Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04EFA5CB4
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 21:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfIBTcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 15:32:42 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42995 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbfIBTcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 15:32:42 -0400
Received: by mail-pg1-f196.google.com with SMTP id p3so7846606pgb.9;
        Mon, 02 Sep 2019 12:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8uh9/XY6ueQfpSKxv8VJgELq8LY9QmNiFoOeViVR+c4=;
        b=pxQviwEBr0hEsNe1eCykn9M13dqO4mBqfwj1m4MWuDTkWkG1B1LZzsTNWegeoiL1lP
         00DtTplx0zqiFxhT56al/XqE3yasqKgdVyNUuz7aygxtgDMHjgorrndMHCKqN0yhK2uD
         7/3G5Fj4npqW6VrT+9aQwJEPwcY5kM7sWlv27K1NpbLPzf75Y82nJL0tk5W9sTEeZrOs
         Nsq68NrEn+S1AvwCZvc3CyoHDWFBwjU1HPjkM4rdBq/SdrSg7owZi9APYacuzdGcejmc
         kypgTMmRWfZK/iQDjbZhYK0NkB9o7AKYlkFx327UltxETd2zlnCmbTx3VFUa018uAh1F
         c/DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8uh9/XY6ueQfpSKxv8VJgELq8LY9QmNiFoOeViVR+c4=;
        b=ScIUzUF3gOtpeYbiqRbrznDchQqQwWQ6nNSaFgVe0Fy0f0PvVKmUv0v3INb6oQ0VqY
         O/WgNbb33k4RaCWEfgJgTxjmp2bp3zAAoH7Yv9/0W2HIrkL8acL0gOui98ylkSjGsTjh
         /7m2jImicvB3gj4qcq+otfFQRh/D/8KmpRWOc0xGNQFyEZdL8qyzathor+4XLDUGXutj
         0BG0Cdk/psXGzr/Rn8+DZlH1kysojniN0doFoJACt/OIbVYD0EJxMKszPZlZG1WW0/qc
         0HFz9hahhXglNM5fdzK43tcxLd+dcWtrltSHMzmGPJKwPI0qPRpTl6crwUGHx9LibxJQ
         8hCw==
X-Gm-Message-State: APjAAAVR3i43N0M+qwaodXvoMeWBtPlo7cRoPNjbwyXQd0zkX91WUxm2
        pUoQgmPI7ZP+BdmLNCHpc49WJRdR
X-Google-Smtp-Source: APXvYqxkFooiS6ICYvQ9vnRobKav0pYZiEQBh4lXbGG9jTnEa4sKiiIHfpqFUrzUb3VN42qxhULyew==
X-Received: by 2002:aa7:809a:: with SMTP id v26mr36157719pff.82.1567452760864;
        Mon, 02 Sep 2019 12:32:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i6sm10739350pfq.20.2019.09.02.12.32.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 12:32:39 -0700 (PDT)
Subject: Re: [PATCH] Fix a double free bug in rsi_91x_deinit
To:     Greg KH <greg@kroah.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Hui Peng <benquike@gmail.com>,
        security@kernel.org, Mathias Payer <mathias.payer@nebelwelt.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190819220230.10597-1-benquike@gmail.com>
 <20190831181852.GA22160@roeck-us.net>
 <87k1asqw87.fsf@kamboji.qca.qualcomm.com>
 <385361d3-048e-9b3f-c749-aa5861e397e7@roeck-us.net>
 <20190902184722.GC5697@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <804fb4dc-23e5-3442-c64e-9857d61d6b6c@roeck-us.net>
Date:   Mon, 2 Sep 2019 12:32:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190902184722.GC5697@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/19 11:47 AM, Greg KH wrote:
> On Sun, Sep 01, 2019 at 07:08:29AM -0700, Guenter Roeck wrote:
>> On 9/1/19 1:03 AM, Kalle Valo wrote:
>>> Guenter Roeck <linux@roeck-us.net> writes:
>>>
>>>> On Mon, Aug 19, 2019 at 06:02:29PM -0400, Hui Peng wrote:
>>>>> `dev` (struct rsi_91x_usbdev *) field of adapter
>>>>> (struct rsi_91x_usbdev *) is allocated  and initialized in
>>>>> `rsi_init_usb_interface`. If any error is detected in information
>>>>> read from the device side,  `rsi_init_usb_interface` will be
>>>>> freed. However, in the higher level error handling code in
>>>>> `rsi_probe`, if error is detected, `rsi_91x_deinit` is called
>>>>> again, in which `dev` will be freed again, resulting double free.
>>>>>
>>>>> This patch fixes the double free by removing the free operation on
>>>>> `dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
>>>>> used in `rsi_disconnect`, in that code path, the `dev` field is not
>>>>>    (and thus needs to be) freed.
>>>>>
>>>>> This bug was found in v4.19, but is also present in the latest version
>>>>> of kernel.
>>>>>
>>>>> Reported-by: Hui Peng <benquike@gmail.com>
>>>>> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
>>>>> Signed-off-by: Hui Peng <benquike@gmail.com>
>>>>
>>>> FWIW:
>>>>
>>>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>>>
>>>> This patch is listed as fix for CVE-2019-15504, which has a CVSS 2.0 score
>>>> of 10.0 (high) and CVSS 3.0 score of 9.8 (critical).
>>>
>>> A double free in error path is considered as a critical CVE issue? I'm
>>> very curious, why is that?
>>>
>>
>> You'd have to ask the people assigning CVSS scores. However, if the memory
>> was reallocated, that reallocated memory (which is still in use) is freed.
>> Then all kinds of bad things can happen.
> 
> Yes, but moving from "bad things _can_ happen" to "bad things happen" in
> an instance like this will be a tough task.  It also requires physical
> access to the machine.
> 

Is this correct even with usbip enabled ?

> Anyway, that doesn't mean we shouldn't fix it, it's just that CVSS can
> be crazy when it comes to kernel patches (i.e. almost all fixes should
> be "critical"...)
> 

Not all of them, but probably too many. That is why I asked if the problem
is real. I _used_ to trust CVSS scores, but by now I am at least somewhat
suspicious - especially if a patch wasn't applied for a period of time,
like this series of usb patches.

Having said that, I am even more wary of double-free problems - those tend
to be notoriously difficult to debug. I'd rather have them out of my way,
even if they are unlikely to be seen in the real world (plus, Murphy
says that anything unlikely is going to happen almost immediately).

Guenter
