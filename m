Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A86E6C1838
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjCTPWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjCTPVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:21:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D39118AB4;
        Mon, 20 Mar 2023 08:15:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A1FC221AAD;
        Mon, 20 Mar 2023 15:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679325290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uLZs4PB9+G025pPf5iXZq69Oo8p6DwoTDJ9FIB3DakA=;
        b=dyfo88zYl6Yg5zwB//QpN0nOKP+K1umn0wM32BDTTjYeqCJ5p9Lw2jOa3SK4qiWcMcrwlj
        Fy6X5H1yeX38+Va2dUprUcfbeFAEtq8A9KSvKaJDEgyOlLaxVyisCGZWnvVy2frIv5Mm+q
        gDYPobFxbx1LkmjqgawM9lxRqlfRiho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679325290;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uLZs4PB9+G025pPf5iXZq69Oo8p6DwoTDJ9FIB3DakA=;
        b=+sFPLg9Lj4GgT1NOz/fE/eXtrZorlXjvebBjXnJtiJxzsB8z3hapyRq41TxCT4rp0QOXBH
        spDHqXlbU7W1nbCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 88EC513A00;
        Mon, 20 Mar 2023 15:14:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6mHdIGp4GGTcPgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 20 Mar 2023 15:14:50 +0000
Message-ID: <7b2a7b7b-0ebc-1f03-5f1b-ac598fc950dc@suse.cz>
Date:   Mon, 20 Mar 2023 16:14:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [net PATCH 1/2] mm: Use fixed constant in page_frag_alloc instead
 of size + 1
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org, jannh@google.com
References: <20190215223741.16881.84864.stgit@localhost.localdomain>
 <20190215224412.16881.89296.stgit@localhost.localdomain>
 <d68edefb-4930-a9cf-1150-9bd2a2a9a02f@suse.cz>
In-Reply-To: <d68edefb-4930-a9cf-1150-9bd2a2a9a02f@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 10:30, Vlastimil Babka wrote:
> On 2/15/19 23:44, Alexander Duyck wrote:
>> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>> 
>> This patch replaces the size + 1 value introduced with the recent fix for 1
>> byte allocs with a constant value.
>> 
>> The idea here is to reduce code overhead as the previous logic would have
>> to read size into a register, then increment it, and write it back to
>> whatever field was being used. By using a constant we can avoid those
>> memory reads and arithmetic operations in favor of just encoding the
>> maximum value into the operation itself.
>> 
>> Fixes: 2c2ade81741c ("mm: page_alloc: fix ref bias in page_frag_alloc() for 1-byte allocs")
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>> ---
>>  mm/page_alloc.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index ebb35e4d0d90..37ed14ad0b59 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4857,11 +4857,11 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>>  		/* Even if we own the page, we do not use atomic_set().
>>  		 * This would break get_page_unless_zero() users.
>>  		 */
>> -		page_ref_add(page, size);
>> +		page_ref_add(page, PAGE_FRAG_CACHE_MAX_SIZE);
> 
> But this value can be theoretically too low when PAGE_SIZE >
> PAGE_FRAG_CACHE_MAX_SIZE? Such as on architectures with 64kB page size,
> while PAGE_FRAG_CACHE_MAX_SIZE is 32kB?

Nevermind, PAGE_FRAG_CACHE_MAX_SIZE would be 64kB because

#define PAGE_FRAG_CACHE_MAX_SIZE        __ALIGN_MASK(32768, ~PAGE_MASK)

So all is fine, sorry for the noise.

