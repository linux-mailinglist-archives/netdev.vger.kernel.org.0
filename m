Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFC41D8D82
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 04:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgESCOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 22:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbgESCOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 22:14:43 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BC8C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:43 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x10so4993471plr.4
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FYNVdxvvM+WGxAVVh8iia7WL2xYg5RlPtbgz4F2VHxA=;
        b=LR6zABHdPsJEFBBNiucvpcOJF6k+qJCZ6yCYbihh1E2WyCvtD4nPbsOdkfLvFt4UAd
         pVPHj0FCXXd6+TLQNy02MLTlQ1LjHEZ5MfoElztAJOdn2qCa4cfK8aoct3cZErj5wU3v
         dTFEFU6T1SOc9kWdzkdQOkFCFR7lPxHkv+qfI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FYNVdxvvM+WGxAVVh8iia7WL2xYg5RlPtbgz4F2VHxA=;
        b=ncJiidYpCg3/ezccgv1XRoxoCWVVsoHuYZgcY3WUSCg3b81kSEIU6/XvwxwQfpu1mV
         7S3nj1p5FBKLHl+KEooR8vW4EPUFzbtpXDB++FOzDkA2pdNpH78jh2wG6AdC+fHYjCOO
         C/615qL0ie6txdsIUUgQwSCJu0tw171q5iUQqYG9oEIsYms+uDBJ3OmQhEDMR2Nb3hl2
         3OCZedzR1UP8byXpXv3b5gdgZS6SpQ5WKAowl0rZZFqoNTjMuyFFKisDIYwCbQJQ+6yA
         3jTOkxGaagCHCHrSZdJb3NnmzVQQ0x5CWsxCCOevYE5JSBnqupCoWTeKug7IkNwXvIDR
         QnyA==
X-Gm-Message-State: AOAM53043/kJMDJ/jqHYaRzXyZy5B34qEMj84sx5lmIG43Wolnz2efud
        h2duWo8XuAlZTTI5nEUe6K1LoQ==
X-Google-Smtp-Source: ABdhPJzDKvg2omy4kobnR8lkZIkCrzC2jrnBTx7clfmWvRt2TnMyxAN9acrRxw0Z8P145RAYwMZh4A==
X-Received: by 2002:a17:90b:438b:: with SMTP id in11mr2518387pjb.139.1589854482577;
        Mon, 18 May 2020 19:14:42 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id 5sm664753pjf.19.2020.05.18.19.14.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 19:14:41 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next 3/6] vxlan: ecmp support for mac fdb entries
Date:   Mon, 18 May 2020 19:14:31 -0700
Message-Id: <1589854474-26854-4-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

Todays vxlan mac fdb entries can point to multiple remote
ips (rdsts) with the sole purpose of replicating
broadcast-multicast and unknown unicast packets to those remote ips.

E-VPN multihoming [1,2,3] requires bridged vxlan traffic to be
load balanced to remote switches (vteps) belonging to the
same multi-homed ethernet segment (E-VPN multihoming is analogous
to multi-homed LAG implementations, but with the inter-switch
peerlink replaced with a vxlan tunnel). In other words it needs
support for mac ecmp. Furthermore, for faster convergence, E-VPN
multihoming needs the ability to update fdb ecmp nexthops independent
of the fdb entries.

New route nexthop API is perfect for this usecase.
This patch extends the vxlan fdb code to take a nexthop id
pointing to an ecmp nexthop group.

Changes include:
- New NDA_NH_ID attribute for fdbs
- Use the newly added fdb nexthop groups
- makes vxlan rdsts and nexthop handling code mutually
  exclusive
- since this is a new use-case and the requirement is for ecmp
nexthop groups, the fdb add and update path checks that the
nexthop is really an ecmp nexthop group. This check can be relaxed
in the future, if we want to introduce replication fdb nexthop groups
and allow its use in lieu of current rdst lists.
- fdb update requests with nexthop id's only allowed for existing
fdb's that have nexthop id's
- learning will not override an existing fdb entry with nexthop
group
- I have wrapped the switchdev offload code around the presence of
rdst
- I think there is scope for simplyfing vxlan_xmit_one: Will see
what I can do before the non-RFC version

