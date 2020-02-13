Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6558C15B913
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 06:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgBMFc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 00:32:59 -0500
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:18731 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgBMFc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 00:32:59 -0500
X-Greylist: delayed 682 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2020 00:32:58 EST
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [192.168.231.130]) by mgwkm01.jp.fujitsu.com with smtp
         id 4e58_21ef_72859388_b07b_4858_b1a2_2c5be16b76c5;
        Thu, 13 Feb 2020 14:21:34 +0900
Received: from durio.utsfd.cs.fujitsu.co.jp (durio.utsfd.cs.fujitsu.co.jp [10.24.20.112])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 21C3FAC00BE
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 14:21:33 +0900 (JST)
Received: by durio.utsfd.cs.fujitsu.co.jp (Postfix, from userid 1008)
        id C932A1FF2A4; Thu, 13 Feb 2020 14:21:32 +0900 (JST)
From:   Keiya Nobuta <nobuta.keiya@fujitsu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Keiya Nobuta <nobuta.keiya@fujitsu.com>
Subject: [PATCH] net: sched: Add sysfs_notify for /sys/class/net/*/carrier
Date:   Thu, 13 Feb 2020 14:21:11 +0900
Message-Id: <20200213052111.19595-1-nobuta.keiya@fujitsu.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes /sys/class/<iface>/carrier pollable and allows
application to monitor current physical link state changes.

Signed-off-by: Keiya Nobuta <nobuta.keiya@fujitsu.com>
---
 net/sched/sch_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6c9595f..67e4190 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -493,6 +493,7 @@ void netif_carrier_on(struct net_device *dev)
 		linkwatch_fire_event(dev);
 		if (netif_running(dev))
 			__netdev_watchdog_up(dev);
+		sysfs_notify(&dev->dev.kobj, NULL, "carrier");
 	}
 }
 EXPORT_SYMBOL(netif_carrier_on);
@@ -510,6 +511,7 @@ void netif_carrier_off(struct net_device *dev)
 			return;
 		atomic_inc(&dev->carrier_down_count);
 		linkwatch_fire_event(dev);
+		sysfs_notify(&dev->dev.kobj, NULL, "carrier");
 	}
 }
 EXPORT_SYMBOL(netif_carrier_off);
-- 
2.7.4

