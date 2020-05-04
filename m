Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA19F1C4992
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 00:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgEDW2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 18:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgEDW2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 18:28:31 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4633BC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 15:28:31 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id fu13so109444pjb.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 15:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z0UGzWPL7acmTASycMCLnCO3J5RwVKthHRyDk3rUG3I=;
        b=Hp1aiPSJATHApkRxCyelx+9+06iaK4UJtlMEc7rks3u+u9kacvdHEVxzCSbDz6eFD2
         AP+9w7KX8JrmTEFXHECGnDx2mJauLGaXYYDlA05V/MPsqw4OliyhtoUYbMdcD6rMJh7a
         TXERFGK8XRq3nam2gggVNxJp/U3EBq4HYSWgo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z0UGzWPL7acmTASycMCLnCO3J5RwVKthHRyDk3rUG3I=;
        b=OX5UWFQJjKgimK7dagoMh+0X8s77TzRUXHf0iGmajbDaL4GnYJo5335YK76hphzups
         KBpJtmQateBOWPP3O8MAoOR0SegF1y5cdzmdzYehR1fbzkkC+DYV0cx4oeD+aMnWja+R
         YHNX+4DlkYjQ8SkwBfusoKPF/o6VBn/7dp794jZf//N5MfoPpy4vuwI6UQNB2PgVXMEk
         3ZAz2vTPI52axxI1L8UpH2yjOux45r6LoWjqFX7vnBKP9zq1ikWulHttPL5Nq1niy7IA
         yPX1JOoDjPnOolf/dM9/gOHq1V30AQeS30ukD2fK1bf9sDYmv+Kpmm9D5fjofcffZS6l
         2xLA==
X-Gm-Message-State: AGi0PuZobtOjgOuxlnJg4TAwJyezGBz7lFK6hvJZdWNLlvNiLWLIUpWP
        otLKF9Qd+EJVtK6DyJlP2vphbg==
X-Google-Smtp-Source: APiQypI7ouyeia03Fu7TL8W/ZZnX8wi+hhpHR36j7O+R5e+5Ryh9yQKJYkno3Y/6pmeEBVzd6nd4UQ==
X-Received: by 2002:a17:90a:a402:: with SMTP id y2mr46708pjp.24.1588631310589;
        Mon, 04 May 2020 15:28:30 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id ie17sm21213pjb.19.2020.05.04.15.28.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 15:28:29 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        idosch@mellanox.com, jiri@mellanox.com, petrm@mellanox.com
Subject: [RFC PATCH net-next 2/5] vxlan: ecmp support for mac fdb entries
Date:   Mon,  4 May 2020 15:28:18 -0700
Message-Id: <1588631301-21564-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
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

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/vxlan.c            | 286 ++++++++++++++++++++++++++++++++---------
 include/uapi/linux/neighbour.h |   1 +
 2 files changed, 227 insertions(+), 60 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a5b415f..176f2b3 100644
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
+	struct nexthop	  *nh;
 };
 
 #define NTF_VXLAN_ADDED_BY_USER 0x100
@@ -174,11 +177,15 @@ static inline struct hlist_head *vs_head(struct net *net, __be16 port)
  */
 static inline struct vxlan_rdst *first_remote_rcu(struct vxlan_fdb *fdb)
 {
+	if (fdb->nh)
+		return NULL;
 	return list_entry_rcu(fdb->remotes.next, struct vxlan_rdst, list);
 }
 
 static inline struct vxlan_rdst *first_remote_rtnl(struct vxlan_fdb *fdb)
 {
+	if (fdb->nh)
+		return NULL;
 	return list_first_entry(&fdb->remotes, struct vxlan_rdst, list);
 }
 
