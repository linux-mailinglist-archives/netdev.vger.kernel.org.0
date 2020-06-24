Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBB1207B9D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406148AbgFXSe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406087AbgFXSeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 14:34:25 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A52C0613ED
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 11:34:25 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f2so1380105plr.8
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 11:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q0SFa2U1n/gw/Ov9iaCh0A1BsBXlbDSR7iGMtKgrzh4=;
        b=M3ywDaEt0dPEA9Zei6WnBet8lO2g/RxcJupW42tD+Z1GN89NYkAYWwE6kIpHPpB0rJ
         qipLOy0qWQtG00GCJnzFKZbMB+Xv9r3oZKL4ZEHNE01UTf/rThsqs1IcKn+PXnSXydf/
         vmxiMyxlqV4w21Dy8aual9+OdpoY+1TEwWh6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q0SFa2U1n/gw/Ov9iaCh0A1BsBXlbDSR7iGMtKgrzh4=;
        b=DMd1ThBRTZfJWS364sB7esdnD44l9Hxz/xDyn4GE8vwsSQTxbRpRV4L/Do5qTdg34z
         EOv0kv7gnXmdx8VZy1pDsbNeR11wxCWEkVJAoziJ8jU3oLavwUOzEL+tTw4djlc10bu6
         +3H20NjoewGbMc0e2C5hdnwd3zheiLnbSWoCilq2Li9iWDRdS2j/VcZ1ysJPLMSIjDZS
         TpdEWWdXtxxEunaxxvqkXsJe80qGs9nY0eVaWDNBw3kQEDHwz3xwM2lxv3Yu1vVxoKYb
         +sWRWylShT15fL7v3CG9/UYp606iEoAH1N1GKCPF6DmP2Lq5EHf6zfPuzjDvH3evXI/L
         RJ3A==
X-Gm-Message-State: AOAM532DGFGwZvC7Iwnw4XkVKIyNKhUPwQGPs8yga6axf7iPL2m75Kq3
        OX5VambCtlDIF8WODBwRWgJAeA==
X-Google-Smtp-Source: ABdhPJw46RbXduZ9/vIbsjF3HOOykc1RJam9QQxJpRAMnqFUFinIl8ll04+dNKIrzY5607VmlQPE0g==
X-Received: by 2002:a17:90a:294f:: with SMTP id x15mr28400108pjf.97.1593023664707;
        Wed, 24 Jun 2020 11:34:24 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id e15sm11983263pgt.17.2020.06.24.11.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 11:34:24 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        alainm@chromium.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] Bluetooth: Don't restart scanning if paused
Date:   Wed, 24 Jun 2020 11:34:19 -0700
Message-Id: <20200624113351.1.Ic6b1fca2b1b3fe989db21ceae76bab80bd87d387@changeid>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When restarting LE scanning, check if it's currently paused before
enabling passive scanning.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---
When running suspend stress tests on Chromebooks, we discovered
instances where the Chromebook didn't enter the deepest idle states
(i.e. S0ix). After some debugging, we found that passive scanning was
being enabled AFTER the suspend notifier had run (and disabled all
scanning).

For this fix, I simply looked at all the places where we call
HCI_OP_LE_SET_SCAN_ENABLE and added a guard clause for suspend. With
this fix, we were able to get through 100+ iterations of the suspend
stress test without any problems entering S0ix.


 net/bluetooth/hci_request.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 86ae4b953a011e..116207009dde01 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -819,6 +819,11 @@ static void hci_req_start_scan(struct hci_request *req, u8 type, u16 interval,
 {
 	struct hci_dev *hdev = req->hdev;
 
+	if (hdev->scanning_paused) {
+		bt_dev_dbg(hdev, "Scanning is paused for suspend");
+		return;
+	}
+
 	/* Use ext scanning if set ext scan param and ext scan enable is
 	 * supported
 	 */
@@ -2657,6 +2662,11 @@ static int le_scan_restart(struct hci_request *req, unsigned long opt)
 	if (!hci_dev_test_flag(hdev, HCI_LE_SCAN))
 		return 0;
 
+	if (hdev->scanning_paused) {
+		bt_dev_dbg(hdev, "Scanning is paused for suspend");
+		return 0;
+	}
+
 	hci_req_add_le_scan_disable(req);
 
 	if (use_ext_scan(hdev)) {
-- 
2.27.0.111.gc72c7da667-goog

