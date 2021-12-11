Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F44E4714DD
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 18:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhLKRLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 12:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhLKRLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 12:11:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4A8C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 09:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 91783CE09E5
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 17:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E59C004DD;
        Sat, 11 Dec 2021 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639242695;
        bh=775bdAN3IrSb5WpLkm6k+sP9Db+cCiOdjCd5In4omlQ=;
        h=From:To:Cc:Subject:Date:From;
        b=WGQtEdg2YCPYDoji3Pr5s7g2Xbfsqj335GMfrK8x9Pgjx1ppUfbRYocxhb7Knuibr
         COxSb21/7Zs2Wq6et/cR7iKJgUXpn839mvb0alWQSsGEPAXbGv2cN47suunh8efTtY
         NxpB4Htx9+TZqfstKyc9ZkRB2NWZC+gO+1QJGQ3/GLuahTHhtfM8ee5KKyNeWovJ4e
         BvkpARmoG2zhSr0JRECx8jENjZ/BSQg1lnqo9qAIr73cjXv20LQHZ+dsyzvGSC8AB8
         0q20BZ6//WNc+s/4cl5pQ66UTRokVzdajWk8g+ge9lNoX3RK7RjPh0TMOZRvyNA75O
         ljLesDB68rGtg==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>
Subject: [PATCH net] selftests: Add duplicate config only for MD5 VRF tests
Date:   Sat, 11 Dec 2021 10:11:30 -0700
Message-Id: <20211211171130.74589-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit referenced below added configuration in the default VRF that
duplicates a VRF to check MD5 passwords are properly used and fail
when expected. That config should not be added all the time as it
can cause tests to pass that should not (by matching on default VRF
setup when it should not). Move the duplicate setup to a function
that is only called for the MD5 tests and add a cleanup function
to remove it after the MD5 tests.

Fixes: 5cad8bce26e0 ("fcnal-test: Add TCP MD5 tests for VRF")
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 26 +++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 32d5f7bc588e..d0c45023b4d4 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -462,6 +462,22 @@ cleanup()
 	ip netns del ${NSC} >/dev/null 2>&1
 }
 
+cleanup_vrf_dup()
+{
+	ip link del ${NSA_DEV2} >/dev/null 2>&1
+	ip netns pids ${NSC} | xargs kill 2>/dev/null
+	ip netns del ${NSC} >/dev/null 2>&1
+}
+
+setup_vrf_dup()
+{
+	# some VRF tests use ns-C which has the same config as
+	# ns-B but for a device NOT in the VRF
+	create_ns ${NSC} "-" "-"
+	connect_ns ${NSA} ${NSA_DEV2} ${NSA_IP}/24 ${NSA_IP6}/64 \
+		   ${NSC} ${NSC_DEV} ${NSB_IP}/24 ${NSB_IP6}/64
+}
+
 setup()
 {
 	local with_vrf=${1}
@@ -491,12 +507,6 @@ setup()
 
 		ip -netns ${NSB} ro add ${VRF_IP}/32 via ${NSA_IP} dev ${NSB_DEV}
 		ip -netns ${NSB} -6 ro add ${VRF_IP6}/128 via ${NSA_IP6} dev ${NSB_DEV}
-
-		# some VRF tests use ns-C which has the same config as
-		# ns-B but for a device NOT in the VRF
-		create_ns ${NSC} "-" "-"
-		connect_ns ${NSA} ${NSA_DEV2} ${NSA_IP}/24 ${NSA_IP6}/64 \
-			   ${NSC} ${NSC_DEV} ${NSB_IP}/24 ${NSB_IP6}/64
 	else
 		ip -netns ${NSA} ro add ${NSB_LO_IP}/32 via ${NSB_IP} dev ${NSA_DEV}
 		ip -netns ${NSA} ro add ${NSB_LO_IP6}/128 via ${NSB_IP6} dev ${NSA_DEV}
@@ -1247,7 +1257,9 @@ ipv4_tcp_vrf()
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
+	setup_vrf_dup
 	ipv4_tcp_md5
+	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
@@ -2743,7 +2755,9 @@ ipv6_tcp_vrf()
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
+	setup_vrf_dup
 	ipv6_tcp_md5
+	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
-- 
2.25.1

