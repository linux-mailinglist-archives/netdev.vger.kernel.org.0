Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89398F4A8
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732497AbfHOTdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:33:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46868 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfHOTdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:33:00 -0400
Received: by mail-pf1-f195.google.com with SMTP id q139so1798621pfc.13;
        Thu, 15 Aug 2019 12:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=p7aqnAxt4JZHFY9o0OB/fA5VGIsSeYMdSjXI0F07Cmg=;
        b=Nuqb6d4Zm3704+QDdhxRMUZT/PFx7B0ES+uTxZ16Rp9+YrRpLLrp9APz8y8sCxsE9+
         EnnGbN6ybkVD3oEneF4hHpWyRl+WrJmKEJ+M0TN4wpRKcRFBB8GgJ9WeCqIdrIgVE/kV
         fFx9XXqqmOKMc4890Y8jSI1kO+0j78JP7YJhcYl307r/8JHJ1nYszwmvYzweJpC07IpO
         1hlGo1hDE8NAbB6v1d2gUzixLVvUrT68beZyHYCbCsqiZN1d/e/Ql6f1fSevDJrtTM1p
         neJed9Zjaj4dJNQBYTdWO2IPFtDIJLWFSrSaRJ7ieL+7TQHHdLkeziIOuh+qNg/K5HBW
         bk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=p7aqnAxt4JZHFY9o0OB/fA5VGIsSeYMdSjXI0F07Cmg=;
        b=QeSWb+P6hzzE1pgcRhXjel4DvYz37Qi8eiA+Lz9s2N0xMpbNeo/+MWnyAbM/VwTUHW
         RtNIcyLElnhLFtJ3uWkYDcN4YTmQ6Lc1r0TL/MLIFqckuR2aPpsmbMDH6EJrr9zWepsb
         v5hmy8RLdXEHKKk/FyzWxwpI5emmN6lFQ+/pW1W+JGkc4gTl6AmnPiIXULyx0afyOriR
         w9ATXFoWc98xUJgtp23HHyfmS6dAG006KBPdesMC/ZrFPHx3Q4f4us2ur3JC8GkFnNn6
         kEJYjGl4uGnJFCgVQtUaFqNV+MZyoWjm50v8PDncXDnIUpp6b6RJaCPU+O3hj0YvJrTt
         calA==
X-Gm-Message-State: APjAAAUnf2f0ru8XY/e5Z6zXVJOf5dkOvnJcW+9KctlDdIFKGxOzHHtN
        EsTeQAw9rds/uKxHsSJ1Hkc=
X-Google-Smtp-Source: APXvYqywj0OftSHEfbT4+9vHaQoy3pkI16VnmgMQJWCTevASvp70dSF0ikoKMfZeysS2xv4N6tZZvg==
X-Received: by 2002:a62:be02:: with SMTP id l2mr7195167pff.63.1565897579197;
        Thu, 15 Aug 2019 12:32:59 -0700 (PDT)
Received: from [172.20.53.208] ([2620:10d:c090:200::3:fd5d])
        by smtp.gmail.com with ESMTPSA id t4sm4134652pfq.153.2019.08.15.12.32.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 12:32:58 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ivan Khoronzhuk" <ivan.khoronzhuk@linaro.org>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        yhs@fb.com, andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v2 2/3] xdp: xdp_umem: replace kmap on vmap for
 umem map
Date:   Thu, 15 Aug 2019 12:32:57 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <0BD97FA1-8251-436D-A1F8-00BEF0791B95@gmail.com>
In-Reply-To: <20190815191456.GA11699@khorivan>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
 <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
 <5B58D364-609F-498E-B7DF-4457D454A14D@gmail.com>
 <20190815191456.GA11699@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Aug 2019, at 12:19, Ivan Khoronzhuk wrote:

> On Thu, Aug 15, 2019 at 11:23:16AM -0700, Jonathan Lemon wrote:
>> On 15 Aug 2019, at 5:13, Ivan Khoronzhuk wrote:
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
>>> ---
>>> net/xdp/xdp_umem.c | 36 ++++++++++++++++++++++++++++++------
>>> 1 file changed, 30 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>>> index a0607969f8c0..d740c4f8810c 100644
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
>>> @@ -170,7 +170,30 @@ static void xdp_umem_unmap_pages(struct 
>>> xdp_umem *umem)
>>> 	unsigned int i;
>>>
>>> 	for (i = 0; i < umem->npgs; i++)
>>> -		kunmap(umem->pgs[i]);
>>> +		if (PageHighMem(umem->pgs[i]))
>>> +			vunmap(umem->pages[i].addr);
>>> +}
>>> +
>>> +static int xdp_umem_map_pages(struct xdp_umem *umem)
>>> +{
>>> +	unsigned int i;
>>> +	void *addr;
>>> +
>>> +	for (i = 0; i < umem->npgs; i++) {
>>> +		if (PageHighMem(umem->pgs[i]))
>>> +			addr = vmap(&umem->pgs[i], 1, VM_MAP, PAGE_KERNEL);
>>> +		else
>>> +			addr = page_address(umem->pgs[i]);
>>> +
>>> +		if (!addr) {
>>> +			xdp_umem_unmap_pages(umem);
>>> +			return -ENOMEM;
>>> +		}
>>> +
>>> +		umem->pages[i].addr = addr;
>>> +	}
>>> +
>>> +	return 0;
>>> }
>>
>> You'll want a __xdp_umem_unmap_pages() helper here that takes an
>> count of the number of pages to unmap, so it can be called from
>> xdp_umem_unmap_pages() in the normal case, and xdp_umem_map_pages()
>> in the error case.  Otherwise the error case ends up calling
>> PageHighMem on a null page.
>> -- 
>> Jonathan
>
> Do you mean null address?
> If so, then vunmap do nothing if it's null, and addr is null if it's 
> not
> assigned... and it's not assigned w/o correct mapping...
>
> If you mean null page, then it is not possible after all they are
> pinned above, here: xdp_umem_pin_pages(), thus assigned.
>
> Or I missed smth?

No - I forgot about umem_pin_pages() - feel free to ignore my comments.
--
Jonathan

>
> Despite of this, seems like here should be one more patch, adding 
> unpinning page
> in error path, but this not related to this change. Will do this in 
> follow up
> fix patch, if no objection to my explanation, ofc.
>
> -- 
> Regards,
> Ivan Khoronzhuk
