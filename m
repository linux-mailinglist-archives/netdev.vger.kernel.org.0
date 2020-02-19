Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8981652D8
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgBSW7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:59:53 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45693 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbgBSW7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 17:59:53 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so696567pls.12
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 14:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BXeqScbdY3yqq3cB9YNVtFeROwX/m901Nait+l30Um8=;
        b=rxiA2h1Lb/1+D7tK5m6ZfDhkl9M5Mf9LOrxcyosMup1SKWrFsb5qSkJ0NFKIKnczuE
         IXg8cZJ94GOzDEFDOwfen84vZXu7oprRtWQ/2ntZtGoMEsV2t8hGEgXNEAbn2TkXv2tJ
         vYp4aXJDkjCbYWKykJbmthubFSB4W5enr1oc77dXda3EMUYjPnAZEWmN0p8wjcMu+vR2
         QjVtt4CrjnNOxst2Uv3JONDN+JKX/Ej2J4m033oWDoiQjZDXCOmwfw2l9E8vuuOL45j+
         D3kSPzHxsL4a06j1FDFyOhWxpZ36DzNpvooe+OaUfuASjO5r0u0Uq0AAVSJtLBC70fzo
         R94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BXeqScbdY3yqq3cB9YNVtFeROwX/m901Nait+l30Um8=;
        b=n+CIU2Qaq98y4GW07A5UOn23MGxGeBkE813yCkD/PhVKn33COvz+LQmmULST49ZG/x
         n4CbYoaL7sXNIpwE8jd8k8Gn5w+6lqDvy768Cg58SfnjvjV1d6FWavmqGIAbKMcQQMJU
         l5s6eEIKTzUUBMHZBiGrkbmCw4oMNrkgHLe+XGnMsHd1pPAGB6f1AMlz5DnMZAEUT0o2
         ZORyWVL46PSP44bI3GgKXvKxrLh1FS1XAHmvQbcyjcWs8W4MMbANfK9nAM8wLRaA9QTq
         ubBZbFbCDtxlvgpM8YIWSetc+9ot1l/K83pjvH3g0U3liSGyIl2L2icJyZzu6qQluWHd
         pLIA==
X-Gm-Message-State: APjAAAVn7Q6UAmEiDoDsirC0jL1hitw6mDe2By5kmaNFzQ07kYgQsvK4
        WyzD8oqE1TOZ/r6QLmqeADUufWWsTZZDUg==
X-Google-Smtp-Source: APXvYqw6q7kSxTkcwQLy24th2Vp5/Hb+ric8rI723nXGvaeR/+HViqMxvY2JcB2coNJt2Lo4h1pF8A==
X-Received: by 2002:a17:90a:ec10:: with SMTP id l16mr29479pjy.19.1582153192728;
        Wed, 19 Feb 2020 14:59:52 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id z30sm654047pfq.154.2020.02.19.14.59.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Feb 2020 14:59:52 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/1] ionic: fix fw_status read
Date:   Wed, 19 Feb 2020 14:59:42 -0800
Message-Id: <20200219225942.34005-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fw_status field is only 8 bits, so fix the read.  Also,
we only want to look at the one status bit, to allow for future
use of the other bits, and watch for a bad PCI read.

Fixes: 97ca486592c0 ("ionic: add heartbeat check")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c | 11 +++++++----
 drivers/net/ethernet/pensando/ionic/ionic_if.h  |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 87f82f36812f..46107de5e6c3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -103,7 +103,7 @@ int ionic_heartbeat_check(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
 	unsigned long hb_time;
-	u32 fw_status;
+	u8 fw_status;
 	u32 hb;
 
 	/* wait a little more than one second before testing again */
@@ -111,9 +111,12 @@ int ionic_heartbeat_check(struct ionic *ionic)
 	if (time_before(hb_time, (idev->last_hb_time + ionic->watchdog_period)))
 		return 0;
 
-	/* firmware is useful only if fw_status is non-zero */
-	fw_status = ioread32(&idev->dev_info_regs->fw_status);
-	if (!fw_status)
+	/* firmware is useful only if the running bit is set and
+	 * fw_status != 0xff (bad PCI read)
+	 */
+	fw_status = ioread8(&idev->dev_info_regs->fw_status);
+	if (fw_status == 0xff ||
+	    !(fw_status & IONIC_FW_STS_F_RUNNING))
 		return -ENXIO;
 
 	/* early FW has no heartbeat, else FW will return non-zero */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index ce07c2931a72..54547d53b0f2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -2445,6 +2445,7 @@ union ionic_dev_info_regs {
 		u8     version;
 		u8     asic_type;
 		u8     asic_rev;
+#define IONIC_FW_STS_F_RUNNING	0x1
 		u8     fw_status;
 		u32    fw_heartbeat;
 		char   fw_version[IONIC_DEVINFO_FWVERS_BUFLEN];
-- 
2.17.1

