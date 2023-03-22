Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA976C3F89
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 02:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCVBOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 21:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCVBOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 21:14:48 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E844A1E8
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:14:47 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-177b78067ffso18047533fac.7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1679447687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=euz2KV+mWXmtwI7FvvF97+gA3gyLRbRae34ehMfHzzs=;
        b=LrVyLI5Glqt1hPfYhzbr0mjFsHBo5VPe/E4HgzCQv2Mi/Y9ufR1Za20e5SQwPmezDm
         3mMWaL6rGmnFYol0Oh6b2ED20yg3FGEvmGu0ePmgejARQM90Rb2xawDnN4ST1mR6YJhZ
         FVIfBcok+wG+wJTlRTrRdJrUFWi60P5j9S71bWNveWujjdcp38YQGN/KTOfltJwWAhjk
         vYicYKCS+F9Va5wGbDWZUR9IniBaDDPIHpjMBH0rMM0XOQJuCTERfEWaZDUvjWQQ7qNV
         Yt+mGyKttjFzhLl/EqeR3pVQGW8Mselw/q6wIwo+xgSzoCRJKIPhEesZoTpnqfDCsB1w
         RCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679447687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=euz2KV+mWXmtwI7FvvF97+gA3gyLRbRae34ehMfHzzs=;
        b=3z01n/RNIWRQgfhT+M6iDvuNYdklv3y6j2dbCkSANi0d18/B4X+GSSGysVlRp6TYre
         /yt/zDaX+GNn81fIWYaG8h29vOMqE7zqK1DkPpPZJTI+etCaG8t4pA2O2ly3usAv/C/W
         vyowYviIfwJcO+3Xps+ZVFANrJtQpbGpqKsHXcRDOErySbUfOzJCbd6m996K/TDyI0Bl
         0f0khgUnEAoNlafwQXXyhgvQB2KhY0J+/louMsty/VCX8YrArCjGxsdQLkPI2FGXCpbp
         sNBGcZ2LvWInMfqoQXTl8Pwp2AV+4+VwoKMVR8Cq4Cjfypc6AjcMFdBIyUymV3VwFIF6
         Bwjw==
X-Gm-Message-State: AO0yUKXWieDxPFjsDtT9BIBW6Gf/J0yTpTFYTTkxTCUGkpuP8r4gNH9K
        DlUYn8SvWlvWAwrh0bzMjTjmHw==
X-Google-Smtp-Source: AK7set9bqh9VJetUZ/HqCZrXMiQwEHEsiZsbTRirnEeQjnMiQPdX9V6wBoGxMwtW9UTlCFxf1Ict1Q==
X-Received: by 2002:a05:6870:3289:b0:17a:b715:ab9a with SMTP id q9-20020a056870328900b0017ab715ab9amr551275oac.50.1679447686853;
        Tue, 21 Mar 2023 18:14:46 -0700 (PDT)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id tk6-20020a05687189c600b0017703cd8ff6sm4747510oab.7.2023.03.21.18.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 18:14:46 -0700 (PDT)
From:   Steev Klimaszewski <steev@kali.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>,
        Johan Hovold <johan@kernel.org>,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH v7 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
Date:   Tue, 21 Mar 2023 20:14:40 -0500
Message-Id: <20230322011442.34475-3-steev@kali.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322011442.34475-1-steev@kali.org>
References: <20230322011442.34475-1-steev@kali.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add regulators, GPIOs and changes required to power on/off wcn6855.
Add support for firmware download for wcn6855 which is in the linux-firmware
repository as hpbtfw21.tlv and hpnv21.bin.

Based on the assumption that this is similar to the wcn6750.

Signed-off-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Bjorn Andersson <andersson@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
---
Changes since v6:
 * Update commit message.
 * Add Johan's R-b and T-b.

Changes since v5:
 * Revert Set qcadev->initspeed since 6855 doesn't use it, don't touch.
 * Convert get_fw_build_info to a switch statement
 * Add poweroff handling
 * Fix up line alignments
 * Drop from microsoft extensions check since I don't actually know if we need

Changes since v4:
 * Remove unused firmware check because we don't have mbn firmware.
 * Set qcadev->init_speed if it hasn't been set.

Changes since v3:
 * drop unused regulators

Changes since v2:
 * drop unnecessary commit info

