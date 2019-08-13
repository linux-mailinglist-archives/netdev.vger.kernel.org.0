Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA13C8B1A3
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfHMHz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:55:57 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:58221 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725981AbfHMHz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:55:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B68F4310A;
        Tue, 13 Aug 2019 03:55:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=jWHT+X7OcdTMjivyhzA+5BR+l2Z6/szjRWb3h+88Yf0=; b=mdw2rZiV
        GYOa0ePLdcdCqu1H6bp+sqMcXDGqoElIV2qm3FPp+fyJynniFjWbcbjQaLa+GYoK
        r7gD3uiK8BpvKdZJyPaz5g5WyobKuXWlyNOHsDC/OAJ0npvcYjUudlWiQsTXT+yb
        Yjh3FeWGARyRo/95f2YQFzNr3pa6wA+zjcJ5lD6KTfKLfqCObiCG0klJAxcRcXEc
        +BUYGoj44Qjd+NYHAv5rMIDx0DRpg5UWFtKuwKgRRP6VWmwr2iUYAt8Gtsx+JGzg
        URun7sqzlowi8Wdu2CgV24lJS280eCvxUA+YvTvav7Yd76Xh29cTpaIqNa5ZN3rH
        Q293RG/oZbhTPA==
X-ME-Sender: <xms:C21SXc4IFVfQacyF_ssi7alkRqVu4hyvUTSq4mY0HgQB0cjsLxE0aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucffohhmrghinhepfhgvughorhgrhhhoshhtvggurdhorhhgne
    cukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:C21SXcjHdSxCNeVC7vIFSUJXZKbugeqNRrqRAOMnJp8Z9EsB_4-bwQ>
    <xmx:C21SXbFPvqCFlxWCm8Sn4VvBr3_aiNSwX86d4lhjJSRleeK0LZGoWQ>
    <xmx:C21SXXVVVuLw7Bx4VOAMhrXrb7tTrJ_Qv7H8WwwTCVnR8OM8DK_igQ>
    <xmx:C21SXVL6tpyEjKeY59yQMDNgsG830AXK8VoALl0mSy9J43l2z4WkUg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E0878005B;
        Tue, 13 Aug 2019 03:55:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 03/14] drop_monitor: Add basic infrastructure for hardware drops
Date:   Tue, 13 Aug 2019 10:53:49 +0300
Message-Id: <20190813075400.11841-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813075400.11841-1-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
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
index e352550a6895..3e567d0b484f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11148,6 +11148,7 @@ S:	Maintained
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

