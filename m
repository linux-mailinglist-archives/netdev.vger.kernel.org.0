Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0510D391229
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 10:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhEZIUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 04:20:12 -0400
Received: from mail-vs1-f53.google.com ([209.85.217.53]:44981 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhEZIUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 04:20:11 -0400
Received: by mail-vs1-f53.google.com with SMTP id i29so269451vsr.11;
        Wed, 26 May 2021 01:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cwJrjJPn4XdJtdaNHc/uwJ41Erytueup9SA7gWbLwLc=;
        b=TknXp62Tjdb47E3sod/c1NOiYYHO++PTLTTWUJX+idsZnBM6TlK+rPjtrMshFThGOM
         abPpAvRNdbOyIaX2o+bUmETZIhzLzePKfK9DHMgihVnqHE/Bb5hJUCmkde6ssKEX1pBA
         Cj8ex/3+TI9m5p7nUHTN6calnOWMoJJfMTdIIyLjwKKsohApGRgi8KFk3t75/A6wzLZ3
         tIa8KT5xjnC8XZrAjX9B1EHC6Gy5qJMvpz/hD5ak9zLqiRG6QC/d2KSrA04/ipMh4VPa
         Qbcbw2bmk+1cgUAQKE+rzWa0tFGoeMNF5qJK8lQwwgUetVMvZYa/3/EnR/S1+xFaht26
         tZRw==
X-Gm-Message-State: AOAM5327cB3tMOp6D02b/MAH/9MGXjv6b2095JOT+5UBgxfpuesmEYZX
        OjidG/3HDJqhAh+HBX/96JqEtI1gNaHpR4HjQvI=
X-Google-Smtp-Source: ABdhPJyBP43fy0z/xLr24CBnaFxqMibw4+PtPqA/CPHen7oIzefuWsMGVqm5mGd8u6JPJ0dQP9MmoI2MjgM94cpGp3U=
X-Received: by 2002:a67:3c2:: with SMTP id 185mr30138437vsd.42.1622017119229;
 Wed, 26 May 2021 01:18:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210330145430.996981-1-maz@kernel.org> <20210330145430.996981-8-maz@kernel.org>
 <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
 <6c522f8116f54fa6f23a2d217d966c5a@kernel.org> <CAMuHMdWzBqLVOVn_z8S2H-x-kL+DfOsM5mDb_D8OKsyRJtKpdA@mail.gmail.com>
 <8735u9x6sb.wl-maz@kernel.org>
In-Reply-To: <8735u9x6sb.wl-maz@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 26 May 2021 10:18:27 +0200
Message-ID: <CAMuHMdUBwcB-v0ugCPB3D6dbttiSbqQeHgNrr+r331ntRrfiAw@mail.gmail.com>
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

On Wed, May 26, 2021 at 10:01 AM Marc Zyngier <maz@kernel.org> wrote:
> On Wed, 26 May 2021 08:52:42 +0100,
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, May 11, 2021 at 11:13 AM Marc Zyngier <maz@kernel.org> wrote:
> > > On 2021-05-11 10:07, Geert Uytterhoeven wrote:
> > > > On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
> > > >> From: Jianyong Wu <jianyong.wu@arm.com>
> > > >
> > > >> --- a/drivers/ptp/Kconfig
> > > >> +++ b/drivers/ptp/Kconfig
> > > >> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
> > > >>  config PTP_1588_CLOCK_KVM
> > > >>         tristate "KVM virtual PTP clock"
> > > >>         depends on PTP_1588_CLOCK
> > > >> -       depends on KVM_GUEST && X86
> > > >> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY &&
> > > >> ARM_ARCH_TIMER)
> > > >
> > > > Why does this not depend on KVM_GUEST on ARM?
> > > > I.e. shouldn't the dependency be:
> > > >
> > > >     KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))
> > > >
> > > > ?
> > >
> > > arm/arm64 do not select KVM_GUEST. Any kernel can be used for a guest,
> > > and KVM/arm64 doesn't know about this configuration symbol.
> >
> > OK.
> >
> > Does PTP_1588_CLOCK_KVM need to default to yes?
> > Perhaps only on X86, to maintain the status quo?
>
> I think I don't really understand the problem you are trying to
> solve. Is it that 'make oldconfig' now asks you about this new driver?
> Why is that an issue?

My first "problem" was that it asked about this new driver on
arm/arm64, while I assumed there were some missing dependencies
(configuring a kernel should not ask useless questions).  That turned
out to be a wrong assumption, so there is no such problem here.

The second problem is "default y": code that is not critical should
not be enabled by default.  Hence my last question.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
