Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E111C18B0FA
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 11:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgCSKOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 06:14:25 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:34154 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgCSKOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 06:14:24 -0400
Received: by mail-lj1-f176.google.com with SMTP id s13so1805695ljm.1
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 03:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NS59NhIO9FklVSlocZ9COaIootU6HPAqwvgvjPc0JZI=;
        b=SqyyKzxUs28gcPCwVh8IeEUD9O5N1DSX9MOVC2q0MCGzGNm3D11USn4YL65M2BM9XT
         cJzx/beasUHcfJw86tj0hhHtHVSKRUoXXapZld6DqjSc4lQw0Q1bulNhkjJkI4qrs6UW
         fupiP3NJ+zsgiTzGQc4YTzvE8hZuu60Bavl1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NS59NhIO9FklVSlocZ9COaIootU6HPAqwvgvjPc0JZI=;
        b=lS25+rFZP+52ptMaWQthTsl2JcWDkqcnSoMgbkH06psNdFcyHMi/WxaLj8uLe4QtDl
         U1g2lVMZT73wU99eg+I9oVtjTO4pQZAHAEklDjEUPnivluXvE6SAvTY0nzVYe+I+sSOo
         z3GmalQdTPH3XdrQZGs5qkM4Ce7C/N3WgU5GxKFp6Gnj37cSLZwonYmsfsw/Qsh6Zbpl
         X37q1KGCtCt+1EH92H2WrYoqPpBZp+5OftprcuA7ArCg6/X1+AlWfmJ0+863NNnjQS8V
         wQ9inIHkGNWQIRBPchjTX9RMel+qFwfouCcIQbLHfVvfcEWFhdjt+MtydvfDaLSYo3z5
         SkjQ==
X-Gm-Message-State: ANhLgQ0kYHUh9BaNkND41QveYYGWDcZcEKO/RowUXiPHEASbjt9x4w1T
        fUtt+7m9QWlXoQjxw3HUff3gmxaYhac=
X-Google-Smtp-Source: ADFU+vvzbrwtgfA7x5AdvT8J/tb7SkV+yGQsbrrF0o+yL8hpzRnXirorSWpuOlNvHfscZMXv7k99DQ==
X-Received: by 2002:a2e:9b44:: with SMTP id o4mr1656826ljj.63.1584612860427;
        Thu, 19 Mar 2020 03:14:20 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r10sm1124678ljk.13.2020.03.19.03.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 03:14:19 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2] net: bridge: vlan: include stats in dumps if requested
Date:   Thu, 19 Mar 2020 12:14:14 +0200
Message-Id: <20200319101414.201391-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for vlan stats to be included when dumping vlan
information. We have to dump them only when explicitly requested (thus the
flag below) because that disables the vlan range compression and will make
the dump significantly larger. In order to request the stats to be
included we add a new dump attribute called BRIDGE_VLANDB_DUMP_FLAGS which
can affect dumps with the following first flag:
  - BRIDGE_VLANDB_DUMPF_STATS
The stats are intentionally nested and put into separate attributes to make
it easier for extending later since we plan to add per-vlan mcast stats,
drop stats and possibly STP stats. This is the last missing piece from the
new vlan API which makes the dumped vlan information complete.

A dump request which should include stats looks like:
 [BRIDGE_VLANDB_DUMP_FLAGS] |= BRIDGE_VLANDB_DUMPF_STATS

A vlandb entry attribute with stats looks like:
 [BRIDGE_VLANDB_ENTRY] = {
     [BRIDGE_VLANDB_ENTRY_STATS] = {
         [BRIDGE_VLANDB_STATS_RX_BYTES]
         [BRIDGE_VLANDB_STATS_RX_PACKETS]
         ...
     }
 }

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
v2: Use a separate dump attribute for the flags instead of a reserved
    field to avoid uapi breakage as noted by DaveM.
    Rebased and retested on the latest net-next.

 include/uapi/linux/if_bridge.h | 30 ++++++++++++++
 net/bridge/br_vlan.c           | 73 ++++++++++++++++++++++++++++------
 2 files changed, 91 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 54010b49c093..9dd1b1fa3291 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -175,6 +175,16 @@ struct br_vlan_msg {
 	__u32 ifindex;
 };
 
