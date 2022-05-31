Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB1353933E
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 16:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344041AbiEaOmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 10:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiEaOmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 10:42:42 -0400
Received: from m12-12.163.com (m12-12.163.com [220.181.12.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2A683AA4F;
        Tue, 31 May 2022 07:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=aHImv8CecLYVsqxKLx
        3rBrqZ/D2QPjA2ce0QtxRVS6U=; b=EIltXozl2No9vHKMLM/uX+FcLKlsvVmznW
        RpEoePT6laOVkJojJXlZqLXi3QS2HswLuHavgogewG6axocynVEjZNMBdXAPyGxg
        UKBG4NYGScz5X0X48vmWxZzztj3oAacQ/JwFUqvZF+3XEshfF+HP3Sp0Vbswv9zD
        mR7j5nNK8=
Received: from localhost.localdomain (unknown [171.221.150.250])
        by smtp8 (Coremail) with SMTP id DMCowAAnhxMcKZZiLhmEFQ--.38243S2;
        Tue, 31 May 2022 22:41:38 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     kuba@kernel.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Chen Lin <chen45464546@163.com>
Subject: Re:Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is bigger than PAGE_SIZE
Date:   Tue, 31 May 2022 22:41:12 +0800
Message-Id: <1654008072-3136-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20220530122918.549ef054@kernel.org>
References: <20220530122918.549ef054@kernel.org>
X-CM-TRANSID: DMCowAAnhxMcKZZiLhmEFQ--.38243S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF18AF1xGF43Gr1kKw45KFg_yoW8Ww15pr
        WUCFy5ZF45X3Z8CrW8Jrs8Aa4Fy3s3JFWUJayfJas8Zw13JrW0gw1DtrnIvryIkwn2kayI
        vr4jgr45Ca1Yq37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRt5rOUUUUU=
X-Originating-IP: [171.221.150.250]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/1tbiGgISnlaEB7ovCgAAse
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At 2022-05-31 02:29:18, "Jakub Kicinski" <kuba@kernel.org> wrote:
>On Mon, 30 May 2022 12:27:05 -0700 Jakub Kicinski wrote:
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index e008a3df0485..360a545ee5e8 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5537,6 +5537,7 @@ EXPORT_SYMBOL(free_pages);
>>   * sk_buff->head, or to be used in the "frags" portion of skb_shared_info.
>>   */
>>  static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
>> +					     unsigned int fragsz,
>>  					     gfp_t gfp_mask)
>>  {
>>  	struct page *page = NULL;
>> @@ -5549,7 +5550,7 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
>>  				PAGE_FRAG_CACHE_MAX_ORDER);
>>  	nc->size = page ? PAGE_FRAG_CACHE_MAX_SIZE : PAGE_SIZE;
>>  #endif
>> -	if (unlikely(!page))
>> +	if (unlikely(!page && fragsz <= PAGE_SIZE))
>>  		page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
>>  
>>  	nc->va = page ? page_address(page) : NULL;
>> @@ -5576,7 +5577,7 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
>>  
>>  	if (unlikely(!nc->va)) {
>>  refill:
>> -		page = __page_frag_cache_refill(nc, gfp_mask);
>> +		page = __page_frag_cache_refill(nc, fragsz, gfp_mask);
>>  		if (!page)
>>  			return NULL;
>
>Oh, well, the reuse also needs an update. We can slap a similar
>condition next to the pfmemalloc check.

The sample code above cannot completely solve the current problem.
For example, when fragsz is greater than PAGE_FRAG_CACHE_MAX_SIZE(32768),
__page_frag_cache_refill will return a memory of only 32768 bytes, so 
should we continue to expand the PAGE_FRAG_CACHE_MAX_SIZE? Maybe more 
work needs to be done

