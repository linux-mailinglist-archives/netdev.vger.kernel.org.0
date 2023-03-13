Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F746B84F7
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjCMWm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCMWmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:42:55 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D4F0900AB;
        Mon, 13 Mar 2023 15:42:44 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 9D360E0EB2;
        Tue, 14 Mar 2023 01:42:43 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=MejpIP3Pe+jcP8366+eVMDkcIjinKML8YC4WSTSWguE=; b=Dj8jj1mEy84s
        9tgcbqz2to37zCRCaIKQdQogsZI2Ua6U6cLkyM0MU06vBjm2aJPtgT361ac1rjWf
        fmpdnnIwOs4hHF8gV6SGNXFa5QdY4slLqZf3/JgS6Pon+Jhu2sH64dOAPYCoN+Bz
        9LwGW88x8aCE3NNst/n6QqBAleQ33qs=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 77BA7E0E6A;
        Tue, 14 Mar 2023 01:42:43 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:42:42 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 01/13] net: phy: realtek: Fix events detection failure in LPI mode
Date:   Tue, 14 Mar 2023 01:42:25 +0300
Message-ID: <20230313224237.28757-2-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.8.30.10]
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been noticed that RTL8211E PHY stops detecting and reporting events
(cable plugging in/out, link state changes, etc) when EEE is successfully
advertised and "RXC stopping in LPI" is enabled. The freeze happens right
after 3.0.10 bit (PC1R "Clock Stop Enable" register) is set. At the same
time LED2 stops blinking as if EEE mode has been disabled, interrupt pin
doesn't change its state (signal tested by oscilloscope). Notably the
network traffic still flows through the PHY with no obvious problem as
long as a network cable is connected. But if any MDIO read/write procedure
is performed after the "RXC stop in LPI" mode is enabled (even from a
non-existent device on the MDIO bus) the PHY gets to be unfrozen, LED2
starts blinking and PHY interrupts happens again (even which have happened
during the freeze). The problem has been noticed on RTL8211E PHY working
together with DW GMAC 3.73a MAC and reporting its event via a dedicated DW
MAC GPIO-IRQ signal. (Obviously the problem has been unnoticed in the
polling mode, since it gets naturally fixed by the periodic MDIO read
procedure from the PHY status register - BMSR.)

In order to fix that problem we suggest to locally re-implement the MMD
write method for RTL8211E PHY and perform a dummy read right after the
PC1R register is accessed to enable the RXC stopping in LPI mode.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---

Original patch:
Link: https://lore.kernel.org/netdev/20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru/
---
 drivers/net/phy/realtek.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 3d99fd6664d7..72ca06bcd53e 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -637,6 +637,42 @@ static int rtl822x_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 	return ret;
 }
 
+static int rtl8211e_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
+			      u16 val)
+{
+	int ret;
+
+	/* Write to the MMD registers by using the standard control/data pair.
+	 * The only difference is that we need to perform a dummy read after
+	 * the PC1R.CLKSTOP_EN bit is set. It's required to workaround an issue
+	 * of a partial core freeze so LED2 stops blinking in EEE mode, PHY
+	 * stops detecting the link change and raising IRQs until any read from
+	 * its registers performed. That happens only if and right after the PHY
+	 * is enabled to stop RXC in LPI mode.
+	 */
+	ret = __phy_write(phydev, MII_MMD_CTRL, devnum);
+	if (ret)
+		return ret;
+
+	ret = __phy_write(phydev, MII_MMD_DATA, regnum);
+	if (ret)
+		return ret;
+
+	ret = __phy_write(phydev, MII_MMD_CTRL, devnum | MII_MMD_CTRL_NOINCR);
+	if (ret)
+		return ret;
+
+	ret = __phy_write(phydev, MII_MMD_DATA, val);
+	if (ret)
+		return ret;
+
+	if (devnum == MDIO_MMD_PCS && regnum == MDIO_CTRL1 &&
+	    val & MDIO_PCS_CTRL1_CLKSTOP_EN)
+		ret =  __phy_read(phydev, MII_MMD_DATA);
+
+	return ret < 0 ? ret : 0;
+}
+
 static int rtl822x_get_features(struct phy_device *phydev)
 {
 	int val;
@@ -919,6 +955,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.write_mmd	= rtl8211e_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc916),
 		.name		= "RTL8211F Gigabit Ethernet",
-- 
2.39.2


