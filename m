Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA0D2AF8A8
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgKKTFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:05:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgKKTFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 14:05:44 -0500
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B461E20797;
        Wed, 11 Nov 2020 19:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605121543;
        bh=QuYJYy9Z8qTlM956KSHGMy2Godc8Ym5zh6p3LrKqyuQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=M7HVRqraUEo/4Nl3aG8Cczbgfd1ERNf0o1lJ4CZDjWP7NPYvGmqqShocj1UHktTtu
         F/B8tkIqTKg0aeDU6VbZos6n1JExJL5CKRb/cc7huTLsEieyREm2SZy0juBrzCWq5u
         WrYE65CZZrH+Jpb/WHP7XNAIX/94TbUEAbG70EEw=
Received: by mail-oo1-f50.google.com with SMTP id r11so689969oos.12;
        Wed, 11 Nov 2020 11:05:43 -0800 (PST)
X-Gm-Message-State: AOAM531S7hj/T28CsLgRtQlQn2P2dtgvmoMpfpzT/GpI+oyR9DA9itHL
        B0PHc7QzjE+IdMWc3OcAqCZy6PY7ptUFUnTYPA==
X-Google-Smtp-Source: ABdhPJwypuMzJg/5W47bou8+okjT2kD1Fu5H8ig9wyBUvLsktWN4KwiT9YgDjoH5xW4vcl/eb6Oagrn11jTvnTPXZbE=
X-Received: by 2002:a4a:1a82:: with SMTP id 124mr18130758oof.81.1605121542885;
 Wed, 11 Nov 2020 11:05:42 -0800 (PST)
MIME-Version: 1.0
References: <20201111130507.1560881-1-mkl@pengutronix.de>
In-Reply-To: <20201111130507.1560881-1-mkl@pengutronix.de>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 11 Nov 2020 13:05:31 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLCRA4ee5OYzz2FNz+WTRiCa6YEGXDoXB29PC3D9uH6EQ@mail.gmail.com>
Message-ID: <CAL_JsqLCRA4ee5OYzz2FNz+WTRiCa6YEGXDoXB29PC3D9uH6EQ@mail.gmail.com>
Subject: Re: pull-request: can 2020-11-11
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawnguo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 7:05 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> Hello,
>
> after v5.10-rc1 the flexcan bindings were converted to yaml. This causes
> several unneeded regressions on i.MX53 based boards and/or SoC specifying the
> fsl,stop-mode property in their flexcan node.
>
> This series fixes these problems by first updating the affected i.MX SoC dtsi
> files and then fixing the flexcan yaml binding.
>
> After I got the OK from the DT and fsl people, the plan is to upstream this via
> net/master. If this is not an option, I'll send individual patches.

There's no need for dts changes to go into 5.10. dtbs_check is nowhere
near warning free yet. They should go via the soc tree. The schema
fixes do need to go in and I can take them. However, all the issues
still aren't fixed:

Documentation/devicetree/bindings/clock/imx5-clock.example.dt.yaml:
can@53fc8000: compatible: 'oneOf' conditional failed, one must be
fixed:
        ['fsl,imx53-flexcan', 'fsl,p1010-flexcan'] is too long
        Additional items are not allowed ('fsl,p1010-flexcan' was unexpected)
        'fsl,imx53-flexcan' is not one of ['fsl,imx7d-flexcan',
'fsl,imx6ul-flexcan', 'fsl,imx6sx-flexcan']
        'fsl,imx53-flexcan' is not one of ['fsl,ls1028ar1-flexcan']
        'fsl,imx25-flexcan' was expected
        'fsl,imx6q-flexcan' was expected
        'fsl,lx2160ar1-flexcan' was expected
        From schema:
/home/rob/proj/git/linux-dt/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml

Either the imx5-clock.yaml example needs changing or the schema does.
I'm guessing it's the former. I've applied the 2 schema patches here.

Rob
