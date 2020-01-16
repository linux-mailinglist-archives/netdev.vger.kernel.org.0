Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3A213DE78
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 16:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgAPPTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 10:19:07 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52032 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgAPPTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 10:19:07 -0500
Received: by mail-pj1-f67.google.com with SMTP id d15so1665680pjw.1;
        Thu, 16 Jan 2020 07:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gv/c4WmqGfA4FwM+VUnPA6bgCeuDGypbQgWIA5eSdW4=;
        b=BdnC5X2ejkNu6VgzVywx16V1MICoF+R7x5yXvrxhs7+K4demvgdXAocEzXP9dNN6tf
         ALngM0W3ucKlEPjA7RGYNqdUiwrkXVa8/9WO7kukDQicGPWFqPI4lc4hhwQ8kxPWkeTA
         uii4HQEyjtbDY0ca0MsBV6F/H3eQUS8xY0jLnQxn4U6MKtOlbY+mE+P67VziGut5c2bW
         oDzRiZtHaYAPl8KfLtuTHnD5LGAm6bDc9wP1G6Innf7Q0kgyz7SIKOS/mB/xX6glorIE
         zuPxvXwvYL7okIrTR2KM8zVHY+bOlVyU7FMYJGdqS/BAdbdJXAv2yORk2D3QZkTtFC5t
         D9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gv/c4WmqGfA4FwM+VUnPA6bgCeuDGypbQgWIA5eSdW4=;
        b=Sxx8EgpQvmtNOnBdh9QmtwyFGhs7pmR9v+EbI+sZ8mBovwZkoSjyf/hLVT+UMvxZT3
         AGtgNYdu15X1trB0Ega3uSs5ZgMp00XYZ83G+iiO0bT/5cQ4axCDseK4esajY93Xybpy
         WyZY+R+UGyUwt6ScX+Bb2SHnKtiKEWhosQcesvWL9wonFgP24zEDRwcMv2QbRrN4oHtx
         jDxTQQUoGIxr7sul2DnPLsbfQQJlgBOy+BGossV2c7G9CsD9vxngEmmTpYopUzGiU4Br
         0FH5Aozw8Re4iRIOEJR/YvhRMoz3a/g8YuyD+6847Li4YpniV5LZO8TWRW5Wk6xUm0Km
         zv8Q==
X-Gm-Message-State: APjAAAUJE8lZOfFS6f8crA6eTM4ibqRjjGpd/VO+lZtzCcEgh4kfceGf
        RcrJXf1dy52dfACnW24mCBM=
X-Google-Smtp-Source: APXvYqzx+iJdx41eEtxov+lseJBDVi5+Bd+co9P8ndxjrrqLZ4Ks8iLi3tuljWT/UHOJJUjbUZVoTA==
X-Received: by 2002:a17:90a:9416:: with SMTP id r22mr7531065pjo.2.1579187947145;
        Thu, 16 Jan 2020 07:19:07 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k9sm4007510pjo.19.2020.01.16.07.19.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 07:19:06 -0800 (PST)
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Miller <davem@davemloft.net>, zhangshaokun@hisilicon.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jinyuqi@huawei.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com, guoyang2@huawei.com
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
Message-ID: <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
Date:   Thu, 16 Jan 2020 07:19:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/16/20 7:12 AM, Eric Dumazet wrote:
> 
> 
> On 1/16/20 4:27 AM, David Miller wrote:
>> From: Shaokun Zhang <zhangshaokun@hisilicon.com>
>> Date: Wed, 15 Jan 2020 11:23:40 +0800
>>
>>> From: Yuqi Jin <jinyuqi@huawei.com>
>>>
>>> atomic_try_cmpxchg is called instead of atomic_cmpxchg that can reduce
>>> the access number of the global variable @p_id in the loop. Let's
>>> optimize it for performance.
>>>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>>> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>>> Cc: Eric Dumazet <edumazet@google.com>
>>> Cc: Yang Guo <guoyang2@huawei.com>
>>> Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
>>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>>
>> I doubt this makes any measurable improvement in performance.
>>
>> If you can document a specific measurable improvement under
>> a useful set of circumstances for real usage, then put those
>> details into the commit message and resubmit.
>>
>> Otherwise, I'm not applying this, sorry.
>>
> 
> 
> Real difference that could be made here is to 
> only use this cmpxchg() dance for CONFIG_UBSAN
> 
> When CONFIG_UBSAN is not set, atomic_add_return() is just fine.
> 
> (Supposedly UBSAN should not warn about that either, but this depends on compiler version)

I will test something like :

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2010888e68ca96ae880481973a6d808d6c5612c5..e2fa972f5c78f2aefc801db6a45b2a81141c3028 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -495,11 +495,15 @@ u32 ip_idents_reserve(u32 hash, int segs)
        if (old != now && cmpxchg(p_tstamp, old, now) == old)
                delta = prandom_u32_max(now - old);
 
-       /* Do not use atomic_add_return() as it makes UBSAN unhappy */
+#ifdef CONFIG_UBSAN
+       /* Do not use atomic_add_return() as it makes old UBSAN versions unhappy */
        do {
                old = (u32)atomic_read(p_id);
                new = old + delta + segs;
        } while (atomic_cmpxchg(p_id, old, new) != old);
+#else
+       new = atomic_add_return(segs + delta, p_id);
+#endif
 
        return new - segs;
 }

