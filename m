Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229DC3FB9AE
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbhH3QEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 12:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237882AbhH3QEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 12:04:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CA2261037;
        Mon, 30 Aug 2021 16:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630339394;
        bh=aFevs/gSxbU10OD2HhmBmIy8lmlTrmGWeunJfZ8GXV4=;
        h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
        b=m2lWo3rrUt4CKtf+9F2RHi0LAvLDR2zr+nYw2qOLlFROMfazIHJUSBQ2RODMcrLCi
         pzQfitkSgwP1WJXPln2v8dn1uQJ2q+wfRUhgZJyRm18qEuds8+mYdqTboqvIdf+Gnc
         a4BTUmXO4/SkaUc8+GXU4aMi98MQ5kPd44a91lz4zWw+p2pitv8uVrAWtF7RFPapUA
         Eh/XkXZl59kLXE08NC8R2cnWZ8rufzCkM91fA3nPSBvo8tqYJDlSgUOZao+EXWjy15
         EboYQuQ5LkUOuRCJeXe7cq3/kwZ4dIFQnaekndyfxpXBsHJR1xjP87pkNRjPJsdOjz
         2AC5wSIaP7m9g==
Received: by mail-lf1-f42.google.com with SMTP id z2so32295639lft.1;
        Mon, 30 Aug 2021 09:03:13 -0700 (PDT)
X-Gm-Message-State: AOAM530AIEECWa4sha1mRNabH6UUM9RfFBmgWFKIFXKaRVwsTOnvsjxh
        VzR5n0eMCZOX6O73LaIpKXB/pvhPXSKcz/XOlBs=
X-Google-Smtp-Source: ABdhPJx2X93KAB+EVeQrnZM2DurW5sWa6kSM/wqlVkgAZbsxt9UtjBf99dzVD1xur/X4iU/kpcebwmpmAENY8zMU9po=
X-Received: by 2002:a05:6512:3f89:: with SMTP id x9mr18217622lfa.233.1630339392410;
 Mon, 30 Aug 2021 09:03:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210823143754.14294-1-michael.riesch@wolfvision.net>
 <CAGb2v67Duk_56fOKVwZsYn2HKJ99o8WJ+d4jetD2UjDsAt9BcA@mail.gmail.com> <568a0825-ed65-58d7-9c9c-cecb481cf9d9@wolfvision.net>
In-Reply-To: <568a0825-ed65-58d7-9c9c-cecb481cf9d9@wolfvision.net>
Reply-To: wens@kernel.org
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Tue, 31 Aug 2021 00:03:00 +0800
X-Gmail-Original-Message-ID: <CAGb2v658bD91LereM-Mc-2usEq-RH=pn_8bR9fEgmDUqpi5OoQ@mail.gmail.com>
Message-ID: <CAGb2v658bD91LereM-Mc-2usEq-RH=pn_8bR9fEgmDUqpi5OoQ@mail.gmail.com>
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
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Aug 30, 2021 at 3:57 PM Michael Riesch
<michael.riesch@wolfvision.net> wrote:
>
> Hi ChenYu,
>
> On 8/29/21 7:48 PM, Chen-Yu Tsai wrote:
> > Hi,
> >
> > On Mon, Aug 23, 2021 at 10:39 PM Michael Riesch
> > <michael.riesch@wolfvision.net> wrote:
> >>
> >> This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
> >> "net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
> >> unbalanced pm_runtime_enable warnings.
> >>
> >> In the commit to be reverted, support for power management was
> >> introduced to the Rockchip glue code. Later, power management support
> >> was introduced to the stmmac core code, resulting in multiple
> >> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
> >>
> >> The multiple invocations happen in rk_gmac_powerup and
> >> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
> >> stmmac_{dvr_remove, suspend}, respectively, which are always called
> >> in conjunction.
> >>
> >> Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
> >
> > I just found that Ethernet stopped working on my RK3399 devices,
> > and I bisected it down to this patch.
>
> Oh dear. First patch in a kernel release for a while and I already break
> things.
>
> Cc: Sasha as this patch has just been applied to 5.13-stable.
>
> > The symptom I see is no DHCP responses, either because the request
> > isn't getting sent over the wire, or the response isn't getting
> > received. The PHY seems to be working correctly.
>
> Unfortunately I don't have any RK3399 hardware. Is this a custom
> board/special hardware or something that is readily available in the
> shops? Maybe this is a good reason to buy a RK3399 based single-board
> computer :-)

I hit this on an ROC-RK3399-PC first, then bisected it on a NanoPi M4V2.
They both should be easy to get from their respective vendors. AFAIK
all the RK3399 devices have pretty much the same setup for Ethernet.

BTW, Don't get the Nanopi in the M4V2 variant. Get the original M4, or
the M4B (but the WiFi on the M4B doesn't seem to work lately).

> I am working on the RK3568 EVB1 and have not encountered faulty
> behavior. DHCP works fine and I can boot via NFS. Therefore, not sure
> whether I can be much of help in this matter, but in case you want to
> discuss this further please do not hesitate to contact me off-list.

My gut is telling me (without looking at the code) that maybe the GRF
access was not going through, and so the RGMII delays and stuff weren't
set properly, hence no traffic getting to/from the PHY. Otherwise there
were no error messages. I don't think I'll be able to squeeze out more
cycles to track down what actually went wrong though.


Regards
ChenYu
