Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0FF91089
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfHQNa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:30:26 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42395 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbfHQNaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:30:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9BF4F206E;
        Sat, 17 Aug 2019 09:30:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:30:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GYIlmiDtgVF1QkCDCnL0kvlN+CShcy2T70Cqm4xyyhQ=; b=aj760Psb
        g9fM3JmY7hgwhY/S3I7GFkA2AWNzl3o2crDmwKJhgcFTKUS8f/BThYsqY1ZneZp2
        wtSYi1nm+fggwEGk4ge+8CrPcoDpSiHrpKAsLrkUqQNpNny6LqMUTCRvRG7vdcJw
        /q6kiVM9s6uMLcuE3Q5eNenmhi/EzQrGRom/mm/r8/Pa7BnSRhGhrohSd36hyaXV
        lZR4tEYKWn+Ouqg67DHxnxkiR8vi8TsDT9VruCF6CxG67UhoasKA/+cd54Ao7+1t
        QezSiSGfNt4N7kRNN8TyKUKXrsmoV4FaO3GZxBgKc0fcOwSQkcM0GyY9XtTLkH4K
        BUBAgsEloKoyJQ==
X-ME-Sender: <xms:cAFYXXb07ZRc7KIn2yH4579YCMXW3gPg45H0OZjfQ8h8NxgjnZBUyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuffhomhgrihhnpehfvgguohhrrghhohhsthgvugdrohhrghenuc
    fkphepjeelrddujeejrddvuddrudektdenucfrrghrrghmpehmrghilhhfrhhomhepihgu
    ohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:cAFYXT8g4EIjanXljEwprBuZNfEDP7qLPG-ZeKgd2UDRy97WUfeGFA>
    <xmx:cAFYXbQsF_vdKIG3m0kEAFReaVhM-oHcBBfgMQnneF_4xMbyMa3HLw>
    <xmx:cAFYXYBlCUEqMfK7qPjcF8DshuxvSqWp05i8Wn-rRhRR6i6flEqZig>
    <xmx:cAFYXc1VmEwZS0KBDrAAS6AF3CifnTB7V26htabOXKcMpgBWw0HNYg>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id C5CAF80060;
        Sat, 17 Aug 2019 09:30:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 03/16] drop_monitor: Add basic infrastructure for hardware drops
Date:   Sat, 17 Aug 2019 16:28:12 +0300
Message-Id: <20190817132825.29790-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Export a function that can be invoked in order to report packets that
were dropped by the underlying hardware along with metadata.

Subsequent patches will add support for the different alert modes.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 MAINTAINERS                |  1 +
 include/net/drop_monitor.h | 33 +++++++++++++++++++++++++++++++++
 net/core/drop_monitor.c    | 28 ++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)
 create mode 100644 include/net/drop_monitor.h

diff --git a/MAINTAINERS b/MAINTAINERS
index fd9ab61c2670..96d3e60697f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11156,6 +11156,7 @@ S:	Maintained
 W:	https://fedorahosted.org/dropwatch/
 F:	net/core/drop_monitor.c
 F:	include/uapi/linux/net_dropmon.h
+F:	include/net/drop_monitor.h
 
 NETWORKING DRIVERS
 M:	"David S. Miller" <davem@davemloft.net>
diff --git a/include/net/drop_monitor.h b/include/net/drop_monitor.h
new file mode 100644
index 000000000000..2ab668461463
--- /dev/null
+++ b/include/net/drop_monitor.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _NET_DROP_MONITOR_H_
+#define _NET_DROP_MONITOR_H_
+
+#include <linux/ktime.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+
+/**
+ * struct net_dm_hw_metadata - Hardware-supplied packet metadata.
+ * @trap_group_name: Hardware trap group name.
+ * @trap_name: Hardware trap name.
+ * @input_dev: Input netdevice.
+ */
+struct net_dm_hw_metadata {
+	const char *trap_group_name;
+	const char *trap_name;
+	struct net_device *input_dev;
+};
+
+#if IS_ENABLED(CONFIG_NET_DROP_MONITOR)
+void net_dm_hw_report(struct sk_buff *skb,
+		      const struct net_dm_hw_metadata *hw_metadata);
+#else
+static inline void
+net_dm_hw_report(struct sk_buff *skb,
+		 const struct net_dm_hw_metadata *hw_metadata)
+{
+}
+#endif
+
+#endif /* _NET_DROP_MONITOR_H_ */
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index aa9147a18329..6020f34728af 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -26,6 +26,7 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <net/drop_monitor.h>
 #include <net/genetlink.h>
 #include <net/netevent.h>
 
@@ -43,6 +44,7 @@
  * netlink alerts
  */
 static int trace_state = TRACE_OFF;
+static bool monitor_hw;
 
 /* net_dm_mutex
  *
@@ -93,6 +95,8 @@ struct net_dm_alert_ops {
 	void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
 				int work, int budget);
 	void (*work_item_func)(struct work_struct *work);
+	void (*hw_probe)(struct sk_buff *skb,
+			 const struct net_dm_hw_metadata *hw_metadata);
 };
 
 struct net_dm_skb_cb {
@@ -267,10 +271,17 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 	rcu_read_unlock();
 }
 
+static void
+net_dm_hw_summary_probe(struct sk_buff *skb,
+			const struct net_dm_hw_metadata *hw_metadata)
+{
+}
+
 static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
 	.kfree_skb_probe	= trace_kfree_skb_hit,
 	.napi_poll_probe	= trace_napi_poll_hit,
 	.work_item_func		= send_dm_alert,
+	.hw_probe		= net_dm_hw_summary_probe,
 };
 
 static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
@@ -482,10 +493,17 @@ static void net_dm_packet_work(struct work_struct *work)
 		net_dm_packet_report(skb);
 }
 
+static void
+net_dm_hw_packet_probe(struct sk_buff *skb,
+		       const struct net_dm_hw_metadata *hw_metadata)
+{
+}
+
 static const struct net_dm_alert_ops net_dm_alert_packet_ops = {
 	.kfree_skb_probe	= net_dm_packet_trace_kfree_skb_hit,
 	.napi_poll_probe	= net_dm_packet_trace_napi_poll_hit,
 	.work_item_func		= net_dm_packet_work,
+	.hw_probe		= net_dm_hw_packet_probe,
 };
 
 static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
@@ -493,6 +511,16 @@ static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
 	[NET_DM_ALERT_MODE_PACKET]	= &net_dm_alert_packet_ops,
 };
 
+void net_dm_hw_report(struct sk_buff *skb,
+		      const struct net_dm_hw_metadata *hw_metadata)
+{
+	if (!monitor_hw)
+		return;
+
+	net_dm_alert_ops_arr[net_dm_alert_mode]->hw_probe(skb, hw_metadata);
+}
+EXPORT_SYMBOL_GPL(net_dm_hw_report);
+
 static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 {
 	const struct net_dm_alert_ops *ops;
-- 
2.21.0

