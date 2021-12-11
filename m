Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595C4471554
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 19:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhLKS02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 13:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhLKS02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 13:26:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CE4C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 10:26:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80C92B80951
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 18:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A818AC004DD;
        Sat, 11 Dec 2021 18:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639247185;
        bh=b5xhOO+whI31FmF+W64Cy8mVJvnlksT6XIs83nEtkLk=;
        h=From:To:Cc:Subject:Date:From;
        b=JOicknH+66c45Bc0ONYHf0DFkeyHHTXBhlzZKjxiwh/i5yBCKIRnzghZkX5gvmHJG
         dAdSkWNLD7fAcVUYI84h54ooHDm23sx9YSY1OJhIglHMThQsxUPH68nqjUfrVurdwN
         PFgs2jlACgqiFsaHwnF0rmVOD/joRKvufzKURalan/midRn5wBP5nPHGyNsxj/pKY1
         elTyEQikvcAsnblQvx6O3gkGpm/oNc7/7O+1tXlldMjCrxPbMxq9qRA+xkOhyyh3fh
         4euawgBsYCSVhyQhdABmkIY+jYsXLQrcd41mVx8kdYtvwMBdkPx7uqXGD2OphJBu55
         gz7Lbl5lHDBTg==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH net] selftests: Fix IPv6 address bind tests
Date:   Sat, 11 Dec 2021 11:26:16 -0700
Message-Id: <20211211182616.74865-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 allows binding a socket to a device then binding to an address
not on the device (__inet6_bind -> ipv6_chk_addr with strict flag
not set). Update the bind tests to reflect legacy behavior.

Fixes: 34d0302ab861 ("selftests: Add ipv6 address bind tests to fcnal-test")
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 25bba4557a8e..daa63e087b9f 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3461,11 +3461,14 @@ ipv6_addr_bind_novrf()
 	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 0 "TCP socket bind to local address after device bind"
 
+	# Sadly, the kernel allows binding a socket to a device and then
+	# binding to an address not on the device. So this test passes
+	# when it really should not
 	a=${NSA_LO_IP6}
 	log_start
-	show_hint "Should fail with 'Cannot assign requested address'"
+	show_hint "Tecnically should fail since address is not on device but kernel allows"
 	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
-	log_test_addr ${a} $? 1 "TCP socket bind to out of scope local address"
+	log_test_addr ${a} $? 0 "TCP socket bind to out of scope local address"
 }
 
 ipv6_addr_bind_vrf()
@@ -3514,10 +3517,15 @@ ipv6_addr_bind_vrf()
 	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 0 "TCP socket bind to local address with device bind"
 
+	# Sadly, the kernel allows binding a socket to a device and then
+	# binding to an address not on the device. The only restriction
+	# is that the address is valid in the L3 domain. So this test
+	# passes when it really should not
 	a=${VRF_IP6}
 	log_start
+	show_hint "Tecnically should fail since address is not on device but kernel allows"
 	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
-	log_test_addr ${a} $? 1 "TCP socket bind to VRF address with device bind"
+	log_test_addr ${a} $? 0 "TCP socket bind to VRF address with device bind"
 
 	a=${NSA_LO_IP6}
 	log_start
-- 
2.25.1

