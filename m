Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B450B4B14B6
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245418AbiBJR4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:56:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245401AbiBJR4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:56:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDEFB25C3
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644515781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3Yvbq83t8gEjjvIM8ZubRYCkJPcJbzMYeOWPsjX7Un0=;
        b=RppPt29w+Zw9WRKahNIwTpnrVz5j4/Qi59coOSg1DfXYPmcEd9GrsPTyJaXbD1SbYc7Z3w
        ZOI3HCxscrvHz9S2uajYPTxG6U2p746RSAH7Kg4KAkzYO2jmUcvFQaU96qsNK4dYUj/pkG
        Aki1FVQSKK1jUPiI4qMtOA91273EygA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-z5sj7pEXOyGNxIWPR1efcw-1; Thu, 10 Feb 2022 12:56:18 -0500
X-MC-Unique: z5sj7pEXOyGNxIWPR1efcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A354C85EE62;
        Thu, 10 Feb 2022 17:56:16 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.40.192.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AACB9167AC;
        Thu, 10 Feb 2022 17:56:13 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Oz Shlomo <ozsh@nvidia.com>, Eelco Chaudron <echaudro@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next] net/sched: act_police: more accurate MTU policing
Date:   Thu, 10 Feb 2022 18:56:08 +0100
Message-Id: <876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in current Linux, MTU policing does not take into account that packets at
the TC ingress have the L2 header pulled. Thus, the same TC police action
(with the same value of tcfp_mtu) behaves differently for ingress/egress.
In addition, the full GSO size is compared to tcfp_mtu: as a consequence,
the policer drops GSO packets even when individual segments have the L2 +
L3 + L4 + payload length below the configured valued of tcfp_mtu.

Improve the accuracy of MTU policing as follows:
 - account for mac_len for non-GSO packets at TC ingress.
 - compare MTU threshold with the segmented size for GSO packets.
Also, add a kselftest that verifies the correct behavior.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_police.c                        | 16 +++++-
 .../selftests/net/forwarding/tc_police.sh     | 52 +++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 0923aa2b8f8a..899fe025df77 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -239,6 +239,20 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
+static bool tcf_police_mtu_check(struct sk_buff *skb, u32 limit)
+{
+	u32 len;
+
+	if (skb_is_gso(skb))
+		return skb_gso_validate_mac_len(skb, limit);
+
+	len = qdisc_pkt_len(skb);
+	if (skb_at_tc_ingress(skb))
+		len += skb->mac_len;
+
+	return len <= limit;
+}
+
 static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
@@ -261,7 +275,7 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			goto inc_overlimits;
 	}
 
-	if (qdisc_pkt_len(skb) <= p->tcfp_mtu) {
+	if (tcf_police_mtu_check(skb, p->tcfp_mtu)) {
 		if (!p->rate_present && !p->pps_present) {
 			ret = p->tcfp_result;
 			goto end;
diff --git a/tools/testing/selftests/net/forwarding/tc_police.sh b/tools/testing/selftests/net/forwarding/tc_police.sh
index 4f9f17cb45d6..0a51eef21b9e 100755
--- a/tools/testing/selftests/net/forwarding/tc_police.sh
+++ b/tools/testing/selftests/net/forwarding/tc_police.sh
@@ -37,6 +37,8 @@ ALL_TESTS="
 	police_tx_mirror_test
 	police_pps_rx_test
 	police_pps_tx_test
+	police_mtu_rx_test
+	police_mtu_tx_test
 "
 NUM_NETIFS=6
 source tc_common.sh
@@ -346,6 +348,56 @@ police_pps_tx_test()
 	tc filter del dev $rp2 egress protocol ip pref 1 handle 101 flower
 }
 
+police_mtu_common_test() {
+	RET=0
+
+	local test_name=$1; shift
+	local dev=$1; shift
+	local direction=$1; shift
+
+	tc filter add dev $dev $direction protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action police mtu 1042 conform-exceed drop/ok
+
+	# to count "conform" packets
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action drop
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=54321 -p 1001 -c 10 -q
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=54321 -p 1000 -c 3 -q
+
+	tc_check_packets "dev $dev $direction" 101 13
+	check_err $? "wrong packet counter"
+
+	# "exceed" packets
+	local overlimits_t0=$(tc_rule_stats_get ${dev} 1 ${direction} .overlimits)
+	test ${overlimits_t0} = 10
+	check_err $? "wrong overlimits, expected 10 got ${overlimits_t0}"
+
+	# "conform" packets
+	tc_check_packets "dev $h2 ingress" 101 3
+	check_err $? "forwarding error"
+
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+	tc filter del dev $dev $direction protocol ip pref 1 handle 101 flower
+
+	log_test "$test_name"
+}
+
+police_mtu_rx_test()
+{
+	police_mtu_common_test "police mtu (rx)" $rp1 ingress
+}
+
+police_mtu_tx_test()
+{
+	police_mtu_common_test "police mtu (tx)" $rp2 egress
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.34.1

