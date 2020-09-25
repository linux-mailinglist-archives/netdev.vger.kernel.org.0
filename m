Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0627901D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgIYSNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYSNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:13:09 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B74C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:13:09 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z19so3938713pfn.8
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=l/Z+daJ2NTi5kLv6f+57dvBlJVhAWOkZFBKNfIURaSs=;
        b=u/rYlUKgsyuNyJjAYlaEVOJ86nHAqjHWxxcIGOGhlBbpZ6SiG23WBE+ZkZYeMMc+Ak
         FrcbKvyFtuRp6S5fOyIfv1zF4irARiEPftwTzvSf7Gu6FNWjvX7ljFT9B1sRQTwy68iR
         vihD8v14k2j6VTxiu4eQSLtHikU1cukV4KpnCEQmW+ew4FeoxhukPAHh5UdMlyLqTeT5
         u0cjBYMDWLbCseeNCG+EVTy8lmIyvj0Dq/mb1cdBvq3bI3ujInK8lO+YB36UXs8gPQTQ
         IrtoXmSVTur8tJFVV7ssVPr3w1SGl3lALWZYTQA1/kaihMhlqa3zHD1zmTsrzXWDjTzc
         1oZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l/Z+daJ2NTi5kLv6f+57dvBlJVhAWOkZFBKNfIURaSs=;
        b=knxjLY+ii3TwePnnjvzY1rD2UGy+W+80mSVyevHQ4ihSmc8psVf0U6R+ly4f1zUBv5
         iTWHrETx0Ni4Lo8nkMxdNFGGdz/xppyl0ohrfa7XDfvoFO4iZ6cGixVk0zHGeyutAnGW
         PaSWVex8Ixz5uFgHsJNJlYCzZ6dQY/JW39ruQL33+elGfY1RtHlHnfR8gQzEyi0T5Jno
         dU1hPaRz/0LCOaMyYnkr5bLgEWZbHt0qMSUIbTK+9mR77esifcFs4I6mrhAq3w10dhni
         Uc5mXJa6kREwflfxm8TBuk3Q3R6kycA7+ECqLIThGXdFCxqjKQT8yhsykPpE+dS2kGsr
         aIYA==
X-Gm-Message-State: AOAM53325yJFq81FSoAYPrsKInz2mSSeiLJHDXeZwMUq0941HJeAPusY
        ndnnhcuAeKpLithaOfc9FOA=
X-Google-Smtp-Source: ABdhPJxaZDHYavh8pFjOiDFgPoBTjOVYqfnQpyCeWZSlLeUAa2JSzyKUMi7fel1EUIt36gG65Yk1qg==
X-Received: by 2002:a65:51c8:: with SMTP id i8mr193872pgq.142.1601057588984;
        Fri, 25 Sep 2020 11:13:08 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id i126sm3322337pfc.48.2020.09.25.11.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 11:13:07 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, xiyou.wangcong@gmail.com
Subject: [PATCH net 1/3] net: core: add __netdev_upper_dev_unlink()
Date:   Fri, 25 Sep 2020 18:13:02 +0000
Message-Id: <20200925181302.25146-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netdev_upper_dev_unlink() has to work differently according to flags.
This idea is the same with __netdev_upper_dev_link().

In the following patches, new flags will be added.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/core/dev.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 266073e300b5..b7b3d6e15cda 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7762,16 +7762,8 @@ int netdev_master_upper_dev_link(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_master_upper_dev_link);
 
-/**
- * netdev_upper_dev_unlink - Removes a link to upper device
- * @dev: device
- * @upper_dev: new upper device
- *
- * Removes a link to device which is upper to this one. The caller must hold
- * the RTNL lock.
- */
-void netdev_upper_dev_unlink(struct net_device *dev,
-			     struct net_device *upper_dev)
+static void __netdev_upper_dev_unlink(struct net_device *dev,
+				      struct net_device *upper_dev)
 {
 	struct netdev_notifier_changeupper_info changeupper_info = {
 		.info = {
@@ -7800,6 +7792,20 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 	__netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level,
 				    NULL);
 }
+
+/**
+ * netdev_upper_dev_unlink - Removes a link to upper device
+ * @dev: device
+ * @upper_dev: new upper device
+ *
+ * Removes a link to device which is upper to this one. The caller must hold
+ * the RTNL lock.
+ */
+void netdev_upper_dev_unlink(struct net_device *dev,
+			     struct net_device *upper_dev)
+{
+	__netdev_upper_dev_unlink(dev, upper_dev);
+}
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
 static void __netdev_adjacent_dev_set(struct net_device *upper_dev,
-- 
2.17.1

