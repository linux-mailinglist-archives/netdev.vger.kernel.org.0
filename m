Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA07A181062
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 07:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgCKGGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 02:06:35 -0400
Received: from condef-01.nifty.com ([202.248.20.66]:23432 "EHLO
        condef-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKGGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 02:06:35 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2020 02:06:34 EDT
Received: from conuserg-08.nifty.com ([10.126.8.71])by condef-01.nifty.com with ESMTP id 02B5pqou014965
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 14:51:52 +0900
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 02B5nsuH014142;
        Wed, 11 Mar 2020 14:49:55 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 02B5nsuH014142
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1583905796;
        bh=5Jc1qPKc/LTqMzP9XLekz19E/apKl3IBuLq7/cwJG8I=;
        h=From:To:Cc:Subject:Date:From;
        b=qKIo3vnRkKNIGbUBiV1sBODVoHVXID/IcuZaQCzQHn1gLgiWbpcJkF8Df6wTAsw00
         p+IP9mJLMw3dr4JEaNZflZpCVdkfONLcYtpDVDyxP/1dAVZ+Of2GWyFA09Zul4/bU4
         QMOYyjoqJ4qNJzm6y1l+r75G3hT9PG/gtEbXInWt44kj0i/fPiz2GUGlqA98eeGYsA
         WKB8/wUBbIphBZ3sMuZx5eRhwGHYYM6oF6LVVq6MUdBOJrvj8aSjV8LcCyaLUNiDR0
         hzpwV6VAGHAtiAULkZZniYp0lHm/VrlOZilt3wE4HxIzRVW72+szP5/jEICp1wNKlU
         oUcN6SCGIMzOg==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Cc:     Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] net: drop_monitor: make drop_monitor built-in
Date:   Wed, 11 Mar 2020 14:49:53 +0900
Message-Id: <20200311054953.11956-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In net/Kconfig, NET_DEVLINK implies NET_DROP_MONITOR.

The original behavior of the 'imply' keyword prevents NET_DROP_MONITOR
from being 'm' when NET_DEVLINK=y.

With the planned Kconfig change that relaxes the 'imply', the
combination of NET_DEVLINK=y and NET_DROP_MONITOR=m would be allowed,
causing a link error of vmlinux.

As far as I see the mainline code, NET_DROP_MONITOR=m does not provide
any useful case.

The call-site of net_dm_hw_report() only exists in net/core/devlink.c,
which is always built-in since NET_DEVLINK is a bool type option.

So, NET_DROP_MONITOR=m causes a build error, or creates an unused
module at best.

Make NET_DROP_MONITOR a bool option, and remove the module exit code.
I also unexported net_dm_hw_report because I see no other call-site
in upstream.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

This build error was reported in linux-next.
https://lkml.org/lkml/2020/3/10/1936

A less invasive change would be to change
IS_ENABLED(CONFIG_NET_DROP_MONITOR) in include/net/drop_monitor.h
to IS_REACHABLE(CONFIG_NET_DROP_MONITOR).

If you want to keep this modular, it is fine too.

If this patch is acceptable,
I'd like to get Ack from the maintainers,
and insert this patch before my Kconfig change.


 include/net/drop_monitor.h |  2 +-
 net/Kconfig                |  2 +-
 net/core/drop_monitor.c    | 56 ++------------------------------------
 3 files changed, 4 insertions(+), 56 deletions(-)

diff --git a/include/net/drop_monitor.h b/include/net/drop_monitor.h
index 2ab668461463..aa775f243b61 100644
--- a/include/net/drop_monitor.h
+++ b/include/net/drop_monitor.h
@@ -19,7 +19,7 @@ struct net_dm_hw_metadata {
 	struct net_device *input_dev;
 };
 
-#if IS_ENABLED(CONFIG_NET_DROP_MONITOR)
+#ifdef CONFIG_NET_DROP_MONITOR
 void net_dm_hw_report(struct sk_buff *skb,
 		      const struct net_dm_hw_metadata *hw_metadata);
 #else
