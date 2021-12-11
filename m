Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904AC4714E5
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 18:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhLKRV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 12:21:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59342 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhLKRV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 12:21:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33742B80B27
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 17:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD49C004DD;
        Sat, 11 Dec 2021 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639243285;
        bh=eBvZ1raDO6HZ/OLuoy9VWN5HvX6hA5r/6uq2awTWMcI=;
        h=From:To:Cc:Subject:Date:From;
        b=duQfCOJlcvqTFSFTPPfHRGXHwxXbGNp3sm6iavzylp4QRVPF18EvdHd8c1F6Tuvix
         cRFuWzYO8KM50oFZ3MypLAzejF6yLO5SABicJq9qIaPJrfJWdWxwk/29wmx+tsrP7c
         2UD+aw4hV4fvJrMGwki3+48TIfqBCWG99hb29AaWeBrqgCgOgJ4qOmhBYBCFKGvkXl
         BlOqdaY2zR2RPqVfNQnsqqUaJA+UqEYvkR7rtEeUCIl6FggO6N6dUJn4DYRuxseCnT
         ANqnkJmePPWgHLu3rzFoFB+G/+K/wpie2hJ1BcSVqp9Brf+gDVZVjAt5Za5N7QbXFX
         CzqdZgGvaoRxA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH net] selftests: Fix raw socket bind tests with VRF
Date:   Sat, 11 Dec 2021 10:21:08 -0700
Message-Id: <20211211172108.74647-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit referenced below added negative socket bind tests for VRF. The
socket binds should fail since the address to bind to is in a VRF yet
the socket is not bound to the VRF or a device within it. Update the
expected return code to check for 1 (bind failure) so the test passes
when the bind fails as expected. Add a 'show_hint' comment to explain
why the bind is expected to fail.

Fixes: 75b2b2b3db4c ("selftests: Add ipv4 address bind tests to fcnal-test")
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index d0c45023b4d4..25bba4557a8e 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1825,8 +1825,9 @@ ipv4_addr_bind_vrf()
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
+		show_hint "Socket not bound to VRF, but address is in VRF"
 		run_cmd nettest -s -R -P icmp -l ${a} -b
-		log_test_addr ${a} $? 0 "Raw socket bind to local address"
+		log_test_addr ${a} $? 1 "Raw socket bind to local address"
 
 		log_start
 		run_cmd nettest -s -R -P icmp -l ${a} -I ${NSA_DEV} -b
-- 
2.25.1

