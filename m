Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964DE649C35
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiLLKbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiLLK36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:29:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE98F101FC;
        Mon, 12 Dec 2022 02:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670840908; x=1702376908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oEQIPWDenFClIvnZCUXjihndSreluBl3o/FZOfExQ+0=;
  b=A8qU5Lg0b9N6eDrF2YAS9XcYCfdXha880152Xm71mQ0cxd3x3AvBOzWo
   KWbS5Q1UOLgIciM7s3wzFWxJcqfoDzXKNmczakJK+LUh4iwbFYVtnRBtG
   6/GL14ys11kQUHOLWeYWvGeoe+yrWP6GF/cuescKNGr7f3paD3falfp0K
   oDm3N1ArMx3p57Bb8KIO2CfHbg1erTIVPf6heb1OTRguj20g5//PZdnUt
   5b8283Tmxx0thyb9XqcfohdlMgguOs93d2zhtfNNOrgT6Qi+RKpBOJXCP
   1O+pbmJT7TT1l9dTK5bFt16yGJdWedLbu67R12OOrRkqsGWfu3GbYp6WI
   w==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="187686761"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 03:28:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 03:28:26 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 03:28:20 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v4 11/13] net: dsa: microchip: ptp: add support for perout programmable pins
Date:   Mon, 12 Dec 2022 15:56:37 +0530
Message-ID: <20221212102639.24415-12-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212102639.24415-1-arun.ramadoss@microchip.com>
References: <20221212102639.24415-1-arun.ramadoss@microchip.com>
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
index 2bc3ed72dc56..ea0b7f9fbb97 100644
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
@@ -785,6 +789,23 @@ static int ksz_ptp_enable(struct ptp_clock_info *ptp,
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
@@ -820,6 +841,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	struct ksz_device *dev = ds->priv;
 	struct ksz_ptp_data *ptp_data;
 	int ret;
+	u8 i;
 
 	ptp_data = &dev->ptp_data;
 	mutex_init(&ptp_data->lock);
@@ -834,12 +856,25 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
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