Changes since v1:
 * None

 drivers/bluetooth/btqca.c   | 14 ++++++++-
 drivers/bluetooth/btqca.h   | 10 +++++++
 drivers/bluetooth/hci_qca.c | 57 ++++++++++++++++++++++++++++---------
 3 files changed, 66 insertions(+), 15 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index c9064d34d830..fd0941fe8608 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -614,6 +614,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		config.type = ELF_TYPE_PATCH;
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/msbtfw%02x.mbn", rom_ver);
+	} else if (soc_type == QCA_WCN6855) {
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/hpbtfw%02x.tlv", rom_ver);
 	} else {
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/rampatch_%08x.bin", soc_ver);
@@ -648,6 +651,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	else if (soc_type == QCA_WCN6750)
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/msnv%02x.bin", rom_ver);
+	else if (soc_type == QCA_WCN6855)
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/hpnv%02x.bin", rom_ver);
 	else
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/nvm_%08x.bin", soc_ver);
@@ -685,11 +691,17 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		return err;
 	}
 
-	if (soc_type == QCA_WCN3991 || soc_type == QCA_WCN6750) {
+	switch (soc_type) {
+	case QCA_WCN3991:
+	case QCA_WCN6750:
+	case QCA_WCN6855:
 		/* get fw build info */
 		err = qca_read_fw_build_info(hdev);
 		if (err < 0)
 			return err;
+		break;
+	default:
+		break;
 	}
 
 	bt_dev_info(hdev, "QCA setup on UART is completed");
diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index 61e9a50e66ae..b884095bcd9d 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -147,6 +147,7 @@ enum qca_btsoc_type {
 	QCA_WCN3991,
 	QCA_QCA6390,
 	QCA_WCN6750,
+	QCA_WCN6855,
 };
 
 #if IS_ENABLED(CONFIG_BT_QCA)
@@ -168,6 +169,10 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
 {
 	return soc_type == QCA_WCN6750;
 }
+static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
+{
+	return soc_type == QCA_WCN6855;
+}
 
 #else
 
@@ -206,6 +211,11 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
 	return false;
 }
 
+static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
+{
+	return false;
+}
+
 static inline int qca_send_pre_shutdown_cmd(struct hci_dev *hdev)
 {
 	return -EOPNOTSUPP;
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 3df8c3606e93..38ff962662ff 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1317,7 +1317,8 @@ static int qca_set_baudrate(struct hci_dev *hdev, uint8_t baudrate)
 
 	/* Give the controller time to process the request */
 	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu)))
+	    qca_is_wcn6750(qca_soc_type(hu)) ||
+	    qca_is_wcn6855(qca_soc_type(hu)))
 		usleep_range(1000, 10000);
 	else
 		msleep(300);
