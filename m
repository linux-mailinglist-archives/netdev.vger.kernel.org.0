Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D6B63D7BD
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiK3OIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiK3OHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:37 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FB38BD19
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id a16so2704305edb.9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrnGr1gkWDPzCdVnTO5Oj9Ll5rKnYAEwA2ORBCcWSm4=;
        b=P+WcvqQjAM6KwFqHF7sLEcO0W54sC+NQ38Lyd4ymCJlD0Ns7DBTfxzJ0wX9OHkM5aY
         PHlqvWmjcYKzjJ4yRDefk5uwrfEZyHsz16QAL797UDlxA0gDsKySoq7y5flP4Fwnfv+0
         e2/4wYIz1ia1w62FTW5/4kydUHLowlQCvzI+TNKGcNqfBNk7Gzg4FpLSTiKzNJpIg5My
         HwcqTEkB2OheDdo6onaYJz134QHHA1e3D/lGkkNSq446Xm4mfZ3d0/04qGDbn14t7Cg3
         y3dt5xNg/y7g53ydL7ljQuXoVsHVrUKpjWaZvxjv16YR/g7CykTJ3blvxeB7NaNVVlQZ
         gEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrnGr1gkWDPzCdVnTO5Oj9Ll5rKnYAEwA2ORBCcWSm4=;
        b=KfAiBeHsM3KNk6klVbakz6Yt8fQz/KDV+0UbMOCK3pnNC3YtgO2GUIUD3VtOdSlWEH
         LWARX48DVz5EmDSt7kYzEKa8tiUUHLssaUe/ySHdX9bQPdXxRytZSPao/11Zkq6PLdcr
         VmhEtyq6mzUmYlAGbOhuQ95EbRLcDa4s3XriJBVVZFzHrfrQlmUmlR8f6/E/QAHnIk+3
         SYDZsz3vrimZvatUXdWS+o3By3sGQVXGSVYcNwpysKYX0SAPmtzceWBMfBTGHqm0/gdk
         3UXL7ulCgxCZXhPi6GKrHqXW2cCXLxA0fL/r0ycOtjJ/oy85bauMDmhD0RD9y7vqGxYi
         SpUQ==
X-Gm-Message-State: ANoB5pkX0AJcgXPZL1n4WYVEvsIX4ox99+8wyeL4GUzgDehxktDYT3z8
        bYWMuUzZRDnFzVwvBEntNvHJYQ==
X-Google-Smtp-Source: AA0mqf5vpdclCuaS9lKTr4melk2oy8sb8GRO7RHf/ED85q/Ss7q2eNgWws6OUjNGz/oRau+ItdZH3Q==
X-Received: by 2002:a05:6402:f1c:b0:46a:b1a9:c34e with SMTP id i28-20020a0564020f1c00b0046ab1a9c34emr24734189eda.212.1669817228215;
        Wed, 30 Nov 2022 06:07:08 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:07:07 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/11] selftests: mptcp: make evts global in userspace_pm
Date:   Wed, 30 Nov 2022 15:06:30 +0100
Message-Id: <20221130140637.409926-9-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=22947; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=74f2sVkcyyZrceQDN5eAJcHPlf9GnlTPNPYe49lAAK8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2NoY+FUlXH7TR+COsAZpqEEQXL+TnKWYTK/5Jem
 qWu2SfKJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djaAAKCRD2t4JPQmmgc6nGEA
 Dw0PtJSxMXMfjdXTs7wGhit4XJJzGVyTQZDac1+CE9z34zeaJ5KaWQsX5NtKugQQaiV4pLmTZV1Qc0
 NYIahHZJGKiPq9BZpFay/J7E96Q5vKg/Yx2xjQIufzE7cX8iO2XE4hasFrplQZ5DLzyoEkBOXPPR9s
 4TNrcGcjf+HU/2CpttMbINaZqLXO+hmVgvrNRhEOrhzSd15MxVP0OxhwY7Q+0Td5WDFA/N2WNvCaci
 u3YVjJgIiX0JxZg825n2UxamFHN8VTDNV//uJQJMObDJ0i6eTjQU8WZ1bJz5YChVGwraJ+9rgIMtVs
 e/aay8tTQU6vIkxBoA9iXj0FOXKXWT2Khhc67T5zCgTLoC+cM1Fo7nBExOzhBGj94kGD6wrlpXOxET
 +c0KFkeIncjeZkqunaaBNck64vWU8LzSii/cn/opIEtqGdGNzcYLN4i08qx2LNBR7WCg3YxtO0Febf
 HdNcf0ienSjF6pJbC7eNscJPNUPl7IwvS7yb8XaR3UhSH6npUWw9+P3HfiHC6UN2SuYg+a2rpfwqAr
 DGUW/63bzOMfdtlYkR2o39iQx8AV8eM1k1plt6ODcHUADnxkugDPBKX8qeh4CS8FB9vJlro2kq+DJV
 HQMKbjMTw62o6AnjnROLDPweWqy6ckgqiNCFPaMgiQkY/NsyYuq4WO4rk25g==
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

