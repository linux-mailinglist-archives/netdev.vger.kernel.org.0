Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE692C4DF4
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 05:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387591AbgKZEWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 23:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387541AbgKZEWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 23:22:36 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44BFC0617A7
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 20:22:34 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id n62so1208031ybf.19
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 20:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=gG/lxrx7FpQ05LAwklQlG9ac6wkfMe43jAdzGfhKsfw=;
        b=rBbe2j788MAoQ27LgT2cMbii7UmZPjd/206slpeeZh6VAET/Qc1oaaPDRcJ8FIVVna
         rZgE6D0r6sPzWKBaxCgQznzgQCFOJdJ7ZwmIU5ieER6XCbnBjukt6Pm94MDxMnamq/Dd
         M2z20Ug4j6Pdy+djmd8N0mEfJvJDOP3CsIqfc9lTbTTlfd/H7sMZv+VX1RdzFILSuMdW
         hIHrvDNjVYhNkhK2KFGCZX1slGU/PkeTI/HoiGfUdmvX8dA1jAkRLnkN2K7dDuuy09gh
         EGIkuNAL4QdtyEcD6bmT3NRgoxOveLn3npJBIKib/Od1SvF9xf37ekM+2CC8EHMut81K
         9R9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=gG/lxrx7FpQ05LAwklQlG9ac6wkfMe43jAdzGfhKsfw=;
        b=jIZ+CxUE4aL1iFoBp2ou7/Jfj+cFFWpED+dxBXqJmUtO36EkiN1bNffaV+5yCwMSNt
         dbCzHXSha9CTnOFBA1p5wUpmT6k790H/KbZAp/CKAcndr5Jx+VxfU8UZp9EMBf9mA+mo
         MNHF8z1p6GzgJphfHTrv6ofgEIAoCrCssxI/kD9GuHDjmHZOdPh1FRh8g1K8DtlapTS8
         KFHyQ2gJAylqgasP2bMF7WsGcDhZA1c/9iutE7uOmLSEGu10LD2qKOz+oNg5PkotdeYP
         xJM+ksSavmHtoqH3GOfhFqVJzK6Iks0hGH2QOu1X9i75SaL0GKnHWxrqxZd7yvgLXBXQ
         x2Iw==
X-Gm-Message-State: AOAM530KZGwlJlDyHYYoO15DB+IGy/mQqpB4tIxlSnrUWGlQhz1lOlDX
        D7/ISivOLls6H5RcrC9pSV2rKXiZurfBMDeCWQ==
X-Google-Smtp-Source: ABdhPJzVqag7BKTib97vEXOnr4Fel8MOXhUZxa6njJUrPCjzjzswMCMmDkLPEeSlXqW+tgN2dkMjZYvPB0Bbln7/hQ==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a25:2d55:: with SMTP id
 s21mr1135187ybe.389.1606364553770; Wed, 25 Nov 2020 20:22:33 -0800 (PST)
Date:   Thu, 26 Nov 2020 12:22:21 +0800
Message-Id: <20201126122109.v11.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v11 1/5] Bluetooth: Interleave with allowlist scan
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

This patch implements the interleaving between allowlist scan and
no-filter scan. It'll be used to save power when at least one monitor is
registered and at least one pending connection or one device to be
scanned for.

The durations of the allowlist scan and the no-filter scan are
controlled by MGMT command: Set Default System Configuration. The
default values are set randomly for now.

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
---

Changes in v11:
- Add signed-off-by lines in patch 4/5, 5/5

Changes in v10:
- remove comment about setting default values
- rename should_interleaving to use_interleaving
- rebase on new bluetooth-next/master (previous patch was applied)

Changes in v9:
- Fix compile warning on patch 6/6

Changes in v8:
- Simplified logic in __hci_update_interleaved_scan
- Remove hdev->name when calling bt_dev_dbg
- Remove 'default' in hci_req_add_le_interleaved_scan switch block
- Remove {} around :1915
- Update commit message and title in v7 4/5
- Add a cleanup patch for replacing BT_DBG with bt_dev_dbg

Changes in v7:
- Fix bt_dev_warn argument type warning

Changes in v6:
- Set parameter EnableAdvMonInterleaveScan to 1 byte long

Changes in v5:
- Rename 'adv_monitor' from many functions/variables
- Move __hci_update_interleaved_scan into hci_req_add_le_passive_scan
- Update the logic of update_adv_monitor_scan_state

Changes in v4:
- Rebase to bluetooth-next/master (previous 2 patches are applied)
- Fix over 80 chars limit in mgmt_config.c
- Set EnableAdvMonInterleaveScan default to Disable

Changes in v3:
- Remove 'Bluez' prefix

