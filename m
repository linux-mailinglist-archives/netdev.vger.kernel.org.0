Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952E06679E1
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239662AbjALPxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240312AbjALPwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:52:47 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F89C1123
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673538063; x=1705074063;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=oUK2ACBDt68b8+5N1drGEA/zCC5P130zN9Q9P8hW2Zw=;
  b=j4BN6L/N3sPjSzmfIe3uGv9XffjuK+egVCWYrhDcriF2kriImcB+xrCN
   moupfCQp1X1iZ+zS8xSn+R0hLuiNbsZH1hYZue1Hhe7w/8+d8jbgywRhH
   jT2NYZkgkRu05NLrpiJ+uXirug6saZkveVGtujCGsULGQ6WKXl6/oi2eH
   g=;
X-IronPort-AV: E=Sophos;i="5.97,211,1669075200"; 
   d="scan'208";a="170568498"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 15:40:57 +0000
Received: from EX13D46EUB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 21A3882414;
        Thu, 12 Jan 2023 15:40:56 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D46EUB002.ant.amazon.com (10.43.166.241) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 12 Jan 2023 15:40:54 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.162.56) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Thu, 12 Jan 2023 15:40:51 +0000
References: <20230111042214.907030-1-willy@infradead.org>
 <20230111042214.907030-6-willy@infradead.org>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 05/26] page_pool: Start using netmem in allocation path.
Date:   Thu, 12 Jan 2023 17:36:58 +0200
In-Reply-To: <20230111042214.907030-6-willy@infradead.org>
Message-ID: <pj41zlpmbjn4ld.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D39UWB003.ant.amazon.com (10.43.161.215) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


"Matthew Wilcox (Oracle)" <willy@infradead.org> writes:

> Convert __page_pool_alloc_page_order() and 
> __page_pool_alloc_pages_slow()
> ...
>  TRACE_EVENT(page_pool_update_nid,
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 437241aba5a7..4e985502c569 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> ...
>  
> @@ -421,7 +422,8 @@ static struct page 
> *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  		page = NULL;
>  	}
>  
> -	/* When page just alloc'ed is should/must have refcnt 
> 1. */
> +	/* When page just allocated it should have refcnt 1 (but 
> may have
> +	 * speculative references) */

Sorry for the pity comment, but the comment style here is 
inconsistent
https://www.kernel.org/doc/html/v4.11/process/coding-style.html#commenting

You should have the last '*/' to be on its own line
(again sorry for not giving more useful feedback... then again, 
it's a rather simply fix (: )

Shay

>  	return page;
>  }

