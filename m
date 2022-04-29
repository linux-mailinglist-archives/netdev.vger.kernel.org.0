Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBB7514F7A
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378441AbiD2PdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346797AbiD2PdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:33:14 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84372D4CB9;
        Fri, 29 Apr 2022 08:29:55 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 23TFTWID012296;
        Fri, 29 Apr 2022 17:29:32 +0200
Date:   Fri, 29 Apr 2022 17:29:32 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 3/7] tcp: resalt the secret every 10 seconds
Message-ID: <20220429152932.GC11224@1wt.eu>
References: <20220428124001.7428-1-w@1wt.eu>
 <20220428124001.7428-4-w@1wt.eu>
 <Ymv4GAezJlA1+Vfs@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymv4GAezJlA1+Vfs@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Fri, Apr 29, 2022 at 04:37:12PM +0200, Jason A. Donenfeld wrote:
> Hi Eric,
> 
> On Thu, Apr 28, 2022 at 02:39:57PM +0200, Willy Tarreau wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > In order to limit the ability for an observer to recognize the source
> > ports sequence used to contact a set of destinations, we should
> > periodically shuffle the secret. 10 seconds looks effective enough
> Nit: "periodically re-salt the input".
> > without causing particular issues.
> 
> Just FYI, moving from siphash_3u32 to siphash_4u32 is not free, as it
> bumps us up from siphash_3u32 to siphash_2u64, which does two more
> siphash rounds. Maybe this doesn't matter much, but just FYI.
> 
> I wonder, though, about your "10 seconds looks effective enough without
> causing particular issues." I surmise from that sentence that a lower
> value might cause particular issues, but that you found 10 seconds to be
> okay in practice. Fine. But what happens if one caller hits this at
> second 9 and the next caller hits it at second 0? In that case, the
> interval might have been 1 second, not 10. In other words, if you need
> a certain minimum quantization for this to not cause "particular
> issues", it might not work the way you wanted it to.

I can partially respond on this one because as you've probably seen at
first I had some reserves on this one, which vanished.

The problem caused by reusing a source port too early almost essentially
concerns clients closing first, either with a regular shutdown() where
a FIN is sent first, or by forcing an RST by disabling lingering / breaking
the association with connect(AF_UNSPEC). In both cases, the risk is that
the packet supposed to finish to close the connection (e.g. last ACK that
turns the socket to TIME_WAIT or the RST) is lost, releasing the local
entry too early and making the client send a SYN from a port that's still
seen as in use on the other side.

For local TIME_WAIT, there's no issue in practice because 1) the port is
not yet usable, and 2) clients closing first cannot sustain high connection
rates anyway, they're limited to #ports/60s.

For those dealing with high connection rates (e.g. proxies) which seldom
have to abort connections, they have no other choice but closing using an
RST to avoid blocking the port in TIME_WAIT. These ones already face the
risk that the RST is lost on the path and that a subsequent SYN from the
same port is delivered to a connection that's in ESTABLISHED or FIN_WAIT
state anyway. This *does* happen due to losses, albeit at quite a low
rate in general. In such cases, the server returns an out-of-window ACK,
the client sends an RST and a SYN again (which roughly looks like a
retransmit as the RST). Such cases may occasionally fail through firewalls
if the RST is lost between the firewall and the server. The firewall will
then block the response ACK from the server and the client will have to
time out on the SYN and try again. This is the current situation even
without the patch (hence why closing with RST must be avoided as much as
possible).

The change of the salting here can slightly increase the risk that this
happens during the transition from the 9th to the 10th second as you said,
and only for the case above. However this will only be a problem if the
SYN arrives before the RST or if the RST is lost. The second case already
exists and the difference is that before the patch, we could have hoped
that the other side would finally have closed on timeout before sending a
new SYN (which is already not granted, e.g. ESTABLISHED) or unlikely to
happen above #ports/60s connections per second (e.g.  FIN_WAIT with a
longer timeout).  The first case (SYN arrives before RST) may happen on
randomly load-balanced links (where TCP already doesn't work well), and
while this does increase the risk, the risk only concerns just a few SYN
packets every 10s which each have a chance over #port of reusing the same
port as the last one, or ~#port/N of reusing the same port as one of the
last N ones for small values of N. This remains extremely low and is not
higher than the risk of losing the RST before the patch anyway.

As such all these risks are very low but they increase as the timer
decreases. This would work well at 60s and could probably still work well
enough at 1s. But 10s is enough to make Amit's attack impractical, so
better not risk to degrade anything. And the tests I ran showed only 2
failed connections after 13 billion closed by the client, which is
perfectly within what I'm used to observe in such cases.

> Additionally, that problem aside, if you round EPHEMERAL_PORT_SHUFFLE_PERIOD
> to the nearest power of two, you can turn the expensive division into a
> bit shift right.

I've been wondering if it would help to use 8 or 16 here, but that doesn't
change anything, it's a constant so it's converted to a reciprocal divide
by the compiler, i.e. just a 32-bit multiply and a shift.

Thanks!
Willy
