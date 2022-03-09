Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E744D3243
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiCIP5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbiCIP5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:57:48 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6290913C26F;
        Wed,  9 Mar 2022 07:56:47 -0800 (PST)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 1168A200008;
        Wed,  9 Mar 2022 15:56:43 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     Jakub Kicinski <kuba@kernel.org>, Roi Dayan <roid@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Aaron Conole <aconole@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net-next] net: openvswitch: fix uAPI incompatibility with existing user space
Date:   Wed,  9 Mar 2022 16:56:23 +0100
Message-Id: <20220309155623.2996968-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few years ago OVS user space made a strange choice in the commit [1]
to define types only valid for the user space inside the copy of a
kernel uAPI header.  '#ifndef __KERNEL__' and another attribute was
added later.

This leads to the inevitable clash between user space and kernel types
when the kernel uAPI is extended.  The issue was unveiled with the
addition of a new type for IPv6 extension header in kernel uAPI.

When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to the
older user space application, application tries to parse it as
OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message as
malformed.  Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied along with
every IPv6 packet that goes to the user space, IPv6 support is fully
broken.

Fixing that by bringing these user space attributes to the kernel
uAPI to avoid the clash.  Strictly speaking this is not the problem
of the kernel uAPI, but changing it is the only way to avoid breakage
of the older user space applications at this point.

These 2 types are explicitly rejected now since they should not be
passed to the kernel.  Additionally, OVS_KEY_ATTR_TUNNEL_INFO moved
out from the '#ifdef __KERNEL__' as there is no good reason to hide
it from the userspace.  And it's also explicitly rejected now, because
it's for in-kernel use only.

Comments with warnings were added to avoid the problem coming back.

 [1] beb75a40fdc2 ("userspace: Switching of L3 packets in L2 pipeline")

Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension header support")
Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com
Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b0068b4cd12f6de507c
Reported-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---

Roi, could you please test this change on your setup?

I didn't run system tests myself yet, setting up environment at the moment.

 include/uapi/linux/openvswitch.h | 18 ++++++++++++++----
 net/openvswitch/flow_netlink.c   |  9 ++++++++-
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 9d1710f20505..ce3e1738d427 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -351,11 +351,21 @@ enum ovs_key_attr {
 	OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
 	OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
 	OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
-	OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
 
-#ifdef __KERNEL__
-	OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
-#endif
+	/* User space decided to squat on types 29 and 30.  They are defined
+	 * below, but should not be sent to the kernel.
+	 *
+	 * WARNING: No new types should be added unless they are defined
+	 *          for both kernel and user space (no 'ifdef's).  It's hard
+	 *          to keep compatibility otherwise.
+	 */
+	OVS_KEY_ATTR_PACKET_TYPE,   /* be32 packet type */
+	OVS_KEY_ATTR_ND_EXTENSIONS, /* IPv6 Neighbor Discovery extensions */
+
+	OVS_KEY_ATTR_TUNNEL_INFO,   /* struct ip_tunnel_info.
+				     * For in-kernel use only.
+				     */
+	OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
 	__OVS_KEY_ATTR_MAX
 };
 
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 8b4124820f7d..c9c49e5cd67f 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -346,7 +346,7 @@ size_t ovs_key_attr_size(void)
 	/* Whenever adding new OVS_KEY_ FIELDS, we should consider
 	 * updating this function.
 	 */
-	BUILD_BUG_ON(OVS_KEY_ATTR_TUNNEL_INFO != 30);
+	BUILD_BUG_ON(OVS_KEY_ATTR_MAX != 32);
 
 	return    nla_total_size(4)   /* OVS_KEY_ATTR_PRIORITY */
 		+ nla_total_size(0)   /* OVS_KEY_ATTR_TUNNEL */
@@ -482,6 +482,13 @@ static int __parse_flow_nlattrs(const struct nlattr *attr,
 			return -EINVAL;
 		}
 
+		if (type == OVS_KEY_ATTR_PACKET_TYPE ||
+		    type == OVS_KEY_ATTR_ND_EXTENSIONS ||
+		    type == OVS_KEY_ATTR_TUNNEL_INFO) {
+			OVS_NLERR(log, "Key type %d is not supported", type);
+			return -EINVAL;
+		}
+
 		if (attrs & (1 << type)) {
 			OVS_NLERR(log, "Duplicate key (type %d).", type);
 			return -EINVAL;
-- 
2.34.1

