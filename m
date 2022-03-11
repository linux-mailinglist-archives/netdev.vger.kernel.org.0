Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D31F4D678E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350743AbiCKR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350358AbiCKR0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:26:19 -0500
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DFA1C1EEA
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:25:15 -0800 (PST)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.27])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CA7D22006F;
        Fri, 11 Mar 2022 17:25:13 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7CEB760006B;
        Fri, 11 Mar 2022 17:25:13 +0000 (UTC)
Received: from ben-dt4.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id EB84213C2B6;
        Fri, 11 Mar 2022 09:25:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com EB84213C2B6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1647019513;
        bh=VmYW+e+wJLtBg44VXIl+cd5qesOZ819wk/iyrXxK6t8=;
        h=From:To:Cc:Subject:Date:From;
        b=ABzn/x2qP4daBJtrFzs+Uy15U1zMXFOR7pLqcq+U6ih5NCj2EcIpEPpGB+HXRn5Ot
         O9VnZRPpbKzx9QCgKhcttjTtAlK21omWI7eXGd02uwhjWPP1fCyILanxbpyK/2oCni
         fLhfN8/YJXOSaBzn5Hs0z9S4t3S6PBVGe+NxL27o=
From:   greearb@candelatech.com
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] vrf/mcast:  Fix mcast routing when using vrf.
Date:   Fri, 11 Mar 2022 09:25:09 -0800
Message-Id: <20220311172509.10992-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1647019514-6gqx4CBIyDxo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

The problem case is where you have a VRF with 2 ports.  Assume
eth1 points towards upstream and has default gateway, eth2 points
towards a local subnet.

User binds a UDP multicast socket to eth2 and attempts to send
multicast traffic on a non-local-multicast address (something other
than 224.0.0.x/24).  There is no multicast router daemon in this case.

The flow through the kernel will start out with the correct oif (eth2),
but in this logic, the oif becomes the index of the vrf device instead:

    /* update flow if oif or iif point to device enslaved to l3mdev */
    l3mdev_update_flow(net, flowi4_to_flowi(flp));

After that, the mcast routing logic will choose the eth1 interface
as the output device, and the code in __mkroute_output will in the
end cause the frame to be sent out eth1 instead of the desired eth2.

To fix this, add special case logic to detect this in __mkroute_output
and instead use the user-specified port as the output device when
there is no specific mcast route available.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/ipv4/route.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f33ad1f383b6..722df8fcf417 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2475,6 +2475,7 @@ int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 /* called with rcu_read_lock() */
 static struct rtable *__mkroute_output(const struct fib_result *res,
 				       const struct flowi4 *fl4, int orig_oif,
+				       struct net_device *orig_dev_out,
 				       struct net_device *dev_out,
 				       unsigned int flags)
 {
@@ -2516,12 +2517,26 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 			flags &= ~RTCF_LOCAL;
 		else
 			do_cache = false;
-		/* If multicast route do not exist use
-		 * default one, but do not gateway in this case.
+		/* If multicast route does not exist use
+		 * default one, but do not use gateway in this case.
 		 * Yes, it is hack.
 		 */
-		if (fi && res->prefixlen < 4)
+		if (fi && res->prefixlen < 4) {
+			struct net *net = dev_net(dev_out);
+
 			fi = NULL;
+
+			if (orig_oif && orig_dev_out &&
+			    dev_out->ifindex != orig_oif &&
+			    netif_index_is_l3_master(net, fl4->flowi4_oif)) {
+				/* vrf overwrites the original flowi4_oif for
+				 * member network devices.  In that case,
+				 * lets use the user-specified oif instead of
+				 * a default route.
+				 */
+				dev_out = orig_dev_out;
+			}
+		}
 	} else if ((type == RTN_LOCAL) && (orig_oif != 0) &&
 		   (orig_oif != dev_out->ifindex)) {
 		/* For local routes that require a particular output interface
@@ -2630,6 +2645,7 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 					    const struct sk_buff *skb)
 {
 	struct net_device *dev_out = NULL;
+	struct net_device *orig_dev_out = NULL;
 	int orig_oif = fl4->flowi4_oif;
 	unsigned int flags = 0;
 	struct rtable *rth;
@@ -2785,12 +2801,13 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 		goto make_route;
 	}
 
+	orig_dev_out = dev_out;
 	fib_select_path(net, res, fl4, skb);
 
 	dev_out = FIB_RES_DEV(*res);
 
 make_route:
-	rth = __mkroute_output(res, fl4, orig_oif, dev_out, flags);
+	rth = __mkroute_output(res, fl4, orig_oif, orig_dev_out, dev_out, flags);
 
 out:
 	return rth;
-- 
2.20.1

