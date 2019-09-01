Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF43AA49BC
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 16:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbfIAOId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 10:08:33 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35042 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfIAOId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 10:08:33 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so5403008plb.2;
        Sun, 01 Sep 2019 07:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JPQn7evHwAIFUQeXNHFpGSBFL3fdvy+iWW2paQp4S8M=;
        b=MCWJ0hsgzSN5UaUZHovyq4Rg62dozNlOmjOSV4kDAeFHyrxLyhBE+872oLqwjSzMfS
         tdhB2GW3skNIRqR2O8foKq2UbHYMUOHY6RyzlK7OtGZALMzDSVtsaVTRrC8OOEvkU4u0
         apKwfGtiKl573O9kHbWHt84lJBHyQNQjJihH/HB2aiz5Uu94e9DQGqNQVt76BuJEQd33
         8W1tNFRB8kHV1AEBNvouTO1JN4oj2FeW0HUNuCFBEOIL1h6JSSLqQ8KnZ4mQnisBiOen
         zR84OGxDrCF1NRJNOExM72sg8dvv4cuIg4mfrvMS1xYzgrssl52T8B2Vsrfsx6FEcY3A
         dliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JPQn7evHwAIFUQeXNHFpGSBFL3fdvy+iWW2paQp4S8M=;
        b=hz+DgaDAYIOyI2mvIneP5kjQmwD9MBYca2c6v3sG3UodTLokbQ2AUP+ZGspv8jlFmS
         fPRfvYRxtb6LmZ3xJU5dG+buM3ABeCuLCSBMo6DoDLVJakudIqwrT96NqXnMzPsZ4LhD
         JFdRsfoRS1XZZZE+i9flWxFhWv3F6qYxhGEfPwIxj1zzFDwuoSGLh4fDi/wWtZLK2p/W
         E5qvO1akPC3LdiS08BlizR5qpcqioH7tHGIQHrUqlQRpnU2Cxdo9O3AMXQstuZe6GnhU
         PmQ8gAO34AEr3mWlfnyy+oeDTgtj84z1ufnwU6LKxIW0mJjz3rJ48LIdSNXwKMiYUyJ0
         PsUA==
X-Gm-Message-State: APjAAAXyZTLnvAqHi+qFtrTZ1LgMRhsTuByB1Y+bkU8U9WJd+HN/8z9f
        il6lBUvC0+jqHtJhzQMGHbm/hlm4
X-Google-Smtp-Source: APXvYqx6QwLwWBm5m9V9M4iM0czn+o3bSTA4lr19LvDJ4k33ZqbrZD/zfs0FTJrYnfx/49pqRiVUKQ==
X-Received: by 2002:a17:902:9b8f:: with SMTP id y15mr26577918plp.194.1567346912108;
        Sun, 01 Sep 2019 07:08:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v15sm13058296pfn.69.2019.09.01.07.08.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Sep 2019 07:08:31 -0700 (PDT)
Subject: Re: [PATCH] Fix a double free bug in rsi_91x_deinit
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Hui Peng <benquike@gmail.com>, security@kernel.org,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190819220230.10597-1-benquike@gmail.com>
 <20190831181852.GA22160@roeck-us.net>
 <87k1asqw87.fsf@kamboji.qca.qualcomm.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <385361d3-048e-9b3f-c749-aa5861e397e7@roeck-us.net>
Date:   Sun, 1 Sep 2019 07:08:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87k1asqw87.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/19 1:03 AM, Kalle Valo wrote:
> Guenter Roeck <linux@roeck-us.net> writes:
> 
>> On Mon, Aug 19, 2019 at 06:02:29PM -0400, Hui Peng wrote:
>>> `dev` (struct rsi_91x_usbdev *) field of adapter
>>> (struct rsi_91x_usbdev *) is allocated  and initialized in
>>> `rsi_init_usb_interface`. If any error is detected in information
>>> read from the device side,  `rsi_init_usb_interface` will be
>>> freed. However, in the higher level error handling code in
>>> `rsi_probe`, if error is detected, `rsi_91x_deinit` is called
>>> again, in which `dev` will be freed again, resulting double free.
>>>
>>> This patch fixes the double free by removing the free operation on
>>> `dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
>>> used in `rsi_disconnect`, in that code path, the `dev` field is not
>>>   (and thus needs to be) freed.
>>>
>>> This bug was found in v4.19, but is also present in the latest version
>>> of kernel.
>>>
>>> Reported-by: Hui Peng <benquike@gmail.com>
>>> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
>>> Signed-off-by: Hui Peng <benquike@gmail.com>
>>
>> FWIW:
>>
>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>
>> This patch is listed as fix for CVE-2019-15504, which has a CVSS 2.0 score
>> of 10.0 (high) and CVSS 3.0 score of 9.8 (critical).
> 
> A double free in error path is considered as a critical CVE issue? I'm
> very curious, why is that?
> 

You'd have to ask the people assigning CVSS scores. However, if the memory
was reallocated, that reallocated memory (which is still in use) is freed.
Then all kinds of bad things can happen.

Guenter

>> Are there any plans to apply this patch to the upstream kernel anytime
>> soon ?
> 
> I was on vacation last week and hence I have not been able to apply any
> wireless patches. I should be able to catch up next week.
> 

