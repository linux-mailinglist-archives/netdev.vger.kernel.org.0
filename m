Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9254420DD8F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbgF2TNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731464AbgF2TNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:36 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B22C008755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 01:40:31 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id 9so17056642ljc.8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 01:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y2atqIGK37ILgDNJdohonospx0r47MxOkSdYCiw2OJ0=;
        b=QH3wWILFXt++weWn8Jl3dFoenZHdPyjJ5FAS+RaeaG3fC1AABhjaHwN5BnrGer1+8q
         8Y1NuQOpAMgCEYANJKgY74lbxJjoUJ/wW3PkCV5cofA+Cinmxb/nrsooqG4GIIxVhxaw
         exhMXOpDwweJ45PE2/C/AyDfadJx1Dt/C4Nws8+5oJznMyOLTngIutMlPbVLvEL/MK2j
         tnNMxL2dTdcHeORQFeNmkFyg9z3h69oE4bQ4gFJ/jWjvGzKY25egrUYu0dx3KkspC9AE
         JEl/jRaSv6HPXeQ3pYQC1zPWWEa1JA1IcDx7WGnluhEnMWSUDnZpVaoYX5j1nXNSp7Rx
         lWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y2atqIGK37ILgDNJdohonospx0r47MxOkSdYCiw2OJ0=;
        b=jCT9CqpylJ8Wt9NO8iiF1wiFoctFbKPFAsc2GsqWfJae8WtEEWiZWrbxP4OP2NnKlk
         whdhwfn4E0PPyb0EuMpQwzeLgwWn8DoUeExBThMLSRw0+OVHnTwe+u36zOJbm9ifXkx2
         lugharSVLOu/BeIZk3W41EJxb3tFu079KgIZmFOgaQyLx0bO3N+7qYymPyBhTF4c1Hj1
         +eIV8w4noUAzrhB8yx9u2K8GisuGnAy8OryQD9tvITOYkNeNJs9B42GtftrPxvqI3+k9
         u9nelBonxOMR/at7VyUDhHlM0Q9iGnaEY1F+Xm9S75LOEubkDtljhcu+1cyJAJ0MqwHZ
         2C1A==
X-Gm-Message-State: AOAM533SnSEiQDZULZTB2iLyW6kZnCA0ffj5IOy9qBxLBOhOvi8UoeNX
        Wb0B818xkuu5q7K/BK5+vqUWYw==
X-Google-Smtp-Source: ABdhPJyHHNhD5t2xjkbSGZiHt6KbdhAMKDi84P+mmkiT/V0jyrY+MpmJ+m/QKyI3DPkEbvRil0hrTg==
X-Received: by 2002:a2e:3003:: with SMTP id w3mr7315031ljw.11.1593420029479;
        Mon, 29 Jun 2020 01:40:29 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:8f5:df87:b899:8d19:71e5:a71? ([2a00:1fa0:8f5:df87:b899:8d19:71e5:a71])
        by smtp.gmail.com with ESMTPSA id c14sm787394ljj.112.2020.06.29.01.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 01:40:28 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     "REE dirk.behme@de.bosch.com" <dirk.behme@de.bosch.com>,
        "Shashikant.Suguni@in.bosch.com" <Shashikant.Suguni@in.bosch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <9f71873b-ee5e-7ae3-8a5a-caf7bf38a68e@gmail.com>
 <TY2PR01MB36926D80F2080A3D6109F11AD8980@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <TY2PR01MB36926B67ED0643A9EAA9A4F3D86E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Message-ID: <a1dc573d-78b0-7137-508d-efcdfa68d936@cogentembedded.com>
Date:   Mon, 29 Jun 2020 11:40:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB36926B67ED0643A9EAA9A4F3D86E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 29.06.2020 8:24, Yoshihiro Shimoda wrote:

>>>>> From: Yoshihiro Shimoda, Sent: Tuesday, May 26, 2020 6:47 PM
>>>>>
>>>>> According to the report of [1], this driver is possible to cause
>>>>> the following error in ravb_tx_timeout_work().
>>>>>
>>>>> ravb e6800000.ethernet ethernet: failed to switch device to config mode
>>>>>
>>>>> This error means that the hardware could not change the state
>>>>> from "Operation" to "Configuration" while some tx queue is operating.
>>>>> After that, ravb_config() in ravb_dmac_init() will fail, and then
>>>>> any descriptors will be not allocaled anymore so that NULL porinter
>>>>> dereference happens after that on ravb_start_xmit().
>>>>>
>>>>> Such a case is possible to be caused because this driver supports
>>>>> two queues (NC and BE) and the ravb_stop_dma() is possible to return
>>>>> without any stopping process if TCCR or CSR register indicates
>>>>> the hardware is operating for TX.
>>>>>
>>>>> To fix the issue, just try to wake the subqueue on
>>>>> ravb_tx_timeout_work() if the descriptors are not full instead
>>>>> of stop all transfers (all queues of TX and RX).
>>>>>
>>>>> [1]
>>>>> https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/
>>>>>
>>>>> Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
>>>>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>>>>> ---
>>>>>    I'm guessing that this issue is possible to happen if:
>>>>>    - ravb_start_xmit() calls netif_stop_subqueue(), and
>>>>>    - ravb_poll() will not be called with some reason, and
>>>>>    - netif_wake_subqueue() will be not called, and then
>>>>>    - dev_watchdog() in net/sched/sch_generic.c calls ndo_tx_timeout().
>>>>>
>>>>>    However, unfortunately, I didn't reproduce the issue yet.
>>>>>    To be honest, I'm also guessing other queues (SR) of this hardware
>>>>>    which out-of tree driver manages are possible to reproduce this issue,
>>>>>    but I didn't try such environment for now...
>>>>>
>>>>>    So, I marked RFC on this patch now.
>>>>
>>>> I'm afraid, but do you have any comments about this patch?
>>>
>>>      I agree that we should now reset only the stuck queue, not both but I
>>> doubt your solution is good enough. Let me have another look...
>>
>> Thank you for your comment! I hope this solution is good enough...
> 
> I'm sorry again and again. But, do you have any time to look this patch?

    Yes, in the sense of reviewing -- I don't consider it complete. And no, in 
the sense of looking into the issue myself... Can we do a per-queue tear-down
and re-init (not necessarily all in 1 patch)?

> Best regards,
> Yoshihiro Shimoda

MBR, Sergei
