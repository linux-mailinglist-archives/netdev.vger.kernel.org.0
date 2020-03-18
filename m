Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77EE189C7E
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCRNEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:04:13 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37882 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgCRNEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:04:13 -0400
Received: by mail-lf1-f65.google.com with SMTP id j11so20291216lfg.4
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 06:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L4yQJluOvc46lNyqqVb7se6AVE/Gv7oCJyL3ecL5y8E=;
        b=hzjFpIyR5P6z3ucc8PqCSysdAnjqk/dzMlwCscfvCsq9DyHXLoXyVDpr6MEMAZ8/lw
         df06enFrsk90Yc1ssz3A6CSJwfofEcyrX038b1vwbxPRNk2Yl+zxOQ8fJ9/g9pyVV3tE
         nxiEm18/XDSfGyy7rO79SD7Ch4gIp3cxnkxjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L4yQJluOvc46lNyqqVb7se6AVE/Gv7oCJyL3ecL5y8E=;
        b=C6bTRuvTQpDM42qZ/veSCZ4HzFo4h47MQDTCyX4mlvojvE9oXCXC64fE4AC1IV3HGq
         yAFxCbWmPzusmSh8QDoVpoDCf9pTGOExe9ApgG9h16EFxj9tFoVGE0IKhqvnw8ADb7c2
         W90bzfQQtBxzh6ROqtihQvkE53D5m06YxZTjNTTuCIHba9VmsGoCG8Vo3k7thDe7p2m/
         6MmfAKJiDxSQlez5pTlKh2SiaP+NTKkmESmhNgsQ0dsHidq4JY0JH7BmlB9vOCd2HM7Z
         HZQSu+OM3PSK05oqmV80j6KstQQqEIeH6GPnB+zXXgz9g8hB1DTWut4OxnbBxL3M4o8E
         gtbg==
X-Gm-Message-State: ANhLgQ1JKRefplikMphnDlkVipmr94HRxi6lvZWojqZp5aQsPg+bu+3m
        tcBZ7qvo1HPr2aIK2BPR6Vqq2VQ6vd4=
X-Google-Smtp-Source: ADFU+vs2xcl+H0IsaDmTdFXuU/T/kxXtS4+mJrhnTe/rONX3bjTjl7o5kxf9K3BwiyEZ4k4zMVSZQA==
X-Received: by 2002:a19:8c4d:: with SMTP id i13mr2942888lfj.42.1584536648083;
        Wed, 18 Mar 2020 06:04:08 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id z21sm4327384ljz.49.2020.03.18.06.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 06:04:07 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next] net: bridge: vlan: include stats in dumps if requested
Date:   Wed, 18 Mar 2020 15:03:25 +0200
Message-Id: <20200318130325.100508-1-nikolay@cumulusnetworks.com>
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
the dump significantly larger. In order to request the stats dump we turn
one of the br_vlan_msg reserved fields into a flag field and check it for:
  - BRIDGE_VLMSG_FLAG_DUMP_STATS
The stats are intentionally nested and put into separate attributes to make
it easier for extending later since we plan to add per-vlan mcast stats,
drop stats and possibly STP stats. This is the last missing piece from the
new vlan API which makes the dumped vlan information complete.

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
 include/uapi/linux/if_bridge.h | 24 ++++++++++++-
 net/bridge/br_vlan.c           | 62 ++++++++++++++++++++++++++++------
 2 files changed, 74 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 54010b49c093..13b76a4e7ed8 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -170,11 +170,13 @@ struct bridge_stp_xstats {
 /* Bridge vlan RTM header */
 struct br_vlan_msg {
 	__u8 family;
-	__u8 reserved1;
+	__u8 flags;
 	__u16 reserved2;
 	__u32 ifindex;
 };
 
+#define BRIDGE_VLMSG_FLAG_DUMP_STATS	(1 << 0) /* Include stats in the dump */
+
 /* Bridge vlan RTM attributes
  * [BRIDGE_VLANDB_ENTRY] = {
  *     [BRIDGE_VLANDB_ENTRY_INFO]
@@ -194,10 +196,30 @@ enum {
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
index 24f524536be4..8fa5f6df36bb 100644
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
+			    u8 bvm_flags)
 {
 	struct net_bridge_vlan *v, *range_start = NULL, *range_end = NULL;
+	bool dump_stats = !!(bvm_flags & BRIDGE_VLMSG_FLAG_DUMP_STATS);
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
@@ -1808,7 +1848,7 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			err = -ENODEV;
 			goto out_err;
 		}
-		err = br_vlan_dump_dev(dev, skb, cb);
+		err = br_vlan_dump_dev(dev, skb, cb, bvm->flags);
 		if (err && err != -EMSGSIZE)
 			goto out_err;
 	} else {
@@ -1816,7 +1856,7 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			if (idx < s_idx)
 				goto skip;
 
-			err = br_vlan_dump_dev(dev, skb, cb);
+			err = br_vlan_dump_dev(dev, skb, cb, bvm->flags);
 			if (err == -EMSGSIZE)
 				break;
 skip:
-- 
2.25.1

