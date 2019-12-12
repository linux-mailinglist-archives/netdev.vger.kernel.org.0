Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1765911D51D
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbfLLSR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:17:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41273 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730337AbfLLSRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:17:17 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so3782597wrw.8
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hBPoJS3IZxT2JPLxeVgMyV228dWcEi4VKQE0TeXEkHM=;
        b=VnQSwHP0aCzzn/bkooXwQlNOcjXTKvM1HCwTOnRYgbOB05K1qlrZtBIW1R1bBI2wiA
         t+Rlj5hFAlhiE34nQnWplPtrdCYUg7hNjxtEzRZbhVe8slY/qLs5ykfBjvvzykB+O43N
         wBKpD47UvvUnUr6zNVM2NsWTFW2Pv89eQKGjqHV2c5hum2Claibue8f1A/quYNpbj4pm
         FXFq4V3qjUP5Inj4yNLkqcsnINITsDDPshxi20SySOLXcHwjI2KnOBzrbGr5XC8JSR/o
         H4W9CY/RKoeyJbsYErJqZJdLCrz7Bou63kwKwwrVqzrKUtfqyXwR4LWFYQuJkWz7d53T
         BG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hBPoJS3IZxT2JPLxeVgMyV228dWcEi4VKQE0TeXEkHM=;
        b=NMWQ5dqo3zX08x1BB+nu18UvgFaMNFhqA8lPRcnGthcgYNgpCdiTm7xbm6O9qHjNZO
         LagfG8Nh1mcysUKEguYcmFiHNcAcsmXbacCYDff8hu3luZ7j2Fmjl1rWdEUiNAP9NE6J
         94kReMb6mlK8b+S6H0W3lPj14NTiAGU5kjS5O2UxdveqLFS7qqyiyNYjca0XZIuJPjO1
         pALcwU6phyHk+Lxk5dFxx24kqu2lzIdvqCs2MS1jT01hVGXlJNtd/N3n2r3awLNpcW2z
         ZxxVWCyCEuVNGHaZZxtrmhuAG+RdRZvS0T45x7xN4WwTrzO90JMlAw6b2O8e9Nf2Z52P
         TEiA==
X-Gm-Message-State: APjAAAVlNV1/wjWnMfsVPoGW7sDm/01nq+d+8ObLI7y/xKDQPVPWQHHH
        6JMY1Cp0fAUkuk9ljjaEsKJEwpaDtvJor4sIlAFWOt85IfZsVxCpcGCt4aUmRygZiOP92RtLbzp
        GC7kwtFsgbKrkriO9r/dDOmzFVsotGQfdBPi2hn7MEjYzMLWNjSXQqv7r8N3xw3Sk0MbaZKLyTA
        ==
X-Google-Smtp-Source: APXvYqz7pdnTFqKaVyyAYnkh2m0NMZaKzpL709srS5gxfAvE8N8cdBePJTWbrq7qVLTQ52WG38w2+g==
X-Received: by 2002:adf:db41:: with SMTP id f1mr7995766wrj.392.1576174633782;
        Thu, 12 Dec 2019 10:17:13 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id j21sm7928736wmj.39.2019.12.12.10.17.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 10:17:13 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 7/9] nfp: flower: handle notifiers for ipv6 route changes
Date:   Thu, 12 Dec 2019 18:16:54 +0000
Message-Id: <1576174616-9738-8-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
References: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A notifier is used to track route changes in the kernel. If a change is
made to a route that is offloaded to fw then an update is sent to the NIC.
The driver tracks all routes that are offloaded to determine if a kernel
change is of interest.

