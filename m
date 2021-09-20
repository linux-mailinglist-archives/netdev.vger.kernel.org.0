Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58A7412ACE
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbhIUB6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbhIUBxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:53:01 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583F8C03548D
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 16:32:11 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id e22-20020a05620a209600b003d5ff97bff7so157349306qka.1
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 16:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=yc+WG8DgzzzslEhkCObV2LCCncvDL30fgx6qJuCU3ZE=;
        b=GG4O89gcDx/mBspN+VOJv+Eu1wp4rroxjXnYBHyd4uMlqdW9SQLGCNmRNInYOG+kdd
         DAQq3+kSSCqiKhlolvRVHRexonCd0Gm/uS+XD2uqfTjmgB+QlPPXoGhuLq22FwIlVssT
         98a8MGmA0kNlUCma0lTe+Un6IWOtpGCe5Wg22LXunzcaw/vYynD11MaLleLEQmH0g/ud
         pKGeP3UbWfSJ2WjAYliSg2vdtDaNTT9Ca4wmKnjQdvr36bhVAfp/2IG1XvNDoMQQl0Kx
         7PALbeW0i3yJJHZFwudOaaeaf7UCeQ2V15omKpunx53hXi2jVtkC4/g+B5tJbbcNrjzQ
         elVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=yc+WG8DgzzzslEhkCObV2LCCncvDL30fgx6qJuCU3ZE=;
        b=SPylQdJfDSjw94vIBkTE4iFS6ggg3sj3Rg8s53+5++lgR4kbJhLjuyJ8e/28IFoJNy
         mL99SuDA8f/+c7uBjNRgNX7+VxjVfH0Tu+2oVNFlh9YuQosnt9GBg4oKtj9RTNJQ2XBl
         7EuSgccByGXnQ7GvVKlFPhV21mC8lL7vB4wUkf+C3wh9wUwKWFl9cXbMY39X1lm/vAf0
         2iuh6751TwsrG451Qvgyyz9TdXMCG3lubwaWnOMaDqaTjxBzxgWxYBk0jyVnPVml+JVg
         mIc7png3dTsRrIYTE7Afg40GULRdzWalfzYjGhQIp0rucFBKp54yydsh3a12NgQH2hVn
         TSLA==
X-Gm-Message-State: AOAM531kUakFfwn9nYEkm48mzWq27MPE6q6ZTM+XO2kqJsqslZTwBSWY
        U/hd8OaYnPKS4UQFciskPLefUhbAIZKyKQ==
X-Google-Smtp-Source: ABdhPJznQG0nFp879fW9PJ6nsCrsDGu7OtAnOJzXpeMFZvwRH5aE+81myQb6CHhxm2mPfAK65fz+fD9Yj6h5ow==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:c2de:a92c:e275:5bdf])
 (user=mmandlik job=sendgmr) by 2002:a25:ad97:: with SMTP id
 z23mr34148446ybi.412.1632180730386; Mon, 20 Sep 2021 16:32:10 -0700 (PDT)
Date:   Mon, 20 Sep 2021 16:32:03 -0700
Message-Id: <20210920162929.v1.1.Ib31940aba2253e3f25cbca09a2d977d27170e163@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v1] bluetooth: Fix Advertisement Monitor Suspend/Resume
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Manish Mandlik <mmandlik@google.com>, apusaka@google.com,
        mcchou@google.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During system suspend, advertisement monitoring is disabled by setting
the=C2=A0HCI_VS_MSFT_LE_Set_Advertisement_Filter_Enable to False. This
disables the monitoring during suspend, however, if the controller is
monitoring a device, it sends HCI_VS_MSFT_LE_Monitor_Device_Event to
indicate that the monitoring has been stopped for that particular
device. This event may occur after suspend depending on the
low_threshold_timeout and peer device advertisement frequency, which
causes early wake up.

Right way to disable the monitoring for suspend is by removing all the
monitors before suspend and re-monitor after resume to ensure no events
are received=C2=A0during suspend. This patch fixes this suspend/resume issu=
e.

Following tests are performed:
- Add monitors before suspend and make sure DeviceFound gets triggered
- Suspend the system and verify that all monitors are removed by kernel
  but not Released by bluetoothd
- Wake up and verify that all monitors are added again and DeviceFound
  gets triggered

Reviewed-by: apusaka@google.com
Reviewed-by: mcchou@google.com
Signed-off-by: Manish Mandlik <mmandlik@google.com>
---

 net/bluetooth/hci_request.c |  15 +++--
 net/bluetooth/msft.c        | 117 +++++++++++++++++++++++++++++++-----
 net/bluetooth/msft.h        |   5 ++
 3 files changed, 116 insertions(+), 21 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 47fb665277d4..c018a172ced3 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1281,21 +1281,24 @@ static void suspend_req_complete(struct hci_dev *hd=
ev, u8 status, u16 opcode)
 	}
 }
