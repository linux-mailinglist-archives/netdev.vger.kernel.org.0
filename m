Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966F859EA28
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiHWRt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiHWRsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:48:39 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3A5696DB;
        Tue, 23 Aug 2022 08:46:22 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso7967203wmb.2;
        Tue, 23 Aug 2022 08:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=tPKbavRdFK/u4df00oalSVINqAUAigsKU5d+68m+1Sk=;
        b=SQmbkDxJ7HyLRW/K86ANeowpoVGKXj+lYHQ96bxkrFdAYzVV3Brsoby7pMQ3PAMuOh
         eetuUM76lHKqFiRASTZZ6tHDFNxuAzoikNnDdM2PCTL8k/oXJXCI1qyhh6IHJg0nS+xH
         qggm8xKjUslpvWh8/2qZMxvI1WlCv1PVOsGzKol11UVyTIf+ojabeTdHTN3dSbKiJWLM
         5JX34SdcaF8veH7/0/5vtrQYoIsL++PKMyYptAziXHGfyO9qfBSif2Wvz35MMd4e5gMz
         MR+YhZPIhOsQEXm9ta6a2DXo+SDLj2/2IQXlEt12JemD0OWNJEwkRXhX0j5kxea+CSKm
         Ed4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=tPKbavRdFK/u4df00oalSVINqAUAigsKU5d+68m+1Sk=;
        b=Av4TlMGG+kawUp5GiwCuN5J+fbLDhN56SDvao7SDl5fjw8arym1MFtzyQBvDrUOP8l
         xwkl/51RPl2fXMQuuqwW5W/Zzdhz8OED6pfE1RfuzHqSJKIpYTK3itKZF8IXN05TUn5N
         Omk645PhkNRhRwYkRCOT4V/it4KmAv7YiTYi6scbyepgo2sIR1jufG/OqVkshCKGzOnC
         uM3ezZhafwTT2NQeZgpvYj9Jgm6qnpjg3NsWiBxQnLFyCMy9inb0wJtIfSd0+w/sbzou
         Eb27UgjUPegbwLP+ckQ+x+CEPgT+50dmYlSS8/dKzzXerXZWJXEyzIVix05A1684C9Sr
         Et/A==
X-Gm-Message-State: ACgBeo3anWf4raVN4B4KYy2TYI3lzQ2Uhi5h24sRS00eM08Imjyv/9mB
        Res8/R8+HevKIQyQXIMRgwY=
X-Google-Smtp-Source: AA6agR7AoUhIYOHrG9C6C9Iym/ur+IFgYP3LfyfwXzwdnBRLT1lnejivk7pJ0+sigmr7RlOQQM9rMg==
X-Received: by 2002:a05:600c:350:b0:3a5:3473:1c23 with SMTP id u16-20020a05600c035000b003a534731c23mr2699350wmd.9.1661269580554;
        Tue, 23 Aug 2022 08:46:20 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id i26-20020a1c541a000000b003a64f684704sm11341211wmb.40.2022.08.23.08.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 08:46:20 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pablo@netfilter.org,
        contact@proelbtn.com, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, devel@linux-ipsec.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next 2/3] xfrm: interface: support collect metadata mode
Date:   Tue, 23 Aug 2022 18:45:56 +0300
Message-Id: <20220823154557.1400380-3-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220823154557.1400380-1-eyal.birger@gmail.com>
References: <20220823154557.1400380-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for 'collect_md' mode on xfrm interfaces.

Each net can have one collect_md device, created by providing the
IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
altered and has no if_id or link device attributes.

