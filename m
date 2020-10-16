Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCDC290E46
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 01:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410593AbgJPXxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 19:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392584AbgJPXuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 19:50:54 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AF7C0613D3
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 16:51:11 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id q63so3318678qkf.3
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 16:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XfHzCbg0Hb+bq8yWOkG0rvdYG7FakrZNfPJ+xoBSlYw=;
        b=hWNaQdHbOc4lwTyErdJ19mPRY/5uTrfU5DfevRMQm6YioDjRGWZiVkZiLEDAOSYAvI
         l/dsQ0e3olL1h9rO0CH33l8OLa1MpQwiC7mfqft8ElxCfjyVROpvhOYMKtujm6ZzJ9Om
         MQiJkgGgYYCngQU13jNF1n4hWtADKj7btGRMGmyVife3Rpi/Vsa5L5X+Qc5hXm6BTJj+
         VM8zceDPiZH+ReFuiP0G3oJmoW2n4xMaLVMm12Qs3EMUB35ysSsjOaUerAgB1iBQsyvO
         DmB6iuanjyQhg803Dq9o1/eiCU4IyP/O6v6vblOW3eeGopP5cMh0exNqgaZEff5VrcfJ
         45Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XfHzCbg0Hb+bq8yWOkG0rvdYG7FakrZNfPJ+xoBSlYw=;
        b=anqgthotX92UJqZmoZxegqwZjGzLDXolyU6lGbHNGbh+cFTIJeV9swIgnIRiMwmtCI
         h2fgXCp24iDlqHp/43JHTIvYgK8vXA5ZrxJIV0c2TpIE+6CNnil/XUjN8IlI8Z5j4H0j
         JRQrdClcUjIXqTjQxOiWBf8QMd67dHOnWcrQROoX8fH1xiGXpVmDbmID/jZF0mqw9GwN
         T4zgFwl5WRDwRJWdj3JO/x/QtmkO0Ju/r9dmM822ZAdrQhEttaVeT9vhNBLtNRK4efoI
         83FdarAApXdAlbMXc23vygA2XypEeZxY8fBCyw9WtIcStc7z9UEmJ2Ic3Fj+4LLsxtdO
         JMHw==
X-Gm-Message-State: AOAM533RSRDG/dkFof94AyuA/FQ7O1Cf9iPUmdAVBMgiHXmwBUrjMchV
        r2mucnUTWdYGXI6CJ/wnsNnIOPgA7eVr4S2Vtk4=
X-Google-Smtp-Source: ABdhPJwZpiJ5z86Xm0jamE1A/65AUceNBj4x9C2DP5OCcy70Ds2hNqsYdCa20We0KZVVcfoldMRlXEhaTw7yqf6OHsM=
X-Received: by 2002:a05:620a:1598:: with SMTP id d24mr6559364qkk.168.1602892270272;
 Fri, 16 Oct 2020 16:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20201016232006.3352947-1-kuba@kernel.org>
In-Reply-To: <20201016232006.3352947-1-kuba@kernel.org>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Sat, 17 Oct 2020 01:50:59 +0200
Message-ID: <CAA85sZsm0ZNGoU59Lhn+qUHDAUcNjLoJYdqUf45k_nSkANMDog@mail.gmail.com>
Subject: Re: [PATCH net] ixgbe: fix probing of multi-port devices with one MDIO
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team@fb.com, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 1:20 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Ian reports that after upgrade from v5.8.14 to v5.9 only one
> of his 4 ixgbe netdevs appear in the system.
>
> Quoting the comment on ixgbe_x550em_a_has_mii():
>  * Returns true if hw points to lowest numbered PCI B:D.F x550_em_a device in
>  * the SoC.  There are up to 4 MACs sharing a single MDIO bus on the x550em_a,
>  * but we only want to register one MDIO bus.
>
> This matches the symptoms, since the return value from
> ixgbe_mii_bus_init() is no longer ignored we need to handle
> the higher ports of x550em without an error.

Nice, that fixes it!

You can add a:
Tested-by: Ian Kumlien <ian.kumlien@gmail.com>

;)

> Fixes: 09ef193fef7e ("net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()")
> Reported-by: Ian Kumlien <ian.kumlien@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 23 ++++++++++++--------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
> index f77fa3e4fdd1..fc389eecdd2b 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
> @@ -901,15 +901,13 @@ static bool ixgbe_x550em_a_has_mii(struct ixgbe_hw *hw)
>   **/
>  s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
>  {
> +       s32 (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
> +       s32 (*read)(struct mii_bus *bus, int addr, int regnum);
>         struct ixgbe_adapter *adapter = hw->back;
>         struct pci_dev *pdev = adapter->pdev;
>         struct device *dev = &adapter->netdev->dev;
>         struct mii_bus *bus;
>
> -       bus = devm_mdiobus_alloc(dev);
> -       if (!bus)
> -               return -ENOMEM;
> -
>         switch (hw->device_id) {
>         /* C3000 SoCs */
>         case IXGBE_DEV_ID_X550EM_A_KR:
> @@ -922,16 +920,23 @@ s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
>         case IXGBE_DEV_ID_X550EM_A_1G_T:
>         case IXGBE_DEV_ID_X550EM_A_1G_T_L:
>                 if (!ixgbe_x550em_a_has_mii(hw))
> -                       return -ENODEV;
> -               bus->read = &ixgbe_x550em_a_mii_bus_read;
> -               bus->write = &ixgbe_x550em_a_mii_bus_write;
> +                       return 0;
> +               read = &ixgbe_x550em_a_mii_bus_read;
> +               write = &ixgbe_x550em_a_mii_bus_write;
>                 break;
>         default:
> -               bus->read = &ixgbe_mii_bus_read;
> -               bus->write = &ixgbe_mii_bus_write;
> +               read = &ixgbe_mii_bus_read;
> +               write = &ixgbe_mii_bus_write;
>                 break;
>         }
>
> +       bus = devm_mdiobus_alloc(dev);
> +       if (!bus)
> +               return -ENOMEM;
> +
> +       bus->read = read;
> +       bus->write = write;
> +
>         /* Use the position of the device in the PCI hierarchy as the id */
>         snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mdio-%s", ixgbe_driver_name,
>                  pci_name(pdev));
> --
> 2.26.2
>
