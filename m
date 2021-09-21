Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9F3413CE5
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 23:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhIUVtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 17:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbhIUVtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 17:49:10 -0400
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A818C061575
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 14:47:41 -0700 (PDT)
Received: by mail-oi1-x24a.google.com with SMTP id o185-20020acad7c2000000b0026b63b5c3f4so434110oig.18
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 14:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=HmPUo7NP84irG+fpbG/9RGxaqmMyeDRhG4gEokC1TiU=;
        b=PWm6HO7VNfgOGGz8s2UmG7/ruYnSj98+qJ6XhjtSE02dBcbgXmoAvLE07O+zKH5Yqh
         QFin2LgemJShzHUlpJd835AdDJhsleAWY93PexfgRlpbJ6ycDZQHiicZaok9PjH9ii4F
         ez2OmbzVM4pW4ZN8dXIC9p8BevvD47dfXmF6vqJZGuRiLyFtLIxoW2k8XXdVay7QmCoa
         8Z7K5wo9qmUdR3qlHiJuI3M61oWRRE1P/fvs4KXASXPVwgCU/cHRkRsWGRx2eNVGJU7+
         Zgz9yni/oZHNkqwNMC8lw1A+Yz4KZ5Vs2yFT0xdf1dmuuATezv8BpzP5uP8UDiphrk5J
         Rf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=HmPUo7NP84irG+fpbG/9RGxaqmMyeDRhG4gEokC1TiU=;
        b=wtCgwj3mIgylmAoDURXSxE4B3CZaHPsvPMXjy8NUs4t4imAFrBF6qB61lixoRuYFMo
         irbzqZ3sP55COQUxtBFQ4bDrUxPHhs0kkferrQI1sUkxGqZL+7wPfJF77/zwCXQqVFIl
         efYmBCvgjPG0Ll1u1HMkoJXjFX8aTuOp0lBd0TgNEzASHp0h7J2cp35sx7fvKYoNKakp
         qKfDsNhd33eX8nUCY+l/t/3fHpbD6bID+Ec5wGP6BHPv4MWtPjfVddqSVN6MBK0K8CDp
         nnqUxBVL80bk2MbcBGlIfllQDtJM9uO4UdjqY4BqM0XlSQqr23Q3tFKOvJWWU9ScnV3h
         nfjw==
X-Gm-Message-State: AOAM5310+OhkJypSomew31jV3fD2Dpm+D+bYVPXTgJ4KdLZI9brl2b/4
        1AlnxzSUmyZwSJB9zG4tiRG0hKI4BFcWJA==
X-Google-Smtp-Source: ABdhPJztfHXMNM3813FeExLvw4XPSZsY2Bse4pN4NA/CaCvAZgE7gwqOxMNfSajxKHhJcP0I+BAiRB+ZsaBsBA==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:98fb:b541:26ee:9c8a])
 (user=mmandlik job=sendgmr) by 2002:a25:1d86:: with SMTP id
 d128mr41342099ybd.406.1632260849068; Tue, 21 Sep 2021 14:47:29 -0700 (PDT)
Date:   Tue, 21 Sep 2021 14:47:10 -0700
Message-Id: <20210921144640.v3.1.Ib31940aba2253e3f25cbca09a2d977d27170e163@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3] bluetooth: Fix Advertisement Monitor Suspend/Resume
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Manish Mandlik <mmandlik@google.com>,
        Archie Pusaka <apusaka@google.com>,
        Miao-chen Chou <mcchou@google.com>,
        "David S. Miller" <davem@davemloft.net>,
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

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Archie Pusaka <apusaka@google.com>
Reviewed-by: Miao-chen Chou <mcchou@google.com>
---

Changes in v3:
- Updated the msft_{suspend/resume} function names

Changes in v2:
- Updated the Reviewd-by names

 net/bluetooth/hci_request.c |  15 +++--
 net/bluetooth/msft.c        | 117 +++++++++++++++++++++++++++++++-----
 net/bluetooth/msft.h        |   5 ++
 3 files changed, 116 insertions(+), 21 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 47fb665277d4..25eeca3ab495 100644
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
+			msft_suspend(hdev);
+		else
+			msft_resume(hdev);
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
index 21b1787e7893..255cffa554ee 100644
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
+void msft_suspend(struct hci_dev *hdev)
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
+void msft_resume(struct hci_dev *hdev)
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
index 8018948c5975..27d73f82b9de 100644
--- a/net/bluetooth/msft.h
+++ b/net/bluetooth/msft.h
@@ -24,6 +24,8 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_=
monitor *monitor,
 			u16 handle);
 void msft_req_add_set_filter_enable(struct hci_request *req, bool enable);
 int msft_set_filter_enable(struct hci_dev *hdev, bool enable);
+void msft_suspend(struct hci_dev *hdev);
+void msft_resume(struct hci_dev *hdev);
 bool msft_curve_validity(struct hci_dev *hdev);
=20
 #else
@@ -59,6 +61,9 @@ static inline int msft_set_filter_enable(struct hci_dev *=
hdev, bool enable)
 	return -EOPNOTSUPP;
 }
=20
+void msft_suspend(struct hci_dev *hdev) {}
+void msft_resume(struct hci_dev *hdev) {}
+
 static inline bool msft_curve_validity(struct hci_dev *hdev)
 {
 	return false;
--=20
2.33.0.464.g1972c5931b-goog

