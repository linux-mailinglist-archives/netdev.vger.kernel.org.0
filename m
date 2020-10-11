Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0822E28A6A5
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 11:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387459AbgJKJYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 05:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgJKJYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 05:24:50 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958BFC0613CE;
        Sun, 11 Oct 2020 02:24:49 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dg9so11451329edb.12;
        Sun, 11 Oct 2020 02:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tH45RmioYS3HtwVDfkOZiUgyPKcw48joPJkjW+p/y2k=;
        b=I4BNsrv8kdOI9zLwYOShUS1WC28NH3JI55NT2p/R4GoG25X77zYu41TfPUjpWfK6L6
         CrN6+FYr6UsHfBU4nIA9q6XK+rrTxwC4FnJmbJI0rd1+7H2LHgBg5xpGA0iYB25niYES
         FsQi5hJrI/bc+7I2jObKzCpJFmVJQtrehfT0Y2u72mJhg0vwaDFIdyPn2uIBTS7NJxEO
         IHlwwgq6UNSg7WxdILIFu+16IHfzt+PXp+N021PMWPGl3eg9bxmyqtCUOJpa3TTBMq0A
         m50PD5Nks8px8WuVvot4h3YfBFwasRL6kpgQn6xzaRNAKQmOn3tclYQ1dCyRzLg1y1/J
         J38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tH45RmioYS3HtwVDfkOZiUgyPKcw48joPJkjW+p/y2k=;
        b=mnkcH8P9qYZtfcMB8A4Ta9xIB7YAY26IuTJI8YZR040ui4RmqKlvnkJ1TgNGgM/YqX
         6Xr6bRKEXHRECzpofe0J1Q+dZTA+sMnDLHfcWkIHv/FkrTl3eZ9d5wQpWX9Mnn+NPHOP
         k6CPlEMeQaNBneK+fnPd/krynkeTS/iNckdxXf7mszwkDN6/3XnC97D7+/6nx6cxdoaS
         p7F7OxlEXYjjSVVA3P8tT9EIPAiWgzzlFOjTY8jjFuoBmPHEonuZfpS8xfox+JDnvomF
         ky6mzhzTNU0H96ZQmLVh6HPT8ZH+FtEvBx3N/JZ56Doo/pdKCYS2HGjsefSqvF0Y8tyg
         afPg==
X-Gm-Message-State: AOAM532xVZ6Ne28zXSUIriC/AHdZJdvFwZakDGxRfsMdPRKLGTtFtMJ/
        Jg9rnvQFzkez14p6Eo+1XtjjYfOh5Hgdsg==
X-Google-Smtp-Source: ABdhPJzyinaKYsOUUr1JqCSL+yUoSM495atqvyfqafzGj+nvUDOiolEyh+13nkTGbyhXnvqIykjMIg==
X-Received: by 2002:aa7:c948:: with SMTP id h8mr6689859edt.171.1602408287443;
        Sun, 11 Oct 2020 02:24:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id x2sm8855899edr.65.2020.10.11.02.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 02:24:47 -0700 (PDT)
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
Message-ID: <c73866a9-2ee8-b549-f578-75d62b9263b4@gmail.com>
Date:   Sun, 11 Oct 2020 11:24:41 +0200
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

A similar discussion can be found e.g. here:
https://lore.kernel.org/netdev/20191126222013.1904785-1-bigeasy@linutronix.de/
However I don't see any actual outcome.
