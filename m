Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452D86C65DD
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjCWK47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbjCWK43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:56:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BB7AF1A;
        Thu, 23 Mar 2023 03:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679568966; x=1711104966;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OWTRNWK2+IE1ztjiEwVADPsVbFWplrXAMoIpmCf1h2w=;
  b=GjSKms45upBefJhcTjV0NLa7Kh7+SDSAjvQSMV8fn/Ek+aFifPnjQ26b
   nLOiPwoVxU4rpjrou98W225L7YJuVenIUnh17DdLrvOXRdoq9nFrZDflS
   tEUvwTtripnpiBPk4v/Z0mHvowfGi+Z5vt+UAR+4KksUJw3v93+AEtlaw
   3rKAPcwY3Vo213j7xzHuwMZULPIO7mYuEauqmeHKEi/aZd7pJ5X+exoTG
   T9kngKUDBQZRpB38wtyMisH2QTXD/dny/mXJpdCI++pmBVTWXtloelTlk
   AOAiEqiLnhec039c7RW0lnaUE741X8zh+t4Vkvz0jUmvzcQ31A0KEhC5R
   w==;
X-IronPort-AV: E=Sophos;i="5.98,283,1673938800"; 
   d="scan'208";a="203050709"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2023 03:56:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 03:56:02 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 03:56:00 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <error27@gmail.com>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] net: phy: micrel: Add support for PTP_PF_EXTTS for lan8841
Date:   Thu, 23 Mar 2023 11:55:57 +0100
Message-ID: <20230323105557.2436767-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the PTP programmable gpios to implement also PTP_PF_EXTTS
function. The pins can be configured to capture both of rising
and falling edge. Once the event is seen, then an interrupt is
generated and the LTC is saved in the registers.

This was tested using:
ts2phc -m -l 7 -s generic -f ts2phc.cfg

Where the configuration was the following:
[global]
ts2phc.pin_index  6

[eth2]

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v1->v2:
- inside lan8841_gpio_process_cap tmp was u16 and checked for tmp < 0
  which is impossible to happen, change tmp to be int as the return type
  of phy_read_mmd
---
 drivers/net/phy/micrel.c | 162 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 162 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e26c6723caa4d..cb87d38b4d9a5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3437,6 +3437,7 @@ static void lan8841_ptp_process_rx_ts(struct kszphy_ptp_priv *ptp_priv)
 #define LAN8841_PTP_INT_STS_PTP_TX_TS_INT	BIT(12)
 #define LAN8841_PTP_INT_STS_PTP_RX_TS_OVRFL_INT	BIT(9)
 #define LAN8841_PTP_INT_STS_PTP_RX_TS_INT	BIT(8)