@@ -1394,7 +1395,8 @@ static unsigned int qca_get_speed(struct hci_uart *hu,
 static int qca_check_speeds(struct hci_uart *hu)
 {
 	if (qca_is_wcn399x(qca_soc_type(hu)) ||
-	    qca_is_wcn6750(qca_soc_type(hu))) {
+	    qca_is_wcn6750(qca_soc_type(hu)) ||
+	    qca_is_wcn6855(qca_soc_type(hu))) {
 		if (!qca_get_speed(hu, QCA_INIT_SPEED) &&
 		    !qca_get_speed(hu, QCA_OPER_SPEED))
 			return -EINVAL;
@@ -1428,7 +1430,8 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 		 * changing the baudrate of chip and host.
 		 */
 		if (qca_is_wcn399x(soc_type) ||
-		    qca_is_wcn6750(soc_type))
+		    qca_is_wcn6750(soc_type) ||
+		    qca_is_wcn6855(soc_type))
 			hci_uart_set_flow_control(hu, true);
 
 		if (soc_type == QCA_WCN3990) {
@@ -1446,7 +1449,8 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
 
 error:
 		if (qca_is_wcn399x(soc_type) ||
-		    qca_is_wcn6750(soc_type))
+		    qca_is_wcn6750(soc_type) ||
+		    qca_is_wcn6855(soc_type))
 			hci_uart_set_flow_control(hu, false);
 
 		if (soc_type == QCA_WCN3990) {
@@ -1682,7 +1686,8 @@ static int qca_power_on(struct hci_dev *hdev)
 		return 0;
 
 	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type)) {
+	    qca_is_wcn6750(soc_type) ||
+	    qca_is_wcn6855(soc_type)) {
 		ret = qca_regulator_init(hu);
 	} else {
 		qcadev = serdev_device_get_drvdata(hu->serdev);
@@ -1723,7 +1728,8 @@ static int qca_setup(struct hci_uart *hu)
 
 	bt_dev_info(hdev, "setting up %s",
 		qca_is_wcn399x(soc_type) ? "wcn399x" :
-		(soc_type == QCA_WCN6750) ? "wcn6750" : "ROME/QCA6390");
+		(soc_type == QCA_WCN6750) ? "wcn6750" :
+		(soc_type == QCA_WCN6855) ? "wcn6855" : "ROME/QCA6390");
 
 	qca->memdump_state = QCA_MEMDUMP_IDLE;
 
@@ -1735,7 +1741,8 @@ static int qca_setup(struct hci_uart *hu)
 	clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
 
 	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type)) {
+	    qca_is_wcn6750(soc_type) ||
+	    qca_is_wcn6855(soc_type)) {
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 		hci_set_aosp_capable(hdev);
 
@@ -1757,7 +1764,8 @@ static int qca_setup(struct hci_uart *hu)
 	}
 
 	if (!(qca_is_wcn399x(soc_type) ||
-	     qca_is_wcn6750(soc_type))) {
+	      qca_is_wcn6750(soc_type) ||
+	      qca_is_wcn6855(soc_type))) {
 		/* Get QCA version information */
 		ret = qca_read_soc_version(hdev, &ver, soc_type);
 		if (ret)
@@ -1883,6 +1891,20 @@ static const struct qca_device_data qca_soc_data_wcn6750 = {
 	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
+static const struct qca_device_data qca_soc_data_wcn6855 = {
+	.soc_type = QCA_WCN6855,
+	.vregs = (struct qca_vreg []) {
+		{ "vddio", 5000 },
+		{ "vddbtcxmx", 126000 },
+		{ "vddrfacmn", 12500 },
+		{ "vddrfa0p8", 102000 },
+		{ "vddrfa1p7", 302000 },
+		{ "vddrfa1p2", 257000 },
+	},
+	.num_vregs = 6,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
+};
+
 static void qca_power_shutdown(struct hci_uart *hu)
 {
 	struct qca_serdev *qcadev;
@@ -1912,7 +1934,7 @@ static void qca_power_shutdown(struct hci_uart *hu)
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);
 		qca_regulator_disable(qcadev);
-	} else if (soc_type == QCA_WCN6750) {
+	} else if (soc_type == QCA_WCN6750 || soc_type == QCA_WCN6855) {
 		gpiod_set_value_cansleep(qcadev->bt_en, 0);
 		msleep(100);
 		qca_regulator_disable(qcadev);
@@ -2047,7 +2069,8 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 	if (data &&
 	    (qca_is_wcn399x(data->soc_type) ||
-	    qca_is_wcn6750(data->soc_type))) {
+	     qca_is_wcn6750(data->soc_type) ||
+	     qca_is_wcn6855(data->soc_type))) {
 		qcadev->btsoc_type = data->soc_type;
 		qcadev->bt_power = devm_kzalloc(&serdev->dev,
 						sizeof(struct qca_power),
@@ -2067,14 +2090,18 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
-		if (IS_ERR_OR_NULL(qcadev->bt_en) && data->soc_type == QCA_WCN6750) {
+		if (IS_ERR_OR_NULL(qcadev->bt_en) &&
+		    (data->soc_type == QCA_WCN6750 ||
+		     data->soc_type == QCA_WCN6855)) {
 			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
 			power_ctrl_enabled = false;
 		}
 
 		qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",
 					       GPIOD_IN);
-		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) && data->soc_type == QCA_WCN6750)
+		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) &&
+		    (data->soc_type == QCA_WCN6750 ||
+		     data->soc_type == QCA_WCN6855))
 			dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
 
 		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
@@ -2150,8 +2177,9 @@ static void qca_serdev_remove(struct serdev_device *serdev)
 	struct qca_power *power = qcadev->bt_power;
 
 	if ((qca_is_wcn399x(qcadev->btsoc_type) ||
-	     qca_is_wcn6750(qcadev->btsoc_type)) &&
-	     power->vregs_on)
+	     qca_is_wcn6750(qcadev->btsoc_type) ||
+	     qca_is_wcn6855(qcadev->btsoc_type)) &&
+	    power->vregs_on)
 		qca_power_shutdown(&qcadev->serdev_hu);
 	else if (qcadev->susclk)
 		clk_disable_unprepare(qcadev->susclk);
@@ -2335,6 +2363,7 @@ static const struct of_device_id qca_bluetooth_of_match[] = {
 	{ .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3991},
 	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
 	{ .compatible = "qcom,wcn6750-bt", .data = &qca_soc_data_wcn6750},
+	{ .compatible = "qcom,wcn6855-bt", .data = &qca_soc_data_wcn6855},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, qca_bluetooth_of_match);
-- 
2.39.2