[1] E-VPN RFC https://tools.ietf.org/html/rfc7432
[2] E-VPN with vxlan https://tools.ietf.org/html/rfc8365
[3] http://vger.kernel.org/lpc_net2018_talks/scaling_bridge_fdb_database_slidesV3.pdf

Includes a nexthop_path_fdb_result NULL check crash fix from Nikolay Aleksandrov

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/vxlan.c            | 285 ++++++++++++++++++++++++++++++++---------
 include/net/nexthop.h          |   2 +
 include/net/vxlan.h            |  24 ++++
 include/uapi/linux/neighbour.h |   1 +
 4 files changed, 255 insertions(+), 57 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a5b415f..01933e9 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -26,6 +26,7 @@
 #include <net/netns/generic.h>
 #include <net/tun_proto.h>
 #include <net/vxlan.h>
+#include <net/nexthop.h>
 
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ip6_tunnel.h>
@@ -78,6 +79,8 @@ struct vxlan_fdb {
 	u16		  state;	/* see ndm_state */
 	__be32		  vni;
 	u16		  flags;	/* see ndm_flags and below */
+	struct list_head  nh_list;
+	struct nexthop __rcu *nh;
 };
 
 #define NTF_VXLAN_ADDED_BY_USER 0x100
@@ -174,11 +177,15 @@ static inline struct hlist_head *vs_head(struct net *net, __be16 port)
  */
 static inline struct vxlan_rdst *first_remote_rcu(struct vxlan_fdb *fdb)
 {
+	if (rcu_access_pointer(fdb->nh))
+		return NULL;
 	return list_entry_rcu(fdb->remotes.next, struct vxlan_rdst, list);
 }
 
 static inline struct vxlan_rdst *first_remote_rtnl(struct vxlan_fdb *fdb)
 {
+	if (rcu_access_pointer(fdb->nh))
+		return NULL;
 	return list_first_entry(&fdb->remotes, struct vxlan_rdst, list);
 }
 
@@ -251,9 +258,10 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 {
 	unsigned long now = jiffies;
 	struct nda_cacheinfo ci;
+	bool send_ip, send_eth;
 	struct nlmsghdr *nlh;
+	struct nexthop *nh;
 	struct ndmsg *ndm;
-	bool send_ip, send_eth;
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
 	if (nlh == NULL)
@@ -265,15 +273,19 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 	send_eth = send_ip = true;
 
 	if (type == RTM_GETNEIGH) {
-		send_ip = !vxlan_addr_any(&rdst->remote_ip);
+		if (rdst) {
+			send_ip = !vxlan_addr_any(&rdst->remote_ip);
+			ndm->ndm_family = send_ip ? rdst->remote_ip.sa.sa_family : AF_INET;
+		} else if (rcu_access_pointer(fdb->nh)) {
+			ndm->ndm_family = nexthop_get_family(rcu_dereference(fdb->nh));
+		}
 		send_eth = !is_zero_ether_addr(fdb->eth_addr);
-		ndm->ndm_family = send_ip ? rdst->remote_ip.sa.sa_family : AF_INET;
 	} else
 		ndm->ndm_family	= AF_BRIDGE;
 	ndm->ndm_state = fdb->state;
 	ndm->ndm_ifindex = vxlan->dev->ifindex;
 	ndm->ndm_flags = fdb->flags;
-	if (rdst->offloaded)
+	if (rdst && rdst->offloaded)
 		ndm->ndm_flags |= NTF_OFFLOADED;
 	ndm->ndm_type = RTN_UNICAST;
 
@@ -284,23 +296,31 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 
 	if (send_eth && nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->eth_addr))
 		goto nla_put_failure;
