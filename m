Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFAB5BAD32
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 14:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiIPMSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 08:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiIPMSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 08:18:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8E1B089F;
        Fri, 16 Sep 2022 05:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663330698; x=1694866698;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=QwWl8kK2MTNE9pHwnpM8w8c9vbfjgB5jP3YggKtHXn4=;
  b=UVPK84mbnKPoVCsVX6URTk7YtwZJP73G9BZo7olrMMRWqVqd425HBFk7
   Q2uWCY2DZrW4s9RO7INsjUNZFmV2k2hJcIJ3o5j2t3Yqzun28N+0zC3nv
   qkY+yOo/m52pFPA3aijnsERBNvctvGlreOIng6JCePglu9/R4XzYK0ixE
   7a5KTv6y3sjXr5WTHHjUFJ4i7vf9c9k/5gXZ0Ti6UK+t5j8AJZtQy8Z6B
   I2DNADHEqZ4umCA+q28LcIp2sjBDGpWwrQnOlAsmen1cAuduvVinpmb4b
   KF9JNRQk5WG6as5FNsLMoAlHuXLyfEGX5yIcz3SlNgI+7ZgTVW9JOU7Le
   g==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="174192871"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2022 05:18:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 16 Sep 2022 05:18:16 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 16 Sep 2022 05:18:13 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [patch v2 net-next] net: phy: micrel: PEROUT support in lan8814
Date:   Fri, 16 Sep 2022 17:48:09 +0530
Message-ID: <20220916121809.16924-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support Periodic output from lan8814 gpio

Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
v1 -> v2
- Adding PTP maintainer
- Given line space between Macro and function.
---
 drivers/net/phy/micrel.c | 408 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 384 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 7b8c5c8d013e..91e5bf04f652 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -243,6 +243,50 @@
 #define PS_TO_REG				200
 #define FIFO_SIZE				8
 
