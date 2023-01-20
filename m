Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D442D675AB2
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjATRDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjATRDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:03:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA601BD0
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 09:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674234136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8L0VV2lq8zL7OiW2Mg/Mv76PXH9xfoSEugTXSKHlbiA=;
        b=QjdgCmMywjaEYmHhyCYWUwLzwUvtA3euOXncwSDocqAS0sv0ubRa0pwzR9V2ky3hDXeI2e
        JWTHQqzqZEVy8eqn1CtxEMrEaEptmGl8Keon4sBcTujXVS2RZRewbJJPes/HbuukepYUXT
        J8kjvoCzQuqfHkht/BJBjRmrdmjPgrM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-6LVdK7-iPiWkxyTc8mQgXA-1; Fri, 20 Jan 2023 12:02:13 -0500
X-MC-Unique: 6LVdK7-iPiWkxyTc8mQgXA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B9D33C0255D;
        Fri, 20 Jan 2023 17:02:13 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (ovpn-194-73.brq.redhat.com [10.40.194.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3847E2166B2A;
        Fri, 20 Jan 2023 17:02:08 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     jhs@mojatatu.com
Cc:     jiri@resnulli.us, lucien.xin@gmail.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, wizhao@redhat.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH net-next 2/2] act_mirred: use the backlog for nested calls to mirred ingress
Date:   Fri, 20 Jan 2023 18:01:40 +0100
Message-Id: <5fdd584d53f0807f743c07b1c0381cf5649495cd.1674233458.git.dcaratti@redhat.com>
In-Reply-To: <cover.1674233458.git.dcaratti@redhat.com>
References: <cover.1674233458.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

William reports kernel soft-lockups on some OVS topologies when TC mirred
egress->ingress action is hit by local TCP traffic [1].
The same can also be reproduced with SCTP (thanks Xin for verifying), when
client and server reach themselves through mirred egress to ingress, and
one of the two peers sends a "heartbeat" packet (from within a timer).

Enqueueing to backlog proved to fix this soft lockup; however, as Cong
noticed [2], we should preserve - when possible - the current mirred
behavior that counts as "overlimits" any eventual packet drop subsequent to
the mirred forwarding action [3]. A compromise solution might use the
backlog only when tcf_mirred_act() has a nest level greater than one:
change tcf_mirred_forward() accordingly.

Also, add a kselftest that can reproduce the lockup and verifies TC mirred
ability to account for further packet drops after TC mirred egress->ingress
(when the nest level is 1).

 [1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
 [2] https://lore.kernel.org/netdev/Y0w%2FWWY60gqrtGLp@pop-os.localdomain/
 [3] such behavior is not guaranteed: for example, if RPS or skb RX
     timestamping is enabled on the mirred target device, the kernel
     can defer receiving the skb and return NET_RX_SUCCESS inside
     tcf_mirred_forward().

Reported-by: William Zhao <wizhao@redhat.com>
CC: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_mirred.c                        |  7 +++
 .../selftests/net/forwarding/tc_actions.sh    | 49 ++++++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index c8abb5136491..8037ec9b1d31 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -206,12 +206,19 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
+static bool is_mirred_nested(void)
+{
+	return unlikely(__this_cpu_read(mirred_nest_level) > 1);
+}
+
 static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 {
 	int err;
 
 	if (!want_ingress)
 		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
+	else if (is_mirred_nested())
+		err = netif_rx(skb);
 	else
 		err = netif_receive_skb(skb);
 
diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index 1e0a62f638fe..919c0dd9fe4b 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -3,7 +3,8 @@
 
 ALL_TESTS="gact_drop_and_ok_test mirred_egress_redirect_test \
 	mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
-	gact_trap_test mirred_egress_to_ingress_test"
+	gact_trap_test mirred_egress_to_ingress_test \
+	mirred_egress_to_ingress_tcp_test"
 NUM_NETIFS=4
 source tc_common.sh
 source lib.sh
@@ -198,6 +199,52 @@ mirred_egress_to_ingress_test()
 	log_test "mirred_egress_to_ingress ($tcflags)"
 }
 
+mirred_egress_to_ingress_tcp_test()
+{
+	local tmpfile=$(mktemp) tmpfile1=$(mktemp)
+
+	RET=0
+	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
+	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
+		$tcflags ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
+			action ct commit nat src addr 192.0.2.2 pipe \
+			action ct clear pipe \
+			action ct commit nat dst addr 192.0.2.1 pipe \
+			action ct clear pipe \
+			action skbedit ptype host pipe \
+			action mirred ingress redirect dev $h1
+	tc filter add dev $h1 protocol ip pref 101 handle 101 egress flower \
+		$tcflags ip_proto icmp \
+			action mirred ingress redirect dev $h1
+	tc filter add dev $h1 protocol ip pref 102 handle 102 ingress flower \
+		ip_proto icmp \
+			action drop
+
+	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1  &
+	local rpid=$!
+	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
+	wait -n $rpid
+	cmp -s $tmpfile $tmpfile1
+	check_err $? "server output check failed"
+
+	$MZ $h1 -c 10 -p 64 -a $h1mac -b $h1mac -A 192.0.2.1 -B 192.0.2.1 \
+		-t icmp "ping,id=42,seq=5" -q
+	tc_check_packets "dev $h1 egress" 101 10
+	check_err $? "didn't mirred redirect ICMP"
+	tc_check_packets "dev $h1 ingress" 102 10
+	check_err $? "didn't drop mirred ICMP"
+	local overlimits=$(tc_rule_stats_get ${h1} 101 egress .overlimits)
+	test ${overlimits} = 10
+	check_err $? "wrong overlimits, expected 10 got ${overlimits}"
+
+	tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
+	tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
+	tc filter del dev $h1 ingress protocol ip pref 102 handle 102 flower
+
+	rm -f $tmpfile $tmpfile1
+	log_test "mirred_egress_to_ingress_tcp ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.38.1