Changes in v2:
- remove 'case 0x001c' in mgmt_config.c

 include/net/bluetooth/hci_core.h |  10 +++
 net/bluetooth/hci_core.c         |   3 +
 net/bluetooth/hci_request.c      | 128 +++++++++++++++++++++++++++++--
 net/bluetooth/mgmt_config.c      |  10 +++
 4 files changed, 144 insertions(+), 7 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9873e1c8cd163..cfede18709d8f 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -361,6 +361,8 @@ struct hci_dev {
 	__u8		ssp_debug_mode;
 	__u8		hw_error_code;
 	__u32		clock;
+	__u16		advmon_allowlist_duration;
+	__u16		advmon_no_filter_duration;
 
 	__u16		devid_source;
 	__u16		devid_vendor;
@@ -542,6 +544,14 @@ struct hci_dev {
 	struct delayed_work	rpa_expired;
 	bdaddr_t		rpa;
 
+	enum {
+		INTERLEAVE_SCAN_NONE,
+		INTERLEAVE_SCAN_NO_FILTER,
+		INTERLEAVE_SCAN_ALLOWLIST
+	} interleave_scan_state;
+
+	struct delayed_work	interleave_scan;
+
 #if IS_ENABLED(CONFIG_BT_LEDS)
 	struct led_trigger	*power_led;
 #endif
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index c4aa2cbb92697..20506b31492d6 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3592,6 +3592,9 @@ struct hci_dev *hci_alloc_dev(void)
 	hdev->cur_adv_instance = 0x00;
 	hdev->adv_instance_timeout = 0;
 
+	hdev->advmon_allowlist_duration = 300;
+	hdev->advmon_no_filter_duration = 500;
+
 	hdev->sniff_max_interval = 800;
 	hdev->sniff_min_interval = 80;
 
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index fb87882fb71a1..d6bf1517ddaec 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -378,6 +378,53 @@ void __hci_req_write_fast_connectable(struct hci_request *req, bool enable)
 		hci_req_add(req, HCI_OP_WRITE_PAGE_SCAN_TYPE, 1, &type);
 }
 
+static void start_interleave_scan(struct hci_dev *hdev)
+{
+	hdev->interleave_scan_state = INTERLEAVE_SCAN_NO_FILTER;
+	queue_delayed_work(hdev->req_workqueue,
+			   &hdev->interleave_scan, 0);
+}
+
+static bool is_interleave_scanning(struct hci_dev *hdev)
+{
+	return hdev->interleave_scan_state != INTERLEAVE_SCAN_NONE;
+}
+
+static void cancel_interleave_scan(struct hci_dev *hdev)
+{
+	bt_dev_dbg(hdev, "cancelling interleave scan");
+
+	cancel_delayed_work_sync(&hdev->interleave_scan);
+
+	hdev->interleave_scan_state = INTERLEAVE_SCAN_NONE;
+}
+
+/* Return true if interleave_scan wasn't started until exiting this function,
+ * otherwise, return false
+ */
+static bool __hci_update_interleaved_scan(struct hci_dev *hdev)
+{
+	/* If there is at least one ADV monitors and one pending LE connection
+	 * or one device to be scanned for, we should alternate between
+	 * allowlist scan and one without any filters to save power.
+	 */
+	bool use_interleaving = hci_is_adv_monitoring(hdev) &&
+				!(list_empty(&hdev->pend_le_conns) &&
+				  list_empty(&hdev->pend_le_reports));
+	bool is_interleaving = is_interleave_scanning(hdev);
+
+	if (use_interleaving && !is_interleaving) {
+		start_interleave_scan(hdev);
+		bt_dev_dbg(hdev, "starting interleave scan");
+		return true;
+	}
+
+	if (!use_interleaving && is_interleaving)
+		cancel_interleave_scan(hdev);
+
+	return false;
+}
+
 /* This function controls the background scanning based on hdev->pend_le_conns
  * list. If there are pending LE connection we start the background scanning,
  * otherwise we stop it.
@@ -450,8 +497,7 @@ static void __hci_update_background_scan(struct hci_request *req)
 			hci_req_add_le_scan_disable(req, false);
 
 		hci_req_add_le_passive_scan(req);
-
-		BT_DBG("%s starting background scanning", hdev->name);
+		bt_dev_dbg(hdev, "starting background scanning");
 	}
 }
 
@@ -848,12 +894,17 @@ static u8 update_white_list(struct hci_request *req)
 			return 0x00;
 	}
 
-	/* Once the controller offloading of advertisement monitor is in place,
-	 * the if condition should include the support of MSFT extension
-	 * support. If suspend is ongoing, whitelist should be the default to
-	 * prevent waking by random advertisements.
+	/* Use the allowlist unless the following conditions are all true:
+	 * - We are not currently suspending
+	 * - There are 1 or more ADV monitors registered
+	 * - Interleaved scanning is not currently using the allowlist
+	 *
+	 * Once the controller offloading of advertisement monitor is in place,
+	 * the above condition should include the support of MSFT extension
+	 * support.
 	 */
-	if (!idr_is_empty(&hdev->adv_monitors_idr) && !hdev->suspended)
+	if (!idr_is_empty(&hdev->adv_monitors_idr) && !hdev->suspended &&
+	    hdev->interleave_scan_state != INTERLEAVE_SCAN_ALLOWLIST)
 		return 0x00;
 
 	/* Select filter policy to use white list */
@@ -1006,6 +1057,10 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 				      &own_addr_type))
 		return;
 
