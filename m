Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1023FFD4A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 04:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfKRDVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 22:21:15 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:43248 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfKRDVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 22:21:15 -0500
Received: by mail-pj1-f68.google.com with SMTP id a10so1053919pju.10;
        Sun, 17 Nov 2019 19:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=48DDJ4D4S0wYE8hxlSX2K0AyEjit/Lx1WwVnZYqsT+I=;
        b=tKIWcTVdlUNglY4T7xTItt1EokO0F0BFh+0tRyrNSllt1rWGK6pONI9ryn0ODwybI+
         nYAE3Jp169TRLeByPK7RUzvFPxBqlaqdqAD8cI0HmFrFyIbTukYFZXfoI1+VR67+3omx
         4xv+ctgCbaxoVrfdf7e/V9spby8F8HPxTgPPC2vFL7kYuPgM9tv4EAh4bk3GfeBvAvUd
         2PWklx3VNiUCDijpsy99xTNwLtX9UScAyua297oD8wLLkl+JvIkeZ3uQaNqEf/RuIRQY
         WxjPXNMpKdlP+HMj/WOhUWk2WM4AQRyErQ74vJKkp0xdvD8ix9ozkA1URwBykdasuE1f
         hOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=48DDJ4D4S0wYE8hxlSX2K0AyEjit/Lx1WwVnZYqsT+I=;
        b=G2pR1f1pTcwRZKwmwGXp/Lxws3mqMbCbiUmHn8LNMUStOxCHHYTYhwmNs5s1HiQe+I
         H69Y1c3+XnqkUIhDQKx5CpGj4+vBW8cTU5wEaJnneaPKp8BoFmhaYzIfITEDvYwyf4II
         3Jgxt80vgJ0eQxEUDRsM78qcmU4LCjY9llDwqbPiqMnBvppehA4C1A0GLVYvfmimaM4P
         9XwQeieaWIGU3fJjFPFhiuBx3NHT0rzmUXQFZQK1RHI5U6Rj3SL9aPrwqqMfexZALxFn
         Yi814sZ8tUskKU+TMVflPuG7w4dMToXOmvQWCCktCLmhrcpctvHvfx+jSXe3ZMYwHtTW
         8/AQ==
X-Gm-Message-State: APjAAAUnkEWe05rjNia/TULvSnuxVrI6vEGod2tHk/Auw9bS2Ycbv7iE
        T524Zef8Y3BD8qauPay2hHA=
X-Google-Smtp-Source: APXvYqyLqXWScSf+XWbQzxGoSJwp4nYlzU0v5ikM1XZHIGdOwpKlBh9HvQY9U3AyW06XnWbvX7mb8w==
X-Received: by 2002:a17:90a:234c:: with SMTP id f70mr35952404pje.109.1574047274609;
        Sun, 17 Nov 2019 19:21:14 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:bd88:fb6d:6b19:f7d1])
        by smtp.googlemail.com with ESMTPSA id u9sm18891455pfm.102.2019.11.17.19.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Nov 2019 19:21:13 -0800 (PST)
Subject: Re: [PATCH] vrf: Fix possible NULL pointer oops when delete nic
To:     "wangxiaogang (F)" <wangxiaogang3@huawei.com>, dsahern@kernel.org,
        shrijeet@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hujunwei4@huawei.com, xuhanbing@huawei.com
References: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
 <7fe948a8-debd-e336-9584-e66153e90701@gmail.com>
 <bead86fd-ae33-219f-0601-d80b57695d3c@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a9efbb8a-4f48-9208-0615-087fb9e8e2d9@gmail.com>
Date:   Sun, 17 Nov 2019 20:21:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <bead86fd-ae33-219f-0601-d80b57695d3c@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/19 8:16 PM, wangxiaogang (F) wrote:
> 
> 
> On 2019/11/16 0:59, David Ahern wrote:
>> On 11/14/19 11:22 PM, wangxiaogang (F) wrote:
>>> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
>>> index b8228f5..86c4b8c 100644
>>> --- a/drivers/net/vrf.c
>>> +++ b/drivers/net/vrf.c
>>> @@ -1427,6 +1427,9 @@ static int vrf_device_event(struct notifier_block *unused,
>>>  			goto out;
>>>
>>>  		vrf_dev = netdev_master_upper_dev_get(dev);
>>> +		if (!vrf_dev)
>>> +			goto out;
>>> +
>>>  		vrf_del_slave(vrf_dev, dev);
>>>  	}
>>>  out:
>>
>> BTW, I believe this is the wrong fix. A device can not be a VRF slave
>> AND not have an upper device. Something is fundamentally wrong.
>>
>>
> 
> this problem occurs when our testers deleted the NIC and vrf in parallel.
> I will try to recurring this problem later.
> 

The deletes are serial in the kernel due to the rtnl, but dev changes
are under rcu...
