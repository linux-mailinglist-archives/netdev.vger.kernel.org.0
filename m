Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06A2BBFE8
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 15:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgKUO2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 09:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgKUO2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 09:28:45 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9841BC0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 06:28:43 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id p8so13857745wrx.5
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 06:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hxYu9yopkXy2vm/i3Sw8GFey5M2x4maFSi23rYeZjBU=;
        b=OWHKIsypIyr2y4QRHVKwMZWoD808E/1Fn9bbufxjR3qUbmQasupb5JTEOxINpPbBxq
         2C1Yy30fjn6AJdQVlMG1seSXWAz1KxFLZPtb17PEDUNcsilIyk3eDrB4csh6n3+vFhYh
         /xXF35NbGpToqdKbL8u0NMvjTK/SxUDS4WMFK2yG8Z8kgk0Z/PV6Di6Lr900jMUdeEIy
         pwGV/MDE1vM+yc3Mz4WmRXU73WoJyOYy1cq8oRnXvDNCiELvbdmD8jLoCjr5iWxJ/Wcw
         nG89H4AkDjrgC1QOdJieG3XCLLGxsJBBY/IuDNFGpx5ksR2n8T4EKQOstQGn0yHcoRk7
         qFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hxYu9yopkXy2vm/i3Sw8GFey5M2x4maFSi23rYeZjBU=;
        b=qq8wf4+2H6kfpbo1uuqYFJt5bE/BYGjzTCcgpjx/knpMukmp8RJ4g/GwluzJDwmeEv
         54vqzW01gN4Q/0SCA3yjdHE7DF6hdr7YV1oB/dbIg4eAGLXmCWM8NNv9jLpC06rdoZIZ
         Yd+jK5vmv+d1RimiJywRentFVVPthlxVM5CcPTfS8Mf93VqqT/IYefkcFJVlCPT7eHtd
         4MOPBs25R40lyAw/f9YIYWOKf7EyXzsbAXNDQdlozGzRqoQwjfuMTz1Ng4i8nAMVG6/7
         2mrNlwlXNKdExzN5z73fybW18r//GCiNJkq8jy61LxuzShgZOBFNT+tnDgx5bwo1dhOz
         f9ww==
X-Gm-Message-State: AOAM530fxrtwmkoL9v8tERTa/+qG5SNYHDVDCpaEqPsDDXM+tY5whEve
        rfrmaVhKqjIOqZ8yE8bCRRU=
X-Google-Smtp-Source: ABdhPJza/ZMzxFZ+/89HjsCWNkxv8WjB9x/+tvOhuJjvYp8pCULWljQ4i+5cziMpccpIx2Po34l+Vg==
X-Received: by 2002:a5d:6548:: with SMTP id z8mr2302522wrv.399.1605968921953;
        Sat, 21 Nov 2020 06:28:41 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id t23sm7666190wmn.4.2020.11.21.06.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 06:28:41 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next] xfrm: interface: support collect metadata mode
Date:   Sat, 21 Nov 2020 16:28:23 +0200
Message-Id: <20201121142823.3629805-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for 'collect_md' mode on xfrm interfaces.

Each net can have one collect_md device, created by providing the
IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
altered and has no if_id or link device attributes.

On transmit to this device, the if_id is fetched from the attached dst
metadata on the skb. The dst metadata type used is METADATA_IP_TUNNEL
since the only needed property is the if_id stored in the tun_id member
of the ip_tunnel_info->key.

On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
packet received and attaches it to the skb. The if_id used in this case is
fetched from the xfrm state. This can later be used by upper layers such
as tc, ebpf, and ip rules.

Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
metadata is postponed until after scrubing. Similarly, xfrm_input() is
adapted to avoid dropping metadata dsts by only dropping 'valid'
(skb_valid_dst(skb) == true) dsts.

