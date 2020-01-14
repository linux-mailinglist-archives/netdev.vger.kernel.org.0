Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A137213B181
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgANR6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:58:40 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34640 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgANR6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 12:58:36 -0500
Received: by mail-lj1-f193.google.com with SMTP id z22so15420229ljg.1
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 09:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VgjmK8wyUDR97bSwB5wlCT5//+1zzhSgncPfQ/07YPs=;
        b=EHqdpGNsFZ7ObJf1aQWsbmNPtLtTUVAujPEuA6igEdonPJW9E2Vc+C8kCZpEqe9Oc7
         2viQ3gj0ZMAOG6D6c48e/RpEi7EI6cFDl5CQ0MN3i3iN8BdaaokycnwqNg4Px5d2hXEQ
         Ay9+TmZtqJ3OdHnJ74SRMdmJkD2QtBWiVQr7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VgjmK8wyUDR97bSwB5wlCT5//+1zzhSgncPfQ/07YPs=;
        b=T5gL9tCr0NmJqg+18AypAqRi4ACEHZdl5L5PWJ4MLiZpI4Os1H+Q5Tg3JwJ5QgkXgF
         tIeZ0On2mhc4g6j9igu081e4YurmxAY/RkzdO7/mQDsGKsnd5uuv+cMiZ5E2HNbcl5fR
         9W4XpaGiT/ck0RHIAUGasW50I+awU0//uIHF4hzK79bQMxpgNNO6teou0S6xopke1UAh
         rM2KjgL1yaKm+ez7ACiuTlX5w1BvDPjuoNhEPQ5WneY41lN/tvEKqge8amtx7V4u2mLY
         gu92i2hQkbT490p4cCLsAC4zmhD70lnvKLjuhEuVRE0iUUFLEL1VeEWbwRS4l4Ablhwc
         gTWw==
X-Gm-Message-State: APjAAAWiNa/i3JX1e+QzV+zbZn/AfnhCQkca/1f+vnWDye1w0z0FwU9k
        Vz8Y4K/n6iGXuykYnzaNgDZutCGFUzE=
X-Google-Smtp-Source: APXvYqyE4hY9vjq6BIIrkCCTHPYDWo8OPdNCjsuTQhu3Cxe6Als6T4PKVSNdhapw36jqXAglNTvBdA==
X-Received: by 2002:a2e:8188:: with SMTP id e8mr13816621ljg.57.1579024713754;
        Tue, 14 Jan 2020 09:58:33 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a15sm7685655lfi.60.2020.01.14.09.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 09:58:33 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 3/8] net: bridge: vlan: add rtm definitions and dump support
Date:   Tue, 14 Jan 2020 19:56:09 +0200
Message-Id: <20200114175614.17543-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200114175614.17543-1-nikolay@cumulusnetworks.com>
References: <20200114175614.17543-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds vlan rtm definitions:
 - NEWVLAN: to be used for creating vlans, setting options and
   notifications
 - DELVLAN: to be used for deleting vlans
 - GETVLAN: used for dumping vlan information

Dumping vlans which can span multiple messages is added now with basic
information (vid and flags). We use nlmsg_parse() to validate the header
length in order to be able to extend the message with filtering
attributes later.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
v2: use nlmsg_parse() for stricter validation

 include/uapi/linux/if_bridge.h |  28 +++++++
 include/uapi/linux/rtnetlink.h |   7 ++
 net/bridge/br_netlink.c        |   2 +
 net/bridge/br_private.h        |  14 ++++
 net/bridge/br_vlan.c           | 148 +++++++++++++++++++++++++++++++++
 security/selinux/nlmsgtab.c    |   5 +-
 6 files changed, 203 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 4a58e3d7de46..4da04f77d9ee 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -165,6 +165,34 @@ struct bridge_stp_xstats {
 	__u64 tx_tcn;
 };
 
