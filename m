Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4352C3D8590
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 03:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhG1Bny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 21:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhG1Bnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 21:43:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25A3C061757;
        Tue, 27 Jul 2021 18:43:52 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1m8Ybr-0004uE-19; Wed, 28 Jul 2021 03:43:47 +0200
Date:   Wed, 28 Jul 2021 03:43:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Alex Forster <aforster@cloudflare.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        Kyle Bowman <kbowman@cloudflare.com>,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [netfilter-core] [PATCH] netfilter: xt_NFLOG: allow 128
 character log prefixes
Message-ID: <20210728014347.GM3673@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Alex Forster <aforster@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        Kyle Bowman <kbowman@cloudflare.com>, linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210727190001.914-1-kbowman@cloudflare.com>
 <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia>
 <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
 <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jul 27, 2021 at 05:45:09PM -0500, Alex Forster via netfilter-core wrote:
> > Yes, you can update iptables-nft to use nft_log instead of xt_LOG,
> > that requires no kernel upgrades and it will work with older kernels.
> 
> I've always been under the impression that mixing xtables and nftables
> was impossible. Forgive me, but I just want to clarify one more time:
> you're saying we should be able to modify iptables-nft such that the
> following rule will use xt_bpf to match a packet and then nft_log to
> log it, rather than xt_log as it does today?

iptables-nft is free to use either xtables extensions or native nftables
expressions and it may mix them within the same rule. Internally, this
is all nftables but calling xtables extensions via a compat expression.

You might want to check iptables commit ccf154d7420c0 ("xtables: Don't
use native nftables comments") for reference, it does the opposite of
what you want to do.

>     iptables-nft -A test-chain -d 11.22.33.44/32 -m bpf --bytecode
> "1,6 0 0 65536" -j NFLOG --nflog-prefix
> "0123456789012345678901234567890123456789012345678901234567890123456789"

Keep in mind though, you may end with rulesets an older iptables(-nft)
will reject. I've seen people running into such compat issues when using
containers for things they shouldn't, but that's a different story.

> We had some unexplained performance loss when we were evaluating
> switching to iptables-nft, but if this sort of mixing is possible then
> it is certainly worth reevaluating.

There were some significant performance improvements in the near past.
Repeating the check might yield better results in this aspect, too.

Cheers, Phil