Extend the notifier to track IPv6 route changes and create a new list that
stores offloaded IPv6 routes. Modify the IPv4 route helper functions to
accept varying address lengths. This way, the same core functions can be
used to handle IPv4 and IPv6.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  12 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 236 +++++++++++++++------
 2 files changed, 180 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 01e1886..7a46032 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -64,10 +64,12 @@ struct nfp_fl_stats_id {
  * @offloaded_macs:	Hashtable of the offloaded MAC addresses
  * @ipv4_off_list:	List of IPv4 addresses to offload
  * @ipv6_off_list:	List of IPv6 addresses to offload
- * @neigh_off_list:	List of neighbour offloads
+ * @neigh_off_list_v4:	List of IPv4 neighbour offloads
+ * @neigh_off_list_v6:	List of IPv6 neighbour offloads
  * @ipv4_off_lock:	Lock for the IPv4 address list
  * @ipv6_off_lock:	Lock for the IPv6 address list
- * @neigh_off_lock:	Lock for the neighbour address list
+ * @neigh_off_lock_v4:	Lock for the IPv4 neighbour address list
+ * @neigh_off_lock_v6:	Lock for the IPv6 neighbour address list
  * @mac_off_ids:	IDA to manage id assignment for offloaded MACs
  * @neigh_nb:		Notifier to monitor neighbour state
  */
@@ -75,10 +77,12 @@ struct nfp_fl_tunnel_offloads {
 	struct rhashtable offloaded_macs;
 	struct list_head ipv4_off_list;
 	struct list_head ipv6_off_list;
-	struct list_head neigh_off_list;
+	struct list_head neigh_off_list_v4;
+	struct list_head neigh_off_list_v6;
 	struct mutex ipv4_off_lock;
 	struct mutex ipv6_off_lock;
-	spinlock_t neigh_off_lock;
+	spinlock_t neigh_off_lock_v4;
+	spinlock_t neigh_off_lock_v6;
 	struct ida mac_off_ids;
 	struct notifier_block neigh_nb;
 };
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 09807b3..0eaaa637 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -109,13 +109,13 @@ struct nfp_tun_req_route_ipv6 {
 };
 
 /**
- * struct nfp_ipv4_route_entry - routes that are offloaded to the NFP
- * @ipv4_addr:	destination of route
+ * struct nfp_offloaded_route - routes that are offloaded to the NFP
  * @list:	list pointer
+ * @ip_add:	destination of route - can be IPv4 or IPv6
  */
-struct nfp_ipv4_route_entry {
-	__be32 ipv4_addr;
+struct nfp_offloaded_route {
 	struct list_head list;
+	u8 ip_add[];
 };
 
 #define NFP_FL_IPV4_ADDRS_MAX        32
@@ -262,66 +262,121 @@ nfp_flower_xmit_tun_conf(struct nfp_app *app, u8 mtype, u16 plen, void *pdata,
 	return 0;
 }
 
-static bool nfp_tun_has_route(struct nfp_app *app, __be32 ipv4_addr)
+static bool
+__nfp_tun_has_route(struct list_head *route_list, spinlock_t *list_lock,
+		    void *add, int add_len)
 {
-	struct nfp_flower_priv *priv = app->priv;
-	struct nfp_ipv4_route_entry *entry;
-	struct list_head *ptr, *storage;
+	struct nfp_offloaded_route *entry;
 
-	spin_lock_bh(&priv->tun.neigh_off_lock);
-	list_for_each_safe(ptr, storage, &priv->tun.neigh_off_list) {
-		entry = list_entry(ptr, struct nfp_ipv4_route_entry, list);
-		if (entry->ipv4_addr == ipv4_addr) {
-			spin_unlock_bh(&priv->tun.neigh_off_lock);
+	spin_lock_bh(list_lock);
+	list_for_each_entry(entry, route_list, list)
+		if (!memcmp(entry->ip_add, add, add_len)) {
+			spin_unlock_bh(list_lock);
 			return true;
 		}
-	}
-	spin_unlock_bh(&priv->tun.neigh_off_lock);
+	spin_unlock_bh(list_lock);
 	return false;
 }
 
-static void nfp_tun_add_route_to_cache(struct nfp_app *app, __be32 ipv4_addr)
+static int
+__nfp_tun_add_route_to_cache(struct list_head *route_list,
+			     spinlock_t *list_lock, void *add, int add_len)
 {
-	struct nfp_flower_priv *priv = app->priv;
-	struct nfp_ipv4_route_entry *entry;
-	struct list_head *ptr, *storage;
+	struct nfp_offloaded_route *entry;
 
-	spin_lock_bh(&priv->tun.neigh_off_lock);
-	list_for_each_safe(ptr, storage, &priv->tun.neigh_off_list) {
-		entry = list_entry(ptr, struct nfp_ipv4_route_entry, list);
-		if (entry->ipv4_addr == ipv4_addr) {
-			spin_unlock_bh(&priv->tun.neigh_off_lock);
-			return;
+	spin_lock_bh(list_lock);
+	list_for_each_entry(entry, route_list, list)
+		if (!memcmp(entry->ip_add, add, add_len)) {
+			spin_unlock_bh(list_lock);
+			return 0;
 		}
-	}
-	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+
+	entry = kmalloc(sizeof(*entry) + add_len, GFP_ATOMIC);
 	if (!entry) {
-		spin_unlock_bh(&priv->tun.neigh_off_lock);
-		nfp_flower_cmsg_warn(app, "Mem error when storing new route.\n");
-		return;
+		spin_unlock_bh(list_lock);
+		return -ENOMEM;
 	}
 
-	entry->ipv4_addr = ipv4_addr;
-	list_add_tail(&entry->list, &priv->tun.neigh_off_list);
-	spin_unlock_bh(&priv->tun.neigh_off_lock);
+	memcpy(entry->ip_add, add, add_len);
+	list_add_tail(&entry->list, route_list);
+	spin_unlock_bh(list_lock);
+
+	return 0;
 }
 
-static void nfp_tun_del_route_from_cache(struct nfp_app *app, __be32 ipv4_addr)
+static void
+__nfp_tun_del_route_from_cache(struct list_head *route_list,
+			       spinlock_t *list_lock, void *add, int add_len)
 {
-	struct nfp_flower_priv *priv = app->priv;
-	struct nfp_ipv4_route_entry *entry;
-	struct list_head *ptr, *storage;
+	struct nfp_offloaded_route *entry;
 
-	spin_lock_bh(&priv->tun.neigh_off_lock);
-	list_for_each_safe(ptr, storage, &priv->tun.neigh_off_list) {
-		entry = list_entry(ptr, struct nfp_ipv4_route_entry, list);
-		if (entry->ipv4_addr == ipv4_addr) {
+	spin_lock_bh(list_lock);
+	list_for_each_entry(entry, route_list, list)
+		if (!memcmp(entry->ip_add, add, add_len)) {
 			list_del(&entry->list);
 			kfree(entry);
 			break;
 		}
-	}
-	spin_unlock_bh(&priv->tun.neigh_off_lock);
+	spin_unlock_bh(list_lock);
+}
+
+static bool nfp_tun_has_route_v4(struct nfp_app *app, __be32 *ipv4_addr)
+{
+	struct nfp_flower_priv *priv = app->priv;
+
+	return __nfp_tun_has_route(&priv->tun.neigh_off_list_v4,
+				   &priv->tun.neigh_off_lock_v4, ipv4_addr,
+				   sizeof(*ipv4_addr));
+}
+
+static bool
+nfp_tun_has_route_v6(struct nfp_app *app, struct in6_addr *ipv6_addr)
+{
+	struct nfp_flower_priv *priv = app->priv;
+
+	return __nfp_tun_has_route(&priv->tun.neigh_off_list_v6,
+				   &priv->tun.neigh_off_lock_v6, ipv6_addr,
+				   sizeof(*ipv6_addr));
+}
+
+static void
+nfp_tun_add_route_to_cache_v4(struct nfp_app *app, __be32 *ipv4_addr)
+{
+	struct nfp_flower_priv *priv = app->priv;
+
+	__nfp_tun_add_route_to_cache(&priv->tun.neigh_off_list_v4,
+				     &priv->tun.neigh_off_lock_v4, ipv4_addr,
+				     sizeof(*ipv4_addr));
+}
+
+static void
+nfp_tun_add_route_to_cache_v6(struct nfp_app *app, struct in6_addr *ipv6_addr)
+{
+	struct nfp_flower_priv *priv = app->priv;
+
+	__nfp_tun_add_route_to_cache(&priv->tun.neigh_off_list_v6,
+				     &priv->tun.neigh_off_lock_v6, ipv6_addr,
+				     sizeof(*ipv6_addr));
+}
+
+static void
+nfp_tun_del_route_from_cache_v4(struct nfp_app *app, __be32 *ipv4_addr)
+{
+	struct nfp_flower_priv *priv = app->priv;
+
+	__nfp_tun_del_route_from_cache(&priv->tun.neigh_off_list_v4,
+				       &priv->tun.neigh_off_lock_v4, ipv4_addr,
+				       sizeof(*ipv4_addr));
+}
+
+static void
+nfp_tun_del_route_from_cache_v6(struct nfp_app *app, struct in6_addr *ipv6_addr)
+{
+	struct nfp_flower_priv *priv = app->priv;
+
+	__nfp_tun_del_route_from_cache(&priv->tun.neigh_off_list_v6,
+				       &priv->tun.neigh_off_lock_v6, ipv6_addr,
+				       sizeof(*ipv6_addr));
 }
 
 static void
@@ -340,7 +395,7 @@ nfp_tun_write_neigh_v4(struct net_device *netdev, struct nfp_app *app,
 
 	/* If entry has expired send dst IP with all other fields 0. */
 	if (!(neigh->nud_state & NUD_VALID) || neigh->dead) {
-		nfp_tun_del_route_from_cache(app, payload.dst_ipv4);
+		nfp_tun_del_route_from_cache_v4(app, &payload.dst_ipv4);
 		/* Trigger ARP to verify invalid neighbour state. */
 		neigh_event_send(neigh, NULL);
 		goto send_msg;
@@ -352,7 +407,7 @@ nfp_tun_write_neigh_v4(struct net_device *netdev, struct nfp_app *app,
 	neigh_ha_snapshot(payload.dst_addr, neigh, netdev);
 	payload.port_id = cpu_to_be32(port_id);
 	/* Add destination of new route to NFP cache. */
-	nfp_tun_add_route_to_cache(app, payload.dst_ipv4);
+	nfp_tun_add_route_to_cache_v4(app, &payload.dst_ipv4);
 
 send_msg:
 	nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH,
@@ -376,6 +431,7 @@ nfp_tun_write_neigh_v6(struct net_device *netdev, struct nfp_app *app,
 
 	/* If entry has expired send dst IP with all other fields 0. */
 	if (!(neigh->nud_state & NUD_VALID) || neigh->dead) {
+		nfp_tun_del_route_from_cache_v6(app, &payload.dst_ipv6);
 		/* Trigger probe to verify invalid neighbour state. */
 		neigh_event_send(neigh, NULL);
 		goto send_msg;
@@ -386,6 +442,8 @@ nfp_tun_write_neigh_v6(struct net_device *netdev, struct nfp_app *app,
 	ether_addr_copy(payload.src_addr, netdev->dev_addr);
 	neigh_ha_snapshot(payload.dst_addr, neigh, netdev);
 	payload.port_id = cpu_to_be32(port_id);
+	/* Add destination of new route to NFP cache. */
+	nfp_tun_add_route_to_cache_v6(app, &payload.dst_ipv6);
 
 send_msg:
 	nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6,
@@ -399,10 +457,13 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 {
 	struct nfp_flower_priv *app_priv;
 	struct netevent_redirect *redir;
-	struct flowi4 flow = {};
+	struct flowi4 flow4 = {};
+	struct flowi6 flow6 = {};
+	struct dst_entry *dst;
 	struct neighbour *n;
 	struct nfp_app *app;
 	struct rtable *rt;
+	bool ipv6 = false;
 	int err;
 
 	switch (event) {
@@ -417,7 +478,13 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 		return NOTIFY_DONE;
 	}
 
-	flow.daddr = *(__be32 *)n->primary_key;
+	if (n->tbl->family == AF_INET6)
+		ipv6 = true;
+
+	if (ipv6)
+		flow6.daddr = *(struct in6_addr *)n->primary_key;
+	else
+		flow4.daddr = *(__be32 *)n->primary_key;
 
 	app_priv = container_of(nb, struct nfp_flower_priv, tun.neigh_nb);
 	app = app_priv->app;
@@ -427,23 +494,39 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 		return NOTIFY_DONE;
 
 	/* Only concerned with changes to routes already added to NFP. */
-	if (!nfp_tun_has_route(app, flow.daddr))
+	if ((ipv6 && !nfp_tun_has_route_v6(app, &flow6.daddr)) ||
+	    (!ipv6 && !nfp_tun_has_route_v4(app, &flow4.daddr)))
 		return NOTIFY_DONE;
 
 #if IS_ENABLED(CONFIG_INET)
-	/* Do a route lookup to populate flow data. */
-	rt = ip_route_output_key(dev_net(n->dev), &flow);
-	err = PTR_ERR_OR_ZERO(rt);
-	if (err)
+	if (ipv6) {
+#if IS_ENABLED(CONFIG_IPV6)
+		dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(n->dev), NULL,
+						      &flow6, NULL);
+		if (IS_ERR(dst))
+			return NOTIFY_DONE;
+
+		dst_release(dst);
+		flow6.flowi6_proto = IPPROTO_UDP;
+		nfp_tun_write_neigh_v6(n->dev, app, &flow6, n, GFP_ATOMIC);
+#else
 		return NOTIFY_DONE;
+#endif /* CONFIG_IPV6 */
+	} else {
+		/* Do a route lookup to populate flow data. */
+		rt = ip_route_output_key(dev_net(n->dev), &flow4);
+		err = PTR_ERR_OR_ZERO(rt);
+		if (err)
+			return NOTIFY_DONE;
 
-	ip_rt_put(rt);
+		ip_rt_put(rt);
+
+		flow4.flowi4_proto = IPPROTO_UDP;
+		nfp_tun_write_neigh_v4(n->dev, app, &flow4, n, GFP_ATOMIC);
+	}
 #else
 	return NOTIFY_DONE;
-#endif
-
-	flow.flowi4_proto = IPPROTO_UDP;
-	nfp_tun_write_neigh_v4(n->dev, app, &flow, n, GFP_ATOMIC);
+#endif /* CONFIG_INET */
 
 	return NOTIFY_OK;
 }
@@ -1205,8 +1288,10 @@ int nfp_tunnel_config_start(struct nfp_app *app)
 	INIT_LIST_HEAD(&priv->tun.ipv6_off_list);
 
 	/* Initialise priv data for neighbour offloading. */
-	spin_lock_init(&priv->tun.neigh_off_lock);
-	INIT_LIST_HEAD(&priv->tun.neigh_off_list);
+	spin_lock_init(&priv->tun.neigh_off_lock_v4);
+	INIT_LIST_HEAD(&priv->tun.neigh_off_list_v4);
+	spin_lock_init(&priv->tun.neigh_off_lock_v6);
+	INIT_LIST_HEAD(&priv->tun.neigh_off_list_v6);
 	priv->tun.neigh_nb.notifier_call = nfp_tun_neigh_event_handler;
 
 	err = register_netevent_notifier(&priv->tun.neigh_nb);
@@ -1221,9 +1306,11 @@ int nfp_tunnel_config_start(struct nfp_app *app)
 
 void nfp_tunnel_config_stop(struct nfp_app *app)
 {
+	struct nfp_offloaded_route *route_entry, *temp;
 	struct nfp_flower_priv *priv = app->priv;
-	struct nfp_ipv4_route_entry *route_entry;
 	struct nfp_ipv4_addr_entry *ip_entry;
+	struct nfp_tun_neigh_v6 ipv6_route;
+	struct nfp_tun_neigh ipv4_route;
 	struct list_head *ptr, *storage;
 
 	unregister_netevent_notifier(&priv->tun.neigh_nb);
@@ -1239,12 +1326,33 @@ void nfp_tunnel_config_stop(struct nfp_app *app)
 
 	mutex_destroy(&priv->tun.ipv6_off_lock);
 
-	/* Free any memory that may be occupied by the route list. */
-	list_for_each_safe(ptr, storage, &priv->tun.neigh_off_list) {
-		route_entry = list_entry(ptr, struct nfp_ipv4_route_entry,
-					 list);
+	/* Free memory in the route list and remove entries from fw cache. */
+	list_for_each_entry_safe(route_entry, temp,
+				 &priv->tun.neigh_off_list_v4, list) {
+		memset(&ipv4_route, 0, sizeof(ipv4_route));
+		memcpy(&ipv4_route.dst_ipv4, &route_entry->ip_add,
+		       sizeof(ipv4_route.dst_ipv4));
 		list_del(&route_entry->list);
 		kfree(route_entry);
+
+		nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH,
+					 sizeof(struct nfp_tun_neigh),
+					 (unsigned char *)&ipv4_route,
+					 GFP_KERNEL);
+	}
+
+	list_for_each_entry_safe(route_entry, temp,
+				 &priv->tun.neigh_off_list_v6, list) {
+		memset(&ipv6_route, 0, sizeof(ipv6_route));
+		memcpy(&ipv6_route.dst_ipv6, &route_entry->ip_add,
+		       sizeof(ipv6_route.dst_ipv6));
+		list_del(&route_entry->list);
+		kfree(route_entry);
+
+		nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6,
+					 sizeof(struct nfp_tun_neigh),
+					 (unsigned char *)&ipv6_route,
+					 GFP_KERNEL);
 	}
 
 	/* Destroy rhash. Entries should be cleaned on netdev notifier unreg. */
-- 
2.7.4

