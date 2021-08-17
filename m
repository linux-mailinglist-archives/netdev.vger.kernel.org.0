Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A2E3EE5F3
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhHQEzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhHQEzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:55:50 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C522C061764;
        Mon, 16 Aug 2021 21:55:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j1so30097903pjv.3;
        Mon, 16 Aug 2021 21:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hAXABoom5XY+ws1/jiIFHmNJnWtweNFayiGnrPzUhKo=;
        b=ewl9OoE2pnxQkOSLm43GnYt9fFJEhFLOIu9grvLJPILw3j5E4dnW+TOZAhmE/Apjxl
         5x4TGw+X4B63h4YW4rmdCNkAHLi/K/OQdBPhM3czyyqDQOsDBvkISIWyEW0F89azcIvh
         is5rfYxu6D/cNOpIskVZLvE1i1jfayvBLqf89Rhyf3uChgdMWHiR3j5GxhAxwRD6N3ok
         Itgf2Mtpzx9yJW2mLZYxyizR9wKa2D7ska7MziSU0Q40+Bwy0k3qgk4ayZ+1UBn5aYNU
         /qFXjNqV1+ZfB5WVduvwdpUZfAhZToy6gPn4MpWB7d74vvYjKyQO/AX0Avr37ZFT9Uc1
         KEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hAXABoom5XY+ws1/jiIFHmNJnWtweNFayiGnrPzUhKo=;
        b=s3HsaSOqYyyFscYXB6FZYJN+ELCjZbodPdUg95+0JK9f4Bb1b6MfMrPQ39EaUs5kTk
         0Tjbph6D/BXE5CY0/7DOGlgfjxNyaQ8+F0SDIP8BVoZC2TzrDASyuLR4CJI8nzx4KZiQ
         MJHqQTjmADGf10Z01iXQjIv1OxUXxoAFue6APYawfCZuuire69K9z5sLp4mN4ZDnpeHH
         BWh806e0Y9Ce/1Z09C6ED3SwNWj6ajGMA0X1n3+1eQHxGBRPKwjQ0056nvlOldimOLOR
         AN7zluonsVSqVgw6WfeUrHrcXf32o4PjlxI6t4dIZvIqUwvVoDWofvOp7jzXYMBHskVa
         Rqlg==
X-Gm-Message-State: AOAM533HvmLtIMVfGul/L0/zFP8p6BS2tSgYsVhxhvXp1ivixumF0TSx
        3i96nYQ/xL3lYHPHTddB/EU=
X-Google-Smtp-Source: ABdhPJxhyhrtsbV/IkVXpjBzLeMLDOgoo0HmIE/UWAfWd+zR3AmkLu53p/slOhIqP2X4sg9Ehnu4fA==
X-Received: by 2002:a63:7cb:: with SMTP id 194mr1724744pgh.308.1629176115852;
        Mon, 16 Aug 2021 21:55:15 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id r9sm863091pfh.135.2021.08.16.21.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 21:55:15 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] Bluetooth: Fix return value in hci_dev_do_close()
Date:   Tue, 17 Aug 2021 13:55:10 +0900
Message-Id: <20210817045510.4479-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hci_error_reset() return without calling hci_dev_do_open() when
hci_dev_do_close() return error value which is not 0.

Also, hci_dev_close() return hci_dev_do_close() function's return
value.

But, hci_dev_do_close() return always 0 even if hdev->shutdown
return error value. So, fix hci_dev_do_close() to save and return
the return value of the hdev->shutdown when it is called.

Fixes: a44fecbd52a4d ("Bluetooth: Add shutdown callback before closing the device")
Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
 net/bluetooth/hci_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e1a545c8a69f..5f3c7515a8f0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1718,6 +1718,7 @@ static void hci_pend_le_actions_clear(struct hci_dev *hdev)
 int hci_dev_do_close(struct hci_dev *hdev)
 {
 	bool auto_off;
+	int ret = 0;
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
@@ -1730,7 +1731,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
 		hci_req_sync_unlock(hdev);
-		return 0;
+		return ret;
 	}
 
 	hci_leds_update_powered(hdev, false);
@@ -1803,7 +1804,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	    test_bit(HCI_UP, &hdev->flags)) {
 		/* Execute vendor specific shutdown routine */
 		if (hdev->shutdown)
-			hdev->shutdown(hdev);
+			ret = hdev->shutdown(hdev);
 	}
 
 	/* flush cmd  work */
@@ -1845,7 +1846,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_req_sync_unlock(hdev);
 
 	hci_dev_put(hdev);
-	return 0;
+	return ret;
 }
 
 int hci_dev_close(__u16 dev)
-- 
2.26.2

