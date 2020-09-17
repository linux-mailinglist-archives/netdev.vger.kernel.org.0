Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B591826D31D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 07:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgIQFar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 01:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgIQFaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 01:30:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C465C061756
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:30:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r9so1137811ybd.20
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ygbRGR9MwQmhVfnOPf7/bfPQRgvGhgJ28URwKmtcTXY=;
        b=fLZlyxtD0aKEcvA+dEYTYrEvrvvko2Dbwk39ayqkCi3IVgAoZ2lGWWQLlSkz7NCtZt
         Gxl17cg91T1SEeE3eFkQV3YfMYi8ACcRKW88i3MTs9ZuNBQKPqTdObZFhMS6W9Tuk6p6
         7xMhwuzMtJVrv3CO9DQd6HDlt5sgfnhnvscmuQNxGaKEalmzEEsdgdd/cX/T1xX7I4Rr
         3YasPxPPbNlw0Oobkc8Kri8QCyDtLTy9CuzVqtCohi6J80rDk0ogYK2tksgssNzH7wAi
         9XDM/HFhN9tsgOJx0BRamQltRGpK/lnP8/fh+PCBNktQCogE54XodNeAruDxBpKOMNcv
         si3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ygbRGR9MwQmhVfnOPf7/bfPQRgvGhgJ28URwKmtcTXY=;
        b=r7XL8OJ7Tbrn7WQEhvbEwMgZF8Hvkihgh7vz8cUoUzGR5K2gC/Ao84y+w/5vb7q+h7
         N93TEca+RLgZ8Atw4xF++az10C4TRS/hg/rxjmuXQnuLjAQC82eENCyADADEa0R6WLr4
         yAlDRflZdYCPdrtKrf/2G+ETrreObZZZE2c0U3FuGGIpRr/NDEqROqYAmAinTF7lfEVh
         pif+q/x5O4lDnDBNSN/9uUD65zr9jiiMrV+uXPbcz5DAfE2P+CXWCH0/2UzuyEyJy26r
         kaejF2UQPO4wRfIcwfASBlS7AKDWGN6U02i8JLVqc3Dykoh0oI31qfKRL1kOa5kZlCPN
         1FFw==
X-Gm-Message-State: AOAM533/8PL12x2j3L1uE5nSiLD+QFU2nttPVpMtIWv+iaPfqc8/w41k
        /yRcaXB9/hykPxm+DOyefft+QyHjTJuD0pPQ6Q==
X-Google-Smtp-Source: ABdhPJzRjYVShJdRorG6MaSccBe6ZdX1e3S2/18Yaiab0f2LybTKVk9bv/O83Y1YB3R7mSO5Sq+2PCBsGO7y2bLfyQ==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a25:23d6:: with SMTP id
 j205mr21425311ybj.76.1600320606780; Wed, 16 Sep 2020 22:30:06 -0700 (PDT)
Date:   Thu, 17 Sep 2020 13:29:43 +0800
In-Reply-To: <20200917132836.BlueZ.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Message-Id: <20200917132836.BlueZ.6.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20200917132836.BlueZ.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [BlueZ PATCH 6/6] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     mcchou@chromium.org, marcel@holtmann.org, mmandlik@chromium.org,
        howardchung@google.com, luiz.dentz@gmail.com, alainm@chromium.org,
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
index 6dc3e43dcaa9f..4df6de44ee438 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -69,6 +69,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 						def_le_autoconnect_timeout),
 		HDEV_PARAM_U16(0x001d, advmon_allowlist_duration),
 		HDEV_PARAM_U16(0x001e, advmon_no_filter_duration),
+		HDEV_PARAM_U16(0x001f, enable_advmon_interleave_scan),
 	};
 	struct mgmt_rp_read_def_system_config *rp = (void *)params;
 
@@ -143,6 +144,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x001c:
 		case 0x001d:
 		case 0x001e:
+		case 0x001f:
 			if (len != sizeof(u16)) {
 				bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
 					    len, sizeof(u16), type);
@@ -264,6 +266,10 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
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

