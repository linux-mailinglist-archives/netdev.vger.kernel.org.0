Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C93A6C111B
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjCTLqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjCTLqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:46:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2B11F481
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 04:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679312721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLOkaIPcbDZ2yUkkPqS/xwMRngtYg0NdpldM46xyh/w=;
        b=hvw5TJhFfswl7dp8fnVqv6wK2iyekHqb0P57wE9Y3T64Mf/erWi6TfKJlPrYNViEWO2eAH
        lMeAIlFlQLJ2wIjK8VyfnG++arAf+J+5PA/DKr0dlIv+fHLMBPqkHLhtKlQkEdO1f3/Ddi
        D6F+1qaSkiJJqNNRy0Cvz6w8XkB9ByQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-B-8ixrIIMjuFJ7nEn2DyGA-1; Mon, 20 Mar 2023 07:45:16 -0400
X-MC-Unique: B-8ixrIIMjuFJ7nEn2DyGA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15F493822DE1;
        Mon, 20 Mar 2023 11:45:16 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.226.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07CC7C15BA0;
        Mon, 20 Mar 2023 11:45:14 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net/sched: act_tunnel_key: add support for "don't fragment"
Date:   Mon, 20 Mar 2023 12:44:55 +0100
Message-Id: <13672bdb258d2f261ef233033437f1034995785b.1679312049.git.dcaratti@redhat.com>
In-Reply-To: <cover.1679312049.git.dcaratti@redhat.com>
References: <cover.1679312049.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

extend "act_tunnel_key" to allow specifying TUNNEL_DONT_FRAGMENT; add tdc
selftest that verifies the control plane, and a kselftest for data plane.

Suggested-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/uapi/linux/tc_act/tc_tunnel_key.h     |   1 +
 net/sched/act_tunnel_key.c                    |   6 +
 .../selftests/net/forwarding/tc_tunnel_key.sh | 161 ++++++++++++++++++
 .../tc-tests/actions/tunnel_key.json          |  25 +++
 4 files changed, 193 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_tunnel_key.sh

diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
index 49ad4033951b..9d533fe91fac 100644
--- a/include/uapi/linux/tc_act/tc_tunnel_key.h
+++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
@@ -34,6 +34,7 @@ enum {
 					 */
 	TCA_TUNNEL_KEY_ENC_TOS,		/* u8 */
 	TCA_TUNNEL_KEY_ENC_TTL,		/* u8 */
+	TCA_TUNNEL_KEY_NO_FRAG,		/* u8 */
 	__TCA_TUNNEL_KEY_MAX,
 };
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 2d12d2626415..4841b97f8fd3 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -420,6 +420,10 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 		    nla_get_u8(tb[TCA_TUNNEL_KEY_NO_CSUM]))
 			flags &= ~TUNNEL_CSUM;
 
+		if (tb[TCA_TUNNEL_KEY_NO_FRAG] &&
+		    nla_get_u8(tb[TCA_TUNNEL_KEY_NO_FRAG]))
+			flags |= TUNNEL_DONT_FRAGMENT;
+
 		if (tb[TCA_TUNNEL_KEY_ENC_DST_PORT])
 			dst_port = nla_get_be16(tb[TCA_TUNNEL_KEY_ENC_DST_PORT]);
 
@@ -747,6 +751,8 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
 				   key->tp_dst)) ||
 		    nla_put_u8(skb, TCA_TUNNEL_KEY_NO_CSUM,
 			       !(key->tun_flags & TUNNEL_CSUM)) ||
+		    nla_put_u8(skb, TCA_TUNNEL_KEY_NO_FRAG,
+			       !!(key->tun_flags & TUNNEL_DONT_FRAGMENT)) ||
 		    tunnel_key_opts_dump(skb, info))
 			goto nla_put_failure;
 
