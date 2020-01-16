Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9E513F873
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389129AbgAPTSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:18:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732137AbgAPQyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 565EC205F4;
        Thu, 16 Jan 2020 16:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193672;
        bh=LomtqtWcTWq5Lnolg/EZTmS/WvghW41OIZLXueRo6W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcYNDTHQ1UVZuoRaDqbn4WjKFYAAw5z22RQiSizjI9EOgTGuNR1f1qg88GvEGZd18
         4lTtzACsyuF2jYFOsxdWunI8ND2caXd6PbSKm6BzPbx35bfZyTbOIJfXg9dWBN+AJF
         hbv8dqTqqDRPY1BamBS9/yXytZbqgN1s6Bvpa2QI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        Hulk Robot <hulkci@huawei.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 197/205] net-sysfs: Call dev_hold always in netdev_queue_add_kobject
Date:   Thu, 16 Jan 2020 11:42:52 -0500
Message-Id: <20200116164300.6705-197-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

[ Upstream commit e0b60903b434a7ee21ba8d8659f207ed84101e89 ]

Dev_hold has to be called always in netdev_queue_add_kobject.
Otherwise usage count drops below 0 in case of failure in
kobject_init_and_add.

Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Miller <davem@davemloft.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index b4db68e5caa9..4c826b8bf9b1 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1462,14 +1462,17 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
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
2.20.1

