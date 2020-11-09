Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAD82ABE3A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgKIOHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:07:25 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37094 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgKIOHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:07:24 -0500
Received: by mail-ot1-f66.google.com with SMTP id l36so9012829ota.4;
        Mon, 09 Nov 2020 06:07:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qItS/x3JE/SvOZ8YtwxUA1cr4KrrSfqUypilCfxyhBs=;
        b=MQmFP0DczI7zAEQtoQK9wHdyxL9q8rfpTYx7HtgpewyUdxHk4yvfaWwxDM9CpjytwD
         gcBCMv5taPKM3oiS92H2eM80EMfC4Xf/OzrxQMHqnT5M5LWBXW9FJmO5rwSJElyMoo1x
         AU04O3g3XJ9TpXgcjVmIdRltfOqfdpezepRrSnIUXsnQBL7BqBZpDvUJed8MpvbZAI7T
         ++pkngWrrR4TowI4gbaylHegugyFPtEUO5HSTxg7JWKoUznHPX77gTg8B5rpzdpelHlb
         cXnWD+2WC4igC+ZnO7GN+XvUg21Z5BL8YrVEedO5Ay9LJLOGgdgdV593Lhxp1/eEh+Mc
         sDAg==
X-Gm-Message-State: AOAM533/AdGrFyBkWYksKlcBTI/QyDTnvh/+4w8hgv1YKY4BMj03RWrJ
        bv/bpKMeiEVyeMESGpyDc/wlwBzokXmQbLGdzEc=
X-Google-Smtp-Source: ABdhPJzgpYehEI3SdWXufFS9I1mYiO0GDqKZkPYcEO+iAW/ctyCqn4R6pQaOmq/WsKVHPGdGtK400/DgPWks9pWC8H8=
X-Received: by 2002:a9d:16f:: with SMTP id 102mr11137585otu.206.1604930841719;
 Mon, 09 Nov 2020 06:07:21 -0800 (PST)
MIME-Version: 1.0
References: <20201109080938.4174745-1-zhangqilong3@huawei.com>
 <20201109080938.4174745-2-zhangqilong3@huawei.com> <CAJZ5v0gZp_R60FN+ZrKmEn+m0F4yjt_MB+N8uGG=fxKUnZdknQ@mail.gmail.com>
 <d05e3d35a68e41e2ac36acfcd577ad47@huawei.com> <CAJZ5v0hpNNAyRuQyMbOE2Lwer_uJbC0uTpnpCBpPNTv54_fxRg@mail.gmail.com>
 <bf9325b7c3e04691a215fb16a133d536@huawei.com>
In-Reply-To: <bf9325b7c3e04691a215fb16a133d536@huawei.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 9 Nov 2020 15:07:10 +0100
Message-ID: <CAJZ5v0ggJCFqqmFVGmxEf2MRckLU6GsF=V=cnzfveyOqOMfVZg@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM: runtime: Add a general runtime get sync operation
 to deal with usage counter