diff --git a/tools/testing/selftests/net/forwarding/tc_tunnel_key.sh b/tools/testing/selftests/net/forwarding/tc_tunnel_key.sh
new file mode 100755
index 000000000000..5ac184d51809
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_tunnel_key.sh
@@ -0,0 +1,161 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+ALL_TESTS="tunnel_key_nofrag_test"
+
+NUM_NETIFS=4
+source tc_common.sh
+source lib.sh
+
+tcflags="skip_hw"
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24
+	forwarding_enable
+	mtu_set $h1 1500
+	tunnel_create h1-et vxlan 192.0.2.1 192.0.2.2 dev $h1 dstport 0 external
+	tc qdisc add dev h1-et clsact
+	mtu_set h1-et 1230
+	mtu_restore $h1
+	mtu_set $h1 1000
+}
+
+h1_destroy()
+{
+	tc qdisc del dev h1-et clsact
+	tunnel_destroy h1-et
+	forwarding_restore
+	mtu_restore $h1
+	simple_if_fini $h1 192.0.2.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/24
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 192.0.2.2/24
+}
+
+switch_create()
+{
+	simple_if_init $swp1 192.0.2.2/24
+	tc qdisc add dev $swp1 clsact
+	simple_if_init $swp2 192.0.2.1/24
+}
+
+switch_destroy()
+{
+	simple_if_fini $swp2 192.0.2.1/24
+	tc qdisc del dev $swp1 clsact
+	simple_if_fini $swp1 192.0.2.2/24
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	h1mac=$(mac_get $h1)
+	h2mac=$(mac_get $h2)
+
+	swp1origmac=$(mac_get $swp1)
+	swp2origmac=$(mac_get $swp2)
+	ip link set $swp1 address $h2mac
+	ip link set $swp2 address $h1mac
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+	switch_create
+
+	if ! tc action add action tunnel_key help 2>&1 | grep -q nofrag; then
+		log_test "SKIP: iproute doesn't support nofrag"
+		exit $ksft_skip
+	fi
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+
+	ip link set $swp2 address $swp2origmac
+	ip link set $swp1 address $swp1origmac
+}
+
+tunnel_key_nofrag_test()
+{
+	RET=0
+	local i
+
+	tc filter add dev $swp1 ingress protocol ip pref 100 handle 100 \
+		flower ip_flags nofrag action drop
+	tc filter add dev $swp1 ingress protocol ip pref 101 handle 101 \
+		flower ip_flags firstfrag action drop
+	tc filter add dev $swp1 ingress protocol ip pref 102 handle 102 \
+		flower ip_flags nofirstfrag action drop
+
+	# test 'nofrag' set
+	tc filter add dev h1-et egress protocol all pref 1 handle 1 matchall $tcflags \
+		action tunnel_key set src_ip 192.0.2.1 dst_ip 192.0.2.2 id 42 nofrag index 10
+	$MZ h1-et -c 1 -p 930 -a 00:aa:bb:cc:dd:ee -b 00:ee:dd:cc:bb:aa -t ip -q
+	tc_check_packets "dev $swp1 ingress" 100 1
+	check_err $? "packet smaller than MTU was not tunneled"
+
+	$MZ h1-et -c 1 -p 931 -a 00:aa:bb:cc:dd:ee -b 00:ee:dd:cc:bb:aa -t ip -q
+	tc_check_packets "dev $swp1 ingress" 100 1
+	check_err $? "packet bigger than MTU matched nofrag (nofrag was set)"
+	tc_check_packets "dev $swp1 ingress" 101 0
+	check_err $? "packet bigger than MTU matched firstfrag (nofrag was set)"
+	tc_check_packets "dev $swp1 ingress" 102 0
+	check_err $? "packet bigger than MTU matched nofirstfrag (nofrag was set)"
+
+	# test 'nofrag' cleared
+	tc actions change action tunnel_key set src_ip 192.0.2.1 dst_ip 192.0.2.2 id 42 index 10
+	$MZ h1-et -c 1 -p 931 -a 00:aa:bb:cc:dd:ee -b 00:ee:dd:cc:bb:aa -t ip -q
+	tc_check_packets "dev $swp1  ingress" 100 1
+	check_err $? "packet bigger than MTU matched nofrag (nofrag was unset)"
+	tc_check_packets "dev $swp1  ingress" 101 1
+	check_err $? "packet bigger than MTU didn't match firstfrag (nofrag was unset) "
+	tc_check_packets "dev $swp1 ingress" 102 1
+	check_err $? "packet bigger than MTU didn't match nofirstfrag (nofrag was unset) "
+
+	for i in 100 101 102; do
+		tc filter del dev $swp1 ingress protocol ip pref $i handle $i flower
+	done
+	tc filter del dev h1-et egress pref 1 handle 1 matchall
+
+	log_test "tunnel_key nofrag ($tcflags)"
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+tc_offload_check
+if [[ $? -ne 0 ]]; then
+	log_info "Could not test offloaded functionality"
+else
+	tcflags="skip_sw"
+	tests_run
+fi
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
index b40ee602918a..1ae51eadc477 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
@@ -983,5 +983,30 @@
         "teardown": [
             "$TC actions flush action tunnel_key"
         ]
+    },
+    {
+        "id": "6bda",
+        "name": "Add tunnel_key action with nofrag option",
+        "category": [
+            "actions",
+            "tunnel_key"
+        ],
+        "skip": "$TC actions add action tunnel_key help 2>&1 | grep -q nofrag",
+        "setup": [
+            [
+                "$TC action flush action tunnel_key",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 10.10.10.1 dst_ip 10.10.10.2 id 1111 nofrag index 222",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action tunnel_key index 222",
+        "matchPattern": "action order [0-9]+: tunnel_key.*src_ip 10.10.10.1.*dst_ip 10.10.10.2.*key_id 1111.*csum.*nofrag pipe.*index 222",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action tunnel_key"
+        ]
     }
 ]
-- 
2.39.2

