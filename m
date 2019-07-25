Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1EA74729
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 08:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387508AbfGYGbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 02:31:13 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44309 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbfGYGbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 02:31:13 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so22962781plr.11
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 23:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8XFmRxjQUZHfVuRq3opWFethuoNp09CnP8B4IXsgP2g=;
        b=lDvH4bOZdi3rf06kd04Z6/z7aZTM9n3BDjMG1P4MiI9U2bq4ihnjOdRiMDojZC3cdQ
         wQVDtkyW1W70wY/r0o/WnUlce5m9eCRRyGMdpQ4C2L0z/2p2CMuMdijk7f2tAaaJa6MO
         Di5KFe+egyDw/zmlP597M+we8ZV9NleQEAOlCUnTEEEuClbE37sd0XDyZy/6kzhu15IE
         rB+OziPI0jqEn9heW52ZFS9rJC/mc8iS9f/OPH+vLM/DQVuniiQGxBZpcCSszPNt8CZc
         QF943y7g3Cn55w26SgFH4CQGfT0pPyz2G9P4yZ+5x+2pbuhPDtDJRrqtxFuQ+BYDAZWf
         iiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8XFmRxjQUZHfVuRq3opWFethuoNp09CnP8B4IXsgP2g=;
        b=TMbbKIiAhM0vbA5nz6ClZROPAH0OlffoCsvbo9ivouDppZ1uDFbi2wynMVhy318Lm/
         n8zKtvJ0UhzMIef0uThInTVxOsoc9AtN3yxb2I2wi2QkipYf3h4EYSCaE9OSU0537ZWw
         6YhtoNrjcLie0MS6VIaJ6Dnjo+gsU6jLM+sQxkofL8XJEWUojmAijKI9dmymo6UfiSH5
         sDlFj4gh8lyOC0kBz2XWf54E4/v1scVUfVpJ5iBQb6IkMrkfp/lGSjyEbdctE8cHcUbN
         vgkrBralgZNf2W1syInmlk0fk+CTnvSYDoGcLDy4vbdXiYgYPJzpGAoP8P1pNwpLQwHf
         JKXg==
X-Gm-Message-State: APjAAAVgTDGxo5uuQEQX/AxAu4gPJFvIxx+U8cT2BQEhPJxG0iZyS2P1
        1e3xO26MTjmimeKypzr/g71m4dUv3oI=
X-Google-Smtp-Source: APXvYqz6+fZBBApCPKsAaDn53hy/LvF1r11aSW4WKDF6l32eyUiF7aK+w6f4RqwdNS/8CTcIi1LqWg==
X-Received: by 2002:a17:902:7c90:: with SMTP id y16mr90845841pll.238.1564036272112;
        Wed, 24 Jul 2019 23:31:12 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id w18sm61226317pfj.37.2019.07.24.23.31.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 23:31:11 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH] ath10k: Fix HOST capability QMI incompatibility
