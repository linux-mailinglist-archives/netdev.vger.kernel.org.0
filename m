Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6338C27F020
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbgI3RRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:17:16 -0400
Received: from mg.ssi.bg ([178.16.128.9]:56430 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731507AbgI3RRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 13:17:09 -0400
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 818C7C944;
        Wed, 30 Sep 2020 20:17:06 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id E84D5C8B4;
        Wed, 30 Sep 2020 20:17:03 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 9E01C3C09D9;
        Wed, 30 Sep 2020 20:17:03 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 08UHH2c6005100;
        Wed, 30 Sep 2020 20:17:02 +0300
Date:   Wed, 30 Sep 2020 20:17:02 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        abt-admin@mail.ru
Subject: Re: Fw: [Bug 209427] New: Incorrect timestamp cause packet to be
 dropped
In-Reply-To: <8e1a8be5-4123-ea86-80f2-16027cfa021c@gmail.com>
Message-ID: <alpine.LFD.2.23.451.2009302010190.4321@ja.home.ssi.bg>
References: <20200929103532.0ecbc3b3@hermes.local> <8e1a8be5-4123-ea86-80f2-16027cfa021c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 30 Sep 2020, Eric Dumazet wrote:

> On 9/29/20 7:35 PM, Stephen Hemminger wrote:
> > 
> > 
> > then I noticed that in some cases skb->tstamp is equal to real ts whereas in
> > the regular cases where a packet pass through it's time since kernel boot. This
> > doesn't make any sense for me as this condition is satisfied constantly
> > 
> > net/sched/sch_fq.c:439
> > static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
> >                                     const struct fq_sched_data *q)
> > {
> >         return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
> > }
> > 
> > Any ideas on what it can be?
> > 
> Thanks for the detailed report !
> 
> I suspect ipvs or bridge code needs something similar to the fixes done in 
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=de20900fbe1c4fd36de25a7a5a43223254ecf0d0
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=41d1c8839e5f8cb781cc635f12791decee8271b7
> 
> The reason for that is that skb->tstamp can get a timestamp in input path,
> with a base which is not CLOCK_MONOTONIC, unfortunately.
> 
> Whenever a packet is forwarded, its tstamp must be cleared.
> 
> Can you try :
> 
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index b00866d777fe0e9ed8018087ebc664c56f29b5c9..11e8ccdae358a89067046efa62ed40308b9e06f9 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -952,6 +952,8 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int skb_af,
>  
>         ip_vs_drop_early_demux_sk(skb);
>  
> +       skb->tstamp = 0;
> +

	Should be after all skb_forward_csum() calls in ip_vs_xmit.c

>         if (skb_headroom(skb) < max_headroom || skb_cloned(skb)) {
>                 new_skb = skb_realloc_headroom(skb, max_headroom);
>                 if (!new_skb)

Regards

--
Julian Anastasov <ja@ssi.bg>

