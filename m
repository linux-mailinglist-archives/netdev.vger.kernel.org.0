Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B417E678E31
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbjAXCUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbjAXCUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:23 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259C03A86C
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:19 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id a25so12023105qto.10
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzGZVmjJFztVwIL/kmRyh2xhmuCyvIR0WPg0O8eXD2w=;
        b=pFTvrrArnZcSQ6dAthmWCgYA1PN8Dukud1Or51xTM/7dqeuo4UW5cvLuypUkCEdPCG
         lYZn0cMfSY6jxtno5eLDALCUK6GNUtqPkFDRxc3PWdHp39NQmkw4CofvbpCIl5B7M8+o
         ISohoG5Htm856YD8uLG3A0GeqQZJ77yto8iWh+dHimH4M7+phZjW7xDE207JLWCKTNyj
         kmYjc5Uu3+aK684DeDSJr93zn2m12zxZVBaLUXtZ9SiQ15vwevEWIcart04rbZx+goCD
         v5QtDaoE2Po7ddxvUNanQY04XHpdl4YQsma6Nys8IUCZRIIGFmIKev5mI9oOkJWUGITF
         GTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzGZVmjJFztVwIL/kmRyh2xhmuCyvIR0WPg0O8eXD2w=;
        b=7m7nhq2F8mYThG1/QP7qolb61VRBPwszG7oFMvmvIuo85SRZJloLLYJR9O6J5OBTkn
         DsiTJqJAgdYblc7N128WZUxsOlFbEPOePlmk3OQwFX5AufwaMErArS8rdy+t6JbIKzu+
         W1s4wLFLkzRyXRYmRoZil6h7yicq00eo0YiJ31HjIQFV9umzuiY8dRTukhuOzoT6J1sS
         0AqO0inKj1DEA512NdWmXzN/r/e3jc0ZKp+0pPNYUEHOq3dvleoppNzFKCOWPNGzB4xX
         trZAb95NOZ88IQHQY7SKsU9jRqWI53djq40tFUPEk8afGd44Xbgg2vcd/FeuIltUFMU9
         g22g==
X-Gm-Message-State: AFqh2kqf02me+EklL6ZkU2BhfCoLfWa9/0z1Kq8Enb/lTtZ6it2AOg0/
        xfbcCtO3AUXc/4Rcq9S8ZlBXY978ibzvoA==
X-Google-Smtp-Source: AMrXdXvoCsrc/37iK2ulJNqG0waiIoLcMzHOyGcX3VyeyeN3eizXg3ozXqF0HhdncalpIEBlSriLZQ==
X-Received: by 2002:a05:622a:5d9a:b0:3b6:3494:175 with SMTP id fu26-20020a05622a5d9a00b003b634940175mr39901988qtb.66.1674526818882;
        Mon, 23 Jan 2023 18:20:18 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:18 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv2 net-next 10/10] selftests: add a selftest for ipv4 big tcp
Date:   Mon, 23 Jan 2023 21:20:04 -0500
Message-Id: <8b15078200bc9e39a9be924ea3e05ddb5449064a.1674526718.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674526718.git.lucien.xin@gmail.com>
References: <cover.1674526718.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test runs on the client-router-server topo, and monitors the traffic
on the RX devices of router and server while sending BIG TCP packets with
netperf from client to server. Meanwhile, it changes 'tso' on the TX devs
and 'gro' on the RX devs. Then it checks if any BIG TCP packets appears
on the RX devs with 'iptables -m length ! --length 0:65535' for each case.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 tools/testing/selftests/net/Makefile   |   1 +
 tools/testing/selftests/net/big_tcp.sh | 140 +++++++++++++++++++++++++
 2 files changed, 141 insertions(+)
 create mode 100644 tools/testing/selftests/net/big_tcp.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 47314f0b3006..2b26b1c20198 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -76,6 +76,7 @@ TEST_PROGS += sctp_vrf.sh
 TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
 TEST_GEN_FILES += nat6to4.o