+	if (__hci_update_interleaved_scan(hdev))
+		return;
+
+	bt_dev_dbg(hdev, "interleave state %d", hdev->interleave_scan_state);
 	/* Adding or removing entries from the white list must
 	 * happen before enabling scanning. The controller does
 	 * not allow white list modification while scanning.
@@ -1870,6 +1925,62 @@ static void adv_timeout_expire(struct work_struct *work)
 	hci_dev_unlock(hdev);
 }
 
+static int hci_req_add_le_interleaved_scan(struct hci_request *req,
+					   unsigned long opt)
+{
+	struct hci_dev *hdev = req->hdev;
+	int ret = 0;
+
+	hci_dev_lock(hdev);
+
+	if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
+		hci_req_add_le_scan_disable(req, false);
+	hci_req_add_le_passive_scan(req);
+
+	switch (hdev->interleave_scan_state) {
+	case INTERLEAVE_SCAN_ALLOWLIST:
+		bt_dev_dbg(hdev, "next state: allowlist");
+		hdev->interleave_scan_state = INTERLEAVE_SCAN_NO_FILTER;
+		break;
+	case INTERLEAVE_SCAN_NO_FILTER:
+		bt_dev_dbg(hdev, "next state: no filter");
+		hdev->interleave_scan_state = INTERLEAVE_SCAN_ALLOWLIST;
+		break;
+	case INTERLEAVE_SCAN_NONE:
+		BT_ERR("unexpected error");
+		ret = -1;
+	}
+
+	hci_dev_unlock(hdev);
+
+	return ret;
+}
+
+static void interleave_scan_work(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev,
+					    interleave_scan.work);
+	u8 status;
+	unsigned long timeout;
+
+	if (hdev->interleave_scan_state == INTERLEAVE_SCAN_ALLOWLIST) {
+		timeout = msecs_to_jiffies(hdev->advmon_allowlist_duration);
+	} else if (hdev->interleave_scan_state == INTERLEAVE_SCAN_NO_FILTER) {
+		timeout = msecs_to_jiffies(hdev->advmon_no_filter_duration);
+	} else {
+		bt_dev_err(hdev, "unexpected error");
+		return;
+	}
+
+	hci_req_sync(hdev, hci_req_add_le_interleaved_scan, 0,
+		     HCI_CMD_TIMEOUT, &status);
+
+	/* Don't continue interleaving if it was canceled */
+	if (is_interleave_scanning(hdev))
+		queue_delayed_work(hdev->req_workqueue,
+				   &hdev->interleave_scan, timeout);
+}
+
 int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 			   bool use_rpa, struct adv_info *adv_instance,
 			   u8 *own_addr_type, bdaddr_t *rand_addr)
@@ -3297,6 +3408,7 @@ void hci_request_setup(struct hci_dev *hdev)
 	INIT_DELAYED_WORK(&hdev->le_scan_disable, le_scan_disable_work);
 	INIT_DELAYED_WORK(&hdev->le_scan_restart, le_scan_restart_work);
 	INIT_DELAYED_WORK(&hdev->adv_instance_expire, adv_timeout_expire);
+	INIT_DELAYED_WORK(&hdev->interleave_scan, interleave_scan_work);
 }
 
 void hci_request_cancel_all(struct hci_dev *hdev)
@@ -3316,4 +3428,6 @@ void hci_request_cancel_all(struct hci_dev *hdev)
 		cancel_delayed_work_sync(&hdev->adv_instance_expire);
 		hdev->adv_instance_timeout = 0;
 	}
+
+	cancel_interleave_scan(hdev);
 }
diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index b30b571f8caf8..2d3ad288c78ac 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -67,6 +67,8 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		HDEV_PARAM_U16(0x001a, le_supv_timeout),
 		HDEV_PARAM_U16_JIFFIES_TO_MSECS(0x001b,
 						def_le_autoconnect_timeout),
+		HDEV_PARAM_U16(0x001d, advmon_allowlist_duration),
+		HDEV_PARAM_U16(0x001e, advmon_no_filter_duration),
 	};
 	struct mgmt_rp_read_def_system_config *rp = (void *)params;
 
@@ -138,6 +140,8 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x0019:
 		case 0x001a:
 		case 0x001b:
+		case 0x001d:
+		case 0x001e:
 			if (len != sizeof(u16)) {
 				bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
 					    len, sizeof(u16), type);
@@ -251,6 +255,12 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 			hdev->def_le_autoconnect_timeout =
 					msecs_to_jiffies(TLV_GET_LE16(buffer));
 			break;
+		case 0x0001d:
+			hdev->advmon_allowlist_duration = TLV_GET_LE16(buffer);
+			break;
+		case 0x0001e:
+			hdev->advmon_no_filter_duration = TLV_GET_LE16(buffer);
+			break;
 		default:
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
-- 
2.29.2.454.gaff20da3a2-goog

