Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8A563D7B5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiK3OIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiK3OHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:32 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A346C769F8
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:04 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z20so24174469edc.13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vVvw7X/GbK1uw8NEy53Xer3Z7d7cB2KBB5y6WQtaEk=;
        b=XjUBpqcyqHxCl5bbgK7jToBOpwvQAdUjlUDfSdYpBivtym6A7Hjy9Ji9GWxsGn35wu
         whAgDCdPd0+GO3yKt9nTej1ougdD6W4+ONtAezMQEVHMah486nU2eRHa2Ze8lG1NGP7M
         Hzt4+vwj8IFJmGxXExxQK9QtOMP3vKsTLDGX7kMKZUGHqmi8XiqPQDuCtaIZ6Vy94vGg
         SoLlDV3wxdqceLXYUY8iY3KA3BQp+PuzlZdU7XeG252hFcD5T8JuexAobFdMDTNK2NAP
         X3ijy5gFhsZF7TcmD/uoEgrgBPPjTRr/4kjw6a0a0gyF5ZEJLU3gA7i9qEC+2m2hSpHb
         8cZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2vVvw7X/GbK1uw8NEy53Xer3Z7d7cB2KBB5y6WQtaEk=;
        b=N1PBh45LekUGp2hF79iDJ8/FUjbXxG3SfoPyO6Tl2QwbZ0FnJ6GoWSYBdMxM5KARlh
         hku7hu2pQ9H8ZjS93wYZ4hG2unGiMU7XpkYdqVrQ24st9rvpHBQtJX4I9P05x5GWzsqK
         T3qpcw0tJ1SV9aMuCFZ1B/naSkUT7u65lEiD2gjv8mjNmcUCrj4n9F+9s5+3w/WRBFWO
         5Q/llC1hav0Q/ZoUZXkk7IMC2hT0R7/9bJlX4YJmPS4Nk1x9JcTpYNIHlQ7p7TYhAwd6
         oX4bRmGk0O2UTNuPD47lRXO7JPUZkQPWcy1hdrN0QiXKTE/PSfce6tFMGZS9EP1NUGAK
         /KnA==
X-Gm-Message-State: ANoB5plR/zHVgR/li/APfP0HL/8it9QXvdGCeEYRFIbqeyHtSF0OzVcU
        skv7spm0F62WV+12Q5m6h75hvQ==
X-Google-Smtp-Source: AA0mqf7G0IhHkis17R7KEahp13i9wYGOGmhYQ7PgYOGtNq4ygFCdTa/jZGdlyCipBJ8O/77Zd7y/Bg==
X-Received: by 2002:a05:6402:ea0:b0:463:a83c:e019 with SMTP id h32-20020a0564020ea000b00463a83ce019mr39357779eda.253.1669817222886;
        Wed, 30 Nov 2022 06:07:02 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:07:02 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/11] selftests: mptcp: declare var as local
Date:   Wed, 30 Nov 2022 15:06:27 +0100
Message-Id: <20221130140637.409926-6-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4471; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=lUshWFmqLTSaxhy6jIUdB01u4qUlhoHgYrons8BADMM=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2NozzGzy2cE3zTK8cmVfAW4GfQ6Gk8h75OQbl18
 aHAzCo6JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djaAAKCRD2t4JPQmmgc94cD/
 4w5j2YieduhM2Ir7Q9nbuk6s10zRVFqoozqDn5HKr3y8keDSJotSnd6tkaGl1s8wRauAdWxqZ52X6q
 jKWBtCBElKSnFWg0iIg3wB8OcSdDqG5RFHg0Axcks7ANQvP1L/VOIl5EtJfbbRw0dPxgRqhMlgAQkx
 f3bKaTe/+17a7oBbF+m3ryHY/vr3EMSXsbqzOmy9IIJKi6Tfcc6Igl93ECukRmse/OkZ3jMNbxCYm3
 wtejSQM8lc8AphMo8AEugMjBsiHHNIP3wOZPEfgKHJbnZpBgII4ZL5iIzO7xVCIFem41UFaa/4k0Kx
 ZLaf5t59dh0BnuEj1VpZMB+3TZVRbL8BNU7rNk9kPh0WVZh7NxvrZDPELAsdyWY24Xno+4mdAXZlxa
 V2IOnDXjGsQsmeghitZbqSQXga+BHNJbdSW+uwdRqQX5lX7eyU3/MnZMEjp8aKf/R4RDurlkoCwYEX
 C1/Qx4myEgVyXGKzBjOkmtJZ/dtU+N6Eyjes5V0oK2V6vngSh4WkOHPnikfxFnMNH7xmXbXjTQV9ue
 GgICUbBYiaYTO7uUOTssR5Qn3R4VpS/gY14soly5lELLhTgET4A26wBh/dJQwUquG7xmDDRGSGBWzv
 gwGf3PYUlWd+EZDAbvjqB7wnTPJyA72XWSpiEjCYsFUisIJmXhAyZFByd/sw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just to avoid classical Bash pitfall where variables are accidentally
overridden by other functions because the proper scope has not been
defined.

