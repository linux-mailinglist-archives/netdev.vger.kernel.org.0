Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC2D45F004
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 15:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377752AbhKZOlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 09:41:35 -0500
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:37220 "EHLO
        smtpservice.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S238289AbhKZOje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 09:39:34 -0500
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id A7D7860620;
        Fri, 26 Nov 2021 15:36:19 +0100 (CET)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mqcKp-0002vs-Gw; Fri, 26 Nov 2021 15:36:19 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     fw@strlen.de, pablo@netfilter.org
Cc:     lschlesinger@drivenets.com, dsahern@kernel.org,
        crosser@average.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH nf] vrf: don't run conntrack on vrf with !dflt qdisc
Date:   Fri, 26 Nov 2021 15:36:12 +0100
Message-Id: <20211126143612.11262-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the below patch, the conntrack attached to skb is set to "notrack" in
the context of vrf device, for locally generated packets.
But this is true only when the default qdisc is set to the vrf device. When
changing the qdisc, notrack is not set anymore.
In fact, there is a shortcut in the vrf driver, when the default qdisc is
set, see commit dcdd43c41e60 ("net: vrf: performance improvements for
IPv4") for more details.

This patch ensures that the behavior is always the same, whatever the qdisc
is.

To demonstrate the difference, a new test is added in conntrack_vrf.sh.

Fixes: 8c9c296adfae ("vrf: run conntrack only in context of lower/physdev for locally generated packets")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 drivers/net/vrf.c                             |  8 ++---
 .../selftests/netfilter/conntrack_vrf.sh      | 30 ++++++++++++++++---
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index ccf677015d5b..38c2f0dbe795 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -768,8 +768,6 @@ static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
 
 	skb->dev = vrf_dev;
 
-	vrf_nf_set_untracked(skb);
-
 	err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, vrf_dev, vrf_ip6_out_direct_finish);
 
@@ -790,6 +788,8 @@ static struct sk_buff *vrf_ip6_out(struct net_device *vrf_dev,
 	if (rt6_need_strict(&ipv6_hdr(skb)->daddr))
 		return skb;
 
+	vrf_nf_set_untracked(skb);
+
 	if (qdisc_tx_is_default(vrf_dev) ||
 	    IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED)
 		return vrf_ip6_out_direct(vrf_dev, sk, skb);
@@ -998,8 +998,6 @@ static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
 
 	skb->dev = vrf_dev;
 
-	vrf_nf_set_untracked(skb);
-
 	err = nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, vrf_dev, vrf_ip_out_direct_finish);
 
@@ -1021,6 +1019,8 @@ static struct sk_buff *vrf_ip_out(struct net_device *vrf_dev,
 	    ipv4_is_lbcast(ip_hdr(skb)->daddr))
 		return skb;
 
+	vrf_nf_set_untracked(skb);
+
 	if (qdisc_tx_is_default(vrf_dev) ||
 	    IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED)
 		return vrf_ip_out_direct(vrf_dev, sk, skb);
diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
index 91f3ef0f1192..8b5ea9234588 100755
--- a/tools/testing/selftests/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/netfilter/conntrack_vrf.sh
@@ -150,11 +150,27 @@ EOF
 # oifname is the vrf device.
 test_masquerade_vrf()
 {
+	local qdisc=$1
+
+	if [ "$qdisc" != "default" ]; then
+		tc -net $ns0 qdisc add dev tvrf root $qdisc
+	fi
+
 	ip netns exec $ns0 conntrack -F 2>/dev/null
 
 ip netns exec $ns0 nft -f - <<EOF
 flush ruleset
 table ip nat {
+	chain rawout {
+		type filter hook output priority raw;
+
+		oif tvrf ct state untracked counter
+	}
+	chain postrouting2 {
+		type filter hook postrouting priority mangle;
+
+		oif tvrf ct state untracked counter
+	}
 	chain postrouting {
 		type nat hook postrouting priority 0;
 		# NB: masquerade should always be combined with 'oif(name) bla',
@@ -171,13 +187,18 @@ EOF
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2'
+	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2' &&
+	ip netns exec $ns0 nft list table ip nat |grep -q 'untracked counter packets [1-9]'
 	if [ $? -eq 0 ]; then
-		echo "PASS: iperf3 connect with masquerade + sport rewrite on vrf device"
+		echo "PASS: iperf3 connect with masquerade + sport rewrite on vrf device ($qdisc qdisc)"
 	else
-		echo "FAIL: vrf masq rule has unexpected counter value"
+		echo "FAIL: vrf rules have unexpected counter value"
 		ret=1
 	fi
+
+	if [ "$qdisc" != "default" ]; then
+		tc -net $ns0 qdisc del dev tvrf root
+	fi
 }
 
 # add masq rule that gets evaluated w. outif set to veth device.
@@ -213,7 +234,8 @@ EOF
 }
 
 test_ct_zone_in
-test_masquerade_vrf
+test_masquerade_vrf "default"
+test_masquerade_vrf "pfifo"
 test_masquerade_veth
 
 exit $ret
-- 
2.33.0

