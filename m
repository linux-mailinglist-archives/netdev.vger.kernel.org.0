Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43578C0A0
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfHMSdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:33:22 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34103 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfHMSdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:33:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id b24so1571953pfp.1;
        Tue, 13 Aug 2019 11:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=w11YVFyoLhs+BNlDPKgWqoZJ95LEfsQBBxyoZnnFeNE=;
        b=JXS1wIa7Asipg0jcfsj8uWKX+etctXxHpwJRJbAFNgqXrt3eObuuXS66gp5hdjk69D
         osQZW+muNqqcBsj2hwEsdy/Nic3Wk+eBkWjETfGIxD4ovlMjcFYwsHFw63/lv6h4Hcd2
         Fhepa7HRvjRjKwsWNYs9tx2jo3v02jq68xR6Z0krWE4Qk3zyelI6wT/5jyvpKPJHok4Y
         Yk6ZMgkNKtK7qdbqgXAKWfhvCGhCxXl5QTBVxc+6O9ntTBXoUMD7Plf4DlDxz9rWzXh6
         7RXgatQ/ExkJUVo62PW+mZ2UBlG7plWd91mSpeGLnnRWi6NuCjZcMW2oPvyCx1J1nhva
         3zdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=w11YVFyoLhs+BNlDPKgWqoZJ95LEfsQBBxyoZnnFeNE=;
        b=gOIGgU21W6vSk4LlkPaO7JRZNG2p+y+uAFMk5RM2/mcH/ns6QwNsRe8+ovEkDc/PXn
         YiPmfO69HSf2FheC+PwkPeFJ6a+FhDXfj4/IyaGl0eqG1M8lSPvjRagbSa7mOAqlDrlN
         jBRDbPjFaP8MuHH+fwJ2qgo96H2RFw7mKZSmDGGgIrPqJjjUSVzpiOv9bP5NYpx5OXKb
         UVlSEKKrlSw+X4KmMb0xmRGLkFav0De4MlIAVCN0Ymx4gvQR/+YAMnMAY6FMoQdIuskK
         BjVeR8rrBeqRO/m3RQu4F7XTjlGtsFaAnc6jyHuZA1+mzQ0MomwV01c1tF0IR4kyv8Cc
         Bimw==
X-Gm-Message-State: APjAAAVpH0lmqpQt3u1081voDHR59yMZee490dfGC8HTRFPbJtXUxIR1
        ZOqkskxz2P1tOf1yPVqh63w=
X-Google-Smtp-Source: APXvYqwAT2LtSdQBLIiqXEDE3epqcWCW/8drmQhiid5gI8BRWCHDuOAagb4aRZijqrEwz/mqbNSDIA==
X-Received: by 2002:a65:43c2:: with SMTP id n2mr35769951pgp.110.1565721200412;
        Tue, 13 Aug 2019 11:33:20 -0700 (PDT)
Received: from [172.20.41.143] ([2620:10d:c090:200::3:ec2a])
        by smtp.gmail.com with ESMTPSA id b68sm134603729pfb.149.2019.08.13.11.33.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 11:33:19 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ivan Khoronzhuk" <ivan.khoronzhuk@linaro.org>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] xdp: xdp_umem: replace kmap on vmap for umem
 map
Date:   Tue, 13 Aug 2019 11:33:18 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <BC98A490-2892-452B-AC3E-C9B9F9BA121C@gmail.com>
In-Reply-To: <20190813183023.GA2856@khorivan>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-3-ivan.khoronzhuk@linaro.org>
 <9F98648A-8654-4767-97B5-CF4BC939393C@flugsvamp.com>
 <20190813183023.GA2856@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13 Aug 2019, at 11:30, Ivan Khoronzhuk wrote:

> On Tue, Aug 13, 2019 at 10:42:18AM -0700, Jonathan Lemon wrote:
>>
>>
>> On 13 Aug 2019, at 3:23, Ivan Khoronzhuk wrote:
>>
>>> For 64-bit there is no reason to use vmap/vunmap, so use 
>>> page_address
>>> as it was initially. For 32 bits, in some apps, like in samples
>>> xdpsock_user.c when number of pgs in use is quite big, the kmap
>>> memory can be not enough, despite on this, kmap looks like is
>>> deprecated in such cases as it can block and should be used rather
>>> for dynamic mm.
>>>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>>
>> Seems a bit overkill - if not high memory, kmap() falls back
>> to just page_address(), unlike vmap().
>
>> -- Jonathan
>
> So, as kmap has limitation... if I correctly understood, you propose
> to avoid macros and do smth like kmap:
>
> 	void *addr;
> 	if (!PageHighMem(&umem->pgs[i]))
> 		addr =  page_address(page);
> 	else
> 		addr = vmap(&umem->pgs[i], 1, VM_MAP, PAGE_KERNEL);
>
> 	umem->pages[i].addr = addr;
>
> and while unmap
>
> 	if (!PageHighMem(&umem->pgs[i]))
> 		vunmap(umem->pages[i].addr);
>
> I can try it, and add this in v2 if no objection.

Seems like a reasonable compromise to me.
-- 
Jonathan


>
>>
>>> ---
>>> net/xdp/xdp_umem.c | 16 ++++++++++++----
>>> 1 file changed, 12 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>>> index a0607969f8c0..907c9019fe21 100644
>>> --- a/net/xdp/xdp_umem.c
>>> +++ b/net/xdp/xdp_umem.c
>>> @@ -14,7 +14,7 @@
>>> #include <linux/netdevice.h>
>>> #include <linux/rtnetlink.h>
>>> #include <linux/idr.h>
>>> -#include <linux/highmem.h>
>>> +#include <linux/vmalloc.h>
>>>
>>> #include "xdp_umem.h"
>>> #include "xsk_queue.h"
>>> @@ -167,10 +167,12 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
>>>
>>> static void xdp_umem_unmap_pages(struct xdp_umem *umem)
>>> {
>>> +#if BITS_PER_LONG == 32
>>> 	unsigned int i;
>>>
>>> 	for (i = 0; i < umem->npgs; i++)
>>> -		kunmap(umem->pgs[i]);
>>> +		vunmap(umem->pages[i].addr);
>>> +#endif
>>> }
>>>
>>> static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>>> @@ -378,8 +380,14 @@ static int xdp_umem_reg(struct xdp_umem *umem, 
>>> struct xdp_umem_reg *mr)
>>> 		goto out_account;
>>> 	}
>>>
>>> -	for (i = 0; i < umem->npgs; i++)
>>> -		umem->pages[i].addr = kmap(umem->pgs[i]);
>>> +	for (i = 0; i < umem->npgs; i++) {
>>> +#if BITS_PER_LONG == 32
>>> +		umem->pages[i].addr = vmap(&umem->pgs[i], 1, VM_MAP,
>>> +					   PAGE_KERNEL);
>>> +#else
>>> +		umem->pages[i].addr = page_address(umem->pgs[i]);
>>> +#endif
>>> +	}
>>>
>>> 	return 0;
>>>
>>> -- 
>>> 2.17.1
>
> -- 
> Regards,
> Ivan Khoronzhuk
