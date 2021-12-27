Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77DF47FA01
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 04:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhL0DxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 22:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbhL0DxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 22:53:11 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F26CC06173E;
        Sun, 26 Dec 2021 19:53:11 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f125so12753723pgc.0;
        Sun, 26 Dec 2021 19:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QohvkKpyJDtU9M9092zDpVIBEjTTVy7a01/50yenvsY=;
        b=UyW+dXlGNmUd0aQaITKthuxcsC9bSRv0WQ3QI7CHwqi4aJsC3culaovb0F/HgSM6Hy
         rMlDnS5oeHGaIT2yAxhXlxpKoRY1mKBxSATC1Uwl9pe3PvGP03RYD/flCI3c2ZBuIUE2
         QaQrGzJLVO14BfikKN6DhIS38M1har8zqLYmaJt0baV7AaeRPGdSF/Lw/e0b2mysaYjg
         eFyfSL6WCv6ibCfnoX1Vpt7N+xUQXBjBttSfNSdln3N5Pf1aTQW26jII3krNhM9NsAB7
         a/z/AomBES164mUOU/LvK+cZDok/qGmIrZtA7S0S9oZcSe4Nm1Kk2wCmuMOuARZQRy4+
         J95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QohvkKpyJDtU9M9092zDpVIBEjTTVy7a01/50yenvsY=;
        b=t1uiZfB72tsfZEYfxVh+19PHmYFTyVNuDA5Mnjy/ccHpoa5z2rX18j3iWpAdM+Km90
         EmtoHoqvRPrlDQCn1gTlQci75wTj1+PUQ9mtux8DpK6mXq241hwPPaj4F9L5SelLfVTz
         uO0xpbBdMpgPIzLJutE+NKjsfoQrA3vdF5d9Z8fM1YnK4iPowug5WSiCL/XHMH/vHn5v
         i/39y3wguwuumYq5On5GqSMQdGBFA0SDdW5bd5gl+1ZfJm6JJdOSm6VPTySIDtCrgut/
         dXJQVRnpKzFdpqEFYMoVoZU8wYu26875luxoIGG1F4fLe06Sx2Cq0W/WoNwLuIpM+rBc
         hRNw==
X-Gm-Message-State: AOAM531hzp3NMhW6CLJbUWXGkV/o+SjM/4rIlXPw/ftri2Xv6fHzdJoE
        J7UMf/rP1lZyW0wMM6/haHlmlWIG3mY=
X-Google-Smtp-Source: ABdhPJwUfU2Gd2A+Q5CBpxkNKl6ngiugI7OyJ22cahUFwSgBkMW3oLpWPk84GNkbhTFCWjYFpECLPA==
X-Received: by 2002:a63:794a:: with SMTP id u71mr1505030pgc.160.1640577189868;
        Sun, 26 Dec 2021 19:53:09 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i11sm15363747pfq.206.2021.12.26.19.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Dec 2021 19:53:09 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH nf] selftests/netfilter: switch to socat for tests using -q option
Date:   Mon, 27 Dec 2021 11:52:53 +0800
Message-Id: <20211227035253.144503-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nc cmd(nmap-ncat) that distributed with Fedora/Red Hat does not have
option -q. This make some tests failed with:

	nc: invalid option -- 'q'

Let's switch to socat which is far more dependable.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../testing/selftests/netfilter/ipip-conntrack-mtu.sh  |  9 +++++----
 tools/testing/selftests/netfilter/nf_nat_edemux.sh     | 10 +++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh b/tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh
index 4a6f5c3b3215..eb9553e4986b 100755
--- a/tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh
+++ b/tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh
@@ -41,7 +41,7 @@ checktool (){
 
 checktool "iptables --version" "run test without iptables"
 checktool "ip -Version" "run test without ip tool"
-checktool "which nc" "run test without nc (netcat)"
+checktool "which socat" "run test without socat"
 checktool "ip netns add ${r_a}" "create net namespace"
 
 for n in ${r_b} ${r_w} ${c_a} ${c_b};do
@@ -60,11 +60,12 @@ trap cleanup EXIT
 test_path() {
 	msg="$1"
 
-	ip netns exec ${c_b} nc -n -w 3 -q 3 -u -l -p 5000 > ${rx} < /dev/null &
+	ip netns exec ${c_b} socat -t 3 - udp4-listen:5000,reuseaddr > ${rx} < /dev/null &
 
 	sleep 1
 	for i in 1 2 3; do
-		head -c1400 /dev/zero | tr "\000" "a" | ip netns exec ${c_a} nc -n -w 1 -u 192.168.20.2 5000
+		head -c1400 /dev/zero | tr "\000" "a" | \
+			ip netns exec ${c_a} socat -t 1 -u STDIN UDP:192.168.20.2:5000
 	done
 
 	wait
@@ -189,7 +190,7 @@ ip netns exec ${r_w} sysctl -q net.ipv4.conf.all.forwarding=1 > /dev/null
 #---------------------
 #Now we send a 1400 bytes UDP packet from Client A to Client B:
 
-# clienta:~# head -c1400 /dev/zero | tr "\000" "a" | nc -u 192.168.20.2 5000
+# clienta:~# head -c1400 /dev/zero | tr "\000" "a" | socat -u STDIN UDP:192.168.20.2:5000
 test_path "without"
 
 # The IPv4 stack on Client A already knows the PMTU to Client B, so the
diff --git a/tools/testing/selftests/netfilter/nf_nat_edemux.sh b/tools/testing/selftests/netfilter/nf_nat_edemux.sh
index cfee3b65be0f..1092bbcb1fba 100755
--- a/tools/testing/selftests/netfilter/nf_nat_edemux.sh
+++ b/tools/testing/selftests/netfilter/nf_nat_edemux.sh
@@ -76,23 +76,23 @@ ip netns exec $ns2 ip route add 10.96.0.1 via 192.168.1.1
 sleep 1
 
 # add a persistent connection from the other namespace
-ip netns exec $ns2 nc -q 10 -w 10 192.168.1.1 5201 > /dev/null &
+ip netns exec $ns2 socat -t 10 - TCP:192.168.1.1:5201 > /dev/null &
 
 sleep 1
 
 # ip daddr:dport will be rewritten to 192.168.1.1 5201
 # NAT must reallocate source port 10000 because
 # 192.168.1.2:10000 -> 192.168.1.1:5201 is already in use
-echo test | ip netns exec $ns2 nc -w 3 -q 3 10.96.0.1 443 >/dev/null
+echo test | ip netns exec $ns2 socat -t 3 -u STDIN TCP:10.96.0.1:443 >/dev/null
 ret=$?
 
 kill $iperfs
 
-# Check nc can connect to 10.96.0.1:443 (aka 192.168.1.1:5201).
+# Check socat can connect to 10.96.0.1:443 (aka 192.168.1.1:5201).
 if [ $ret -eq 0 ]; then
-	echo "PASS: nc can connect via NAT'd address"
+	echo "PASS: socat can connect via NAT'd address"
 else
-	echo "FAIL: nc cannot connect via NAT'd address"
+	echo "FAIL: socat cannot connect via NAT'd address"
 	exit 1
 fi
 
-- 
2.31.1

