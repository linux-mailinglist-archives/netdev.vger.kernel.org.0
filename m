Return-Path: <netdev+bounces-3494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CDF707924
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96C7F1C2104B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C8938D;
	Thu, 18 May 2023 04:38:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6637C
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:38:14 +0000 (UTC)
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F277A19BE;
	Wed, 17 May 2023 21:38:12 -0700 (PDT)
Received: from Phocidae.conference (42-72-4-222.emome-ip.hinet.net [42.72.4.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 68693412F9;
	Thu, 18 May 2023 04:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684384690;
	bh=FoHK/ve8fn0r7S3rvrVc2zhZN2YcXHNlC/XwiRfGFas=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=jR+Pg56zhIYdc8zsouhkvbMJRKD5z9brDo5LqeVa7UdaO23JzXjXLDqdEtG+hfTu8
	 2M4zBLvVU0ar62ESa46Qm09IqhD7c/7Dj/rOmWDQ4bOTtcAhXRT678gHlRgl8+j/f3
	 T7M/cp6b/OWja4dl7v9VZyi50owwy/bXKigLtCl6KQzwebSSAhOumvehqB5Dry4uq/
	 rfwc4GYbiYlmHcPkZEMrhmDp3e0L5fGtUnboB1CwHAZuMJUL3EC521wUnOD9J+QuvO
	 IezMUpn1H1hh61gzLuRnIxXMTX4zq34Ae6IMVnCJYYbk3PtxFW/R77VP2vLJGuNb6s
	 SY7JF5ZOdSYlA==
From: Po-Hsu Lin <po-hsu.lin@canonical.com>
To: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org
Cc: po-hsu.lin@canonical.com,
	roxana.nicolescu@canonical.com,
	shuah@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net
Subject: [PATCHv3 net] selftests: fib_tests: mute cleanup error message
Date: Thu, 18 May 2023 12:37:59 +0800
Message-Id: <20230518043759.28477-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the end of the test, there will be an error message induced by the
`ip netns del ns1` command in cleanup()

  Tests passed: 201
  Tests failed:   0
  Cannot remove namespace file "/run/netns/ns1": No such file or directory

This can even be reproduced with just `./fib_tests.sh -h` as we're
calling cleanup() on exit.

Redirect the error message to /dev/null to mute it.

V2: Update commit message and fixes tag.
V3: resubmit due to missing netdev ML in V2

Fixes: b60417a9f2b8 ("selftest: fib_tests: Always cleanup before exit")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/fib_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 7da8ec8..35d89df 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -68,7 +68,7 @@ setup()
 cleanup()
 {
 	$IP link del dev dummy0 &> /dev/null
-	ip netns del ns1
+	ip netns del ns1 &> /dev/null
 	ip netns del ns2 &> /dev/null
 }
 
-- 
2.7.4


