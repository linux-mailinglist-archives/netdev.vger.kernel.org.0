Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C015639118F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 09:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhEZHya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 03:54:30 -0400
Received: from mail-ua1-f52.google.com ([209.85.222.52]:34546 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhEZHyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 03:54:25 -0400
Received: by mail-ua1-f52.google.com with SMTP id x1so287942uau.1;
        Wed, 26 May 2021 00:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DF4Qym5vi5urmQVozT7x89feYVqRBLX860c1iUhsLiU=;
        b=YzPVqcY1EPZbaSCvOFGIgiiu8fiZbg23q0itrX0saQgR0RC2NdOe5weYcHR2TC1WUJ
         tj/RqrjAY0a6KwH5mM0ge2ust62kc9dqk6VTt7lgY7WJdBRcjzTnqV1FpkzvSnZ9eqiD
         Emgt/9b+ss1NCdhhnD4ZjNJ09d5pa7uuCZVOoLJziJMUBkwxW63KoYD+u3O5LosX/NaK
         Pwo1oh4Lm9Rj+GJ2GvWtWJWE8NXaQHF6ffRl5VaEzohtx0VOqXHh7KSt6pAgauYvdJSH
         tJlRD/4seN1HvODGVKrCm5zU6PTZmEVdfa3OxlwlTKtRwkddsrmAemtmeTaF1yGP0bf5
         eK5A==
X-Gm-Message-State: AOAM5324tQN9FLCLU9Z5CHomQvW2a/TzMdG8DOkLdnQCaYFN/khIz3tK
        veEJqwooJkfHglTTPgcH3tSUYvWrl7LzytuVDMk=
X-Google-Smtp-Source: ABdhPJxZSU7OcT6+Xw6agQLX8qT6DqdHwFEcdKKd93N3mCPT/ubOM0JdG4oGvbsyUb2+YK1Dc2xb1IMQ8nAWxqjy1SU=
X-Received: by 2002:a1f:9505:: with SMTP id x5mr26222492vkd.6.1622015574205;
 Wed, 26 May 2021 00:52:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210330145430.996981-1-maz@kernel.org> <20210330145430.996981-8-maz@kernel.org>
 <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com> <6c522f8116f54fa6f23a2d217d966c5a@kernel.org>
In-Reply-To: <6c522f8116f54fa6f23a2d217d966c5a@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 26 May 2021 09:52:42 +0200
Message-ID: <CAMuHMdWzBqLVOVn_z8S2H-x-kL+DfOsM5mDb_D8OKsyRJtKpdA@mail.gmail.com>
Subject: Re: [PATCH v19 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
To:     Marc Zyngier <maz@kernel.org>
Cc:     jianyong.wu@arm.com, netdev <netdev@vger.kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>,
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

Hi Marc,

On Tue, May 11, 2021 at 11:13 AM Marc Zyngier <maz@kernel.org> wrote:
> On 2021-05-11 10:07, Geert Uytterhoeven wrote:
> > On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
> >> From: Jianyong Wu <jianyong.wu@arm.com>
> >>
> >> Currently, there is no mechanism to keep time sync between guest and
> >> host
> >> in arm/arm64 virtualization environment. Time in guest will drift
> >> compared
> >> with host after boot up as they may both use third party time sources
> >> to correct their time respectively. The time deviation will be in
> >> order
> >> of milliseconds. But in some scenarios,like in cloud environment, we
> >> ask
> >> for higher time precision.
> >>
> >> kvm ptp clock, which chooses the host clock source as a reference
> >> clock to sync time between guest and host, has been adopted by x86
> >> which takes the time sync order from milliseconds to nanoseconds.
> >>
> >> This patch enables kvm ptp clock for arm/arm64 and improves clock sync
> >> precision
> >> significantly.
> >
> >> --- a/drivers/ptp/Kconfig
> >> +++ b/drivers/ptp/Kconfig
> >> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
> >>  config PTP_1588_CLOCK_KVM
> >>         tristate "KVM virtual PTP clock"
> >>         depends on PTP_1588_CLOCK
> >> -       depends on KVM_GUEST && X86
> >> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY &&
> >> ARM_ARCH_TIMER)
> >
> > Why does this not depend on KVM_GUEST on ARM?
> > I.e. shouldn't the dependency be:
> >
> >     KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))
> >
> > ?
>
> arm/arm64 do not select KVM_GUEST. Any kernel can be used for a guest,
> and KVM/arm64 doesn't know about this configuration symbol.

OK.

Does PTP_1588_CLOCK_KVM need to default to yes?
Perhaps only on X86, to maintain the status quo?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