+TEST_PROGS += big_tcp.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/big_tcp.sh b/tools/testing/selftests/net/big_tcp.sh
new file mode 100644
index 000000000000..af1fd60de71d
--- /dev/null
+++ b/tools/testing/selftests/net/big_tcp.sh
@@ -0,0 +1,140 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Testing For BIG TCP.
+# TOPO: CLIENT_NS (link0)<--->(link1) ROUTER_NS (link2)<--->(link3) SERVER_NS
+
+CLIENT_NS=$(mktemp -u client-XXXXXXXX)
+CLIENT_IP4="198.51.100.1"
+
+SERVER_NS=$(mktemp -u server-XXXXXXXX)
+SERVER_IP4="203.0.113.1"
+
+ROUTER_NS=$(mktemp -u router-XXXXXXXX)
+SERVER_GW4="203.0.113.2"
+CLIENT_GW4="198.51.100.2"
+
+MAX_SIZE=128000
+CHK_SIZE=65535
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+setup() {
+	ip netns add $CLIENT_NS
+	ip netns add $SERVER_NS
+	ip netns add $ROUTER_NS
+	ip -net $ROUTER_NS link add link1 type veth peer name link0 netns $CLIENT_NS
+	ip -net $ROUTER_NS link add link2 type veth peer name link3 netns $SERVER_NS
+
+	ip -net $CLIENT_NS link set link0 up
+	ip -net $CLIENT_NS addr add $CLIENT_IP4/24 dev link0
+	ip -net $CLIENT_NS route add $SERVER_IP4 dev link0 via $CLIENT_GW4
+	ip -net $CLIENT_NS link set dev link0 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip net exec $CLIENT_NS sysctl -wq net.ipv4.tcp_window_scaling=10
+
+	ip -net $ROUTER_NS link set link1 up
+	ip -net $ROUTER_NS link set link2 up
+	ip -net $ROUTER_NS addr add $CLIENT_GW4/24 dev link1
+	ip -net $ROUTER_NS addr add $SERVER_GW4/24 dev link2
+	ip -net $ROUTER_NS link set dev link1 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip -net $ROUTER_NS link set dev link2 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip net exec $ROUTER_NS sysctl -wq net.ipv4.ip_forward=1
+
+	ip -net $SERVER_NS link set link3 up
+	ip -net $SERVER_NS addr add $SERVER_IP4/24 dev link3
+	ip -net $SERVER_NS route add $CLIENT_IP4 dev link3 via $SERVER_GW4
+	ip -net $SERVER_NS link set dev link3 gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
+	ip net exec $SERVER_NS sysctl -wq net.ipv4.tcp_window_scaling=10
+	ip net exec $SERVER_NS netserver 2>&1 >/dev/null
+}
+
+cleanup() {
+	ip net exec $SERVER_NS pkill netserver
+	ip -net $ROUTER_NS link del link1
+	ip -net $ROUTER_NS link del link2
+	ip netns del "$CLIENT_NS"
+	ip netns del "$SERVER_NS"
+	ip netns del "$ROUTER_NS"
+}
+
+start_counter() {
+	local ipt="iptables"
+	local iface=$1
+	local netns=$2
+
+	ip net exec $netns $ipt -t raw -A PREROUTING -i $iface \
+		-m length ! --length 0:$CHK_SIZE -j ACCEPT
+}
+
+check_counter() {
+	local ipt="iptables"
+	local iface=$1
+	local netns=$2
+
+	test `ip net exec $netns $ipt -t raw -L -v |grep $iface | awk '{print $1}'` != "0"
+}
+
+stop_counter() {
+	local ipt="iptables"
+	local iface=$1
+	local netns=$2
+
+	ip net exec $netns $ipt -t raw -D PREROUTING -i $iface \
+		-m length ! --length 0:$CHK_SIZE -j ACCEPT
+}
+
+do_netperf() {
+	local serip=$SERVER_IP4
+	local netns=$1
+
+	ip net exec $netns netperf -$NF -t TCP_STREAM -H $serip 2>&1 >/dev/null
+}
+
+do_test() {
+	local cli_tso=$1
+	local gw_gro=$2
+	local gw_tso=$3
+	local ser_gro=$4
+	local ret="PASS"
+
+	ip net exec $CLIENT_NS ethtool -K link0 tso $cli_tso
+	ip net exec $ROUTER_NS ethtool -K link1 gro $gw_gro
+	ip net exec $ROUTER_NS ethtool -K link2 tso $gw_tso
+	ip net exec $SERVER_NS ethtool -K link3 gro $ser_gro
+
+	start_counter link1 $ROUTER_NS
+	start_counter link3 $SERVER_NS
+	do_netperf $CLIENT_NS
+
+	if check_counter link1 $ROUTER_NS; then
+		check_counter link3 $SERVER_NS || ret="FAIL_on_link3"
+	else
+		ret="FAIL_on_link1"
+	fi
+
+	stop_counter link1 $ROUTER_NS
+	stop_counter link3 $SERVER_NS
+	printf "%-9s %-8s %-8s %-8s: [%s]\n" \
+		$cli_tso $gw_gro $gw_tso $ser_gro $ret
+	test $ret = "PASS"
+}
+
+testup() {
+	echo "CLI GSO | GW GRO | GW GSO | SER GRO" && \
+	do_test "on"  "on"  "on"  "on"  && \
+	do_test "on"  "off" "on"  "off" && \
+	do_test "off" "on"  "on"  "on"  && \
+	do_test "on"  "on"  "off" "on"  && \
+	do_test "off" "on"  "off" "on"
+}
+
+if ! netperf -V &> /dev/null; then
+	echo "SKIP: Could not run test without netperf tool"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+setup && echo "Testing for BIG TCP:" && \
+NF=4 testup && echo "***v4 Tests Done***"
+exit $?
-- 
2.31.1

