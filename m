Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2684D688441
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjBBQXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjBBQXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:23:34 -0500
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4815965F08;
        Thu,  2 Feb 2023 08:23:17 -0800 (PST)
Received: by mail-qt1-f174.google.com with SMTP id c2so2411063qtw.5;
        Thu, 02 Feb 2023 08:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3o2EroZCzQkw5bl7REHapR8H4IjY3ZfW6rLXV2KsyK8=;
        b=cFB2MG72IrHouIWxXWxpPNnbKMWRA8Oo7ZRPVBr9HJKGU6mECmlCwIpzP1B72mcPU2
         gZkpmmP5922ZXLJP7Gj5KBabWJ4Xq94NwFqT2fTOTRZjzUHanSyIszA20paOGudduTKo
         hbfyhEfcF8bMcbGmPdAbLUcvc9izACUtoFSzctrLYgmjX6Tl34tfOCTopxbsLISXMxR5
         Aqyt3gEU72dt3tTOs+Aqt6hLhyDs0ZSR2KFbsgZVQQ/hw+9IOHcjTQIVvPRzN7XGwFj0
         sq6IEp0IGYX3toYN7WEc+B8t1pkM042AMOaOxrsIGxB+hQ0ylIr/OGH8L6sZ5OF7nzX5
         /YJg==
X-Gm-Message-State: AO0yUKXfuhc/9wwfyVEmeEmYi2FU7cwaw92AzMEWFsbnxfDEv+qcbWNN
        A0OA+y2y450KQtXXb4jxz+dzOGvgl6Zi9Q==
X-Google-Smtp-Source: AK7set9RmK8xVD098mvrlh8uWbfV5wtkRqOoEYi/ZgUSq8vCVrhgD2LlzG6chrMe01BWb9Y8KTrHRA==
X-Received: by 2002:a05:622a:1046:b0:3b7:ed2c:fbb7 with SMTP id f6-20020a05622a104600b003b7ed2cfbb7mr11852965qte.0.1675354943641;
        Thu, 02 Feb 2023 08:22:23 -0800 (PST)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id q20-20020ac84514000000b003b9a50c8fa1sm5914232qtn.87.2023.02.02.08.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 08:22:22 -0800 (PST)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-4b718cab0e4so32979517b3.9;
        Thu, 02 Feb 2023 08:22:22 -0800 (PST)
X-Received: by 2002:a0d:c2c4:0:b0:514:a90f:10ea with SMTP id
 e187-20020a0dc2c4000000b00514a90f10eamr714568ywd.316.1675354942363; Thu, 02
 Feb 2023 08:22:22 -0800 (PST)
MIME-Version: 1.0
References: <68bd1e34-4251-4306-cc7d-e5ccc578acd9@gmail.com>
 <585c4b48790d71ca43b66fc24ea8d84917c4a0e1.camel@physik.fu-berlin.de> <CAMuHMdXPSh6u3FmMW002-fML2CMMs7ZO4a1-05nBHZo_dndb_A@mail.gmail.com>
In-Reply-To: <CAMuHMdXPSh6u3FmMW002-fML2CMMs7ZO4a1-05nBHZo_dndb_A@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 2 Feb 2023 17:22:11 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWSNYantcmNu+43Az8hVGDvXVFVG8pRVr38o-Mqx1AgKg@mail.gmail.com>
Message-ID: <CAMuHMdWSNYantcmNu+43Az8hVGDvXVFVG8pRVr38o-Mqx1AgKg@mail.gmail.com>
Subject: Re: [PATCH net-next] r8169: use devm_clk_get_optional_enabled() to
 simplify the code
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org, nic_swsd@realtek.com,
        pabeni@redhat.com, linux-sh@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 5:09 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Feb 2, 2023 at 3:11 PM John Paul Adrian Glaubitz
> <glaubitz@physik.fu-berlin.de> wrote:
> > > Now that we have devm_clk_get_optional_enabled(), we don't have to
> > > open-code it.
> > >
> > > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>
> > > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > > +++ b/drivers/net/ethernet/realtek/r8169_main.c
>
> > > @@ -5216,9 +5185,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> > >               return -ENOMEM;
> > >
> > >       /* Get the *optional* external "ether_clk" used on some boards */
> > > -     rc = rtl_get_ether_clk(tp);
> > > -     if (rc)
> > > -             return rc;
> > > +     tp->clk = devm_clk_get_optional_enabled(&pdev->dev, "ether_clk");
> > > +     if (IS_ERR(tp->clk))
> > > +             return dev_err_probe(&pdev->dev, PTR_ERR(tp->clk), "failed to get ether_clk\n");
> > >
> > >       /* enable device (incl. PCI PM wakeup and hotplug setup) */
> > >       rc = pcim_enable_device(pdev);
> > > --
> > > 2.37.3
> >
> > This change broke the r8169 driver on my SH7785LCR SuperH Evaluation Board.
> >
> > With your patch, the driver initialization fails with:
> >
> > [    1.648000] r8169 0000:00:00.0: error -EINVAL: failed to get ether_clk
> > [    1.676000] r8169: probe of 0000:00:00.0 failed with error -22
> >
> > Any idea what could be the problem?
>
> SH's clk_enable() returns -EINVAL if clk == NULL, which is wrong.
> Preparing a patch...

https://lore.kernel.org/r/b53e6b557b4240579933b3359dda335ff94ed5af.1675354849.git.geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
