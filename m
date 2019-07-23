Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1698722EC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfGWXXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:23:22 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37159 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfGWXXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 19:23:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so19893885pfa.4
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 16:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/LqedSmA2FqcZGzTM87ZxMai4HBeD/f1hnGIeHRb82A=;
        b=rAmz9qkYWGJIeAxhjqwocXj/yjo3N0q5gej1cdd6VSKAUYC5WRD3cyfFKuAQbyJnah
         TYubMAiy+dQS6wKbY92HsXCPMYtY7+I9tXPpF9FyC+zucGqy3QxZ1mp+XFuOMhWVceVf
         F795fG887kfRJW8sjaWi4N8BYh7tfIUacVaY+4qtnDpOo4TRcL0JlLGu3+4MQidOOoV4
         /FoN3an+8n4TJuAMAcUpY3G8azwPge5WTFq7XvG3otqLGkkTelrm7umY8rZcMH1X01cf
         np2Ooh0qBQ+e1C5RXK2Ds0cbFcz7mlLxF2n5K+qpW0gpI0iUKvAxO+BoHo+3vrbazLJM
         /YmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/LqedSmA2FqcZGzTM87ZxMai4HBeD/f1hnGIeHRb82A=;
        b=K9p7Ae+zfIkrtW/kvUkjiWU6OiNj8GMuOEFUvXGHzUkMmRfhkMPzwKEx9kq8M6uXys
         TeBaYeZI7Os8HvVazxR3WT6gbhn43A39LUm/NwMdSfvjCRWp/svFjhO8k2gpRohI+CMx
         uRBLH6CXJVhsWk7b30k4qA58DMOYdTvWm8naf2Ug+TnxWwHClAC7FhkEq7/7uwELq3Tn
         fxHPBeEXskqHRLRWXnmZVvu1QMH185hunSNBjngWml+xUt0GtqrhtvrR9Xl2Q5XXZWgZ
         3ssRI4Skahr49B7NylWzxXsD+o5Z5AX76MpaeoWYTa1PWM71prT5Msrr6tI/24Mw4tIk
         /TIw==
X-Gm-Message-State: APjAAAX7GEisDIixPTAlUN5Cjz20hGsoi6nbDwV135mWlnYvBjkHCZND
        VImLJ87RJGX31ByiDzdq97WjuTjlhyHvRw==
X-Google-Smtp-Source: APXvYqxxMJYGNR9jWMKMZbITaXm5+ok7KHwKjjhtSEC+0t1B1mvL8d4Oc5sVBIIFc+9Po6ow/LdN9w==
X-Received: by 2002:a62:6454:: with SMTP id y81mr7856903pfb.13.1563924201178;
        Tue, 23 Jul 2019 16:23:21 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id d17sm45951230pgl.66.2019.07.23.16.23.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 16:23:20 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 02/19] ionic: Add hardware init and device
 commands
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190722214023.9513-3-snelson@pensando.io>
 <20190723.141833.384334163321137202.davem@davemloft.net>
 <59e45fd2-3c62-58cf-cf63-935d17703d2c@pensando.io>
 <20190723.160538.2065000079755912945.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4dd2bbcb-07ea-b45a-3067-a4353d3ff81a@pensando.io>
Date:   Tue, 23 Jul 2019 16:23:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723.160538.2065000079755912945.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 4:05 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Tue, 23 Jul 2019 15:50:22 -0700
>
>> On 7/23/19 2:18 PM, David Miller wrote:
>>> From: Shannon Nelson <snelson@pensando.io>
>>> Date: Mon, 22 Jul 2019 14:40:06 -0700
>>>
>>>> +void ionic_init_devinfo(struct ionic_dev *idev)
>>>> +{
>>>> + idev->dev_info.asic_type = ioread8(&idev->dev_info_regs->asic_type);
>>>> + idev->dev_info.asic_rev = ioread8(&idev->dev_info_regs->asic_rev);
>>>> +
>>>> +	memcpy_fromio(idev->dev_info.fw_version,
>>>> +		      idev->dev_info_regs->fw_version,
>>>> +		      IONIC_DEVINFO_FWVERS_BUFLEN);
>>>> +
>>>> +	memcpy_fromio(idev->dev_info.serial_num,
>>>> +		      idev->dev_info_regs->serial_num,
>>>> +		      IONIC_DEVINFO_SERIAL_BUFLEN);
>>>    ...
>>>> +	sig = ioread32(&idev->dev_info_regs->signature);
>>> I think if you are going to use the io{read,write}{8,16,32,64}()
>>> interfaces then you should use io{read,write}{8,16,32,64}_rep()
>>> instead of memcpy_{to,from}io().
>>>
>> Sure.
> Note, I could be wrong.  Please test.
>
> I think the operation of the two things might be different.

It seems to me that memcpy() usually just does the right thing in most 
cases, so that's what I went with.  Looking into some of the 
definitions, and at how I used memcpy_...(), I think there are some 
appropriate ways to use ioread32_rep() in a couple of my cases, and 
another case or two where the memcpy variant may not make much 
difference with ioread8_rep().  It's also possible that sparse may have 
an opinion.  I'll look at them.

sln

