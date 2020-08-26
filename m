Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB36A253A57
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHZWre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgHZWra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:47:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77323C061757
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:47:29 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls14so1576623pjb.3
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BTV2RlnMnYfEfU+n6J7LxKvHGWuogRfWUjxo9oBtDWg=;
        b=hunhi80imRT79pQZiQ6L3lKxUljVv11uqwzOckeYlSW2xC/1XGMNrtCJoldSMClPz6
         LLho8FdrvVzbnWU6iQtwlGYc5JfAhX03Cz8UiUfxOW/JAs04Gjx6L1onY5EalO1ukw5S
         lRgunltwr0SCkQ5/7jkBVzavGV8Nkhvy6GTGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BTV2RlnMnYfEfU+n6J7LxKvHGWuogRfWUjxo9oBtDWg=;
        b=b+6tn2opYQHLpIQZU+O/6xJc8k9T6wjjSL/UPvktZLabZE1ubtcp2Qx0MjzSkPlhEg
         3PAXxKCvlcSfKBkrJlS6oNlQ8ms6Ac1825idEIDc9GYsI/0P6E96jf8qSUhqDf8sNAB+
         L2BNx19g1tkUmZqUX2SwWaxsPjFrzb/aW/dbi0L6aBb03gU0nrpAgHrb9oW7/xWX4vKp
         ec8UiPWNy/LmET/1S+bxTCT7t6ia69D6m4TW1rQYSctrdO77RHVLfBG8VOn206HyTU1g
         241RZOkuatTe6u6T2EoxojVkv4gDFfM/QjtO/E7x+/tbne5bHMQ39ZS4ay8108buOXsy
         bVNA==
X-Gm-Message-State: AOAM532KxuXIOHWlv3R98JZftMhssZfztBu/2544ARtSLZgvvnDj5kQc
        bBiPzOmBZrDWyR8JG2APJTai7A==
X-Google-Smtp-Source: ABdhPJzp3CSsjDcKg/29/X87IL09PfgN+zVZmYuop0NFK3+uXle3rQu5a8WZU1dDdQPrIdlRbbCi9g==
X-Received: by 2002:a17:90a:8817:: with SMTP id s23mr8065795pjn.158.1598482048667;
        Wed, 26 Aug 2020 15:47:28 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id s10sm123093pjl.37.2020.08.26.15.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 15:47:28 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>
Subject: [PATCH] Bluetooth: Clear suspend tasks on unregister
Date:   Wed, 26 Aug 2020 15:47:22 -0700
Message-Id: <20200826154719.1.I24fb6cc377d03d64d74f83cec748afd12ee33e37@changeid>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While unregistering, make sure to clear the suspend tasks before
cancelling the work. If the unregister is called during resume from
suspend, this will unnecessarily add 2s to the resume time otherwise.

Fixes: 4e8c36c3b0d73d (Bluetooth: Fix suspend notifier race)
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---
This was discovered with RT8822CE using the btusb driver. This chipset
will reset on resume during system suspend and was unnecessarily adding
2s to every resume. Since we're unregistering anyway, there's no harm in
just clearing the pending events.

 net/bluetooth/hci_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 68bfe57b66250f..ed4cb3479433c0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3442,6 +3442,16 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	}
 }
 
+static void hci_suspend_clear_tasks(struct hci_dev *hdev)
+{
+	int i;
+
+	for (i = 0; i < __SUSPEND_NUM_TASKS; ++i)
+		clear_bit(i, hdev->suspend_tasks);
+
+	wake_up(&hdev->suspend_wait_q);
+}
+
 static int hci_suspend_wait_event(struct hci_dev *hdev)
 {
 #define WAKE_COND                                                              \
@@ -3785,6 +3795,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	cancel_work_sync(&hdev->power_on);
 
 	unregister_pm_notifier(&hdev->suspend_notifier);
+	hci_suspend_clear_tasks(hdev);
 	cancel_work_sync(&hdev->suspend_prepare);
 
 	hci_dev_do_close(hdev);
-- 
2.28.0.297.g1956fa8f8d-goog

