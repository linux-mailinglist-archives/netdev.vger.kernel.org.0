Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2850630966
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiKSCNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiKSCMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:12:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195F842F5C;
        Fri, 18 Nov 2022 18:12:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A909F62838;
        Sat, 19 Nov 2022 02:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED90EC43141;
        Sat, 19 Nov 2022 02:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823920;
        bh=OOD+tYPIH/bBvPYBFQJgUNo52ozICWFuGCxahjNu2OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1fzrxhjFsVlZfruvEJU3VyVyhwv5JnTPyaQqIJMZOUF/zryRZJqWKW2xTvBXFzOH
         H82HwiLHlId+E+fJnFGgcCQFOnJqy7S7Cxyow7+ftnyeX6Jcio9KampmjIVtAKU4Ap
         SR997jl4cfrQovFRi9aVExnOBFn1z/LT0rAXTd7MVbra5BYeeC91gMZ+3OFQpVZgQm
         hb9HrM/lPp5sfvNWywfLdsOKig0QpX3DOI3TDnJoHnJb400xs3TSROviKRkbwgGUwb
         /nqlx2rf/+rc6lO4UxmY26WUoUgSPqxA+2TxbDnLYWtIf2du97MS+hfCX4M/GcD7Xx
         MYjeOuxQczq0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrien Thierry <athierry@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 16/44] selftests/net: give more time to udpgro bg processes to complete startup
Date:   Fri, 18 Nov 2022 21:10:56 -0500
Message-Id: <20221119021124.1773699-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adrien Thierry <athierry@redhat.com>

[ Upstream commit cdb525ca92b196f8916102b62431aa0d9a644ff2 ]

In some conditions, background processes in udpgro don't have enough
time to set up the sockets. When foreground processes start, this
results in the test failing with "./udpgso_bench_tx: sendmsg: Connection
refused". For instance, this happens from time to time on a Qualcomm
SA8540P SoC running CentOS Stream 9.

To fix this, increase the time given to background processes to
complete the startup before foreground processes start.

Signed-off-by: Adrien Thierry <athierry@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro.sh         | 4 ++--
 tools/testing/selftests/net/udpgro_bench.sh   | 2 +-
 tools/testing/selftests/net/udpgro_frglist.sh | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index ebbd0b282432..6a443ca3cd3a 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -50,7 +50,7 @@ run_one() {
 		echo "failed" &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 	ret=$?
 	wait $(jobs -p)
@@ -117,7 +117,7 @@ run_one_2sock() {
 		echo "failed" &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args} -p 12345
 	sleep 0.1
 	# first UDP GSO socket should be closed at this point
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index fad2d1a71cac..8a1109a545db 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -39,7 +39,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 }
 
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index 832c738cc3c2..7fe85ba51075 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -44,7 +44,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 }
 
-- 
2.35.1

