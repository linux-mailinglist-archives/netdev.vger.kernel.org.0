Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96668423D35
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbhJFLty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbhJFLtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:49:49 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BE2C061755;
        Wed,  6 Oct 2021 04:47:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id l7so8910332edq.3;
        Wed, 06 Oct 2021 04:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vxpCd9DTD+L+m0nuHZPiU7pujsT7ePOGVZipNpzzkmY=;
        b=p6kpuSLH5GrXiQRUm8Wc/iqauzF/veeUIu5HFE566yVmikcq5hglXUs7ocopJ0vnRS
         mhw6keP3Dq8CvMBj+dO878mmZfx5qvsPTOU+Xj5zCi33DsAliH0GcS/5sRG/zniUe1Rg
         tv8HL9ixJtqVp9jl4/UENVZessdweSwru0IbAvlA7WzFibYNNiMzWl7BDll0p+HJY/Dj
         ldae5XOL4rsSgrVTCW91PSSLjBjnRCy4Ckbz8j+hxMGq26aqlCuEZ4slFV0HNKgiYgS3
         DCjfV+3BlJByPGxMBOcAgoIc98jifDPjs8+f+o+xgRM3vQSw51s1iNruBGBDbue8j7V/
         cbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vxpCd9DTD+L+m0nuHZPiU7pujsT7ePOGVZipNpzzkmY=;
        b=0TD6Uglwyh8GFYJ0td3h3x1OMrsCjW5f3IAldh037zRnK6FH40SmtTp7CyxSg/eiKm
         xTFW+Z5xBaKwGU48GgriD6pwdDI+uFO8WHTBUQm6A9MWXp2EXQ+zUvAqvem5Uw+FGXKH
         kFaNR4qEYC8H82gTu2/c6Xi+zckMOLPX9NaclzZOjEKAgRy0SKWknq9bD2R2cAhk2ZM9
         0BKs1GCgSjFhNXAr+vnwvPSI39QIQNGmnbn1sS1x1S4yoF8dzz0+2g3iHmEICaUnzy/X
         9CV7fMt5l4rHTo6nqLeIYpCygbG0WkuVOn9rkWoPpB0OhF1Rg7xpFNOa93MeijgItf2U
         k65w==
X-Gm-Message-State: AOAM531+VN7DT+GEtYBki/7qzlgdrrfAdDR4689DUdCu9j8AA3ltcPP/
        dMaD1d09vHcd9ZdqmkxB3iU=
X-Google-Smtp-Source: ABdhPJzhk4wz5dmckehgAsLblKzEufbUhssl6KO70BsAGxHGOEwhZ4RqRrSeIeukS1gQD2mp6SRXaw==
X-Received: by 2002:a17:906:3148:: with SMTP id e8mr31472956eje.240.1633520876292;
        Wed, 06 Oct 2021 04:47:56 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:47:55 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] selftests: net/fcnal: Use accept_dad=0 to avoid setup sleep
Date:   Wed,  6 Oct 2021 14:47:20 +0300
Message-Id: <9cfeec9f336bf6f5fe06309526820e9bbbc87ea3.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Duplicate Address Detection makes ipv6 addresses unavailable for a short
period after adding (average about 1 second). Adding sleep statements
avoid this but since all addresses in the test environment are
controlled from the same source we can just disable DAD for the entire
namespace.

Unlike sprinkling nodad to all ipv6 address additions this also skips
DAD for link-local-addresses.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 9cf05e6e0d9b..0bd60cd3bc06 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -357,11 +357,11 @@ create_vrf()
 	ip -netns ${ns} link set ${vrf} up
 	ip -netns ${ns} route add vrf ${vrf} unreachable default metric 8192
 	ip -netns ${ns} -6 route add vrf ${vrf} unreachable default metric 8192
 
 	ip -netns ${ns} addr add 127.0.0.1/8 dev ${vrf}
-	ip -netns ${ns} -6 addr add ::1 dev ${vrf} nodad
+	ip -netns ${ns} -6 addr add ::1 dev ${vrf}
 	if [ "${addr}" != "-" ]; then
 		ip -netns ${ns} addr add dev ${vrf} ${addr}
 	fi
 	if [ "${addr6}" != "-" ]; then
 		ip -netns ${ns} -6 addr add dev ${vrf} ${addr6}
@@ -378,10 +378,11 @@ create_ns()
 	local ns=$1
 	local addr=$2
 	local addr6=$3
 
 	ip netns add ${ns}
