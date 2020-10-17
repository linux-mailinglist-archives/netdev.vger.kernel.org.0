Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88755291511
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 01:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439908AbgJQX3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 19:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbgJQX3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 19:29:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2FA120878;
        Sat, 17 Oct 2020 23:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602977391;
        bh=PS7Jyely9I5EQo7o9XDjmMzSliznkYY025UjvCTWy1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vFKn1O7nF82ARW/QwyVHB/4OAEDGAQ6EwVA7u5R37A8O9r6Kt1aLtNCu6D2TtbeIz
         2hZxl7SDK0psca9x5xlqaVaBsb3L4TCcjcTNerN7ojapqP8pI2n3Il81IMOGWfDL+v
         bZ/FhVZlZhc7S59H/nIIRS6q5zesU1jlkI9yiCuY=
Date:   Sat, 17 Oct 2020 16:29:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Remove __napi_schedule_irqoff?
Message-ID: <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com>
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Oct 2020 15:45:57 +0200 Heiner Kallweit wrote:
> When __napi_schedule_irqoff was added with bc9ad166e38a
> ("net: introduce napi_schedule_irqoff()") the commit message stated:
> "Many NIC drivers can use it from their hard IRQ handler instead of
> generic variant."

Eric, do you think it still matters? Does it matter on x86?

> It turned out that this most of the time isn't safe in certain
> configurations:
> - if CONFIG_PREEMPT_RT is set
> - if command line parameter threadirqs is set
> 
> Having said that drivers are being switched back to __napi_schedule(),
> see e.g. patch in [0] and related discussion. I thought about a
> __napi_schedule version checking dynamically whether interrupts are
> disabled. But checking e.g. variable force_irqthreads also comes at
> a cost, so that we may not see a benefit compared to calling
> local_irq_save/local_irq_restore.
> 
> If more or less all users have to switch back, then the question is
> whether we should remove __napi_schedule_irqoff.
> Instead of touching all users we could make  __napi_schedule_irqoff
> an alias for __napi_schedule for now.
> 
> [0] https://lkml.org/lkml/2020/10/8/706

We're effectively calling raise_softirq_irqoff() from IRQ handlers,
with force_irqthreads == true that's no longer legal.

Thomas - is the expectation that IRQ handlers never assume they have 
IRQs disabled going forward? We don't have any performance numbers 
but if I'm reading Agner's tables right POPF is 18 cycles on Broadwell.
Is PUSHF/POPF too cheap to bother?

Otherwise a non-solution could be to make IRQ_FORCED_THREADING
configurable.