=20
-static void hci_req_add_set_adv_filter_enable(struct hci_request *req,
-					      bool enable)
+static void hci_req_prepare_adv_monitor_suspend(struct hci_request *req,
+						bool suspending)
 {
 	struct hci_dev *hdev =3D req->hdev;
=20
 	switch (hci_get_adv_monitor_offload_ext(hdev)) {
 	case HCI_ADV_MONITOR_EXT_MSFT:
-		msft_req_add_set_filter_enable(req, enable);
+		if (suspending)
+			msft_remove_all_monitors_on_suspend(hdev);
+		else
+			msft_reregister_monitors_on_resume(hdev);
 		break;
 	default:
 		return;
 	}
=20
 	/* No need to block when enabling since it's on resume path */
-	if (hdev->suspended && !enable)
+	if (hdev->suspended && suspending)
 		set_bit(SUSPEND_SET_ADV_FILTER, hdev->suspend_tasks);
 }
=20
@@ -1362,7 +1365,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, en=
um suspended_state next)
 		}
=20
 		/* Disable advertisement filters */
-		hci_req_add_set_adv_filter_enable(&req, false);
+		hci_req_prepare_adv_monitor_suspend(&req, true);
=20
 		/* Prevent disconnects from causing scanning to be re-enabled */
 		hdev->scanning_paused =3D true;
@@ -1404,7 +1407,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, en=
um suspended_state next)
 		/* Reset passive/background scanning to normal */
 		__hci_update_background_scan(&req);
 		/* Enable all of the advertisement filters */
-		hci_req_add_set_adv_filter_enable(&req, true);
+		hci_req_prepare_adv_monitor_suspend(&req, false);
=20
 		/* Unpause directed advertising */
 		hdev->advertising_paused =3D false;
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 21b1787e7893..328d5e341f9a 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -94,11 +94,14 @@ struct msft_data {
 	__u16 pending_add_handle;
 	__u16 pending_remove_handle;
 	__u8 reregistering;
+	__u8 suspending;
 	__u8 filter_enabled;
 };
=20
 static int __msft_add_monitor_pattern(struct hci_dev *hdev,
 				      struct adv_monitor *monitor);
+static int __msft_remove_monitor(struct hci_dev *hdev,
+				 struct adv_monitor *monitor, u16 handle);
=20
 bool msft_monitor_supported(struct hci_dev *hdev)
 {
@@ -154,7 +157,7 @@ static bool read_supported_features(struct hci_dev *hde=
v,
 }
=20
 /* This function requires the caller holds hdev->lock */
-static void reregister_monitor_on_restart(struct hci_dev *hdev, int handle=
)
+static void reregister_monitor(struct hci_dev *hdev, int handle)
 {
 	struct adv_monitor *monitor;
 	struct msft_data *msft =3D hdev->msft_data;
@@ -182,6 +185,69 @@ static void reregister_monitor_on_restart(struct hci_d=
ev *hdev, int handle)
 	}
 }
=20
+/* This function requires the caller holds hdev->lock */
+static void remove_monitor_on_suspend(struct hci_dev *hdev, int handle)
+{
+	struct adv_monitor *monitor;
+	struct msft_data *msft =3D hdev->msft_data;
+	int err;
+
+	while (1) {
+		monitor =3D idr_get_next(&hdev->adv_monitors_idr, &handle);
+		if (!monitor) {
+			/* All monitors have been removed */
+			msft->suspending =3D false;
+			hci_update_background_scan(hdev);
+			return;
+		}
+
+		msft->pending_remove_handle =3D (u16)handle;
+		err =3D __msft_remove_monitor(hdev, monitor, handle);
+
+		/* If success, return and wait for monitor removed callback */
+		if (!err)
+			return;
+
+		/* Otherwise free the monitor and keep removing */
+		hci_free_adv_monitor(hdev, monitor);
+		handle++;
+	}
+}
+
+/* This function requires the caller holds hdev->lock */
+void msft_remove_all_monitors_on_suspend(struct hci_dev *hdev)
+{
+	struct msft_data *msft =3D hdev->msft_data;
+
+	if (!msft)
+		return;
+
+	if (msft_monitor_supported(hdev)) {
+		msft->suspending =3D true;
+		/* Quitely remove all monitors on suspend to avoid waking up
+		 * the system.
+		 */
+		remove_monitor_on_suspend(hdev, 0);
+	}
+}
+
+/* This function requires the caller holds hdev->lock */
+void msft_reregister_monitors_on_resume(struct hci_dev *hdev)
+{
+	struct msft_data *msft =3D hdev->msft_data;
+
+	if (!msft)
+		return;
+
+	if (msft_monitor_supported(hdev)) {
+		msft->reregistering =3D true;
+		/* Monitors are removed on suspend, so we need to add all
+		 * monitors on resume.
+		 */
+		reregister_monitor(hdev, 0);
+	}
+}
+
 void msft_do_open(struct hci_dev *hdev)
 {
 	struct msft_data *msft =3D hdev->msft_data;
@@ -214,7 +280,7 @@ void msft_do_open(struct hci_dev *hdev)
 		/* Monitors get removed on power off, so we need to explicitly
 		 * tell the controller to re-monitor.
 		 */
-		reregister_monitor_on_restart(hdev, 0);
+		reregister_monitor(hdev, 0);
 	}
 }