To:     zhangqilong <zhangqilong3@huawei.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 2:46 PM zhangqilong <zhangqilong3@huawei.com> wrote:
>
> Hi,
>
> >
> > On Mon, Nov 9, 2020 at 2:24 PM zhangqilong <zhangqilong3@huawei.com>
> > wrote:
> > >
> > > Hi
> > > >
> > > > On Mon, Nov 9, 2020 at 9:05 AM Zhang Qilong
> > > > <zhangqilong3@huawei.com>
> > > > wrote:
> > > > >
> > > > > In many case, we need to check return value of
> > > > > pm_runtime_get_sync, but it brings a trouble to the usage counter
> > > > > processing. Many callers forget to decrease the usage counter when
> > > > > it failed. It has been discussed a lot[0][1]. So we add a function
> > > > > to deal with the usage counter for better coding.
> > > > >
> > > > > [0]https://lkml.org/lkml/2020/6/14/88
> > > > > [1]https://patchwork.ozlabs.org/project/linux-tegra/patch/20200520
> > > > > 0951 48.10995-1-dinghao.liu@zju.edu.cn/
> > > > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > > > > ---
> > > > >  include/linux/pm_runtime.h | 32
> > ++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 32 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/pm_runtime.h
> > > > > b/include/linux/pm_runtime.h index 4b708f4e8eed..2b0af5b1dffd
> > > > > 100644
> > > > > --- a/include/linux/pm_runtime.h
> > > > > +++ b/include/linux/pm_runtime.h
> > > > > @@ -386,6 +386,38 @@ static inline int pm_runtime_get_sync(struct
> > > > > device
> > > > *dev)
> > > > >         return __pm_runtime_resume(dev, RPM_GET_PUT);  }
> > > > >
> > > > > +/**
> > > > > + * gene_pm_runtime_get_sync - Bump up usage counter of a device
> > > > > +and
> > > > resume it.
> > > > > + * @dev: Target device.
> > > >
> > > > The force argument is not documented.
> > >
> > > (1) Good catch, I will add it in next version.
> > >
> > > >
> > > > > + *
> > > > > + * Increase runtime PM usage counter of @dev first, and carry out
> > > > > + runtime-resume
> > > > > + * of it synchronously. If __pm_runtime_resume return negative
> > > > > + value(device is in
> > > > > + * error state) or return positive value(the runtime of device is
> > > > > + already active)
> > > > > + * with force is true, it need decrease the usage counter of the
> > > > > + device when
> > > > > + * return.
> > > > > + *
> > > > > + * The possible return values of this function is zero or negative value.
> > > > > + * zero:
> > > > > + *    - it means success and the status will store the resume operation
> > > > status
> > > > > + *      if needed, the runtime PM usage counter of @dev remains
> > > > incremented.
> > > > > + * negative:
> > > > > + *    - it means failure and the runtime PM usage counter of @dev has
> > > > been
> > > > > + *      decreased.
> > > > > + * positive:
> > > > > + *    - it means the runtime of the device is already active before that.
> > If
> > > > > + *      caller set force to true, we still need to decrease the usage
> > > > counter.
> > > >
> > > > Why is this needed?
> > >
> > > (2) If caller set force, it means caller will return even the device
> > > has already been active (__pm_runtime_resume return positive value)
> > > after calling gene_pm_runtime_get_sync, we still need to decrease the
> > usage count.
> >
> > But who needs this?
> >
> > I don't think that it is a good idea to complicate the API this way.
>
> The callers like:
> ret = pm_runtime_get_sync(dev);
> if (ret) {
>         ...
>         return (xxx);
> }

Which isn't correct really, is it?

If ret is greater than 0, the error should not be returned in the
first place, so you may want the new wrapper to return zero in that
case instead.

> drivers/spi/spi-img-spfi.c:734 img_spfi_resume() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/mfd/arizona-core.c:49 arizona_clk32k_enable() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/usb/dwc3/dwc3-pci.c:212 dwc3_pci_resume_work() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/input/keyboard/omap4-keypad.c:279 omap4_keypad_probe() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/gpu/drm/vc4/vc4_dsi.c:839 vc4_dsi_encoder_enable() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/gpu/drm/i915/selftests/mock_gem_device.c:157 mock_gem_device() warn: 'pm_runtime_get_sync(&pdev->dev)' returns positive and negative
> drivers/watchdog/rti_wdt.c:230 rti_wdt_probe() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/media/platform/exynos4-is/mipi-csis.c:513 s5pcsis_s_stream() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c:89 mtk_vcodec_dec_pw_on() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/media/platform/ti-vpe/cal.c:794 cal_probe() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/media/platform/ti-vpe/vpe.c:2478 vpe_runtime_get() warn: pm_runtime_get_sync() also returns 1 on success
> drivers/media/i2c/smiapp/smiapp-core.c:1529 smiapp_pm_get_init() warn: pm_runtime_get_sync() also returns 1 on success
> ...
> they need it to simplify the function.
>
> If we only want to simplify like
> ret = pm_runtime_get_sync(dev);
> if (ret < 0) {
>         ...
>         Return (xxx)
> }
> The parameter force could be removed.

Which is exactly my point.
