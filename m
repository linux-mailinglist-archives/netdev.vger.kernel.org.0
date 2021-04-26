Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61AE36B779
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbhDZRFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbhDZRFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:05:32 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0704C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:49 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id u20so64975533lja.13
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=LtsleOeb+xmEjnjVcOQVav1US/7Y1octau7gSB29ozs=;
        b=H+AhWmPpTmJe8HW0sbNeE+T8GJrZ3C84h99VtOMsch+btpamSpove6N3BbUrp7Una1
         XGzSxCBwm2TTaV4Lx8pI9se03vYQb5KroqreADw0pZuwtiBFFmGDsduoG/o4WcNCBNx+
         mjFDGcA78oqeghApMKAXmxhW09cQM0Wp6bSfvfxdxghMG047Skc7bTUyR6TJa0xhWSsE
         7xWS/ASH7cjm6dLOzRkdap/LxgbGX419d/Duvx4AN62QWIbGFuQQsoGSI2IhesR8tz8Q
         YnRzbx67utWgkfcgskuR32xjAGETPg2NuTRSkaPTn6maU/UcDZbGtZ6F2uGqkSVktzPo
         GNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=LtsleOeb+xmEjnjVcOQVav1US/7Y1octau7gSB29ozs=;
        b=m9HC8Kq8OygwQbBPeD13ceewygxkhJFhL7saLTVS3GX+IHOBpKvhTppxODoAA11Z/Q
         VyhBfAeKiB/2JAvnTatGvBwrDx5090ZuNKk3x8iX4MQo1RT0a7+G6+q3Fw0e8AKyqOpO
         oSg4DvQ0cXMHCRQQFotQK06Ct+731ADTVLrTDDHyZmym9z1xtCjR/+4LXRyFEHuP/JbR
         RmjroZN/KgSNDYcBNRdIHhPmL4BGetuG/J0T6oq/7rzMy01JTKQXy4RfW7lDDgO7AHx+
         G50jnoLMvsmR81TZEKxj7pdQ2Itb3QGMIWRHh4XO/hDgLN+XHG1SJ5WqgWZQc9pRA22+
         DsZQ==
X-Gm-Message-State: AOAM531Jupls612l383JYgP3GBG0HyMDR21kUBfMDdDGDJOhqPNUTdWb
        vs8Ykg/3GFDQR7WigkPymM8A/w==
X-Google-Smtp-Source: ABdhPJzS+q86QG1WC4CA1enp1D8sx/7jIVDECKuvXOkXhP8wiuyPwezscYlfYxpfSJVQuEwFBBJNNA==
X-Received: by 2002:a2e:555:: with SMTP id 82mr13793764ljf.200.1619456688259;
        Mon, 26 Apr 2021 10:04:48 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c18sm59140ljd.66.2021.04.26.10.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 10:04:47 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@resnulli.us, idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [RFC net-next 2/9] net: bridge: Disambiguate offload_fwd_mark
Date:   Mon, 26 Apr 2021 19:04:04 +0200
Message-Id: <20210426170411.1789186-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426170411.1789186-1-tobias@waldekranz.com>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this change, four related - but distinct - concepts where named
offload_fwd_mark:

- skb->offload_fwd_mark: Set by the switchdev driver if the underlying
  hardware has already forwarded this frame to the other ports in the
  same hardware domain.

- nbp->offload_fwd_mark: An idetifier used to group ports that share
  the same hardware forwarding domain.

- br->offload_fwd_mark: Counter used to make sure that unique IDs are
  used in cases where a bridge contains ports from multiple hardware
  domains.

- skb->cb->offload_fwd_mark: The hardware domain on which the frame
  ingressed and was forwarded.

Introduce the term "hardware forwarding domain" ("hwdom") in the
bridge to denote a set of ports with the following property:

    If an skb with skb->offload_fwd_mark set, is received on a port
    belonging to hwdom N, that frame has already been forwarded to all
    other ports in hwdom N.

