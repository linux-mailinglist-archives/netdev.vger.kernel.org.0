Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014A654CD28
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351659AbiFOPhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347275AbiFOPhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:37:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBF024BC0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655307437; x=1686843437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pBKbNoK2CfLjoHSNtCS7NJQUrA/9B8lbVbFEj8YMssA=;
  b=Kr0pJ16WTHB4QSBTlCqbTuVPtTis2QJMhxT2DVnICN+0s0M+qJjtffma
   IJA2YYwddDhTRRvXiQwOAqvY33szQjjmC5h4ir2DZ2KCexGEWJ5WtfCK8
   0PznveWf22tdfuiLeQsfj/oc1kZgThBaC6g3NF8JwvPtP7XPd97K1HD7H
   5fIgUn+EE5wI94vWKuzm2PREZkeJFDf1097ZUSsbMW3f5X6p01HyPdPKa
   1P7CXkb/wEpcowM1AFr6Lia301zdkLNCi2Ap9sSf0QUs+KuLViPaMdglq
   CbFha4Hr6KBIVLmLVFQzRmXujA+R1npMO0A7rycDHt39fRP/GuOOA4Dja
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="258856608"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="258856608"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 08:37:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="674560121"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Jun 2022 08:37:15 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25FFbETS012312;
        Wed, 15 Jun 2022 16:37:14 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: don't check skb_count twice
Date:   Wed, 15 Jun 2022 17:35:25 +0200
Message-Id: <20220615153525.1270806-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615032426.17214-1-liew.s.piaw@gmail.com>
References: <20220615032426.17214-1-liew.s.piaw@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sieng Piaw Liew <liew.s.piaw@gmail.com>
Date: Wed, 15 Jun 2022 11:24:26 +0800

> NAPI cache skb_count is being checked twice without condition. Change to
> checking the second time only if the first check is run.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> ---
>  net/core/skbuff.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 5b3559cb1d82..c426adff6d96 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -172,13 +172,14 @@ static struct sk_buff *napi_skb_cache_get(void)
>  	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
>  	struct sk_buff *skb;
>  
> -	if (unlikely(!nc->skb_count))
> +	if (unlikely(!nc->skb_count)) {
>  		nc->skb_count = kmem_cache_alloc_bulk(skbuff_head_cache,
>  						      GFP_ATOMIC,
>  						      NAPI_SKB_CACHE_BULK,
>  						      nc->skb_cache);
> -	if (unlikely(!nc->skb_count))
> -		return NULL;
> +		if (unlikely(!nc->skb_count))
> +			return NULL;
> +	}

I was sure the compilers are able to see that if the condition is
false first time, it will be the second as well. Just curious, have
you consulted objdump/objdiff to look whether anything changed?

Also, please use scripts/get_maintainers.pl or at least git blame
and add the original authors to Ccs next time, so that they won't
miss your changes and will be able to review them in time. E.g. I
noticed this patch only when it did hit the net-next tree already,
as I don't monitor LKML 24/7 (but I do that with my mailbox).

>  
>  	skb = nc->skb_cache[--nc->skb_count];
>  	kasan_unpoison_object_data(skbuff_head_cache, skb);
> -- 
> 2.17.1

Thanks,
Olek
