Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4182CE643
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgLDDHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgLDDHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:07:07 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B59FC061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:06:27 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id k4so3041388qtj.10
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CEXSCdKkhduQSvEEfToLCAKnQvvjAj0QIHUrQBw0BUc=;
        b=LoZvpFCj0DrNYPzr5o/AA4l04RERpgRMihQ9yixBVroXfmvFh/F0SOYpJ5YoAtYFr3
         T88vdWcwXq5JmFDEBCcQ1khNlz7cyof7L69oF10/tbgDjB2wuX9WrB9As6zE+auo8fRY
         185b8nC3MLZWrEfutiq7gwvboqjkgxfRXwXyodzVIsWMtR9pdeXQ4Dmkbn7kxxCsYyva
         SkVWU+jbiMrVlw77G5thX5kNj4ziudnbXEZ5LkKy6P79/4IuTiFAlkNnG+1o4W0DwSfK
         B3bMutI/uOa9XnG4K5PbweR6DNRIfMkTRpn2ZoKli8AbdCTzT5ot9z2/PvAWPdvNzCyb
         0AbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CEXSCdKkhduQSvEEfToLCAKnQvvjAj0QIHUrQBw0BUc=;
        b=LTxCYfyyzjurqKRgeofEoJQqLam5WM7HyrxUK8wzOorplmbqwlkGIGxjz+2TId+Col
         ln8/hFKthWnzAYGy9YhKiTDvbKFNAKrr9NhpNX5dFc1lgnVHOyzh3uaaSgXK9+EN7DsI
         p9+xgvxXMvgsrefgRbyysUMqOBaDC08KacPC38GxTAWeBLWIxIb/lTb/AW4u8FzRb3Kr
         IH5RXGRFoZ24yl2FI0y/rUsHLJvSin99iMk0MlJoc5yReelwnqXWP6xaXUFwcZ8MtvVT
         bCuDaSqL2SNNaU3pRXwuF3XT6ZDu/Z8dbblh2Qq3jwSZpbg4eTmToXjhjWA4foOr8gRK
         Ixuw==
X-Gm-Message-State: AOAM533QeCz/XrUaLGhPjNs9/SSTUibQqVqzDDmrJt8gajscigwnysrT
        0qYK8j8jgd6Y63JZRYB7+bhpPfnRMcwO
X-Google-Smtp-Source: ABdhPJwvNqQUXEq1jr+RJRywb8Rab7IyU3LXvSnigLA6VYfPt+VhMlfALddrXShKmPpqcvgMZP0K6Q==
X-Received: by 2002:ac8:4998:: with SMTP id f24mr6993403qtq.30.1607051185823;
        Thu, 03 Dec 2020 19:06:25 -0800 (PST)
Received: from localhost.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id 76sm3621679qkg.134.2020.12.03.19.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 19:06:25 -0800 (PST)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net] vrf: packets with lladdr src needs dst at input with orig_iif when needs strict
Date:   Thu,  3 Dec 2020 22:06:04 -0500
Message-Id: <20201204030604.18828-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on the order of the routes to fe80::/64 are installed on the
VRF table, the NS for the source link-local address of the originator
might be sent to the wrong interface.

This patch ensures that packets with link-local addr source is doing a
lookup with the orig_iif when the destination addr indicates that it
is strict.

Add the reproducer as a use case in self test script fcnal-test.sh.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 drivers/net/vrf.c                         | 10 ++-
 tools/testing/selftests/net/fcnal-test.sh | 95 +++++++++++++++++++++++
 2 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index f2793ffde191..b9b7e00b72a8 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1315,11 +1315,17 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 	int orig_iif = skb->skb_iif;
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
+	bool is_ll_src;
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
-	 * packet taps again. Reset pkt_type for upper layers to process skb
+	 * packet taps again. Reset pkt_type for upper layers to process skb.
+	 * for packets with lladdr src, however, skip so that the dst can be
+	 * determine at input using original ifindex in the case that daddr
+	 * needs strict
 	 */
-	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
+	is_ll_src = ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL;
+	if (skb->pkt_type == PACKET_LOOPBACK ||
+	    (need_strict && !is_ndisc && !is_ll_src)) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index fb5c55dd6df8..02b0b9ead40b 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -256,6 +256,28 @@ setup_cmd_nsb()
 	fi
 }
 
