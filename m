Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402A265CEAB
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbjADIr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbjADIqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:46:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0396310FB;
        Wed,  4 Jan 2023 00:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672821979; x=1704357979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IcuKadJZIyDKCKoFJdux75E8mZFj5bNSomen0wIAlhY=;
  b=IVY4CPgffHkC/e8y8VpN5Lu107xOuGckylWYbmuKCHuY0bdF7RslwsoR
   dRlrNz53tbXBSqpUQjDejt1pFQRy1aVcU4f6y5dUl6X1ml32KzkUvcGFA
   aKi0s51WjTZnOPAWx1q9Kykh1+j3irF99midqaleM5TJASzDJiYE8CJvu
   Ogt0D80Xz9NVrdzYO8xhXHuIbwLZUsh5dQkC5jFxmmH5KsKGap7wUsXNt
   nnv9DusLAv8IZkTiQyovYjJZP4RTNF+A2u9iagccti3nfz1+IpRZB7d5b
   vsgEUVEpc5KIOGQApLMM9MlDVBDp6ENTU/vs/QNh/J13F2kO6pwWK4agA
   w==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="130720010"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2023 01:46:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 01:46:17 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 01:46:11 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v7 11/13] net: dsa: microchip: ptp: add support for perout programmable pins
Date:   Wed, 4 Jan 2023 14:13:14 +0530
Message-ID: <20230104084316.4281-12-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230104084316.4281-1-arun.ramadoss@microchip.com>
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two programmable pins available for Trigger output unit to
generate periodic pulses. This patch add verify_pin for the available 2
pins and configure it with respect to GPIO index for the TOU unit.

Tested using testptp
./testptp -i 0 -L 0,2
./testptp -i 0 -d /dev/ptp0 -p 1000000000
./testptp -i 1 -L 1,2
./testptp -i 1 -d /dev/ptp0 -p 100000000

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
v1 - v2
- checkpatch warning to limit 80 chars

Patch v1
- patch is new
---
 drivers/net/dsa/microchip/ksz_ptp.c | 35 +++++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h |  3 +++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index d08918b10417..03fbbe6493ed 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -171,6 +171,10 @@ static int ksz_ptp_enable_perout(struct ksz_device *dev,
 	    ptp_data->tou_mode != KSZ_PTP_TOU_IDLE)
 		return -EBUSY;
 
+	pin = ptp_find_pin(ptp_data->clock, PTP_PF_PEROUT, request->index);
+	if (pin < 0)
+		return -EINVAL;
+
 	data32 = FIELD_PREP(PTP_GPIO_INDEX, pin) |
 		 FIELD_PREP(PTP_TOU_INDEX, request->index);
 	ret = ksz_rmw32(dev, REG_PTP_UNIT_INDEX__4,
@@ -779,6 +783,23 @@ static int ksz_ptp_enable(struct ptp_clock_info *ptp,
 	return ret;
 }
 
+static int ksz_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+			      enum ptp_pin_function func, unsigned int chan)
+{
+	int ret = 0;
+
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
 /*  Function is pointer to the do_aux_work in the ptp_clock capability */
 static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
 {
@@ -822,6 +843,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	struct ksz_device *dev = ds->priv;
 	struct ksz_ptp_data *ptp_data;
 	int ret;
+	u8 i;
 
 	ptp_data = &dev->ptp_data;
 	mutex_init(&ptp_data->lock);
@@ -836,12 +858,25 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	ptp_data->caps.adjtime		= ksz_ptp_adjtime;
 	ptp_data->caps.do_aux_work	= ksz_ptp_do_aux_work;
 	ptp_data->caps.enable		= ksz_ptp_enable;
+	ptp_data->caps.verify		= ksz_ptp_verify_pin;
+	ptp_data->caps.n_pins		= KSZ_PTP_N_GPIO;
 	ptp_data->caps.n_per_out	= 3;
 
 	ret = ksz_ptp_start_clock(dev);
 	if (ret)
 		return ret;
 
+	for (i = 0; i < KSZ_PTP_N_GPIO; i++) {
+		struct ptp_pin_desc *ptp_pin = &ptp_data->pin_config[i];
+
+		snprintf(ptp_pin->name,
+			 sizeof(ptp_pin->name), "ksz_ptp_pin_%02d", i);
+		ptp_pin->index = i;
+		ptp_pin->func = PTP_PF_NONE;
+	}
+
+	ptp_data->caps.pin_config = ptp_data->pin_config;
+
 	/* Currently only P2P mode is supported. When 802_1AS bit is set, it
 	 * forwards all PTP packets to host port and none to other ports.
 	 */
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 9451e3a76375..0ca8ca4f804e 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -12,6 +12,8 @@
 
 #include <linux/ptp_clock_kernel.h>
 
+#define KSZ_PTP_N_GPIO		2
+
 enum ksz_ptp_tou_mode {
 	KSZ_PTP_TOU_IDLE,
 	KSZ_PTP_TOU_PEROUT,
@@ -20,6 +22,7 @@ enum ksz_ptp_tou_mode {
 struct ksz_ptp_data {
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
+	struct ptp_pin_desc pin_config[KSZ_PTP_N_GPIO];
 	/* Serializes all operations on the PTP hardware clock */
 	struct mutex lock;
 	/* lock for accessing the clock_time */
-- 
2.36.1

