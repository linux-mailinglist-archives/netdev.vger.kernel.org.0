Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794182D760B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405989AbgLKMvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405984AbgLKMu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:50:59 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A5C0613D3;
        Fri, 11 Dec 2020 04:50:18 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 3so8467927wmg.4;
        Fri, 11 Dec 2020 04:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=AZh6epnblgNjcXj9Q6TirIVCDf8ojkkWKD1ZT1IFbo0=;
        b=fRw+t1yi2q/quJMj2mDcdMy+/97ElCT0SlqAm5aKMjksPJbaGms4IregiyJZ4e/DG0
         NzC47Cnxk7JyZ9sfOhWjGgkMswia6smaPDIE/+rDk1ByqOuFSSP8qNp+U8Yf6201XQgA
         IEaa0V4sNPW79OnqmRHln+3kLnfyI63CPiY43HLI7Uhn3wgHnl3ZMBdgW8rcrqEpnXdZ
         2joYMd4XY5OYgaiv6mPZjoSdMo6U2GW1VNMF6YtmM6dq4so5PevVNh0ehXf4l1d68EjG
         /D50qf9zD0DEQnWjCyouwlpxcA+hcHNy7xit/7A+Dtp59jW4x08HaL3spQCSO1khRzWd
         TCdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=AZh6epnblgNjcXj9Q6TirIVCDf8ojkkWKD1ZT1IFbo0=;
        b=ELuygU/2BNnVwzj28dU7XlcUCWmAofzLjV2UJeK7aj0cj2nfPXTeOK6pHSvwg8skTy
         kJf5BcKpmHuqPeKTNnRCLC6CGCNXqsHXx8ZbeOxKq+pNxefBr1Njewf6FLl2WT1g9kSh
         LmHiCGfI6r7oH/uMpXz2mA+/BKe1AKk+AXnQ5jqr+7qmoe0Yw2tRevJlCamUA6o3TJci
         RMO7vyNzuTCOU9EU4Z/xI1AgMmBIRgpwlf8wAqN9wk0VWdwvbdLs5OoWRwsjHhkMR7Hl
         Fm8Pt1IiT/MJRpIPi1U4ecq/XIMxrewLKMx70FsgujZjctZ+kh0vzt5KrhDXJSM7rnFW
         D2sw==
X-Gm-Message-State: AOAM531zqW0wWaat2uEj7wdFrQ8bjqDDlbZmnXWIzwWwBmPHiEqORxN7
        6p89+1fKS59WpPdwJvrMLHnCoLVye4WEqQ==
X-Google-Smtp-Source: ABdhPJxfeKFOVFYxXf3fCLC0eSEHMZvdo4ET217m6cm8UQepZ1sLNQa6uYIQWey1QwThcu699AOEuA==
X-Received: by 2002:a1c:67c2:: with SMTP id b185mr13102888wmc.119.1607691017088;
        Fri, 11 Dec 2020 04:50:17 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:c83a:dffd:2622:7172? (p200300ea8f065500c83adffd26227172.dip0.t-ipconnect.de. [2003:ea:8f06:5500:c83a:dffd:2622:7172])
        by smtp.googlemail.com with ESMTPSA id c1sm13698555wml.8.2020.12.11.04.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 04:50:16 -0800 (PST)
Subject: Re: [PATCH net v2] lan743x: fix rx_napi_poll/interrupt ping-pong
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20201210035540.32530-1-TheSven73@gmail.com>
 <5ff5fd64-2bf0-cbf7-642f-67be198cba05@gmail.com>
 <CAGngYiXsyRH=5UYwaCkVDDGkRX6m_Cw9iam+nSRZwA1=ZNPnOQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f462a419-aa6f-38f7-573e-c48c2a859f55@gmail.com>
Date:   Fri, 11 Dec 2020 13:50:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAGngYiXsyRH=5UYwaCkVDDGkRX6m_Cw9iam+nSRZwA1=ZNPnOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 11.12.2020 um 13:43 schrieb Sven Van Asbroeck:
> Hi Heiner,
> 
> On Thu, Dec 10, 2020 at 2:32 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>>
>> In addition you could play with sysfs attributes
>> /sys/class/net/<if>/gro_flush_timeout
>> /sys/class/net/<if>/napi_defer_hard_irqs
> 
> Interesting, I will look into that.
> 
I run a 1Gbit chip with gro_flush_timeout = 20000 and napi_defer_hard_irqs = 1.
This helped to reduce interrupt load significantly under iperf3
(w/o interrupt coalescing at chip level)

>>> @@ -2407,7 +2409,7 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
>>>
>>>       netif_napi_add(adapter->netdev,
>>>                      &rx->napi, lan743x_rx_napi_poll,
>>> -                    rx->ring_size - 1);
>>> +                    64);
>>
>> This value isn't completely arbitrary.
>> Better use constant NAPI_POLL_WEIGHT.
>>
> 
> Thank you, I will change it in the next patch version.
> 

