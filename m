Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E842311D519
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbfLLSRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:17:18 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53094 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730358AbfLLSRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:17:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so3425395wmc.2
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+38SmiL6fMIgqzQcwGQgZ2To42cIeY4X0Qogd8wRazE=;
        b=yauwuWMsHfivbMJOTY5awEbcJy4lQOdKj67qBOhR/6/njiQYvM/LqwscfZxXq9Mjkx
         ssYLY/bAIV2AEPBRUkJw1kzblPeI6xfFOlvGTVbm70V97Lc/QlVV+KdTHlt1oAppTnim
         V1240yWePmDp0R6wMl8JImxM6EUun/8eZUU5c7lJYz6BobAIfW6utIMDisUou4kc9vpy
         0Mr24yeyAa7WIih6+lvUO9cWvoj2BW35nTfzO6CNq5x4jsEj/cTqNyu63pKck5Qxcixt
         s8QLrrBIK/7Yp7KpbOm/IHM/z64WbtVLZK1qmd4ZRg3L2Cue5Pwsmp5QWnwIfJ4MCnCk
         M1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+38SmiL6fMIgqzQcwGQgZ2To42cIeY4X0Qogd8wRazE=;
        b=JfklVyyvcm2dbCVbXbX0xbMAh1by9xwvMc1JPlpF/taDr3nN/jwQVheQHMDAuqPXFm
         iw1O455zXcETnMsUNWmaUso7tpPticJVnPsy4hpmFa5hFoizgQjk9EC4bU49Htq1uxi5
         SBQLLKqYfmLTbiXotGXyUR0tWZzal83tHNWEjdlUsZFspjpAq8rSfSY8sitdgZyIC6jq
         B8Pl1/sMjqZDyP2sZGfyHkch2SmIuVS4IMB3EdxHgha68bH+/5mdNr++W+5y2YSzo3pu
         Egd31mcZtwXWBjCIPBUiO7qh1HUeT34tsdib1pdXla6sgNRIgk499NDyZCyTbX9n+VdP
         NGkg==
X-Gm-Message-State: APjAAAV9Z8Qga2KqV52v7jSSL6tk+5qfucsM+5pXmdcy/gsVDqvXyJhY
        uDvcr6VC2egsNKj8pWWCKeuuAw85ry4Jl0yE7bm7p3ZJYkQrDnEg9RVS7tWlv6ZNYE9l+u8YwVV
        yubU0od4iuam1R9OhPghisbd+/ywInCmZBeYmEq8wb8Bf4HLgeDpbogNFLr1EonQZi9TKZAcjQw
        ==
X-Google-Smtp-Source: APXvYqzQvz6chZo3kFW0pXEFjvF1il4xjP2NfXZvubPHFOtwazTLrfKOBO28bGm+J6Hzc7Lmp/gS0w==
X-Received: by 2002:a7b:cb97:: with SMTP id m23mr7995093wmi.37.1576174632747;
        Thu, 12 Dec 2019 10:17:12 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id j21sm7928736wmj.39.2019.12.12.10.17.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 10:17:12 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 6/9] nfp: flower: handle ipv6 tunnel no neigh request
Date:   Thu, 12 Dec 2019 18:16:53 +0000
Message-Id: <1576174616-9738-7-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
References: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When fw does not know the next hop for an IPv6 tunnel, it sends a request
to the driver.

Handle this request by doing a route lookup on the IPv6 address and
offloading the next hop to the fw neighbour table.

Similar functions already exist to handle IPv4 no neighbour requests. To
avoid confusion, append these functions with the _ipv4 tag. There is no
change in functionality with this.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.c   |   8 +-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |   2 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   3 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 111 ++++++++++++++++++++-
 4 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
index 05981b5..00b904e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
@@ -270,7 +270,10 @@ nfp_flower_cmsg_process_one_rx(struct nfp_app *app, struct sk_buff *skb)
 		}
 		goto err_default;
 	case NFP_FLOWER_CMSG_TYPE_NO_NEIGH:
-		nfp_tunnel_request_route(app, skb);
+		nfp_tunnel_request_route_v4(app, skb);
+		break;
+	case NFP_FLOWER_CMSG_TYPE_NO_NEIGH_V6:
+		nfp_tunnel_request_route_v6(app, skb);
 		break;
 	case NFP_FLOWER_CMSG_TYPE_ACTIVE_TUNS:
 		nfp_tunnel_keep_alive(app, skb);