+	nh = rcu_dereference(fdb->nh);
+	if (nh) {
+		if (nla_put_u32(skb, NDA_NH_ID, nh->id))
+			goto nla_put_failure;
+	} else if (rdst) {
+		if (send_ip && vxlan_nla_put_addr(skb, NDA_DST,
+						  &rdst->remote_ip))
+			goto nla_put_failure;
+
+		if (rdst->remote_port &&
+		    rdst->remote_port != vxlan->cfg.dst_port &&
+		    nla_put_be16(skb, NDA_PORT, rdst->remote_port))
+			goto nla_put_failure;
+		if (rdst->remote_vni != vxlan->default_dst.remote_vni &&
+		    nla_put_u32(skb, NDA_VNI, be32_to_cpu(rdst->remote_vni)))
+			goto nla_put_failure;
+		if (rdst->remote_ifindex &&
+		    nla_put_u32(skb, NDA_IFINDEX, rdst->remote_ifindex))
+			goto nla_put_failure;
+	}
 
-	if (send_ip && vxlan_nla_put_addr(skb, NDA_DST, &rdst->remote_ip))
-		goto nla_put_failure;
-
-	if (rdst->remote_port && rdst->remote_port != vxlan->cfg.dst_port &&
-	    nla_put_be16(skb, NDA_PORT, rdst->remote_port))
-		goto nla_put_failure;
-	if (rdst->remote_vni != vxlan->default_dst.remote_vni &&
-	    nla_put_u32(skb, NDA_VNI, be32_to_cpu(rdst->remote_vni)))
-		goto nla_put_failure;
 	if ((vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA) && fdb->vni &&
 	    nla_put_u32(skb, NDA_SRC_VNI,
 			be32_to_cpu(fdb->vni)))
 		goto nla_put_failure;
-	if (rdst->remote_ifindex &&
-	    nla_put_u32(skb, NDA_IFINDEX, rdst->remote_ifindex))
-		goto nla_put_failure;
 
 	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
 	ci.ndm_confirmed = 0;