By decoupling the name from "offload_fwd_mark", we can extend the
term's definition in the future - e.g. to add constraints that
describe expected egress behavior - without overloading the meaning of
"offload_fwd_mark".

- nbp->offload_fwd_mark thus becomes nbp->hwdom.

- br->offload_fwd_mark becomes br->last_hwdom.

- skb->cb->offload_fwd_mark becomes skb->cb->src_hwdom. There is a
  slight change here: Whereas previously this was only set for
  offloaded packets, we now always track the incoming hwdom. As all
  uses where already gated behind checks of skb->offload_fwd_mark,
  this will not introduce any functional change, but it paves the way
  for future changes where the ingressing hwdom must be known both for
  offloaded and non-offloaded frames.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/bridge/br_if.c        |  2 +-
 net/bridge/br_private.h   | 10 +++++-----
 net/bridge/br_switchdev.c | 16 ++++++++--------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f7d2f472ae24..73fa703f8df5 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -643,7 +643,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	if (err)
 		goto err5;
 
-	err = nbp_switchdev_mark_set(p);
+	err = nbp_switchdev_hwdom_set(p);
 	if (err)
 		goto err6;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7ce8a77cc6b6..53248715f631 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -327,7 +327,7 @@ struct net_bridge_port {
 	struct netpoll			*np;
 #endif
 #ifdef CONFIG_NET_SWITCHDEV
-	int				offload_fwd_mark;
+	int				hwdom;
 #endif
 	u16				group_fwd_mask;
 	u16				backup_redirected_cnt;
@@ -472,7 +472,7 @@ struct net_bridge {
 	u32				auto_cnt;
 
 #ifdef CONFIG_NET_SWITCHDEV
-	int offload_fwd_mark;
+	int last_hwdom;
 #endif
 	struct hlist_head		fdb_list;
 
@@ -502,7 +502,7 @@ struct br_input_skb_cb {
 #endif
 
 #ifdef CONFIG_NET_SWITCHDEV
-	int offload_fwd_mark;
+	int src_hwdom;
 #endif
 };
 
@@ -1593,7 +1593,7 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_mark_set(struct net_bridge_port *p);
+int nbp_switchdev_hwdom_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1613,7 +1613,7 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
-static inline int nbp_switchdev_mark_set(struct net_bridge_port *p)
+static inline int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
 {
 	return 0;
 }
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a5e601e41cb9..bc085077ae71 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,20 +8,20 @@
 
 #include "br_private.h"
 
-static int br_switchdev_mark_get(struct net_bridge *br, struct net_device *dev)
+static int br_switchdev_hwdom_get(struct net_bridge *br, struct net_device *dev)
 {
 	struct net_bridge_port *p;
 
 	/* dev is yet to be added to the port list. */
 	list_for_each_entry(p, &br->port_list, list) {
 		if (netdev_port_same_parent_id(dev, p->dev))
-			return p->offload_fwd_mark;
+			return p->hwdom;
 	}
 
-	return ++br->offload_fwd_mark;
+	return ++br->last_hwdom;
 }
 
-int nbp_switchdev_mark_set(struct net_bridge_port *p)
+int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
 {
 	struct netdev_phys_item_id ppid = { };
 	int err;
@@ -35,7 +35,7 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
 		return err;
 	}
 
-	p->offload_fwd_mark = br_switchdev_mark_get(p->br, p->dev);
+	p->hwdom = br_switchdev_hwdom_get(p->br, p->dev);
 
 	return 0;
 }
@@ -43,15 +43,15 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
 {
-	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
-		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
+	if (p->hwdom)
+		BR_INPUT_SKB_CB(skb)->src_hwdom = p->hwdom;
 }
 
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb)
 {
 	return !skb->offload_fwd_mark ||
-	       BR_INPUT_SKB_CB(skb)->offload_fwd_mark != p->offload_fwd_mark;
+	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
 }
 
 /* Flags that can be offloaded to hardware */
-- 
2.25.1

