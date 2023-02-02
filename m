Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AC26883C0
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjBBQJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBBQJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:09:27 -0500
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CC73A94;
        Thu,  2 Feb 2023 08:09:27 -0800 (PST)
Received: by mail-qt1-f172.google.com with SMTP id bb40so2374557qtb.2;
        Thu, 02 Feb 2023 08:09:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/QAeQ3Kkm7/RsqNwoFstmAPduPZDtB8HYzFuUHQl5KE=;
        b=WXLT6tkGom9vU1kB5dQwk5uKPTy/j5Oe4VkcPVfylwUnmOzIQDF/RiXPQZgGieVadV
         Pf+IrQJq6ImsHoW1RcEJwi3lgLGTIwF4buvWECOJ2DPoj5GU3qLJnloxZp3NvWyx0x+J
         ieGAFYGTSk4940odapHt0A/pVjo4S3Vvo8B/Srx2A0A/zpaQ7Ww4a9jb1B5zL/VWUvC+
         I7x286hUb4GiNcU13FvvLEdrXm2Pv9v1BwxoyscFKpsv/m44P3zxykbWw2TyhPninf3g
         iP+PN2dB6dKyncw39Mc/FRCSUfeeQWY6pGa6vRP3Pyvho6w702LurtpQ7IbLC8uNss+T
         gptQ==
X-Gm-Message-State: AO0yUKXrERcpsFVTlPZunhckLOqXMhyvf/R58l2CGC+/UMJHzgqdJPEd
        hDz/wpnzRajiz6mFIKY6yXHg0GyiwpNB4g==
X-Google-Smtp-Source: AK7set9WxYslMiZ8eQe5WBqWwC/8m4fh4mDdxHjYDbQ+jkmhlwLfOMSmcOGqTNg0IuN1h0hPEsj5+A==
X-Received: by 2002:ac8:5785:0:b0:3b8:6c68:e6d with SMTP id v5-20020ac85785000000b003b86c680e6dmr3573311qta.13.1675354165801;
        Thu, 02 Feb 2023 08:09:25 -0800 (PST)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id a143-20020ae9e895000000b006ff8a122a1asm5743099qkg.78.2023.02.02.08.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 08:09:25 -0800 (PST)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-5063029246dso32651777b3.6;
        Thu, 02 Feb 2023 08:09:24 -0800 (PST)
X-Received: by 2002:a81:c604:0:b0:506:6059:e949 with SMTP id
 l4-20020a81c604000000b005066059e949mr593429ywi.502.1675354164599; Thu, 02 Feb
 2023 08:09:24 -0800 (PST)
MIME-Version: 1.0
References: <68bd1e34-4251-4306-cc7d-e5ccc578acd9@gmail.com> <585c4b48790d71ca43b66fc24ea8d84917c4a0e1.camel@physik.fu-berlin.de>
In-Reply-To: <585c4b48790d71ca43b66fc24ea8d84917c4a0e1.camel@physik.fu-berlin.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 2 Feb 2023 17:09:13 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXPSh6u3FmMW002-fML2CMMs7ZO4a1-05nBHZo_dndb_A@mail.gmail.com>
Message-ID: <CAMuHMdXPSh6u3FmMW002-fML2CMMs7ZO4a1-05nBHZo_dndb_A@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adrian,

On Thu, Feb 2, 2023 at 3:11 PM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> > Now that we have devm_clk_get_optional_enabled(), we don't have to
> > open-code it.
> >
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c

> > @@ -5216,9 +5185,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >               return -ENOMEM;
> >
> >       /* Get the *optional* external "ether_clk" used on some boards */
> > -     rc = rtl_get_ether_clk(tp);
> > -     if (rc)
> > -             return rc;
> > +     tp->clk = devm_clk_get_optional_enabled(&pdev->dev, "ether_clk");
> > +     if (IS_ERR(tp->clk))
> > +             return dev_err_probe(&pdev->dev, PTR_ERR(tp->clk), "failed to get ether_clk\n");
> >
> >       /* enable device (incl. PCI PM wakeup and hotplug setup) */
> >       rc = pcim_enable_device(pdev);
> > --
> > 2.37.3
>
> This change broke the r8169 driver on my SH7785LCR SuperH Evaluation Board.
>
> With your patch, the driver initialization fails with:
>
> [    1.648000] r8169 0000:00:00.0: error -EINVAL: failed to get ether_clk
> [    1.676000] r8169: probe of 0000:00:00.0 failed with error -22
>
> Any idea what could be the problem?

SH's clk_enable() returns -EINVAL if clk == NULL, which is wrong.
Preparing a patch...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
