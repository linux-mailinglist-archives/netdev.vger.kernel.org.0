Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A2F381755
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 11:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhEOJuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 05:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhEOJuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 05:50:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC71C061573
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 02:49:05 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621072143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iq9o7YPY+AsUGgd9Wuyk3dCj9EtJktVa8f6ZHKbtNOk=;
        b=awVUuSOs11MoUQ8GelE8AsjJXpZV9dl1WjfcXAaJCvrf2Yr85ot0TrJLfu4F6EuGIU4Ycj
        XaSVssFO37AFy/ndfm/kRjY3u46gwnMciiNGlH+ehzxm+Vj7LJa7PDCojXaV3iymjfQfA+
        9QWCgl1pYucTAYFhVo7/Lw0ZXlB3z8Bn3CBRUIOovEKxK+ucFvqhuZq7Jpmf56V733cOor
        fLB5OA5H5maZhsWqfu7SEmuiDnRsC/I7t0E6Ih0HsOzOYa/Wxrq3lQGegcGq2j9Rlhx0l9
        L7bLpLTZm7wRrmFi//en9zOpDQc+a7jR9vxO5+jBFAQ+MoW5bmR815PnyY+zRQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621072143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iq9o7YPY+AsUGgd9Wuyk3dCj9EtJktVa8f6ZHKbtNOk=;
        b=wxRh9ZS7xK8a6GuX2kh0tDglvsi+cOg8fxpWwnpJ0U9yaddPA8GlqGn/HWX00Myya5ChQe
        SAcll3febn/BwpBg==
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        simon.horman@netronome.com, oss-drivers@netronome.com,
        bigeasy@linutronix.de, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/2] net: add a napi variant for RT-well-behaved drivers
In-Reply-To: <20210514222402.295157-1-kuba@kernel.org>
References: <20210514222402.295157-1-kuba@kernel.org>
Date:   Sat, 15 May 2021 11:49:02 +0200
Message-ID: <87pmxs1g4x.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14 2021 at 15:24, Jakub Kicinski wrote:
>  /**
> - *	napi_schedule_irqoff - schedule NAPI poll
> - *	@n: NAPI context
> + * napi_schedule_irq() - schedule NAPI poll from hardware IRQ
> + * @n: NAPI context
>   *
>   * Variant of napi_schedule(), assuming hard irqs are masked.
> + * Hardware interrupt handler must be marked with IRQF_NO_THREAD
> + * to safely invoke this function on CONFIG_RT=y kernels (unless
> + * it manually masks the interrupts already).
>   */
> -static inline void napi_schedule_irqoff(struct napi_struct *n)
> +static inline void napi_schedule_irq(struct napi_struct *n)
>  {
>  	if (napi_schedule_prep(n))
> -		__napi_schedule_irqoff(n);
> +		__napi_schedule_irq(n);

As this is intended for the trivial

   irqhandler()
        napi_schedule_irq(n);
        return IRQ_HANDLED;

case, wouldn't it make sense to bring napi_schedule_irq() out of line
and have the prep invocation right there?

void napi_schedule_irq(struct napi_struct *n)
{
 	if (napi_schedule_prep(n))
		____napi_schedule(this_cpu_ptr(&softnet_data), n);
}
EXPORT_SYMBOL(napi_schedule_irq);

As that spares a function call and lets the compiler be smarter about
it. I might be missing something though, but at least brain is more
awake now :)

Thanks,

        tglx