@@ -361,7 +364,8 @@ void nfp_flower_cmsg_rx(struct nfp_app *app, struct sk_buff *skb)
 		   nfp_flower_process_mtu_ack(app, skb)) {
 		/* Handle MTU acks outside wq to prevent RTNL conflict. */
 		dev_consume_skb_any(skb);
-	} else if (cmsg_hdr->type == NFP_FLOWER_CMSG_TYPE_TUN_NEIGH) {
+	} else if (cmsg_hdr->type == NFP_FLOWER_CMSG_TYPE_TUN_NEIGH ||
+		   cmsg_hdr->type == NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6) {
 		/* Acks from the NFP that the route is added - ignore. */
 		dev_consume_skb_any(skb);
 	} else if (cmsg_hdr->type == NFP_FLOWER_CMSG_TYPE_PORT_REIFY) {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 7537695..5a8ad58 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -572,6 +572,8 @@ enum nfp_flower_cmsg_type_port {
 	NFP_FLOWER_CMSG_TYPE_QOS_STATS =	20,
 	NFP_FLOWER_CMSG_TYPE_PRE_TUN_RULE =	21,
 	NFP_FLOWER_CMSG_TYPE_TUN_IPS_V6 =	22,
+	NFP_FLOWER_CMSG_TYPE_NO_NEIGH_V6 =	23,
+	NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6 =	24,
 	NFP_FLOWER_CMSG_TYPE_MAX =		32,
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index bd288e2..01e1886 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -418,7 +418,8 @@ void
 nfp_tunnel_put_ipv6_off(struct nfp_app *app, struct nfp_ipv6_addr_entry *entry);
 struct nfp_ipv6_addr_entry *
 nfp_tunnel_add_ipv6_off(struct nfp_app *app, struct in6_addr *ipv6);
-void nfp_tunnel_request_route(struct nfp_app *app, struct sk_buff *skb);
+void nfp_tunnel_request_route_v4(struct nfp_app *app, struct sk_buff *skb);
+void nfp_tunnel_request_route_v6(struct nfp_app *app, struct sk_buff *skb);
 void nfp_tunnel_keep_alive(struct nfp_app *app, struct sk_buff *skb);
 void nfp_flower_lag_init(struct nfp_fl_lag *lag);
 void nfp_flower_lag_cleanup(struct nfp_fl_lag *lag);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index eddb52d..09807b3 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -71,6 +71,22 @@ struct nfp_tun_neigh {
 };
 
 /**
+ * struct nfp_tun_neigh_v6 - neighbour/route entry on the NFP
+ * @dst_ipv6:	destination IPv6 address
+ * @src_ipv6:	source IPv6 address
+ * @dst_addr:	destination MAC address
+ * @src_addr:	source MAC address
+ * @port_id:	NFP port to output packet on - associated with source IPv6
+ */
+struct nfp_tun_neigh_v6 {
+	struct in6_addr dst_ipv6;
+	struct in6_addr src_ipv6;
+	u8 dst_addr[ETH_ALEN];
+	u8 src_addr[ETH_ALEN];
+	__be32 port_id;
+};
+
+/**
  * struct nfp_tun_req_route_ipv4 - NFP requests a route/neighbour lookup
  * @ingress_port:	ingress port of packet that signalled request
  * @ipv4_addr:		destination ipv4 address for route
@@ -83,6 +99,16 @@ struct nfp_tun_req_route_ipv4 {
 };
 
 /**
+ * struct nfp_tun_req_route_ipv6 - NFP requests an IPv6 route/neighbour lookup
+ * @ingress_port:	ingress port of packet that signalled request
+ * @ipv6_addr:		destination ipv6 address for route
+ */
+struct nfp_tun_req_route_ipv6 {
+	__be32 ingress_port;
+	struct in6_addr ipv6_addr;
+};
+
+/**
  * struct nfp_ipv4_route_entry - routes that are offloaded to the NFP
  * @ipv4_addr:	destination of route
  * @list:	list pointer
@@ -299,8 +325,8 @@ static void nfp_tun_del_route_from_cache(struct nfp_app *app, __be32 ipv4_addr)
 }
 
 static void
-nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
-		    struct flowi4 *flow, struct neighbour *neigh, gfp_t flag)
+nfp_tun_write_neigh_v4(struct net_device *netdev, struct nfp_app *app,
+		       struct flowi4 *flow, struct neighbour *neigh, gfp_t flag)
 {
 	struct nfp_tun_neigh payload;
 	u32 port_id;
@@ -334,6 +360,39 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 				 (unsigned char *)&payload, flag);
 }
 
+static void
+nfp_tun_write_neigh_v6(struct net_device *netdev, struct nfp_app *app,
+		       struct flowi6 *flow, struct neighbour *neigh, gfp_t flag)
+{
+	struct nfp_tun_neigh_v6 payload;
+	u32 port_id;
+
+	port_id = nfp_flower_get_port_id_from_netdev(app, netdev);
+	if (!port_id)
+		return;
+
+	memset(&payload, 0, sizeof(struct nfp_tun_neigh_v6));
+	payload.dst_ipv6 = flow->daddr;
+
+	/* If entry has expired send dst IP with all other fields 0. */
+	if (!(neigh->nud_state & NUD_VALID) || neigh->dead) {
+		/* Trigger probe to verify invalid neighbour state. */
+		neigh_event_send(neigh, NULL);
+		goto send_msg;
+	}
+
+	/* Have a valid neighbour so populate rest of entry. */
+	payload.src_ipv6 = flow->saddr;
+	ether_addr_copy(payload.src_addr, netdev->dev_addr);
+	neigh_ha_snapshot(payload.dst_addr, neigh, netdev);
+	payload.port_id = cpu_to_be32(port_id);
+
+send_msg:
+	nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6,
+				 sizeof(struct nfp_tun_neigh_v6),
+				 (unsigned char *)&payload, flag);
+}
+
 static int
 nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