@@ -401,7 +421,7 @@ static int vxlan_fdb_notify(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 {
 	int err;
 
-	if (swdev_notify) {
+	if (swdev_notify && rd) {
 		switch (type) {
 		case RTM_NEWNEIGH:
 			err = vxlan_fdb_switchdev_call_notifiers(vxlan, fdb, rd,
@@ -805,6 +825,8 @@ static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
 	f->flags = ndm_flags;
 	f->updated = f->used = jiffies;
 	f->vni = src_vni;
+	f->nh = NULL;
+	INIT_LIST_HEAD(&f->nh_list);
 	INIT_LIST_HEAD(&f->remotes);
 	memcpy(f->eth_addr, mac, ETH_ALEN);
 
@@ -819,11 +841,76 @@ static void vxlan_fdb_insert(struct vxlan_dev *vxlan, const u8 *mac,
 			   vxlan_fdb_head(vxlan, mac, src_vni));
 }
 
+static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
+			       u32 nhid, struct netlink_ext_ack *extack)
+{
+	struct nexthop *old_nh = rtnl_dereference(fdb->nh);
+	struct nh_group *nhg;
+	struct nexthop *nh;
+	int err = -EINVAL;
+
+	if (old_nh && old_nh->id == nhid)
+		return 0;
+
+	nh = nexthop_find_by_id(vxlan->net, nhid);
+	if (!nh) {
+		NL_SET_ERR_MSG(extack, "Nexthop id does not exist");
+		goto err_inval;
+	}
+
+	if (nh) {
+		if (!nexthop_get(nh)) {
+			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
+			nh = NULL;
+			goto err_inval;
+		}
+		if (!nh->is_fdb_nh) {
+			NL_SET_ERR_MSG(extack, "Nexthop is not a fdb nexthop");
+			goto err_inval;
+		}
+
+		if (!nh->is_group || !nh->nh_grp->mpath) {
+			NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
+			goto err_inval;
+		}
+
+		/* check nexthop group family */
+		nhg = rtnl_dereference(nh->nh_grp);
+		switch (vxlan->default_dst.remote_ip.sa.sa_family) {
+		case AF_INET:
+			if (!nhg->has_v4) {
+				err = -EAFNOSUPPORT;
+				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
+				goto err_inval;
+			}
+			break;
+		case AF_INET6:
+			if (nhg->has_v4) {
+				err = -EAFNOSUPPORT;
+				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
+				goto err_inval;
+			}
+		}
+	}
+
+	rcu_assign_pointer(fdb->nh, nh);
+	list_add_tail_rcu(&fdb->nh_list, &nh->fdb_list);
+	if (old_nh)
+		nexthop_put(old_nh);
+	return 0;
+
+err_inval:
+	if (nh)
+		nexthop_put(nh);
+	return err;
+}
+
 static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 			    const u8 *mac, union vxlan_addr *ip,
 			    __u16 state, __be16 port, __be32 src_vni,
 			    __be32 vni, __u32 ifindex, __u16 ndm_flags,
-			    struct vxlan_fdb **fdb)
+			    u32 nhid, struct vxlan_fdb **fdb,
+			    struct netlink_ext_ack *extack)
 {
 	struct vxlan_rdst *rd = NULL;
 	struct vxlan_fdb *f;
@@ -838,20 +925,33 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 	if (!f)
 		return -ENOMEM;
 
-	rc = vxlan_fdb_append(f, ip, port, vni, ifindex, &rd);
-	if (rc < 0) {
-		kfree(f);
-		return rc;
-	}
+	if (nhid)
+		rc = vxlan_fdb_nh_update(vxlan, f, nhid, extack);
+	else
+		rc = vxlan_fdb_append(f, ip, port, vni, ifindex, &rd);
+	if (rc < 0)
+		goto errout;
 
 	*fdb = f;
 
 	return 0;
+
+errout:
+	kfree(f);
+	return rc;
 }
 
 static void __vxlan_fdb_free(struct vxlan_fdb *f)
 {
 	struct vxlan_rdst *rd, *nd;
+	struct nexthop *nh;
+
+	nh = rcu_dereference_raw(f->nh);
+	if (nh) {
+		rcu_assign_pointer(f->nh, NULL);
+		list_del_rcu(&f->nh_list);
+		nexthop_put(nh);
+	}
 
 	list_for_each_entry_safe(rd, nd, &f->remotes, list) {
 		dst_cache_destroy(&rd->dst_cache);
@@ -875,10 +975,15 @@ static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 	netdev_dbg(vxlan->dev, "delete %pM\n", f->eth_addr);
 
 	--vxlan->addrcnt;
-	if (do_notify)
-		list_for_each_entry(rd, &f->remotes, list)
-			vxlan_fdb_notify(vxlan, f, rd, RTM_DELNEIGH,
+	if (do_notify) {
+		if (rcu_access_pointer(f->nh))
+			vxlan_fdb_notify(vxlan, f, NULL, RTM_DELNEIGH,
 					 swdev_notify, NULL);
+		else
+			list_for_each_entry(rd, &f->remotes, list)
+				vxlan_fdb_notify(vxlan, f, rd, RTM_DELNEIGH,
+						 swdev_notify, NULL);
+	}
 
 	hlist_del_rcu(&f->hlist);
 	call_rcu(&f->rcu, vxlan_fdb_free);
@@ -897,7 +1002,7 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 				     __u16 state, __u16 flags,
 				     __be16 port, __be32 vni,
 				     __u32 ifindex, __u16 ndm_flags,
-				     struct vxlan_fdb *f,
+				     struct vxlan_fdb *f, u32 nhid,
 				     bool swdev_notify,
 				     struct netlink_ext_ack *extack)
 {
@@ -908,6 +1013,12 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 	int rc = 0;
 	int err;
 
+	if (nhid && !rcu_access_pointer(f->nh)) {
+		NL_SET_ERR_MSG(extack,
+			       "Cannot replace an existing non nexthop fdb with a nexthop");
+		return -EOPNOTSUPP;
+	}
+
 	/* Do not allow an externally learned entry to take over an entry added
 	 * by the user.
 	 */
@@ -925,6 +1036,14 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 		}
 	}
 
+	if (nhid) {
+		rc = vxlan_fdb_nh_update(vxlan, f, nhid, extack);
+		if (rc < 0)
+			return rc;
+		notify = 1;
+		f->updated = jiffies;
+	}
+
 	if ((flags & NLM_F_REPLACE)) {
 		/* Only change unicasts */
 		if (!(is_multicast_ether_addr(f->eth_addr) ||
@@ -975,7 +1094,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 				   const u8 *mac, union vxlan_addr *ip,
 				   __u16 state, __u16 flags,
 				   __be16 port, __be32 src_vni, __be32 vni,
-				   __u32 ifindex, __u16 ndm_flags,
+				   __u32 ifindex, __u16 ndm_flags, u32 nhid,
 				   bool swdev_notify,
 				   struct netlink_ext_ack *extack)
 {
@@ -990,7 +1109,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 
 	netdev_dbg(vxlan->dev, "add %pM -> %pIS\n", mac, ip);
 	rc = vxlan_fdb_create(vxlan, mac, ip, state, port, src_vni,
-			      vni, ifindex, fdb_flags, &f);
+			      vni, ifindex, fdb_flags, nhid, &f, extack);
 	if (rc < 0)
 		return rc;
 
@@ -1012,7 +1131,7 @@ static int vxlan_fdb_update(struct vxlan_dev *vxlan,
 			    const u8 *mac, union vxlan_addr *ip,
 			    __u16 state, __u16 flags,
 			    __be16 port, __be32 src_vni, __be32 vni,
-			    __u32 ifindex, __u16 ndm_flags,
+			    __u32 ifindex, __u16 ndm_flags, u32 nhid,
 			    bool swdev_notify,
 			    struct netlink_ext_ack *extack)
 {
@@ -1028,14 +1147,15 @@ static int vxlan_fdb_update(struct vxlan_dev *vxlan,
 
 		return vxlan_fdb_update_existing(vxlan, ip, state, flags, port,
 						 vni, ifindex, ndm_flags, f,
-						 swdev_notify, extack);
+						 nhid, swdev_notify, extack);
 	} else {
 		if (!(flags & NLM_F_CREATE))
 			return -ENOENT;
 
 		return vxlan_fdb_update_create(vxlan, mac, ip, state, flags,
 					       port, src_vni, vni, ifindex,
-					       ndm_flags, swdev_notify, extack);
+					       ndm_flags, nhid, swdev_notify,
+					       extack);
 	}
 }
 
@@ -1049,7 +1169,7 @@ static void vxlan_fdb_dst_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 
 static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 			   union vxlan_addr *ip, __be16 *port, __be32 *src_vni,
-			   __be32 *vni, u32 *ifindex)
+			   __be32 *vni, u32 *ifindex, u32 *nhid)
 {
 	struct net *net = dev_net(vxlan->dev);
 	int err;
@@ -1109,6 +1229,11 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 		*ifindex = 0;
 	}
 
+	if (tb[NDA_NH_ID])
+		*nhid = nla_get_u32(tb[NDA_NH_ID]);
+	else
+		*nhid = 0;
+
 	return 0;
 }
 