From: Geliang Tang <geliang.tang@suse.com>

This patch makes server_evts and client_evts global in userspace_pm.sh,
then these two variables could be used in test_announce(), test_remove()
and test_subflows(). The local variable 'evts' in these three functions
then could be dropped.

Also move local variable 'file' as a global one.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 .../selftests/net/mptcp/userspace_pm.sh       | 213 ++++++++----------
 1 file changed, 93 insertions(+), 120 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 08a88ea47a29..91d6f30e2fe4 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -15,7 +15,11 @@ SUB_CLOSED=11      # MPTCP_EVENT_SUB_CLOSED
 AF_INET=2
 AF_INET6=10
 
-evts_pid=0
+file=""
+server_evts=""
+client_evts=""
+server_evts_pid=0
+client_evts_pid=0
 client4_pid=0
 server4_pid=0
 client6_pid=0
@@ -47,7 +51,7 @@ cleanup()
 {
 	echo "cleanup"
 
-	rm -rf $file
+	rm -rf $file $client_evts $server_evts
 
 	# Terminate the MPTCP connection and related processes
 	if [ $client4_pid -ne 0 ]; then
@@ -62,8 +66,11 @@ cleanup()
 	if [ $server6_pid -ne 0 ]; then
 		kill_wait $server6_pid
 	fi
-	if [ $evts_pid -ne 0 ]; then
-		kill_wait $evts_pid
+	if [ $server_evts_pid -ne 0 ]; then
+		kill_wait $server_evts_pid
+	fi
+	if [ $client_evts_pid -ne 0 ]; then
+		kill_wait $client_evts_pid
 	fi
 	local netns
 	for netns in "$ns1" "$ns2" ;do
@@ -113,8 +120,9 @@ make_file()
 
 make_connection()
 {
-	local file
-	file=$(mktemp)
+	if [ -z "$file" ]; then
+		file=$(mktemp)
+	fi
 	make_file "$file" "client"
 
 	local is_v6=$1
@@ -132,16 +140,24 @@ make_connection()
 
 	# Capture netlink events over the two network namespaces running
 	# the MPTCP client and server
-	local client_evts
-	client_evts=$(mktemp)
+	if [ -z "$client_evts" ]; then
+		client_evts=$(mktemp)
+	fi
 	:>"$client_evts"
+	if [ $client_evts_pid -ne 0 ]; then
+		kill_wait $client_evts_pid
+	fi
 	ip netns exec "$ns2" ./pm_nl_ctl events >> "$client_evts" 2>&1 &
-	local client_evts_pid=$!
-	local server_evts
-	server_evts=$(mktemp)
+	client_evts_pid=$!
+	if [ -z "$server_evts" ]; then
+		server_evts=$(mktemp)
+	fi
 	:>"$server_evts"
+	if [ $server_evts_pid -ne 0 ]; then
+		kill_wait $server_evts_pid
+	fi
 	ip netns exec "$ns1" ./pm_nl_ctl events >> "$server_evts" 2>&1 &
-	local server_evts_pid=$!
+	server_evts_pid=$!
 	sleep 0.5
 
 	# Run the server
@@ -159,7 +175,6 @@ make_connection()
 	sleep 1
 
 	# Capture client/server attributes from MPTCP connection netlink events
-	kill_wait $client_evts_pid
 
 	local client_token
 	local client_port
@@ -171,12 +186,10 @@ make_connection()
 	client_port=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$client_evts")
 	client_serverside=$(sed --unbuffered -n 's/.*\(server_side:\)\([[:digit:]]*\).*$/\2/p;q'\
 				      "$client_evts")
-	kill_wait $server_evts_pid
 	server_token=$(grep "type:1," "$server_evts" |
 		       sed --unbuffered -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q')
 	server_serverside=$(grep "type:1," "$server_evts" |
 			    sed --unbuffered -n 's/.*\(server_side:\)\([[:digit:]]*\).*$/\2/p;q')
-	rm -f "$client_evts" "$server_evts" "$file"
 
 	if [ "$client_token" != "" ] && [ "$server_token" != "" ] && [ "$client_serverside" = 0 ] &&
 		   [ "$server_serverside" = 1 ]
@@ -240,13 +253,8 @@ verify_announce_event()
 
 test_announce()
 {
-	local evts
-	evts=$(mktemp)
 	# Capture events on the network namespace running the server
-	:>"$evts"
-	ip netns exec "$ns1" ./pm_nl_ctl events >> "$evts" 2>&1 &
-	evts_pid=$!
-	sleep 0.5
+	:>"$server_evts"
 
 	# ADD_ADDR using an invalid token should result in no action
 	local invalid_token=$(( client4_token - 1))
@@ -254,7 +262,7 @@ test_announce()
 	   $client_addr_id dev ns2eth1 > /dev/null 2>&1
 
 	local type
-	type=$(sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
+	type=$(sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
 	stdbuf -o0 -e0 printf "ADD_ADDR 10.0.2.2 (ns2) => ns1, invalid token    \t\t"
 	if [ "$type" = "" ]
 	then
@@ -265,71 +273,63 @@ test_announce()
 	fi
 
 	# ADD_ADDR from the client to server machine reusing the subflow port
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns2"\
 	   ./pm_nl_ctl ann 10.0.2.2 token "$client4_token" id $client_addr_id dev\
 	   ns2eth1 > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "ADD_ADDR id:%d 10.0.2.2 (ns2) => ns1, reuse port \t\t" $client_addr_id
 	sleep 0.5
-	verify_announce_event "$evts" "$ANNOUNCED" "$server4_token" "10.0.2.2" "$client_addr_id"\
+	verify_announce_event $server_evts $ANNOUNCED $server4_token "10.0.2.2" $client_addr_id \
 			      "$client4_port"
 
 	# ADD_ADDR6 from the client to server machine reusing the subflow port
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl ann\
 	   dead:beef:2::2 token "$client6_token" id $client_addr_id dev ns2eth1 > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "ADD_ADDR6 id:%d dead:beef:2::2 (ns2) => ns1, reuse port\t\t" $client_addr_id
 	sleep 0.5
-	verify_announce_event "$evts" "$ANNOUNCED" "$server6_token" "dead:beef:2::2"\
+	verify_announce_event "$server_evts" "$ANNOUNCED" "$server6_token" "dead:beef:2::2"\
 			      "$client_addr_id" "$client6_port" "v6"
 
 	# ADD_ADDR from the client to server machine using a new port
-	:>"$evts"
+	:>"$server_evts"
 	client_addr_id=$((client_addr_id+1))
 	ip netns exec "$ns2" ./pm_nl_ctl ann 10.0.2.2 token "$client4_token" id\
 	   $client_addr_id dev ns2eth1 port $new4_port > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "ADD_ADDR id:%d 10.0.2.2 (ns2) => ns1, new port \t\t\t" $client_addr_id
 	sleep 0.5
-	verify_announce_event "$evts" "$ANNOUNCED" "$server4_token" "10.0.2.2"\
+	verify_announce_event "$server_evts" "$ANNOUNCED" "$server4_token" "10.0.2.2"\
 			      "$client_addr_id" "$new4_port"
 
-	kill_wait $evts_pid
-
 	# Capture events on the network namespace running the client
-	:>"$evts"
-	ip netns exec "$ns2" ./pm_nl_ctl events >> "$evts" 2>&1 &
-	evts_pid=$!
-	sleep 0.5
+	:>"$client_evts"
 
 	# ADD_ADDR from the server to client machine reusing the subflow port
 	ip netns exec "$ns1" ./pm_nl_ctl ann 10.0.2.1 token "$server4_token" id\
 	   $server_addr_id dev ns1eth2 > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "ADD_ADDR id:%d 10.0.2.1 (ns1) => ns2, reuse port \t\t" $server_addr_id
 	sleep 0.5
-	verify_announce_event "$evts" "$ANNOUNCED" "$client4_token" "10.0.2.1"\
+	verify_announce_event "$client_evts" "$ANNOUNCED" "$client4_token" "10.0.2.1"\
 			      "$server_addr_id" "$app4_port"
 
 	# ADD_ADDR6 from the server to client machine reusing the subflow port
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl ann dead:beef:2::1 token "$server6_token" id\
 	   $server_addr_id dev ns1eth2 > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "ADD_ADDR6 id:%d dead:beef:2::1 (ns1) => ns2, reuse port\t\t" $server_addr_id
 	sleep 0.5
-	verify_announce_event "$evts" "$ANNOUNCED" "$client6_token" "dead:beef:2::1"\
+	verify_announce_event "$client_evts" "$ANNOUNCED" "$client6_token" "dead:beef:2::1"\
 			      "$server_addr_id" "$app6_port" "v6"
 
 	# ADD_ADDR from the server to client machine using a new port
-	:>"$evts"
+	:>"$client_evts"
 	server_addr_id=$((server_addr_id+1))
 	ip netns exec "$ns1" ./pm_nl_ctl ann 10.0.2.1 token "$server4_token" id\
 	   $server_addr_id dev ns1eth2 port $new4_port > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "ADD_ADDR id:%d 10.0.2.1 (ns1) => ns2, new port \t\t\t" $server_addr_id
 	sleep 0.5
-	verify_announce_event "$evts" "$ANNOUNCED" "$client4_token" "10.0.2.1"\
+	verify_announce_event "$client_evts" "$ANNOUNCED" "$client4_token" "10.0.2.1"\
 			      "$server_addr_id" "$new4_port"
-
-	kill_wait $evts_pid
-	rm -f "$evts"
 }
 
 verify_remove_event()
@@ -357,14 +357,8 @@ verify_remove_event()
 
 test_remove()
 {
-	local evts
-	evts=$(mktemp)
-
 	# Capture events on the network namespace running the server
-	:>"$evts"
-	ip netns exec "$ns1" ./pm_nl_ctl events >> "$evts" 2>&1 &
-	evts_pid=$!
-	sleep 0.5
+	:>"$server_evts"
 
 	# RM_ADDR using an invalid token should result in no action
 	local invalid_token=$(( client4_token - 1 ))
@@ -373,7 +367,7 @@ test_remove()
 	stdbuf -o0 -e0 printf "RM_ADDR id:%d ns2 => ns1, invalid token                    \t"\
 	       $client_addr_id
 	local type
-	type=$(sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
+	type=$(sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
 	if [ "$type" = "" ]
 	then
 		stdbuf -o0 -e0 printf "[OK]\n"
@@ -387,7 +381,7 @@ test_remove()
 	   $invalid_id > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "RM_ADDR id:%d ns2 => ns1, invalid id                    \t"\
 	       $invalid_id
-	type=$(sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
+	type=$(sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
 	if [ "$type" = "" ]
 	then
 		stdbuf -o0 -e0 printf "[OK]\n"
@@ -396,40 +390,35 @@ test_remove()
 	fi
 
 	# RM_ADDR from the client to server machine
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl rem token "$client4_token" id\
 	   $client_addr_id > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "RM_ADDR id:%d ns2 => ns1                                \t"\
 	       $client_addr_id
 	sleep 0.5
-	verify_remove_event "$evts" "$REMOVED" "$server4_token" "$client_addr_id"
+	verify_remove_event "$server_evts" "$REMOVED" "$server4_token" "$client_addr_id"
 
 	# RM_ADDR from the client to server machine
-	:>"$evts"
+	:>"$server_evts"
 	client_addr_id=$(( client_addr_id - 1 ))
 	ip netns exec "$ns2" ./pm_nl_ctl rem token "$client4_token" id\
 	   $client_addr_id > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "RM_ADDR id:%d ns2 => ns1                                \t"\
 	       $client_addr_id
 	sleep 0.5
-	verify_remove_event "$evts" "$REMOVED" "$server4_token" "$client_addr_id"
+	verify_remove_event "$server_evts" "$REMOVED" "$server4_token" "$client_addr_id"
 
 	# RM_ADDR6 from the client to server machine
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl rem token "$client6_token" id\
 	   $client_addr_id > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "RM_ADDR6 id:%d ns2 => ns1                               \t"\
 	       $client_addr_id
 	sleep 0.5
-	verify_remove_event "$evts" "$REMOVED" "$server6_token" "$client_addr_id"
-
-	kill_wait $evts_pid
+	verify_remove_event "$server_evts" "$REMOVED" "$server6_token" "$client_addr_id"
 
 	# Capture events on the network namespace running the client
-	:>"$evts"
-	ip netns exec "$ns2" ./pm_nl_ctl events >> "$evts" 2>&1 &
-	evts_pid=$!
-	sleep 0.5
+	:>"$client_evts"
 
 	# RM_ADDR from the server to client machine
 	ip netns exec "$ns1" ./pm_nl_ctl rem token "$server4_token" id\
@@ -437,27 +426,24 @@ test_remove()
 	stdbuf -o0 -e0 printf "RM_ADDR id:%d ns1 => ns2                                \t"\
 	       $server_addr_id
 	sleep 0.5
-	verify_remove_event "$evts" "$REMOVED" "$client4_token" "$server_addr_id"
+	verify_remove_event "$client_evts" "$REMOVED" "$client4_token" "$server_addr_id"
 
 	# RM_ADDR from the server to client machine
-	:>"$evts"
+	:>"$client_evts"
 	server_addr_id=$(( server_addr_id - 1 ))
 	ip netns exec "$ns1" ./pm_nl_ctl rem token "$server4_token" id\
 	   $server_addr_id > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "RM_ADDR id:%d ns1 => ns2                                \t" $server_addr_id
 	sleep 0.5
-	verify_remove_event "$evts" "$REMOVED" "$client4_token" "$server_addr_id"
+	verify_remove_event "$client_evts" "$REMOVED" "$client4_token" "$server_addr_id"
 
 	# RM_ADDR6 from the server to client machine
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl rem token "$server6_token" id\
 	   $server_addr_id > /dev/null 2>&1
 	stdbuf -o0 -e0 printf "RM_ADDR6 id:%d ns1 => ns2                               \t" $server_addr_id
 	sleep 0.5
-	verify_remove_event "$evts" "$REMOVED" "$client6_token" "$server_addr_id"
-
-	kill_wait $evts_pid
-	rm -f "$evts"
+	verify_remove_event "$client_evts" "$REMOVED" "$client6_token" "$server_addr_id"
 }
 
 verify_subflow_events()
@@ -533,13 +519,8 @@ verify_subflow_events()
 
 test_subflows()
 {
-	local evts
-	evts=$(mktemp)
 	# Capture events on the network namespace running the server
-	:>"$evts"
-	ip netns exec "$ns1" ./pm_nl_ctl events >> "$evts" 2>&1 &
-	evts_pid=$!
-	sleep 0.5
+	:>"$server_evts"
 
 	# Attempt to add a listener at 10.0.2.2:<subflow-port>
 	ip netns exec "$ns2" ./pm_nl_ctl listen 10.0.2.2\
@@ -552,25 +533,25 @@ test_subflows()
 	sleep 0.5
 
 	# CREATE_SUBFLOW from server to client machine
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl csf lip 10.0.2.1 lid 23 rip 10.0.2.2\
 	   rport "$client4_port" token "$server4_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_ESTABLISHED" "$server4_token" "$AF_INET" "10.0.2.1"\
+	verify_subflow_events $server_evts $SUB_ESTABLISHED $server4_token $AF_INET "10.0.2.1" \
 			      "10.0.2.2" "$client4_port" "23" "$client_addr_id" "ns1" "ns2"
 
 	# Delete the listener from the client ns, if one was created
 	kill_wait $listener_pid
 
 	local sport
-	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
+	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
 
 	# DESTROY_SUBFLOW from server to client machine
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl dsf lip 10.0.2.1 lport "$sport" rip 10.0.2.2 rport\
 	   "$client4_port" token "$server4_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_CLOSED" "$server4_token" "$AF_INET" "10.0.2.1"\
+	verify_subflow_events "$server_evts" "$SUB_CLOSED" "$server4_token" "$AF_INET" "10.0.2.1"\
 			      "10.0.2.2" "$client4_port" "23" "$client_addr_id" "ns1" "ns2"
 
 	# RM_ADDR from client to server machine
@@ -584,31 +565,31 @@ test_subflows()
 	listener_pid=$!
 
 	# ADD_ADDR6 from client to server machine reusing the subflow port
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl ann dead:beef:2::2 token "$client6_token" id\
 	   $client_addr_id > /dev/null 2>&1
 	sleep 0.5
 
 	# CREATE_SUBFLOW6 from server to client machine
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl csf lip dead:beef:2::1 lid 23 rip\
 	   dead:beef:2::2 rport "$client6_port" token "$server6_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_ESTABLISHED" "$server6_token" "$AF_INET6"\
+	verify_subflow_events "$server_evts" "$SUB_ESTABLISHED" "$server6_token" "$AF_INET6"\
 			      "dead:beef:2::1" "dead:beef:2::2" "$client6_port" "23"\
 			      "$client_addr_id" "ns1" "ns2"
 
 	# Delete the listener from the client ns, if one was created
 	kill_wait $listener_pid
 
-	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
+	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
 
 	# DESTROY_SUBFLOW6 from server to client machine
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl dsf lip dead:beef:2::1 lport "$sport" rip\
 	   dead:beef:2::2 rport "$client6_port" token "$server6_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_CLOSED" "$server6_token" "$AF_INET6"\
+	verify_subflow_events "$server_evts" "$SUB_CLOSED" "$server6_token" "$AF_INET6"\
 			      "dead:beef:2::1" "dead:beef:2::2" "$client6_port" "23"\
 			      "$client_addr_id" "ns1" "ns2"
 
@@ -623,44 +604,39 @@ test_subflows()
 	listener_pid=$!
 
 	# ADD_ADDR from client to server machine using a new port
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl ann 10.0.2.2 token "$client4_token" id\
 	   $client_addr_id port $new4_port > /dev/null 2>&1
 	sleep 0.5
 
 	# CREATE_SUBFLOW from server to client machine
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl csf lip 10.0.2.1 lid 23 rip 10.0.2.2 rport\
 	   $new4_port token "$server4_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_ESTABLISHED" "$server4_token" "$AF_INET"\
+	verify_subflow_events "$server_evts" "$SUB_ESTABLISHED" "$server4_token" "$AF_INET"\
 			      "10.0.2.1" "10.0.2.2" "$new4_port" "23"\
 			      "$client_addr_id" "ns1" "ns2"
 
 	# Delete the listener from the client ns, if one was created
 	kill_wait $listener_pid
 
-	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
+	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
 
 	# DESTROY_SUBFLOW from server to client machine
-	:>"$evts"
+	:>"$server_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl dsf lip 10.0.2.1 lport "$sport" rip 10.0.2.2 rport\
 	   $new4_port token "$server4_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_CLOSED" "$server4_token" "$AF_INET" "10.0.2.1"\
+	verify_subflow_events "$server_evts" "$SUB_CLOSED" "$server4_token" "$AF_INET" "10.0.2.1"\
 			      "10.0.2.2" "$new4_port" "23" "$client_addr_id" "ns1" "ns2"
 
 	# RM_ADDR from client to server machine
 	ip netns exec "$ns2" ./pm_nl_ctl rem id $client_addr_id token\
 	   "$client4_token" > /dev/null 2>&1
 
-	kill_wait $evts_pid
-
 	# Capture events on the network namespace running the client
-	:>"$evts"
-	ip netns exec "$ns2" ./pm_nl_ctl events >> "$evts" 2>&1 &
-	evts_pid=$!
-	sleep 0.5
+	:>"$client_evts"
 
 	# Attempt to add a listener at 10.0.2.1:<subflow-port>
 	ip netns exec "$ns1" ./pm_nl_ctl listen 10.0.2.1\
@@ -673,24 +649,24 @@ test_subflows()
 	sleep 0.5
 
 	# CREATE_SUBFLOW from client to server machine
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl csf lip 10.0.2.2 lid 23 rip 10.0.2.1 rport\
 	   $app4_port token "$client4_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_ESTABLISHED" "$client4_token" "$AF_INET" "10.0.2.2"\
+	verify_subflow_events $client_evts $SUB_ESTABLISHED $client4_token $AF_INET "10.0.2.2"\
 			      "10.0.2.1" "$app4_port" "23" "$server_addr_id" "ns2" "ns1"
 
 	# Delete the listener from the server ns, if one was created
 	kill_wait $listener_pid
 
-	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
+	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$client_evts")
 
 	# DESTROY_SUBFLOW from client to server machine
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl dsf lip 10.0.2.2 lport "$sport" rip 10.0.2.1 rport\
 	   $app4_port token "$client4_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_CLOSED" "$client4_token" "$AF_INET" "10.0.2.2"\
+	verify_subflow_events "$client_evts" "$SUB_CLOSED" "$client4_token" "$AF_INET" "10.0.2.2"\
 			      "10.0.2.1" "$app4_port" "23" "$server_addr_id" "ns2" "ns1"
 
 	# RM_ADDR from server to client machine
@@ -704,17 +680,17 @@ test_subflows()
 	listener_pid=$!
 
 	# ADD_ADDR6 from server to client machine reusing the subflow port
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl ann dead:beef:2::1 token "$server6_token" id\
 	   $server_addr_id > /dev/null 2>&1
 	sleep 0.5
 
 	# CREATE_SUBFLOW6 from client to server machine
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl csf lip dead:beef:2::2 lid 23 rip\
 	   dead:beef:2::1 rport $app6_port token "$client6_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_ESTABLISHED" "$client6_token"\
+	verify_subflow_events "$client_evts" "$SUB_ESTABLISHED" "$client6_token"\
 			      "$AF_INET6" "dead:beef:2::2"\
 			      "dead:beef:2::1" "$app6_port" "23"\
 			      "$server_addr_id" "ns2" "ns1"
@@ -722,14 +698,14 @@ test_subflows()
 	# Delete the listener from the server ns, if one was created
 	kill_wait $listener_pid
 
-	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
+	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$client_evts")
 
 	# DESTROY_SUBFLOW6 from client to server machine
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl dsf lip dead:beef:2::2 lport "$sport" rip\
 	   dead:beef:2::1 rport $app6_port token "$client6_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_CLOSED" "$client6_token" "$AF_INET6" "dead:beef:2::2"\
+	verify_subflow_events $client_evts $SUB_CLOSED $client6_token $AF_INET6 "dead:beef:2::2"\
 			      "dead:beef:2::1" "$app6_port" "23" "$server_addr_id" "ns2" "ns1"
 
 	# RM_ADDR6 from server to client machine
@@ -743,38 +719,35 @@ test_subflows()
 	listener_pid=$!
 
 	# ADD_ADDR from server to client machine using a new port
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns1" ./pm_nl_ctl ann 10.0.2.1 token "$server4_token" id\
 	   $server_addr_id port $new4_port > /dev/null 2>&1
 	sleep 0.5
 
 	# CREATE_SUBFLOW from client to server machine
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl csf lip 10.0.2.2 lid 23 rip 10.0.2.1 rport\
 	   $new4_port token "$client4_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_ESTABLISHED" "$client4_token" "$AF_INET"\
+	verify_subflow_events "$client_evts" "$SUB_ESTABLISHED" "$client4_token" "$AF_INET"\
 			      "10.0.2.2" "10.0.2.1" "$new4_port" "23" "$server_addr_id" "ns2" "ns1"
 
 	# Delete the listener from the server ns, if one was created
 	kill_wait $listener_pid
 
-	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts")
+	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$client_evts")
 
 	# DESTROY_SUBFLOW from client to server machine
-	:>"$evts"
+	:>"$client_evts"
 	ip netns exec "$ns2" ./pm_nl_ctl dsf lip 10.0.2.2 lport "$sport" rip 10.0.2.1 rport\
 	   $new4_port token "$client4_token" > /dev/null 2>&1
 	sleep 0.5
-	verify_subflow_events "$evts" "$SUB_CLOSED" "$client4_token" "$AF_INET" "10.0.2.2"\
+	verify_subflow_events "$client_evts" "$SUB_CLOSED" "$client4_token" "$AF_INET" "10.0.2.2"\
 			      "10.0.2.1" "$new4_port" "23" "$server_addr_id" "ns2" "ns1"
 
 	# RM_ADDR from server to client machine
 	ip netns exec "$ns1" ./pm_nl_ctl rem id $server_addr_id token\
 	   "$server4_token" > /dev/null 2>&1
-
-	kill_wait $evts_pid
-	rm -f "$evts"
 }
 
 test_prio()
-- 
2.37.2

