Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7822C2BC159
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 19:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgKUSMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 13:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgKUSMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 13:12:30 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCC8C0613CF;
        Sat, 21 Nov 2020 10:12:29 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kgXN0-00C6P4-DV; Sat, 21 Nov 2020 19:12:22 +0100
Message-ID: <bcfb0fe1b207d2f4bb52f0d1ef51207f9b5587de.camel@sipsolutions.net>
Subject: Re: [PATCH v5 2/3] net: add kcov handle to skb extensions
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Florian Westphal <fw@strlen.de>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Aleksandr Nogikh <aleksandrnogikh@gmail.com>,
        davem@davemloft.net, edumazet@google.com, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>
Date:   Sat, 21 Nov 2020 19:12:21 +0100
In-Reply-To: <20201121100636.26aaaf8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
         <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
         <20201121160941.GA485907@shredder.lan>
         <20201121165227.GT15137@breakpoint.cc>
         <20201121100636.26aaaf8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-21 at 10:06 -0800, Jakub Kicinski wrote:
> On Sat, 21 Nov 2020 17:52:27 +0100 Florian Westphal wrote:
> > Ido Schimmel <idosch@idosch.org> wrote:
> > > Other suggestions?  
> > 
> > Aleksandr, why was this made into an skb extension in the first place?
> > 
> > AFAIU this feature is usually always disabled at build time.
> > For debug builds (test farm /debug kernel etc) its always needed.
> > 
> > If thats the case this u64 should be an sk_buff member, not an
> > extension.
> 
> Yeah, in hindsight I should have looked at how it's used. Not a great
> fit for extensions. We can go back, but...
> 
> In general I'm not very happy at how this is going. First of all just
> setting the handle in a couple of allocs seems to not be enough, skbs
> get cloned, reused etc. There were also build problems caused by this
> patch and Aleksandr & co where nowhere to be found. Now we find out
> this causes leaks, how was that not caught by the syzbot it's supposed
> to serve?!

Heh.

> So I'm leaning towards reverting the whole thing. You can attach
> kretprobes and record the information you need in BPF maps.

I'm not going to object to reverting it (and perhaps redoing it better
later), but I will point out that kretprobe isn't going to work, you
eventually need kcov_remote_start() to be called in strategic points
before processing the skb after it bounced through the system.

IOW, it's not really about serving userland, it's about enabling (and
later disabling) coverage collection for the bits of code it cares
about, mostly because collecting it for _everything_ is going to be too
slow and will mess up the data since for coverage guided fuzzing you
really need the reported coverage data to be only about the injected
fuzz data...

johannes

