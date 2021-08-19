Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D35B3F1CB3
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240348AbhHSP2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239919AbhHSP2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:28:00 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0860C061575;
        Thu, 19 Aug 2021 08:27:23 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u1so4150011plr.1;
        Thu, 19 Aug 2021 08:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V1JguQf7hSkeiryxCEqgeTY63Kh0FlvDJF1NBI4kCGQ=;
        b=eQnQoVVjsf8bsXWyiIDFASybzoN7zEdNgUPiTk1ralgr09DlpR1pdTPpwEk+9jsX7h
         cZLN7wntCgMLQ4HCjHjmwi82E4adgj/eSZKHpdIGZnw33dB4gAjmfvJ0Q3qf9VnC81sH
         yzWJPH3O+45urtwUoZ+y+QAhfOWwquILAFnypfEF6Lb/ojm46vV8XOIZrMedrrVikLM1
         2jJ/R12eXe4rR3VOtNUnj1lpOx1lLsoJWoPQknQWJu5wWmX2HSbXDqrmpXP/4HzSlPKh
         T2jUILYjEzR3wojxbgOAGaqzVx7Qmp1Jy8inZLtja/NM8vWyGBH1MtK7uISYW7l3QIdL
         7f2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V1JguQf7hSkeiryxCEqgeTY63Kh0FlvDJF1NBI4kCGQ=;
        b=iZmSCEOoQvxnrQ0fwfKtyl1ALT/D5O/st9iqarTIFKX2Af41v+dXleYWpUbBZS3Nci
         3ORG4giOareVmqm8wd7i2FQI3PSWvohDlU+En9D/iQTYwu84grjf0PPvPhZX3XsAhnUQ
         Up8SzF/imbDelYCd7ePNuKFEcWvw1Xos3a5FJf3u5OLrT2YDogsyHySIrnDYECgAnG2y
         BH17yZqiBnjCHzCrJbzZjSjxYkmpPHuotoo1TNK9RLR+haoy3Cg3p0oxkw+LPSHAA7xU
         a5dwBTKXULkbkcWqLFMVIC3NpXjNmndyLK08fJe3+B9fXBLtFjHX9GOUm2qyrNvIQD/Q
         a+IQ==
X-Gm-Message-State: AOAM530Eq3/zxQI+mttNVZdT8XbNORRf/DDWkS7P+T3VmurRGe9ffUax
        ZSSVZTfGjuAJNqZOzbX+INA=
X-Google-Smtp-Source: ABdhPJxfS52irM5co5NNDAIy72pDRK/Ab1siHC/iqnb8jFn7+VGtUlQniIKdcnaAL4/5Fpcmxun1UA==
X-Received: by 2002:a17:90a:8905:: with SMTP id u5mr15261390pjn.95.1629386843372;
        Thu, 19 Aug 2021 08:27:23 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id z1sm3638332pjr.0.2021.08.19.08.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 08:27:22 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] Bluetooth: Fix return value in hci_dev_do_close()
Date:   Fri, 20 Aug 2021 00:27:18 +0900
Message-Id: <20210819152718.2713-1-l4stpr0gr4m@gmail.com>
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
Changes in v4:
 - rename variable to err.

 net/bluetooth/hci_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8622da2d9395..8ed19a07d69c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1718,6 +1718,7 @@ static void hci_pend_le_actions_clear(struct hci_dev *hdev)
 int hci_dev_do_close(struct hci_dev *hdev)
 {
 	bool auto_off;
+	int err = 0;
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
@@ -1732,13 +1733,13 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	    test_bit(HCI_UP, &hdev->flags)) {
 		/* Execute vendor specific shutdown routine */
 		if (hdev->shutdown)
-			hdev->shutdown(hdev);
+			err = hdev->shutdown(hdev);
 	}
 
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
 		hci_req_sync_unlock(hdev);
-		return 0;
+		return err;
 	}
 
 	hci_leds_update_powered(hdev, false);
@@ -1845,7 +1846,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_req_sync_unlock(hdev);
 
 	hci_dev_put(hdev);
-	return 0;
+	return err;
 }
 
 int hci_dev_close(__u16 dev)
-- 
2.26.2