@@ -1123,7 +1248,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	union vxlan_addr ip;
 	__be16 port;
 	__be32 src_vni, vni;
-	u32 ifindex;
+	u32 ifindex, nhid;
 	u32 hash_index;
 	int err;
 
@@ -1133,10 +1258,11 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		return -EINVAL;
 	}
 
-	if (tb[NDA_DST] == NULL)
+	if (!tb || (!tb[NDA_DST] && !tb[NDA_NH_ID]))
 		return -EINVAL;
 
-	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex);
+	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
+			      &nhid);
 	if (err)
 		return err;
 
@@ -1148,7 +1274,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	err = vxlan_fdb_update(vxlan, addr, &ip, ndm->ndm_state, flags,
 			       port, src_vni, vni, ifindex,
 			       ndm->ndm_flags | NTF_VXLAN_ADDED_BY_USER,
-			       true, extack);
+			       nhid, true, extack);
 	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
@@ -1159,8 +1285,8 @@ static int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
 			      __be16 port, __be32 src_vni, __be32 vni,
 			      u32 ifindex, bool swdev_notify)
 {
-	struct vxlan_fdb *f;
 	struct vxlan_rdst *rd = NULL;
+	struct vxlan_fdb *f;
 	int err = -ENOENT;
 
 	f = vxlan_find_mac(vxlan, addr, src_vni);
@@ -1195,12 +1321,13 @@ static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	union vxlan_addr ip;
 	__be32 src_vni, vni;
-	__be16 port;
-	u32 ifindex;
+	u32 ifindex, nhid;
 	u32 hash_index;
+	__be16 port;
 	int err;
 
-	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex);
+	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
+			      &nhid);
 	if (err)
 		return err;
 
