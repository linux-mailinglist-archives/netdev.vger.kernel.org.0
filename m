Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27D537A301
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhEKJJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:09:21 -0400
Received: from mail-vs1-f52.google.com ([209.85.217.52]:45980 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhEKJJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 05:09:18 -0400
Received: by mail-vs1-f52.google.com with SMTP id x188so4253750vsx.12;
        Tue, 11 May 2021 02:08:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VWZENhS44KnEbYhJ55uNu4C5dSY972Eyg88PLcY/zho=;
        b=ZYteCF6VMnbzLPAL9iAFHg4dIeYly3O1jQ5AW5JJ2oPvkDf9qaHUYPPSTqgNsxT5sH
         z3T+D/pKNKeSsu6YOS9dBxElcxnKDvYdOPgcyDCb/u+Rjyfpj745mOZI32j9IjihwyUr
         18QVNg5hgXGFGwhICErwrs1obuxQToEcdsLOybILakDy3FOXo5qg9Unde5N9jpGNBfOg
         ksriRNSbrosR5iE6bMuQAlm+SInUEV4H0lm9pFhk+oCD0yP23p/y3/6M5kGXwnXTYgNz
         2yQHWt/hx0eOG6fgVYxpn8Wuy1dv/f+HlL2gT5ilUwr//ZgxrlhnrNooAhGHlRhAGFyS
         YgiQ==
X-Gm-Message-State: AOAM532nrO/G0LpWV4ZfZEqMlg+EpjJ40uVfT8BX5GGt+EPxoDpKK11r
        EdBs9u0cwCTCCcNf2gDYQKoQKiMkGjRtKiOxI+M=
X-Google-Smtp-Source: ABdhPJweTlTBbaLMWAGki0KxVFdQqpl/ZcfogWI1Lhfowsw6ZamthDcv+jjw6/wD3nCQ2Fi0vyUoOcx9OTMR/abE99c=
X-Received: by 2002:a67:3113:: with SMTP id x19mr17992653vsx.40.1620724090696;
 Tue, 11 May 2021 02:08:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210330145430.996981-1-maz@kernel.org> <20210330145430.996981-8-maz@kernel.org>
In-Reply-To: <20210330145430.996981-8-maz@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 11 May 2021 11:07:59 +0200
Message-ID: <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
Subject: Re: [PATCH v19 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
To:     Marc Zyngier <maz@kernel.org>, jianyong.wu@arm.com
Cc:     netdev <netdev@vger.kernel.org>, Yangbo Lu <yangbo.lu@nxp.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, KVM list <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>, justin.he@arm.com,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc, Jianyong,

On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
> From: Jianyong Wu <jianyong.wu@arm.com>
>
> Currently, there is no mechanism to keep time sync between guest and host
> in arm/arm64 virtualization environment. Time in guest will drift compared
> with host after boot up as they may both use third party time sources
> to correct their time respectively. The time deviation will be in order
> of milliseconds. But in some scenarios,like in cloud environment, we ask
> for higher time precision.
>
> kvm ptp clock, which chooses the host clock source as a reference
> clock to sync time between guest and host, has been adopted by x86
> which takes the time sync order from milliseconds to nanoseconds.
>
> This patch enables kvm ptp clock for arm/arm64 and improves clock sync precision
> significantly.

> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
>  config PTP_1588_CLOCK_KVM
>         tristate "KVM virtual PTP clock"
>         depends on PTP_1588_CLOCK
> -       depends on KVM_GUEST && X86
> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER)

Why does this not depend on KVM_GUEST on ARM?
I.e. shouldn't the dependency be:

    KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))

?

>         default y
>         help
>           This driver adds support for using kvm infrastructure as a PTP

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