+setup_cmd_nsc()
+{
+	local cmd="$*"
+	local rc
+
+	run_cmd_nsc ${cmd}
+	rc=$?
+	if [ $rc -ne 0 ]; then
+		# show user the command if not done so already
+		if [ "$VERBOSE" = "0" ]; then
+			echo "setup command: $cmd"
+		fi
+		echo "failed. stopping tests"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue"
+			read a
+		fi
+		exit $rc
+	fi
+}
+
 # set sysctl values in NS-A
 set_sysctl()
 {
@@ -471,6 +493,36 @@ setup()
 	sleep 1
 }
 
+setup_lla_only()
+{
+	# make sure we are starting with a clean slate
+	kill_procs
+	cleanup 2>/dev/null
+
+	log_debug "Configuring network namespaces"
+	set -e
+
+	create_ns ${NSA} "-" "-"
+	create_ns ${NSB} "-" "-"
+	create_ns ${NSC} "-" "-"
+	connect_ns ${NSA} ${NSA_DEV} "-" "-" \
+		   ${NSB} ${NSB_DEV} "-" "-"
+	connect_ns ${NSA} ${NSA_DEV2} "-" "-" \
+		   ${NSC} ${NSC_DEV}  "-" "-"
+
+	NSA_LINKIP6=$(get_linklocal ${NSA} ${NSA_DEV})
+	NSB_LINKIP6=$(get_linklocal ${NSB} ${NSB_DEV})
+	NSC_LINKIP6=$(get_linklocal ${NSC} ${NSC_DEV})
+
+	create_vrf ${NSA} ${VRF} ${VRF_TABLE} "-" "-"
+	ip -netns ${NSA} link set dev ${NSA_DEV} vrf ${VRF}
+	ip -netns ${NSA} link set dev ${NSA_DEV2} vrf ${VRF}
+
+	set +e
+
+	sleep 1
+}
+
 ################################################################################
 # IPv4
 
@@ -3787,10 +3839,53 @@ use_case_br()
 	setup_cmd_nsb ip li del vlan100 2>/dev/null
 }
 
+# VRF only.
+# ns-A device is connected to both ns-B and ns-C on a single VRF but only has
+# LLA on the interfaces
+use_case_ping_lla_multi()
+{
+	setup_lla_only
+	# only want reply from ns-A
+	setup_cmd_nsb sysctl -qw net.ipv6.icmp.echo_ignore_multicast=1
+	setup_cmd_nsc sysctl -qw net.ipv6.icmp.echo_ignore_multicast=1
+
+	log_start
+	run_cmd_nsb ping -c1 -w1 ${MCAST}%${NSB_DEV}
+	log_test_addr ${MCAST}%${NSB_DEV} $? 0 "Pre cycle, ping out ns-B"
+
+	run_cmd_nsc ping -c1 -w1 ${MCAST}%${NSC_DEV}
+	log_test_addr ${MCAST}%${NSC_DEV} $? 0 "Pre cycle, ping out ns-C"
+
+	# cycle/flap the first ns-A interface
+	setup_cmd ip link set ${NSA_DEV} down
+	setup_cmd ip link set ${NSA_DEV} up
+	sleep 1
+
+	log_start
+	run_cmd_nsb ping -c1 -w1 ${MCAST}%${NSB_DEV}
+	log_test_addr ${MCAST}%${NSB_DEV} $? 0 "Post cycle ${NSA} ${NSA_DEV}, ping out ns-B"
+	run_cmd_nsc ping -c1 -w1 ${MCAST}%${NSC_DEV}
+	log_test_addr ${MCAST}%${NSC_DEV} $? 0 "Post cycle ${NSA} ${NSA_DEV}, ping out ns-C"
+
+	# cycle/flap the second ns-A interface
+	setup_cmd ip link set ${NSA_DEV2} down
+	setup_cmd ip link set ${NSA_DEV2} up
+	sleep 1
+
+	log_start
+	run_cmd_nsb ping -c1 -w1 ${MCAST}%${NSB_DEV}
+	log_test_addr ${MCAST}%${NSB_DEV} $? 0 "Post cycle ${NSA} ${NSA_DEV2}, ping out ns-B"
+	run_cmd_nsc ping -c1 -w1 ${MCAST}%${NSC_DEV}
+	log_test_addr ${MCAST}%${NSC_DEV} $? 0 "Post cycle ${NSA} ${NSA_DEV2}, ping out ns-C"
+}
+
 use_cases()
 {
 	log_section "Use cases"
+	log_subsection "Device enslaved to bridge"
 	use_case_br
+	log_subsection "Ping LLA with multiple interfaces"
+	use_case_ping_lla_multi
 }
 
 ################################################################################
-- 
2.20.1

