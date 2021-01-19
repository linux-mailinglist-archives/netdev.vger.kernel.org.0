Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D903E2FBB03
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391347AbhASPWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:22:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47896 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391314AbhASPW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:22:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1sp5-001T0o-6c; Tue, 19 Jan 2021 16:21:35 +0100
Date:   Tue, 19 Jan 2021 16:21:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mdio, phy: fix -Wshadow warnings triggered by
 nested container_of()
Message-ID: <YAb4/7Nb1qaGiS0f@lunn.ch>
References: <20210116161246.67075-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210116161246.67075-1-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 04:13:22PM +0000, Alexander Lobakin wrote:
> container_of() macro hides a local variable '__mptr' inside. This
> becomes a problem when several container_of() are nested in each
> other within single line or plain macros.
> As C preprocessor doesn't support generating random variable names,
> the sole solution is to avoid defining macros that consist only of
> container_of() calls, or they will self-shadow '__mptr' each time:
> 
> In file included from ./include/linux/bitmap.h:10,
>                  from drivers/net/phy/phy_device.c:12:
> drivers/net/phy/phy_device.c: In function ‘phy_device_release’:
> ./include/linux/kernel.h:693:8: warning: declaration of ‘__mptr’ shadows a previous local [-Wshadow]
>   693 |  void *__mptr = (void *)(ptr);     \
>       |        ^~~~~~
> ./include/linux/phy.h:647:26: note: in expansion of macro ‘container_of’
>   647 | #define to_phy_device(d) container_of(to_mdio_device(d), \
>       |                          ^~~~~~~~~~~~
> ./include/linux/mdio.h:52:27: note: in expansion of macro ‘container_of’
>    52 | #define to_mdio_device(d) container_of(d, struct mdio_device, dev)
>       |                           ^~~~~~~~~~~~
> ./include/linux/phy.h:647:39: note: in expansion of macro ‘to_mdio_device’
>   647 | #define to_phy_device(d) container_of(to_mdio_device(d), \
>       |                                       ^~~~~~~~~~~~~~
> drivers/net/phy/phy_device.c:217:8: note: in expansion of macro ‘to_phy_device’
>   217 |  kfree(to_phy_device(dev));
>       |        ^~~~~~~~~~~~~
> ./include/linux/kernel.h:693:8: note: shadowed declaration is here
>   693 |  void *__mptr = (void *)(ptr);     \
>       |        ^~~~~~
> ./include/linux/phy.h:647:26: note: in expansion of macro ‘container_of’
>   647 | #define to_phy_device(d) container_of(to_mdio_device(d), \
>       |                          ^~~~~~~~~~~~
> drivers/net/phy/phy_device.c:217:8: note: in expansion of macro ‘to_phy_device’
>   217 |  kfree(to_phy_device(dev));
>       |        ^~~~~~~~~~~~~
> 
> As they are declared in header files, these warnings are highly
> repetitive and very annoying (along with the one from linux/pci.h).
> 
> Convert the related macros from linux/{mdio,phy}.h to static inlines
> to avoid self-shadowing and potentially improve bug-catching.
> No functional changes implied.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
