Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B46114205
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 14:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbfLEN55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 08:57:57 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38829 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbfLEN55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 08:57:57 -0500
Received: by mail-lf1-f66.google.com with SMTP id r14so2572735lfm.5
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 05:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=1bwMcS8ClvkxemokRSe/pWkgFW4Ddoo+cBFPePmCPOo=;
        b=OrVFDqIe6wOWZj2YgL+EkMgLVvLGH7pvvdl48CndPELHiYXODtt0lop4WJSLurubZJ
         PXd+YBAOAqo0+kFXMl8Fv89GacqBjxLrW7WhvlWEY+PX2IRp76YHueSgO4xLNwP89BdI
         8XHfLng9ptjhLtibnF/Ylr2C8fbLgTgbLpTVKRDZ90EJrf2tdfyaYSbqJ3Z5eIqaoNOC
         2r1cLV5Q+An54P5pA6uCS7uPxiet4iGSJgFS1gOSQFp3WbIE3xorNgSySblzrKekfyNt
         R0I2hmxVLyD9IiWguSk0WK2W6RwOtFemjLWqSK+iUuwWPVoBpyFyalFcgyzSdbR8t10q
         bQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1bwMcS8ClvkxemokRSe/pWkgFW4Ddoo+cBFPePmCPOo=;
        b=NAhCeUuGITHPPjD6WoplOEFlzlFjI6rF9gzYZ/pES6RSIhRx5Lco0GBR2qMPJ9Syp8
         AMX8u0tCUPmo63kwQlalSFkcK0k1V4l03EdX9yg+dS/bU9AEB8C8Cc0vy3jEkKnxJnoL
         nFTHfKUxiD5298Zxqmd2U2ntm8c5vbq6+GYmj4x/ikF8enAMc2xJVcinfXsHUz3IsWw6
         GhUXRO/wJP+PHdVMdxZvRXTnG6+UCTQIt5ygjiFgOAqINWxwrhlcCjjXgMX2hkbmTvJO
         FLAi8D0pybz8ats5g1XoMqfXqLs2EEpNaIUWekb8wd7I2KuwDjYPsoAtnUAyl6UnTBLo
         cPyw==
X-Gm-Message-State: APjAAAWpBJqnR2nWuHMKH/Mttp6f3+h24Zz4DDxQDMO4YtjhUBFjBzoe
        hF6ZmMcT0y8GlyrqS92H1U+MQJfv/Mc=
X-Google-Smtp-Source: APXvYqwPu+v+uc95nECvlu7/4eUlnV3GPF9JkMWJ21Swv/S+5Vjok1FnB5zqS1OLmvjaHUNVFWyfpA==
X-Received: by 2002:a19:888:: with SMTP id 130mr5362601lfi.167.1575554274855;
        Thu, 05 Dec 2019 05:57:54 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id i184sm5017129lfd.12.2019.12.05.05.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 05:57:54 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net-sysfs: Call dev_hold always in netdev_queue_add_kobject
Date:   Thu,  5 Dec 2019 15:57:07 +0200
Message-Id: <20191205135707.13221-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

Dev_hold has to be called always in netdev_queue_add_kobject.
Otherwise usage count drops below 0 in case of failure in
kobject_init_and_add.

Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Miller <davem@davemloft.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 net/core/net-sysfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ae3bcb1540ec..5c4624298996 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1459,14 +1459,17 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	struct kobject *kobj = &queue->kobj;
 	int error = 0;
 
+	/* Kobject_put later will trigger netdev_queue_release call
+	 * which decreases dev refcount: Take that reference here
+	 */
+	dev_hold(queue->dev);
+
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 				     "tx-%u", index);
 	if (error)
 		goto err;
 
-	dev_hold(queue->dev);
-
 #ifdef CONFIG_BQL
 	error = sysfs_create_group(kobj, &dql_group);
 	if (error)
-- 
2.17.1