On transmit to this device, the if_id is fetched from the attached dst
metadata on the skb. The dst metadata type used is METADATA_XFRM
which holds the if_id property.

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
 net/xfrm/xfrm_interface.c    | 115 +++++++++++++++++++++++++++++------
 net/xfrm/xfrm_policy.c       |  10 +--
 5 files changed, 116 insertions(+), 28 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6e8fa98f786f..756b1bbc27f5 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -312,9 +312,15 @@ struct km_event {
 	struct net *net;
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
@@ -985,6 +991,7 @@ void xfrm_dst_ifdown(struct dst_entry *dst, struct net_device *dev);
 struct xfrm_if_parms {
 	int link;		/* ifindex of underlying L2 interface */
 	u32 if_id;		/* interface identifyer */
+	bool collect_md;
 };
 
 struct xfrm_if {
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e36d9d2c65a7..d96f13a42589 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -694,6 +694,7 @@ enum {
 	IFLA_XFRM_UNSPEC,
 	IFLA_XFRM_LINK,
 	IFLA_XFRM_IF_ID,
+	IFLA_XFRM_COLLECT_METADATA,
 	__IFLA_XFRM_MAX
 };
 
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 144238a50f3d..25e822fb5771 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -20,6 +20,7 @@
 #include <net/xfrm.h>
 #include <net/ip_tunnels.h>
 #include <net/ip6_tunnel.h>
+#include <net/dst_metadata.h>
 
 #include "xfrm_inout.h"
 
@@ -720,7 +721,8 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		sp = skb_sec_path(skb);
 		if (sp)
 			sp->olen = 0;
-		skb_dst_drop(skb);
+		if (skb_valid_dst(skb))
+			skb_dst_drop(skb);
 		gro_cells_receive(&gro_cells, skb);
 		return 0;
 	} else {
@@ -738,7 +740,8 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
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
index 5113fa0fbcee..efb8263e1c22 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -41,6 +41,7 @@
 #include <net/addrconf.h>
 #include <net/xfrm.h>
 #include <net/net_namespace.h>
+#include <net/dst_metadata.h>
 #include <net/netns/generic.h>
 #include <linux/etherdevice.h>
 
@@ -56,6 +57,7 @@ static const struct net_device_ops xfrmi_netdev_ops;
 struct xfrmi_net {
 	/* lists for storing interfaces in use */
 	struct xfrm_if __rcu *xfrmi[XFRMI_HASH_SIZE];
+	struct xfrm_if __rcu *collect_md_xfrmi;
 };
 
 #define for_each_xfrmi_rcu(start, xi) \
@@ -77,17 +79,23 @@ static struct xfrm_if *xfrmi_lookup(struct net *net, struct xfrm_state *x)
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
@@ -107,11 +115,18 @@ static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
 	}
 
 	if (!dev || !(dev->flags & IFF_UP))
-		return NULL;
+		return false;
 	if (dev->netdev_ops != &xfrmi_netdev_ops)
-		return NULL;
+		return false;
 
-	return netdev_priv(dev);
+	xi = netdev_priv(dev);
+	params->net = xi->net;
+
+	if (xi->p.collect_md)
+		params->if_id = xfrm_input_state(skb)->if_id;
+	else
+		params->if_id = xi->p.if_id;
+	return true;
 }
 
 static void xfrmi_link(struct xfrmi_net *xfrmn, struct xfrm_if *xi)
@@ -157,7 +172,10 @@ static int xfrmi_create(struct net_device *dev)
 	if (err < 0)
 		goto out;
 
-	xfrmi_link(xfrmn, xi);
+	if (xi->p.collect_md)
+		rcu_assign_pointer(xfrmn->collect_md_xfrmi, xi);
+	else
+		xfrmi_link(xfrmn, xi);
 
 	return 0;
 
@@ -185,7 +203,10 @@ static void xfrmi_dev_uninit(struct net_device *dev)
 	struct xfrm_if *xi = netdev_priv(dev);
 	struct xfrmi_net *xfrmn = net_generic(xi->net, xfrmi_net_id);
 
-	xfrmi_unlink(xfrmn, xi);
+	if (xi->p.collect_md)
+		rcu_assign_pointer(xfrmn->collect_md_xfrmi, NULL);
+	else
+		xfrmi_unlink(xfrmn, xi);
 }
 
 static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
@@ -254,6 +275,16 @@ static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 	}
 
 	xfrmi_scrub_packet(skb, xnet);
+	if (xi->p.collect_md) {
+		struct metadata_dst *md_dst;
+
+		md_dst = metadata_dst_alloc(0, METADATA_XFRM, GFP_ATOMIC);
+		if (!md_dst)
+			return -ENOMEM;
+
+		md_dst->u.xfrm_info.if_id = x->if_id;
+		skb_dst_set(skb, (struct dst_entry *)md_dst);
+	}
 	dev_sw_netstats_rx_add(dev, skb->len);
 
 	return 0;
