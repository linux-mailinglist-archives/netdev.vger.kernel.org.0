Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF942908AA
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 17:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408459AbgJPPku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 11:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406010AbgJPPku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 11:40:50 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC71C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 08:40:49 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id t21so2907879eds.6
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 08:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Od+DC98/SKKtOrW/sVZoq8hxaBhsTfMOe1o74kbuWao=;
        b=m8iABxwmu8UUpfchiEj762TSKQEe4ZKtWLF7n+ZTjEokDLVa6TyowdWmdhdPD2I+LA
         qVSV92pk1zSj7UX0BcKJ5RTcFnQZZP9Y4pNtb6AF52WbZjZhx+xP8Ab424AHYm86MlDd
         KZ3/Hwhji2i/XQRHGNsi/+rMgaLcNh7JFB5caP807/MhG6sBRuRakgmCw9QTk+WBwa1x
         tTu0BCi8J39SzGkdXt9IrIaKhws4fCTS2QSNPAIW4o/8gpF7PR7GRRO18DhULAMCswdA
         KTLMhSJQdfQiZjNJCBK4LG7V+v684Eei1OB0EoS/719fcFRCHEOzGcFWFOZHYVeY/0FD
         JJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Od+DC98/SKKtOrW/sVZoq8hxaBhsTfMOe1o74kbuWao=;
        b=O/I01opzJd4QeOIN2s8Ba/XPn71u9qORpLyeVtac+GvlBJkar0c/JhDDRQC8/4mrC/
         r3F9H6D86PMTRAGB/P0ww4N552PH4zxVR9j+TWxy+EzWdkr8TwZgxwAdwzgGndr5606B
         /3H2O9uwxiFNKOlrsGfjVh2rOxoDq7TVlPi4erDcdGgcdB156fg0KQgk72CJAhzz18sX
         sXnLhvwgQVjFt5zFUkijkGgfM/1ZlGj3fW+z2vXMDY/0h7V3xhIPsn3KYlKesTWt0dGf
         6ZkrSQ5owvKFb0LOlsHI1H058IQBizy6HbxSmRbmkJaXHbzcXtVZ51Bmxn8Ajpjti2DO
         uEAA==
X-Gm-Message-State: AOAM533QnT4br/lNFuZeZEDzx1kViSFsqoEcalUdJlza5BsmWzgp8MZJ
        iUrRvOUyYKUfY4AJRVdFBqA=
X-Google-Smtp-Source: ABdhPJz7P8+Rx3toEZVs/CL0VKGT65OgJGCU0ptv7RgWzalu2TThsMRFiqXHNUsxouWpfeqfq/40JA==
X-Received: by 2002:aa7:c390:: with SMTP id k16mr4924863edq.40.1602862848451;
        Fri, 16 Oct 2020 08:40:48 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id s1sm1784141edi.44.2020.10.16.08.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 08:40:47 -0700 (PDT)
Date:   Fri, 16 Oct 2020 18:40:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Mike Galbraith <efault@gmx.de>, netdev <netdev@vger.kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Subject: Re: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
Message-ID: <20201016154046.llepbidazcqx7yyj@skbuf>
References: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
 <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
 <20201016142611.zpp63qppmazxl4k7@skbuf>
 <a3c87f21-7e49-99a5-026f-4a24e0cb7a86@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3c87f21-7e49-99a5-026f-4a24e0cb7a86@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 04:41:50PM +0200, Heiner Kallweit wrote:
> On 16.10.2020 16:26, Vladimir Oltean wrote:
> > On Fri, Oct 16, 2020 at 01:34:55PM +0200, Heiner Kallweit wrote:
> >> I'm aware of the topic, but missing the benefits of the irqoff version
> >> unconditionally doesn't seem to be the best option.
> > 
> > What are the benefits of the irqoff version? As far as I see it, the
> > only use case for that function is when the caller has _explicitly_
> > disabled interrupts.
> > 
> If the irqoff version wouldn't have a benefit, then I think we wouldn't
> have it ..
> 
> > The plain napi_schedule call will check if irqs are disabled. If they
> > are, it won't do anything further in that area. There is no performance
> > impact except for a check.
> > 
> There is no such check, and in general currently attempts are made to
> remove usage of e.g. in_interrupt(). napi_schedule() has additional calls
> to local_irq_save() and local_irq_restore().

This has nothing to do with in_interrupt().

Now, to explain where my confusion came from.
arm64 has this:

static inline unsigned long arch_local_irq_save(void)
{
	unsigned long flags;

	flags = arch_local_save_flags();

	/*
	 * There are too many states with IRQs disabled, just keep the current
	 * state if interrupts are already disabled/masked.
	 */
	if (!arch_irqs_disabled_flags(flags))
		arch_local_irq_disable();

	return flags;
}

I just thought that the generic implementation had the "if" too.
