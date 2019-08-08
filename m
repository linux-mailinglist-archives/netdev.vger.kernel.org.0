Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBCCD862BF
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 15:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732998AbfHHNPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 09:15:23 -0400
Received: from packetmixer.de ([79.140.42.25]:58736 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732643AbfHHNPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 09:15:23 -0400
Received: from kero.packetmixer.de (p200300C5971AA600E0A7EA13A3520353.dip0.t-ipconnect.de [IPv6:2003:c5:971a:a600:e0a7:ea13:a352:353])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 2A00862076;
        Thu,  8 Aug 2019 15:06:22 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/4] batman-adv: Replace usage of strlcpy with strscpy
Date:   Thu,  8 Aug 2019 15:06:17 +0200
Message-Id: <20190808130619.4481-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808130619.4481-1-sw@simonwunderlich.de>
References: <20190808130619.4481-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The strscpy was introduced to fix some API problems around strlcpy. And
checkpatch started to report recently that strlcpy is deprecated and
strscpy is preferred.

The functionality introduced in commit 30035e45753b ("string: provide
strscpy()") improves following points compared to strlcpy:

* it doesn't read from memory beyond (src + size)
* provides an easy way to check for destination buffer overflow
* robust against asynchronous source buffer changes

Since batman-adv doesn't depend on any of the previously mentioned behavior
changes, the usage of strlcpy can simply be replaced by strscpy to silence
checkpatch.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/soft-interface.c | 8 ++++----
 net/batman-adv/sysfs.c          | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index c7a2e77ca1da..a1146cb10919 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -943,10 +943,10 @@ static const struct net_device_ops batadv_netdev_ops = {
 static void batadv_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "B.A.T.M.A.N. advanced", sizeof(info->driver));
-	strlcpy(info->version, BATADV_SOURCE_VERSION, sizeof(info->version));
-	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
-	strlcpy(info->bus_info, "batman", sizeof(info->bus_info));
+	strscpy(info->driver, "B.A.T.M.A.N. advanced", sizeof(info->driver));
+	strscpy(info->version, BATADV_SOURCE_VERSION, sizeof(info->version));
+	strscpy(info->fw_version, "N/A", sizeof(info->fw_version));
+	strscpy(info->bus_info, "batman", sizeof(info->bus_info));
 }
 
 /* Inspired by drivers/net/ethernet/dlink/sundance.c:1702
diff --git a/net/batman-adv/sysfs.c b/net/batman-adv/sysfs.c
index 1efcb97039cd..e5bbc28ed12c 100644
--- a/net/batman-adv/sysfs.c
+++ b/net/batman-adv/sysfs.c
@@ -1070,7 +1070,7 @@ static ssize_t batadv_store_mesh_iface(struct kobject *kobj,
 	dev_hold(net_dev);
 	INIT_WORK(&store_work->work, batadv_store_mesh_iface_work);
 	store_work->net_dev = net_dev;
-	strlcpy(store_work->soft_iface_name, buff,
+	strscpy(store_work->soft_iface_name, buff,
 		sizeof(store_work->soft_iface_name));
 
 	queue_work(batadv_event_workqueue, &store_work->work);
-- 
2.20.1

