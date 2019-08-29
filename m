Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7319A2888
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 22:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfH2U6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 16:58:37 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53624 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbfH2U6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 16:58:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i3RV2-0007J3-97; Thu, 29 Aug 2019 22:58:32 +0200
Date:   Thu, 29 Aug 2019 22:58:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
Message-ID: <20190829205832.GM20113@breakpoint.cc>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
 <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
 <b6585989069fd832a65b73d1c4f4319a10714165.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6585989069fd832a65b73d1c4f4319a10714165.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leonardo Bras <leonardo@linux.ibm.com> wrote:
> On Thu, 2019-08-29 at 17:04 -0300, Leonardo Bras wrote:
> > > Thats a good point -- Leonardo, is the
> > > "net.bridge.bridge-nf-call-ip6tables" sysctl on?
> > 
> > Running
> > # sudo sysctl -a
> > I can see:
> > net.bridge.bridge-nf-call-ip6tables = 1
> 
> Also, doing
> # echo 0 >  /proc/sys/net/bridge/bridge-nf-call-ip6tables 
> And then trying to boot the guest will not crash the host.
> 
> Which would make sense, since host iptables is not dealing with guest
> IPv6 packets.

Yes.

> So, the real cause of this bug is the bridge making host ip6tables deal
> with guest IPv6 packets ? 
> If so, would it be ok if write a patch testing ipv6_mod_enabled()
> before passing guest ipv6 packets to host ip6tables? 

I'm not sure.  This switch is very old, it was added 10 years ago
in v2.6.31-rc1.

Even if we disable call-ip6tables in br_netfilter we will at least
in addition need a patch for nft_fib_netdev.c.

From a "avoid calls to ipv6 stack when its disabled" standpoint,
the safest fix is to disable call-ip6tables functionality if ipv6
module is off *and* fix nft_fib_netdev.c to BREAK in ipv6 is off case.

I started to place a list of suspicous modules here, but that got out
of hand quickly.

So, given I don't want to plaster ipv6_mod_enabled() everywhere, I
would suggest this course of action:

1. add a patch to BREAK in nft_fib_netdev.c for !ipv6_mod_enabled()
2. change net/bridge/br_netfilter_hooks.c, br_nf_pre_routing() to
   make sure ipv6_mod_enabled() is true before doing the ipv6 stack
   "emulation".

Makes sense?

Thanks,
Florian
