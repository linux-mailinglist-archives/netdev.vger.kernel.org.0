Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AEB546BC5
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345038AbiFJRmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346863AbiFJRmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:42:11 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A5E155226
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:42:05 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 25AHg1Nr020088;
        Fri, 10 Jun 2022 19:42:01 +0200
Date:   Fri, 10 Jun 2022 19:42:01 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Ronny Meeus <ronny.meeus@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: TCP socket send return EAGAIN unexpectedly when sending small
 fragments
Message-ID: <20220610174201.GC19540@1wt.eu>
References: <CAMJ=MEcPzkBLynL7tpjdv0TCRA=Cmy13e7wmFXrr-+dOVcshKA@mail.gmail.com>
 <f0f30591-f503-ae7c-9293-35cca4ceec84@gmail.com>
 <CAMJ=MEdctBNSihixym1ZO9RVaCa_FpTQ8e4xFukz3eN8F1P8bQ@mail.gmail.com>
 <0e02ea2593204cd9805c6ed4b7f46c98@AcuMS.aculab.com>
 <CAMJ=MEe3r+ZrAONTciQgU4yqtXTJJvXc0OFvJYwYg20kPGQtdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMJ=MEe3r+ZrAONTciQgU4yqtXTJJvXc0OFvJYwYg20kPGQtdA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 07:16:06PM +0200, Ronny Meeus wrote:
> Op vr 10 jun. 2022 om 17:21 schreef David Laight <David.Laight@aculab.com>:
> >
> > ...
> > > If the 5 queued packets on the sending side would cause the EAGAIN
> > > issue, the real question maybe is why the receiving side is not
> > > sending the ACK within the 10ms while for earlier messages the ACK is
> > > sent much sooner.
> >
> > Have you disabled Nagle (TCP_NODELAY) ?
> 
> Yes I enabled TCP_NODELAY so the Nagle algo is disabled.
> I did a lot of tests over the last couple of days but if I remember well
> enable or disable TCP_NODELAY does not influence the result.

There are many possible causes for what you're observing. For example
if your NIC has too small a tx ring and small buffers, you can imagine
that the Nx106 bytes fit in the buffers but not the N*107, which cause
a tiny delay waiting for the Tx IRQ to recycle the buffers, and that
during this time your subsequent send() are coalesced into larger
segments that are sent at once when using 107.

If you do not want packets to be sent individually and you know you
still have more to come, you need to put MSG_MORE on the send() flags
(or to disable TCP_NODELAY).

Clearly, when running with TCP_NODELAY you're asking the whole stack
"do your best to send as fast as possible", which implies "without any
consideration for efficiency optimization". I've seen a situation in the
past where it was impossible to send any extra segment after a first
unacked PUSH was in flight. Simply sending full segments was enough to
considerably increase the performance. I analysed this as a result of
the SWS avoidance algorithm and concluded that it was normal in that
situation, though I've not witnessed it anymore in a while.

So just keep in mind to try not to abuse TCP_NODELAY too much.

Willy
