Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B7C2FFF04
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbhAVIj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbhAVIiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:38:24 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FF6C06121F
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 00:36:50 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l3so4814177ybl.17
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 00:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=GoHtCD9i/HlVEXFt8+h29d4MxhFf0tqQCKDbQQUvONI=;
        b=KscSHaebmBoTdf9LwsLcKwhJu7p25PKadVGRGPcdgMhNa9uYGj7f/lLucOa+aWC3fl
         vY/l29jJ2pyHn+IKkRioQHrLpmAt6Ea7xkTDEZK9Clys1KSCa3zmr7Z46lY5JOzQjS0W
         G+hy/sOMiPKuu2orYQ/nD43LyI6ISciPMmbT480i/NB5wDM4TmHir8yzP2G1CByCZuW4
         xrBKBGDtiX9OG8Q2DXXXbXInZh3ASShQXvuzGAZb0xsU1SCnhxn3I7/P5vfpdjINWoMx
         l7kK4DflvVo+jHoRNcw4vtUx6veHPPqt4QKZ2CyxDLIXtwD3DPIaa0FuMBh5YX+EZLVb
         zUUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GoHtCD9i/HlVEXFt8+h29d4MxhFf0tqQCKDbQQUvONI=;
        b=WvhRRJNr9dMbiTvEryV/Ye2Y4gA91ckFPPKdn+7NRJj33w0UnzAxPIvYVAUKUFv/XC
         Tp4zj0ilizOVB1PFV4VvXzB9NQVdQm9D9eEcjboe9eGeKVRCb72DCdLEyhj/TMVTaE6g
         y0B6Y7lin6+obg/Ib0Vz6i6maZZTf77Nqrc4ZM0ve4HxYnx1928LDIY5NHJv6h1qIV2C
         Rmy4ZzjXoDd67VdxXNRIaQr0QfV4zkRH87JJCn7q314GvrPQoqdJHTzZoiDHuZ4EdSSB
         eHIZjK2XXVEdrO+JBh454xM7l1VXyHh9LgN1Wc/Bh91k4e/4b91a/FZBoxAiC213vgC/
         gfvA==
X-Gm-Message-State: AOAM532r2+Z8zWIaafgHd6kwAhAcbx8W5iR68G0IgHf6hBng7pA1H8Qy
        sVNiJnYslkqquxkzglY6a6wUzecg97om
X-Google-Smtp-Source: ABdhPJzP0Z89akTyWApS8norA15HXkqT/+ByEX6DtZyJArvEPRt0i/XUcHRgwH9a05Z+gb46wHGl2o9KZvdp
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:f693:9fff:fef4:2347])
 (user=apusaka job=sendgmr) by 2002:a25:41c9:: with SMTP id
 o192mr5005552yba.100.1611304609718; Fri, 22 Jan 2021 00:36:49 -0800 (PST)
Date:   Fri, 22 Jan 2021 16:36:16 +0800
In-Reply-To: <20210122083617.3163489-1-apusaka@google.com>
Message-Id: <20210122163457.v6.6.If655289cea81baf9226583a39f703ddc53817a51@changeid>
Mime-Version: 1.0
References: <20210122083617.3163489-1-apusaka@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v6 6/7] Bluetooth: advmon offload MSFT interleave scanning integration
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

When MSFT extension is supported, we don't have to interleave the scan
as we could just do allowlist scan.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>

---

Changes in v6:
* New patch "advmon offload MSFT interleave scanning integration"

 net/bluetooth/hci_request.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 5aa7bd5030a2..d29a44d77b4e 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -404,13 +404,18 @@ static void cancel_interleave_scan(struct hci_dev *hdev)
  */
 static bool __hci_update_interleaved_scan(struct hci_dev *hdev)
 {
-	/* If there is at least one ADV monitors and one pending LE connection
-	 * or one device to be scanned for, we should alternate between
-	 * allowlist scan and one without any filters to save power.
+	/* Do interleaved scan only if all of the following are true:
+	 * - There is at least one ADV monitor
+	 * - At least one pending LE connection or one device to be scanned for
+	 * - Monitor offloading is not supported
+	 * If so, we should alternate between allowlist scan and one without
+	 * any filters to save power.
 	 */
 	bool use_interleaving = hci_is_adv_monitoring(hdev) &&
 				!(list_empty(&hdev->pend_le_conns) &&
-				  list_empty(&hdev->pend_le_reports));
+				  list_empty(&hdev->pend_le_reports)) &&
+				hci_get_adv_monitor_offload_ext(hdev) ==
+				    HCI_ADV_MONITOR_EXT_NONE;
 	bool is_interleaving = is_interleave_scanning(hdev);
 
 	if (use_interleaving && !is_interleaving) {
@@ -899,14 +904,11 @@ static u8 update_white_list(struct hci_request *req)
 
 	/* Use the allowlist unless the following conditions are all true:
 	 * - We are not currently suspending
-	 * - There are 1 or more ADV monitors registered
+	 * - There are 1 or more ADV monitors registered and it's not offloaded
 	 * - Interleaved scanning is not currently using the allowlist
-	 *
-	 * Once the controller offloading of advertisement monitor is in place,
-	 * the above condition should include the support of MSFT extension
-	 * support.
 	 */
 	if (!idr_is_empty(&hdev->adv_monitors_idr) && !hdev->suspended &&
+	    hci_get_adv_monitor_offload_ext(hdev) == HCI_ADV_MONITOR_EXT_NONE &&
 	    hdev->interleave_scan_state != INTERLEAVE_SCAN_ALLOWLIST)
 		return 0x00;
 
-- 
2.30.0.280.ga3ce27912f-goog

