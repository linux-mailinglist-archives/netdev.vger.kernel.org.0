Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123AF3FAD7D
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 19:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhH2Rt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 13:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhH2RtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 13:49:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5921360E97;
        Sun, 29 Aug 2021 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630259313;
        bh=Ng8Nc7RPjC5XZnL4EXuDtogqZsofQfD04ok2tzTdyg0=;
        h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
        b=WfLgDYhad3SWUz1Q4kjSXblwrfvtrwvQKrBBbqTsJgc9VEDQ7j0W46HWUbQGj6Q+K
         DZDilVD4HVaFbbPrRc8sjLPWJaCJC4+o6+hqJ5NSmlfeSgwh6w+Lyl0XGSun/MyOYS
         /kMm/O4VXOV2YzUvKbT/dhKfQ09ka2cwsUosXz3fBa7njXBw8QLnsVNX0+CVascDjS
         mzuavtotaNgLVb7fG/UEOXwC0XMAyhu8HtoU84+2E+RG7f9L53p2auRsy+l4OtyvGp
         al8f3KENJLJHQGaLVbQg3LBtb9vQdUIG7d2YiDYqdV/OB4oJVvFSk4n/agQFy6pSKd
         LBScUxJf9dl/A==
Received: by mail-lf1-f42.google.com with SMTP id m28so26330194lfj.6;
        Sun, 29 Aug 2021 10:48:33 -0700 (PDT)
X-Gm-Message-State: AOAM531+JW2guyzl/BpLcsrmyMz1azd4agHBm+iLivdlj3RueZpLlw5g
        M0wDuuWILenAgQpUh2s1g0HRtyQhUA7TzyWSIgg=
X-Google-Smtp-Source: ABdhPJyB1nMr9MC5DfmQcKkSm3lO+DjPQnAw0j9giP2Ell6A/NFUpcvTKa18StEugRVNKMxhup/rEojB0Viq1QaPQ5w=
X-Received: by 2002:a05:6512:3f89:: with SMTP id x9mr14794257lfa.233.1630259311683;
 Sun, 29 Aug 2021 10:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210823143754.14294-1-michael.riesch@wolfvision.net>
In-Reply-To: <20210823143754.14294-1-michael.riesch@wolfvision.net>
Reply-To: wens@kernel.org
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Mon, 30 Aug 2021 01:48:19 +0800
X-Gmail-Original-Message-ID: <CAGb2v67Duk_56fOKVwZsYn2HKJ99o8WJ+d4jetD2UjDsAt9BcA@mail.gmail.com>
Message-ID: <CAGb2v67Duk_56fOKVwZsYn2HKJ99o8WJ+d4jetD2UjDsAt9BcA@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings
To:     Michael Riesch <michael.riesch@wolfvision.net>
Cc:     netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Aug 23, 2021 at 10:39 PM Michael Riesch
<michael.riesch@wolfvision.net> wrote:
>
> This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
> "net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
> unbalanced pm_runtime_enable warnings.
>
> In the commit to be reverted, support for power management was
> introduced to the Rockchip glue code. Later, power management support
> was introduced to the stmmac core code, resulting in multiple
> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
>
> The multiple invocations happen in rk_gmac_powerup and
> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
> stmmac_{dvr_remove, suspend}, respectively, which are always called
> in conjunction.
>
> Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>

I just found that Ethernet stopped working on my RK3399 devices,
and I bisected it down to this patch.

The symptom I see is no DHCP responses, either because the request
isn't getting sent over the wire, or the response isn't getting
received. The PHY seems to be working correctly.


ChenYu
