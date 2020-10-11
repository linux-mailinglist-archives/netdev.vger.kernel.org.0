Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0AC28A796
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 15:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387924AbgJKNmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 09:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387887AbgJKNma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 09:42:30 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF6CC0613CE;
        Sun, 11 Oct 2020 06:42:30 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id x1so14184337eds.1;
        Sun, 11 Oct 2020 06:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hLxG0yZ5cZrExT3IP3K5DP3mD84GDhpB6hZtlMmQVmE=;
        b=B5bQKrMxDEyYGZai4RbwquyXNF22aY0dhlPe6gAJ1zPbcZgSYCMzucXvoMjI2a2Sqb
         Qtvl1es9qkwlyjowHg0oGGjkBKxu0o5HXu7hKobGGElCz7A6eq/5hPYdYs9inb+ZOfIi
         RZQgdd/Zs6Qe+etdqbYBvY+pdMBqUJjFBUZoveL0KHQF1ME8XgvJK/mj6BRRjNAfbgkj
         RbDQ1bV9LBWlIZCpkqxIzmILwfTPnresJ2Z/oK27RCJgNf8VbX9KJyryFqWgyt1Pgnvf
         0A9FVhZIdETnELehurtsJKB6vwZyD7qBLAL07nrq1ezTW15in2YYJPYrKKoPu3avwvLf
         lFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hLxG0yZ5cZrExT3IP3K5DP3mD84GDhpB6hZtlMmQVmE=;
        b=OCRrMFIWf7mbY9Zd/1xc/NEoI4tft6PGZj7DTsiJujsNbdT2v1kFNDUQ2JuspOHCOU
         4PTBIf7DoF/FvgRB+aWC129DS4Gy6u2f1AfGHFxhzXdrXx+VmBme1mMgW9IMqSv9woel
         zVY2xnO0BFiGz1ruAUhpMzr8Xu6d1UesaykZwk7wMjGWH7EPmkS93FFmof2eDa2B2rEx
         Z9y8MSzenPs/lL4K/hORkBmJLSQkXpJHfn2cNUgF52FVxa5a+CD0FZpnt0AoFjP2Wxjp
         XyMlKdd535MltjCGYUveYvYwvEpTtC3O1DAiUEJQJKNIeRvKylHgv0E35wwapwiYnV/a
         hrVA==
X-Gm-Message-State: AOAM531CrcSpYnplhYigHJL1pZd/VITzwKTdsDJ5yC1LdAWxrwW/B7Bd
        ERSQoQMoWJmIZ5V+giIwoPA=
X-Google-Smtp-Source: ABdhPJxnDhlnbDVChei7DLsNpLX3y7RDHL/sAv8tUogZzC2FUdZ0LuoU57KmtX6qI0C/9D8WkYGi6g==
X-Received: by 2002:a05:6402:3089:: with SMTP id de9mr9497751edb.368.1602423748759;
        Sun, 11 Oct 2020 06:42:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id p12sm9093760edr.18.2020.10.11.06.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 06:42:28 -0700 (PDT)
Subject: Re: [PATCH] net: stmmac: Don't call _irqoff() with hardirqs enabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Keeping <john@metanate.com>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
References: <20201008162749.860521-1-john@metanate.com>
 <8036d473-68bd-7ee7-e2e9-677ff4060bd3@gmail.com>
 <20201009085805.65f9877a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <725ba7ca-0818-074b-c380-15abaa5d037b@gmail.com>
 <070b2b87-f38c-088d-4aaf-12045dbd92f7@gmail.com>
 <20201010082248.22cc7656@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <04d10b06-ca1c-3bfa-0a5f-730a9c8a2744@gmail.com>
Date:   Sun, 11 Oct 2020 15:42:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201010082248.22cc7656@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2020 17:22, Jakub Kicinski wrote:
> On Sat, 10 Oct 2020 15:08:15 +0200 Heiner Kallweit wrote:
>> On 09.10.2020 18:06, Heiner Kallweit wrote:
>>> On 09.10.2020 17:58, Jakub Kicinski wrote:  
>>>> On Fri, 9 Oct 2020 16:54:06 +0200 Heiner Kallweit wrote:  
>>>>> I'm thinking about a __napi_schedule version that disables hard irq's
>>>>> conditionally, based on variable force_irqthreads, exported by the irq
>>>>> subsystem. This would allow to behave correctly with threadirqs set,
>>>>> whilst not loosing the _irqoff benefit with threadirqs unset.
>>>>> Let me come up with a proposal.  
>>>>
>>>> I think you'd need to make napi_schedule_irqoff() behave like that,
>>>> right?  Are there any uses of napi_schedule_irqoff() that are disabling
>>>> irqs and not just running from an irq handler?
>>>>  
>>> Right, the best approach depends on the answer to the latter question.
>>> I didn't check this yet, therefore I described the least intrusive approach.
>>>   
>>
>> With some help from coccinelle I identified the following functions that
>> call napi_schedule_irqoff() or __napi_schedule_irqoff() and do not run
>> from an irq handler (at least not at the first glance).
>>
>> dpaa2_caam_fqdan_cb
>> qede_simd_fp_handler
>> mlx4_en_rx_irq
>> mlx4_en_tx_irq
> 
> Don't know the others but FWIW the mlx4 ones run from an IRQ handler,
> AFAICT:
> 
> static irqreturn_t mlx4_interrupt(int irq, void *dev_ptr)
> static irqreturn_t mlx4_msi_x_interrupt(int irq, void *eq_ptr)
>   mlx4_eq_int()
>     mlx4_cq_completion
>       cq->comp()
> 
>> qeth_qdio_poll
>> netvsc_channel_cb
>> napi_watchdog
> 
> This one runs from a hrtimer, which I believe will be a hard irq
> context on anything but RT. I could be wrong.
> 

Typically forced irq threading will not be enabled, therefore going
back to use napi_schedule() in drivers in most cases will cause
losing the benefit of the irqoff version. Something like the following
should be better. Only small drawback I see is that in case of forced
irq threading hrtimers will still run in hardirq context and we lose
the benefit of the irqoff version in napi_watchdog().

diff --git a/net/core/dev.c b/net/core/dev.c
index a146bac84..7d18560b2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6393,7 +6393,11 @@ EXPORT_SYMBOL(napi_schedule_prep);
  */
 void __napi_schedule_irqoff(struct napi_struct *n)
 {
-	____napi_schedule(this_cpu_ptr(&softnet_data), n);
+	/* hard irqs may not be masked in case of forced irq threading */
+	if (force_irqthreads)
+		__napi_schedule(n);
+	else
+		____napi_schedule(this_cpu_ptr(&softnet_data), n);
 }
 EXPORT_SYMBOL(__napi_schedule_irqoff);
 
-- 
2.28.0


