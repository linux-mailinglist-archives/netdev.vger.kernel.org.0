Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB46C4EEA7E
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 11:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344614AbiDAJhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 05:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiDAJhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 05:37:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B8D62BDF
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 02:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648805713; x=1680341713;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uyaMVm4QPUylpfbLkKqKA+djgtnXEVFlQv+q2SdbZSA=;
  b=ZUtx5+c6QFTLeKYPdnV2Q20g0z5LLEYFE5Zsskr8KP7DBh2l378Y+bMF
   7jw9BZgmAZAgylR3h3881NjX6c/Eg8Aq34GabrGxbWHdCr7U61cMLoSBU
   YBIVJy4LW1RCvso4mQTjFw1JhXaQSFw0IA3KrP9kGFUeNXm9+pPPJOGnu
   fDm+aOolhMPjHFBj6OgCE+mespp84LoZ1EOS3Dkk5BDZCiIWlKfrQw33+
   HtF2WT92IElSYBQP2cAUINjGKQCqei2UicE3nbSmqYr/UK6EWNPAKPTNW
   25ARn19uNor8MqoTjlORNZZhc9J6j05f6YUMjatPFe1Zsy3limjhkHMHl
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,226,1643698800"; 
   d="scan'208";a="151165417"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 02:35:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 02:35:12 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Apr 2022 02:35:10 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC ethtool] phy-tunables: add support for get/set rx/tx latencies
Date:   Fri, 1 Apr 2022 11:38:00 +0200
Message-ID: <20220401093800.3341760-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for "ethtool --set-phy-tunable <dev> latency-rx/tx-<speed> %d"
and "ethtool --get-phy-tunable <dev> latency-rx/tx-<speed>" to set/get
the latency of the PHY.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 ethtool.c            | 254 +++++++++++++++++++++++++++++++++++++++++++
 uapi/linux/ethtool.h |   6 +
 2 files changed, 260 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 5d718a2..01e0594 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5257,6 +5257,96 @@ static int do_get_phy_tunable(struct cmd_context *ctx)
 			fprintf(stdout,
 				"Energy Detect Power Down: enabled, TX %u msecs\n",
 				cont.msecs);
+	} else if (!strcmp(argp[0], "latency-rx-1000mbit")) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_GTUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_RX_1000MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		if (send_ioctl(ctx, &cont.latency) < 0) {
+			perror("Cannot Get PHY Latency RX 1000Mbit value");
+			return 87;
+		}
+		fprintf(stdout, "Latency RX 1000Mbit: %d\n", cont.lat);
+	} else if (!strcmp(argp[0], "latency-tx-1000mbit")) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_GTUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_TX_1000MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		if (send_ioctl(ctx, &cont.latency) < 0) {
+			perror("Cannot Get PHY Latency TX 1000Mbit value");
+			return 87;
+		}
+		fprintf(stdout, "Latency TX 1000Mbit: %d\n", cont.lat);
+	} else if (!strcmp(argp[0], "latency-rx-100mbit")) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_GTUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_RX_100MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		if (send_ioctl(ctx, &cont.latency) < 0) {
+			perror("Cannot Get PHY Latency RX 100Mbit value");
+			return 87;
+		}
+		fprintf(stdout, "Latency RX 100Mbit: %d\n", cont.lat);
+	} else if (!strcmp(argp[0], "latency-tx-100mbit")) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_GTUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_TX_100MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		if (send_ioctl(ctx, &cont.latency) < 0) {
+			perror("Cannot Get PHY Latency TX 100Mbit value");
+			return 87;
+		}
+		fprintf(stdout, "Latency TX 100Mbit: %d\n", cont.lat);
+	} else if (!strcmp(argp[0], "latency-rx-10mbit")) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_GTUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_RX_10MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		if (send_ioctl(ctx, &cont.latency) < 0) {
+			perror("Cannot Get PHY Latency RX 10Mbit value");
+			return 87;
+		}
+		fprintf(stdout, "Latency RX 10Mbit: %d\n", cont.lat);
+	} else if (!strcmp(argp[0], "latency-tx-10mbit")) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_GTUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_TX_10MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		if (send_ioctl(ctx, &cont.latency) < 0) {
+			perror("Cannot Get PHY Latency TX 10Mbit value");
+			return 87;
+		}
+		fprintf(stdout, "Latency TX 10Mbit: %d\n", cont.lat);
 	} else {
 		exit_bad_args();
 	}
