Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADBC2EF77F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbhAHSgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:36:19 -0500
Received: from mga04.intel.com ([192.55.52.120]:15177 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbhAHSgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 13:36:19 -0500
IronPort-SDR: IukN8uvVglOeesaNrO1u2Anndnd5cpN9bOnXon0YLjfhR+b8k5MiUheV1rr0fyMQ9ezrMVyRqd
 W9k6sZ4UYdgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="175061297"
X-IronPort-AV: E=Sophos;i="5.79,332,1602572400"; 
   d="scan'208";a="175061297"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 10:35:38 -0800
IronPort-SDR: o8bS21OClYQAd0KB7U06eFITSFA+f0yhrO24xDbHK075rPQ4Oe9es/nOq8F8MinuDxkiX2v8YG
 Bh2TOiMG+UWQ==
X-IronPort-AV: E=Sophos;i="5.79,332,1602572400"; 
   d="scan'208";a="399064663"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.68.23])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 10:35:38 -0800
Date:   Fri, 8 Jan 2021 10:35:37 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, intel-wired-lan@lists.osuosl.org,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next v1 1/2] net: core: count drops from GRO
Message-ID: <20210108103537.00005168@intel.com>
In-Reply-To: <CANn89iLcRrmXW_MGjuMMnNxWS+kaEnY=Y79hCPuiwiDd_G9=EA@mail.gmail.com>
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
        <20210106215539.2103688-2-jesse.brandeburg@intel.com>
        <CANn89iLcRrmXW_MGjuMMnNxWS+kaEnY=Y79hCPuiwiDd_G9=EA@mail.gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6071,6 +6071,7 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
> >                 break;
> >
> >         case GRO_DROP:
> > +               atomic_long_inc(&skb->dev->rx_dropped);
> >                 kfree_skb(skb);
> >                 break;
> >
> > @@ -6159,6 +6160,7 @@ static gro_result_t napi_frags_finish(struct napi_struct *napi,
> >                 break;
> >
> >         case GRO_DROP:
> > +               atomic_long_inc(&skb->dev->rx_dropped);
> >                 napi_reuse_skb(napi, skb);
> >                 break;
> >
> 
> 
> This is not needed. I think we should clean up ice instead.

My patch 2 already did that. I was trying to address the fact that I'm
*actually seeing* GRO_DROP return codes coming back from stack.

I'll try to reproduce that issue again that I saw. Maybe modern kernels
don't have the problem as frequently or at all.

> Drivers are supposed to have allocated the skb (using
> napi_get_frags()) before calling napi_gro_frags()

ice doesn't use napi_get_frags/napi_gro_frags, so I'm not sure how this
is relevant. 

> Only napi_gro_frags() would return GRO_DROP, but we supposedly could
> crash at that point, since a driver is clearly buggy.

seems unlikely since we don't call those functions.
 
> We probably can remove GRO_DROP completely, assuming lazy drivers are fixed.

This might be ok, but doesn't explain why I was seeing this return
code (which was the whole reason I was trying to count them), however I
may have been running on a distro kernel from redhat/centos 8 when I
was seeing these events. I haven't fully completed spelunking all the
different sources, but might be able to follow down the rabbit hole
further.

 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8fa739259041aaa03585b5a7b8ebce862f4b7d1d..c9460c9597f1de51957fdcfc7a64ca45bce5af7c
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6223,9 +6223,6 @@ gro_result_t napi_gro_frags(struct napi_struct *napi)
>         gro_result_t ret;
>         struct sk_buff *skb = napi_frags_skb(napi);
> 
> -       if (!skb)
> -               return GRO_DROP;
> -
>         trace_napi_gro_frags_entry(skb);
> 
>         ret = napi_frags_finish(napi, skb, dev_gro_receive(napi, skb));

This change (noted from your other patches is fine), and a likely
improvement, thanks for sending those!
