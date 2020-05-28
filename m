Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E561E70EA
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437914AbgE1Xzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437893AbgE1Xz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:55:27 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F14C08C5D1
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:26 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 131so236580pfv.13
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fK8XOMSjikpew8+0tN6yowyaNgl0sUklFFZF40oyRfQ=;
        b=iO+4MO5A+6DKEqeaFZ5cJyKAVltmQIEsKgbNqoJDg1fmePF1LRuhvfNiX3MGZsSXr9
         /UZXt2IPPGlA0f7WLAqoCP4Vyxy+JweqxssRJuR6qmJozSUJ3oqQ/nBFzYM+YP3M1n+1
         czKgDJFH8+t1Gj+n/+3kMdar81/9htOHuJjFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fK8XOMSjikpew8+0tN6yowyaNgl0sUklFFZF40oyRfQ=;
        b=NJbCLMwdeK/4CLz7YMQUOoLkwO+RBMHwyKoxxueCll1JcNn+pPdaeqq/2pFO5CGMR5
         IGCD3sDIZ+AuAPI0vws4GQBesiIYyN+x3FI/vIZTeA8Dou0X+VQxjgQ55EBO9KgRNjnY
         XnPuvbxZJFWDcjmQJFs9c2KDuqUSVu3Is8UTmf71tzXgxrn3LM5LhXgJf8WEQaZImQx6
         w7/toBHZMiPsRRe7qlT8hPFgrr6muCf+Qn2rqU/zIW8PZeyABW5/PmHOCCox+aJIO8dX
         LtkJHmJOsXFGzQK2PBwyOfiCsfv86VJFuS/VO6txs1oLI3serf84038howzA7HPuozKj
         fAaw==
X-Gm-Message-State: AOAM533fG0g74LGiE5BbhvI+fmWKrlvEdEvmD78slcSyTkNfv4Pm53Xn
        7BHxQJ7VSSOltJFgpAMlcwjXTA==
X-Google-Smtp-Source: ABdhPJzvlcBtsAwXeEO8INzN8oHwDILbeRknd8BR03DqDV3xqqRGHh3ej0fu3Dul9EmI5l0x9Ta0/Q==
X-Received: by 2002:a62:8845:: with SMTP id l66mr5801379pfd.324.1590710126087;
        Thu, 28 May 2020 16:55:26 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id f18sm5022591pga.75.2020.05.28.16.55.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 16:55:25 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Yoni Shavit <yshavit@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 7/7] Bluetooth: Update background scan and report device based on advertisement monitors
Date:   Thu, 28 May 2020 16:54:55 -0700
Message-Id: <20200528165324.v1.7.Id9ca021d5a3e8c748ea5c0a1c81582b9a8183f45@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528165324.v1.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200528165324.v1.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This calls hci_update_background_scan() when there is any update on the
advertisement monitors. If there is at least one advertisement monitor,
the filtering policy of scan parameters should be 0x00. This also reports
device found mgmt events if there is at least one monitor.

The following cases were tested with btmgmt advmon-* commands.
(1) add a ADV monitor and observe that the passive scanning is
triggered.
(2) remove the last ADV monitor and observe that the passive scanning is
terminated.
(3) with a LE peripheral paired, repeat (1) and observe the passive
scanning continues.
(4) with a LE peripheral paired, repeat (2) and observe the passive
scanning continues.
(5) with a ADV monitor, suspend/resume the host and observe the passive
scanning continues.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         | 13 +++++++++++++
 net/bluetooth/hci_event.c        |  5 +++--
 net/bluetooth/hci_request.c      | 17 ++++++++++++++---
 net/bluetooth/mgmt.c             |  5 ++++-
 5 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 78ac7fd282d77..1ce89e546a64e 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1243,6 +1243,7 @@ void hci_adv_monitors_clear(struct hci_dev *hdev);
 void hci_free_adv_monitor(struct adv_monitor *monitor);
 int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
 int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle);
