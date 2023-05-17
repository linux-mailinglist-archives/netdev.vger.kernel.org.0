Return-Path: <netdev+bounces-3184-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9421B705E93
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 452C21C20C2F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8877D2116;
	Wed, 17 May 2023 04:11:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2DC2100
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:11:43 +0000 (UTC)
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC03DE77;
	Tue, 16 May 2023 21:11:41 -0700 (PDT)
Received: from Phocidae.conference (1.general.phlin.uk.vpn [10.172.194.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7532F4026B;
	Wed, 17 May 2023 04:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684296699;
	bh=uKNing954xz7FQw7FvKS/pI3qCFzr7vWKfumoDuRopI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=kjcenEifqc63vTT9gXN5ixSp9+ueUVddiUV3UxkPaE42AOUVBC+7jC63I31iVkZC4
	 R5rrxq/Jc2Hle46v30dOuornMdcL1NCCU2fcQT1uSWD+b7WcLq+v3eYyiUhjgPAl8P
	 dDd562+EoGsznrb8d/LjgpkDmaADdw1j32FLqm5scYqerVfwysTBVu+QqszU3e2t8i
	 VKqwpgVBerCnaw5a3xd8YQBudXS0Y6uJtDmu92FikmuH8VTtG6kKDAI1F/RslBhRBM
	 pq6PF5+utJPlNUePKtKhrhkcrIydDCEhAhTrTMZqghk6Kkqvm5hQULcnhO1mMF44mL
	 64HqJqQ918rZA==
From: Po-Hsu Lin <po-hsu.lin@canonical.com>
To: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org
Cc: po-hsu.lin@canonical.com,
	dsahern@gmail.com,
	shuah@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net
Subject: [PATCH] selftests: fib_tests: mute cleanup error message
Date: Wed, 17 May 2023 12:11:19 +0800
Message-Id: <20230517041119.202072-1-po-hsu.lin@canonical.com>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the end of the test, there will be an error message induced by the
`ip netns del ns1` command in cleanup()

  Tests passed: 201
  Tests failed:   0
  Cannot remove namespace file "/run/netns/ns1": No such file or directory

Redirect the error message to /dev/null to mute it.

Fixes: a0e11da78f48 ("fib_tests: Add tests for metrics on routes")
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


