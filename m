Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96102C2FAE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404254AbgKXSH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404249AbgKXSH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 13:07:58 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08654C061A4D
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:07:58 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id d132so10992379qke.5
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=AdjdpVQcf0T65QuTpih/wyhMceyibAZarrTekgNRPGQ=;
        b=eadp+o8Cl4tTyUI7ESKvZMF2qQqFSz3I3CyjirELVCPZ860zaPz2Q2jH1kwRUsgTAJ
         NSl+SMTbu2600Ap6vsr+rr5F72zdmgAMD1FENe1uya7do/75m0wOcxuoegrl7hJ166Ii
         lSggECiF1fLBkdM2mpriE3+sWzmlHfC364V2gOHJ0GU/hqRt0wc3z/7zn0B+PKRJV/hW
         M0iDcy/YMdOOcoDHAuhEdCr3D2RL9P/CUwlxtLjUN7C+XKURhXPT4WZ+p91aLaVeU8yC
         0tb2k0meMUtzeQ+nmSYtGqthSAIkwDhyJ0cHMu081EB7TtcArAwDp+MXEkesiHfYjKYx
         6PUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AdjdpVQcf0T65QuTpih/wyhMceyibAZarrTekgNRPGQ=;
        b=TXUzeSHft3oPR6WZwy8tTmKtvYqG3SEcqZxEUwV0m6eWpJBnxPhSWCnwGhLFoLiiIX
         rob0gl6ngaCFR9dIhclLFOEPxmq00Hin3IwkO7SYrZa9fz2xldS622JvYWlqtU8SBTjf
         +grDRTUBgHVtzHtH5fPnT4lULHpnLSLsT9DW/TKgzdeyQSOdPNNqCX9KrFOqx3G0Zf8h
         bTnA7IEoM3RSCqkT84sxpkmezB5a4Rb/GHnAn8X7pMhq+R9IZp9Gw23UNe0a1JqsUPHh
         vnmL/dr3gU4cBpWfOEDiz8HMbQuUQ/q+wxu1EfFYLP2EVfz9T9Py09t2rCNAe50//Z/J
         aGhg==
X-Gm-Message-State: AOAM5325rCvaDeD7VMe2eSUBoC6TFA7MBMHYOZbg6SRgynpLey0yiCQ3
        bYdFQv3ZbB07RN3zpVFLQXh9FRC+sJrEkbxnKLAa
X-Google-Smtp-Source: ABdhPJx/0TuQRfMuaw00poQjuF0wS2l9AQGJGTy99+28SUsVGWDHomPh3MFQYQVYwfiifpBMFI0njh7PONY30R31lxar
Sender: "danielwinkler via sendgmr" 
        <danielwinkler@danielwinkler-linux.mtv.corp.google.com>
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a25:504c:: with SMTP id
 e73mr8363973ybb.376.1606241277164; Tue, 24 Nov 2020 10:07:57 -0800 (PST)
Date:   Tue, 24 Nov 2020 10:07:44 -0800
In-Reply-To: <20201124180746.1773091-1-danielwinkler@google.com>
Message-Id: <20201124100610.v5.3.I74255537fa99ed3c0025321008b361c6ad90a431@changeid>
Mime-Version: 1.0
References: <20201124180746.1773091-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v5 3/5] Bluetooth: Use intervals and tx power from mgmt cmds
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Daniel Winkler <danielwinkler@google.com>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch takes the min/max intervals and tx power optionally provided
in mgmt interface, stores them in the advertisement struct, and uses
them when configuring the hci requests. While tx power is not used if
extended advertising is unavailable, software rotation will use the min
and max advertising intervals specified by the client.

This change is validated manually by ensuring the min/max intervals are
propagated to the controller on both hatch (extended advertising) and
kukui (no extended advertising) chromebooks, and that tx power is
propagated correctly on hatch. These tests are performed with multiple
advertisements simultaneously.

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 include/net/bluetooth/hci_core.h |  5 ++++-
 net/bluetooth/hci_core.c         |  8 +++++---
 net/bluetooth/hci_request.c      | 29 +++++++++++++++++++----------
 net/bluetooth/mgmt.c             |  8 ++++++--
 4 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 48d144ae8b57d6..ab168f46b6d909 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -230,6 +230,8 @@ struct adv_info {
 	__u16	scan_rsp_len;
 	__u8	scan_rsp_data[HCI_MAX_AD_LENGTH];
 	__s8	tx_power;
+	__u32   min_interval;
+	__u32   max_interval;
 	bdaddr_t	random_addr;
 	bool 		rpa_expired;
 	struct delayed_work	rpa_expired_cb;
@@ -1292,7 +1294,8 @@ struct adv_info *hci_get_next_instance(struct hci_dev *hdev, u8 instance);
 int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 			 u16 adv_data_len, u8 *adv_data,
 			 u16 scan_rsp_len, u8 *scan_rsp_data,
-			 u16 timeout, u16 duration);
+			 u16 timeout, u16 duration, s8 tx_power,
+			 u32 min_interval, u32 max_interval);
 int hci_set_adv_instance_data(struct hci_dev *hdev, u8 instance,
 			 u16 adv_data_len, u8 *adv_data,
 			 u16 scan_rsp_len, u8 *scan_rsp_data);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 35afb63514f38b..3397fc706e87a1 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2951,7 +2951,8 @@ static void adv_instance_rpa_expired(struct work_struct *work)
 int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 			 u16 adv_data_len, u8 *adv_data,
 			 u16 scan_rsp_len, u8 *scan_rsp_data,
