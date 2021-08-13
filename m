Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF1C3EB7EB
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbhHMPKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241275AbhHMPJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:09:46 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BDCC061756;
        Fri, 13 Aug 2021 08:09:19 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id c24so20353960lfi.11;
        Fri, 13 Aug 2021 08:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W2ooleetOGxDv6uA8BJbyCwodwSrc5h12weH35wLF8I=;
        b=LJ9tvuR18O6i0e/19G+GiF5PLODO5+OHXzP8X61oleHa7rd6+QZyTd6vEpzqW2nXn+
         JDqJfOqlhI8p6liS+aKZsi6CckOgV/mBo8Dzrlo8LzuzZN3w0uAsjztKJ6aFy+ufc7cK
         129Rolwxw+GSezhVuAAHNlKRpk4nHjreaayZaNc49Yaj1IqmdANowcLxZeu9ZHDVnX06
         bWXMHSJiLIQYEI7I/LZLRvxON0xhRKY1f/dl6ly4db+NMPe+CaN7ku0/Nl33rX8W94DA
         JZeJjhLohf4vBFmm0lGY92hwz1jsKutn6FLLA0VYrG7fEHYCWsYGsOIwyzaoieZ8SBo+
         FAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W2ooleetOGxDv6uA8BJbyCwodwSrc5h12weH35wLF8I=;
        b=Unw3BMfWIstp15JcKUkJzqnQ3CivUqiQaEHkMQSe3M82ib7nOwEi4joACMUwsNEJ6I
         9cZ+v5vASjaesVPOJl/+HtsmAW8reXMDtj9DIVhPry7sSjtHOK/XA/mqIxR71pCJunCO
         QMJSRNIM5SgrD/VLN89VbqYF91rxKJp2xbdJiYmdDV979Xh2oEM0VHK2ZgV63ViG23I4
         SyzYotjRjpExG9R98dW8/sVFaeqr+o3ab/81bmQTeitZM4Xysfh3tcDq55gwpBLx42q/
         FLPUxddBm8C4tU4VJhJZWMaxMLJtrdCx2LHcWBJi7OxAIcyBf8cVL07Tcbhzrr92Rb4U
         89tQ==
X-Gm-Message-State: AOAM532maxwbXUb1SNWfYDCFzw39GMsbgGgNCYnPaBRfQVUOO9Ah/sZg
        LkgSqGB1kHkVNPwImG9Z8oo=
X-Google-Smtp-Source: ABdhPJw6mdF7zUfbTWIQTUIzK1O+2FCEe3s3BpOgu9HbDibOnPFFyeqRBsPq5/Aqzj/fQ2MOQrWCHA==
X-Received: by 2002:a19:dc57:: with SMTP id f23mr2015290lfj.294.1628867358296;
        Fri, 13 Aug 2021 08:09:18 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id a18sm193831ljq.14.2021.08.13.08.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 08:09:17 -0700 (PDT)
Subject: Re: [PATCH] net: 6pack: fix slab-out-of-bounds in decode_data
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
References: <20210813112855.11170-1-paskripkin@gmail.com>
 <20210813145834.GC1931@kadam>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <0c5bc329-6555-edb1-82ad-038cae6b0299@gmail.com>
Date:   Fri, 13 Aug 2021 18:09:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210813145834.GC1931@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/21 5:58 PM, Dan Carpenter wrote:
> On Fri, Aug 13, 2021 at 02:28:55PM +0300, Pavel Skripkin wrote:
>> Syzbot reported slab-out-of bounds write in decode_data().
>> The problem was in missing validation checks.
>> 
>> Syzbot's reproducer generated malicious input, which caused
>> decode_data() to be called a lot in sixpack_decode(). Since
>> rx_count_cooked is only 400 bytes and noone reported before,
>> that 400 bytes is not enough, let's just check if input is malicious
>> and complain about buffer overrun.
>> 
>> Fail log:
>> ==================================================================
>> BUG: KASAN: slab-out-of-bounds in drivers/net/hamradio/6pack.c:843
>> Write of size 1 at addr ffff888087c5544e by task kworker/u4:0/7
>> 
>> CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.6.0-rc3-syzkaller #0
>> ...
>> Workqueue: events_unbound flush_to_ldisc
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>>  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
>>  __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
>>  kasan_report+0x12/0x20 mm/kasan/common.c:641
>>  __asan_report_store1_noabort+0x17/0x20 mm/kasan/generic_report.c:137
>>  decode_data.part.0+0x23b/0x270 drivers/net/hamradio/6pack.c:843
>>  decode_data drivers/net/hamradio/6pack.c:965 [inline]
>>  sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]
>> 
>> Reported-and-tested-by: syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> ---
>>  drivers/net/hamradio/6pack.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
>> index fcf3af76b6d7..f4ffc2a80ab7 100644
>> --- a/drivers/net/hamradio/6pack.c
>> +++ b/drivers/net/hamradio/6pack.c
>> @@ -827,6 +827,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
>>  		return;
>>  	}
>>  
>> +	if (sp->rx_count_cooked + 3 >= sizeof(sp->cooked_buf)) {
> 
> It should be + 2 instead of + 3.
> 
> We write three bytes.  idx, idx + 1, idx + 2.  Otherwise, good fix!
> 

Indeed. Will fix in v2, thank you for pointing it out!


With regards,
Pavel Skripkin
