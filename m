Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF92C4DFE
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 05:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbgKZEWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 23:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387625AbgKZEWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 23:22:49 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF960C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 20:22:49 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 4so1237324ybv.11
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 20:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=OEmCYU2wE2pMwO9qaMpsDa79P/ofsNacQ+feLvvDdbE=;
        b=STf4eE3pfgxCyhwWt+LTitCOCfInJE/KMsuIjgDAYgXLjvzcRY4SOzGthXqp/3C8j/
         z7HYYHsz515hqxVJYKhZV40GWExlUAiqj3gEqwX7zD9ZLfV2JK2j+kfKZSeGozC2fOP+
         LoUsE2GgSdEeyhZy2Oul1dhlRiCiKeH1J9c7AECPpJJ1fs+EIBy739iF0L1ew19s6JSH
         xAu/7CCOjWTWexShnYk36/Na6oCf9Nig3N1JypGKkSTRcdZpLPSXbcqbUcXs8YYZ8srF
         gUkk9hT5hnmp233/l8CON2TpVQdJUJxor57jmeY4ZB9xPFxmUt/1ax3KUz+JczXrWs2d
         wJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OEmCYU2wE2pMwO9qaMpsDa79P/ofsNacQ+feLvvDdbE=;
        b=VbAMlQQG8ptQtR7dXtaoGxHop1RuBflkRmiOEUei3dAc6hI8m5x05bwpKPvYum/nVY
         w4+HcTtNaO58LB1JSxVeS2neBTeF/1QXNJCZS9xYueuPW9sbnKOt45Ytk3nbN/R9vSym
         0Y7e5TvQjE4ANY7BwKdsOos/5ipr8PAINs8KMnyp1wmFEs36wfd1Ll0hRcdhraJEG7r8
         Y6u+n6B38YWOzq9nrIxi4oeojoR9ZxpBswuvh0IGrzvc7gcF3CGatqgMu8BwMgNExZzQ
         kSS8CayHnkLMz4bnSQJA6Bt2wG5oIqyVXy25vVZb/PCR4dFgjNFPnADosxWVEy/6vwKy
         nFPA==
X-Gm-Message-State: AOAM530zWEzWWfLoBitmzisgoUukJA6ejgugEuN34zmWRarirn8TwCjx
        M1zyC0ElW3udVj/C2OS964NrhPOGD83MH4pGZg==
X-Google-Smtp-Source: ABdhPJyJPvTdX6cnHg9r5S5byve52ylm8v9Tw9Lfek0Vg61lMmjC6V3sPbNP2HXv+g/NvXl6PEmtWuZF//PJomJGrg==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a25:6949:: with SMTP id
 e70mr1356451ybc.313.1606364568995; Wed, 25 Nov 2020 20:22:48 -0800 (PST)
Date:   Thu, 26 Nov 2020 12:22:25 +0800
In-Reply-To: <20201126122109.v11.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20201126122109.v11.5.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20201126122109.v11.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v11 5/5] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.org,
        Howard Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a configurable parameter to switch off the interleave
scan feature.

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

(no changes since v9)

Changes in v9:
- Update and rename the macro TLV_GET_LE8

Changes in v7:
- Fix bt_dev_warn arguemnt type warning

Changes in v6:
- Set EnableAdvMonInterleaveScan to 1 byte long

Changes in v4:
- Set EnableAdvMonInterleaveScan default to Disable
- Fix 80 chars limit in mgmt_config.c

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         |  1 +
 net/bluetooth/hci_request.c      |  3 ++-
 net/bluetooth/mgmt_config.c      | 41 +++++++++++++++++++++++++-------
 4 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index cfede18709d8f..63c6d656564a1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -363,6 +363,7 @@ struct hci_dev {
 	__u32		clock;
 	__u16		advmon_allowlist_duration;
 	__u16		advmon_no_filter_duration;
+	__u8		enable_advmon_interleave_scan;
 
 	__u16		devid_source;
 	__u16		devid_vendor;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 20506b31492d6..8cfcf43eb08fd 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3594,6 +3594,7 @@ struct hci_dev *hci_alloc_dev(void)
 
 	hdev->advmon_allowlist_duration = 300;
 	hdev->advmon_no_filter_duration = 500;
+	hdev->enable_advmon_interleave_scan = 0x00;	/* Default to disable */
 
 	hdev->sniff_max_interval = 800;
 	hdev->sniff_min_interval = 80;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 0c326e32e240c..d0d0fbbb3fa57 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1057,7 +1057,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 				      &own_addr_type))
 		return;
 
