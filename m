Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9DF1FA276
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 23:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731761AbgFOVGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 17:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731668AbgFOVGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 17:06:42 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6137AC08C5C2
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:06:42 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id s6so1089791vkb.9
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZLvWjCloxY3lhqt5Y/n4uc8TQYyU0FRxQJFsgkejp+0=;
        b=oHJ0ysAF5smXaRh+kIKQMkrbriZOwor9F6OemiNx01/wXgAGLwhBlbIEEMKQo62y91
         4LBerGtB5SmuUX4V2ewdAzu2N6Gwp6ppHZB0kEk/M7lOth5nWq3B583KxSorq0f4tqaK
         bgHWuFAYGHgv2uGoMyEC6gCqFR0FXFav+ulME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZLvWjCloxY3lhqt5Y/n4uc8TQYyU0FRxQJFsgkejp+0=;
        b=MoLqmaoKCjXEUUTWJNy1GHY/j4VLsJk4O8VNhOsRs4iNQkg8ZIBFaywjusjIuioxII
         mZIGaNHl1fYt3Mxi9leUcT+q8bhlgFDnWMOnyweZjUDg3eFP0A896MvfVwYIHW82PtVQ
         ITv0MubgnMfYgXyC/UB1dOzd2U742X+ZILqjbjB3gPIN2OKuDXgxiaE1O6085nLL14nN
         GpfccMrEqW0gbQXJpnXN9LTXIHiEvxPisXdFQGKXAm4E8eA10zXYKE+n+XHusdbepLJ0
         5aWT5llqYhdhKpzUK1bOhlviXSXEf6GteLMLzj3ajXg41Bkw16gpw3KsDLmxTFPw1ssn
         sZjg==
X-Gm-Message-State: AOAM532REx3ZOPRO5qC46v75QAjBwPhz9nRo0k3XyeqDVISk5gYtnRiy
        LUCpBDsIickCRTOiq/EApfzq5A==
X-Google-Smtp-Source: ABdhPJzjezht/+Uj1VbmlPsJCoJsHI9A++v/BYMYgyek0uRnOZTj2+CK/NUWfHuYenZe3qyJwG8UhQ==
X-Received: by 2002:a05:6122:33a:: with SMTP id d26mr20565530vko.30.1592255201576;
        Mon, 15 Jun 2020 14:06:41 -0700 (PDT)
Received: from alain.c.googlers.com.com (252.177.243.35.bc.googleusercontent.com. [35.243.177.252])
        by smtp.gmail.com with ESMTPSA id g22sm27554vso.8.2020.06.15.14.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 14:06:40 -0700 (PDT)
From:   Alain Michaud <alainm@chromium.org>
To:     linux-bluetooth@vger.kernel.org
Cc:     Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2] bluetooth: Adding a configurable autoconnect timeout
Date:   Mon, 15 Jun 2020 21:06:38 +0000
Message-Id: <20200615210638.132889-1-alainm@chromium.org>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a configurable LE autoconnect timeout.

Signed-off-by: Alain Michaud <alainm@chromium.org>
---

Changes in v1:
Fixing longer than 80 char line.

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         |  1 +
 net/bluetooth/hci_event.c        |  2 +-
 net/bluetooth/hci_request.c      |  4 ++--
 net/bluetooth/mgmt_config.c      | 13 +++++++++++++
 5 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 0d5dbb6cb5a0..f8e800479608 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -340,6 +340,7 @@ struct hci_dev {
 	__u16		def_br_lsto;
 	__u16		def_page_timeout;
 	__u16		def_multi_adv_rotation_duration;
+	__u16		def_le_autoconnect_timeout;
 
 	__u16		pkt_type;
 	__u16		esco_type;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 4f1052a7c488..73fb0843fb89 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3422,6 +3422,7 @@ struct hci_dev *hci_alloc_dev(void)
 	hdev->le_rx_def_phys = HCI_LE_SET_PHY_1M;
 	hdev->le_num_of_adv_sets = HCI_MAX_ADV_INSTANCES;
 	hdev->def_multi_adv_rotation_duration = HCI_DEFAULT_ADV_DURATION;
+	hdev->def_le_autoconnect_timeout = HCI_LE_AUTOCONN_TIMEOUT;
 
 	hdev->rpa_timeout = HCI_DEFAULT_RPA_TIMEOUT;
 	hdev->discov_interleaved_timeout = DISCOV_INTERLEAVED_TIMEOUT;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cfeaee347db3..beb9bb1da0ba 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5319,7 +5319,7 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 	}
 
 	conn = hci_connect_le(hdev, addr, addr_type, BT_SECURITY_LOW,
-			      HCI_LE_AUTOCONN_TIMEOUT, HCI_ROLE_MASTER,
+			      hdev->def_le_autoconnect_timeout, HCI_ROLE_MASTER,
 			      direct_rpa);
 	if (!IS_ERR(conn)) {
 		/* If HCI_AUTO_CONN_EXPLICIT is set, conn is already owned
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 04f846958ad6..9b011c539281 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -2791,8 +2791,8 @@ static void start_discovery(struct hci_dev *hdev, u8 *status)
 			 * to do BR/EDR inquiry.
 			 */
 			hci_req_sync(hdev, interleaved_discov,
-				     hdev->le_scan_int_discovery * 2, HCI_CMD_TIMEOUT,
-				     status);
+				     hdev->le_scan_int_discovery * 2,
+				     HCI_CMD_TIMEOUT, status);
 			break;
 		}
 
diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index f6dfbe93542c..0ff77ef05fc5 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -17,6 +17,12 @@
 	{ cpu_to_le16(hdev->_param_name_) } \
 }
 
+#define HDEV_PARAM_U16_JIFFIES_TO_MSECS(_param_code_, _param_name_) \
+{ \
+	{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
+	{ cpu_to_le16(jiffies_to_msecs(hdev->_param_name_)) } \
+}
+
 int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 			   u16 data_len)
 {
@@ -59,6 +65,8 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		HDEV_PARAM_U16(0x0018, le_conn_max_interval),
 		HDEV_PARAM_U16(0x0019, le_conn_latency),
 		HDEV_PARAM_U16(0x001a, le_supv_timeout),
+		HDEV_PARAM_U16_JIFFIES_TO_MSECS(0x001b,
+						def_le_autoconnect_timeout),
 	};
 	struct mgmt_rp_read_def_system_config *rp = (void *)params;
 
@@ -129,6 +137,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x0018:
 		case 0x0019:
 		case 0x001a:
+		case 0x001b:
 			if (len != sizeof(u16)) {
 				bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
 					    len, sizeof(u16), type);
@@ -238,6 +247,10 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x0001a:
 			hdev->le_supv_timeout = TLV_GET_LE16(buffer);
 			break;
+		case 0x0001b:
+			hdev->def_le_autoconnect_timeout =
+					msecs_to_jiffies(TLV_GET_LE16(buffer));
+			break;
 		default:
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
-- 
2.27.0.290.gba653c62da-goog

