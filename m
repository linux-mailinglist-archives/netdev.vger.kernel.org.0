Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EA64AE5C8
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbiBIANO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239326AbiBIANK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:13:10 -0500
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348E8C061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 16:13:09 -0800 (PST)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.64.218])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6ABE81A007E;
        Wed,  9 Feb 2022 00:13:08 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3D89184007D;
        Wed,  9 Feb 2022 00:13:08 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id D4DA913C2B0;
        Tue,  8 Feb 2022 16:13:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com D4DA913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1644365587;
        bh=H6yzabo77K4UKL9GR4S8m6Z805wlouY50TiuZ5uWL28=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=l90NLy9u4WtaQ8+zOQEHWWgaT2yPATuOuzs9sB1QlHYbirkNiT8aO422hbAcjk040
         0+QPLhi/8o/82/AUAv8RAZiK935c/HHd2wTP0sGv0sw+ZeaWZqRxl7yJTDhF+ldacm
         6lPARFV+5DQss4HbrhK+81KyTyzFtHgyNkWS3AC0=
Subject: Re: Question on comment in dev_queue_xmit_nit
From:   Ben Greear <greearb@candelatech.com>
To:     Salam Noureddine <noureddine@arista.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <40bf4696-2c58-f5ba-e81f-46a2a5e7887a@candelatech.com>
Organization: Candela Technologies
Message-ID: <69c0f515-0488-6a8b-be62-5ad0de045af7@candelatech.com>
Date:   Tue, 8 Feb 2022 16:13:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <40bf4696-2c58-f5ba-e81f-46a2a5e7887a@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1644365588-iWmBpTDylxg6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/22 3:51 PM, Ben Greear wrote:
> Hello Salam,
> 
> After an 8 day torture test on a hacked 5.15.7+ kernel doing wifi testing, our system crashed
> in the dev_queue_xmit_nit method, evidently 'skb' is NULL.
> 
> gdb claims it is the 'skb2 = skb_clone ...' line below.  Now, this crash could
> be fault of my local patches or other random things, but the comment caught
> my attention.  It is cloning once per loop as far as I can see, so why the comment
> about 'done only once' ?
> 
>          /* need to clone skb, done only once */
>          skb2 = skb_clone(skb, GFP_ATOMIC);
>          if (!skb2)
>              goto out_unlock;
> 
> Thanks,
> Ben
> 

My question above stands, but I was looking at wrong stack frame for the actual
crash location.  It is actually dying down in slub.c, so I guess it is some nasty
memory corruption and this crash site is probably not actually related to the cause...

(gdb) l *(dev_queue_xmit_nit+0xf4)
0xffffffff819bf4d4 is in dev_queue_xmit_nit (/home2/greearb/git/linux-5.15.dev.y/net/core/dev.c:2305).
2300				pt_prev = ptype;
2301				continue;
2302			}
2303	
2304			/* need to clone skb, done only once */
2305			skb2 = skb_clone(skb, GFP_ATOMIC);
2306			if (!skb2)
2307				goto out_unlock;
2308	
2309			net_timestamp_set(skb2);
(gdb) l *(skb_clone+0x47)
0xffffffff819a9ff7 is in skb_clone (/home2/greearb/git/linux-5.15.dev.y/net/core/skbuff.c:1521).
1516			refcount_set(&fclones->fclone_ref, 2);
1517		} else {
1518			if (skb_pfmemalloc(skb))
1519				gfp_mask |= __GFP_MEMALLOC;
1520	
1521			n = kmem_cache_alloc(skbuff_head_cache, gfp_mask);
1522			if (!n)
1523				return NULL;
1524	
1525			n->fclone = SKB_FCLONE_UNAVAILABLE;
(gdb) l *(kmem_cache_alloc+0x71)
0xffffffff8133b821 is in kmem_cache_alloc (/home2/greearb/git/linux-5.15.dev.y/mm/slub.c:352).
347	}
348	
349	static inline void *get_freepointer(struct kmem_cache *s, void *object)
350	{
351		object = kasan_reset_tag(object);
352		return freelist_dereference(s, object + s->offset);
353	}
354	

Thanks,
Ben