@@ -265,15 +272,19 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 	send_eth = send_ip = true;
 
 	if (type == RTM_GETNEIGH) {
-		send_ip = !vxlan_addr_any(&rdst->remote_ip);
+		if (rdst) {
+			send_ip = !vxlan_addr_any(&rdst->remote_ip);
+			ndm->ndm_family = send_ip ? rdst->remote_ip.sa.sa_family : AF_INET;
+		} else if (fdb->nh) {
+			ndm->ndm_family = fdb->nh->nh_info->family;
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
 
@@ -284,23 +295,30 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 
 	if (send_eth && nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->eth_addr))
 		goto nla_put_failure;
+	if (fdb->nh) {
+		if (nla_put_u32(skb, NDA_NH_ID, fdb->nh->id))
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
@@ -401,7 +419,7 @@ static int vxlan_fdb_notify(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 {
 	int err;
 
-	if (swdev_notify) {
+	if (swdev_notify && rd) {
 		switch (type) {
 		case RTM_NEWNEIGH:
 			err = vxlan_fdb_switchdev_call_notifiers(vxlan, fdb, rd,
@@ -805,6 +823,8 @@ static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
 	f->flags = ndm_flags;
 	f->updated = f->used = jiffies;
 	f->vni = src_vni;
+	f->nh = NULL;
+	INIT_LIST_HEAD(&f->nh_list);
 	INIT_LIST_HEAD(&f->remotes);
 	memcpy(f->eth_addr, mac, ETH_ALEN);
 
@@ -819,11 +839,59 @@ static void vxlan_fdb_insert(struct vxlan_dev *vxlan, const u8 *mac,
 			   vxlan_fdb_head(vxlan, mac, src_vni));
 }
 
+static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
+			       u32 nhid, struct netlink_ext_ack *extack)
+{
+	struct nexthop *nh;
+	int err = -EINVAL;
+
+	if (fdb->nh && (fdb->nh->id == nhid))
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
+	}
+
+	if (fdb->nh) {
+		list_del(&fdb->nh_list);
+		nexthop_put(fdb->nh);
+	}
+
+	fdb->nh = nh;
+	list_add(&fdb->nh_list, &nh->fdb_list);
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
@@ -838,15 +906,20 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
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
@@ -897,7 +970,7 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 				     __u16 state, __u16 flags,
 				     __be16 port, __be32 vni,
 				     __u32 ifindex, __u16 ndm_flags,
-				     struct vxlan_fdb *f,
+				     struct vxlan_fdb *f, u32 nhid,
 				     bool swdev_notify,
 				     struct netlink_ext_ack *extack)
 {
@@ -908,6 +981,9 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 	int rc = 0;
 	int err;
 
+	if (nhid && !f->nh)
+		return -EOPNOTSUPP;
+
 	/* Do not allow an externally learned entry to take over an entry added
 	 * by the user.
 	 */
@@ -925,6 +1001,19 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 		}
 	}
 
+	if (nhid) {
+		if (!f->nh)
+			return -EOPNOTSUPP;
+
+		if (f->nh->id != nhid) {
+			rc = vxlan_fdb_nh_update(vxlan, f, nhid, extack);
+			if (rc < 0)
+				return rc;
+			notify = 1;
+			f->updated = jiffies;
+		}
+	}
+
 	if ((flags & NLM_F_REPLACE)) {
 		/* Only change unicasts */
 		if (!(is_multicast_ether_addr(f->eth_addr) ||
@@ -975,7 +1064,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 				   const u8 *mac, union vxlan_addr *ip,
 				   __u16 state, __u16 flags,
 				   __be16 port, __be32 src_vni, __be32 vni,
-				   __u32 ifindex, __u16 ndm_flags,
+				   __u32 ifindex, __u16 ndm_flags, u32 nhid,
 				   bool swdev_notify,
 				   struct netlink_ext_ack *extack)
 {
@@ -990,7 +1079,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 
 	netdev_dbg(vxlan->dev, "add %pM -> %pIS\n", mac, ip);
 	rc = vxlan_fdb_create(vxlan, mac, ip, state, port, src_vni,
-			      vni, ifindex, fdb_flags, &f);
+			      vni, ifindex, fdb_flags, nhid, &f, extack);
 	if (rc < 0)
 		return rc;
 
@@ -1012,7 +1101,7 @@ static int vxlan_fdb_update(struct vxlan_dev *vxlan,
 			    const u8 *mac, union vxlan_addr *ip,
 			    __u16 state, __u16 flags,
 			    __be16 port, __be32 src_vni, __be32 vni,
-			    __u32 ifindex, __u16 ndm_flags,
+			    __u32 ifindex, __u16 ndm_flags, u32 nhid,
 			    bool swdev_notify,
 			    struct netlink_ext_ack *extack)
 {
@@ -1028,14 +1117,15 @@ static int vxlan_fdb_update(struct vxlan_dev *vxlan,
 
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
 
@@ -1049,7 +1139,7 @@ static void vxlan_fdb_dst_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 
 static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 			   union vxlan_addr *ip, __be16 *port, __be32 *src_vni,
-			   __be32 *vni, u32 *ifindex)
+			   __be32 *vni, u32 *ifindex, u32 *nhid)
 {
 	struct net *net = dev_net(vxlan->dev);
 	int err;
@@ -1109,6 +1199,11 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 		*ifindex = 0;
 	}
 
+	if (tb[NDA_NH_ID])
+		*nhid = nla_get_u32(tb[NDA_NH_ID]);
+	else
+		*nhid = 0;
+
 	return 0;
 }
 
@@ -1123,7 +1218,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	union vxlan_addr ip;
 	__be16 port;
 	__be32 src_vni, vni;
-	u32 ifindex;
+	u32 ifindex, nhid;
 	u32 hash_index;
 	int err;
 
@@ -1133,10 +1228,11 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
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
 
@@ -1148,7 +1244,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	err = vxlan_fdb_update(vxlan, addr, &ip, ndm->ndm_state, flags,
 			       port, src_vni, vni, ifindex,
 			       ndm->ndm_flags | NTF_VXLAN_ADDED_BY_USER,
-			       true, extack);
+			       nhid, true, extack);
 	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
@@ -1181,6 +1277,12 @@ static int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
 		goto out;
 	}
 
+	if (f->nh) {
+		list_del(&f->nh_list);
+		nexthop_put(f->nh);
+		f->nh = NULL;
+	}
+
 	vxlan_fdb_destroy(vxlan, f, true, swdev_notify);
 
 out:
@@ -1196,11 +1298,12 @@ static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 	union vxlan_addr ip;
 	__be32 src_vni, vni;
 	__be16 port;
-	u32 ifindex;
+	u32 ifindex, nhid;
 	u32 hash_index;
 	int err;
 
-	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex);
+	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
+			      &nhid);
 	if (err)
 		return err;
 
@@ -1228,6 +1331,17 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		hlist_for_each_entry_rcu(f, &vxlan->fdb_head[h], hlist) {
 			struct vxlan_rdst *rd;
 
+			if (f->nh) {
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
@@ -1311,6 +1425,10 @@ static bool vxlan_snoop(struct net_device *dev,
 		if (f->state & (NUD_PERMANENT | NUD_NOARP))
 			return true;
 
+		/* Don't override an fdb with nexthop with a learnt entry */
+		if (f->nh)
+			return true;
+
 		if (net_ratelimit())
 			netdev_info(dev,
 				    "%pM migrated from %pIS to %pIS\n",
@@ -1333,7 +1451,7 @@ static bool vxlan_snoop(struct net_device *dev,
 					 vxlan->cfg.dst_port,
 					 vni,
 					 vxlan->default_dst.remote_vni,
-					 ifindex, NTF_SELF, true, NULL);
+					 ifindex, NTF_SELF, 0, true, NULL);
 		spin_unlock(&vxlan->hash_lock[hash_index]);
 	}
 
@@ -2227,6 +2345,8 @@ static struct rtable *vxlan_get_route(struct vxlan_dev *vxlan, struct net_device
 
 	if (tos && !info)
 		use_cache = false;
+	if (!dst_cache)
+		use_cache = false;
 	if (use_cache) {
 		rt = dst_cache_get_ip4(dst_cache, saddr);
 		if (rt)
@@ -2408,11 +2528,26 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
+static void nhc_gw2vxlan_addr(struct nh_info *nhi, union vxlan_addr *remote_ip)
+{
+	memset(remote_ip, 0, sizeof(union vxlan_addr));
+	switch (nhi->fib_nh.nh_common.nhc_gw_family) {
+	case AF_INET:
+		remote_ip->sin.sin_addr.s_addr = nhi->fib_nh.nh_common.nhc_gw.ipv4;
+		remote_ip->sa.sa_family = AF_INET;
+		break;
+	case AF_INET6:
+		remote_ip->sin6.sin6_addr = nhi->fib_nh.nh_common.nhc_gw.ipv6;
+		remote_ip->sa.sa_family = AF_INET6;
+		break;
+	}
+}
+
 static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			   __be32 default_vni, struct vxlan_rdst *rdst,
-			   bool did_rsc)
+			   struct nh_info *nhi, bool did_rsc)
 {
-	struct dst_cache *dst_cache;
+	struct dst_cache *dst_cache = NULL;
 	struct ip_tunnel_info *info;
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	const struct iphdr *old_iph = ip_hdr(skb);
@@ -2432,8 +2567,13 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 	info = skb_tunnel_info(skb);
 
-	if (rdst) {
-		dst = &rdst->remote_ip;
+	if (rdst || nhi) {
+		if (rdst) {
+			dst = &rdst->remote_ip;
+		} else {
+			nhc_gw2vxlan_addr(nhi, &remote_ip);
+			dst = &remote_ip;
+		}
 		if (vxlan_addr_any(dst)) {
 			if (did_rsc) {
 				/* short-circuited back to local bridge */
@@ -2443,11 +2583,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto drop;
 		}
 
-		dst_port = rdst->remote_port ? rdst->remote_port : vxlan->cfg.dst_port;
-		vni = (rdst->remote_vni) ? : default_vni;
-		ifindex = rdst->remote_ifindex;
+		if (rdst) {
+			dst_port = rdst->remote_port ? rdst->remote_port : vxlan->cfg.dst_port;
+			vni = rdst->remote_vni ? : default_vni;
+			ifindex = rdst->remote_ifindex;
+			dst_cache = &rdst->dst_cache;
+		} else {
+			dst_port = vxlan->cfg.dst_port;
+			vni = default_vni;
+			ifindex = nhi->fib_nh.fib_nh_oif;
+		}
 		local_ip = vxlan->cfg.saddr;
-		dst_cache = &rdst->dst_cache;
 		md->gbp = skb->mark;
 		if (flags & VXLAN_F_TTL_INHERIT) {
 			ttl = ip_tunnel_get_ttl(old_iph, skb);
@@ -2616,6 +2762,19 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	kfree_skb(skb);
 }
 
+static void vxlan_xmit_nh(struct sk_buff *skb, struct net_device *dev,
+			  struct vxlan_fdb *f, __be32 vni, bool did_rsc)
+{
+	struct nexthop *nh = f->nh;
+	struct nh_info *nhi;
+	u32 hash;
+
+	hash = skb_get_hash(skb);
+	nhi = nexthop_path_fdb(nh, hash);
+
+	vxlan_xmit_one(skb, dev, vni, NULL, nhi, did_rsc);
+}
+
 /* Transmit local packets over Vxlan
  *
  * Outer IP header inherits ECN and DF from inner header.
@@ -2642,7 +2801,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			vni = tunnel_id_to_key32(info->key.tun_id);
 		} else {
 			if (info && info->mode & IP_TUNNEL_INFO_TX)
-				vxlan_xmit_one(skb, dev, vni, NULL, false);
+				vxlan_xmit_one(skb, dev, vni, NULL, NULL,
+					       false);
 			else
 				kfree_skb(skb);
 			return NETDEV_TX_OK;
@@ -2692,22 +2852,28 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
-	list_for_each_entry_rcu(rdst, &f->remotes, list) {
-		struct sk_buff *skb1;
+	if (f->nh) {
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
+				vxlan_xmit_one(skb1, dev, vni, rdst, NULL,
+					       did_rsc);
 		}
-		skb1 = skb_clone(skb, GFP_ATOMIC);
-		if (skb1)
-			vxlan_xmit_one(skb1, dev, vni, rdst, did_rsc);
+		if (fdst)
+			vxlan_xmit_one(skb, dev, vni, fdst, NULL, did_rsc);
+		else
+			kfree_skb(skb);
 	}
 
-	if (fdst)
-		vxlan_xmit_one(skb, dev, vni, fdst, did_rsc);
-	else
-		kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
@@ -3615,7 +3781,7 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 				       dst->remote_vni,
 				       dst->remote_vni,
 				       dst->remote_ifindex,
-				       NTF_SELF, &f);
+				       NTF_SELF, 0, &f, extack);
 		if (err)
 			return err;
 	}
@@ -4013,7 +4179,7 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 					       vxlan->cfg.dst_port,
 					       conf.vni, conf.vni,
 					       conf.remote_ifindex,
-					       NTF_SELF, true, extack);
+					       NTF_SELF, 0, true, extack);
 			if (err) {
 				spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 				netdev_adjacent_change_abort(dst->remote_dev,
@@ -4335,7 +4501,7 @@ vxlan_fdb_external_learn_add(struct net_device *dev,
 			       fdb_info->remote_vni,
 			       fdb_info->remote_ifindex,
 			       NTF_USE | NTF_SELF | NTF_EXT_LEARNED,
-			       false, extack);
+			       0, false, extack);
 	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
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