That's also what is done in other MPTCP selftests scripts where all non
local variables are defined at the beginning of the script and the
others are defined with the "local" keyword.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 .../selftests/net/mptcp/mptcp_sockopt.sh      | 51 +++++++++++--------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index f74b237bcb32..1b70c0a304ce 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -22,6 +22,7 @@ add_mark_rules()
 	local ns=$1
 	local m=$2
 
+	local t
 	for t in iptables ip6tables; do
 		# just to debug: check we have multiple subflows connection requests
 		ip netns exec $ns $t -A OUTPUT -p tcp --syn -m mark --mark $m -j ACCEPT
@@ -36,6 +37,7 @@ add_mark_rules()
 
 init()
 {
+	local netns
 	for netns in "$ns1" "$ns2" "$ns_sbox";do
 		ip netns add $netns || exit $ksft_skip
 		ip -net $netns link set lo up
@@ -44,6 +46,7 @@ init()
 		ip netns exec $netns sysctl -q net.ipv4.conf.default.rp_filter=0
 	done
 
+	local i
 	for i in `seq 1 4`; do
 		ip link add ns1eth$i netns "$ns1" type veth peer name ns2eth$i netns "$ns2"
 		ip -net "$ns1" addr add 10.0.$i.1/24 dev ns1eth$i
@@ -73,6 +76,7 @@ init()
 
 cleanup()
 {
+	local netns
 	for netns in "$ns1" "$ns2" "$ns_sbox"; do
 		ip netns del $netns
 	done
@@ -103,15 +107,17 @@ check_mark()
 	local ns=$1
 	local af=$2
 
-	tables=iptables
+	local tables=iptables
 
 	if [ $af -eq 6 ];then
 		tables=ip6tables
 	fi
 
+	local counters values
 	counters=$(ip netns exec $ns $tables -v -L OUTPUT | grep DROP)
 	values=${counters%DROP*}
 
+	local v
 	for v in $values; do
 		if [ $v -ne 0 ]; then
 			echo "FAIL: got $tables $values in ns $ns , not 0 - not all expected packets marked" 1>&2
@@ -131,9 +137,9 @@ print_file_err()
 
 check_transfer()
 {
-	in=$1
-	out=$2
-	what=$3
+	local in=$1
+	local out=$2
+	local what=$3
 
 	cmp "$in" "$out" > /dev/null 2>&1
 	if [ $? -ne 0 ] ;then
@@ -156,18 +162,18 @@ is_v6()
 
 do_transfer()
 {
-	listener_ns="$1"
-	connector_ns="$2"
-	cl_proto="$3"
-	srv_proto="$4"
-	connect_addr="$5"
+	local listener_ns="$1"
+	local connector_ns="$2"
+	local cl_proto="$3"
+	local srv_proto="$4"
+	local connect_addr="$5"
 
-	port=12001
+	local port=12001
 
 	:> "$cout"
 	:> "$sout"
 
-	mptcp_connect="./mptcp_connect -r 20"
+	local mptcp_connect="./mptcp_connect -r 20"
 
 	local local_addr
 	if is_v6 "${connect_addr}"; then
@@ -180,7 +186,7 @@ do_transfer()
 		ip netns exec ${listener_ns} \
 			$mptcp_connect -t ${timeout_poll} -l -M 1 -p $port -s ${srv_proto} -c TIMESTAMPNS,TCPINQ \
 				${local_addr} < "$sin" > "$sout" &
-	spid=$!
+	local spid=$!
 
 	sleep 1
 
@@ -189,12 +195,12 @@ do_transfer()
 			$mptcp_connect -t ${timeout_poll} -M 2 -p $port -s ${cl_proto} -c TIMESTAMPNS,TCPINQ \
 				$connect_addr < "$cin" > "$cout" &
 
-	cpid=$!
+	local cpid=$!
 
 	wait $cpid
-	retc=$?
+	local retc=$?
 	wait $spid
-	rets=$?
+	local rets=$?
 
 	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
 		echo " client exit code $retc, server $rets" 1>&2
@@ -229,9 +235,9 @@ do_transfer()
 
 make_file()
 {
-	name=$1
-	who=$2
-	size=$3
+	local name=$1
+	local who=$2
+	local size=$3
 
 	dd if=/dev/urandom of="$name" bs=1024 count=$size 2> /dev/null
 	echo -e "\nMPTCP_TEST_FILE_END_MARKER" >> "$name"
@@ -264,9 +270,9 @@ do_mptcp_sockopt_tests()
 
 run_tests()
 {
-	listener_ns="$1"
-	connector_ns="$2"
-	connect_addr="$3"
+	local listener_ns="$1"
+	local connector_ns="$2"
+	local connect_addr="$3"
 	local lret=0
 
 	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr}
@@ -282,7 +288,7 @@ run_tests()
 do_tcpinq_test()
 {
 	ip netns exec "$ns_sbox" ./mptcp_inq "$@"
-	lret=$?
+	local lret=$?
 	if [ $lret -ne 0 ];then
 		ret=$lret
 		echo "FAIL: mptcp_inq $@" 1>&2
@@ -297,6 +303,7 @@ do_tcpinq_tests()
 {
 	local lret=0
 
+	local args
 	for args in "-t tcp" "-r tcp"; do
 		do_tcpinq_test $args
 		lret=$?
-- 
2.37.2

