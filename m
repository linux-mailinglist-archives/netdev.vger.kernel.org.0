Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280CB6751BA
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjATJye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjATJyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:54:32 -0500
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD3B7AF20;
        Fri, 20 Jan 2023 01:54:22 -0800 (PST)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30K7FRMG000520;
        Fri, 20 Jan 2023 04:54:12 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3n736yq3hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 04:54:12 -0500
Received: from m0167088.ppops.net (m0167088.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30K9sBAs021025;
        Fri, 20 Jan 2023 04:54:11 -0500
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3n736yq3hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 04:54:11 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 30K9sAPV036482
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Jan 2023 04:54:10 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Fri, 20 Jan
 2023 04:54:09 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 20 Jan 2023 04:54:09 -0500
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.139])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 30K9rqTw021132;
        Fri, 20 Jan 2023 04:54:05 -0500
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <yangyingliang@huawei.com>,
        <weiyongjun1@huawei.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <lennart@lfdomain.com>
Subject: [net-next 1/3] net: ethernet: adi: adin1110: add PTP clock support
Date:   Fri, 20 Jan 2023 11:53:46 +0200
Message-ID: <20230120095348.26715-2-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230120095348.26715-1-alexandru.tachici@analog.com>
References: <20230120095348.26715-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: eNSBwtdTTViAOrmikOTV41Djsyqf3jXr
X-Proofpoint-ORIG-GUID: ffoC0GuLxGQYKPyKiitZ5vT6GagVkjwh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_06,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301200093
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add control for the PHC inside the ADIN1110/2111.
Device contains a syntonized counter driven by a 120 MHz
clock  with 8 ns resolution.

Time is stored on two registers: a 32bit seconds register and
a 32bit nanoseconds register.

For adjusting the clock timing, device uses an addend register.
Can generate an output signal on the TS_TIMER pin.
For reading the timestamp the current tiem is saved by setting the
TS_CAPT pin via gpio in order to snapshot both seconds and nanoseconds
in different registers that the live ones.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/ethernet/adi/adin1110.c | 385 ++++++++++++++++++++++++++++
 1 file changed, 385 insertions(+)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 0805f249fff2..3c2d58f07a4a 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -8,6 +8,7 @@
 #include <linux/bitfield.h>
 #include <linux/bits.h>
 #include <linux/cache.h>
+#include <linux/clocksource.h>
 #include <linux/crc8.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -15,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/iopoll.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/kernel.h>
 #include <linux/mii.h>
 #include <linux/module.h>
@@ -22,6 +24,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/phy.h>
 #include <linux/property.h>
+#include <linux/ptp_clock_kernel.h>
 #include <linux/spi/spi.h>
 
 #include <net/switchdev.h>
@@ -35,6 +38,8 @@
 
 #define ADIN1110_CONFIG1			0x04
 #define   ADIN1110_CONFIG1_SYNC			BIT(15)
+#define   ADIN1110_CONFIG1_FTSE			BIT(7)
+#define   ADIN1110_CONFIG1_FTSS			BIT(6)
 
 #define ADIN1110_CONFIG2			0x06
 #define   ADIN2111_P2_FWD_UNK2HOST		BIT(12)
@@ -78,6 +83,20 @@
 #define ADIN1110_MAC_ADDR_MASK_UPR		0x70
 #define ADIN1110_MAC_ADDR_MASK_LWR		0x71
 
+#define ADIN1110_MAC_TS_ADDEND			0x80
+#define ADIN1110_MAC_TS_SEC_CNT			0x82
+#define ADIN1110_MAC_TS_NS_CNT			0x83
+#define ADIN1110_MAC_TS_CFG			0x84
+#define   ADIN1110_MAC_TS_CFG_EN		BIT(0)
+#define   ADIN1110_MAC_TS_CFG_CLR		BIT(1)
+#define   ADIN1110_MAC_TS_CFG_TIMER_STOP	BIT(3)
+#define   ADIN1110_MAC_TS_CFG_CAPT_CNT		BIT(4)
+#define ADIN1110_MAC_TS_TIMER_HI		0x85
+#define ADIN1110_MAC_TS_TIMER_LO		0x86
+#define ADIN1110_MAC_TS_TIMER_START		0x88
+#define ADIN1110_MAC_TS_CAPT0			0x89
+#define ADIN1110_MAC_TS_CAPT1			0x8A
+
 #define ADIN1110_RX_FSIZE			0x90
 #define ADIN1110_RX				0x91
 
@@ -90,6 +109,19 @@
 #define ADIN1110_MDIO_OP_WR			0x1
 #define ADIN1110_MDIO_OP_RD			0x3
 