@@ -5397,6 +5487,26 @@ static int parse_named_uint(struct cmd_context *ctx,
 	return 1;
 }
 
+static int parse_named_int(struct cmd_context *ctx,
+			   const char *name,
+			   long long *val,
+			   long long min,
+			   long long max)
+{
+	if (ctx->argc < 2)
+		return 0;
+
+	if (strcmp(*ctx->argp, name))
+		return 0;
+
+	*val = get_int_range(*(ctx->argp + 1), 10, min, max);
+
+	ctx->argc -= 2;
+	ctx->argp += 2;
+
+	return 1;
+}
+
 static int parse_named_u8(struct cmd_context *ctx, const char *name, u8 *val)
 {
 	unsigned long long val1;
@@ -5421,6 +5531,18 @@ static int parse_named_u16(struct cmd_context *ctx, const char *name, u16 *val)
 	return ret;
 }
 
+static int parse_named_s32(struct cmd_context *ctx, const char *name, s32 *val)
+{
+	long long val1;
+	int ret;
+
+	ret = parse_named_int(ctx, name, &val1, INT_MIN, INT_MAX);
+	if (ret)
+		*val = val1;
+
+	return ret;
+}
+
 static int do_set_phy_tunable(struct cmd_context *ctx)
 {
 	int err = 0;
@@ -5430,6 +5552,12 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
 	u8 fld_msecs = ETHTOOL_PHY_FAST_LINK_DOWN_ON;
 	u8 edpd_changed = 0, edpd_enable = 0;
 	u16 edpd_tx_interval = ETHTOOL_PHY_EDPD_DFLT_TX_MSECS;
+	u8 latency_rx_1000mbit_changed = 0, latency_tx_1000mbit_changed = 0;
+	u8 latency_rx_100mbit_changed = 0, latency_tx_100mbit_changed = 0;
+	u8 latency_rx_10mbit_changed = 0, latency_tx_10mbit_changed = 0;
+	s32 latency_rx_1000mbit_val = 0, latency_tx_1000mbit_val = 0;
+	s32 latency_rx_100mbit_val = 0, latency_tx_100mbit_val = 0;
+	s32 latency_rx_10mbit_val = 0, latency_tx_10mbit_val = 0;
 
 	/* Parse arguments */
 	if (parse_named_bool(ctx, "downshift", &ds_enable)) {
@@ -5444,6 +5572,24 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
 		edpd_changed = 1;
 		if (edpd_enable)
 			parse_named_u16(ctx, "msecs", &edpd_tx_interval);
+	} else if (parse_named_s32(ctx, "latency-rx-1000mbit",
+				   &latency_rx_1000mbit_val)) {
+		latency_rx_1000mbit_changed = 1;
+	} else if (parse_named_s32(ctx, "latency-tx-1000mbit",
+				   &latency_tx_1000mbit_val)) {
+		latency_tx_1000mbit_changed = 1;
+	} else if (parse_named_s32(ctx, "latency-rx-100mbit",
+				   &latency_rx_100mbit_val)) {
+		latency_rx_100mbit_changed = 1;
+	} else if (parse_named_s32(ctx, "latency-tx-100mbit",
+				   &latency_tx_100mbit_val)) {
+		latency_tx_100mbit_changed = 1;
+	} else if (parse_named_s32(ctx, "latency-rx-10mbit",
+				   &latency_rx_10mbit_val)) {
+		latency_rx_10mbit_changed = 1;
+	} else if (parse_named_s32(ctx, "latency-tx-10mbit",
+				   &latency_tx_10mbit_val)) {
+		latency_tx_10mbit_changed = 1;
 	} else {
 		exit_bad_args();
 	}
@@ -5529,6 +5675,102 @@ static int do_set_phy_tunable(struct cmd_context *ctx)
 			perror("Cannot Set PHY Energy Detect Power Down");
 			err = 87;
 		}
