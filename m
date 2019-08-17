Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACF59108C
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfHQNah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:30:37 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:51879 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbfHQNah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:30:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9B71F20CD;
        Sat, 17 Aug 2019 09:30:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=qYGa07d7z098zTBvaTX9CdpGhvVuN+EFl7TsvBBAkhI=; b=GWrjyqwn
        4b+OvbbrgiIbIpykg9SsFzYDGq5qhYnMNQ/eCWLecNM1s49Neu5eGn2cMq9lvRfq
        oIM9ZsPWcADlSTGInkCMssJmwuqXuX6zeKw+RhkHMR3S+NNYBdYqETce+gUyJPbb
        H39LiJJYf2P5TqE6W10o3eAojTYyTH82KQX36KfL8EomI5INpAC7uJ9a4vQfDe4J
        yQMH/RCK+fHdDUPD1E3m5ozAS2Xb8UqWC4hZy35CFKrUIWeyPgycS/Pdx7zfZHvU
        oe3BOaMLwa2Sdwna9CXygxezLzaveIIyoEhJpxpom82nyUFEIBOkbCBWwsPQWnLn
        6HSxac05hJwLoQ==
X-ME-Sender: <xms:ewFYXa3TZeu3RIYndZ4vJphKbDDos3xQ3O_Ssquhys-9We3Hd-87Qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:ewFYXWbAYtEhRkJSZwubTqIociVC3cT9hsOVwedd8WCYhqp4nxPt3Q>
    <xmx:ewFYXa74wPucqi0hxB-bct-ej79cjt8SGhrZYblLw_USk4exaeM5Ew>
    <xmx:ewFYXViVDfkPQ9z6QXFyxF0X_VaDK3oG99ZHEb-a37NDx5tsUPQ0Bw>
    <xmx:ewFYXeAcRrxLynNcwB1RUoaa4hPS7to-UTy_rIuvXase7oxE7hG6kw>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id AAFD280059;
        Sat, 17 Aug 2019 09:30:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 06/16] drop_monitor: Add support for summary alert mode for hardware drops
Date:   Sat, 17 Aug 2019 16:28:15 +0300
Message-Id: <20190817132825.29790-7-idosch@idosch.org>
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

In summary alert mode a notification is sent with a list of recent drop
reasons and a count of how many packets were dropped due to this reason.

To avoid expensive operations in the context in which packets are
dropped, each CPU holds an array whose number of entries is the maximum
number of drop reasons that can be encoded in the netlink notification.
Each entry stores the drop reason and a count. When a packet is dropped
the array is traversed and a new entry is created or the count of an
existing entry is incremented.

