Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D175AD365
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbiIENCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236344AbiIENC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:02:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EE62983B
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 06:02:28 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1662382946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uob+P8q9quYC6NGXIMXYJmtyFVoDmR3GgfDGB8nzl/4=;
        b=AFv9wxeAuABJC6uuMsrmPKjgfQChH/HvrGkhIPisjgqOdT+0/tAL/6VjOuGe9kHDTtLWfa
        3/4fxQQLYGz8hAlEJKwCfaCVuqg5I7l0SMCfnXO2G3d0rzguK1+hyhmAoBLGDtNSBOrnfU
        ict+Fe6fksHPU3h+JEz0QDFs1QpuhfI4XgBnO4/y3xAs7vEnIZ8b4KVsVfsMaoJzUEh4b7
        OJP0aPKJlgvlPaeVbYnF8DiKl7dPePFbeTsvICfXRKIJC3RwVkAjZiySIGPC4D8knL0TR7
        JZnZqmghvdw8ejbUCyuBF0fa5KLghvc4qO47JQutjcSyiVsZUF6bl8QF9tb17w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1662382946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uob+P8q9quYC6NGXIMXYJmtyFVoDmR3GgfDGB8nzl/4=;
        b=9IftrWaSljh+TIY5UxLe/05+hayKP5Lx1geXmHmjIjVOWXNf6e0wso96HxuAxApcDBxAfi
        HTr2Wh7HdjjkffCw==
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v1] net: stmmac: Disable automatic FCS/Pad stripping
Date:   Mon,  5 Sep 2022 15:01:55 +0200
Message-Id: <20220905130155.193640-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stmmac has the possibility to automatically strip the padding/FCS for IEEE
802.3 type frames. This feature is enabled conditionally. Therefore, the stmmac
receive path has to have a determination logic whether the FCS has to be
stripped in software or not.

In fact, for DSA this ACS feature is disabled and the determination logic
doesn't check for it properly. For instance, when using DSA in combination with
an older stmmac (pre version 4), the FCS is not stripped by hardware or software
which is problematic.

So either add another check for DSA to the fast path or simply disable ACS
feature completely. The latter approach has been chosen, because most of the
time the FCS is stripped in software anyway and it removes conditionals from the
receive fast path.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/87v8q8jjgh.fsf@kurt/
---
 .../net/ethernet/stmicro/stmmac/dwmac100.h    |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000.h   |  2 +-
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  |  9 -------
 .../ethernet/stmicro/stmmac/dwmac100_core.c   |  8 -------
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  1 -
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 24 ++++---------------
 6 files changed, 6 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100.h b/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
index 35ab8d0bdce7..7ab791c8d355 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
@@ -56,7 +56,7 @@
 #define MAC_CONTROL_TE		0x00000008	/* Transmitter Enable */
 #define MAC_CONTROL_RE		0x00000004	/* Receiver Enable */
 
-#define MAC_CORE_INIT (MAC_CONTROL_HBD | MAC_CONTROL_ASTP)
+#define MAC_CORE_INIT (MAC_CONTROL_HBD)
 
 /* MAC FLOW CTRL defines */
 #define MAC_FLOW_CTRL_PT_MASK	0xffff0000	/* Pause Time Mask */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index 3c73453725f9..4296ddda8aaa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -126,7 +126,7 @@ enum inter_frame_gap {
 #define GMAC_CONTROL_TE		0x00000008	/* Transmitter Enable */
 #define GMAC_CONTROL_RE		0x00000004	/* Receiver Enable */
 
-#define GMAC_CORE_INIT (GMAC_CONTROL_JD | GMAC_CONTROL_PS | GMAC_CONTROL_ACS | \
+#define GMAC_CORE_INIT (GMAC_CONTROL_JD | GMAC_CONTROL_PS | \
 			GMAC_CONTROL_BE | GMAC_CONTROL_DCRS)
 
 /* GMAC Frame Filter defines */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 76edb9b72675..0e00dd83d027 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -15,7 +15,6 @@
 #include <linux/crc32.h>
 #include <linux/slab.h>
 #include <linux/ethtool.h>
-#include <net/dsa.h>
 #include <asm/io.h>
 #include "stmmac.h"
 #include "stmmac_pcs.h"
@@ -24,7 +23,6 @@
 static void dwmac1000_core_init(struct mac_device_info *hw,
 				struct net_device *dev)
 {
-	struct stmmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value = readl(ioaddr + GMAC_CONTROL);
 	int mtu = dev->mtu;
@@ -32,13 +30,6 @@ static void dwmac1000_core_init(struct mac_device_info *hw,
 	/* Configure GMAC core */
 	value |= GMAC_CORE_INIT;
 
-	/* Clear ACS bit because Ethernet switch tagging formats such as
-	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
-	 * hardware to truncate packets on reception.
-	 */
-	if (netdev_uses_dsa(dev) || !priv->plat->enh_desc)
-		value &= ~GMAC_CONTROL_ACS;
-
 	if (mtu > 1500)
 		value |= GMAC_CONTROL_2K;
 	if (mtu > 2000)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
index 75071a7d551a..a6e8d7bd9588 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
@@ -15,7 +15,6 @@
 *******************************************************************************/
 
 #include <linux/crc32.h>
-#include <net/dsa.h>
 #include <asm/io.h>
 #include "stmmac.h"
 #include "dwmac100.h"
@@ -28,13 +27,6 @@ static void dwmac100_core_init(struct mac_device_info *hw,
 
 	value |= MAC_CORE_INIT;
 
-	/* Clear ASTP bit because Ethernet switch tagging formats such as
-	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
-	 * hardware to truncate packets on reception.
-	 */
-	if (netdev_uses_dsa(dev))
-		value &= ~MAC_CONTROL_ASTP;
-
 	writel(value, ioaddr + MAC_CONTROL);
 
 #ifdef STMMAC_VLAN_TAG_USED
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index d8f1fbc25bdd..c25bfecb4a2d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/ethtool.h>
 #include <linux/io.h>
-#include <net/dsa.h>
 #include "stmmac.h"
 #include "stmmac_pcs.h"
 #include "dwmac4.h"
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 592d29abcb1c..8418e795cc21 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5076,16 +5076,8 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 		buf1_len = stmmac_rx_buf1_len(priv, p, status, len);
 		len += buf1_len;
 
-		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
-		 * Type frames (LLC/LLC-SNAP)
-		 *
-		 * llc_snap is never checked in GMAC >= 4, so this ACS
-		 * feature is always disabled and packets need to be
-		 * stripped manually.
-		 */
-		if (likely(!(status & rx_not_ls)) &&
-		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
-		     unlikely(status != llc_snap))) {
+		/* ACS is disabled; strip manually. */
+		if (likely(!(status & rx_not_ls))) {
 			buf1_len -= ETH_FCS_LEN;
 			len -= ETH_FCS_LEN;
 		}
@@ -5262,16 +5254,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		buf2_len = stmmac_rx_buf2_len(priv, p, status, len);
 		len += buf2_len;
 
-		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
-		 * Type frames (LLC/LLC-SNAP)
-		 *
-		 * llc_snap is never checked in GMAC >= 4, so this ACS
-		 * feature is always disabled and packets need to be
-		 * stripped manually.
-		 */
-		if (likely(!(status & rx_not_ls)) &&
-		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
-		     unlikely(status != llc_snap))) {
+		/* ACS is disabled; strip manually. */
+		if (likely(!(status & rx_not_ls))) {
 			if (buf2_len) {
 				buf2_len -= ETH_FCS_LEN;
 				len -= ETH_FCS_LEN;
-- 
2.30.2