+/* Bridge vlan RTM header */
+struct br_vlan_msg {
+	__u8 family;
+	__u8 reserved1;
+	__u16 reserved2;
+	__u32 ifindex;
+};
+
+/* Bridge vlan RTM attributes
+ * [BRIDGE_VLANDB_ENTRY] = {
+ *     [BRIDGE_VLANDB_ENTRY_INFO]
+ *     ...
+ * }
+ */
+enum {
+	BRIDGE_VLANDB_UNSPEC,
+	BRIDGE_VLANDB_ENTRY,
+	__BRIDGE_VLANDB_MAX,
+};
+#define BRIDGE_VLANDB_MAX (__BRIDGE_VLANDB_MAX - 1)
+
+enum {
+	BRIDGE_VLANDB_ENTRY_UNSPEC,
+	BRIDGE_VLANDB_ENTRY_INFO,
+	__BRIDGE_VLANDB_ENTRY_MAX,
+};
+#define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
+
 /* Bridge multicast database attributes
  * [MDBA_MDB] = {
  *     [MDBA_MDB_ENTRY] = {
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 1418a8362bb7..e06e3e09a1b4 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -171,6 +171,13 @@ enum {
 	RTM_GETLINKPROP,
 #define RTM_GETLINKPROP	RTM_GETLINKPROP
 
+	RTM_NEWVLAN = 112,
+#define RTM_NEWNVLAN	RTM_NEWVLAN
+	RTM_DELVLAN,
+#define RTM_DELVLAN	RTM_DELVLAN
+	RTM_GETVLAN,
+#define RTM_GETVLAN	RTM_GETVLAN
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 40942cece51a..75a7ecf95d7f 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1657,6 +1657,7 @@ int __init br_netlink_init(void)
 	int err;
 
 	br_mdb_init();
+	br_vlan_rtnl_init();
 	rtnl_af_register(&br_af_ops);
 
 	err = rtnl_link_register(&br_link_ops);
@@ -1674,6 +1675,7 @@ int __init br_netlink_init(void)
 void br_netlink_fini(void)
 {
 	br_mdb_uninit();
+	br_vlan_rtnl_uninit();
 	rtnl_af_unregister(&br_af_ops);
 	rtnl_link_unregister(&br_link_ops);
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a7dddc5d7790..1c00411ae938 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -958,6 +958,8 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 void br_vlan_port_event(struct net_bridge_port *p, unsigned long event);
 int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
 			 void *ptr);
+void br_vlan_rtnl_init(void);
+void br_vlan_rtnl_uninit(void);
 
 static inline struct net_bridge_vlan_group *br_vlan_group(
 					const struct net_bridge *br)
@@ -1009,6 +1011,10 @@ static inline u16 br_get_pvid(const struct net_bridge_vlan_group *vg)
 	return vg->pvid;
 }
 
+static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
+{
+	return v->vid == pvid ? v->flags | BRIDGE_VLAN_INFO_PVID : v->flags;
+}
 #else
 static inline bool br_allowed_ingress(const struct net_bridge *br,
 				      struct net_bridge_vlan_group *vg,
@@ -1152,6 +1158,14 @@ static inline int br_vlan_bridge_event(struct net_device *dev,
 {
 	return 0;
 }
+
+static inline void br_vlan_rtnl_init(void)
+{
+}
+
+static inline void br_vlan_rtnl_uninit(void)
+{
+}
 #endif
 
 struct nf_br_ops {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index bb98984cd27d..5f2ac4f244f5 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1505,3 +1505,151 @@ void br_vlan_port_event(struct net_bridge_port *p, unsigned long event)
 		break;
 	}
 }
+
+static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 flags)
+{
+	struct bridge_vlan_info info;
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, BRIDGE_VLANDB_ENTRY);
+	if (!nest)
+		return false;
+
+	memset(&info, 0, sizeof(info));
+	info.vid = vid;
+	if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
+		info.flags |= BRIDGE_VLAN_INFO_UNTAGGED;
+	if (flags & BRIDGE_VLAN_INFO_PVID)
+		info.flags |= BRIDGE_VLAN_INFO_PVID;
+
+	if (nla_put(skb, BRIDGE_VLANDB_ENTRY_INFO, sizeof(info), &info))
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
+static int br_vlan_dump_dev(const struct net_device *dev,
+			    struct sk_buff *skb,
+			    struct netlink_callback *cb)
+{
+	struct net_bridge_vlan_group *vg;
+	int idx = 0, s_idx = cb->args[1];
+	struct nlmsghdr *nlh = NULL;
+	struct net_bridge_vlan *v;
+	struct net_bridge_port *p;
+	struct br_vlan_msg *bvm;
+	struct net_bridge *br;
+	int err = 0;
+	u16 pvid;
+
+	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev))
+		return -EINVAL;
+
+	if (netif_is_bridge_master(dev)) {
+		br = netdev_priv(dev);
+		vg = br_vlan_group_rcu(br);
+		p = NULL;
+	} else {
+		p = br_port_get_rcu(dev);
+		if (WARN_ON(!p))
+			return -EINVAL;
+		vg = nbp_vlan_group_rcu(p);
+		br = p->br;
+	}
+
+	if (!vg)
+		return 0;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			RTM_NEWVLAN, sizeof(*bvm), NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+	bvm = nlmsg_data(nlh);
+	memset(bvm, 0, sizeof(*bvm));
+	bvm->family = PF_BRIDGE;
+	bvm->ifindex = dev->ifindex;
+	pvid = br_get_pvid(vg);
+
+	list_for_each_entry_rcu(v, &vg->vlan_list, vlist) {
+		if (!br_vlan_should_use(v))
+			continue;
+		if (idx < s_idx)
+			goto skip;
+		if (!br_vlan_fill_vids(skb, v->vid, br_vlan_flags(v, pvid))) {
+			err = -EMSGSIZE;
+			break;
+		}
+skip:
+		idx++;
+	}
+	if (err)
+		cb->args[1] = idx;
+	else
+		cb->args[1] = 0;
+	nlmsg_end(skb, nlh);
+
+	return err;
+}
+
+static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	int idx = 0, err = 0, s_idx = cb->args[0];
+	struct net *net = sock_net(skb->sk);
+	struct br_vlan_msg *bvm;
+	struct net_device *dev;
+
+	err = nlmsg_parse(cb->nlh, sizeof(*bvm), NULL, 0, NULL, cb->extack);
+	if (err < 0)
+		return err;
+
+	bvm = nlmsg_data(cb->nlh);
+
+	rcu_read_lock();
+	if (bvm->ifindex) {
+		dev = dev_get_by_index_rcu(net, bvm->ifindex);
+		if (!dev) {
+			err = -ENODEV;
+			goto out_err;
+		}
+		err = br_vlan_dump_dev(dev, skb, cb);
+		if (err && err != -EMSGSIZE)
+			goto out_err;
+	} else {
+		for_each_netdev_rcu(net, dev) {
+			if (idx < s_idx)
+				goto skip;
+
+			err = br_vlan_dump_dev(dev, skb, cb);
+			if (err == -EMSGSIZE)
+				break;
+skip:
+			idx++;
+		}
+	}
+	cb->args[0] = idx;
+	rcu_read_unlock();
+
+	return skb->len;
+
+out_err:
+	rcu_read_unlock();
+
+	return err;
+}
+
+void br_vlan_rtnl_init(void)
+{
+	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETVLAN, NULL,
+			     br_vlan_rtm_dump, 0);
+}
+
+void br_vlan_rtnl_uninit(void)
+{
+	rtnl_unregister(PF_BRIDGE, RTM_GETVLAN);
+}
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index c97fdae8f71b..b69231918686 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -85,6 +85,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_GETNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 	{ RTM_NEWLINKPROP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELLINKPROP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_NEWVLAN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELVLAN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_GETVLAN,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
@@ -168,7 +171,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWLINKPROP + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_NEWVLAN + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.21.0

