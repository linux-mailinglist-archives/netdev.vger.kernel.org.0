Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B183521DF
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 23:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhDAVqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 17:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbhDAVqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 17:46:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7483DC0613E6;
        Thu,  1 Apr 2021 14:46:42 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo1550002wmq.4;
        Thu, 01 Apr 2021 14:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m7ln/s4zP1eb5Ag4HHKbxfo46m0CS6/f2GocxkCKxJU=;
        b=hT3CUtgAL6DMzj+B7U6G5tX0PhpgEWHKHeWr8h0BAothn2DvdThAGoCLC2qaep1rw4
         Uqmz1TmDw2M/7EN6UVUBxw5ngYqi+CW4HPI7BvNQRymiX/AeZflSul0BUhwyUBIR1jql
         +vronBxGYkrLCDRcEw1oVxI5ZUbx7fxKDIXIdjANKoH/ymKr/psLSfTFhiINM6S7siYT
         mv+QdLLsDwP91EB8w1RpAKByZOmrKjLo9Jm/4n8Qy1B65JJe3C73BjsO69lhxxIT/RhC
         PfPPaQxqt2vhrk1mekIIOqPFaPYkGBQ3O8PSL2ST7PLcYC0jPCnTzMGAduUW81+fLyeY
         KGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m7ln/s4zP1eb5Ag4HHKbxfo46m0CS6/f2GocxkCKxJU=;
        b=Ju1jGMt2U4e8Oa2sWFFZfrR//ApoewyZETASRTMTykLi/UirQmF/9xJlL1Vv+Nn6zL
         bWAD2OK5ME9oIS7JxHmizEWEqOUkfqB5XsewmXOC9ufw8ZWukxaQv8a6pHtzAUJUIx7Z
         iC4bctd0c6zog4DVG5K4S6lUIXnvIuieUB3go7/5egcz8VzK41Kpmy5R5wJJqb0TRcvx
         uxBuGZ2ORoGlSZdXav9Uzu9gQ2Ldoxqhe9zc7WNtyklyGwCKb3XAJRLHS5hpPvgIS2lR
         YnkMsiRao0yPT8TzU22iZDf3s4LDANimcvYLHvu5qMU8BOgJIOITd0h62qfcbDOXn5ia
         W+mg==
X-Gm-Message-State: AOAM533BWFBQrJQbHoqAD2E4tmUxZlHyxjnXscUs3D+xQW5b6lTea82O
        d7jkq2nsDe84sxaPvjN4/JWVlE0JTVM=
X-Google-Smtp-Source: ABdhPJw7Hmdy90QJ7iXppr/Y+dr3Q7M3B2jkb1vpMS9YDmQUue6Y4Vw7C1EXxHIicyqJl/26Afg7QQ==
X-Received: by 2002:a7b:c7d3:: with SMTP id z19mr294705wmk.139.1617313600731;
        Thu, 01 Apr 2021 14:46:40 -0700 (PDT)
Received: from [192.168.1.101] ([37.173.153.187])
        by smtp.gmail.com with ESMTPSA id v18sm12806445wrf.41.2021.04.01.14.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 14:46:40 -0700 (PDT)
Subject: Re: [PATCH net] atl1c: move tx cleanup processing out of interrupt
To:     Gatis Peisenieks <gatis@mikrotik.com>, chris.snook@gmail.com,
        davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <a5f7c8ea7e090921da7e8f3d4680e4c3@mikrotik.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b63fcab6-ad2f-c356-6818-08e497ff13e1@gmail.com>
Date:   Thu, 1 Apr 2021 23:46:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <a5f7c8ea7e090921da7e8f3d4680e4c3@mikrotik.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/1/21 7:32 PM, Gatis Peisenieks wrote:
> Tx queue cleanup happens in interrupt handler on same core as rx queue processing.
> Both can take considerable amount of processing in high packet-per-second scenarios.
> 
> Sending big amounts of packets can stall the rx processing which is unfair
> and also can lead to to out-of-memory condition since __dev_kfree_skb_irq
> queues the skbs for later kfree in softirq which is not allowed to happen
> with heavy load in interrupt handler.
> 
> This puts tx cleanup in its own napi to be executed on different core than rx
> cleanup which solves the mentioned problems and increases the throughput.
> 
> The ability to sustain equal amounts of tx/rx traffic increased:
> from 280Kpps to 1130Kpps on Threadripper 3960X with upcoming Mikrotik 10/25G NIC,
> from 520Kpps to 850Kpps on Intel i3-3320 with Mikrotik RB44Ge adapter.
> 
> Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>



>              }
>          }
> -        if (status & ISR_TX_PKT)
> -            atl1c_clean_tx_irq(adapter, atl1c_trans_normal);
> +        if (status & ISR_TX_PKT) {
> +            if (napi_schedule_prep(&adapter->tx_napi)) {
> +                int tx_cpu = (smp_processor_id() + 1) %
> +                    num_online_cpus();

Ouch. Please do not burry in a driver such hard-coded facility.

There is no guarantee tx_cpu is an online cpu .

> +                spin_lock(&adapter->irq_mask_lock);
> +                hw->intr_mask &= ~ISR_TX_PKT;
> +                AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
> +                spin_unlock(&adapter->irq_mask_lock);
> +                smp_call_function_single_async(tx_cpu,
> +                                   &adapter->csd);
> +            }
> +        }
>
Have you tried using a second NAPI, but no csd ?

We now have kthread napi [1]

By simply enabling kthread NAPI on your NIC, you should get same nice behavior.

As a bonus, on moderate load you would use a single cpu instead of two.

[1]
cb038357937ee4f589aab2469ec3896dce90f317 net: fix race between napi kthread mode and busy poll
5fdd2f0e5c64846bf3066689b73fc3b8dddd1c74 net: add sysfs attribute to control napi threaded mode
29863d41bb6e1d969c62fdb15b0961806942960e net: implement threaded-able napi poll loop support
