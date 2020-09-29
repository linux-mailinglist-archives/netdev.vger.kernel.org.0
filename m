Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE8627CAE8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbgI2MWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729802AbgI2LfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:35:10 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73997C0613D1
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:25:50 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id u6so2691549qte.8
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=OtfMhw9NLSyjf/Lk8KkfpNWGNdnBLysym9TdugdWdQ8=;
        b=eU7sM5dRsnBbFM/zl904YtysET3yYUVqKUw3W2H/+O6NbM/gvFeEhjVOMaAxQuKe6w
         4xRtGLOZCk1cqtFeZmIv906sGqBsaduhf1FUpkeL7f4HbCu4afK7YixVKqMAQ32Fg3HZ
         wngI9yZrLFHDS1P0PpcgkCUreVcvwCC632G/CkfXlNXMLH0A2cDDJV4nUyLbUihVgk+2
         PWuX5ckbKAnHmDdrXRTC0dIjlUCWGwhMbdkYrf3Wc/dz3p73eVxkWPP5jDofJ97t+LaG
         B86sJ2r6EX3EI7FiCFPwEuKA1UlrdJA2cGdx+AOzQnyJ3ymhU3QsW6vSpckwqBLZ7dLc
         pekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=OtfMhw9NLSyjf/Lk8KkfpNWGNdnBLysym9TdugdWdQ8=;
        b=a0T+uJhmUorz3n3lm0s+eeOdMQROU9iMqLi7frNElQenheDfn1+aAqyYHMqjh0lyVm
         mNTPz4KFpYQ4KidU2dnHC4kEY0UF0rGT9oeYmjB4UmkL1XPGgvFPVHG7EzlAFb/gXa7S
         qvA46r8HOEaNOYLKHGs44YTFjfoIpg5y0ZkXY0Bg+m7K2Gb76Ao829/eHa6XTiVLkVoP
         Z1DC4LMy56Yh9qMaoTU5nHZT1TpsTWXEtw8uDh8oVYeRQszkxdjeNoXWbnobhK57NVNl
         ctXHOee4r+UmgGwnJQxjv7EQhrKHJSu6D25DRoqV1fxqZ+RtPVGtamvsaOJ/0HNgUp4P
         xYKw==
X-Gm-Message-State: AOAM533dQ+MEeW1+wvrHoPXy7fEWF4QqPzRDtOK2Z7Hx4+70hVer2s5Y
        0ER6jXv31rcuQJeyFUI6hQkm7G5IkbJjXCiNWw==
X-Google-Smtp-Source: ABdhPJz3ebtRd4nIo4evNCazemVs0HWMg3w3rYSKP/988CwXqf1RAY1hefTS2AH0ArTTyS/Qp4YYASA4FjVn/Fq9GQ==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:ad4:500c:: with SMTP id
 s12mr3868530qvo.7.1601378749282; Tue, 29 Sep 2020 04:25:49 -0700 (PDT)
Date:   Tue, 29 Sep 2020 19:25:23 +0800
Message-Id: <20200929192508.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v7 1/4] Bluetooth: Interleave with allowlist scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.org, alainm@chromium.org, mcchou@chromium.org,
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

Changes in v7:
- Fix test bot warning

Changes in v6:
- Change the type of enable_advmon_interleave_scan to u8

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
 net/bluetooth/hci_core.c         |   4 +
 net/bluetooth/hci_request.c      | 133 +++++++++++++++++++++++++++++--
 net/bluetooth/mgmt_config.c      |  10 +++
 4 files changed, 150 insertions(+), 7 deletions(-)

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
index f30a1f5950e15..6c8850149265a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3592,6 +3592,10 @@ struct hci_dev *hci_alloc_dev(void)
 	hdev->cur_adv_instance = 0x00;
 	hdev->adv_instance_timeout = 0;
 
+	/* The default values will be chosen in the future */
+	hdev->advmon_allowlist_duration = 300;
+	hdev->advmon_no_filter_duration = 500;
+
 	hdev->sniff_max_interval = 800;
 	hdev->sniff_min_interval = 80;
 
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index d2b06f5c93804..ba3016cc0b573 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -378,6 +378,56 @@ void __hci_req_write_fast_connectable(struct hci_request *req, bool enable)
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
+	bt_dev_dbg(hdev, "%s cancelling interleave scan", hdev->name);
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
+	if (hci_is_adv_monitoring(hdev) &&
+	    !(list_empty(&hdev->pend_le_conns) &&
+	      list_empty(&hdev->pend_le_reports))) {
+		if (!is_interleave_scanning(hdev)) {
+			/* If there is at least one ADV monitors and one pending
+			 * LE connection or one device to be scanned for, we
+			 * should alternate between allowlist scan and one
+			 * without any filters to save power.
+			 */
+			start_interleave_scan(hdev);
+			bt_dev_dbg(hdev, "%s starting interleave scan",
+				   hdev->name);
+			return true;
+		}
+	} else if (is_interleave_scanning(hdev)) {
+		/* If the interleave condition no longer holds, cancel
+		 * the existed interleave scan.
+		 */
+		cancel_interleave_scan(hdev);
+	}
+
+	return false;
+}
+
 /* This function controls the background scanning based on hdev->pend_le_conns
  * list. If there are pending LE connection we start the background scanning,
  * otherwise we stop it.
@@ -450,8 +500,8 @@ static void __hci_update_background_scan(struct hci_request *req)
 			hci_req_add_le_scan_disable(req, false);
 
 		hci_req_add_le_passive_scan(req);
-
-		BT_DBG("%s starting background scanning", hdev->name);
+		bt_dev_dbg(hdev, "%s starting background scanning",
+			   hdev->name);
 	}
 }
 
@@ -844,12 +894,17 @@ static u8 update_white_list(struct hci_request *req)
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
@@ -1002,6 +1057,9 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 				      &own_addr_type))
 		return;
 
+	if (__hci_update_interleaved_scan(hdev))
+		return;
+
 	/* Adding or removing entries from the white list must
 	 * happen before enabling scanning. The controller does
 	 * not allow white list modification while scanning.
@@ -1871,6 +1929,64 @@ static void adv_timeout_expire(struct work_struct *work)
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
+	default:
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
+	if (is_interleave_scanning(hdev)) {
+		queue_delayed_work(hdev->req_workqueue,
+				   &hdev->interleave_scan, timeout);
+	}
+}
+
 int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 			   bool use_rpa, struct adv_info *adv_instance,
 			   u8 *own_addr_type, bdaddr_t *rand_addr)
@@ -3292,6 +3408,7 @@ void hci_request_setup(struct hci_dev *hdev)
 	INIT_DELAYED_WORK(&hdev->le_scan_disable, le_scan_disable_work);
 	INIT_DELAYED_WORK(&hdev->le_scan_restart, le_scan_restart_work);
 	INIT_DELAYED_WORK(&hdev->adv_instance_expire, adv_timeout_expire);
+	INIT_DELAYED_WORK(&hdev->interleave_scan, interleave_scan_work);
 }
 
 void hci_request_cancel_all(struct hci_dev *hdev)
@@ -3311,4 +3428,6 @@ void hci_request_cancel_all(struct hci_dev *hdev)
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
2.28.0.709.gb0816b6eb0-goog

