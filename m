Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4A26CB465
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjC1C6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC1C6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:58:05 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2CB1BFF
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 19:58:03 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pgzX5-009Nng-3N; Tue, 28 Mar 2023 10:58:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Mar 2023 10:57:59 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Mar 2023 10:57:59 +0800
Subject: [PATCH 2/2] macvlan: Add netlink attribute for broadcast cutoff
References: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
To:     netdev@vger.kernel.org
Message-Id: <E1pgzX5-009Nng-3N@formenos.hmeau.com>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the broadcast cutoff configurable through netlink.  Note
that macvlan is weird because there is no central device for
us to configure (the lowerdev could be anything).  So all the
options are duplicated over what could be thousands of child
devices.

IFLA_MACVLAN_BC_QUEUE_LEN took the approach of taking the maximum
of all child device settings.  This is unnecessary as we could
simply store the option in the port device and take the last
child device that gets updated as the value to use.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/net/macvlan.c              |   31 +++++++++++++++++++++++++++++--
 include/uapi/linux/if_link.h       |    1 +
 tools/include/uapi/linux/if_link.h |    1 +
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 62b4748d3836..4215106adc40 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -47,6 +47,7 @@ struct macvlan_port {
 	struct sk_buff_head	bc_queue;
 	struct work_struct	bc_work;
 	u32			bc_queue_len_used;
+	int			bc_cutoff;
 	u32			flags;
 	int			count;
 	struct hlist_head	vlan_source_hash[MACVLAN_HASH_SIZE];
@@ -814,6 +815,12 @@ static void macvlan_compute_filter(unsigned long *mc_filter,
 	}
 }
 
+static void macvlan_recompute_bc_filter(struct macvlan_dev *vlan)
+{
+	macvlan_compute_filter(vlan->port->bc_filter, vlan->lowerdev, NULL,
+			       vlan->port->bc_cutoff);
+}
+
 static void macvlan_set_mac_lists(struct net_device *dev)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
@@ -838,8 +845,16 @@ static void macvlan_set_mac_lists(struct net_device *dev)
 	 */
 	macvlan_compute_filter(vlan->port->mc_filter, vlan->lowerdev, NULL,
 			       0);
-	macvlan_compute_filter(vlan->port->bc_filter, vlan->lowerdev, NULL,
-			       1);
+	macvlan_recompute_bc_filter(vlan);
+}
+
+static void update_port_bc_cutoff(struct macvlan_dev *vlan, int cutoff)
+{
+	if (vlan->port->bc_cutoff == cutoff)
+		return;
+
+	vlan->port->bc_cutoff = cutoff;
+	macvlan_recompute_bc_filter(vlan);
 }
 
 static int macvlan_change_mtu(struct net_device *dev, int new_mtu)
@@ -1254,6 +1269,7 @@ static int macvlan_port_create(struct net_device *dev)
 		INIT_HLIST_HEAD(&port->vlan_source_hash[i]);
 
 	port->bc_queue_len_used = 0;
+	port->bc_cutoff = 1;
 	skb_queue_head_init(&port->bc_queue);
 	INIT_WORK(&port->bc_work, macvlan_process_broadcast);
 
@@ -1527,6 +1543,10 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	if (data && data[IFLA_MACVLAN_BC_QUEUE_LEN])
 		vlan->bc_queue_len_req = nla_get_u32(data[IFLA_MACVLAN_BC_QUEUE_LEN]);
 
+	if (data && data[IFLA_MACVLAN_BC_CUTOFF])
+		update_port_bc_cutoff(
+			vlan, nla_get_s32(data[IFLA_MACVLAN_BC_CUTOFF]));
+
 	err = register_netdevice(dev);
 	if (err < 0)
 		goto destroy_macvlan_port;
@@ -1623,6 +1643,10 @@ static int macvlan_changelink(struct net_device *dev,
 		update_port_bc_queue_len(vlan->port);
 	}
 
+	if (data && data[IFLA_MACVLAN_BC_CUTOFF])
+		update_port_bc_cutoff(
+			vlan, nla_get_s32(data[IFLA_MACVLAN_BC_CUTOFF]));
+
 	if (set_mode)
 		vlan->mode = mode;
 	if (data && data[IFLA_MACVLAN_MACADDR_MODE]) {
@@ -1703,6 +1727,9 @@ static int macvlan_fill_info(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nla_put_u32(skb, IFLA_MACVLAN_BC_QUEUE_LEN_USED, port->bc_queue_len_used))
 		goto nla_put_failure;
+	if (port->bc_cutoff != 1 &&
+	    nla_put_s32(skb, IFLA_MACVLAN_BC_CUTOFF, port->bc_cutoff))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 57ceb788250f..8d679688efe0 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -635,6 +635,7 @@ enum {
 	IFLA_MACVLAN_MACADDR_COUNT,
 	IFLA_MACVLAN_BC_QUEUE_LEN,
 	IFLA_MACVLAN_BC_QUEUE_LEN_USED,
+	IFLA_MACVLAN_BC_CUTOFF,
 	__IFLA_MACVLAN_MAX,
 };
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 901d98b865a1..39e659c83cfd 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -605,6 +605,7 @@ enum {
 	IFLA_MACVLAN_MACADDR_COUNT,
 	IFLA_MACVLAN_BC_QUEUE_LEN,
 	IFLA_MACVLAN_BC_QUEUE_LEN_USED,
+	IFLA_MACVLAN_BC_CUTOFF,
 	__IFLA_MACVLAN_MAX,
 };
 
