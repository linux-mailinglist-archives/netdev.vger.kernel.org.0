Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2173884C6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 04:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbhESCaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 22:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhESC37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 22:29:59 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A6AC06175F
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 19:28:40 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id h23-20020a17090aa897b029015cc61ef388so6278198pjq.9
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 19:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FVGWDUxOSQXqwV1oVvwfvcpxMVSEuntW/wya4Y8Dz74=;
        b=Kv99QuVwv0R8+uS6Ha7HwuRXHrxFfuD61FuFAcYr+f67tbCvLdSQKUSqIIE+Ywzw9s
         Nn/QGYYclrdtUP/RzbHDow7Qfhnspt5FY9DvDQWOWSg+Gvqyv+u95AZth1szOjFNmJC6
         JaZYjfhVzsW3yVn78hvK/yEZf/CtuLB8SGQJKzXkw9yB7wvVlF+e1WBWFPn0Wn4kBic4
         lqIgxZmH2IuIaSbi5QLhRgj5hQdDYrWp4on7RjQWIuz6Mo9/zcGyzDWnBGIaUFI1CPsj
         yUWqIaYUIr/FGTehdffIKzqa9/z2PccZheYvzcoySClnJcVA8hTWXyW4sP23bvjYW4cZ
         Fppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FVGWDUxOSQXqwV1oVvwfvcpxMVSEuntW/wya4Y8Dz74=;
        b=mL2tWGdoenmViYphPZVubvHdChLt1Av+3ysH7hRC2Pb+giY4kk/RMrB236oFlknrSp
         RYrqYuYVdFjjv3Sdnf7rdcgKgIKIO993EUBXzqHovuTZDpwGgqredWZjNHCQpGqTwOis
         VmoW37pItLwoFwT1vYZJBTpSJi4VoFKbDWo7ZEQW7ntvtrSZL+YyuysR9MzrnI5CCAj0
         9rQwM1NxpVrEJhw50FqbN4Ybm8L4RMvimYyqVeIS2y1HOn6jw9BvMfdSKOG7R7T00GN6
         DBs7UcleBDi9Za+a8ruE6IOByv492KzdhLPsOMRKY1/6LaMHCShyswtvz60F4DifnlyN
         gb9g==
X-Gm-Message-State: AOAM53082USFU31Ri+TCcuu2iGTdLeSrMtKLoR+GT9nyoa+miEJUEVf2
        ydQ950/7NtCmNHaDvCFvD8shXXI2S9QJfzceig==
X-Google-Smtp-Source: ABdhPJx7aXy8r1+KQr/Kr8VQoRrKo2WytXsGmi7FnoNo9WOn2h3sx+n7bUM5Mvg+qbJIXTfZzNJQ0ceX64JRryMDoQ==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:8466:7dd1:317:13e2])
 (user=howardchung job=sendgmr) by 2002:aa7:99da:0:b029:2de:4387:9e46 with
 SMTP id v26-20020aa799da0000b02902de43879e46mr6491952pfi.55.1621391320166;
 Tue, 18 May 2021 19:28:40 -0700 (PDT)
Date:   Wed, 19 May 2021 10:28:33 +0800
Message-Id: <20210519102745.v1.1.I69e82377dd94ad7cba0cde75bcac2dce62fbc542@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v1] Bluetooth: disable filter dup when scan for adv monitor
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Yun-Hao Chung <howardchung@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yun-Hao Chung <howardchung@chromium.org>

Disable duplicates filter when scanning for advertisement monitor for
the following reasons. The scanning includes active scan and passive
scan.

For HW pattern filtering (ex. MSFT), some controllers ignore
RSSI_Sampling_Period when the duplicates filter is enabled.

For SW pattern filtering, when we're not doing interleaved scanning, it
is necessary to disable duplicates filter, otherwise hosts can only
receive one advertisement and it's impossible to know if a peer is still
in range.

Reviewed-by: Archie Pusaka <apusaka@chromium.org>

