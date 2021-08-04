Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547CE3E08DB
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 21:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbhHDT3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 15:29:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:65250 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240666AbhHDT3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 15:29:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="214024778"
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="214024778"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 12:29:21 -0700
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="668201308"
Received: from mmlucas-mobl1.amr.corp.intel.com ([10.212.169.140])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 12:29:20 -0700
Date:   Wed, 4 Aug 2021 12:29:20 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: fix GRO skb truesize update
In-Reply-To: <9134e63fd0d42787e4fbd4bd890d330d6fda9f81.1628097645.git.pabeni@redhat.com>
Message-ID: <5d4fb1de-7cef-b1fd-7513-27da5793f99@linux.intel.com>
References: <9134e63fd0d42787e4fbd4bd890d330d6fda9f81.1628097645.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Aug 2021, Paolo Abeni wrote:

> commit 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb carring sock
> reference") introduces a serious regression at the GRO layer setting
> the wrong truesize for stolen-head skbs.
>
> Restore the correct truesize: SKB_DATA_ALIGN(...) instead of
> SKB_TRUESIZE(...)
>
> Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Fixes: 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb carring sock reference")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

With this patch I'm no longer seeing the WARN_ON_ONCE() fire in 
skb_try_coalesce(). Thanks Paolo!

Tested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

> ---
> net/core/skbuff.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 97ed77a86bb0..02a603556408 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4375,7 +4375,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> 		memcpy(frag + 1, skbinfo->frags, sizeof(*frag) * skbinfo->nr_frags);
> 		/* We dont need to clear skbinfo->nr_frags here */
>
> -		new_truesize = SKB_TRUESIZE(sizeof(struct sk_buff));
> +		new_truesize = SKB_DATA_ALIGN(sizeof(struct sk_buff));
> 		delta_truesize = skb->truesize - new_truesize;
> 		skb->truesize = new_truesize;
> 		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE_STOLEN_HEAD;
> --

--
Mat Martineau
Intel
