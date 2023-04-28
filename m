Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CBE6F15EE
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 12:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345549AbjD1KnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 06:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjD1KnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 06:43:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891C4E48
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 03:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682678556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8VYz7vHN/SQLKQpJ6o5rJHep+Bs09jf1B3PVMTcCTDA=;
        b=DFHDNo3atVVJJY+yTZRi4qOgs7DA3PCISOzqInbVphNCmD2GO6HHkrdFIaPXXt4vsTS1VK
        fsH6kk0iy/tCCy/Q7rIx05Ck+nZQ3gAnnIa3yNFyzgTs7q0A5V2N60naqzwgZKabzau/WC
        DrSxS1Tlf+/pZUIQQAGDry83YK4o5dY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-ffnBFJfeMiyf7ZGnoG3iLg-1; Fri, 28 Apr 2023 06:42:35 -0400
X-MC-Unique: ffnBFJfeMiyf7ZGnoG3iLg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a35b0d4ceso951635566b.3
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 03:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682678554; x=1685270554;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8VYz7vHN/SQLKQpJ6o5rJHep+Bs09jf1B3PVMTcCTDA=;
        b=O+9EjtGKBEpjzFdcSE+DLFs+U+bgFnd9vYhtvn3nc3u8nH/WhQtkDnHnr6lpgbwruH
         +QNZgvJ4jcwdI/zCu3c9GO/UvkuXBVryrslbiMxTVxQRYyeVqqw30fSJn8CHDkkPteXK
         iAxVIMMR3GQYrt16v9yC6hAeXFTL7XkyYs1rXpISUOuLu7k9GKIgwq8fEt5s1IG3dn2/
         5JF3wSLHsvVMkzmGgZAq2iSmSZdWXQh8YQm5E6ZcvupvMiWVSWq0WsSPFu3yetcx31J5
         rRi519WZOdtXaMZx1vOnOpJMG/AIN88uU5YUO9oNSMenPMITUMRMy5hz94cizyFNEm6g
         XXZg==
X-Gm-Message-State: AC+VfDw6HGM4aR4miiPzhWdAeddkX/ck1Aj35zVDhJhG8d4elLjYakWK
        pV7IhNyLGT+aMIV1h6KDhbX2HZH22QhLaegC3eR2MTcXDK0Er5xtLxPC7FXVJa1BnNvTwwDbYCP
        rDWPB5dE/HSaZaBQA
X-Received: by 2002:a17:907:60cc:b0:94e:4735:92f8 with SMTP id hv12-20020a17090760cc00b0094e473592f8mr4630899ejc.27.1682678554534;
        Fri, 28 Apr 2023 03:42:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5RLIFDV7DqMfmu8vI6PEQwNYJoJcGV2dXRsB7+yLFdggKUBAXB+Ox+W/QR/EHGWW7JUWzbOQ==
X-Received: by 2002:a17:907:60cc:b0:94e:4735:92f8 with SMTP id hv12-20020a17090760cc00b0094e473592f8mr4630872ejc.27.1682678554124;
        Fri, 28 Apr 2023 03:42:34 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id 28-20020a170906225c00b0094ee88207d5sm10921484ejr.191.2023.04.28.03.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 03:42:33 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <4eab92af-251a-a9aa-e270-179634d0345b@redhat.com>
Date:   Fri, 28 Apr 2023 12:42:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Cc:     brouer@redhat.com, lorenzo@kernel.org, linyunsheng@huawei.com,
        bpf@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V2 1/2] page_pool: Remove workqueue in new
 shutdown scheme
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>
References: <168262348084.2036355.16294550378793036683.stgit@firesoul>
 <168262351129.2036355.1136491155595493268.stgit@firesoul>
 <871qk582tn.fsf@toke.dk>
In-Reply-To: <871qk582tn.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/04/2023 22.53, Toke Høiland-Jørgensen wrote:
>> +noinline
>>   static void page_pool_empty_ring(struct page_pool *pool)
>>   {
>>   	struct page *page;
>> @@ -796,39 +828,29 @@ static void page_pool_scrub(struct page_pool *pool)
>>   	page_pool_empty_ring(pool);
>>   }
> So this is not in the diff context, but page_pool_empty_ring() does
> this:
> 
> static void page_pool_empty_ring(struct page_pool *pool)
> {
> 	struct page *page;
> 
> 	/* Empty recycle ring */
> 	while ((page = ptr_ring_consume_bh(&pool->ring))) {
> 		/* Verify the refcnt invariant of cached pages */
> 		if (!(page_ref_count(page) == 1))
> 			pr_crit("%s() page_pool refcnt %d violation\n",
> 				__func__, page_ref_count(page));
> 
> 		page_pool_return_page(pool, page);
> 	}
> }
> 
> ...and with this patch, that page_pool_return_page() call will now free
> the pool memory entirely when the last page is returned. When it does
> this, the condition in the while loop will still execute afterwards; it
> would return false, but if the pool was freed, it's now referencing
> freed memory when trying to read from pool->ring.

Yes, that sounds like a problem.

> So I think page_pool_empty_ring needs to either pull out all the pages
> in the ring to an on-stack buffer before calling page_pool_return_page()
> on them, or there needs to be some other way to break the loop early.

Let me address this one first, I'll get back to the other in another
reply.  The usual/idiom way of doing this is to have a next pointer that
is populated inside the loop before freeing the object.
It should look like this (only compile tested):

  static void page_pool_empty_ring(struct page_pool *pool)
  {
	struct page *page, *next;

	next = ptr_ring_consume_bh(&pool->ring);

	/* Empty recycle ring */
	while (next) {
		page = next;
		next = ptr_ring_consume_bh(&pool->ring);

		/* Verify the refcnt invariant of cached pages */
		if (!(page_ref_count(page) == 1))
			pr_crit("%s() page_pool refcnt %d violation\n",
				__func__, page_ref_count(page));

		page_pool_return_page(pool, page);
	}
  }


> There are a couple of other places where page_pool_return_page() is
> called in a loop where the loop variable lives inside struct page_pool,
> so we need to be absolutely sure they will never be called in the
> shutdown stage, or they'll have to be fixed as well.

The other loops are okay, but I spotted another problem in 
__page_pool_put_page() in "Fallback/non-XDP mode", but that is fixable.

--Jesper