Policy matching on packets arriving from collect_md xfrmi devices is
done by using the xfrm state existing in the skb's sec_path.
The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
is changed to keep the details of the if_id extraction tucked away
in xfrm_interface.c.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 include/net/xfrm.h           |  11 +++-
 include/uapi/linux/if_link.h |   1 +
 net/xfrm/xfrm_input.c        |   7 ++-
 net/xfrm/xfrm_interface.c    | 114 ++++++++++++++++++++++++++++++-----
 net/xfrm/xfrm_policy.c       |  10 +--
 5 files changed, 119 insertions(+), 24 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b2a06f10b62c..925f8dcdd0db 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -308,9 +308,15 @@ struct xfrm_replay {
 	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
 };
 
+struct xfrm_if_decode_session_params {
+	struct net *net;
+	u32 if_id;
+};
+
 struct xfrm_if_cb {
-	struct xfrm_if	*(*decode_session)(struct sk_buff *skb,
-					   unsigned short family);
+	bool (*decode_session)(struct sk_buff *skb,
+			       unsigned short family,
+			       struct xfrm_if_decode_session_params *params);
 };
 
 void xfrm_if_register_cb(const struct xfrm_if_cb *ifcb);
@@ -984,6 +990,7 @@ void xfrm_dst_ifdown(struct dst_entry *dst, struct net_device *dev);
 struct xfrm_if_parms {
 	int link;		/* ifindex of underlying L2 interface */
 	u32 if_id;		/* interface identifyer */
+	bool collect_md;
 };
 
 struct xfrm_if {
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index c4b23f06f69e..ff04a06c2b69 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -655,6 +655,7 @@ enum {
 	IFLA_XFRM_UNSPEC,
 	IFLA_XFRM_LINK,
 	IFLA_XFRM_IF_ID,
+	IFLA_XFRM_COLLECT_METADATA,
 	__IFLA_XFRM_MAX
 };
 
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index be6351e3f3cd..c7de46d30697 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -20,6 +20,7 @@
 #include <net/xfrm.h>
 #include <net/ip_tunnels.h>
 #include <net/ip6_tunnel.h>
+#include <net/dst_metadata.h>
 
 #include "xfrm_inout.h"
 
@@ -719,7 +720,8 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		sp = skb_sec_path(skb);
 		if (sp)
 			sp->olen = 0;
-		skb_dst_drop(skb);
+		if (skb_valid_dst(skb))
+			skb_dst_drop(skb);
 		gro_cells_receive(&gro_cells, skb);
 		return 0;
 	} else {
@@ -737,7 +739,8 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			sp = skb_sec_path(skb);
 			if (sp)
 				sp->olen = 0;
-			skb_dst_drop(skb);
+			if (skb_valid_dst(skb))
+				skb_dst_drop(skb);
 			gro_cells_receive(&gro_cells, skb);
 			return err;
 		}
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 9b8e292a7c6a..10c14967d305 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -41,6 +41,7 @@
 #include <net/addrconf.h>
 #include <net/xfrm.h>
 #include <net/net_namespace.h>
+#include <net/dst_metadata.h>
 #include <net/netns/generic.h>
 #include <linux/etherdevice.h>
 
@@ -56,11 +57,22 @@ static const struct net_device_ops xfrmi_netdev_ops;
 struct xfrmi_net {
 	/* lists for storing interfaces in use */
 	struct xfrm_if __rcu *xfrmi[XFRMI_HASH_SIZE];
+	struct xfrm_if __rcu *collect_md_xfrmi;
 };
 
 #define for_each_xfrmi_rcu(start, xi) \
 	for (xi = rcu_dereference(start); xi; xi = rcu_dereference(xi->next))
 
+static u32 tunnel_id_to_if_id(__be64 tun_id)
+{
+	return ntohl(tunnel_id_to_key32(tun_id));
+}
+
+static __be64 if_id_to_tunnel_id(u32 if_id)
+{
+	return key32_to_tunnel_id(htonl(if_id));
+}
+
 static u32 xfrmi_hash(u32 if_id)
 {
 	return hash_32(if_id, XFRMI_HASH_BITS);
@@ -77,17 +89,23 @@ static struct xfrm_if *xfrmi_lookup(struct net *net, struct xfrm_state *x)
 			return xi;
 	}
 
+	xi = rcu_dereference(xfrmn->collect_md_xfrmi);
+	if (xi && xi->dev->flags & IFF_UP)
+		return xi;
+
 	return NULL;
 }
 