=20
@@ -382,8 +448,7 @@ static void msft_le_monitor_advertisement_cb(struct hci=
_dev *hdev,
=20
 	/* If in restart/reregister sequence, keep registering. */
 	if (msft->reregistering)
-		reregister_monitor_on_restart(hdev,
-					      msft->pending_add_handle + 1);
+		reregister_monitor(hdev, msft->pending_add_handle + 1);
=20
 	hci_dev_unlock(hdev);
=20
@@ -420,13 +485,25 @@ static void msft_le_cancel_monitor_advertisement_cb(s=
truct hci_dev *hdev,
 	if (handle_data) {
 		monitor =3D idr_find(&hdev->adv_monitors_idr,
 				   handle_data->mgmt_handle);
-		if (monitor)
+
+		if (monitor && monitor->state =3D=3D ADV_MONITOR_STATE_OFFLOADED)
+			monitor->state =3D ADV_MONITOR_STATE_REGISTERED;
+
+		/* Do not free the monitor if it is being removed due to
+		 * suspend. It will be re-monitored on resume.
+		 */
+		if (monitor && !msft->suspending)
 			hci_free_adv_monitor(hdev, monitor);
=20
 		list_del(&handle_data->list);
 		kfree(handle_data);
 	}
=20
+	/* If in suspend/remove sequence, keep removing. */
+	if (msft->suspending)
+		remove_monitor_on_suspend(hdev,
+					  msft->pending_remove_handle + 1);
+
 	/* If remove all monitors is required, we need to continue the process
 	 * here because the earlier it was paused when waiting for the
 	 * response from controller.
@@ -445,7 +522,8 @@ static void msft_le_cancel_monitor_advertisement_cb(str=
uct hci_dev *hdev,
 	hci_dev_unlock(hdev);
=20
 done:
-	hci_remove_adv_monitor_complete(hdev, status);
+	if (!msft->suspending)
+		hci_remove_adv_monitor_complete(hdev, status);
 }
=20
 static void msft_le_set_advertisement_filter_enable_cb(struct hci_dev *hde=
v,
@@ -578,15 +656,15 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, st=
ruct adv_monitor *monitor)
 	if (!msft)
 		return -EOPNOTSUPP;
=20
-	if (msft->reregistering)
+	if (msft->reregistering || msft->suspending)
 		return -EBUSY;
=20
 	return __msft_add_monitor_pattern(hdev, monitor);
 }
=20
 /* This function requires the caller holds hdev->lock */
-int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
-			u16 handle)
+static int __msft_remove_monitor(struct hci_dev *hdev,
+				 struct adv_monitor *monitor, u16 handle)
 {
 	struct msft_cp_le_cancel_monitor_advertisement cp;
 	struct msft_monitor_advertisement_handle_data *handle_data;
@@ -594,12 +672,6 @@ int msft_remove_monitor(struct hci_dev *hdev, struct a=
dv_monitor *monitor,
 	struct msft_data *msft =3D hdev->msft_data;
 	int err =3D 0;
=20
-	if (!msft)
-		return -EOPNOTSUPP;
-
-	if (msft->reregistering)
-		return -EBUSY;
-
 	handle_data =3D msft_find_handle_data(hdev, monitor->handle, true);
=20
 	/* If no matched handle, just remove without telling controller */
@@ -619,6 +691,21 @@ int msft_remove_monitor(struct hci_dev *hdev, struct a=
dv_monitor *monitor,
 	return err;
 }
=20
+/* This function requires the caller holds hdev->lock */
+int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
+			u16 handle)
+{
+	struct msft_data *msft =3D hdev->msft_data;
+
+	if (!msft)
+		return -EOPNOTSUPP;
+
+	if (msft->reregistering || msft->suspending)
+		return -EBUSY;
+
+	return __msft_remove_monitor(hdev, monitor, handle);
+}
+
 void msft_req_add_set_filter_enable(struct hci_request *req, bool enable)
 {
 	struct hci_dev *hdev =3D req->hdev;
diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
index 8018948c5975..6ec843b94d16 100644
--- a/net/bluetooth/msft.h
+++ b/net/bluetooth/msft.h
@@ -24,6 +24,8 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_=
monitor *monitor,
 			u16 handle);
 void msft_req_add_set_filter_enable(struct hci_request *req, bool enable);
 int msft_set_filter_enable(struct hci_dev *hdev, bool enable);
+void msft_remove_all_monitors_on_suspend(struct hci_dev *hdev);
+void msft_reregister_monitors_on_resume(struct hci_dev *hdev);
 bool msft_curve_validity(struct hci_dev *hdev);
=20
 #else
@@ -59,6 +61,9 @@ static inline int msft_set_filter_enable(struct hci_dev *=
hdev, bool enable)
 	return -EOPNOTSUPP;
 }
=20
+void msft_remove_all_monitors_on_suspend(struct hci_dev *hdev) {}
+void msft_reregister_monitors_on_resume(struct hci_dev *hdev) {}
+
 static inline bool msft_curve_validity(struct hci_dev *hdev)
 {
 	return false;
--=20
2.33.0.464.g1972c5931b-goog