Signed-off-by: Yun-Hao Chung <howardchung@chromium.org>
---

 net/bluetooth/hci_request.c | 42 ++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index fa9125b782f85..54be4f112ef55 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -932,7 +932,7 @@ static bool scan_use_rpa(struct hci_dev *hdev)
 
 static void hci_req_start_scan(struct hci_request *req, u8 type, u16 interval,
 			       u16 window, u8 own_addr_type, u8 filter_policy,
-			       bool addr_resolv)
+			       bool filter_dup, bool addr_resolv)
 {
 	struct hci_dev *hdev = req->hdev;
 
@@ -997,7 +997,7 @@ static void hci_req_start_scan(struct hci_request *req, u8 type, u16 interval,
 
 		memset(&ext_enable_cp, 0, sizeof(ext_enable_cp));
 		ext_enable_cp.enable = LE_SCAN_ENABLE;
-		ext_enable_cp.filter_dup = LE_SCAN_FILTER_DUP_ENABLE;
+		ext_enable_cp.filter_dup = filter_dup;
 
 		hci_req_add(req, HCI_OP_LE_SET_EXT_SCAN_ENABLE,
 			    sizeof(ext_enable_cp), &ext_enable_cp);
@@ -1016,7 +1016,7 @@ static void hci_req_start_scan(struct hci_request *req, u8 type, u16 interval,
 
 		memset(&enable_cp, 0, sizeof(enable_cp));
 		enable_cp.enable = LE_SCAN_ENABLE;
-		enable_cp.filter_dup = LE_SCAN_FILTER_DUP_ENABLE;
+		enable_cp.filter_dup = filter_dup;
 		hci_req_add(req, HCI_OP_LE_SET_SCAN_ENABLE, sizeof(enable_cp),
 			    &enable_cp);
 	}
@@ -1053,6 +1053,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 	u8 own_addr_type;
 	u8 filter_policy;
 	u16 window, interval;
+	/* Default is to enable duplicates filter */
+	u8 filter_dup = LE_SCAN_FILTER_DUP_ENABLE;
 	/* Background scanning should run with address resolution */
 	bool addr_resolv = true;
 
@@ -1106,6 +1108,19 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 	} else if (hci_is_adv_monitoring(hdev)) {
 		window = hdev->le_scan_window_adv_monitor;
 		interval = hdev->le_scan_int_adv_monitor;
+
+		/* Disable duplicates filter when scanning for advertisement
+		 * monitor for the following reasons.
+		 *
+		 * For HW pattern filtering (ex. MSFT), some controllers ignore
+		 * RSSI_Sampling_Period when the duplicates filter is enabled.
+		 *
+		 * For SW pattern filtering, when we're not doing interleaved
+		 * scanning, it is necessary to disable duplicates filter,
+		 * otherwise hosts can only receive one advertisement and it's
+		 * impossible to know if a peer is still in range.
+		 */
+		filter_dup = LE_SCAN_FILTER_DUP_DISABLE;
 	} else {
 		window = hdev->le_scan_window;
 		interval = hdev->le_scan_interval;
@@ -1113,7 +1128,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 
 	bt_dev_dbg(hdev, "LE passive scan with whitelist = %d", filter_policy);
 	hci_req_start_scan(req, LE_SCAN_PASSIVE, interval, window,
-			   own_addr_type, filter_policy, addr_resolv);
+			   own_addr_type, filter_policy, filter_dup,
+			   addr_resolv);
 }
 
 static bool adv_instance_is_scannable(struct hci_dev *hdev, u8 instance)
@@ -3135,6 +3151,8 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 	u8 own_addr_type;
 	/* White list is not used for discovery */
 	u8 filter_policy = 0x00;
+	/* Default is to enable duplicates filter */
+	u8 filter_dup = LE_SCAN_FILTER_DUP_ENABLE;
 	/* Discovery doesn't require controller address resolution */
 	bool addr_resolv = false;
 	int err;
@@ -3159,9 +3177,23 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 	if (err < 0)
 		own_addr_type = ADDR_LE_DEV_PUBLIC;
 
+	if (hci_is_adv_monitoring(hdev)) {
+		/* Duplicate filter should be disabled when some advertisement
+		 * monitor is activated, otherwise AdvMon can only receive one
+		 * advertisement for one peer(*) during active scanning, and
+		 * might report loss to these peers.
+		 *
+		 * Note that different controllers have different meanings of
+		 * |duplicate|. Some of them consider packets with the same
+		 * address as duplicate, and others consider packets with the
+		 * same address and the same RSSI as duplicate.
+		 */
+		filter_dup = LE_SCAN_FILTER_DUP_DISABLE;
+	}
+
 	hci_req_start_scan(req, LE_SCAN_ACTIVE, interval,
 			   hdev->le_scan_window_discovery, own_addr_type,
-			   filter_policy, addr_resolv);
+			   filter_policy, filter_dup, addr_resolv);
 	return 0;
 }
 
-- 
2.31.1.751.gd2f1c929bd-goog

