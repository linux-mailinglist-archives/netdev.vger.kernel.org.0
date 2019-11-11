Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7EE7F788D
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfKKQQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:16:20 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:47102 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbfKKQQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 11:16:20 -0500
Received: by mail-pl1-f193.google.com with SMTP id l4so7954407plt.13
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 08:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=LRGUHuSJyKt/Z3DISNg0Dy5VULQ/e9Yz4ic2kn/8iZw=;
        b=p1IpGaLrmAbnQ0jULxNYnRybSmaZ2Ry+N5lY36XIV1OHoQ4ayuUb3C4TPhhdeNXBkI
         amvAFSHEFoDZyjuWu0M2x91zs1nf/JJiIYcU1vGRj4BHt250N15v36in/D//Raoik6g1
         l6soHhrceonJZNCfbKH1YL9ZWqPN4nSH5alTOG0R59OYwKehHyYMHHSgWiCDjYgSMhc3
         GnRL0Y3K6Dw6OVu71wED3xNR6keaSQR+WEH4QpUHqoFB3js1O132Uc/eh0Qs0xx6LT0m
         B2bve55jN9sls8Epq71jlvXlbU1iO6giiVd6t1lPWkUHO7WwHB4ZZx1TQjBV3rTO631i
         xy/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=LRGUHuSJyKt/Z3DISNg0Dy5VULQ/e9Yz4ic2kn/8iZw=;
        b=CJMqIJY9aggIOdLTzhadNWnYc3KX412y55cLpk0Fk0+toL2lUdAx9B2nf8z+WacUcN
         xuwArtcNFKYMWWNtIJamu7Bnca02uyIAI2oN1mtl25oBhTFNsbaF26kShLQFFBnYHZWs
         N/hHQsJ76+gs5xpjEpsCG2Oy0eqjXCV8yh4smqx4m4nTkFDhQDm3G8BacOOBB5T0ONQ9
         K3QzhbBjteFGTW1T61+Xqe52T0BWyuSR+gUNm3ZJySgJxk/dRree3Rc5vbE6B+2TuU4E
         mWeWiC9cNqumz0yiwLXpYnZBfrox7jROCBMwTID62OQ7oL4hWIFnBGItPWL+iSjAc+ie
         rEnQ==
X-Gm-Message-State: APjAAAUwgPNDfbxhGktz6U5oGr94Ngl0JjR7vzZw9T7FyxPLwCV4/lTW
        moXjTRBY/c1mspxsN2hbh/c=
X-Google-Smtp-Source: APXvYqy/r5SaTfUC0UjeZHq+b/3lUxaiq7JPeJDH2UrWCN5CvV7KO4gmiH7BodsJx6jhQ1Vo0xB8UQ==
X-Received: by 2002:a17:902:b482:: with SMTP id y2mr17971420plr.128.1573488979134;
        Mon, 11 Nov 2019 08:16:19 -0800 (PST)
Received: from [172.26.105.13] ([2620:10d:c090:180::94b6])
        by smtp.gmail.com with ESMTPSA id s18sm16709317pfm.27.2019.11.11.08.16.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 08:16:18 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        kernel-team@fb.com
Subject: Re: [RFC PATCH 1/1] page_pool: do not release pool until inflight ==
 0.
Date:   Mon, 11 Nov 2019 08:16:17 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <ED29D781-92F0-494B-A28E-BB6319FC3FF7@gmail.com>
In-Reply-To: <20191111102104.1ac9620d@carbon>
References: <20191111062038.2336521-1-jonathan.lemon@gmail.com>
 <20191111062038.2336521-2-jonathan.lemon@gmail.com>
 <20191111102104.1ac9620d@carbon>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11 Nov 2019, at 1:21, Jesper Dangaard Brouer wrote:

> On Sun, 10 Nov 2019 22:20:38 -0800
> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 20781ad5f9c3..e334fad0a6b8 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -70,25 +70,47 @@ static void __xdp_mem_allocator_rcu_free(struct 
>> rcu_head *rcu)
>>
>>  	xa = container_of(rcu, struct xdp_mem_allocator, rcu);
>>
>> -	/* Allocator have indicated safe to remove before this is called */
>> -	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
>> -		page_pool_free(xa->page_pool);
>> -
>>  	/* Allow this ID to be reused */
>>  	ida_simple_remove(&mem_id_pool, xa->mem.id);
>>
>> -	/* Poison memory */
>> -	xa->mem.id = 0xFFFF;
>> -	xa->mem.type = 0xF0F0;
>> -	xa->allocator = (void *)0xDEAD9001;
>> -
>>  	kfree(xa);
>>  }
>
> Can you PLEASE leave the memory poisonings that I have added alone.
> Removing these are irrelevant for current patch. You clearly don't 
> like
> this approach, but I've also clearly told that I disagree.  I'm the
> maintainer of this code and I prefer letting them stay. I'm the one
> that signed up for dealing with hard to find bugs in the code.

As you're the maintainer, I'll put this back.  However, I strongly
feel that this is poor practice; detecting use-after-free in cases
like this should be the job of the page and memory allocator; not
kmemleak (which detects lost memory), but page poisoning and redzone
support.

If this is really useful, it should specifically be under DEBUG
support, rather than in the mainline code.  It's not a performance
issue - just more techdebt, from my POV.
-- 
Jonathan