+enum {
+	BRIDGE_VLANDB_DUMP_UNSPEC,
+	BRIDGE_VLANDB_DUMP_FLAGS,
+	__BRIDGE_VLANDB_DUMP_MAX,
+};
+#define BRIDGE_VLANDB_DUMP_MAX (__BRIDGE_VLANDB_DUMP_MAX - 1)
+
+/* flags used in BRIDGE_VLANDB_DUMP_FLAGS attribute to affect dumps */
+#define BRIDGE_VLANDB_DUMPF_STATS	(1 << 0) /* Include stats in the dump */
+
 /* Bridge vlan RTM attributes
  * [BRIDGE_VLANDB_ENTRY] = {
  *     [BRIDGE_VLANDB_ENTRY_INFO]
@@ -194,10 +204,30 @@ enum {
 	BRIDGE_VLANDB_ENTRY_RANGE,
 	BRIDGE_VLANDB_ENTRY_STATE,
 	BRIDGE_VLANDB_ENTRY_TUNNEL_ID,
+	BRIDGE_VLANDB_ENTRY_STATS,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
 
+/* [BRIDGE_VLANDB_ENTRY] = {
+ *     [BRIDGE_VLANDB_ENTRY_STATS] = {
+ *         [BRIDGE_VLANDB_STATS_RX_BYTES]
+ *         ...
+ *     }
+ *     ...
+ * }
+ */
+enum {
+	BRIDGE_VLANDB_STATS_UNSPEC,
+	BRIDGE_VLANDB_STATS_RX_BYTES,
+	BRIDGE_VLANDB_STATS_RX_PACKETS,
+	BRIDGE_VLANDB_STATS_TX_BYTES,
+	BRIDGE_VLANDB_STATS_TX_PACKETS,
+	BRIDGE_VLANDB_STATS_PAD,
+	__BRIDGE_VLANDB_STATS_MAX,
+};
+#define BRIDGE_VLANDB_STATS_MAX (__BRIDGE_VLANDB_STATS_MAX - 1)
+
 /* Bridge multicast database attributes
  * [MDBA_MDB] = {
  *     [MDBA_MDB_ENTRY] = {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 24f524536be4..4398f3796665 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1569,10 +1569,41 @@ void br_vlan_port_event(struct net_bridge_port *p, unsigned long event)
 	}
 }
 
+static bool br_vlan_stats_fill(struct sk_buff *skb,
+			       const struct net_bridge_vlan *v)
+{
+	struct br_vlan_stats stats;
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, BRIDGE_VLANDB_ENTRY_STATS);
+	if (!nest)
+		return false;
+
+	br_vlan_get_stats(v, &stats);
+	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_RX_BYTES, stats.rx_bytes,
+			      BRIDGE_VLANDB_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_RX_PACKETS,
+			      stats.rx_packets, BRIDGE_VLANDB_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_TX_BYTES, stats.tx_bytes,
+			      BRIDGE_VLANDB_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_TX_PACKETS,
+			      stats.tx_packets, BRIDGE_VLANDB_STATS_PAD))
+		goto out_err;
+
+	nla_nest_end(skb, nest);
+
+	return true;
+
+out_err:
+	nla_nest_cancel(skb, nest);
+	return false;
+}
+
 /* v_opts is used to dump the options which must be equal in the whole range */
 static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
 			      const struct net_bridge_vlan *v_opts,
-			      u16 flags)
+			      u16 flags,
+			      bool dump_stats)
 {
 	struct bridge_vlan_info info;
 	struct nlattr *nest;
@@ -1596,8 +1627,13 @@ static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
 	    nla_put_u16(skb, BRIDGE_VLANDB_ENTRY_RANGE, vid_range))
 		goto out_err;
 
-	if (v_opts && !br_vlan_opts_fill(skb, v_opts))
-		goto out_err;
+	if (v_opts) {
+		if (!br_vlan_opts_fill(skb, v_opts))
+			goto out_err;
+
+		if (dump_stats && !br_vlan_stats_fill(skb, v_opts))
+			goto out_err;
+	}
 
 	nla_nest_end(skb, nest);
 