diff --git a/net/Kconfig b/net/Kconfig
index 2eeb0e55f7c9..6ad5d3e95be6 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -347,7 +347,7 @@ config NET_PKTGEN
 	  module will be called pktgen.
 
 config NET_DROP_MONITOR
-	tristate "Network packet drop alerting service"
+	bool "Network packet drop alerting service"
 	depends on INET && TRACEPOINTS
 	---help---
 	  This feature provides an alerting service to userspace in the
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 31700e0c3928..25466b7a0176 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -13,6 +13,7 @@
 #include <linux/if_arp.h>
 #include <linux/inetdevice.h>
 #include <linux/inet.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/netpoll.h>
 #include <linux/sched.h>
@@ -25,7 +26,6 @@
 #include <linux/timer.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <net/drop_monitor.h>
 #include <net/genetlink.h>
 #include <net/netevent.h>
@@ -962,7 +962,6 @@ void net_dm_hw_report(struct sk_buff *skb,
 out:
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(net_dm_hw_report);
 
 static int net_dm_hw_monitor_start(struct netlink_ext_ack *extack)
 {
@@ -1581,11 +1580,6 @@ static void __net_dm_cpu_data_init(struct per_cpu_dm_data *data)
 	u64_stats_init(&data->stats.syncp);
 }
 
-static void __net_dm_cpu_data_fini(struct per_cpu_dm_data *data)
-{
-	WARN_ON(!skb_queue_empty(&data->drop_queue));
-}
-
 static void net_dm_cpu_data_init(int cpu)
 {
 	struct per_cpu_dm_data *data;
@@ -1594,18 +1588,6 @@ static void net_dm_cpu_data_init(int cpu)
 	__net_dm_cpu_data_init(data);
 }
 
-static void net_dm_cpu_data_fini(int cpu)
-{
-	struct per_cpu_dm_data *data;
-
-	data = &per_cpu(dm_cpu_data, cpu);
-	/* At this point, we should have exclusive access
-	 * to this struct and can free the skb inside it.
-	 */
-	consume_skb(data->skb);
-	__net_dm_cpu_data_fini(data);
-}
-
 static void net_dm_hw_cpu_data_init(int cpu)
 {
 	struct per_cpu_dm_data *hw_data;
@@ -1614,15 +1596,6 @@ static void net_dm_hw_cpu_data_init(int cpu)
 	__net_dm_cpu_data_init(hw_data);
 }
 
-static void net_dm_hw_cpu_data_fini(int cpu)
-{
-	struct per_cpu_dm_data *hw_data;
-
-	hw_data = &per_cpu(dm_hw_cpu_data, cpu);
-	kfree(hw_data->hw_entries);
-	__net_dm_cpu_data_fini(hw_data);
-}
-
 static int __init init_net_drop_monitor(void)
 {
 	int cpu, rc;
@@ -1661,29 +1634,4 @@ static int __init init_net_drop_monitor(void)
 out:
 	return rc;
 }
-
-static void exit_net_drop_monitor(void)
-{
-	int cpu;
-
-	BUG_ON(unregister_netdevice_notifier(&dropmon_net_notifier));
-
-	/*
-	 * Because of the module_get/put we do in the trace state change path
-	 * we are guarnateed not to have any current users when we get here
-	 */
-
-	for_each_possible_cpu(cpu) {
-		net_dm_hw_cpu_data_fini(cpu);
-		net_dm_cpu_data_fini(cpu);
-	}
-
-	BUG_ON(genl_unregister_family(&net_drop_monitor_family));
-}
-
-module_init(init_net_drop_monitor);
-module_exit(exit_net_drop_monitor);
-
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Neil Horman <nhorman@tuxdriver.com>");
-MODULE_ALIAS_GENL_FAMILY("NET_DM");
+device_initcall(init_net_drop_monitor);
-- 
2.17.1

