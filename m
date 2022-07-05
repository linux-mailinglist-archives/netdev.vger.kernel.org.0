Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C500756770C
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbiGETA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiGETA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:00:57 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD9110562;
        Tue,  5 Jul 2022 12:00:56 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id n15so15667266ljg.8;
        Tue, 05 Jul 2022 12:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WEj3MTeauhExkBserJBm2mHNQmfNXNb400mZ4q4xVQU=;
        b=e5skRiv7zczl7Whp4FFH9dAke4mOOkz4WwNSJe5yk6Hj3c0o1cd7oqIYD5ltGWMWN4
         HQguZDg1AAEHwpSMIPJ4nBjLtr+AwGCgVEyl0E7Xdt1Oyj1ruGUBuS1STjnx376aEvcD
         R5kvV7pQacl2DOjysQyhIIZUX9IM0de3gO2d3eSekt2TaNqvsclWrrgkeYjQvmvIEiMH
         q2mdlDUPHN2ld++lK00cpiZy5Ne6dtCIFO/2HPKUMyS0ydW3hOcVTTiRRuDnZ9myq+Y9
         8jNloEsioFjkDosa1ivZhGVdj2F1vFkC/BWpn2IcleewUIQ2rCIwIM4615qI/GAN0zGW
         UiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WEj3MTeauhExkBserJBm2mHNQmfNXNb400mZ4q4xVQU=;
        b=1NQeqDIjXAl31HC1cKwKakrmQGG0OeugG8CYmu/Pk0R0jfm7VAm8crPABrQm/7b2lA
         JPM0JtEzjuAXqXfhlO35DrHnn/5toce5CAq8MwK7mEKKue1JX8VGg23+unyyqexGgu8M
         dUaPw9A+jrn4bLabehvUy1sJXIRToV+m0XGLEsrFJ59vV+EtAd+kiHlAhujiUEq+xEIP
         2TJPvOa6wnnit4zI7ImeRsRuXab7vQi2r2QN6DKluTShk/LpJHZdB6bOFjFprGlBMTim
         J9I9n5M0IavvrQsHrPXgXAVoP4n5CQeX9/ajd14KiAyIiDEqCJbZFvq511fJDJtNoEWS
         L03Q==
X-Gm-Message-State: AJIora+GmvaWsqMrnLNcO1a4sUMarbg3Ew9rvJffspnkU5dt6HlrZavV
        dB4/TzpFk3RCBh69OScIx/nOtpAW9Hw0txNfmN8=
X-Google-Smtp-Source: AGRyM1t/OvFyegNmc24Kwkr8qMvrpENb5ZMI7VWRnKfmciNg7frWyk1pTeKAkg7btGf4egBYhItuEqx6x8re93rLsCE=
X-Received: by 2002:a2e:a78a:0:b0:25b:c51a:2c0a with SMTP id
 c10-20020a2ea78a000000b0025bc51a2c0amr21411914ljf.432.1657047654983; Tue, 05
 Jul 2022 12:00:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220614181706.26513-1-max.oss.09@gmail.com> <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
 <20220705151446.GA28605@francesco-nb.int.toradex.com> <CABBYNZJDkmU_Fgfszrau9CK6DSQM2xGaGwfVyVkjNo7MVtBd8w@mail.gmail.com>
 <20220705113829.4af55980@kernel.org>
In-Reply-To: <20220705113829.4af55980@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 5 Jul 2022 12:00:43 -0700
Message-ID: <CABBYNZL9yir6tbEnwu8sQMnNG+h-8bMdnkK1Tsqo8AOtc5goGw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: core: Fix deadlock due to `cancel_work_sync(&hdev->power_on)`
 from hci_power_on_sync.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Max Krummenacher <max.oss.09@gmail.com>,
        =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Marcel Holtmann <marcel@holtmann.org>,
        max.krummenacher@toradex.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Jul 5, 2022 at 11:38 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 5 Jul 2022 10:26:08 -0700 Luiz Augusto von Dentz wrote:
> > On Tue, Jul 5, 2022 at 8:14 AM Francesco Dolcini
> > <francesco.dolcini@toradex.com> wrote:
> > >
> > > Hello Vasyl,
> > >
> > > On Tue, Jul 05, 2022 at 03:59:31PM +0300, Vasyl Vavrychuk wrote:
> > > > Fixes: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
> > >
> > > This fixes tag is broken, dd06ed7ad057 does not exist on
> > > torvalds/master, and the `commit` word should be removed.
> > >
> > > Should be:
> > >
> > > Fixes: ff7f2926114d ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
> >
> > Ive rebased the patch on top of bluetooth-next and fixed the hash,
> > lets see if passes CI I might just go ahead and push it.
>
> Thanks for pushing it along, the final version can got thru bluetooth ->
> -> net and into 5.19, right?

Yep, I will send the pull request in a moment.

-- 
Luiz Augusto von Dentz
