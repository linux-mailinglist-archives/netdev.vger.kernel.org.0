Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CE12D7DD5
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393145AbgLKSNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390729AbgLKSNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:13:04 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68517C0613CF;
        Fri, 11 Dec 2020 10:12:24 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id s21so7450492pfu.13;
        Fri, 11 Dec 2020 10:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q/1zdMH3DpxGtZ8QgtITmolgonObU/7AjOPUuWKrWNo=;
        b=Pm8buLXst2LcV9x4pk4vIxyybuwSbvL97o6tQP/6i0ZC0zOJ6xhhPvOmmJHnVFkhgw
         sQfgcxJImHA+DnVZbZxb64zhatDbthp68cZ4iRaEqM/K8XSe9UZnfE94uYtkDbOOpabu
         L1rj/JPmJET4DAk/lcrawpEkrx9i3ul2i6qGlaQuFoK2UkPf+SMWdOeOPPS8QAdKSG2Q
         g24KIZVw1nm3kfJCayecl50J7bltlRshvQcWiGMUSmazoa8KfAW/iwqyejRvRxGzsh3A
         q/OBzRHzggVvK36H+lQNs9ICk+Z16dfzwLBUVGvlOwEUqmBMnCQtHV8wDQuwIxn+Jo8v
         0Yfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q/1zdMH3DpxGtZ8QgtITmolgonObU/7AjOPUuWKrWNo=;
        b=EUUxuVDwUWkj1VArEtjSBAzqeN4Wr6zM05G+Q3mhyiAFFwoot0Tjkm3KXPYozOD/xr
         86NeIsAM8IDCmetb9oFwO7zyiphFE5DUt4+ORhznegIu4TRh0WU0TlpNEK+cgdNJNkmI
         B1zK7w2FH1XQwMIOHWK4VsMbpXa803wM+hRRf0Y8QGQpHZOT8svJNXzrm+UDXHM/4gLw
         UMMLOsnR1opUvQ27r5JYsBE09ElPEDJej9h2Rtb7vEP07p40Ol0yHrsfc/+JTjfU4Xpo
         zSsGg2zHm4ifwozvvG1U+BS9+++ABI5xWdVi7CuzGpqAZyBB7erM/tgI3wpkUwrJiynZ
         72Ng==
X-Gm-Message-State: AOAM530wzfZyvYP8kvZQqBiDlVHVmCQaNvNQShgjEYbz+ZgL6ANmMuCa
        6AQKarhTbx0Jga4itoXmo5MQmDtx31BldQk7wZeN5o4nx2lt2mU9
X-Google-Smtp-Source: ABdhPJzPNFm8swDHOmLl35eT5h+YQB676NTtT2BWFgfALxfYZ8r2UnWa+iJwNQSLiKZOMQcPIak2nNSo7eC4Ue1vtXA=
X-Received: by 2002:a63:4002:: with SMTP id n2mr13054398pga.4.1607710343875;
 Fri, 11 Dec 2020 10:12:23 -0800 (PST)
MIME-Version: 1.0
References: <20201210192536.118432146@linutronix.de> <20201210194044.157283633@linutronix.de>
In-Reply-To: <20201210194044.157283633@linutronix.de>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 11 Dec 2020 20:12:07 +0200
Message-ID: <CAHp75Veo9aQLCp9ZuCcoexPLHM=R_PEu6uhP_P2bSpsVzyUaNQ@mail.gmail.com>
Subject: Re: [patch 16/30] mfd: ab8500-debugfs: Remove the racy fiddling with irq_desc
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 9:57 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> First of all drivers have absolutely no business to dig into the internals
> of an irq descriptor. That's core code and subject to change. All of this
> information is readily available to /proc/interrupts in a safe and race
> free way.
>
> Remove the inspection code which is a blatant violation of subsystem
> boundaries and racy against concurrent modifications of the interrupt
> descriptor.
>
> Print the irq line instead so the information can be looked up in a sane
> way in /proc/interrupts.

...

> -               seq_printf(s, "%3i:  %6i %4i",
> +               seq_printf(s, "%3i:  %6i %4i %4i\n",

Seems different specifiers, I think the intention was something like
               seq_printf(s, "%3i:  %4i %6i %4i\n",

>                            line,
> +                          line + irq_first,
>                            num_interrupts[line],
>                            num_wake_interrupts[line]);


-- 
With Best Regards,
Andy Shevchenko
