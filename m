Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B02236A7FF
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 17:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhDYPh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 11:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhDYPhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 11:37:25 -0400
X-Greylist: delayed 492 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 25 Apr 2021 08:36:45 PDT
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D21C061574;
        Sun, 25 Apr 2021 08:36:45 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1DAAD3EB2E;
        Sun, 25 Apr 2021 17:28:28 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [PATCH net] net: bridge: mcast: fix broken length + header check for MRDv6 Adv.
Date:   Sun, 25 Apr 2021 17:27:35 +0200
Message-Id: <20210425152736.8421-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPv6 Multicast Router Advertisements parsing has the following two
issues:

For one thing, ICMPv6 MRD Advertisements are smaller than ICMPv6 MLD
messages (ICMPv6 MRD Adv.: 8 bytes vs. ICMPv6 MLDv1/2: >= 24 bytes,
assuming MLDv2 Reports with at least one multicast address entry).
When ipv6_mc_check_mld_msg() tries to parse an Multicast Router
Advertisement its MLD length check will fail - and it will wrongly
return -EINVAL, even if we have a valid MRD Advertisement. With the
returned -EINVAL the bridge code will assume a broken packet and will
wrongly discard it, potentially leading to multicast packet loss towards
multicast routers.

The second issue is the MRD header parsing in
br_ip6_multicast_mrd_rcv(): It wrongly checks for an ICMPv6 header
immediately after the IPv6 header (IPv6 next header type). However
according to RFC4286, section 2 all MRD messages contain a Router Alert
option (just like MLD). So instead there is an IPv6 Hop-by-Hop option
for the Router Alert between the IPv6 and ICMPv6 header, again leading
to the bridge wrongly discarding Multicast Router Advertisements.

To fix these two issues, introduce a new return value -ENODATA to
ipv6_mc_check_mld() to indicate a valid ICMPv6 packet with a hop-by-hop
option which is not an MLD but potentially an MRD packet. This also
simplifies further parsing in the bridge code, as ipv6_mc_check_mld()
already fully checks the ICMPv6 header and hop-by-hop option.

These issues were found and fixed with the help of the mrdisc tool
(https://github.com/troglobit/mrdisc).

Fixes: 4b3087c7e37f ("bridge: Snoop Multicast Router Advertisements")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 include/net/addrconf.h    |  1 -
 net/bridge/br_multicast.c | 33 ++++++++-------------------------
 net/ipv6/mcast_snoop.c    | 12 +++++++-----
 3 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 18f783dcd55f..78ea3e332688 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -233,7 +233,6 @@ void ipv6_mc_unmap(struct inet6_dev *idev);
 void ipv6_mc_remap(struct inet6_dev *idev);
 void ipv6_mc_init_dev(struct inet6_dev *idev);
 void ipv6_mc_destroy_dev(struct inet6_dev *idev);
-int ipv6_mc_check_icmpv6(struct sk_buff *skb);
 int ipv6_mc_check_mld(struct sk_buff *skb);
 void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp);
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9d265447d654..229309d7b4ff 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3152,25 +3152,14 @@ static int br_multicast_ipv4_rcv(struct net_bridge *br,
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int br_ip6_multicast_mrd_rcv(struct net_bridge *br,
-				    struct net_bridge_port *port,
-				    struct sk_buff *skb)
+static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
+				     struct net_bridge_port *port,
+				     struct sk_buff *skb)
 {
-	int ret;
-
-	if (ipv6_hdr(skb)->nexthdr != IPPROTO_ICMPV6)
-		return -ENOMSG;
-
-	ret = ipv6_mc_check_icmpv6(skb);
-	if (ret < 0)
-		return ret;
-
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
-		return -ENOMSG;
+		return;
 
 	br_multicast_mark_router(br, port);
-
-	return 0;
 }
 
 static int br_multicast_ipv6_rcv(struct net_bridge *br,
@@ -3184,18 +3173,12 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 
 	err = ipv6_mc_check_mld(skb);
 
-	if (err == -ENOMSG) {
+	if (err == -ENOMSG || err == -ENODATA) {
 		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
 			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
-
-		if (ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr)) {
-			err = br_ip6_multicast_mrd_rcv(br, port, skb);
-
-			if (err < 0 && err != -ENOMSG) {
-				br_multicast_err_count(br, port, skb->protocol);
-				return err;
-			}
-		}
+		if (err == -ENODATA &&
+		    ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr))
+			br_ip6_multicast_mrd_rcv(br, port, skb);
 
 		return 0;
 	} else if (err < 0) {
diff --git a/net/ipv6/mcast_snoop.c b/net/ipv6/mcast_snoop.c
index d3d6b6a66e5f..04d5fcdfa6e0 100644
--- a/net/ipv6/mcast_snoop.c
+++ b/net/ipv6/mcast_snoop.c
@@ -109,7 +109,7 @@ static int ipv6_mc_check_mld_msg(struct sk_buff *skb)
 	struct mld_msg *mld;
 
 	if (!ipv6_mc_may_pull(skb, len))
-		return -EINVAL;
+		return -ENODATA;
 
 	mld = (struct mld_msg *)skb_transport_header(skb);
 
@@ -122,7 +122,7 @@ static int ipv6_mc_check_mld_msg(struct sk_buff *skb)
 	case ICMPV6_MGM_QUERY:
 		return ipv6_mc_check_mld_query(skb);
 	default:
-		return -ENOMSG;
+		return -ENODATA;
 	}
 }
 
@@ -131,7 +131,7 @@ static inline __sum16 ipv6_mc_validate_checksum(struct sk_buff *skb)
 	return skb_checksum_validate(skb, IPPROTO_ICMPV6, ip6_compute_pseudo);
 }
 
-int ipv6_mc_check_icmpv6(struct sk_buff *skb)
+static int ipv6_mc_check_icmpv6(struct sk_buff *skb)
 {
 	unsigned int len = skb_transport_offset(skb) + sizeof(struct icmp6hdr);
 	unsigned int transport_len = ipv6_transport_len(skb);
@@ -150,7 +150,6 @@ int ipv6_mc_check_icmpv6(struct sk_buff *skb)
 
 	return 0;
 }
-EXPORT_SYMBOL(ipv6_mc_check_icmpv6);
 
 /**
  * ipv6_mc_check_mld - checks whether this is a sane MLD packet
@@ -161,7 +160,10 @@ EXPORT_SYMBOL(ipv6_mc_check_icmpv6);
  *
  * -EINVAL: A broken packet was detected, i.e. it violates some internet
  *  standard
- * -ENOMSG: IP header validation succeeded but it is not an MLD packet.
+ * -ENOMSG: IP header validation succeeded but it is not an ICMPv6 packet
+ *  with a hop-by-hop option.
+ * -ENODATA: IP+ICMPv6 header with hop-by-hop option validation succeeded
+ *  but it is not an MLD packet.
  * -ENOMEM: A memory allocation failure happened.
  *
  * Caller needs to set the skb network header and free any returned skb if it
-- 
2.31.0

