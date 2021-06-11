Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8343A3DBA
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 10:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhFKIGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 04:06:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50532 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFKIGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 04:06:21 -0400
Received: from mail-oo1-f69.google.com ([209.85.161.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <koba.ko@canonical.com>)
        id 1lrc9O-0006dP-RE
        for netdev@vger.kernel.org; Fri, 11 Jun 2021 08:04:22 +0000
Received: by mail-oo1-f69.google.com with SMTP id e10-20020a4ab14a0000b029020e1573bdb7so1132289ooo.9
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 01:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PlfGTy5L26ls2w+H0/x97aCznqKMdMIosts/plCiSY8=;
        b=nPA9XSr3F5z8+GgAuqZKy89H1okS4P67kXWPrqY6iDpCv7TlxLGXw+s1/w8VO5eMOn
         kSbTsaWNCfwNlDFmu+xPco4BItujqTN9UAy4qLBsgjNNcGC8mHPyCz9ed/nGod2q0vxT
         aSSum2xASNDGSUCybKzFIY4mlhaJ/ug/RD3T9oLq5y6QQuzJKT3v53sivixa502IUoIu
         AQGaFpEuVGN6VsBsiYmFipqJ3qs/3WH9wvWizB+pToMpX22acbhdnHaZpu38ZT8Tk5ja
         cPJJpc0W+u1I4dMOiPvtXI9hGUv6kNAAPkMLu9Kp4kVdBqMfikOlbyHj8jD4ZBj0Vw7E
         L26g==
X-Gm-Message-State: AOAM5332AXRFl4B6jyaLffQcYjOwynraAQNRoBS7xvJxjtHTydFDv43M
        S/MzwOKwYtm92cGABlKe4WiwdoaR93dYqOqb4izOt/tFGbpDmTE9tnq42QTvEtSTPBFbee4zsSL
        uhf7AA97Pu0y3OFVh7wL2CQRF1p5ZJxTAkhDhiwAiLLv4Ghu0cg==
X-Received: by 2002:a9d:4115:: with SMTP id o21mr2037656ote.3.1623398661818;
        Fri, 11 Jun 2021 01:04:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyA1a+MfU0WsmLkdnjZSdgPYJyhWMywgEkDSBCZdh83/4htZViGUuSSUDwPYGyadUnrh1KOFSyceHaxpLuuS9E=
X-Received: by 2002:a9d:4115:: with SMTP id o21mr2037624ote.3.1623398661591;
 Fri, 11 Jun 2021 01:04:21 -0700 (PDT)
MIME-Version: 1.0
References: <7060a8ba-720f-904f-a6c6-c873559d8dbe@gmail.com>
In-Reply-To: <7060a8ba-720f-904f-a6c6-c873559d8dbe@gmail.com>
From:   Koba Ko <koba.ko@canonical.com>
Date:   Fri, 11 Jun 2021 16:04:10 +0800
Message-ID: <CAJB-X+WXVcd21eoT_usuVASa8D34Vkrbt5q7dcHSyE1T-vZD8A@mail.gmail.com>
Subject: Re: [PATCH net-next] r8169: avoid link-up interrupt issue on RTL8106e
 if user enables ASPM
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Kai Heng Feng <kai.heng.feng@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 4:57 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> It has been reported that on RTL8106e the link-up interrupt may be
> significantly delayed if the user enables ASPM L1. Per default ASPM
> is disabled. The change leaves L1 enabled on the PCIe link (thus still
> allowing to reach higher package power saving states), but the
> NIC won't actively trigger it.
>
> Reported-by: Koba Ko <koba.ko@canonical.com>
> Tested-by: Koba Ko <koba.ko@canonical.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 64f94a3fe..6a9fe9f7e 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -3508,7 +3508,6 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
>         rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
>
>         rtl_pcie_state_l2l3_disable(tp);
> -       rtl_hw_aspm_clkreq_enable(tp, true);
>  }

As per 0866cd15029b, this also affects the intel soc idle state.
Even the result is positive currently, I think this modification would
have higher risk.

>
>  DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
> --
> 2.32.0
>