@@ -1675,7 +1711,7 @@ void br_vlan_notify(const struct net_bridge *br,
 		goto out_kfree;
 	}
 
-	if (!br_vlan_fill_vids(skb, vid, vid_range, v, flags))
+	if (!br_vlan_fill_vids(skb, vid, vid_range, v, flags, false))
 		goto out_err;
 
 	nlmsg_end(skb, nlh);
@@ -1699,9 +1735,11 @@ bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 
 static int br_vlan_dump_dev(const struct net_device *dev,
 			    struct sk_buff *skb,
-			    struct netlink_callback *cb)
+			    struct netlink_callback *cb,
+			    u32 dump_flags)
 {
 	struct net_bridge_vlan *v, *range_start = NULL, *range_end = NULL;
+	bool dump_stats = !!(dump_flags & BRIDGE_VLANDB_DUMPF_STATS);
 	struct net_bridge_vlan_group *vg;
 	int idx = 0, s_idx = cb->args[1];
 	struct nlmsghdr *nlh = NULL;
@@ -1754,12 +1792,13 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 			continue;
 		}
 
-		if (v->vid == pvid || !br_vlan_can_enter_range(v, range_end)) {
-			u16 flags = br_vlan_flags(range_start, pvid);
+		if (dump_stats || v->vid == pvid ||
+		    !br_vlan_can_enter_range(v, range_end)) {
+			u16 vlan_flags = br_vlan_flags(range_start, pvid);
 
 			if (!br_vlan_fill_vids(skb, range_start->vid,
 					       range_end->vid, range_start,
-					       flags)) {
+					       vlan_flags, dump_stats)) {
 				err = -EMSGSIZE;
 				break;
 			}
@@ -1778,7 +1817,8 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 	 */
 	if (!err && range_start &&
 	    !br_vlan_fill_vids(skb, range_start->vid, range_end->vid,
-			       range_start, br_vlan_flags(range_start, pvid)))
+			       range_start, br_vlan_flags(range_start, pvid),
+			       dump_stats))
 		err = -EMSGSIZE;
 
 	cb->args[1] = err ? idx : 0;
@@ -1788,18 +1828,27 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 	return err;
 }
 
+static const struct nla_policy br_vlan_db_dump_pol[BRIDGE_VLANDB_DUMP_MAX + 1] = {
+	[BRIDGE_VLANDB_DUMP_FLAGS] = { .type = NLA_U32 },
+};
+
 static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct nlattr *dtb[BRIDGE_VLANDB_DUMP_MAX + 1];
 	int idx = 0, err = 0, s_idx = cb->args[0];
 	struct net *net = sock_net(skb->sk);
 	struct br_vlan_msg *bvm;
 	struct net_device *dev;
+	u32 dump_flags = 0;
 
-	err = nlmsg_parse(cb->nlh, sizeof(*bvm), NULL, 0, NULL, cb->extack);
+	err = nlmsg_parse(cb->nlh, sizeof(*bvm), dtb, BRIDGE_VLANDB_DUMP_MAX,
+			  br_vlan_db_dump_pol, cb->extack);
 	if (err < 0)
 		return err;
 
 	bvm = nlmsg_data(cb->nlh);
+	if (dtb[BRIDGE_VLANDB_DUMP_FLAGS])
+		dump_flags = nla_get_u32(dtb[BRIDGE_VLANDB_DUMP_FLAGS]);
 
 	rcu_read_lock();
 	if (bvm->ifindex) {
@@ -1808,7 +1857,7 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			err = -ENODEV;
 			goto out_err;
 		}
-		err = br_vlan_dump_dev(dev, skb, cb);
+		err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
 		if (err && err != -EMSGSIZE)
 			goto out_err;
 	} else {
@@ -1816,7 +1865,7 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			if (idx < s_idx)
 				goto skip;
 
-			err = br_vlan_dump_dev(dev, skb, cb);
+			err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
 			if (err == -EMSGSIZE)
 				break;
 skip:
-- 
2.25.1

