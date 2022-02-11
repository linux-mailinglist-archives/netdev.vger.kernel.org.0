Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5324B3184
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354165AbiBKXtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:49:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353777AbiBKXtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:49:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FBED62;
        Fri, 11 Feb 2022 15:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=z29r9vg5XNMe7m77Dr6cXKEmK5iCpfwxPrZsDuiGx7U=; b=TwzReY0KproR5i7fxmWl0Q7pTR
        YVkL7EPZfCatINM40HivnwPvm0qhtw+tFYT91c9KhpxvyEVCwz8W3We/s+Mpa3FiTnotoxi9fb7Pr
        yaw1D9+4uJIfrKOAzZW3J9/Pdj8Ia45gkyyPgot6ad/cIykZcwM7r35dm402V+AoEMa+02EFijtUL
        Zno/5xIvZE6rJkSxVMcWDMx5bg6t2JWcK29UTBs48KLKTwlwvFT9G8QoTaN6Gy4cf7wUFgL7n6K65
        OJtvmkn3PmV+o9HcGRYe1o2eZkGTBIfBrj5+UUTWSS1AD4LYYEp32VmWCCAsWW2JTOyHkD/Q+GNOZ
        6fcUBDUw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57204)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nIffa-0007ga-Nl; Fri, 11 Feb 2022 23:49:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nIffX-0003zD-6r; Fri, 11 Feb 2022 23:49:39 +0000
Date:   Fri, 11 Feb 2022 23:49:39 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mvpp2: Check for null pcs in mvpp2_acpi_start()
Message-ID: <Ygb2E1DGYVBO+mNP@shell.armlinux.org.uk>
References: <20220211234235.3180025-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211234235.3180025-1-jeremy.linton@arm.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 05:42:35PM -0600, Jeremy Linton wrote:
> Booting a MACCHIATObin with 5.17 the system OOPs with
> a null pointer deref when the network is started. This
> is caused by the pcs->ops structure being null on this
> particular platform/firmware.

pcs->ops should never be NULL. I'm surprised this fix results in any
kind of working networking.

Instead, the initialilsation of port->pcs_*.ops needs to be moved out
of the if (!mvpp2_use_acpi_compat_mode(..)) block. Please try this:

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b45cc7bfcdb5..0fb65940c0a5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7036,6 +7036,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;
 	dev->dev.of_node = port_node;
 
+	port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
+	port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
+
 	if (!mvpp2_use_acpi_compat_mode(port_fwnode)) {
 		port->phylink_config.dev = &dev->dev;
 		port->phylink_config.type = PHYLINK_NETDEV;
@@ -7106,9 +7109,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 				  port->phylink_config.supported_interfaces);
 		}
 
-		port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
-		port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
-
 		phylink = phylink_create(&port->phylink_config, port_fwnode,
 					 phy_mode, &mvpp2_phylink_ops);
 		if (IS_ERR(phylink)) {

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
