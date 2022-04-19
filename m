Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0D65070BB
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353496AbiDSOkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239196AbiDSOkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:40:14 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B33E2181B
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:37:31 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r187-20020a1c44c4000000b0038ccb70e239so1709122wma.3
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=apLaTEZZEAwI37R7bAYRVPalHy5HX+eTKkaH6HP8kI0=;
        b=Wmb1OzM10dFFXwZXNBU0w27+pZwLjo8obxZEVtTsBzVl2iE47Qz+KMZoYuk0z2Fix+
         MV47k/j6Dvzq4TDpwEENQ03AxQhfa6M61k++KngerRKAloU6UnE69A4dovIAN27qHGGn
         tF0H7YK7Re29vLwQ+NXzDYFNDCF0/SfaBPQlvhXYmPoFNoIGPpDHko1xw5ojiXnLBZ35
         cN9Qr6YFHd9ZZqF6ioKBjKZzP0wsfBdMWMgeUt9pqyu2bFgM0iFzrxY5PNH+6Ryox3qH
         SNIeYdMqAK0yqucO/7cCKsJCChD3sLxhzIQau99+a0FmpvjTgpY7wIQ1tugAbUWRCPr3
         dzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=apLaTEZZEAwI37R7bAYRVPalHy5HX+eTKkaH6HP8kI0=;
        b=Hk3JLdIROJfVYmxSIEddMTD+q1uX8jt+CkzW45GjHkdFcvV+tr7C80G1ID9GXG/GRl
         KqKzPRBCUqjczqX8fy0AfD6XW3/riHNDPgvzbiiBrK8v4luaxOSOh61RxxQqtqQaNMN7
         R6pln/Z7rOub33bGO/U3nBKZMvoT/GbYlwHZHyTTBiog1YzL7q/pJtqYRvlXMZYHnW/4
         Y6n1y/welvOTk89BG9+ro8XH2qhBJywr0D1qz7PIz7xCrf2ATzhwFLSMR45IU62A9H0B
         mdtNrIcact26lNLslJpHxWOskLJAUMH/vgYjXprGHWyEFrYUGGHrQmA9VHqUr7zT7kwu
         uL4Q==
X-Gm-Message-State: AOAM531EzPSBwqCw3WACPxtVQVX97eRKz7X0RKFq5upR3EO+ReZtUyXU
        MFEAoI/XQAb3iZXzCrISId8Yl9ZxT3fzCQ==
X-Google-Smtp-Source: ABdhPJw1+H8kRqOZ+tS+Y5HtU/db6BLD4N/0hBMASzP/e70ankwuor1R9rVIX+DSV9XQprmGQeSFQQ==
X-Received: by 2002:a1c:a181:0:b0:392:8f7e:d2f8 with SMTP id k123-20020a1ca181000000b003928f7ed2f8mr13696018wme.30.1650379049841;
        Tue, 19 Apr 2022 07:37:29 -0700 (PDT)
Received: from alaa-emad ([102.41.109.205])
        by smtp.gmail.com with ESMTPSA id i74-20020adf90d0000000b0020373ba7beesm15196863wri.0.2022.04.19.07.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 07:37:29 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com,
        roopa.prabhu@gmail.com, jdenham@redhat.com, sbrivio@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next 1/2] rtnetlink: add extack support in fdb del handlers
Date:   Tue, 19 Apr 2022 16:37:17 +0200
Message-Id: <0d0a044357731a534f111a77783d35d2e4cf6474.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
References: <cover.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
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

Add extack support to .ndo_fdb_del in netdevice.h and
all related methods.

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c        | 2 +-
 drivers/net/ethernet/mscc/ocelot_net.c           | 4 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 +-
 drivers/net/macvlan.c                            | 2 +-
 drivers/net/vxlan/vxlan_core.c                   | 2 +-
 include/linux/netdevice.h                        | 2 +-
 net/bridge/br_fdb.c                              | 2 +-
 net/bridge/br_private.h                          | 2 +-
 net/core/rtnetlink.c                             | 4 ++--
 9 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d768925785ca..4fd32163729e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5678,7 +5678,7 @@ ice_fdb_add(struct ndmsg *ndm, struct nlattr __always_unused *tb[],
 static int
 ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
 	    struct net_device *dev, const unsigned char *addr,
-	    __always_unused u16 vid)
+	    __always_unused u16 vid, struct netlink_ext_ack *extack)
 {
	int err;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 247bc105bdd2..e07c64e3159c 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -774,14 +774,14 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],

 static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			       struct net_device *dev,
-			       const unsigned char *addr, u16 vid)
+			       const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;

-	return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge);
+	return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge, extack);
 }

 static int ocelot_port_fdb_dump(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index d320567b2cca..51fa23418f6a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -368,7 +368,7 @@ static int qlcnic_set_mac(struct net_device *netdev, void *p)

 static int qlcnic_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			struct net_device *netdev,
-			const unsigned char *addr, u16 vid)
+			const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 	int err = -EOPNOTSUPP;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 069e8824c264..ffd34d9f7049 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1017,7 +1017,7 @@ static int macvlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],

 static int macvlan_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			   struct net_device *dev,
-			   const unsigned char *addr, u16 vid)
+			   const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	int err = -EINVAL;
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index de97ff98d36e..cf2f60037340 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1280,7 +1280,7 @@ int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
 /* Delete entry (via netlink) */
 static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 			    struct net_device *dev,
-			    const unsigned char *addr, u16 vid)
+			    const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	union vxlan_addr ip;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 28ea4f8269d4..d0d2a8f33c73 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1509,7 +1509,7 @@ struct net_device_ops {
 					       struct nlattr *tb[],
 					       struct net_device *dev,
 					       const unsigned char *addr,
-					       u16 vid);
+					       u16 vid, struct netlink_ext_ack *extack);
 	int			(*ndo_fdb_dump)(struct sk_buff *skb,
 						struct netlink_callback *cb,
 						struct net_device *dev,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..5bfce2e9a553 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1110,7 +1110,7 @@ static int __br_fdb_delete(struct net_bridge *br,
 /* Remove neighbor entry with RTM_DELNEIGH */
 int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 		  struct net_device *dev,
-		  const unsigned char *addr, u16 vid)
+		  const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *p = NULL;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 18ccc3d5d296..95348c1c9ce5 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -780,7 +780,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 		   const unsigned char *addr, u16 vid, unsigned long flags);

 int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
-		  struct net_device *dev, const unsigned char *addr, u16 vid);
+		  struct net_device *dev, const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack);
 int br_fdb_add(struct ndmsg *nlh, struct nlattr *tb[], struct net_device *dev,
 	       const unsigned char *addr, u16 vid, u16 nlh_flags,
 	       struct netlink_ext_ack *extack);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4041b3e2e8ec..99b30ae58a47 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4223,7 +4223,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		const struct net_device_ops *ops = br_dev->netdev_ops;

 		if (ops->ndo_fdb_del)
-			err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
+			err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid, extack);

 		if (err)
 			goto out;
@@ -4235,7 +4235,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ndm->ndm_flags & NTF_SELF) {
 		if (dev->netdev_ops->ndo_fdb_del)
 			err = dev->netdev_ops->ndo_fdb_del(ndm, tb, dev, addr,
-							   vid);
+							   vid, extack);
 		else
 			err = ndo_dflt_fdb_del(ndm, tb, dev, addr, vid);

--
2.35.2

