Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467A73EE6CC
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 08:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbhHQGou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 02:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhHQGot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 02:44:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AC9C061764;
        Mon, 16 Aug 2021 23:44:17 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so4732782pjl.4;
        Mon, 16 Aug 2021 23:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qGW+/u32RfeHULBSPZGyDEkWYbTkSdQ+pj8g3ZZmAtc=;
        b=mqctxBRs74ZzJjSEeMaWsZHYwP3Sl5ea4IY+Up3swBYWGUCjaNlFTWFWG7ngKe3ZeD
         dZF3f7KVWbgbItP2LiZHwQIQhTv5eE1MCHNozDIct0ma/qF1j0jYuV6Pzac60PnUOdQh
         Yc6K4mo15ceBG2vriCuA2q53cCf385HJcZ3gmgFXpDnzqfA6GpO/p5C1OBucHpcDQI/E
         M6wHd0lueb8i28kR4eYaS9hFT6DVFV20kWeBgRnOhgvqdF7krJ8Ke+Zh0mQYTBb5E4+d
         XHJpGCbFgGVFwFcJzHKbV6dOcgYvISlFWXumEmXYF4APsSKT88Y6LzIFrZYahjxEYqJw
         OZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qGW+/u32RfeHULBSPZGyDEkWYbTkSdQ+pj8g3ZZmAtc=;
        b=H7u7+10AItE+C7iZ6gZZL4VmQGQcyU7DZf1bTt4nJvr6N/vz/u4xSmzdZVL8BrExny
         ds0ZiaRp1eW2NXTipt5nrnrUgxlGy4deHdGBIV+aFjSjJzrNiLGQuZ2qhqZlriPnd0OT
         cIvG3DBtUhn8wkKBoEgkPxJUVy47SyZZthoiuqhaXO6LhmFvX0OLtJh0WJCnUFoooehn
         nQA8jvPQ/q5uVI9cqNCWJ/GZtHW2mmrL+lukTS8a59RLruKqcajdhEsA3mgiWdRGF5Bf
         BmUa+v0JtkPRf7GG9Ev/EHvMG7jZdZe9s1Ip4ipPKJ/nJOuWeMFxI8y8Yc0uQ57jm/8/
         O8cQ==
X-Gm-Message-State: AOAM532YIqz8myIT0r9Ld65h9H+QoS9Fzm2HSVlL90LvvGoCDBmW6evf
        4BS4QUvcTpkTPUYk+UqROsGAUvWboW70c5IvsuI=
X-Google-Smtp-Source: ABdhPJxYbpn9kCLT1fi4MGjMSaFXdc5Za03AsrYBuk1cjQTNcYjUZigKFjQenBx/bqdN8VorIN51bg==
X-Received: by 2002:a63:5509:: with SMTP id j9mr2064571pgb.329.1629182656474;
        Mon, 16 Aug 2021 23:44:16 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id z11sm1301192pfn.69.2021.08.16.23.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 23:44:15 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] Bluetooth: Fix return value in hci_dev_do_close()
Date:   Tue, 17 Aug 2021 15:44:11 +0900
Message-Id: <20210817064411.2378-1-l4stpr0gr4m@gmail.com>
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

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
 net/bluetooth/hci_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8622da2d9395..84afc0d693a8 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1718,6 +1718,7 @@ static void hci_pend_le_actions_clear(struct hci_dev *hdev)
 int hci_dev_do_close(struct hci_dev *hdev)
 {
 	bool auto_off;
+	int ret = 0;
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
@@ -1732,13 +1733,13 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	    test_bit(HCI_UP, &hdev->flags)) {
 		/* Execute vendor specific shutdown routine */
 		if (hdev->shutdown)
-			hdev->shutdown(hdev);
+			ret = hdev->shutdown(hdev);
 	}
 
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
 		hci_req_sync_unlock(hdev);
-		return 0;
+		return ret;
 	}
 
 	hci_leds_update_powered(hdev, false);
@@ -1845,7 +1846,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_req_sync_unlock(hdev);
 
 	hci_dev_put(hdev);
-	return 0;
+	return ret;
 }
 
 int hci_dev_close(__u16 dev)
-- 
2.26.2