+#define LAN8841_PTP_INT_STS_PTP_GPIO_CAP_INT	BIT(2)
 
 static void lan8841_ptp_flush_fifo(struct kszphy_ptp_priv *ptp_priv, bool egress)
 {
@@ -3451,6 +3452,67 @@ static void lan8841_ptp_flush_fifo(struct kszphy_ptp_priv *ptp_priv, bool egress
 	phy_read_mmd(phydev, 2, LAN8841_PTP_INT_STS);
 }
 
+#define LAN8841_PTP_GPIO_CAP_STS			506
+#define LAN8841_PTP_GPIO_SEL				327
+#define LAN8841_PTP_GPIO_SEL_GPIO_SEL(gpio)		((gpio) << 8)
+#define LAN8841_PTP_GPIO_RE_LTC_SEC_HI_CAP		498
+#define LAN8841_PTP_GPIO_RE_LTC_SEC_LO_CAP		499
+#define LAN8841_PTP_GPIO_RE_LTC_NS_HI_CAP		500
+#define LAN8841_PTP_GPIO_RE_LTC_NS_LO_CAP		501
+#define LAN8841_PTP_GPIO_FE_LTC_SEC_HI_CAP		502
+#define LAN8841_PTP_GPIO_FE_LTC_SEC_LO_CAP		503
+#define LAN8841_PTP_GPIO_FE_LTC_NS_HI_CAP		504
+#define LAN8841_PTP_GPIO_FE_LTC_NS_LO_CAP		505
+
+static void lan8841_gpio_process_cap(struct kszphy_ptp_priv *ptp_priv)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+	struct ptp_clock_event ptp_event = {0};
+	int pin, ret, tmp;
+	s32 sec, nsec;
+
+	pin = ptp_find_pin_unlocked(ptp_priv->ptp_clock, PTP_PF_EXTTS, 0);
+	if (pin == -1)
+		return;
+
+	tmp = phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_CAP_STS);
+	if (tmp < 0)
+		return;
+
+	ret = phy_write_mmd(phydev, 2, LAN8841_PTP_GPIO_SEL,
+			    LAN8841_PTP_GPIO_SEL_GPIO_SEL(pin));
+	if (ret)
+		return;
+
+	mutex_lock(&ptp_priv->ptp_lock);
+	if (tmp & BIT(pin)) {
+		sec = phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_RE_LTC_SEC_HI_CAP);
+		sec <<= 16;
+		sec |= phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_RE_LTC_SEC_LO_CAP);
+
+		nsec = phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_RE_LTC_NS_HI_CAP) & 0x3fff;
+		nsec <<= 16;
+		nsec |= phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_RE_LTC_NS_LO_CAP);
+	} else {
+		sec = phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_FE_LTC_SEC_HI_CAP);
+		sec <<= 16;
+		sec |= phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_FE_LTC_SEC_LO_CAP);
+
+		nsec = phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_FE_LTC_NS_HI_CAP) & 0x3fff;
+		nsec <<= 16;
+		nsec |= phy_read_mmd(phydev, 2, LAN8841_PTP_GPIO_FE_LTC_NS_LO_CAP);
+	}
+	mutex_unlock(&ptp_priv->ptp_lock);
+	ret = phy_write_mmd(phydev, 2, LAN8841_PTP_GPIO_SEL, 0);
+	if (ret)
+		return;
+
+	ptp_event.index = 0;
+	ptp_event.timestamp = ktime_set(sec, nsec);
+	ptp_event.type = PTP_CLOCK_EXTTS;
+	ptp_clock_event(ptp_priv->ptp_clock, &ptp_event);
+}
+
 static void lan8841_handle_ptp_interrupt(struct phy_device *phydev)
 {
 	struct kszphy_priv *priv = phydev->priv;
@@ -3459,12 +3521,16 @@ static void lan8841_handle_ptp_interrupt(struct phy_device *phydev)
 
 	do {
 		status = phy_read_mmd(phydev, 2, LAN8841_PTP_INT_STS);
+
 		if (status & LAN8841_PTP_INT_STS_PTP_TX_TS_INT)
 			lan8841_ptp_process_tx_ts(ptp_priv);
 
 		if (status & LAN8841_PTP_INT_STS_PTP_RX_TS_INT)
 			lan8841_ptp_process_rx_ts(ptp_priv);
 
+		if (status & LAN8841_PTP_INT_STS_PTP_GPIO_CAP_INT)
+			lan8841_gpio_process_cap(ptp_priv);
+
 		if (status & LAN8841_PTP_INT_STS_PTP_TX_TS_OVRFL_INT) {
 			lan8841_ptp_flush_fifo(ptp_priv, true);
 			skb_queue_purge(&ptp_priv->tx_queue);
@@ -3924,6 +3990,7 @@ static int lan8841_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 	switch (func) {
 	case PTP_PF_NONE:
 	case PTP_PF_PEROUT:
+	case PTP_PF_EXTTS:
 		break;
 	default:
 		return -1;
@@ -4191,10 +4258,104 @@ static int lan8841_ptp_perout(struct ptp_clock_info *ptp,
 	return ret;
 }
 
+#define LAN8841_PTP_GPIO_CAP_EN			496
+#define LAN8841_PTP_GPIO_CAP_EN_GPIO_RE_CAPTURE_ENABLE(gpio)	(BIT(gpio))
+#define LAN8841_PTP_GPIO_CAP_EN_GPIO_FE_CAPTURE_ENABLE(gpio)	(BIT(gpio) << 8)
+#define LAN8841_PTP_INT_EN_PTP_GPIO_CAP_EN	BIT(2)
+
+static int lan8841_ptp_extts_on(struct kszphy_ptp_priv *ptp_priv, int pin,
+				u32 flags)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+	u16 tmp = 0;
+	int ret;
+
+	/* Set GPIO to be intput */
+	ret = phy_set_bits_mmd(phydev, 2, LAN8841_GPIO_EN, BIT(pin));
+	if (ret)
+		return ret;
+
+	ret = phy_clear_bits_mmd(phydev, 2, LAN8841_GPIO_BUF, BIT(pin));
+	if (ret)
+		return ret;
+
+	/* Enable capture on the edges of the pin */
+	if (flags & PTP_RISING_EDGE)
+		tmp |= LAN8841_PTP_GPIO_CAP_EN_GPIO_RE_CAPTURE_ENABLE(pin);
+	if (flags & PTP_FALLING_EDGE)
+		tmp |= LAN8841_PTP_GPIO_CAP_EN_GPIO_FE_CAPTURE_ENABLE(pin);
+	ret = phy_write_mmd(phydev, 2, LAN8841_PTP_GPIO_CAP_EN, tmp);
+	if (ret)
+		return ret;
+
+	/* Enable interrupt */
+	return phy_modify_mmd(phydev, 2, LAN8841_PTP_INT_EN,
+			      LAN8841_PTP_INT_EN_PTP_GPIO_CAP_EN,
+			      LAN8841_PTP_INT_EN_PTP_GPIO_CAP_EN);
+}
+
+static int lan8841_ptp_extts_off(struct kszphy_ptp_priv *ptp_priv, int pin)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+	int ret;
+
+	/* Set GPIO to be output */
+	ret = phy_clear_bits_mmd(phydev, 2, LAN8841_GPIO_EN, BIT(pin));
+	if (ret)
+		return ret;
+
+	ret = phy_clear_bits_mmd(phydev, 2, LAN8841_GPIO_BUF, BIT(pin));
+	if (ret)
+		return ret;
+
+	/* Disable capture on both of the edges */
+	ret = phy_modify_mmd(phydev, 2, LAN8841_PTP_GPIO_CAP_EN,
+			     LAN8841_PTP_GPIO_CAP_EN_GPIO_RE_CAPTURE_ENABLE(pin) |
+			     LAN8841_PTP_GPIO_CAP_EN_GPIO_FE_CAPTURE_ENABLE(pin),
+			     0);
+	if (ret)
+		return ret;
+
+	/* Disable interrupt */
+	return phy_modify_mmd(phydev, 2, LAN8841_PTP_INT_EN,
+			      LAN8841_PTP_INT_EN_PTP_GPIO_CAP_EN,
+			      0);
+}
+
+static int lan8841_ptp_extts(struct ptp_clock_info *ptp,
+			     struct ptp_clock_request *rq, int on)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
+							ptp_clock_info);
+	int pin;
+	int ret;
+
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_EXTTS_EDGES |
+				PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	pin = ptp_find_pin(ptp_priv->ptp_clock, PTP_PF_EXTTS, rq->extts.index);
+	if (pin == -1 || pin >= LAN8841_PTP_GPIO_NUM)
+		return -EINVAL;
+
+	mutex_lock(&ptp_priv->ptp_lock);
+	if (on)
+		ret = lan8841_ptp_extts_on(ptp_priv, pin, rq->extts.flags);
+	else
+		ret = lan8841_ptp_extts_off(ptp_priv, pin);
+	mutex_unlock(&ptp_priv->ptp_lock);
+
+	return ret;
+}
+
 static int lan8841_ptp_enable(struct ptp_clock_info *ptp,
 			      struct ptp_clock_request *rq, int on)
 {
 	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		return lan8841_ptp_extts(ptp, rq, on);
 	case PTP_CLK_REQ_PEROUT:
 		return lan8841_ptp_perout(ptp, rq, on);
 	default:
@@ -4215,6 +4376,7 @@ static struct ptp_clock_info lan8841_ptp_clock_info = {
 	.verify         = lan8841_ptp_verify,
 	.enable         = lan8841_ptp_enable,
 	.n_per_out      = LAN8841_PTP_GPIO_NUM,
+	.n_ext_ts       = LAN8841_PTP_GPIO_NUM,
 	.n_pins         = LAN8841_PTP_GPIO_NUM,
 };
 
-- 
2.38.0