Date:   Wed, 24 Jul 2019 23:31:08 -0700
Message-Id: <20190725063108.15790-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The introduction of 768ec4c012ac ("ath10k: update HOST capability QMI
message") served the purpose of supporting the new and extended HOST
capability QMI message.

But while the new message adds a slew of optional members it changes the
data type of the "daemon_support" member, which means that older
versions of the firmware will fail to decode the incoming request
message.

There is no way to detect this breakage from Linux and there's no way to
recover from sending the wrong message (i.e. we can't just try one
format and then fallback to the other), so a quirk is introduced in
DeviceTree to indicate to the driver that the firmware requires the 8bit
version of this message.

Cc: stable@vger.kernel.org
Fixes: 768ec4c012ac ("ath10k: update HOST capability qmi message")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 .../bindings/net/wireless/qcom,ath10k.txt     |  6 +++++
 drivers/net/wireless/ath/ath10k/qmi.c         | 13 ++++++++---
 .../net/wireless/ath/ath10k/qmi_wlfw_v01.c    | 22 +++++++++++++++++++
 .../net/wireless/ath/ath10k/qmi_wlfw_v01.h    |  1 +
 drivers/net/wireless/ath/ath10k/snoc.c        | 11 ++++++++++
 drivers/net/wireless/ath/ath10k/snoc.h        |  1 +
 6 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index ae661e65354e..f9499b20d840 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -81,6 +81,12 @@ Optional properties:
 	Definition: Name of external front end module used. Some valid FEM names
 		    for example: "microsemi-lx5586", "sky85703-11"
 		    and "sky85803" etc.
+- qcom,snoc-host-cap-8bit-quirk:
+	Usage: Optional
+	Value type: <empty>
+	Definition: Quirk specifying that the firmware expects the 8bit version
+		    of the host capability QMI request
+
 
 Example (to supply PCI based wifi block details):
 
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 3b63b6257c43..545ac1f06997 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -581,22 +581,29 @@ static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
 {
 	struct wlfw_host_cap_resp_msg_v01 resp = {};
 	struct wlfw_host_cap_req_msg_v01 req = {};
+	struct qmi_elem_info *req_ei;
 	struct ath10k *ar = qmi->ar;
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	struct qmi_txn txn;
 	int ret;
 
 	req.daemon_support_valid = 1;
 	req.daemon_support = 0;
 
-	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
-			   wlfw_host_cap_resp_msg_v01_ei, &resp);
+	ret = qmi_txn_init(&qmi->qmi_hdl, &txn, wlfw_host_cap_resp_msg_v01_ei,
+			   &resp);
 	if (ret < 0)
 		goto out;
 
+	if (test_bit(ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK, &ar_snoc->flags))
+		req_ei = wlfw_host_cap_8bit_req_msg_v01_ei;
+	else
+		req_ei = wlfw_host_cap_req_msg_v01_ei;
+
 	ret = qmi_send_request(&qmi->qmi_hdl, NULL, &txn,
 			       QMI_WLFW_HOST_CAP_REQ_V01,
 			       WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN,
-			       wlfw_host_cap_req_msg_v01_ei, &req);
+			       req_ei, &req);
 	if (ret < 0) {
 		qmi_txn_cancel(&txn);
 		ath10k_err(ar, "failed to send host capability request: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
index 1fe05c6218c3..86fcf4e1de5f 100644
--- a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
+++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
@@ -1988,6 +1988,28 @@ struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[] = {
 	{}
 };
 
+struct qmi_elem_info wlfw_host_cap_8bit_req_msg_v01_ei[] = {
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x10,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   daemon_support_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x10,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   daemon_support),
+	},
+	{}
+};
+
 struct qmi_elem_info wlfw_host_cap_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
diff --git a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
index bca1186e1560..4d107e1364a8 100644
--- a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
+++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
@@ -575,6 +575,7 @@ struct wlfw_host_cap_req_msg_v01 {
 
 #define WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN 189
 extern struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[];
+extern struct qmi_elem_info wlfw_host_cap_8bit_req_msg_v01_ei[];
 
 struct wlfw_host_cap_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index b491361e6ed4..fc15a0037f0e 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1261,6 +1261,15 @@ static int ath10k_snoc_resource_init(struct ath10k *ar)
 	return ret;
 }
 
+static void ath10k_snoc_quirks_init(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	struct device *dev = &ar_snoc->dev->dev;
+
+	if (of_property_read_bool(dev->of_node, "qcom,snoc-host-cap-8bit-quirk"))
+		set_bit(ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK, &ar_snoc->flags);
+}
+
 int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
@@ -1678,6 +1687,8 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	ar->ce_priv = &ar_snoc->ce;
 	msa_size = drv_data->msa_size;
 
+	ath10k_snoc_quirks_init(ar);
+
 	ret = ath10k_snoc_resource_init(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to initialize resource: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index d62f53501fbb..9db823e46314 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -63,6 +63,7 @@ enum ath10k_snoc_flags {
 	ATH10K_SNOC_FLAG_REGISTERED,
 	ATH10K_SNOC_FLAG_UNREGISTERING,
 	ATH10K_SNOC_FLAG_RECOVERY,
+	ATH10K_SNOC_FLAG_8BIT_HOST_CAP_QUIRK,
 };
 
 struct ath10k_snoc {
-- 
2.18.0

