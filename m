Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8259A5EA0
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 02:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfICAgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 20:36:03 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41440 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfICAgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 20:36:03 -0400
Received: by mail-pf1-f195.google.com with SMTP id b13so3048016pfo.8;
        Mon, 02 Sep 2019 17:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WXtfRvg0HAQ1AbEkMFK2l6qpRZ1eLo172QU9YP505tU=;
        b=XPt6HoNIPUbuL/95hSsOFO0I1CAdHaDzNErILR0nCfMLntVWTY24bl3CMpH5IhNewN
         S3/vnM0T/fE4nyLTw5JFoKy0pkFkZhXYRN/TaOyrpaEU13CT7kHyUnV4n9bnjYxbGwyi
         J6w56A32kTq9m2b9o4Ca3uP6FyVC+oWZT/nPGftMTRqpUD3O+lzBs1r3o0xShuuYJZP/
         g5QogblP9INkNpN3QGHH9eVwdHbjALej5NkB1va1cn7PmXpIc1m4K8hWuJe5y1GK5KHv
         tg9iAtdt3BM9E8lMhuATUGQrk69mdNrswTj7baUG4XL4Tz3/0zMq1MtS+BVzVukeBfoK
         DIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WXtfRvg0HAQ1AbEkMFK2l6qpRZ1eLo172QU9YP505tU=;
        b=V1yY/iCURdbiAq36aVwdHa3XIPdc10rIaRXpx1W4QtMWxZVx93pnz/jg5NdLlI5rzj
         b4nOtBycMtL98QujaQUvGEfvBoCaPelV5DhtmgTbxNTmWnlNAa0aJVd6NoZ7TPDug1oa
         b5kdmyjA5pJxSwEXZfceRUEUhOMqSHZabVOn/u7Y/vM2+jMiZ4WfPnZr6WqkyygwyHU4
         38KfKFnmYCHIFESmT4fynWZ9b8QiKelILdy5Z/0DJaaBG6IhtNcGjbZCcGRR46frYqC4
         GAnuaubGfIZjSTPh/v6EE9sQ5L0H4uun29CLi9cr7vxJ0501OrrRXwbsRx0GCyVB1Iep
         jWNA==
X-Gm-Message-State: APjAAAW+Zu3bHGUcOPVSwRfCRgsZGT09gfwJ9ss5EONIlXpogXiZdLU1
        y7MmwrZWY0TSFF5ZlmKSYqIf90ci
X-Google-Smtp-Source: APXvYqycvnSPCdJaiVlKt7unzIMr9yXnjMozZhnMiM7HNdOy26e4EDqRyUsVQaHOYZcxp9um/bw0yg==
X-Received: by 2002:a63:5b52:: with SMTP id l18mr27404687pgm.21.1567470962173;
        Mon, 02 Sep 2019 17:36:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q186sm2031334pfb.47.2019.09.02.17.36.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 17:36:01 -0700 (PDT)
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
 <804fb4dc-23e5-3442-c64e-9857d61d6b6c@roeck-us.net>
 <20190902200635.GA29465@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <a3432c17-f3ec-6d1e-77ec-fab43feefcaf@roeck-us.net>
Date:   Mon, 2 Sep 2019 17:35:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190902200635.GA29465@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/19 1:06 PM, Greg KH wrote:
> On Mon, Sep 02, 2019 at 12:32:37PM -0700, Guenter Roeck wrote:
>> On 9/2/19 11:47 AM, Greg KH wrote:
>>> On Sun, Sep 01, 2019 at 07:08:29AM -0700, Guenter Roeck wrote:
>>>> On 9/1/19 1:03 AM, Kalle Valo wrote:
>>>>> Guenter Roeck <linux@roeck-us.net> writes:
>>>>>
>>>>>> On Mon, Aug 19, 2019 at 06:02:29PM -0400, Hui Peng wrote:
>>>>>>> `dev` (struct rsi_91x_usbdev *) field of adapter
>>>>>>> (struct rsi_91x_usbdev *) is allocated  and initialized in
>>>>>>> `rsi_init_usb_interface`. If any error is detected in information
>>>>>>> read from the device side,  `rsi_init_usb_interface` will be
>>>>>>> freed. However, in the higher level error handling code in
>>>>>>> `rsi_probe`, if error is detected, `rsi_91x_deinit` is called
>>>>>>> again, in which `dev` will be freed again, resulting double free.
>>>>>>>
>>>>>>> This patch fixes the double free by removing the free operation on
>>>>>>> `dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
>>>>>>> used in `rsi_disconnect`, in that code path, the `dev` field is not
>>>>>>>     (and thus needs to be) freed.
>>>>>>>
>>>>>>> This bug was found in v4.19, but is also present in the latest version
>>>>>>> of kernel.
>>>>>>>
>>>>>>> Reported-by: Hui Peng <benquike@gmail.com>
>>>>>>> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
>>>>>>> Signed-off-by: Hui Peng <benquike@gmail.com>
>>>>>>
>>>>>> FWIW:
>>>>>>
>>>>>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>>>>>
>>>>>> This patch is listed as fix for CVE-2019-15504, which has a CVSS 2.0 score
>>>>>> of 10.0 (high) and CVSS 3.0 score of 9.8 (critical).
>>>>>
>>>>> A double free in error path is considered as a critical CVE issue? I'm
>>>>> very curious, why is that?
>>>>>
>>>>
>>>> You'd have to ask the people assigning CVSS scores. However, if the memory
>>>> was reallocated, that reallocated memory (which is still in use) is freed.
>>>> Then all kinds of bad things can happen.
>>>
>>> Yes, but moving from "bad things _can_ happen" to "bad things happen" in
>>> an instance like this will be a tough task.  It also requires physical
>>> access to the machine.
>>>
>>
>> Is this correct even with usbip enabled ?
> 
> Who has usbip enabled anywhere?  :)
> 

It is enabled in Ubuntu, and it looks like it is enabled in Fedora as well.
It is disabled in Chrome OS. I didn't check other distributions.

> I don't know if usbip can trigger this type of thing, maybe someone
> needs to test that...
> 

I seemed to recall someone mentioning that it is possible to use usbip
for remote attacks. This is why I mentioned it. I don't recall details,
though, and I don't know if it is really possible and to what extent.

Guenter