-static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
-					    unsigned short family)
+static bool xfrmi_decode_session(struct sk_buff *skb,
+				 unsigned short family,
+				 struct xfrm_if_decode_session_params *params)
 {
 	struct net_device *dev;
+	struct xfrm_if *xi;
 	int ifindex = 0;
 
 	if (!secpath_exists(skb) || !skb->dev)
-		return NULL;
+		return false;
 
 	switch (family) {
 	case AF_INET6:
@@ -107,11 +125,18 @@ static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
 	}
 
 	if (!dev || !(dev->flags & IFF_UP))
-		return NULL;
+		return false;
 	if (dev->netdev_ops != &xfrmi_netdev_ops)
-		return NULL;
+		return false;
+
+	xi = netdev_priv(dev);
+	params->net = xi->net;
 
-	return netdev_priv(dev);
+	if (xi->p.collect_md)
+		params->if_id = xfrm_input_state(skb)->if_id;
+	else
+		params->if_id = xi->p.if_id;
+	return true;
 }
 
 static void xfrmi_link(struct xfrmi_net *xfrmn, struct xfrm_if *xi)
@@ -157,7 +182,10 @@ static int xfrmi_create(struct net_device *dev)
 	if (err < 0)
 		goto out;
 
-	xfrmi_link(xfrmn, xi);
+	if (xi->p.collect_md)
+		rcu_assign_pointer(xfrmn->collect_md_xfrmi, xi);
+	else
+		xfrmi_link(xfrmn, xi);
 
 	return 0;
 
@@ -185,7 +213,10 @@ static void xfrmi_dev_uninit(struct net_device *dev)
 	struct xfrm_if *xi = netdev_priv(dev);
 	struct xfrmi_net *xfrmn = net_generic(xi->net, xfrmi_net_id);
 
-	xfrmi_unlink(xfrmn, xi);
+	if (xi->p.collect_md)
+		rcu_assign_pointer(xfrmn->collect_md_xfrmi, NULL);
+	else
+		xfrmi_unlink(xfrmn, xi);
 }
 
 static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
@@ -254,6 +285,16 @@ static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 	}
 
 	xfrmi_scrub_packet(skb, xnet);
+	if (xi->p.collect_md) {
+		struct metadata_dst *tun_dst;
+
+		tun_dst = tun_rx_dst(0);
+		if (!tun_dst)
+			return -ENOMEM;
+
+		tun_dst->u.tun_info.key.tun_id = if_id_to_tunnel_id(x->if_id);
+		skb_dst_set(skb, (struct dst_entry *)tun_dst);
+	}
 	dev_sw_netstats_rx_add(dev, skb->len);
 
 	return 0;
@@ -269,10 +310,24 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	struct net_device *tdev;
 	struct xfrm_state *x;
 	int err = -1;
+	u32 if_id;
 	int mtu;
 
+	if (xi->p.collect_md) {
+		struct ip_tunnel_info *tun_info = skb_tunnel_info(skb);
+
+		if (unlikely(!tun_info ||
+			     !(tun_info->mode & IP_TUNNEL_INFO_TX))) {
+			return -EINVAL;
+		}
+
+		if_id = tunnel_id_to_if_id(tun_info->key.tun_id);
+	} else {
+		if_id = xi->p.if_id;
+	}
+
 	dst_hold(dst);
-	dst = xfrm_lookup_with_ifid(xi->net, dst, fl, NULL, 0, xi->p.if_id);
+	dst = xfrm_lookup_with_ifid(xi->net, dst, fl, NULL, 0, if_id);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		dst = NULL;
@@ -283,7 +338,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	if (!x)
 		goto tx_err_link_failure;
 
-	if (x->if_id != xi->p.if_id)
+	if (x->if_id != if_id)
 		goto tx_err_link_failure;
 
 	tdev = dst->dev;
@@ -633,6 +688,9 @@ static void xfrmi_netlink_parms(struct nlattr *data[],
 
 	if (data[IFLA_XFRM_IF_ID])
 		parms->if_id = nla_get_u32(data[IFLA_XFRM_IF_ID]);
+
+	if (data[IFLA_XFRM_COLLECT_METADATA])
+		parms->collect_md = true;
 }
 
 static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
