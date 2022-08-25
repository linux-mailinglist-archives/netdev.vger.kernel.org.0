Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8ED5A0717
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbiHYCF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbiHYCFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:05:55 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF4E1C934
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:05:54 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oR2EC-0002yC-NI;
        Thu, 25 Aug 2022 04:05:52 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org, i.maximets@ovn.org,
        aconole@redhat.com
Subject: [PATCH net-next v3 1/2] openvswitch: allow specifying ifindex of new interfaces
Date:   Thu, 25 Aug 2022 05:04:49 +0300
Message-Id: <20220825020450.664147-2-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220825020450.664147-1-andrey.zhadchenko@virtuozzo.com>
References: <20220825020450.664147-1-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CRIU is preserving ifindexes of net devices after restoration. However,
current Open vSwitch API does not allow to target ifindex, so we cannot
correctly restore OVS configuration.

Add new OVS_DP_ATTR_IFINDEX for OVS_DP_CMD_NEW and use it as desired
ifindex.
Use OVS_VPORT_ATTR_IFINDEX during OVS_VPORT_CMD_NEW to specify new netdev
ifindex.

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---

v3:
Added new OVS_DP_ATTR_IFINDEX instead of using ovs_header->dp_ifindex to
ensure we won't break existing software
Removed unnecessary OVS_VPORT_TYPE_INTERNAL check
Moved desired_ifindex in struct vport_parms for better padding.
Added some documentation

 include/uapi/linux/openvswitch.h     |  3 +++
 net/openvswitch/datapath.c           | 11 +++++++++--
 net/openvswitch/vport-internal_dev.c |  1 +
 net/openvswitch/vport.h              |  2 ++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index ce3e1738d427..94066f87e9ee 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -76,6 +76,8 @@ enum ovs_datapath_cmd {
  * datapath.  Always present in notifications.
  * @OVS_DP_ATTR_MEGAFLOW_STATS: Statistics about mega flow masks usage for the
  * datapath. Always present in notifications.
+ * @OVS_DP_ATTR_IFINDEX: Interface index for a new datapath netdev. Only
+ * valid for %OVS_DP_CMD_NEW requests.
  *
  * These attributes follow the &struct ovs_header within the Generic Netlink
  * payload for %OVS_DP_* commands.
@@ -92,6 +94,7 @@ enum ovs_datapath_attr {
 	OVS_DP_ATTR_PER_CPU_PIDS,   /* Netlink PIDS to receive upcalls in
 				     * per-cpu dispatch mode
 				     */
+	OVS_DP_ATTR_IFINDEX,
 	__OVS_DP_ATTR_MAX
 };
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 7e8a39a35627..2ca86b53c032 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1779,6 +1779,8 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	parms.dp = dp;
 	parms.port_no = OVSP_LOCAL;
 	parms.upcall_portids = a[OVS_DP_ATTR_UPCALL_PID];
+	parms.desired_ifindex = a[OVS_DP_ATTR_IFINDEX]
+		? nla_get_u32(a[OVS_DP_ATTR_IFINDEX]) : 0;
 
 	/* So far only local changes have been made, now need the lock. */
 	ovs_lock();
@@ -1996,6 +1998,7 @@ static const struct nla_policy datapath_policy[OVS_DP_ATTR_MAX + 1] = {
 	[OVS_DP_ATTR_USER_FEATURES] = { .type = NLA_U32 },
 	[OVS_DP_ATTR_MASKS_CACHE_SIZE] =  NLA_POLICY_RANGE(NLA_U32, 0,
 		PCPU_MIN_UNIT_SIZE / sizeof(struct mask_cache_entry)),
+	[OVS_DP_ATTR_IFINDEX] = {.type = NLA_U32 },
 };
 
 static const struct genl_small_ops dp_datapath_genl_ops[] = {
@@ -2199,7 +2202,10 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
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
@@ -2236,11 +2242,12 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	parms.name = nla_data(a[OVS_VPORT_ATTR_NAME]);
-	parms.type = nla_get_u32(a[OVS_VPORT_ATTR_TYPE]);
 	parms.options = a[OVS_VPORT_ATTR_OPTIONS];
 	parms.dp = dp;
 	parms.port_no = port_no;
 	parms.upcall_portids = a[OVS_VPORT_ATTR_UPCALL_PID];
+	parms.desired_ifindex = a[OVS_VPORT_ATTR_IFINDEX]
+		? nla_get_u32(a[OVS_VPORT_ATTR_IFINDEX]) : 0;
 
 	vport = new_vport(&parms);
 	err = PTR_ERR(vport);
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 5b2ee9c1c00b..f0059b7243df 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -147,6 +147,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 	}
 
 	dev_net_set(vport->dev, ovs_dp_get_net(vport->dp));
+	dev->ifindex = parms->desired_ifindex;
 	internal_dev = internal_dev_priv(vport->dev);
 	internal_dev->vport = vport;
 
diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 9de5030d9801..7d276f60c000 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -90,12 +90,14 @@ struct vport {
  * @type: New vport's type.
  * @options: %OVS_VPORT_ATTR_OPTIONS attribute from Netlink message, %NULL if
  * none was supplied.
+ * @desired_ifindex: New vport's ifindex.
  * @dp: New vport's datapath.
  * @port_no: New vport's port number.
  */
 struct vport_parms {
 	const char *name;
 	enum ovs_vport_type type;
+	int desired_ifindex;
 	struct nlattr *options;
 
 	/* For ovs_vport_alloc(). */
-- 
2.31.1