+	} else if (latency_rx_1000mbit_changed) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_STUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_RX_1000MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		cont.lat = latency_rx_1000mbit_val;
+		err = send_ioctl(ctx, &cont.latency);
+		if (err < 0) {
+			perror("Cannot Set PHY Latency RX 1000Mbit value");
+			err = 87;
+		}
+	} else if (latency_tx_1000mbit_changed) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_STUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_TX_1000MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		cont.lat = latency_tx_1000mbit_val;
+		err = send_ioctl(ctx, &cont.latency);
+		if (err < 0) {
+			perror("Cannot Set PHY Latency TX 1000Mbit value");
+			err = 87;
+		}
+	} else if (latency_rx_100mbit_changed) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_STUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_RX_100MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		cont.lat = latency_rx_100mbit_val;
+		err = send_ioctl(ctx, &cont.latency);
+		if (err < 0) {
+			perror("Cannot Set PHY Latency RX 100Mbit value");
+			err = 87;
+		}
+	} else if (latency_tx_100mbit_changed) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_STUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_TX_100MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		cont.lat = latency_tx_100mbit_val;
+		err = send_ioctl(ctx, &cont.latency);
+		if (err < 0) {
+			perror("Cannot Set PHY Latency TX 100Mbit value");
+			err = 87;
+		}
+	} else if (latency_rx_10mbit_changed) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_STUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_RX_10MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		cont.lat = latency_rx_10mbit_val;
+		err = send_ioctl(ctx, &cont.latency);
+		if (err < 0) {
+			perror("Cannot Set PHY Latency RX 10Mbit value");
+			err = 87;
+		}
+	} else if (latency_tx_10mbit_changed) {
+		struct {
+			struct ethtool_tunable latency;
+			s32 lat;
+		} cont;
+
+		cont.latency.cmd = ETHTOOL_PHY_STUNABLE;
+		cont.latency.id = ETHTOOL_PHY_LATENCY_TX_10MBIT;
+		cont.latency.type_id = ETHTOOL_TUNABLE_S32;
+		cont.latency.len = 4;
+		cont.lat = latency_tx_10mbit_val;
+		err = send_ioctl(ctx, &cont.latency);
+		if (err < 0) {
+			perror("Cannot Set PHY Latency TX 10Mbit value");
+			err = 87;
+		}
 	}
 
 	return err;
@@ -5952,6 +6194,12 @@ static const struct option args[] = {
 		.xhelp	= "		[ downshift on|off [count N] ]\n"
 			  "		[ fast-link-down on|off [msecs N] ]\n"
 			  "		[ energy-detect-power-down on|off [msecs N] ]\n"
+			  "		[ latency-rx-1000mbit %d ]\n"
+			  "		[ latency-tx-1000mbit %d ]\n"
+			  "		[ latency-rx-100mbit %d ]\n"
+			  "		[ latency-tx-100mbit %d ]\n"
+			  "		[ latency-rx-10mbit %d ]\n"
+			  "		[ latency-tx-10mbit %d ]\n"
 	},
 	{
 		.opts	= "--get-phy-tunable",
@@ -5960,6 +6208,12 @@ static const struct option args[] = {
 		.xhelp	= "		[ downshift ]\n"
 			  "		[ fast-link-down ]\n"
 			  "		[ energy-detect-power-down ]\n"
+			  "		[ latency-rx-1000mbit ]\n"
+			  "		[ latency-tx-1000mbit ]\n"
+			  "		[ latency-rx-100mbit ]\n"
+			  "		[ latency-tx-100mbit ]\n"
+			  "		[ latency-rx-10mbit ]\n"
+			  "		[ latency-tx-10mbit ]\n"
 	},
 	{
 		.opts	= "--get-tunable",
diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 85548f9..01c07a6 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -294,6 +294,12 @@ enum phy_tunable_id {
 	ETHTOOL_PHY_DOWNSHIFT,
 	ETHTOOL_PHY_FAST_LINK_DOWN,
 	ETHTOOL_PHY_EDPD,
+	ETHTOOL_PHY_LATENCY_RX_10MBIT,
+	ETHTOOL_PHY_LATENCY_TX_10MBIT,
+	ETHTOOL_PHY_LATENCY_RX_100MBIT,
+	ETHTOOL_PHY_LATENCY_TX_100MBIT,
+	ETHTOOL_PHY_LATENCY_RX_1000MBIT,
+	ETHTOOL_PHY_LATENCY_TX_1000MBIT,
 	/*
 	 * Add your fresh new phy tunable attribute above and remember to update
 	 * phy_tunable_strings[] in net/ethtool/common.c
-- 
2.33.0