@@ -269,10 +300,22 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	struct net_device *tdev;
 	struct xfrm_state *x;
 	int err = -1;
+	u32 if_id;
 	int mtu;
 
+	if (xi->p.collect_md) {
+		struct xfrm_md_info *md_info = skb_xfrm_md_info(skb);
+
+		if (unlikely(!md_info))
+			return -EINVAL;
+
+		if_id = md_info->if_id;
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
@@ -283,7 +326,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	if (!x)
 		goto tx_err_link_failure;
 
-	if (x->if_id != xi->p.if_id)
+	if (x->if_id != if_id)
 		goto tx_err_link_failure;
 
 	tdev = dst->dev;
@@ -633,6 +676,9 @@ static void xfrmi_netlink_parms(struct nlattr *data[],
 
 	if (data[IFLA_XFRM_IF_ID])
 		parms->if_id = nla_get_u32(data[IFLA_XFRM_IF_ID]);
+
+	if (data[IFLA_XFRM_COLLECT_METADATA])
+		parms->collect_md = true;
 }
 
 static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
@@ -645,14 +691,27 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
 	int err;
 
 	xfrmi_netlink_parms(data, &p);
-	if (!p.if_id) {
-		NL_SET_ERR_MSG(extack, "if_id must be non zero");
-		return -EINVAL;
-	}
+	if (p.collect_md) {
+		struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 
-	xi = xfrmi_locate(net, &p);
-	if (xi)
-		return -EEXIST;
+		if (p.link || p.if_id) {
+			NL_SET_ERR_MSG(extack, "link and if_id must be zero");
+			return -EINVAL;
+		}
+
+		if (rtnl_dereference(xfrmn->collect_md_xfrmi))
+			return -EEXIST;
+
+	} else {
+		if (!p.if_id) {
+			NL_SET_ERR_MSG(extack, "if_id must be non zero");
+			return -EINVAL;
+		}
+
+		xi = xfrmi_locate(net, &p);
+		if (xi)
+			return -EEXIST;
+	}
 
 	xi = netdev_priv(dev);
 	xi->p = p;
@@ -682,12 +741,19 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 		return -EINVAL;
 	}
 
+	if (p.collect_md) {
+		NL_SET_ERR_MSG(extack, "collect_md can't be changed");
+		return -EINVAL;
+	}
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
@@ -700,6 +766,8 @@ static size_t xfrmi_get_size(const struct net_device *dev)
 		nla_total_size(4) +
 		/* IFLA_XFRM_IF_ID */
 		nla_total_size(4) +
+		/* IFLA_XFRM_COLLECT_METADATA */
+		nla_total_size(0) +
 		0;
 }
 
@@ -711,6 +779,10 @@ static int xfrmi_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put_u32(skb, IFLA_XFRM_LINK, parm->link) ||
 	    nla_put_u32(skb, IFLA_XFRM_IF_ID, parm->if_id))
 		goto nla_put_failure;
+	if (xi->p.collect_md) {
+		if (nla_put_flag(skb, IFLA_XFRM_COLLECT_METADATA))
+			goto nla_put_failure;
+	}
 	return 0;
 
 nla_put_failure:
@@ -725,8 +797,10 @@ static struct net *xfrmi_get_link_net(const struct net_device *dev)
 }
 
 static const struct nla_policy xfrmi_policy[IFLA_XFRM_MAX + 1] = {
-	[IFLA_XFRM_LINK]	= { .type = NLA_U32 },
-	[IFLA_XFRM_IF_ID]	= { .type = NLA_U32 },
+	[IFLA_XFRM_UNSPEC]		= { .strict_start_type = IFLA_XFRM_COLLECT_METADATA },
+	[IFLA_XFRM_LINK]		= { .type = NLA_U32 },
+	[IFLA_XFRM_IF_ID]		= { .type = NLA_U32 },
+	[IFLA_XFRM_COLLECT_METADATA]	= { .type = NLA_FLAG },
 };
 
 static struct rtnl_link_ops xfrmi_link_ops __read_mostly = {
@@ -762,6 +836,9 @@ static void __net_exit xfrmi_exit_batch_net(struct list_head *net_exit_list)
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
index f1a0bab920a5..76894adcc82f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3516,17 +3516,17 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
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
2.34.1