@@ -384,12 +443,12 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 #endif
 
 	flow.flowi4_proto = IPPROTO_UDP;
-	nfp_tun_write_neigh(n->dev, app, &flow, n, GFP_ATOMIC);
+	nfp_tun_write_neigh_v4(n->dev, app, &flow, n, GFP_ATOMIC);
 
 	return NOTIFY_OK;
 }
 
-void nfp_tunnel_request_route(struct nfp_app *app, struct sk_buff *skb)
+void nfp_tunnel_request_route_v4(struct nfp_app *app, struct sk_buff *skb)
 {
 	struct nfp_tun_req_route_ipv4 *payload;
 	struct net_device *netdev;
@@ -423,7 +482,7 @@ void nfp_tunnel_request_route(struct nfp_app *app, struct sk_buff *skb)
 	ip_rt_put(rt);
 	if (!n)
 		goto fail_rcu_unlock;
-	nfp_tun_write_neigh(n->dev, app, &flow, n, GFP_ATOMIC);
+	nfp_tun_write_neigh_v4(n->dev, app, &flow, n, GFP_ATOMIC);
 	neigh_release(n);
 	rcu_read_unlock();
 	return;
@@ -433,6 +492,48 @@ void nfp_tunnel_request_route(struct nfp_app *app, struct sk_buff *skb)
 	nfp_flower_cmsg_warn(app, "Requested route not found.\n");
 }
 
+void nfp_tunnel_request_route_v6(struct nfp_app *app, struct sk_buff *skb)
+{
+	struct nfp_tun_req_route_ipv6 *payload;
+	struct net_device *netdev;
+	struct flowi6 flow = {};
+	struct dst_entry *dst;
+	struct neighbour *n;
+
+	payload = nfp_flower_cmsg_get_data(skb);
+
+	rcu_read_lock();
+	netdev = nfp_app_dev_get(app, be32_to_cpu(payload->ingress_port), NULL);
+	if (!netdev)
+		goto fail_rcu_unlock;
+
+	flow.daddr = payload->ipv6_addr;
+	flow.flowi6_proto = IPPROTO_UDP;
+
+#if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
+	dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(netdev), NULL, &flow,
+					      NULL);
+	if (IS_ERR(dst))
+		goto fail_rcu_unlock;
+#else
+	goto fail_rcu_unlock;
+#endif
+
+	n = dst_neigh_lookup(dst, &flow.daddr);
+	dst_release(dst);
+	if (!n)
+		goto fail_rcu_unlock;
+
+	nfp_tun_write_neigh_v6(n->dev, app, &flow, n, GFP_ATOMIC);
+	neigh_release(n);
+	rcu_read_unlock();
+	return;
+
+fail_rcu_unlock:
+	rcu_read_unlock();
+	nfp_flower_cmsg_warn(app, "Requested IPv6 route not found.\n");
+}
+
 static void nfp_tun_write_ipv4_list(struct nfp_app *app)
 {
 	struct nfp_flower_priv *priv = app->priv;
-- 
2.7.4

