Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531CAEFF00
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 14:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389325AbfKENvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 08:51:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388615AbfKENvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 08:51:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i3IqKN50R5EMHGTGN0q0XbphdfjDnt9NlzSTEashjyI=; b=soJ0f6U0dIRnNuRA4r6Tp12GnX
        SFaB0amN2hRTA/kV2ji/I6/BbXr9G2SKuTQ+eG/U+mcwoC3GqqxL6VgplTnC+FtKgqgAhQIo9A+Zz
        Ms3mc/hsRVlbnhYTaQylDFKZFdoKtipNE1h0bv2C2OCPCMXpolPZ5vJ5H9nldeBa7DI8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRzEU-000267-0Q; Tue, 05 Nov 2019 14:50:54 +0100
Date:   Tue, 5 Nov 2019 14:50:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20191105135054.GA7189@lunn.ch>
References: <20191105195341.666c4a3a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105195341.666c4a3a@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 07:53:41PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powepc
> ppc44x_defconfig) failed like this:
> 
> 
> Caused by commit
> 
>   0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
> 
> I applied the following patch, but there is probably a nicer and more
> complete way to fix this.

Hi Stephen

I just received the 0-day about this. I did not know David had merged
it!

What you have works. So:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

The nicer way is a bit bigger. Is this too big to go in via you?
Should i submit it via netdev, and you can drop your fix once this
arrives?

	Andrew

rom e4a023829b53e2a918df8d8486c65c3650af0690 Mon Sep 17 00:00:00 2001
From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 5 Nov 2019 07:43:53 -0600
Subject: [PATCH] net: ethernet: emac: Fix phy mode type

Pass a phy_interface_t to of_get_phy_mode(), by changing the type of
phy_mode in the device structure. This then requires that
zmii_attach() is also changes, since it takes a pointer to phy_mode.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/ibm/emac/core.h | 2 +-
 drivers/net/ethernet/ibm/emac/zmii.c | 3 ++-
 drivers/net/ethernet/ibm/emac/zmii.h | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.h b/drivers/net/ethernet/ibm/emac/core.h
index e9cda024cbf6..89a1b0fea158 100644
--- a/drivers/net/ethernet/ibm/emac/core.h
+++ b/drivers/net/ethernet/ibm/emac/core.h
@@ -171,7 +171,7 @@ struct emac_instance {
        struct mal_commac               commac;
 
        /* PHY infos */
-       int                             phy_mode;
+       phy_interface_t                 phy_mode;
        u32                             phy_map;
        u32                             phy_address;
        u32                             phy_feat_exc;
diff --git a/drivers/net/ethernet/ibm/emac/zmii.c b/drivers/net/ethernet/ibm/emac/zmii.c
index b9e821de2ac6..57a25c7a9e70 100644
--- a/drivers/net/ethernet/ibm/emac/zmii.c
+++ b/drivers/net/ethernet/ibm/emac/zmii.c
@@ -78,7 +78,8 @@ static inline u32 zmii_mode_mask(int mode, int input)
        }
 }
 
-int zmii_attach(struct platform_device *ofdev, int input, int *mode)
+int zmii_attach(struct platform_device *ofdev, int input,
+               phy_interface_t *mode)
 {
        struct zmii_instance *dev = platform_get_drvdata(ofdev);
        struct zmii_regs __iomem *p = dev->base;
diff --git a/drivers/net/ethernet/ibm/emac/zmii.h b/drivers/net/ethernet/ibm/emac/zmii.h
index 41d46e9b87ba..65daedc78594 100644
--- a/drivers/net/ethernet/ibm/emac/zmii.h
+++ b/drivers/net/ethernet/ibm/emac/zmii.h
@@ -50,7 +50,8 @@ struct zmii_instance {
 
 int zmii_init(void);
 void zmii_exit(void);
-int zmii_attach(struct platform_device *ofdev, int input, int *mode);
+int zmii_attach(struct platform_device *ofdev, int input,
+               phy_interface_t *mode);
 void zmii_detach(struct platform_device *ofdev, int input);
 void zmii_get_mdio(struct platform_device *ofdev, int input);
 void zmii_put_mdio(struct platform_device *ofdev, int input);
-- 
2.24.0.rc0

    Andrew
