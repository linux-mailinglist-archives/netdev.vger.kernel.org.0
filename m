Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686801EF0B7
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 06:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgFEEwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 00:52:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54032 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFEEwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 00:52:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id l26so7159910wme.3
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 21:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/a3q9oJ/+Q5ffliIOcEjfwRPLXfx4yLmntpdJIKRnC4=;
        b=DxkcHfSFJPtTIBddqFv1QTqU8vM7gD/grkSjI9HCrV2Em65aG4gqJCzVD41O5DFoKt
         9aISTZNPtJScZLna5yFdiajuwnWaw/8d//HOFccKDVBxwuf5ELd9aJuaHbfCR8yi2r8X
         Hmttkos4kA0qhw0M2PmnZmiej2kJ5Jb5+AUNlqHWgOTaJBuRp4S/Gtaq/u40tsWXjQtF
         DKFCack5DTVdKRO4vZaeTbSVps93Mdgd3kRDkTfWiCxFhA/MzofZCvyQ/+O4RbEs/ul5
         RH4SsmQu/pOtIUtvdhosdFYHvDAfb9MhXxCkY5vjDL/7SFryM8a20KLFTZSu7rs7A+uj
         QdbA==
X-Gm-Message-State: AOAM530anbHpMoQoQCkxFIAB2tdbDQFSHZ2CgQQo+7yu7L0cDXMXXjbC
        BbBgss6e3lAjsJ5Z9cmdbak=
X-Google-Smtp-Source: ABdhPJxL2wzHvBMIKeVYvp/inGbD214wjZJ77k/7XpRXOkQtHc28x63owtZ3kXJ6ECGE3zOMfq7FqA==
X-Received: by 2002:a1c:e914:: with SMTP id q20mr698002wmc.145.1591332768428;
        Thu, 04 Jun 2020 21:52:48 -0700 (PDT)
Received: from ?IPv6:2a02:21b0:9002:414a:d51e:6f07:7e6f:fcfa? ([2a02:21b0:9002:414a:d51e:6f07:7e6f:fcfa])
        by smtp.gmail.com with ESMTPSA id z12sm11454807wrg.9.2020.06.04.21.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 21:52:47 -0700 (PDT)
Reply-To: valentin@longchamp.me
Subject: Re: [PATCH] net: sched: make the watchdog functions more coherent
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com
References: <20200603212113.11801-1-valentin@longchamp.me>
 <20200604.155512.1355727491425437227.davem@davemloft.net>
From:   Valentin Longchamp <valentin@longchamp.me>
Message-ID: <24d3d43f-8b69-c4e1-9c42-89202705c542@longchamp.me>
Date:   Fri, 5 Jun 2020 06:52:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200604.155512.1355727491425437227.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05.06.2020 à 00:55, David Miller a écrit :
> From: Valentin Longchamp <valentin@longchamp.me>
> Date: Wed,  3 Jun 2020 23:21:13 +0200
> 
>> Remove dev_watchdog_up() that directly called __netdev_watchdog_up() and
>> rename dev_watchdog_down() to __netdev_watchdog_down() for symmetry.
>>
>> Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
>> ---
>>   net/sched/sch_generic.c | 11 +++--------
>>   1 file changed, 3 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>> index 2efd5b61acef..f3cb740a2941 100644
>> --- a/net/sched/sch_generic.c
>> +++ b/net/sched/sch_generic.c
>> @@ -465,12 +465,7 @@ void __netdev_watchdog_up(struct net_device *dev)
>>   	}
>>   }
>>   
>> -static void dev_watchdog_up(struct net_device *dev)
>> -{
>> -	__netdev_watchdog_up(dev);
>> -}
>> -
>> -static void dev_watchdog_down(struct net_device *dev)
>> +static void __netdev_watchdog_down(struct net_device *dev)
> 
> This patch will not apply if I apply your symbol export patch because
> the context above this function will be different.
> 
> Please don't do this.
> 

Yeah, I didn't know how to handle this properly: I kept both patches 
separated because the symbol export should go to stable and this one not.

Is that OK to have only a ("initial") subset of a series aimed for stable ?
