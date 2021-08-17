Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3583EE691
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 08:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhHQGaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 02:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhHQGaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 02:30:11 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75700C061764;
        Mon, 16 Aug 2021 23:29:39 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c17so18401281plz.2;
        Mon, 16 Aug 2021 23:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4/zqyHPXTfbyOuDdqx54f4/T3xWZotmn28vWfO0ntMY=;
        b=FA68YIvzZU4sL0AuaSBR8vtM+w9KSVSStVKmurVUjwC/utme0QZIoyiHIwUQYDoy9g
         SorjrBBWLeNLtT2P7cxnjOhslBuXqs+v9uNPRZ8nrie3l5cGnWeA+s2K2Cn1JO2J+LlF
         +WPI7STqrp9b45/0YOEYye+rzm1W8rspseU91ldfpilQmMeV6FnEBwqUYXmZeDftNJmL
         5TWN9c+dltlzbxK2V2TjUIlQEP8r136b9ydQHUTKpWZ4r8U7rNh+a74d3eFNqZl4OPN2
         qQ3jcl9/dXhuCCJhm/0MHukTdovCHqvsga6t3Q3GwFlL0TG+dunkZgd5HFRF1RItBRdi
         8CHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4/zqyHPXTfbyOuDdqx54f4/T3xWZotmn28vWfO0ntMY=;
        b=tLqP5j7U/DB44o9QBkSoHE75LgpkzqjsGQRP/AXapQT/9EcutOoYFNTnk69/K6zCNp
         lKCFOWQKbWev3umtn2GwqhdptWEBQNaheGJGzwXd7zyAv1ICDXC3R2dnv3iuA17H4A/7
         neJRxZVvHWNyLk+o5bqYqfiYptF1zZNttiJG422rmdnYbh01Dy9ev/UO9AyuLIwMkVqE
         Rj7pQ1pBS6V45vMKTItoj/MkPEQo7ONGsYfWm+iicqPJ0QQFKuOWrkfhMqnR5KlZlO7w
         4dGxB1zyB+JRBxzxXqsPEiQ8LF4hI2OCF29vIBYKOxCOgyx4O34ha0yKVgQ6T7oLuGes
         da6Q==
X-Gm-Message-State: AOAM532mYCKfpLN69b87QgXM+ILdlvcofCu/EpobUvSNswZ9NHzlSBUW
        R5EJbLiD3YdYiX9hx5oEUH4=
X-Google-Smtp-Source: ABdhPJwZ6VCGU/yyZOJaB/ti0Qi1h1cyxpMy1u33O33XBDVA9+t3Lf17x+5D3aG32h7RpI8CuCuBtg==
X-Received: by 2002:aa7:8014:0:b029:3cd:b6f3:5dd6 with SMTP id j20-20020aa780140000b02903cdb6f35dd6mr2098946pfi.39.1629181778979;
        Mon, 16 Aug 2021 23:29:38 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id o9sm1312374pfh.217.2021.08.16.23.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 23:29:38 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] Bluetooth: Fix return value in hci_dev_do_close()
Date:   Tue, 17 Aug 2021 15:29:33 +0900
Message-Id: <20210817062933.2330-1-l4stpr0gr4m@gmail.com>
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
index b0d9c36acc03..fa5f23df4fc3 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1711,6 +1711,7 @@ static void hci_pend_le_actions_clear(struct hci_dev *hdev)
 int hci_dev_do_close(struct hci_dev *hdev)
 {
 	bool auto_off;
+	int ret = 0;
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
@@ -1719,7 +1720,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	    test_bit(HCI_UP, &hdev->flags)) {
 		/* Execute vendor specific shutdown routine */
 		if (hdev->shutdown)
-			hdev->shutdown(hdev);
+			ret = hdev->shutdown(hdev);
 	}
 
 	cancel_delayed_work(&hdev->power_off);
@@ -1730,7 +1731,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
 		hci_req_sync_unlock(hdev);
-		return 0;
+		return ret;
 	}
 
 	hci_leds_update_powered(hdev, false);
@@ -1836,7 +1837,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_req_sync_unlock(hdev);
 
 	hci_dev_put(hdev);
-	return 0;
+	return ret;
 }
 
 int hci_dev_close(__u16 dev)
-- 
2.26.2

