Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090EF599E8A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349763AbiHSPcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349756AbiHSPcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:32:43 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BB0101C53
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 08:32:41 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oP3wc-00Gb30-6R;
        Fri, 19 Aug 2022 17:31:21 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org, mark.d.gray@redhat.com,
        i.maximets@ovn.org, aconole@redhat.com
Subject: [PATCH net-next v2 1/3] openvswitch: allow specifying ifindex of new interfaces
Date:   Fri, 19 Aug 2022 18:30:42 +0300
Message-Id: <20220819153044.423233-2-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
References: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CRIU is preserving ifindexes of net devices after restoration. However,
current Open vSwitch API does not allow to target ifindex, so we cannot
correctly restore OVS configuration.

Use ovs_header->dp_ifindex during OVS_DP_CMD_NEW as desired ifindex.
Use OVS_VPORT_ATTR_IFINDEX during OVS_VPORT_CMD_NEW to specify new netdev
ifindex.

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 include/uapi/linux/openvswitch.h     |  4 ++++
 net/openvswitch/datapath.c           | 16 ++++++++++++++--
 net/openvswitch/vport-internal_dev.c |  1 +
 net/openvswitch/vport.h              |  2 ++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index ce3e1738d427..8ec82b63f85d 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -79,6 +79,10 @@ enum ovs_datapath_cmd {
  *
  * These attributes follow the &struct ovs_header within the Generic Netlink
  * payload for %OVS_DP_* commands.
+ *
+ * %OVS_DP_CMD_NEW requests will try to create net device with ifindex
+ * specified in dp_ifindex. With dp_infindex == 0 any available number will
+ * be chosen.
  */
 enum ovs_datapath_attr {
 	OVS_DP_ATTR_UNSPEC,
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 7e8a39a35627..8033c97a8d65 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1739,6 +1739,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	struct vport *vport;
 	struct ovs_net *ovs_net;
 	int err;
+	struct ovs_header *ovs_header = info->userhdr;
 
 	err = -EINVAL;
 	if (!a[OVS_DP_ATTR_NAME] || !a[OVS_DP_ATTR_UPCALL_PID])
@@ -1779,6 +1780,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	parms.dp = dp;
 	parms.port_no = OVSP_LOCAL;
 	parms.upcall_portids = a[OVS_DP_ATTR_UPCALL_PID];
+	parms.desired_ifindex = ovs_header->dp_ifindex;
 
 	/* So far only local changes have been made, now need the lock. */
 	ovs_lock();
@@ -2199,7 +2201,10 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	if (!a[OVS_VPORT_ATTR_NAME] || !a[OVS_VPORT_ATTR_TYPE] ||
 	    !a[OVS_VPORT_ATTR_UPCALL_PID])
 		return -EINVAL;
-	if (a[OVS_VPORT_ATTR_IFINDEX])
+
+	parms.type = nla_get_u32(a[OVS_VPORT_ATTR_TYPE]);
+
+	if (a[OVS_VPORT_ATTR_IFINDEX] && parms.type != OVS_VPORT_TYPE_INTERNAL)
 		return -EOPNOTSUPP;
 
 	port_no = a[OVS_VPORT_ATTR_PORT_NO]
@@ -2236,12 +2241,19 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	parms.name = nla_data(a[OVS_VPORT_ATTR_NAME]);
-	parms.type = nla_get_u32(a[OVS_VPORT_ATTR_TYPE]);
 	parms.options = a[OVS_VPORT_ATTR_OPTIONS];
 	parms.dp = dp;
 	parms.port_no = port_no;
 	parms.upcall_portids = a[OVS_VPORT_ATTR_UPCALL_PID];
 
+	if (parms.type == OVS_VPORT_TYPE_INTERNAL) {
+		if (a[OVS_VPORT_ATTR_IFINDEX])
+			parms.desired_ifindex =
+				nla_get_u32(a[OVS_VPORT_ATTR_IFINDEX]);
+		else
+			parms.desired_ifindex = 0;
+	}
+
 	vport = new_vport(&parms);
 	err = PTR_ERR(vport);
 	if (IS_ERR(vport)) {
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 5b2ee9c1c00b..2ab8a7e06d4b 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -154,6 +154,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 	if (vport->port_no == OVSP_LOCAL)
 		vport->dev->features |= NETIF_F_NETNS_LOCAL;
 
+	dev->ifindex = parms->desired_ifindex;
 	rtnl_lock();
 	err = register_netdevice(vport->dev);
 	if (err)
diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 9de5030d9801..24e1cba2f1ac 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -98,6 +98,8 @@ struct vport_parms {
 	enum ovs_vport_type type;
 	struct nlattr *options;
 
+	int desired_ifindex;
+
 	/* For ovs_vport_alloc(). */
 	struct datapath *dp;
 	u16 port_no;
-- 
2.31.1