+bool hci_is_adv_monitoring(struct hci_dev *hdev);
 
 void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 1fcd0cc2dcc5b..08c8ce26146d3 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3005,6 +3005,8 @@ void hci_adv_monitors_clear(struct hci_dev *hdev)
 		hci_free_adv_monitor(monitor);
 
 	idr_destroy(&hdev->adv_monitors_idr);
+
+	hci_update_background_scan(hdev);
 }
 
 void hci_free_adv_monitor(struct adv_monitor *monitor)
@@ -3038,6 +3040,9 @@ int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 
 	hdev->adv_monitors_cnt++;
 	monitor->handle = handle;
+
+	hci_update_background_scan(hdev);
+
 	return 0;
 }
 
@@ -3069,9 +3074,17 @@ int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle)
 		idr_for_each(&hdev->adv_monitors_idr, &free_adv_monitor, hdev);
 	}
 
+	hci_update_background_scan(hdev);
+
 	return 0;
 }
 
+/* This function requires the caller holds hdev->lock */
+bool hci_is_adv_monitoring(struct hci_dev *hdev)
+{
+	return !idr_is_empty(&hdev->adv_monitors_idr);
+}
+
 struct bdaddr_list *hci_bdaddr_list_lookup(struct list_head *bdaddr_list,
 					 bdaddr_t *bdaddr, u8 type)
 {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cfeaee347db32..cbcc0b590fd41 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5447,14 +5447,15 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 
 	/* Passive scanning shouldn't trigger any device found events,
 	 * except for devices marked as CONN_REPORT for which we do send
-	 * device found events.
+	 * device found events, or advertisement monitoring requested.
 	 */
 	if (hdev->le_scan_type == LE_SCAN_PASSIVE) {
 		if (type == LE_ADV_DIRECT_IND)
 			return;
 
 		if (!hci_pend_le_action_lookup(&hdev->pend_le_reports,
-					       bdaddr, bdaddr_type))
+					       bdaddr, bdaddr_type) &&
+		    idr_is_empty(&hdev->adv_monitors_idr))
 			return;
 
 		if (type == LE_ADV_NONCONN_IND || type == LE_ADV_SCAN_IND)
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 1fc55685da62d..b743e3fc063d8 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -418,11 +418,15 @@ static void __hci_update_background_scan(struct hci_request *req)
 	 */
 	hci_discovery_filter_clear(hdev);
 
+	BT_DBG("%s ADV monitoring is %s", hdev->name,
+	       hci_is_adv_monitoring(hdev) ? "on" : "off");
+
 	if (list_empty(&hdev->pend_le_conns) &&
-	    list_empty(&hdev->pend_le_reports)) {
+	    list_empty(&hdev->pend_le_reports) &&
+	    !hci_is_adv_monitoring(hdev)) {
 		/* If there is no pending LE connections or devices
-		 * to be scanned for, we should stop the background
-		 * scanning.
+		 * to be scanned for or no ADV monitors, we should stop the
+		 * background scanning.
 		 */
 
 		/* If controller is not scanning we are done. */
@@ -798,6 +802,13 @@ static u8 update_white_list(struct hci_request *req)
 			return 0x00;
 	}
 
+	/* Once the controller offloading of advertisement monitor is in place,
+	 * the if condition should include the support of MSFT extension
+	 * support.
+	 */
+	if (!idr_is_empty(&hdev->adv_monitors_idr))
+		return 0x00;
+
 	/* Select filter policy to use white list */
 	return 0x01;
 }
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 728d79663cbcf..d070373345c5d 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8427,8 +8427,11 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	if (!hci_discovery_active(hdev)) {
 		if (link_type == ACL_LINK)
 			return;
-		if (link_type == LE_LINK && list_empty(&hdev->pend_le_reports))
+		if (link_type == LE_LINK &&
+		    list_empty(&hdev->pend_le_reports) &&
+		    !hci_is_adv_monitoring(hdev)) {
 			return;
+		}
 	}
 
 	if (hdev->discovery.result_filtering) {
-- 
2.26.2

