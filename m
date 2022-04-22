Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6172550B746
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 14:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447483AbiDVMac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 08:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447419AbiDVMab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 08:30:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E78756C14
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 05:27:38 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nhsNh-0008LX-Ky; Fri, 22 Apr 2022 14:27:25 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nhsNf-0007LN-Tm; Fri, 22 Apr 2022 14:27:23 +0200
Date:   Fri, 22 Apr 2022 14:27:23 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v6 1/7] ethtool: Add 10base-T1L link mode entry
Message-ID: <20220422122723.GE5244@pengutronix.de>
References: <20220412130706.36767-1-alexandru.tachici@analog.com>
 <20220412130706.36767-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220412130706.36767-2-alexandru.tachici@analog.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:23:41 up 23 days, 53 min, 77 users,  load average: 0.17, 0.32,
 0.30
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandru,

on top of kernel v5.18-rcX you will need following changes:

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8406ac739def..7e18d1571f78 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -90,8 +90,9 @@ const int phy_10_100_features_array[4] = {
 };
 EXPORT_SYMBOL_GPL(phy_10_100_features_array);
 
-const int phy_basic_t1_features_array[2] = {
+const int phy_basic_t1_features_array[3] = {
 	ETHTOOL_LINK_MODE_TP_BIT,
+	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
 	ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
 };
 EXPORT_SYMBOL_GPL(phy_basic_t1_features_array);
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 06943889d747..2c5e45e2b1f3 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -168,8 +168,10 @@ static void phylink_caps_to_linkmodes(unsigned long *linkmodes,
 	if (caps & MAC_10HD)
 		__set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, linkmodes);
 
-	if (caps & MAC_10FD)
+	if (caps & MAC_10FD) {
 		__set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, linkmodes);
+		__set_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT, linkmodes);
+	}
 
 	if (caps & MAC_100HD) {
 		__set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, linkmodes);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36ca2b5c2253..b12af9e2f389 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -65,7 +65,7 @@ extern const int phy_basic_ports_array[3];
 extern const int phy_fibre_port_array[1];
 extern const int phy_all_ports_features_array[7];
 extern const int phy_10_100_features_array[4];
-extern const int phy_basic_t1_features_array[2];
+extern const int phy_basic_t1_features_array[3];
 extern const int phy_gbit_features_array[2];
 extern const int phy_10gbit_features_array[1];
 

On Tue, Apr 12, 2022 at 04:07:00PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add entry for the 10base-T1L full duplex mode.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  drivers/net/phy/phy-core.c   | 3 ++-
>  include/uapi/linux/ethtool.h | 1 +
>  net/ethtool/common.c         | 3 +++
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 2001f3329133..1f2531a1a876 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -13,7 +13,7 @@
>   */
>  const char *phy_speed_to_str(int speed)
>  {
> -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 92,
> +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 93,
>  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
>  		"If a speed or mode has been added please update phy_speed_to_str "
>  		"and the PHY settings array.\n");
> @@ -176,6 +176,7 @@ static const struct phy_setting settings[] = {
>  	/* 10M */
>  	PHY_SETTING(     10, FULL,     10baseT_Full		),
>  	PHY_SETTING(     10, HALF,     10baseT_Half		),
> +	PHY_SETTING(     10, FULL,     10baseT1L_Full		),
>  };
>  #undef PHY_SETTING
>  
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 7bc4b8def12c..e0f0ee9bc89e 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1691,6 +1691,7 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
>  	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
>  	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
> +	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT		 = 92,
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
>  };
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 0c5210015911..566adf85e658 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -201,6 +201,7 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
>  	__DEFINE_LINK_MODE_NAME(400000, CR4, Full),
>  	__DEFINE_LINK_MODE_NAME(100, FX, Half),
>  	__DEFINE_LINK_MODE_NAME(100, FX, Full),
> +	__DEFINE_LINK_MODE_NAME(10, T1L, Full),
>  };
>  static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
>  
> @@ -236,6 +237,7 @@ static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
>  #define __LINK_MODE_LANES_T1		1
>  #define __LINK_MODE_LANES_X		1
>  #define __LINK_MODE_LANES_FX		1
> +#define __LINK_MODE_LANES_T1L		1
>  
>  #define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex)	\
>  	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = {		\
> @@ -349,6 +351,7 @@ const struct link_mode_info link_mode_params[] = {
>  	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
>  	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
>  	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10, T1L, Full),
>  };
>  static_assert(ARRAY_SIZE(link_mode_params) == __ETHTOOL_LINK_MODE_MASK_NBITS);
>  
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
