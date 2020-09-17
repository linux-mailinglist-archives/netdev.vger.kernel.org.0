Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04B526D711
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgIQIs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgIQIrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:47:41 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC19C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:47:41 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id s141so1058989qka.13
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=kL2AQmKmQ8DRMKjtBMJBwyEAwBYPLpPCmkHC9nftMgY=;
        b=fgXrxwl5WGPHQG8YKqyWsKa+CPdKEMhNFS4ZyclxNkVJqc25wKfupVBKvCKG6haRzC
         0TBWGdEgUhbiblMCalHV7r39WltR8n+867Sh825ejjZPfMAUeAOVcCA8uWA91UdO1q09
         rBfY0YRvul6BhI5xFScawLndUs39LHNgfoS6sMd2OOQ0BBsL8fWi56CjRgKL7w74mZLT
         WdjeAueIV0Z9LX+87sesrytlq2Xa6FS3WpVUqbyiukolI7Y/2GE3ArMPaUux2JBaHiQ/
         SvjeabzpQfozVT//Xr828aSEJVLIVBv+6TtSP5G6PTem8xH83EcFNnwWhXE4XEBLPv6p
         rWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kL2AQmKmQ8DRMKjtBMJBwyEAwBYPLpPCmkHC9nftMgY=;
        b=WumRMuDNplk+F+hlyJVZ8haSOvgxuWGEmF0Un/GSo7LR+jAIVV7rU4miWv9Cgc2fmW
         yBCP/2+JgN0LB5YmnOgjKmWY41EivhVWpcxytj9H1qU9KMnnYL3kVsp4n75Mj+usudP8
         eUE+U0CN0Osr9D7wZkUw08msO2Z20sFWvWwkuVZfhQoXMQfUYCYDzyfBAoytUp7VWYqv
         weCjkNPuenBJDhimU96fu+LQEYqpq3QmVSL94aDOgPqonkjhxNXsqCwx47/d3cyiRdgm
         Cl+zFRqM+yAIRWKyS6fItEaEVblWgpd5xl/blqtdQol9EEqvdZi1/aLSRl/a/BqaKQau
         1o/Q==
X-Gm-Message-State: AOAM530W9ooX34KvcpNYbs8A7PG57p1L8lw2ZINyNBVFn1Ywop4FBdsu
        gm4PF1u63etOwWZqLPfj4KlqjO7rO1rRSK+F4w==
X-Google-Smtp-Source: ABdhPJyNGGCWI5ydqkiZgandDqVu55u47O7nGmUqX2w1Bd9eqbdqO7yMoMa6S7yTGTAh34aYZvpS9plvu9PUEnoVRw==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:ad4:5a0e:: with SMTP id
 ei14mr12731226qvb.15.1600332460122; Thu, 17 Sep 2020 01:47:40 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:47:15 +0800
In-Reply-To: <20200917164632.BlueZ.v2.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Message-Id: <20200917164632.BlueZ.v2.6.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20200917164632.BlueZ.v2.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [BlueZ PATCH v2 6/6] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com, mmandlik@chromium.org,
        mcchou@chromium.org, howardchung@google.com, alainm@chromium.org,
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

(no changes since v1)

 include/net/bluetooth/hci_core.h | 1 +
 net/bluetooth/hci_core.c         | 1 +
 net/bluetooth/hci_request.c      | 3 ++-
 net/bluetooth/mgmt_config.c      | 6 ++++++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 179350f869fdb..c3253f1cac0c2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -363,6 +363,7 @@ struct hci_dev {
 	__u32		clock;
 	__u16		advmon_allowlist_duration;
 	__u16		advmon_no_filter_duration;
+	__u16		enable_advmon_interleave_scan;
 
 	__u16		devid_source;
 	__u16		devid_vendor;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 6c8850149265a..4608715860cce 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3595,6 +3595,7 @@ struct hci_dev *hci_alloc_dev(void)
 	/* The default values will be chosen in the future */
 	hdev->advmon_allowlist_duration = 300;
 	hdev->advmon_no_filter_duration = 500;
+	hdev->enable_advmon_interleave_scan = 0x0001;	/* Default to enable */
 
 	hdev->sniff_max_interval = 800;
 	hdev->sniff_min_interval = 80;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 1fcf6736811e4..bb38e1dead68f 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -500,7 +500,8 @@ static void __hci_update_background_scan(struct hci_request *req)
 		if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
 			hci_req_add_le_scan_disable(req, false);
 
-		if (!update_adv_monitor_scan_state(hdev)) {
+		if (!hdev->enable_advmon_interleave_scan ||
+		    !update_adv_monitor_scan_state(hdev)) {
 			hci_req_add_le_passive_scan(req);
 			bt_dev_dbg(hdev, "%s starting background scanning",
 				   hdev->name);
diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index 1802f7023158c..b4198c33a1b72 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -69,6 +69,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 						def_le_autoconnect_timeout),
 		HDEV_PARAM_U16(0x001d, advmon_allowlist_duration),
 		HDEV_PARAM_U16(0x001e, advmon_no_filter_duration),
+		HDEV_PARAM_U16(0x001f, enable_advmon_interleave_scan),
 	};
 	struct mgmt_rp_read_def_system_config *rp = (void *)params;
 
@@ -142,6 +143,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x001b:
 		case 0x001d:
 		case 0x001e:
+		case 0x001f:
 			if (len != sizeof(u16)) {
 				bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
 					    len, sizeof(u16), type);
@@ -263,6 +265,10 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 			hdev->advmon_no_filter_duration =
 							TLV_GET_LE16(buffer);
 			break;
+		case 0x0001f:
+			hdev->enable_advmon_interleave_scan =
+							TLV_GET_LE16(buffer);
+			break;
 		default:
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
-- 
2.28.0.618.gf4bc123cb7-goog