-	if (__hci_update_interleaved_scan(hdev))
+	if (hdev->enable_advmon_interleave_scan &&
+	    __hci_update_interleaved_scan(hdev))
 		return;
 
 	bt_dev_dbg(hdev, "interleave state %d", hdev->interleave_scan_state);
diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index 282fbf82f3192..1deb0ca7a9297 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -17,12 +17,24 @@
 		__le16 value; \
 	} __packed _param_name_
 
+#define HDEV_PARAM_U8(_param_name_) \
+	struct {\
+		struct mgmt_tlv entry; \
+		__u8 value; \
+	} __packed _param_name_
+
 #define TLV_SET_U16(_param_code_, _param_name_) \
 	{ \
 		{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
 		cpu_to_le16(hdev->_param_name_) \
 	}
 
+#define TLV_SET_U8(_param_code_, _param_name_) \
+	{ \
+		{ cpu_to_le16(_param_code_), sizeof(__u8) }, \
+		hdev->_param_name_ \
+	}
+
 #define TLV_SET_U16_JIFFIES_TO_MSECS(_param_code_, _param_name_) \
 	{ \
 		{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
@@ -65,6 +77,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		HDEV_PARAM_U16(def_le_autoconnect_timeout);
 		HDEV_PARAM_U16(advmon_allowlist_duration);
 		HDEV_PARAM_U16(advmon_no_filter_duration);
+		HDEV_PARAM_U8(enable_advmon_interleave_scan);
 	} __packed rp = {
 		TLV_SET_U16(0x0000, def_page_scan_type),
 		TLV_SET_U16(0x0001, def_page_scan_int),
@@ -97,6 +110,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 					     def_le_autoconnect_timeout),
 		TLV_SET_U16(0x001d, advmon_allowlist_duration),
 		TLV_SET_U16(0x001e, advmon_no_filter_duration),
+		TLV_SET_U8(0x001f, enable_advmon_interleave_scan),
 	};
 
 	bt_dev_dbg(hdev, "sock %p", sk);
@@ -109,6 +123,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 
 #define TO_TLV(x)		((struct mgmt_tlv *)(x))
 #define TLV_GET_LE16(tlv)	le16_to_cpu(*((__le16 *)(TO_TLV(tlv)->value)))
+#define TLV_GET_U8(tlv)		(*((__u8 *)(TO_TLV(tlv)->value)))
 
 int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 			  u16 data_len)
@@ -125,6 +140,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 	/* First pass to validate the tlv */
 	while (buffer_left >= sizeof(struct mgmt_tlv)) {
 		const u8 len = TO_TLV(buffer)->length;
+		size_t exp_type_len;
 		const u16 exp_len = sizeof(struct mgmt_tlv) +
 				    len;
 		const u16 type = le16_to_cpu(TO_TLV(buffer)->type);
@@ -170,20 +186,26 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x001b:
 		case 0x001d:
 		case 0x001e:
-			if (len != sizeof(u16)) {
-				bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
-					    len, sizeof(u16), type);
-
-				return mgmt_cmd_status(sk, hdev->id,
-					MGMT_OP_SET_DEF_SYSTEM_CONFIG,
-					MGMT_STATUS_INVALID_PARAMS);
-			}
+			exp_type_len = sizeof(u16);
+			break;
+		case 0x001f:
+			exp_type_len = sizeof(u8);
 			break;
 		default:
+			exp_type_len = 0;
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
 		}
 
+		if (exp_type_len && len != exp_type_len) {
+			bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
+				    len, exp_type_len, type);
+
+			return mgmt_cmd_status(sk, hdev->id,
+				MGMT_OP_SET_DEF_SYSTEM_CONFIG,
+				MGMT_STATUS_INVALID_PARAMS);
+		}
+
 		buffer_left -= exp_len;
 		buffer += exp_len;
 	}
@@ -289,6 +311,9 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x0001e:
 			hdev->advmon_no_filter_duration = TLV_GET_LE16(buffer);
 			break;
+		case 0x0001f:
+			hdev->enable_advmon_interleave_scan = TLV_GET_U8(buffer);
+			break;
 		default:
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
-- 
2.29.2.454.gaff20da3a2-goog

