Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10DC201EFB
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 02:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgFTAKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 20:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730324AbgFTAKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 20:10:37 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502E4C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 17:10:37 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d6so5054005pjs.3
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 17:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bA2Hx5ZHpgALpLTRNJ8RED5WSk+bgJtyk0UtUvWs6Ck=;
        b=C8tcCrI8g2+v2wcL3NpiNtX1IWiokLbLw8080bz8al5zRbmxNRQMiMlIXUUBpC6Pb3
         fWgQJWNsW+zM/oSOPUPebSZypulS7JDINuPt9f3+7p3BQXL4kawkzNK0zrCz473Kn+ku
         qlpP8WWn0Th6SbqDLG1uxkzeTxb6XjBlPWG9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bA2Hx5ZHpgALpLTRNJ8RED5WSk+bgJtyk0UtUvWs6Ck=;
        b=OtGwGh0TiAsakd0Ydw5LYEBZqQk5D0L/SDWzisAezV+xaYT01PwxfxFNHnY7/XkikY
         cThHoTmkE2GbLb7sCzX5eN2/yABjfDwWgzINq7Xlb2Tw6X0j9ChCPQZvtTP+zV4/CS4G
         jmIx/sY40vqzmBdq8k/gCYVqrRncMc41EY5Z9VAC5pLZlIEvVEWHjlLylj9BzxZkBTXl
         G6HIjn0Yi5ZJPjffHg8lGp34l07EVWxupACoA5cbZwhIZ8snW8EmteGF598Lv6A8GmMh
         yex6fROVXEVovTj++arib/GczNk5GfLDcr9ClEC21j2HCug9IjKBB5nq7o6oh3K/WB/t
         BeRw==
X-Gm-Message-State: AOAM531Xe1PiF/AfT91ZeLFwC0fspvItBLVOO287vZFuI3Mq//By58z7
        ua0ZLsJWz+VJWpL1pacWb/MrYQ==
X-Google-Smtp-Source: ABdhPJxutMk1mTkLK2Fj/BDxglLsp0izci0o1QVdjpFFc0keXGjw9NMDqSB7A3+jQt7om7jczbkn4g==
X-Received: by 2002:a17:90a:9904:: with SMTP id b4mr5893613pjp.207.1592611836739;
        Fri, 19 Jun 2020 17:10:36 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id y136sm7032325pfg.55.2020.06.19.17.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 17:10:36 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        mcchou@chromium.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] Bluetooth: Add hci_dev_lock to get/set device flags
Date:   Fri, 19 Jun 2020 17:10:24 -0700
Message-Id: <20200619171016.1.I56e71a63b5d2712a1b198681e0f107b5aa3cd725@changeid>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding hci_dev_lock since hci_conn_params_(lookup|add) require this
lock.

Suggested-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 net/bluetooth/mgmt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 2a732cab1dc99d..5e9b9728eeac03 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3895,6 +3895,8 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 	bt_dev_dbg(hdev, "Get device flags %pMR (type 0x%x)\n",
 		   &cp->addr.bdaddr, cp->addr.type);
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR) {
 		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
 							      &cp->addr.bdaddr,
@@ -3921,6 +3923,8 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 	status = MGMT_STATUS_SUCCESS;
 
 done:
+	hci_dev_unlock(hdev);
+
 	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_DEVICE_FLAGS, status,
 				&rp, sizeof(rp));
 }
@@ -3959,6 +3963,8 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		goto done;
 	}
 
+	hci_dev_lock(hdev);
+
 	if (cp->addr.type == BDADDR_BREDR) {
 		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
 							      &cp->addr.bdaddr,
@@ -3985,6 +3991,8 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 	}
 
 done:
+	hci_dev_unlock(hdev);
+
 	if (status == MGMT_STATUS_SUCCESS)
 		device_flags_changed(sk, hdev, &cp->addr.bdaddr, cp->addr.type,
 				     supported_flags, current_flags);
-- 
2.27.0.111.gc72c7da667-goog

