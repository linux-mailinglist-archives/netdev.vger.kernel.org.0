Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D9066B08F
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 12:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjAOLUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 06:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjAOLUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 06:20:34 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E42F74C
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 03:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673781633; x=1705317633;
  h=references:from:to:cc:date:in-reply-to:message-id:
   mime-version:subject;
  bh=lN7D4Cqok9W2URLE4i2D8VpyfdXBM6+t+aiHuYVZoJo=;
  b=Y0Ku4vBn3ZOmwE85gm8K2hEVzmQyueEnfJFVyKD+l7hU5yNJizHvOLXP
   iXWIu7AxWxK2ddUSIZt22nsVAWjoNhgqzdcZTOCqbwMiWrmEp/AR5UcVZ
   RgENRyL8h95cAnmoQOBRnlS5sB2IMcH8udgyEU5+fYTSpOWdJpavi9SH6
   U=;
X-IronPort-AV: E=Sophos;i="5.97,218,1669075200"; 
   d="scan'208";a="1092789605"
Subject: Re: [PATCH v3 08/26] page_pool: Convert pp_alloc_cache to contain netmem
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2023 11:20:28 +0000
Received: from EX13D50EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id A8CCB432A6;
        Sun, 15 Jan 2023 11:20:24 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D50EUB003.ant.amazon.com (10.43.166.146) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Sun, 15 Jan 2023 11:20:24 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.160.120) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Sun, 15 Jan 2023 11:20:20 +0000
References: <20230111042214.907030-1-willy@infradead.org>
 <20230111042214.907030-9-willy@infradead.org>
 <pj41zlwn5p1eom.fsf@u570694869fb251.ant.amazon.com>
 <Y8LtYEfdrN+cWiVm@casper.infradead.org>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Sun, 15 Jan 2023 13:03:41 +0200
In-Reply-To: <Y8LtYEfdrN+cWiVm@casper.infradead.org>
Message-ID: <pj41zlo7r011u8.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D35UWC002.ant.amazon.com (10.43.162.218) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Matthew Wilcox <willy@infradead.org> writes:

> CAUTION: This email originated from outside of the 
> organization. Do not click links or open attachments unless you 
> can confirm the sender and know the content is safe.
>
>
>
> On Sat, Jan 14, 2023 at 02:28:50PM +0200, Shay Agroskin wrote:
>> >     memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
>> >     nr_pages = alloc_pages_bulk_array_node(gfp, pool->p.nid, 
>> >     bulk,
>> > - 
>> > pool->alloc.cache);
>> > +                                   (struct page 
>> > **)pool->alloc.cache);
>>
>> Can you fix the alignment here (so that the '(struct page **)' 
>> would align
>> the the 'gfp' argument one line above) ?
>
> No, that makes the line too long.

Couldn't find any word about inlining in the coding style. AFAIK 
82 characters line is considered ok (and the file you're editing 
has even longer lines than that). To me it'd look better aligned, 
but suit yourself