@@ -645,9 +703,20 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
 	int err;
 
 	xfrmi_netlink_parms(data, &p);
-	xi = xfrmi_locate(net, &p);
-	if (xi)
-		return -EEXIST;
+	if (p.collect_md) {
+		struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
+
+		if (p.link || p.if_id)
+			return -EINVAL;
+
+		if (rtnl_dereference(xfrmn->collect_md_xfrmi))
+			return -EEXIST;
+
+	} else {
+		xi = xfrmi_locate(net, &p);
+		if (xi)
+			return -EEXIST;
+	}
 
 	xi = netdev_priv(dev);
 	xi->p = p;
@@ -672,12 +741,17 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 	struct xfrm_if_parms p;
 
 	xfrmi_netlink_parms(data, &p);
+	if (p.collect_md)
+		return -EINVAL;
+
 	xi = xfrmi_locate(net, &p);
 	if (!xi) {
 		xi = netdev_priv(dev);
 	} else {
 		if (xi->dev != dev)
 			return -EEXIST;
+		if (xi->p.collect_md)
+			return -EINVAL;
 	}
 
 	return xfrmi_update(xi, &p);
@@ -690,6 +764,8 @@ static size_t xfrmi_get_size(const struct net_device *dev)
 		nla_total_size(4) +
 		/* IFLA_XFRM_IF_ID */
 		nla_total_size(4) +
+		/* IFLA_XFRM_COLLECT_METADATA */
+		nla_total_size(0) +
 		0;
 }
 
@@ -701,6 +777,10 @@ static int xfrmi_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put_u32(skb, IFLA_XFRM_LINK, parm->link) ||
 	    nla_put_u32(skb, IFLA_XFRM_IF_ID, parm->if_id))
 		goto nla_put_failure;
+	if (xi->p.collect_md) {
+		if (nla_put_flag(skb, IFLA_XFRM_COLLECT_METADATA))
+			goto nla_put_failure;
+	}
 	return 0;
 
 nla_put_failure:
@@ -715,8 +795,9 @@ static struct net *xfrmi_get_link_net(const struct net_device *dev)
 }
 
 static const struct nla_policy xfrmi_policy[IFLA_XFRM_MAX + 1] = {
-	[IFLA_XFRM_LINK]	= { .type = NLA_U32 },
-	[IFLA_XFRM_IF_ID]	= { .type = NLA_U32 },
+	[IFLA_XFRM_LINK]		= { .type = NLA_U32 },
+	[IFLA_XFRM_IF_ID]		= { .type = NLA_U32 },
+	[IFLA_XFRM_COLLECT_METADATA]	= { .type = NLA_FLAG },
 };
 
 static struct rtnl_link_ops xfrmi_link_ops __read_mostly = {
@@ -752,6 +833,9 @@ static void __net_exit xfrmi_exit_batch_net(struct list_head *net_exit_list)
 			     xip = &xi->next)
 				unregister_netdevice_queue(xi->dev, &list);
 		}
+		xi = rcu_dereference(xfrmn->collect_md_xfrmi);
+		if (xi)
+			unregister_netdevice_queue(xi->dev, &list);
 	}
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d622c2548d22..4da5ea277500 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3519,17 +3519,17 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	int xerr_idx = -1;
 	const struct xfrm_if_cb *ifcb;
 	struct sec_path *sp;
-	struct xfrm_if *xi;
 	u32 if_id = 0;
 
 	rcu_read_lock();
 	ifcb = xfrm_if_get_cb();
 
 	if (ifcb) {
-		xi = ifcb->decode_session(skb, family);
-		if (xi) {
-			if_id = xi->p.if_id;
-			net = xi->net;
+		struct xfrm_if_decode_session_params p;
+
+		if (ifcb->decode_session(skb, family, &p)) {
+			if_id = p.if_id;
+			net = p.net;
 		}
 	}
 	rcu_read_unlock();
-- 
2.25.1

