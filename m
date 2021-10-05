Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7205C422DAC
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbhJEQRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236504AbhJEQRw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:17:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E044161507;
        Tue,  5 Oct 2021 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633450561;
        bh=gA9SUJLpMS2aWLEumpGChQlH/EHwBrRRD1vFHumsbfo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cob5acGg1ZOVoxTI77FWB9zPo9fPAPIpY22UNzRo7lZlD8ywOSoV/HB2kz4dOfWN8
         zThN7UYlaaRy5VRXVme9i5kCbG1c8GSmlduZW2+DyK0BA8d6Ilp1VTsJaIFbXOZTm1
         D86dMvAzPPCazmri5geAY9HVQ785S7g8os/XTd54G6scL0ykcnD1xNR0CgQXnzAoj5
         8/D4mqeHa7mJVZ0BGTJZ6jAPnKUDMfNz6EiV2HTOL14xQTPJ7NhfvHZV8q/dlqN1SX
         rGzi4kyKCmwpbBiLE11+29uQaVTvUU1PlD+J8X48DN/0QPJJXU12s1lRxZYUt8eeGf
         37ppjYkj+/9Xg==
Received: by mail-ed1-f42.google.com with SMTP id z20so904921edc.13;
        Tue, 05 Oct 2021 09:16:01 -0700 (PDT)
X-Gm-Message-State: AOAM533lzeTccxxN19Pj68h48/XbxnM0WfXXVqPwnLQ7dTsCubNP6LO5
        HTmndqtpXFZX/g1xLlnwF0jx/7niuy1PZNakyg==
X-Google-Smtp-Source: ABdhPJwz+IAhSNH6BxzvW3QvcUQBpOfB0ZtacYFzUVmuAcaKtBIqPhZhgBpWbts2afyyDJzaFG9oIJE04j/Mpow6z2E=
X-Received: by 2002:a05:6402:44c:: with SMTP id p12mr27851295edw.145.1633450560320;
 Tue, 05 Oct 2021 09:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211005155321.2966828-1-kuba@kernel.org> <20211005155321.2966828-2-kuba@kernel.org>
In-Reply-To: <20211005155321.2966828-2-kuba@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 5 Oct 2021 11:15:48 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+HsW-dpUxC2Sz-FhgHgRonhanX2LgUVHiNZYfZS81iBQ@mail.gmail.com>
Message-ID: <CAL_Jsq+HsW-dpUxC2Sz-FhgHgRonhanX2LgUVHiNZYfZS81iBQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] of: net: add a helper for loading netdev->dev_addr
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 10:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
>
> There are roughly 40 places where netdev->dev_addr is passed
> as the destination to a of_get_mac_address() call. Add a helper
> which takes a dev pointer instead, so it can call an appropriate
> helper.
>
> Note that of_get_mac_address() already assumes the address is
> 6 bytes long (ETH_ALEN) so use eth_hw_addr_set().
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/of/of_net.c    | 25 +++++++++++++++++++++++++

Can we move this file to drivers/net/ given it's always merged via the
net tree? It's also the only thing left not part of the driver
subsystems.

>  include/linux/of_net.h |  6 ++++++
>  2 files changed, 31 insertions(+)
>
> diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
> index dbac3a172a11..f1a9bf7578e7 100644
> --- a/drivers/of/of_net.c
> +++ b/drivers/of/of_net.c
> @@ -143,3 +143,28 @@ int of_get_mac_address(struct device_node *np, u8 *addr)
>         return of_get_mac_addr_nvmem(np, addr);
>  }
>  EXPORT_SYMBOL(of_get_mac_address);
> +
> +/**
> + * of_get_ethdev_address()
> + * @np:                Caller's Device Node
> + * @dev:       Pointer to netdevice which address will be updated
> + *
> + * Search the device tree for the best MAC address to use.
> + * If found set @dev->dev_addr to that address.
> + *
> + * See documentation of of_get_mac_address() for more information on how
> + * the best address is determined.
> + *
> + * Return: 0 on success and errno in case of error.
> + */
> +int of_get_ethdev_address(struct device_node *np, struct net_device *dev)
> +{
> +       u8 addr[ETH_ALEN];
> +       int ret;
> +
> +       ret = of_get_mac_address(np, addr);
> +       if (!ret)
> +               eth_hw_addr_set(dev, addr);
> +       return ret;
> +}
> +EXPORT_SYMBOL(of_get_ethdev_address);
> diff --git a/include/linux/of_net.h b/include/linux/of_net.h
> index daef3b0d9270..314b9accd98c 100644
> --- a/include/linux/of_net.h
> +++ b/include/linux/of_net.h
> @@ -14,6 +14,7 @@
>  struct net_device;
>  extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
>  extern int of_get_mac_address(struct device_node *np, u8 *mac);
> +int of_get_ethdev_address(struct device_node *np, struct net_device *dev);
>  extern struct net_device *of_find_net_device_by_node(struct device_node *np);
>  #else
>  static inline int of_get_phy_mode(struct device_node *np,
> @@ -27,6 +28,11 @@ static inline int of_get_mac_address(struct device_node *np, u8 *mac)
>         return -ENODEV;
>  }
>
> +static inline int of_get_ethdev_address(struct device_node *np, struct net_device *dev)
> +{
> +       return -ENODEV;
> +}
> +
>  static inline struct net_device *of_find_net_device_by_node(struct device_node *np)
>  {
>         return NULL;
> --
> 2.31.1
>