@@ -1228,6 +1355,17 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		hlist_for_each_entry_rcu(f, &vxlan->fdb_head[h], hlist) {
 			struct vxlan_rdst *rd;
 
+			if (rcu_access_pointer(f->nh)) {
+				err = vxlan_fdb_info(skb, vxlan, f,
+						     NETLINK_CB(cb->skb).portid,
+						     cb->nlh->nlmsg_seq,
+						     RTM_NEWNEIGH,
+						     NLM_F_MULTI, NULL);
+				if (err < 0)
+					goto out;
+				continue;
+			}
+
 			list_for_each_entry_rcu(rd, &f->remotes, list) {
 				if (*idx < cb->args[2])
 					goto skip;
@@ -1311,6 +1449,10 @@ static bool vxlan_snoop(struct net_device *dev,
 		if (f->state & (NUD_PERMANENT | NUD_NOARP))
 			return true;
 
+		/* Don't override an fdb with nexthop with a learnt entry */
+		if (rcu_access_pointer(f->nh))
+			return true;
+
 		if (net_ratelimit())
 			netdev_info(dev,
 				    "%pM migrated from %pIS to %pIS\n",
@@ -1333,7 +1475,7 @@ static bool vxlan_snoop(struct net_device *dev,
 					 vxlan->cfg.dst_port,
 					 vni,
 					 vxlan->default_dst.remote_vni,
-					 ifindex, NTF_SELF, true, NULL);
+					 ifindex, NTF_SELF, 0, true, NULL);
 		spin_unlock(&vxlan->hash_lock[hash_index]);
 	}
 
@@ -2616,6 +2758,30 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	kfree_skb(skb);
 }
 
+static void vxlan_xmit_nh(struct sk_buff *skb, struct net_device *dev,
+			  struct vxlan_fdb *f, __be32 vni, bool did_rsc)
+{
+	struct vxlan_rdst nh_rdst;
+	struct nexthop *nh;
+	bool do_xmit;
+	u32 hash;
+
+	memset(&nh_rdst, 0, sizeof(struct vxlan_rdst));
+	hash = skb_get_hash(skb);
+
+	rcu_read_lock();
+	nh = rcu_dereference(f->nh);
+	if (!nh)
+		return;
+	do_xmit = vxlan_fdb_nh_path_select(nh, hash, &nh_rdst);
+	rcu_read_unlock();
+
+	if (likely(do_xmit))
+		vxlan_xmit_one(skb, dev, vni, &nh_rdst, did_rsc);
+	else
+		kfree_skb(skb);
+}
+
 /* Transmit local packets over Vxlan
  *
  * Outer IP header inherits ECN and DF from inner header.
@@ -2692,22 +2858,27 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
-	list_for_each_entry_rcu(rdst, &f->remotes, list) {
-		struct sk_buff *skb1;
+	if (rcu_access_pointer(f->nh)) {
+		vxlan_xmit_nh(skb, dev, f,
+			      (vni ? : vxlan->default_dst.remote_vni), did_rsc);
+	} else {
+		list_for_each_entry_rcu(rdst, &f->remotes, list) {
+			struct sk_buff *skb1;
 
-		if (!fdst) {
-			fdst = rdst;
-			continue;
+			if (!fdst) {
+				fdst = rdst;
+				continue;
+			}
+			skb1 = skb_clone(skb, GFP_ATOMIC);
+			if (skb1)
+				vxlan_xmit_one(skb1, dev, vni, rdst, did_rsc);
 		}
-		skb1 = skb_clone(skb, GFP_ATOMIC);
-		if (skb1)
-			vxlan_xmit_one(skb1, dev, vni, rdst, did_rsc);
+		if (fdst)
+			vxlan_xmit_one(skb, dev, vni, fdst, did_rsc);
+		else
+			kfree_skb(skb);
 	}
 
-	if (fdst)
-		vxlan_xmit_one(skb, dev, vni, fdst, did_rsc);
-	else
-		kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
@@ -3615,7 +3786,7 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 				       dst->remote_vni,
 				       dst->remote_vni,
 				       dst->remote_ifindex,
-				       NTF_SELF, &f);
+				       NTF_SELF, 0, &f, extack);
 		if (err)
 			return err;
 	}
@@ -4013,7 +4184,7 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 					       vxlan->cfg.dst_port,
 					       conf.vni, conf.vni,
 					       conf.remote_ifindex,
-					       NTF_SELF, true, extack);
+					       NTF_SELF, 0, true, extack);
 			if (err) {
 				spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 				netdev_adjacent_change_abort(dst->remote_dev,
@@ -4335,7 +4506,7 @@ vxlan_fdb_external_learn_add(struct net_device *dev,
 			       fdb_info->remote_vni,
 			       fdb_info->remote_ifindex,
 			       NTF_USE | NTF_SELF | NTF_EXT_LEARNED,
-			       false, extack);
+			       0, false, extack);
 	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 04dafc6..d929c98 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -331,6 +331,8 @@ static inline struct fib_nh_common *nexthop_path_fdb_result(struct nexthop *nh,
 	struct nexthop *nhp;
 
 	nhp = nexthop_select_path(nh, hash);
+	if (unlikely(!nhp))
+		return NULL;
 	nhi = rcu_dereference(nhp->nh_info);
 	return &nhi->fib_nhc;
 }
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 373aadc..31bca3e 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -487,4 +487,28 @@ static inline void vxlan_flag_attr_error(int attrtype,
 #undef VXLAN_FLAG
 }
 
+static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
+					    int hash,
+					    struct vxlan_rdst *rdst)
+{
+	struct fib_nh_common *nhc;
+
+	nhc = nexthop_path_fdb_result(nh, hash);
+	if (unlikely(!nhc))
+		return false;
+
+	switch (nhc->nhc_gw_family) {
+	case AF_INET:
+		rdst->remote_ip.sin.sin_addr.s_addr = nhc->nhc_gw.ipv4;
+		rdst->remote_ip.sa.sa_family = AF_INET;
+		break;
+	case AF_INET6:
+		rdst->remote_ip.sin6.sin6_addr = nhc->nhc_gw.ipv6;
+		rdst->remote_ip.sa.sa_family = AF_INET6;
+		break;
+	}
+
+	return true;
+}
+
 #endif
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index cd144e3..eefcda8 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -29,6 +29,7 @@ enum {
 	NDA_LINK_NETNSID,
 	NDA_SRC_VNI,
 	NDA_PROTOCOL,  /* Originator of entry */
+	NDA_NH_ID,
 	__NDA_MAX
 };
 
-- 
2.1.4

