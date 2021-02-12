Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D493831A13E
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhBLPOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:14:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhBLPOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:14:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613142759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tykDJXTF6tQlVdZA5daY3Vzagei97L9VD1bsXIDcrSo=;
        b=J3huR3Vv2mQiYdvrh+H8jeZOB038MPWaEe3x88P9fjUQJMjmAzWzb6sehbmlLk4US2JxFV
        Qomlcdi+YOCfRAwTkx/cdiOohfEpvn3I1z9RCE/Pmuh+Zq1ipIIdQnudZUmO5pNEfmEK3z
        3EdE58UGIFq7HkP1Ielmw9nUgwT3cLw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-mdd1je6FOF6r7Xj3uurZWA-1; Fri, 12 Feb 2021 10:12:36 -0500
X-MC-Unique: mdd1je6FOF6r7Xj3uurZWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9FBB10066EF;
        Fri, 12 Feb 2021 15:12:34 +0000 (UTC)
Received: from computer-6.redhat.com (unknown [10.40.193.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2365C60BE5;
        Fri, 12 Feb 2021 15:12:32 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org
Cc:     shuali@redhat.com
Subject: [PATCH net] flow_dissector: fix TTL and TOS dissection on IPv4 fragments
Date:   Fri, 12 Feb 2021 16:12:25 +0100
Message-Id: <a33c38298e722bc1d2ce4ecd13bb5f42d6859709.1613142439.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following command:

 # tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
   $tcflags dst_ip 192.0.2.2 ip_ttl 63 action drop

doesn't drop all IPv4 packets that match the configured TTL / destination
address. In particular, if "fragment offset" or "more fragments" have non
zero value in the IPv4 header, setting of FLOW_DISSECTOR_KEY_IP is simply
ignored. Fix this dissecting IPv4 TTL and TOS before fragment info; while
at it, add a selftest for tc flower's match on 'ip_ttl' that verifies the
correct behavior.

Fixes: 518d8a2e9bad ("net/flow_dissector: add support for dissection of misc ip header fields")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/core/flow_dissector.c                     |  6 +--
 .../selftests/net/forwarding/tc_flower.sh     | 38 ++++++++++++++++++-
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 6f1adba6695f..0b4f536bc32d 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1050,6 +1050,9 @@ bool __skb_flow_dissect(const struct net *net,
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		}
 
+		__skb_flow_dissect_ipv4(skb, flow_dissector,
+					target_container, data, iph);
+
 		if (ip_is_fragment(iph)) {
 			key_control->flags |= FLOW_DIS_IS_FRAGMENT;
 
@@ -1066,9 +1069,6 @@ bool __skb_flow_dissect(const struct net *net,
 			}
 		}
 
-		__skb_flow_dissect_ipv4(skb, flow_dissector,
-					target_container, data, iph);
-
 		break;
 	}
 	case htons(ETH_P_IPV6): {
diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index 058c746ee300..b11d8e6b5bc1 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
 	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
-	match_ip_tos_test match_indev_test"
+	match_ip_tos_test match_indev_test match_ip_ttl_test"
 NUM_NETIFS=2
 source tc_common.sh
 source lib.sh
@@ -310,6 +310,42 @@ match_ip_tos_test()
 	log_test "ip_tos match ($tcflags)"
 }
 
+match_ip_ttl_test()
+{
+	RET=0
+
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		$tcflags dst_ip 192.0.2.2 ip_ttl 63 action drop
+	tc filter add dev $h2 ingress protocol ip pref 2 handle 102 flower \
+		$tcflags dst_ip 192.0.2.2 action drop
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip "ttl=63" -q
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip "ttl=63,mf,frag=256" -q
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_fail $? "Matched on the wrong filter (no check on ttl)"
+
+	tc_check_packets "dev $h2 ingress" 101 2
+	check_err $? "Did not match on correct filter (ttl=63)"
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip "ttl=255" -q
+
+	tc_check_packets "dev $h2 ingress" 101 3
+	check_fail $? "Matched on a wrong filter (ttl=63)"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct filter (no check on ttl)"
+
+	tc filter del dev $h2 ingress protocol ip pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+
+	log_test "ip_ttl match ($tcflags)"
+}
+
 match_indev_test()
 {
 	RET=0
-- 
2.29.2

