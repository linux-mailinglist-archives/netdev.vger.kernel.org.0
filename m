Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D985EFE0A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 21:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiI2TgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 15:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiI2TgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 15:36:01 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2D75F9A6;
        Thu, 29 Sep 2022 12:35:59 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id k12so1517246qkj.8;
        Thu, 29 Sep 2022 12:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=mTAlcKpePLUmoa2PPlLgnnpbbR37vsLCkLJsK3FMOMM=;
        b=zonwpLQcKQG+p2EU8QstcgW8hyoj+hCye+Gp+61vVgzBiB56Aubi5H1NSfomPzhVsA
         Zxro0mDXhF9BDRkdtR1Pjgrbo4vANCoeGbndss/IRw3qq7TuNlMTkIFbLBpswp13mvtt
         kK0gYEwokxJPlqpr8FAG+t1LaEBKxdxmrIyVkxLdwrUP37mG2ZwwFbmHMKt+pBFXdOst
         8MzsJniTYqeFtIxm7e3sVgZANp37M5v4hSQ53mh56YUzN+IIh/nWd4TVba9h0mi2KyoV
         Dz77r5JHBkMVnjEMWaVVfOGIzHc+UKx8evxnRkHK6tmgi9gMZiA/TWPpPMQhq4MrvDdV
         BGHQ==
X-Gm-Message-State: ACrzQf11s1ZFzyh6D7Auax7/3wMtv0laiaSaLNiEljkKcUcGwuUC/8YT
        jThOBetiYo28V+NwTDT0xA0kKbSCujtI9zLOQkA=
X-Google-Smtp-Source: AMsMyM6nwPbbMnzN+TFVkeFoMqPTRrzMun/9SaGI62vQ28n3j95zFU2xk6dTQ3pv+9rh/XRcMovC6IXcuteR1RYwINI=
X-Received: by 2002:a05:620a:290d:b0:6b6:1a92:d88a with SMTP id
 m13-20020a05620a290d00b006b61a92d88amr3634308qkp.58.1664480158981; Thu, 29
 Sep 2022 12:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220928210059.891387-1-daniel.lezcano@linaro.org>
 <d0be3159-8094-aed1-d9b1-c4b16d88d67c@linaro.org> <CAJZ5v0hOFoe0KqEimFv9pgmiAOzuRoLjdqoScr53ErNFU4AAPA@mail.gmail.com>
 <ae86fc5a-0521-3dde-c2ea-8679c0ec4831@linaro.org>
In-Reply-To: <ae86fc5a-0521-3dde-c2ea-8679c0ec4831@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 29 Sep 2022 21:35:48 +0200
Message-ID: <CAJZ5v0jrWamTTXcHabSk=6cmm4pEx0_ebiECKZRfrX_vS85YYg@mail.gmail.com>
Subject: Re: [PATCH v7 00/29] Rework the trip points creation
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 4:57 PM Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
>
> On 29/09/2022 15:58, Rafael J. Wysocki wrote:
> > On Thu, Sep 29, 2022 at 2:26 PM Daniel Lezcano
> > <daniel.lezcano@linaro.org> wrote:
> >>
> >>
> >> Hi Rafael,
> >>
> >> are you happy with the changes?
> >
> > I'll have a look and let you know.
>
> Great, thanks

Well, because you have not added the history of changes to the
patches, that will take more time than it would otherwise.

Generally, please always add information on what has changed in the
patch between different versions of it.

> >> I would like to integrate those changes with the thermal pull request
> >
> > Sure, but it looks like you've got only a few ACKs for these patches
> > from the driver people.
> >
> > Wouldn't it be prudent to give them some more time to review the changes?
>
> Well I would say I received the ACKs from the drivers which are actively
> maintained. Others are either not with a dedicated maintainer or not a
> reactive one. The first iteration of the series is from August 5th. So
> it has been 2 months.
>
> I pinged for imx, armada and tegra two weeks ago.

OK

> The st, hisilicon drivers fall under the thermal maintainers umbrella
>
> There are three series coming after this series to be posted. I would
> like to go forward in the process of cleaning up the framework. IMO two
> months is enough to let the maintainers pay attention to the changes,
> especially if we do a gentle ping and there are seven versions.
>
> And after that comes the thermal_zone_device_register() parameters
> simplification :)

Well, that's all fine, but I don't want people to get surprised by
significant changes they haven't expected and I want to avoid missing
anything subtle.