+#define LAN8814_GPIO_EN1			0x20
+#define LAN8814_GPIO_EN2			0x21
+#define LAN8814_GPIO_DIR1			0x22
+#define LAN8814_GPIO_DIR2			0x23
+#define LAN8814_GPIO_BUF1			0x24
+#define LAN8814_GPIO_BUF2			0x25
+
+#define LAN8814_GPIO_EN_ADDR(pin)	((pin) > 15 ? LAN8814_GPIO_EN1 : LAN8814_GPIO_EN2)
+#define LAN8814_GPIO_EN_BIT_(pin)	BIT(pin)
+#define LAN8814_GPIO_DIR_ADDR(pin)	((pin) > 15 ? LAN8814_GPIO_DIR1 : LAN8814_GPIO_DIR2)
+#define LAN8814_GPIO_DIR_BIT_(pin)	BIT(pin)
+#define LAN8814_GPIO_BUF_ADDR(pin)	((pin) > 15 ? LAN8814_GPIO_BUF1 : LAN8814_GPIO_BUF2)
+#define LAN8814_GPIO_BUF_BIT_(pin)	BIT(pin)
+
+#define LAN8814_N_GPIO				24
+
+/* The number of periodic outputs is limited by number of
+ * PTP clock event channels
+ */
+#define LAN8814_PTP_N_PEROUT			2
+
+/* LAN8814_TARGET_BUFF: Seconds difference between LTC and target register.
+ * Should be more than 1 sec.
+ */
+#define LAN8814_TARGET_BUFF			3
+
+#define LAN8814_PTP_GENERAL_CONFIG			0x0201
+#define LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_X_MASK_(channel) \
+				((channel) ? GENMASK(11, 8) : GENMASK(7, 4))
+
+#define LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_X_SET_(channel, value) \
+				(((value) & 0xF) << (4 + ((channel) << 2)))
+#define LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X_(channel)	((channel) ? BIT(2) : BIT(0))
+#define LAN8814_PTP_GENERAL_CONFIG_POLARITY_X_(channel)		((channel) ? BIT(3) : BIT(1))
+
+#define LAN8814_PTP_CLOCK_TARGET_SEC_HI_X(channel)		((channel) ? 0x21F : 0x215)
+#define LAN8814_PTP_CLOCK_TARGET_SEC_LO_X(channel)		((channel) ? 0x220 : 0x216)
+#define LAN8814_PTP_CLOCK_TARGET_NS_HI_X(channel)		((channel) ? 0x221 : 0x217)
+#define LAN8814_PTP_CLOCK_TARGET_NS_LO_X(channel)		((channel) ? 0x222 : 0x218)
+#define LAN8814_PTP_CLOCK_TARGET_RELOAD_SEC_HI_X(channel)	((channel) ? 0x223 : 0x219)
+#define LAN8814_PTP_CLOCK_TARGET_RELOAD_SEC_LO_X(channel)	((channel) ? 0x224 : 0x21A)
+#define LAN8814_PTP_CLOCK_TARGET_RELOAD_NS_HI_X(channel)	((channel) ? 0x225 : 0x21B)
+#define LAN8814_PTP_CLOCK_TARGET_RELOAD_NS_LO_X(channel)	((channel) ? 0x226 : 0x21C)
+
 struct kszphy_hw_stat {
 	const char *string;
 	u8 reg;
@@ -267,13 +311,10 @@ struct lan8814_shared_priv {
 	struct phy_device *phydev;
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_clock_info;
+	struct ptp_pin_desc *pin_config;
+	s8 gpio_pin;
 
-	/* Reference counter to how many ports in the package are enabling the
-	 * timestamping
-	 */
-	u8 ref;
-
-	/* Lock for ptp_clock and ref */
+	/* Lock for ptp_clock and gpio_pin */
 	struct mutex shared_lock;
 };
 
@@ -2091,8 +2132,6 @@ static int lan8814_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 {
 	struct kszphy_ptp_priv *ptp_priv =
 			  container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
-	struct phy_device *phydev = ptp_priv->phydev;
-	struct lan8814_shared_priv *shared = phydev->shared->priv;
 	struct lan8814_ptp_rx_ts *rx_ts, *tmp;
 	struct hwtstamp_config config;
 	int txcfg = 0, rxcfg = 0;
@@ -2155,20 +2194,6 @@ static int lan8814_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 	else
 		lan8814_config_ts_intr(ptp_priv->phydev, false);
 
-	mutex_lock(&shared->shared_lock);
-	if (config.rx_filter != HWTSTAMP_FILTER_NONE)
-		shared->ref++;
-	else
-		shared->ref--;
-
-	if (shared->ref)
-		lanphy_write_page_reg(ptp_priv->phydev, 4, PTP_CMD_CTL,
-				      PTP_CMD_CTL_PTP_ENABLE_);
-	else
-		lanphy_write_page_reg(ptp_priv->phydev, 4, PTP_CMD_CTL,
-				      PTP_CMD_CTL_PTP_DISABLE_);
-	mutex_unlock(&shared->shared_lock);
-
 	/* In case of multiple starts and stops, these needs to be cleared */
 	list_for_each_entry_safe(rx_ts, tmp, &ptp_priv->rx_ts_list, list) {
 		list_del(&rx_ts->list);
@@ -2325,6 +2350,293 @@ static int lan8814_ptpci_gettime64(struct ptp_clock_info *ptpci,
 	return 0;
 }
 
+static void lan8814_gpio_release(struct lan8814_shared_priv *shared, s8 gpio_pin)
+{
+	struct phy_device *phydev = shared->phydev;
+	int val;
+
+	/* Disable gpio alternate function, 1: select as gpio, 0: select alt func */
+	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(gpio_pin));
+	val |= LAN8814_GPIO_EN_BIT_(gpio_pin);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(gpio_pin), val);
+
+	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(gpio_pin));
+	val &= ~LAN8814_GPIO_DIR_BIT_(gpio_pin);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(gpio_pin), val);
+
+	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(gpio_pin));
+	val &= ~LAN8814_GPIO_BUF_BIT_(gpio_pin);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(gpio_pin), val);
+}
+
+static void lan8814_gpio_init(struct lan8814_shared_priv *shared)
+{
+	struct phy_device *phydev = shared->phydev;
+
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR1, 0);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR2, 0);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_EN1, 0);
+
+	/* By default disabling alternate function to GPIO 0 and 1
+	 * i.e., 1: select as gpio, 0: select alt func
+	 */
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_EN2, 0x3);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_BUF1, 0);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_BUF2, 0);
+}
+
+static void lan8814_gpio_config_ptp_out(struct lan8814_shared_priv *shared,
+					s8 gpio_pin)
+{
+	struct phy_device *phydev = shared->phydev;
+	int val;
+
+	/* Set as gpio output */
+	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(gpio_pin));
+	val |= LAN8814_GPIO_DIR_BIT_(gpio_pin);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_DIR_ADDR(gpio_pin), val);
+
+	/* Enable gpio 0:for alternate function, 1:gpio */
+	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(gpio_pin));
+	val &= ~LAN8814_GPIO_EN_BIT_(gpio_pin);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_EN_ADDR(gpio_pin), val);
+
+	/* Set buffer type to push pull */
+	val = lanphy_read_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(gpio_pin));
+	val |= LAN8814_GPIO_BUF_BIT_(gpio_pin);
+	lanphy_write_page_reg(phydev, 4, LAN8814_GPIO_BUF_ADDR(gpio_pin), val);
+}
+
+static void lan8814_set_clock_target(struct phy_device *phydev, s8 gpio_pin,
+				     s64 start_sec, u32 start_nsec)
+{
+	if (gpio_pin < 0)
+		return;
+
+	/* Set the start time */
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_CLOCK_TARGET_SEC_LO_X(gpio_pin),
+			      lower_16_bits(start_sec));
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_CLOCK_TARGET_SEC_HI_X(gpio_pin),
+			      upper_16_bits(start_sec));
+
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_CLOCK_TARGET_NS_LO_X(gpio_pin),
+			      lower_16_bits(start_nsec));
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_CLOCK_TARGET_NS_HI_X(gpio_pin),
+			      upper_16_bits(start_nsec) & 0x3fff);
+}
+
+static void lan8814_set_clock_reload(struct phy_device *phydev, s8 gpio_pin,
+				     s64 period_sec, u32 period_nsec)
+{
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_CLOCK_TARGET_RELOAD_SEC_LO_X(gpio_pin),
+			      lower_16_bits(period_sec));
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_CLOCK_TARGET_RELOAD_SEC_HI_X(gpio_pin),
+			      upper_16_bits(period_sec));
+
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_CLOCK_TARGET_RELOAD_NS_LO_X(gpio_pin),
+			      lower_16_bits(period_nsec));
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_CLOCK_TARGET_RELOAD_NS_HI_X(gpio_pin),
+			      upper_16_bits(period_nsec) & 0x3fff);
+}
+
+static void lan8814_general_event_config(struct phy_device *phydev, s8 gpio_pin, int pulse_width)
+{
+	u16 general_config;
+
+	general_config = lanphy_read_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG);
+	general_config &= ~(LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_X_MASK_(gpio_pin));
+	general_config |= LAN8814_PTP_GENERAL_CONFIG_LTC_EVENT_X_SET_(gpio_pin,
+								      pulse_width);
+	general_config &= ~(LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X_(gpio_pin));
+	general_config |= LAN8814_PTP_GENERAL_CONFIG_POLARITY_X_(gpio_pin);
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG, general_config);
+}
+
+static void lan8814_ptp_perout_off(struct lan8814_shared_priv *shared,
+				   s8 gpio_pin)
+{
+	struct phy_device *phydev = shared->phydev;
+	u16 general_config;
+
+	/* Set target to too far in the future, effectively disabling it */
+	lan8814_set_clock_target(phydev, gpio_pin, 0xFFFFFFFF, 0);
+
+	general_config = lanphy_read_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG);
+	general_config |= LAN8814_PTP_GENERAL_CONFIG_RELOAD_ADD_X_(gpio_pin);
+	lanphy_write_page_reg(phydev, 4, LAN8814_PTP_GENERAL_CONFIG, general_config);
+
+	lan8814_gpio_release(shared, gpio_pin);
+}
+
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_200MS_	13
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100MS_	12
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_50MS_	11
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_10MS_	10
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5MS_	9
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1MS_	8
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500US_	7
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100US_	6
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_50US_	5
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_10US_	4
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5US_	3
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1US_	2
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500NS_	1
+#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100NS_	0
+
+static int lan88xx_get_pulsewidth(struct phy_device *phydev,
+				  struct ptp_perout_request *perout_request,
+				  int *pulse_width)
+{
+	struct timespec64 ts_period;
+	s64 ts_on_nsec, period_nsec;
+	struct timespec64 ts_on;
+
+	ts_period.tv_sec = perout_request->period.sec;
+	ts_period.tv_nsec = perout_request->period.nsec;
+
+	ts_on.tv_sec = perout_request->on.sec;
+	ts_on.tv_nsec = perout_request->on.nsec;
+	ts_on_nsec = timespec64_to_ns(&ts_on);
+	period_nsec = timespec64_to_ns(&ts_period);
+
+	if (period_nsec < 200) {
+		phydev_warn(phydev, "perout period too small, minimum is 200ns\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ts_on_nsec >= period_nsec) {
+		phydev_warn(phydev, "pulse width must be smaller than period\n");
+		return -EINVAL;
+	}
+
+	switch (ts_on_nsec) {
+	case 200000000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_200MS_;
+		break;
+	case 100000000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100MS_;
+		break;
+	case 50000000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_50MS_;
+		break;
+	case 10000000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_10MS_;
+		break;
+	case 5000000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5MS_;
+		break;
+	case 1000000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1MS_;
+		break;
+	case 500000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500US_;
+		break;
+	case 100000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100US_;
+		break;
+	case 50000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_50US_;
+		break;
+	case 10000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_10US_;
+		break;
+	case 5000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5US_;
+		break;
+	case 1000:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1US_;
+		break;
+	case 500:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500NS_;
+		break;
+	case 100:
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100NS_;
+		break;
+	default:
+		phydev_warn(phydev, "Using default pulse width of 100ns\n");
+		*pulse_width = LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100NS_;
+		break;
+	}
+	return 0;
+}
+
+static int lan8814_ptp_perout(struct lan8814_shared_priv *shared, int on,
+			      struct ptp_perout_request *perout_request)
+{
+	unsigned int perout_ch = perout_request->index;
+	struct phy_device *phydev = shared->phydev;
+	int pulse_width;
+	int ret;
+
+	/* Reject requests with unsupported flags */
+	if (perout_request->flags & ~PTP_PEROUT_DUTY_CYCLE)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&shared->shared_lock);
+	shared->gpio_pin = ptp_find_pin(shared->ptp_clock, PTP_PF_PEROUT,
+					perout_ch);
+	if (shared->gpio_pin < 0) {
+		mutex_unlock(&shared->shared_lock);
+		return -EBUSY;
+	}
+
+	if (!on) {
+		lan8814_ptp_perout_off(shared, shared->gpio_pin);
+		shared->gpio_pin = -1;
+		mutex_unlock(&shared->shared_lock);
+		return 0;
+	}
+
+	ret = lan88xx_get_pulsewidth(phydev, perout_request, &pulse_width);
+	if (ret < 0) {
+		shared->gpio_pin = -1;
+		mutex_unlock(&shared->shared_lock);
+		return ret;
+	}
+
+	/* Configure to pulse every period */
+	lan8814_general_event_config(phydev, shared->gpio_pin, pulse_width);
+	lan8814_set_clock_target(phydev, shared->gpio_pin, perout_request->start.sec,
+				 perout_request->start.nsec);
+	lan8814_set_clock_reload(phydev, shared->gpio_pin, perout_request->period.sec,
+				 perout_request->period.nsec);
+	lan8814_gpio_config_ptp_out(shared, shared->gpio_pin);
+	mutex_unlock(&shared->shared_lock);
+
+	return 0;
+}
+
+static int lan8814_ptpci_verify(struct ptp_clock_info *ptp, unsigned int pin,
+				enum ptp_pin_function func, unsigned int chan)
+{
+	if (chan != 0 || (pin != 0 && pin != 1))
+		return -1;
+
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int lan8814_ptpci_enable(struct ptp_clock_info *ptpci,
+				struct ptp_clock_request *request, int on)
+{
+	struct lan8814_shared_priv *shared = container_of(ptpci, struct lan8814_shared_priv,
+							  ptp_clock_info);
+
+	switch (request->type) {
+	case PTP_CLK_REQ_PEROUT:
+		return lan8814_ptp_perout(shared, on, &request->perout);
+	default:
+		return -EINVAL;
+	}
+}
+
 static int lan8814_ptpci_settime64(struct ptp_clock_info *ptpci,
 				   const struct timespec64 *ts)
 {
@@ -2333,6 +2645,8 @@ static int lan8814_ptpci_settime64(struct ptp_clock_info *ptpci,
 	struct phy_device *phydev = shared->phydev;
 
 	mutex_lock(&shared->shared_lock);
+	lan8814_set_clock_target(phydev, shared->gpio_pin,
+				 ts->tv_sec + LAN8814_TARGET_BUFF, 0);
 	lan8814_ptp_clock_set(phydev, ts->tv_sec, ts->tv_nsec);
 	mutex_unlock(&shared->shared_lock);
 
@@ -2342,12 +2656,16 @@ static int lan8814_ptpci_settime64(struct ptp_clock_info *ptpci,
 static void lan8814_ptp_clock_step(struct phy_device *phydev,
 				   s64 time_step_ns)
 {
+	struct lan8814_shared_priv *shared = phydev->shared->priv;
+	int gpio_pin = shared->gpio_pin;
 	u32 nano_seconds_step;
 	u64 abs_time_step_ns;
 	u32 unsigned_seconds;
 	u32 nano_seconds;
 	u32 remainder;
 	s32 seconds;
+	u32 tar_sec;
+	u32 nsec;
 
 	if (time_step_ns >  15000000000LL) {
 		/* convert to clock set */
@@ -2359,6 +2677,8 @@ static void lan8814_ptp_clock_step(struct phy_device *phydev,
 			unsigned_seconds++;
 			nano_seconds -= 1000000000;
 		}
+		lan8814_set_clock_target(phydev, gpio_pin,
+					 unsigned_seconds + LAN8814_TARGET_BUFF, 0);
 		lan8814_ptp_clock_set(phydev, unsigned_seconds, nano_seconds);
 		return;
 	} else if (time_step_ns < -15000000000LL) {
@@ -2374,6 +2694,8 @@ static void lan8814_ptp_clock_step(struct phy_device *phydev,
 			nano_seconds += 1000000000;
 		}
 		nano_seconds -= nano_seconds_step;
+		lan8814_set_clock_target(phydev, gpio_pin,
+					 unsigned_seconds + LAN8814_TARGET_BUFF, 0);
 		lan8814_ptp_clock_set(phydev, unsigned_seconds,
 				      nano_seconds);
 		return;
@@ -2428,6 +2750,11 @@ static void lan8814_ptp_clock_step(struct phy_device *phydev,
 					      PTP_LTC_STEP_ADJ_DIR_ |
 					      adjustment_value_hi);
 			seconds -= ((s32)adjustment_value);
+
+			lan8814_ptp_clock_get(phydev, &unsigned_seconds, &nsec);
+			tar_sec = unsigned_seconds - adjustment_value;
+			lan8814_set_clock_target(phydev, gpio_pin,
+						 tar_sec + LAN8814_TARGET_BUFF, 0);
 		} else {
 			u32 adjustment_value = (u32)(-seconds);
 			u16 adjustment_value_lo, adjustment_value_hi;
@@ -2443,6 +2770,11 @@ static void lan8814_ptp_clock_step(struct phy_device *phydev,
 			lanphy_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_HI,
 					      adjustment_value_hi);
 			seconds += ((s32)adjustment_value);
+
+			lan8814_ptp_clock_get(phydev, &unsigned_seconds, &nsec);
+			tar_sec = unsigned_seconds + adjustment_value;
+			lan8814_set_clock_target(phydev, gpio_pin,
+						 tar_sec + LAN8814_TARGET_BUFF, 0);
 		}
 		lanphy_write_page_reg(phydev, 4, PTP_CMD_CTL,
 				      PTP_CMD_CTL_PTP_LTC_STEP_SEC_);
@@ -2783,11 +3115,16 @@ static void lan8814_ptp_init(struct phy_device *phydev)
 	ptp_priv->mii_ts.ts_info  = lan8814_ts_info;
 
 	phydev->mii_ts = &ptp_priv->mii_ts;
+
+	/* Enable ptp to run LTC clock for ptp and gpio 1PPS operation */
+	lanphy_write_page_reg(ptp_priv->phydev, 4, PTP_CMD_CTL,
+			      PTP_CMD_CTL_PTP_ENABLE_);
 }
 
 static int lan8814_ptp_probe_once(struct phy_device *phydev)
 {
 	struct lan8814_shared_priv *shared = phydev->shared->priv;
+	int i;
 
 	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
 	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
@@ -2796,19 +3133,41 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 	/* Initialise shared lock for clock*/
 	mutex_init(&shared->shared_lock);
 
+	shared->pin_config = devm_kmalloc_array(&phydev->mdio.dev,
+						LAN8814_N_GPIO,
+						sizeof(*shared->pin_config),
+						GFP_KERNEL);
+	if (!shared->pin_config)
+		return -ENOMEM;
+
+	for (i = 0; i < LAN8814_N_GPIO; i++) {
+		struct ptp_pin_desc *ptp_pin = &shared->pin_config[i];
+
+		memset(ptp_pin, 0, sizeof(*ptp_pin));
+		snprintf(ptp_pin->name,
+			 sizeof(ptp_pin->name), "lan8814_ptp_pin_%02d", i);
+		ptp_pin->index = i;
+		ptp_pin->func =  PTP_PF_NONE;
+	}
+
+	shared->gpio_pin = -1;
+
 	shared->ptp_clock_info.owner = THIS_MODULE;
 	snprintf(shared->ptp_clock_info.name, 30, "%s", phydev->drv->name);
 	shared->ptp_clock_info.max_adj = 31249999;
 	shared->ptp_clock_info.n_alarm = 0;
 	shared->ptp_clock_info.n_ext_ts = 0;
-	shared->ptp_clock_info.n_pins = 0;
+	shared->ptp_clock_info.n_pins = LAN8814_N_GPIO;
 	shared->ptp_clock_info.pps = 0;
-	shared->ptp_clock_info.pin_config = NULL;
+	shared->ptp_clock_info.pin_config = shared->pin_config;
+	shared->ptp_clock_info.n_per_out = LAN8814_PTP_N_PEROUT;
 	shared->ptp_clock_info.adjfine = lan8814_ptpci_adjfine;
 	shared->ptp_clock_info.adjtime = lan8814_ptpci_adjtime;
 	shared->ptp_clock_info.gettime64 = lan8814_ptpci_gettime64;
 	shared->ptp_clock_info.settime64 = lan8814_ptpci_settime64;
 	shared->ptp_clock_info.getcrosststamp = NULL;
+	shared->ptp_clock_info.enable = lan8814_ptpci_enable;
+	shared->ptp_clock_info.verify = lan8814_ptpci_verify;
 
 	shared->ptp_clock = ptp_clock_register(&shared->ptp_clock_info,
 					       &phydev->mdio.dev);
@@ -2829,6 +3188,7 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 	lanphy_write_page_reg(phydev, 4, PTP_OPERATING_MODE,
 			      PTP_OPERATING_MODE_STANDALONE_);
 
+	lan8814_gpio_init(shared);
 	return 0;
 }
 
-- 
2.17.1

