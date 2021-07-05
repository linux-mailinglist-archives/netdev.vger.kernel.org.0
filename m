Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134A63BB82A
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 09:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhGEHtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 03:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhGEHtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 03:49:50 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DBBC061574;
        Mon,  5 Jul 2021 00:47:12 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y40so7416196ede.4;
        Mon, 05 Jul 2021 00:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3lU+yaKyB51Nd0BK8K42+im13NtdWR4bDe3Aamdm8jM=;
        b=uL2q1Zm27Mou4aR++Qi4k2PhgTcOxmTaP/AvPFFD6VwvtpuVHyKE+SeDhn9TagmhLM
         gAUS+muSbU17ieGtmK6jbT3cVJ1D2VAdrTPbA2KDHp9BJ47Blcxph91HM9uAxUeHe+xq
         6oA9502f2xIpoXh/nGgdlrE07cDFvnvonT3fhqoEyotKc3pba1Evzn7QSt73TMejW+X3
         5Dx6/3ghkpKVg76hBPLASmOgrjkx4it6ctWl9fA1+FXW7Z4So0zQLyzyLGqc5LrkHj9m
         UWRfTqUBaYfHwqKFDN4Z2CTBr+xWVeAk0A1rubFbE1AuVe76++CPrUk5XHWmByVPHqup
         vHMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3lU+yaKyB51Nd0BK8K42+im13NtdWR4bDe3Aamdm8jM=;
        b=HdlFlocNrTpzEPgFkSCZBtE4/TjV2LsHpGBIU56oqs5DleA0A+g7aKza8qmSNCwczG
         mf3gfz9uUeqft//+n+PYSf8yrh06fuIkOEl4tqtokSu9hMiORQ6FoUd9kQKoY/0XjwU0
         e8a+JPC012HopLeiE0UDm5YwV9QfpN3+cU8TwzbUt0RaYqIiOhVthxpMxisiPsm5Pnzy
         z4EGRmu9FdI14GXF0BBSUs8X1W77oeKz/WNxdvtL7cvMmU5qKkRLuenNgM4YGLfx+dxM
         nzbbP76WKtmWAG78KwmrUPpae9QhBq22tyqWXB6tEES+u0ySCiqrnEb53tOQf6b4pHLI
         C1vg==
X-Gm-Message-State: AOAM531msBmAVjNghkuZumL4Rm4P2BCXkSm7PmjTJlL51+AffI3P66Wp
        BNmRLxX//Mg6ZZ0tW8czITlrgVjmuTzZXp+JeyY=
X-Google-Smtp-Source: ABdhPJz69wsIJaVHAjEsyhlptcdaiCA6lkPbcEgV2ZN7vTcn2KJseSzhclcqBiPPooE+gAluDhZBtkKzSUMJypwiJb4=
X-Received: by 2002:a05:6402:430f:: with SMTP id m15mr2352655edc.113.1625471231421;
 Mon, 05 Jul 2021 00:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210702045120.22855-1-aaron.ma@canonical.com>
In-Reply-To: <20210702045120.22855-1-aaron.ma@canonical.com>
From:   Dave Airlie <airlied@gmail.com>
Date:   Mon, 5 Jul 2021 17:47:00 +1000
Message-ID: <CAPM=9twzx0aa5Dq-L5oOSk+w8z7audCq_biXwtFVh3QVY1VceA@mail.gmail.com>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Jul 2021 at 14:53, Aaron Ma <aaron.ma@canonical.com> wrote:
>
> Check PCI state when rd/wr iomem.
> Implement wr32 function as rd32 too.
>
> When unplug TBT dock with i225, rd/wr PCI iomem will cause error log:
> Trace:
> BUG: unable to handle page fault for address: 000000000000b604
> Oops: 0000 [#1] SMP NOPTI
> RIP: 0010:igc_rd32+0x1c/0x90 [igc]
> Call Trace:
> igc_ptp_suspend+0x6c/0xa0 [igc]
> igc_ptp_stop+0x12/0x50 [igc]
> igc_remove+0x7f/0x1c0 [igc]
> pci_device_remove+0x3e/0xb0
> __device_release_driver+0x181/0x240
>
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---

Drive-by, but won't this add a lot of overhead on every register
access? has this been benchmarked with lots of small network transfers
or anything?

Dave.


>  drivers/net/ethernet/intel/igc/igc_main.c | 16 ++++++++++++++++
>  drivers/net/ethernet/intel/igc/igc_regs.h |  7 ++-----
>  2 files changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index f1adf154ec4a..606b72cb6193 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -5292,6 +5292,10 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>         u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
>         u32 value = 0;
>
> +       if (igc->pdev &&
> +               igc->pdev->error_state == pci_channel_io_perm_failure)
> +               return 0;
> +
>         value = readl(&hw_addr[reg]);
>
>         /* reads should not return all F's */
> @@ -5308,6 +5312,18 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>         return value;
>  }
>
> +void igc_wr32(struct igc_hw *hw, u32 reg, u32 val)
> +{
> +       struct igc_adapter *igc = container_of(hw, struct igc_adapter, hw);
> +       u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
> +
> +       if (igc->pdev &&
> +               igc->pdev->error_state == pci_channel_io_perm_failure)
> +               return;
> +
> +       writel((val), &hw_addr[(reg)]);
> +}
> +
>  int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
>  {
>         struct igc_mac_info *mac = &adapter->hw.mac;
> diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
> index cc174853554b..eb4be87d0e8b 100644
> --- a/drivers/net/ethernet/intel/igc/igc_regs.h
> +++ b/drivers/net/ethernet/intel/igc/igc_regs.h
> @@ -260,13 +260,10 @@ struct igc_hw;
>  u32 igc_rd32(struct igc_hw *hw, u32 reg);
>
>  /* write operations, indexed using DWORDS */
> -#define wr32(reg, val) \
> -do { \
> -       u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
> -       writel((val), &hw_addr[(reg)]); \
> -} while (0)
> +void igc_wr32(struct igc_hw *hw, u32 reg, u32 val);
>
>  #define rd32(reg) (igc_rd32(hw, reg))
> +#define wr32(reg, val) (igc_wr32(hw, reg, val))
>
>  #define wrfl() ((void)rd32(IGC_STATUS))
>
> --
> 2.30.2
>
