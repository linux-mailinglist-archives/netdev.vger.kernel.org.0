Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154464DB4C3
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357252AbiCPPWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351322AbiCPPWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:22:17 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFC26C91C
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:21:03 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bg10so4934997ejb.4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RtjHsmXPT8LE+jJTyR39fP968xbgt2lw05SHk5jQS8s=;
        b=ladl5qMJYh8eWYEPBOE0kNvMnkur6GAkQG8+IENKJMv8BN6NUjo8VwC7lshRiqSt9I
         BonGyikuj4q+vE6Fm+FRDtErf2ZHNYx33Kh+NUgcLVekUIWBL85jz+axOBYmLk28B87A
         JEc9MagCf7m57VkNUkfAlkFMDfQ7PIcG7ZAbsFdL42uH3ZuAP+JNpHBdQ++iVLKYX5be
         j0YyihkTlxt9u4uDG3xkWCUSrnaTh/3jWIungPMFfM5K96sIZ4d/fWr82BtoBMGOwuSU
         W//tDd3HYyn06c4XgwUuA3NKN4n3+aowgENGJGzUKFqKgZ7Zpfjro+zMhzoUvnk4PApe
         LfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RtjHsmXPT8LE+jJTyR39fP968xbgt2lw05SHk5jQS8s=;
        b=wlu1yypo7nII7vcItL0+V1meBXN8KgImncgPmSdkyDGmI8J1shd9yZV1aGwLQ/EQu6
         cX6G1dluCd2SCWW4/+FLhXS9lX7yWCGwPiKR/3P7+28d28UG3kOBub4mLXn0KQmMaBkt
         30TgOV/ZaxcrN47A/PybF9Rcmj37tmBzF4MlOVY+Vo5pvsSqxItQI1sas1bQxgZhHJp+
         ZVj3z+yXVRedkvgfKfwo8gHQdXoXsp+bnCRh5MCa8+uZtCxRZw5i86sM+WewZltvq9OR
         F84CH6c3O02e5fZpWVQXOMlIIclgRQOlZpcOaJQau3o3ycxVd9RGYCUauzxqqToKr3Wn
         Q5tw==
X-Gm-Message-State: AOAM531AI+4kV2PiK4XLSgIiP6yJ7e3NxHSXZ0kehndViq7I1twwXvyh
        S9z2vN250VvH9Vr3EMWIHbF8cYiFYk2BTA==
X-Google-Smtp-Source: ABdhPJyQEzMXrbt3MDDvI/dm6rvyeEYPJGHqynHUty1bqmT0ZLyYnNITj1TlX6pR5Q6Vn8a5jvwByQ==
X-Received: by 2002:a17:907:1c19:b0:6dc:c19e:8cc5 with SMTP id nc25-20020a1709071c1900b006dcc19e8cc5mr391436ejc.333.1647444061226;
        Wed, 16 Mar 2022 08:21:01 -0700 (PDT)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm1161523edz.35.2022.03.16.08.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:21:00 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH] Bluetooth: call hci_le_conn_failed with hdev lock in hci_le_conn_failed
Date:   Wed, 16 Mar 2022 16:20:28 +0100
Message-Id: <20220316152027.9988-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hci_le_conn_failed function's documentation says that the caller must
hold hdev->lock. The only callsite that does not hold that lock is
hci_le_conn_failed. The other 3 callsites hold the hdev->lock very
locally. The solution is to hold the lock during the call to
hci_le_conn_failed.

Fixes: 3c857757ef6e ("Bluetooth: Add directed advertising support through connect()")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---
 net/bluetooth/hci_conn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 04ebe901e86f..3bb2b3b6a1c9 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -669,7 +669,9 @@ static void le_conn_timeout(struct work_struct *work)
 	if (conn->role == HCI_ROLE_SLAVE) {
 		/* Disable LE Advertising */
 		le_disable_advertising(hdev);
+		hci_dev_lock(hdev);
 		hci_le_conn_failed(conn, HCI_ERROR_ADVERTISING_TIMEOUT);
+		hci_dev_unlock(hdev);
 		return;
 	}
 
-- 
2.35.1