+/* ADIN2111 PHY PINMUX Controls */
+#define ADIN2111_PINMUX_CFG1			0x8C56
+#define   ADIN2111_PINMUX_CFG1_DIGIO_TSCAPT	GENMASK(5, 4)
+
+#define   ADIN2111_PINMUX_CFG1_TSCAPT_TEST_1	BIT(5)
+#define   ADIN2111_PINMUX_CFG1_NOT_ASSIGNED	GENMASK(5, 4)
+
+/* ADIN2111 PHY LEDs Controls */
+#define ADIN2111_LED_CNTRL			0x8C82
+#define   ADIN2111_LED_CNTRL_LED0_FUNCTION	GENMASK(4, 0)
+
+#define   ADIN2111_LED_CNTRL_TS_TIMER		0x17
+
 #define ADIN1110_CD				BIT(7)
 #define ADIN1110_WRITE				BIT(5)
 
@@ -114,6 +146,11 @@
 #define ADIN_MAC_P2_ADDR_SLOT			3
 #define ADIN_MAC_FDB_ADDR_SLOT			4
 
+#define ADIN_MAC_MAX_PTP_PINS			2
+#define ADIN_MAC_MAX_TS_SLOTS			3
+
+#define adin1110_ptp_to_priv(x) container_of(x, struct adin1110_priv, ptp)
+
 DECLARE_CRC8_TABLE(adin1110_crc_table);
 
 enum adin1110_chips_id {
@@ -150,6 +187,11 @@ struct adin1110_port_priv {
 struct adin1110_priv {
 	struct mutex			lock; /* protect spi */
 	spinlock_t			state_lock; /* protect RX mode */
+	bool				ts_rx_append;
+	struct ptp_clock_info		ptp;
+	struct ptp_clock		*ptp_clock;
+	struct gpio_desc		*ts_capt;
+	struct ptp_pin_desc		ptp_pins[ADIN_MAC_MAX_PTP_PINS];
 	struct mii_bus			*mii_bus;
 	struct spi_device		*spidev;
 	bool				append_crc;
@@ -1640,6 +1682,343 @@ static int adin1110_probe_netdevs(struct adin1110_priv *priv)
 	return 0;
 }
 
+/* ADIN1110 has a syntonized counter driven by an internal 120 MHz clock, a 64-bit
+ * counter in which the lower 32 bits represent nanoseconds with 1 LSB = 1 ns.
+ * Frequency is adjusted by modifying the addend register.
+ */
+static int adin1110_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct adin1110_priv *priv = adin1110_ptp_to_priv(ptp);
+	bool negative = false;
+	u64 ts_addend;
+	u64 diff;
+	u32 val;
+	int ret;
+
+	mutex_lock(&priv->lock);
+
+	ret = adin1110_read_reg(priv, ADIN1110_MAC_TS_ADDEND, &val);
+	if (ret < 0)
+		goto out;
+
+	ts_addend = val;
+
+	if (scaled_ppm < 0) {
+		negative = true;
+		scaled_ppm = -scaled_ppm;
+	}
+
+	diff = mul_u64_u64_div_u64(ts_addend, (u64)scaled_ppm, 1000000ULL << 16);
+	if (negative)
+		val = ts_addend - diff;
+	else
+		val = ts_addend + diff;
+
+	ret = adin1110_write_reg(priv, ADIN1110_MAC_TS_ADDEND, val);
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int adin1110_ptp_read_ts_capt(struct adin1110_priv *priv,
+				     struct timespec64 *ts,
+				     struct ptp_system_timestamp *sts,
+				     struct ktime_timestamps *snap)
+{
+	u32 val;
+	int ret;
+
+	mutex_lock(&priv->lock);
+
+	if (sts)
+		ptp_read_system_prets(sts);
+
+	if (snap)
+		ktime_get_fast_timestamps(snap);
+
+	gpiod_set_value(priv->ts_capt, 1);
+	fsleep(1);
+	gpiod_set_value(priv->ts_capt, 0);
+
+	ret = adin1110_read_reg(priv, ADIN1110_MAC_TS_CAPT0, &val);
+	if (ret < 0)
+		goto out;
+	/* No TS captured when nsecs == 0 */
+	if (!val) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ts->tv_nsec = val;
+
+	ret = adin1110_read_reg(priv, ADIN1110_MAC_TS_CAPT1, &val);
+	if (ret < 0)
+		goto out;
+	if (sts)
+		ptp_read_system_postts(sts);
+
+	ts->tv_sec = val;
+out:
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+static int adin1110_ptp_settime64(struct ptp_clock_info *ptp,
+				  const struct timespec64 *ts)
+{
+	struct adin1110_priv *priv = adin1110_ptp_to_priv(ptp);
+	u32 addend;
+	int ret;
+
+	mutex_lock(&priv->lock);
+
+	ret = adin1110_read_reg(priv, ADIN1110_MAC_TS_ADDEND, &addend);
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_write_reg(priv, ADIN1110_MAC_TS_ADDEND, 0);
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_write_reg(priv, ADIN1110_MAC_TS_NS_CNT,
+				 ALIGN(ts->tv_nsec, 16));
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_write_reg(priv, ADIN1110_MAC_TS_SEC_CNT,
+				 ts->tv_sec);
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_write_reg(priv, ADIN1110_MAC_TS_ADDEND, addend);
+out:
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+static int adin1110_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct adin1110_priv *priv = adin1110_ptp_to_priv(ptp);
+	struct timespec64 ts;
+	u64 dev_time;
+	int ret;
+
+	ret = adin1110_ptp_read_ts_capt(priv, &ts, NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	dev_time = timespec64_to_ns(&ts);
+	dev_time += delta;
+
+	ts = ns_to_timespec64(dev_time);
+
+	return adin1110_ptp_settime64(ptp, &ts);
+}
+
+static int adin1110_ptp_gettimex64(struct ptp_clock_info *ptp,
+				   struct timespec64 *ts,
+				   struct ptp_system_timestamp *sts)
+{
+	struct adin1110_priv *priv = adin1110_ptp_to_priv(ptp);
+
+	return adin1110_ptp_read_ts_capt(priv, ts, sts, NULL);
+}
+
+static int adin1110_ptp_getcrosststamp(struct ptp_clock_info *ptp,
+				       struct system_device_crosststamp *cts)
+{
+	struct adin1110_priv *priv = adin1110_ptp_to_priv(ptp);
+	struct ktime_timestamps snap;
+	struct timespec64 ts;
+	int ret;
+
+	ret = adin1110_ptp_read_ts_capt(priv, &ts, NULL, &snap);
+	if (ret < 0)
+		return ret;
+
+	cts->device = timespec64_to_ktime(ts);
+	cts->sys_realtime = snap.real;
+	cts->sys_monoraw = snap.mono;
+
+	return 0;
+}
+
+static int adin1110_enable_perout(struct adin1110_priv *priv,
+				  struct ptp_perout_request perout,
+				  int on)
+{
+	u32 on_nsec;
+	u32 phase;
+	u32 mask;
+	int ret;
+
+	if (priv->cfg->id == ADIN2111_MAC) {
+		ret = phy_clear_bits_mmd(priv->ports[0]->phydev, MDIO_MMD_VEND1,
+					 ADIN2111_LED_CNTRL,
+					 ADIN2111_LED_CNTRL_LED0_FUNCTION);
+		if (ret < 0)
+			return ret;
+
+		ret = phy_set_bits_mmd(priv->ports[0]->phydev, MDIO_MMD_VEND1,
+				       ADIN2111_LED_CNTRL,
+				       on ? ADIN2111_LED_CNTRL_TS_TIMER : 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	mutex_lock(&priv->lock);
+
+	ret = adin1110_set_bits(priv, ADIN1110_MAC_TS_CFG,
+				ADIN1110_MAC_TS_CFG_CLR,
+				ADIN1110_MAC_TS_CFG_CLR);
+	if (ret < 0)
+		goto out;
+
+	if (perout.flags & PTP_PEROUT_DUTY_CYCLE)
+		on_nsec = perout.on.nsec;
+	else
+		on_nsec = perout.period.nsec / 2;
+
+	ret = adin1110_write_reg(priv, ADIN1110_MAC_TS_TIMER_HI,
+				 ALIGN(on_nsec, 16));
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_write_reg(priv, ADIN1110_MAC_TS_TIMER_LO,
+				 ALIGN((perout.period.nsec - on_nsec), 16));
+	if (ret < 0)
+		goto out;
+
+	if (perout.flags & PTP_PEROUT_PHASE)
+		phase = ALIGN(perout.phase.nsec, 16);
+	else
+		phase = 0;
+
+	/* TS_TIMER_START reg must be written to a value >= 16 because of how
+	 * the syntonized counter was implemented.
+	 */
+	if (phase < 16)
+		phase = 16;
+
+	if (on) {
+		ret = adin1110_write_reg(priv, ADIN1110_MAC_TS_TIMER_START,
+					 phase);
+		if (ret < 0)
+			goto out;
+	}
+
+	mask = ADIN1110_MAC_TS_CFG_EN | ADIN1110_MAC_TS_CFG_TIMER_STOP;
+	ret = adin1110_set_bits(priv, ADIN1110_MAC_TS_CFG, mask,
+				on ? ADIN1110_MAC_TS_CFG_EN : ADIN1110_MAC_TS_CFG_TIMER_STOP);
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_set_bits(priv, ADIN1110_CONFIG1, ADIN1110_CONFIG1_SYNC,
+				ADIN1110_CONFIG1_SYNC);
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int adin1110_enable_extts(struct adin1110_priv *priv,
+				 struct ptp_extts_request extts,
+				 int on)
+{
+	u32 val;
+	int ret;
+
+	if (extts.index >= priv->ptp.n_ext_ts)
+		return -EINVAL;
+
+	if (priv->cfg->id == ADIN2111_MAC) {
+		ret = phy_clear_bits_mmd(priv->ports[0]->phydev, MDIO_MMD_VEND1,
+					 ADIN2111_PINMUX_CFG1,
+					 ADIN2111_PINMUX_CFG1_DIGIO_TSCAPT);
+		if (ret < 0)
+			return ret;
+
+		val = on ? ADIN2111_PINMUX_CFG1_TSCAPT_TEST_1 : ADIN2111_PINMUX_CFG1_NOT_ASSIGNED;
+		ret = phy_set_bits_mmd(priv->ports[0]->phydev, MDIO_MMD_VEND1,
+				       ADIN2111_PINMUX_CFG1_DIGIO_TSCAPT, val);
+		if (ret < 0)
+			return ret;
+	}
+
+	mutex_lock(&priv->lock);
+	ret = adin1110_set_bits(priv, ADIN1110_MAC_TS_CFG,
+				ADIN1110_MAC_TS_CFG_EN,
+				on ? ADIN1110_MAC_TS_CFG_EN : 0);
+	if (ret < 0)
+		goto out;
+
+	ret = adin1110_set_bits(priv, ADIN1110_CONFIG1,
+				ADIN1110_CONFIG1_SYNC,
+				ADIN1110_CONFIG1_SYNC);
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int adin1110_ptp_enable(struct ptp_clock_info *ptp,
+			       struct ptp_clock_request *request, int on)
+{
+	struct adin1110_priv *priv = adin1110_ptp_to_priv(ptp);
+
+	switch (request->type) {
+	case PTP_CLK_REQ_EXTTS:
+		return adin1110_enable_extts(priv, request->extts, on);
+	case PTP_CLK_REQ_PEROUT:
+		return adin1110_enable_perout(priv, request->perout, on);
+	case PTP_CLK_REQ_PPS:
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int adin1110_setup_ptp(struct adin1110_priv *priv)
+{
+	priv->ts_capt = devm_gpiod_get_optional(&priv->spidev->dev, "ts-capt",
+						GPIOD_OUT_LOW);
+	if (!priv->ts_capt)
+		return 0;
+
+	snprintf(priv->ptp_pins[0].name, 64, "%s-%u-ptp-per-out",
+		 priv->cfg->name, priv->spidev->chip_select);
+	priv->ptp_pins[0].index = 0;
+	priv->ptp_pins[0].func = PTP_PF_PEROUT;
+	priv->ptp_pins[0].chan = 0;
+
+	snprintf(priv->ptp_pins[1].name, 64, "%s-%u-ptp-ext-ts",
+		 priv->cfg->name, priv->spidev->chip_select);
+	priv->ptp_pins[1].index = 1;
+	priv->ptp_pins[1].func = PTP_PF_EXTTS;
+	priv->ptp_pins[1].chan = 0;
+
+	priv->ptp.owner = THIS_MODULE;
+	snprintf(priv->ptp.name, PTP_CLOCK_NAME_LEN, "%s-%u-ptp",
+		 priv->cfg->name, priv->spidev->chip_select);
+
+	priv->ptp.max_adj = 512000;
+	priv->ptp.n_ext_ts = 1;
+	priv->ptp.n_per_out = 1;
+	priv->ptp.n_pins = ADIN_MAC_MAX_PTP_PINS;
+	priv->ptp.pin_config = priv->ptp_pins;
+	priv->ptp.adjfine = adin1110_ptp_adjfine;
+	priv->ptp.adjtime = adin1110_ptp_adjtime;
+	priv->ptp.gettimex64 = adin1110_ptp_gettimex64;
+	priv->ptp.getcrosststamp = adin1110_ptp_getcrosststamp;
+	priv->ptp.settime64 = adin1110_ptp_settime64;
+	priv->ptp.enable = adin1110_ptp_enable;
+
+	priv->ptp_clock = ptp_clock_register(&priv->ptp, &priv->spidev->dev);
+	if (IS_ERR(priv->ptp_clock))
+		return PTR_ERR(priv->ptp_clock);
+
+	return 0;
+}
+
 static int adin1110_probe(struct spi_device *spi)
 {
 	const struct spi_device_id *dev_id = spi_get_device_id(spi);
@@ -1680,6 +2059,12 @@ static int adin1110_probe(struct spi_device *spi)
 		return ret;
 	}
 
+	ret = adin1110_setup_ptp(priv);
+	if (ret < 0) {
+		dev_err(dev, "Could not register PTP clock %d\n", ret);
+		return ret;
+	}
+
 	return adin1110_probe_netdevs(priv);
 }
 
-- 
2.34.1