+	ip netns exec ${ns} sysctl -wq net.ipv6.conf.{all,default}.accept_dad=0
 
 	ip -netns ${ns} link set lo up
 	if [ "${addr}" != "-" ]; then
 		ip -netns ${ns} addr add dev lo ${addr}
 	fi
@@ -490,12 +491,10 @@ setup()
 	# tell ns-B how to get to remote addresses of ns-A
 	ip -netns ${NSB} ro add ${NSA_LO_IP}/32 via ${NSA_IP} dev ${NSB_DEV}
 	ip -netns ${NSB} ro add ${NSA_LO_IP6}/128 via ${NSA_IP6} dev ${NSB_DEV}
 
 	set +e
-
-	sleep 1
 }
 
 setup_lla_only()
 {
 	# make sure we are starting with a clean slate
@@ -520,12 +519,10 @@ setup_lla_only()
 	create_vrf ${NSA} ${VRF} ${VRF_TABLE} "-" "-"
 	ip -netns ${NSA} link set dev ${NSA_DEV} vrf ${VRF}
 	ip -netns ${NSA} link set dev ${NSA_DEV2} vrf ${VRF}
 
 	set +e
-
-	sleep 1
 }
 
 ################################################################################
 # IPv4
 
@@ -3014,11 +3011,11 @@ ipv6_udp_novrf()
 	sleep 1
 	run_cmd_nsb nettest -6 -D -r ${NSA_IP6}
 	log_test $? 0 "UDP in - LLA to GUA"
 
 	run_cmd_nsb ip -6 ro del ${NSA_IP6}/128 dev ${NSB_DEV}
-	run_cmd_nsb ip -6 addr add ${NSB_IP6}/64 dev ${NSB_DEV} nodad
+	run_cmd_nsb ip -6 addr add ${NSB_IP6}/64 dev ${NSB_DEV}
 }
 
 ipv6_udp_vrf()
 {
 	local a
@@ -3292,11 +3289,11 @@ ipv6_udp_vrf()
 	sleep 1
 	run_cmd_nsb nettest -6 -D -r ${NSA_IP6}
 	log_test $? 0 "UDP in - LLA to GUA"
 
 	run_cmd_nsb ip -6 ro del ${NSA_IP6}/128 dev ${NSB_DEV}
-	run_cmd_nsb ip -6 addr add ${NSB_IP6}/64 dev ${NSB_DEV} nodad
+	run_cmd_nsb ip -6 addr add ${NSB_IP6}/64 dev ${NSB_DEV}
 }
 
 ipv6_udp()
 {
         # should not matter, but set to known state
@@ -3742,11 +3739,11 @@ use_case_br()
 	setup_cmd ip addr del dev ${NSA_DEV} ${NSA_IP}/24
 	setup_cmd ip -6 addr del dev ${NSA_DEV} ${NSA_IP6}/64
 
 	setup_cmd ip link add br0 type bridge
 	setup_cmd ip addr add dev br0 ${NSA_IP}/24
-	setup_cmd ip -6 addr add dev br0 ${NSA_IP6}/64 nodad
+	setup_cmd ip -6 addr add dev br0 ${NSA_IP6}/64
 
 	setup_cmd ip li set ${NSA_DEV} master br0
 	setup_cmd ip li set ${NSA_DEV} up
 	setup_cmd ip li set br0 up
 	setup_cmd ip li set br0 vrf ${VRF}
@@ -3791,15 +3788,15 @@ use_case_br()
 
 	setup_cmd ip li set br0 nomaster
 	setup_cmd ip li add br0.100 link br0 type vlan id 100
 	setup_cmd ip li set br0.100 vrf ${VRF} up
 	setup_cmd ip    addr add dev br0.100 172.16.101.1/24
-	setup_cmd ip -6 addr add dev br0.100 2001:db8:101::1/64 nodad
+	setup_cmd ip -6 addr add dev br0.100 2001:db8:101::1/64
 
 	setup_cmd_nsb ip li add vlan100 link ${NSB_DEV} type vlan id 100
 	setup_cmd_nsb ip addr add dev vlan100 172.16.101.2/24
-	setup_cmd_nsb ip -6 addr add dev vlan100 2001:db8:101::2/64 nodad
+	setup_cmd_nsb ip -6 addr add dev vlan100 2001:db8:101::2/64
 	setup_cmd_nsb ip li set vlan100 up
 	sleep 1
 
 	rmmod br_netfilter 2>/dev/null
 
-- 
2.25.1

