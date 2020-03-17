Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A861D18794E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 06:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgCQFke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 01:40:34 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:45860 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgCQFkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 01:40:33 -0400
Received: by mail-vk1-f201.google.com with SMTP id j68so5135759vkj.12
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 22:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=el82hvu8NsarLBH+1bSM5mOhPUGbPGRaUwoQglxhFZs=;
        b=PYz7uO05mG25NfUmMbpjZKCOZbxuF3u1CeNkjJDeW4SMOhqxfZ8/yJnrMmXdi5VeV9
         jLeEmHj7qIs4osoWmBuCse20pEigoQMUyodNp4LVCkIFfxAmuJGBmppBctcZwXwFJswS
         OvZOFL6C0u/qSaIFvukwFUyXBft83T5SZ5hENFMj2ZDSiVK95DInCXLMfOWVnKSZx5El
         8gf+eV+iBgYPGi0qZWqUk+HDBB8rxlPmuysjBNfDUEerKhf6EvCQqedBOafPX0dlv4lP
         IcCYZvNxs09Abb1wNrlU1kT9ge6uVBZGxxeopIZQYjEiRQECmydKvBsibIEdfkGryNnY
         mPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=el82hvu8NsarLBH+1bSM5mOhPUGbPGRaUwoQglxhFZs=;
        b=PAYeQ4WHfxa01h4n3HaOcCgqnCODM/DW+WNke0Uf6OjCiJKJJaKEIyYIkl0RenGtq4
         7/4oW5pxSn4pfcYx/VQkjVK9Vx7+lrNViKjDO9glHKw3LxCWCYByWmZJ8ZqhTZu//JEY
         nW4QuBoSGFKD06MeIHz/EDiKxJHdcxmPjV1MFn0E7/T0Y79XtrZUqERhe2YjvAUEEK7D
         4bQPOHXux/60SVFnOKbCvif2SL85r9cyRYZSE/GWW7TVzIUOM+wCUCGPcPa+lzjB1kf2
         do8iYsyzIBq2+jhF/QXoJ2GGOMxKlF8CGsIYyzox5vbkM09IFH90y4pPZvXigtcMfRmo
         nu8w==
X-Gm-Message-State: ANhLgQ3aw1TDYCtrxodXYr8zfeqnC+y7qc++KL38AsWqGUCyR7HVYG7/
        euTAJLNlGhjqKGTQqYT0fXp3qGy4NPlJCQ==
X-Google-Smtp-Source: ADFU+vvobSt7t9RrwR/m04uzP8LCbT1bE28OruemFxbEsN4zMun2S8b74DOmhSvpXfrTSMb4P36QDEyPRn8AGw==
X-Received: by 2002:ab0:614c:: with SMTP id w12mr2373505uan.141.1584423632602;
 Mon, 16 Mar 2020 22:40:32 -0700 (PDT)
Date:   Mon, 16 Mar 2020 22:40:27 -0700
Message-Id: <20200316224023.1.I002569822232363cfbb5af1f33a293ea390c24c7@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH] Bluetooth: Do not cancel advertising when starting a scan
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org
Cc:     Yoni Shavit <yshavit@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        Dmitry Grinberg <dmitrygr@google.com>,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Grinberg <dmitrygr@google.com>

BlueZ cancels adv when starting a scan, but does not cancel a scan when
starting to adv. Neither is required, so this brings both to a
consistent state (of not affecting each other). Some very rare (I've
never seen one) BT 4.0 chips will fail to do both at once. Even this is
ok since the command that will fail will be the second one, and thus the
common sense logic of first-come-first-served is preserved for BLE
requests.

Signed-off-by: Dmitry Grinberg <dmitrygr@google.com>
Signed-off-by: Manish Mandlik <mmandlik@google.com>
---

 net/bluetooth/hci_request.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index bf83179ab9d19..649e1e5ed446a 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -2727,23 +2727,6 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 
 	BT_DBG("%s", hdev->name);
 
-	if (hci_dev_test_flag(hdev, HCI_LE_ADV)) {
-		hci_dev_lock(hdev);
-
-		/* Don't let discovery abort an outgoing connection attempt
-		 * that's using directed advertising.
-		 */
-		if (hci_lookup_le_connect(hdev)) {
-			hci_dev_unlock(hdev);
-			return -EBUSY;
-		}
-
-		cancel_adv_timeout(hdev);
-		hci_dev_unlock(hdev);
-
-		__hci_req_disable_advertising(req);
-	}
-
 	/* If controller is scanning, it means the background scanning is
 	 * running. Thus, we should temporarily stop it in order to set the
 	 * discovery scanning parameters.
-- 
2.25.1.481.gfbce0eb801-goog

