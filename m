Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7682F10212E
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKSJvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:51:50 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34364 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSJvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:51:50 -0500
Received: by mail-lj1-f193.google.com with SMTP id 139so22583049ljf.1
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 01:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=OvPPW0nP0UgfQ0cd2818ZC0QNHA4p+yIjRu9N/3wtYo=;
        b=b0zMvW/wq2UtrrKOBg69aowD6IdVyfCUiFgBBEnIsLKbEUATLJgG7eq0CKVpLnYzIu
         N87KEg2JkDUa33vjatjXejzuAi7b38SU1602d1Xv/1cIWH6m9rPqcLszivTzGCoCVtVT
         +iD0x0IoKf5aSguQzD/6oeiamabFsnW6k0uHhJ0qte0jhIylyJ8OKuv+Dl8fnoi+L3Lg
         Acsse4jazlQfSnihmgxo9JBeALXdMAWl+wd6Jx2V0UpHs7bRunH0XTT7DZNq2YQIn4QM
         VFTz3vcEn2J7WwKT+TRLkph1XIH5Fmu6H0iZFlgQHLBH2Gjn+HzGWYk+J6dPdkMnt1a7
         xdRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OvPPW0nP0UgfQ0cd2818ZC0QNHA4p+yIjRu9N/3wtYo=;
        b=MIBOiX392Tt+O2gxFSwP1BAh0WvsSvQqET+ccVMZqpQ9iS+BnHjHWpyZqWZern7VUE
         d2m9wsvB8B8zBvF0+DWizDrx1dl3mD9/BUOmfRrihKGGH486ZBGdcyH+UucMPp0Ay9ey
         MhLVXt+U2bccoel80T1lH7pW5x0IuO2HrVy86VCgz+7DvNywTKeTwu7iToUK1MI5G8j6
         oIcVIaCtxX/7QsIW6FrJtXUiM+1BFdZsHKCtXWEUAPMwCsNfLJls473NGfSnsNXi7QsC
         GoBSx5D1umDb7HNLL/afE+4mg1jr2NBRvmgY64PRZrQ6010SpWERFd/D4fGLEd2srOYC
         r9rQ==
X-Gm-Message-State: APjAAAXbon0Vt0MGNEagTpetJiI4dhbRLUvxkniioOFgaXBAU0QNHTaU
        bKkitVG4ypKY4LWq2IVsv0acwIW4W/8=
X-Google-Smtp-Source: APXvYqxMvaVkSetWh90rAx0T6PpSLO0pIrQeIlGZ8ZyAvCBmgwf8t9GvqxePdN4upw5fidq0dsMsbA==
X-Received: by 2002:a2e:9194:: with SMTP id f20mr3088778ljg.154.1574157106443;
        Tue, 19 Nov 2019 01:51:46 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id k25sm9534905ljg.22.2019.11.19.01.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 01:51:45 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
Date:   Tue, 19 Nov 2019 11:51:21 +0200
Message-Id: <20191119095121.6295-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

kobject_init_and_add takes reference even when it fails. This has
to be given up by the caller in error handling. Otherwise memory
allocated by kobject_init_and_add is never freed.

Cc: David Miller <davem@davemloft.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
---
 net/core/net-sysfs.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 865ba6ca16eb..4f404bf33e44 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -923,21 +923,23 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
 				     "rx-%u", index);
 	if (error)
-		return error;
+		goto err;
 
 	dev_hold(queue->dev);
 
 	if (dev->sysfs_rx_queue_group) {
 		error = sysfs_create_group(kobj, dev->sysfs_rx_queue_group);
-		if (error) {
-			kobject_put(kobj);
-			return error;
-		}
+		if (error)
+			goto err;
 	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
 	return error;
+
+err:
+	kobject_put(kobj);
+	return error;
 }
 #endif /* CONFIG_SYSFS */
 
@@ -1461,21 +1463,21 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 				     "tx-%u", index);
 	if (error)
-		return error;
+		goto err;
 
 	dev_hold(queue->dev);
 
 #ifdef CONFIG_BQL
 	error = sysfs_create_group(kobj, &dql_group);
-	if (error) {
-		kobject_put(kobj);
-		return error;
-	}
+	if (error)
+		goto err;
 #endif
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
-	return 0;
+err:
+	kobject_put(kobj);
+	return error;
 }
 #endif /* CONFIG_SYSFS */
 
-- 
2.17.1