Later, in process context, the array is replaced with a newly allocated
copy and the old array is encoded in a netlink notification. To avoid
breaking user space, the notification includes the ancillary header,
which is 'struct net_dm_alert_msg' with number of entries set to '0'.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |   3 +
 net/core/drop_monitor.c          | 195 ++++++++++++++++++++++++++++++-
 2 files changed, 196 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 9f8fb1bb4aa4..3bddc9ec978c 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -87,6 +87,9 @@ enum net_dm_attr {
 	NET_DM_ATTR_ORIGIN,			/* u16 */
 	NET_DM_ATTR_HW_TRAP_GROUP_NAME,		/* string */
 	NET_DM_ATTR_HW_TRAP_NAME,		/* string */
+	NET_DM_ATTR_HW_ENTRIES,			/* nested */
+	NET_DM_ATTR_HW_ENTRY,			/* nested */
+	NET_DM_ATTR_HW_TRAP_COUNT,		/* u32 */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 5a950b5af8fd..807c79d606aa 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -58,9 +58,26 @@ struct net_dm_stats {
 	struct u64_stats_sync syncp;
 };
 
+#define NET_DM_MAX_HW_TRAP_NAME_LEN 40
+
+struct net_dm_hw_entry {
+	char trap_name[NET_DM_MAX_HW_TRAP_NAME_LEN];
+	u32 count;
+};
+
+struct net_dm_hw_entries {
+	u32 num_entries;
+	struct net_dm_hw_entry entries[0];
+};
+
 struct per_cpu_dm_data {
-	spinlock_t		lock;	/* Protects 'skb' and 'send_timer' */
-	struct sk_buff		*skb;
+	spinlock_t		lock;	/* Protects 'skb', 'hw_entries' and
+					 * 'send_timer'
+					 */
+	union {
+		struct sk_buff			*skb;
+		struct net_dm_hw_entries	*hw_entries;
+	};
 	struct sk_buff_head	drop_queue;
 	struct work_struct	dm_alert_work;
 	struct timer_list	send_timer;
@@ -275,16 +292,189 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 	rcu_read_unlock();
 }
 
+static struct net_dm_hw_entries *
+net_dm_hw_reset_per_cpu_data(struct per_cpu_dm_data *hw_data)
+{
+	struct net_dm_hw_entries *hw_entries;
+	unsigned long flags;
+
+	hw_entries = kzalloc(struct_size(hw_entries, entries, dm_hit_limit),
+			     GFP_KERNEL);
+	if (!hw_entries) {
+		/* If the memory allocation failed, we try to perform another
+		 * allocation in 1/10 second. Otherwise, the probe function
+		 * will constantly bail out.
+		 */
+		mod_timer(&hw_data->send_timer, jiffies + HZ / 10);
+	}
+
+	spin_lock_irqsave(&hw_data->lock, flags);
+	swap(hw_data->hw_entries, hw_entries);
+	spin_unlock_irqrestore(&hw_data->lock, flags);
+
+	return hw_entries;
+}
+
+static int net_dm_hw_entry_put(struct sk_buff *msg,
+			       const struct net_dm_hw_entry *hw_entry)
+{
+	struct nlattr *attr;
+
+	attr = nla_nest_start(msg, NET_DM_ATTR_HW_ENTRY);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (nla_put_string(msg, NET_DM_ATTR_HW_TRAP_NAME, hw_entry->trap_name))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NET_DM_ATTR_HW_TRAP_COUNT, hw_entry->count))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, attr);
+	return -EMSGSIZE;
+}
+
+static int net_dm_hw_entries_put(struct sk_buff *msg,
+				 const struct net_dm_hw_entries *hw_entries)
+{
+	struct nlattr *attr;
+	int i;
+
+	attr = nla_nest_start(msg, NET_DM_ATTR_HW_ENTRIES);
+	if (!attr)
+		return -EMSGSIZE;
+
+	for (i = 0; i < hw_entries->num_entries; i++) {
+		int rc;
+
+		rc = net_dm_hw_entry_put(msg, &hw_entries->entries[i]);
+		if (rc)
+			goto nla_put_failure;
+	}
+
+	nla_nest_end(msg, attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, attr);
+	return -EMSGSIZE;
+}
+
+static int
+net_dm_hw_summary_report_fill(struct sk_buff *msg,
+			      const struct net_dm_hw_entries *hw_entries)
+{
+	struct net_dm_alert_msg anc_hdr = { 0 };
+	void *hdr;
+	int rc;
+
+	hdr = genlmsg_put(msg, 0, 0, &net_drop_monitor_family, 0,
+			  NET_DM_CMD_ALERT);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	/* We need to put the ancillary header in order not to break user
+	 * space.
+	 */
+	if (nla_put(msg, NLA_UNSPEC, sizeof(anc_hdr), &anc_hdr))
+		goto nla_put_failure;
+
+	rc = net_dm_hw_entries_put(msg, hw_entries);
+	if (rc)
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static void net_dm_hw_summary_work(struct work_struct *work)
+{
+	struct net_dm_hw_entries *hw_entries;
+	struct per_cpu_dm_data *hw_data;
+	struct sk_buff *msg;
+	int rc;
+
+	hw_data = container_of(work, struct per_cpu_dm_data, dm_alert_work);
+
+	hw_entries = net_dm_hw_reset_per_cpu_data(hw_data);
+	if (!hw_entries)
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		goto out;
+
+	rc = net_dm_hw_summary_report_fill(msg, hw_entries);
+	if (rc) {
+		nlmsg_free(msg);
+		goto out;
+	}
+
+	genlmsg_multicast(&net_drop_monitor_family, msg, 0, 0, GFP_KERNEL);
+
+out:
+	kfree(hw_entries);
+}
+
 static void
 net_dm_hw_summary_probe(struct sk_buff *skb,
 			const struct net_dm_hw_metadata *hw_metadata)
 {
+	struct net_dm_hw_entries *hw_entries;
+	struct net_dm_hw_entry *hw_entry;
+	struct per_cpu_dm_data *hw_data;
+	unsigned long flags;
+	int i;
+
+	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
+	spin_lock_irqsave(&hw_data->lock, flags);
+	hw_entries = hw_data->hw_entries;
+
+	if (!hw_entries)
+		goto out;
+
+	for (i = 0; i < hw_entries->num_entries; i++) {
+		hw_entry = &hw_entries->entries[i];
+		if (!strncmp(hw_entry->trap_name, hw_metadata->trap_name,
+			     NET_DM_MAX_HW_TRAP_NAME_LEN - 1)) {
+			hw_entry->count++;
+			goto out;
+		}
+	}
+	if (WARN_ON_ONCE(hw_entries->num_entries == dm_hit_limit))
+		goto out;
+
+	hw_entry = &hw_entries->entries[hw_entries->num_entries];
+	strlcpy(hw_entry->trap_name, hw_metadata->trap_name,
+		NET_DM_MAX_HW_TRAP_NAME_LEN - 1);
+	hw_entry->count = 1;
+	hw_entries->num_entries++;
+
+	if (!timer_pending(&hw_data->send_timer)) {
+		hw_data->send_timer.expires = jiffies + dm_delay * HZ;
+		add_timer(&hw_data->send_timer);
+	}
+
+out:
+	spin_unlock_irqrestore(&hw_data->lock, flags);
 }
 
 static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
 	.kfree_skb_probe	= trace_kfree_skb_hit,
 	.napi_poll_probe	= trace_napi_poll_hit,
 	.work_item_func		= send_dm_alert,
+	.hw_work_item_func	= net_dm_hw_summary_work,
 	.hw_probe		= net_dm_hw_summary_probe,
 };
 
@@ -1309,6 +1499,7 @@ static void net_dm_hw_cpu_data_fini(int cpu)
 	struct per_cpu_dm_data *hw_data;
 
 	hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+	kfree(hw_data->hw_entries);
 	__net_dm_cpu_data_fini(hw_data);
 }
 
-- 
2.21.0