-			 u16 timeout, u16 duration)
+			 u16 timeout, u16 duration, s8 tx_power,
+			 u32 min_interval, u32 max_interval)
 {
 	struct adv_info *adv_instance;
 
@@ -2979,6 +2980,9 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 	adv_instance->flags = flags;
 	adv_instance->adv_data_len = adv_data_len;
 	adv_instance->scan_rsp_len = scan_rsp_len;
+	adv_instance->min_interval = min_interval;
+	adv_instance->max_interval = max_interval;
+	adv_instance->tx_power = tx_power;
 
 	if (adv_data_len)
 		memcpy(adv_instance->adv_data, adv_data, adv_data_len);
@@ -2995,8 +2999,6 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 	else
 		adv_instance->duration = duration;
 
-	adv_instance->tx_power = HCI_TX_POWER_INVALID;
-
 	INIT_DELAYED_WORK(&adv_instance->rpa_expired_cb,
 			  adv_instance_rpa_expired);
 
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 048d4db9d4ea53..4e31f39df96838 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1443,6 +1443,7 @@ static bool is_advertising_allowed(struct hci_dev *hdev, bool connectable)
 void __hci_req_enable_advertising(struct hci_request *req)
 {
 	struct hci_dev *hdev = req->hdev;
+	struct adv_info *adv_instance;
 	struct hci_cp_le_set_adv_param cp;
 	u8 own_addr_type, enable = 0x01;
 	bool connectable;
@@ -1450,6 +1451,7 @@ void __hci_req_enable_advertising(struct hci_request *req)
 	u32 flags;
 
 	flags = get_adv_instance_flags(hdev, hdev->cur_adv_instance);
+	adv_instance = hci_find_adv_instance(hdev, hdev->cur_adv_instance);
 
 	/* If the "connectable" instance flag was not set, then choose between
 	 * ADV_IND and ADV_NONCONN_IND based on the global connectable setting.
@@ -1481,11 +1483,16 @@ void __hci_req_enable_advertising(struct hci_request *req)
 
 	memset(&cp, 0, sizeof(cp));
 
-	if (connectable) {
-		cp.type = LE_ADV_IND;
-
+	if (adv_instance) {
+		adv_min_interval = adv_instance->min_interval;
+		adv_max_interval = adv_instance->max_interval;
+	} else {
 		adv_min_interval = hdev->le_adv_min_interval;
 		adv_max_interval = hdev->le_adv_max_interval;
+	}
+
+	if (connectable) {
+		cp.type = LE_ADV_IND;
 	} else {
 		if (get_cur_adv_instance_scan_rsp_len(hdev))
 			cp.type = LE_ADV_SCAN_IND;
@@ -1496,9 +1503,6 @@ void __hci_req_enable_advertising(struct hci_request *req)
 		    hci_dev_test_flag(hdev, HCI_LIMITED_DISCOVERABLE)) {
 			adv_min_interval = DISCOV_LE_FAST_ADV_INT_MIN;
 			adv_max_interval = DISCOV_LE_FAST_ADV_INT_MAX;
-		} else {
-			adv_min_interval = hdev->le_adv_min_interval;
-			adv_max_interval = hdev->le_adv_max_interval;
 		}
 	}
 
@@ -2021,9 +2025,15 @@ int __hci_req_setup_ext_adv_instance(struct hci_request *req, u8 instance)
 
 	memset(&cp, 0, sizeof(cp));
 
-	/* In ext adv set param interval is 3 octets */
-	hci_cpu_to_le24(hdev->le_adv_min_interval, cp.min_interval);
-	hci_cpu_to_le24(hdev->le_adv_max_interval, cp.max_interval);
+	if (adv_instance) {
+		hci_cpu_to_le24(adv_instance->min_interval, cp.min_interval);
+		hci_cpu_to_le24(adv_instance->max_interval, cp.max_interval);
+		cp.tx_power = adv_instance->tx_power;
+	} else {
+		hci_cpu_to_le24(hdev->le_adv_min_interval, cp.min_interval);
+		hci_cpu_to_le24(hdev->le_adv_max_interval, cp.max_interval);
+		cp.tx_power = HCI_ADV_TX_POWER_NO_PREFERENCE;
+	}
 
 	secondary_adv = (flags & MGMT_ADV_FLAG_SEC_MASK);
 
@@ -2046,7 +2056,6 @@ int __hci_req_setup_ext_adv_instance(struct hci_request *req, u8 instance)
 
 	cp.own_addr_type = own_addr_type;
 	cp.channel_map = hdev->le_adv_channel_map;
-	cp.tx_power = 127;
 	cp.handle = instance;
 
 	if (flags & MGMT_ADV_FLAG_SEC_2M) {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index ec6b520be368be..668a62c8181eb1 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7533,7 +7533,10 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 				   cp->adv_data_len, cp->data,
 				   cp->scan_rsp_len,
 				   cp->data + cp->adv_data_len,
-				   timeout, duration);
+				   timeout, duration,
+				   HCI_ADV_TX_POWER_NO_PREFERENCE,
+				   hdev->le_adv_min_interval,
+				   hdev->le_adv_max_interval);
 	if (err < 0) {
 		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 				      MGMT_STATUS_FAILED);
@@ -7741,7 +7744,8 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 
 	/* Create advertising instance with no advertising or response data */
 	err = hci_add_adv_instance(hdev, cp->instance, flags,
-				   0, NULL, 0, NULL, timeout, duration);
+				   0, NULL, 0, NULL, timeout, duration,
+				   tx_power, min_interval, max_interval);
 
 	if (err < 0) {
 		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_PARAMS,
-- 
2.29.2.454.gaff20da3a2-goog

