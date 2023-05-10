Return-Path: <netdev+bounces-1366-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9BD6FD9C5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2013C1C20CC8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037E920B37;
	Wed, 10 May 2023 08:41:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B854936E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:41:27 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A36262696;
	Wed, 10 May 2023 01:41:21 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 6/7] selftests: nft_flowtable.sh: monitor result file sizes
Date: Wed, 10 May 2023 10:33:12 +0200
Message-Id: <20230510083313.152961-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230510083313.152961-1-pablo@netfilter.org>
References: <20230510083313.152961-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Boris Sukholitko <boris.sukholitko@broadcom.com>

When running nft_flowtable.sh in VM on a busy server we've found that
the time of the netcat file transfers vary wildly.

Therefore replace hardcoded 3 second sleep with the loop checking for
a change in the file sizes. Once no change in detected we test the results.

Nice side effect is that we shave 1 second sleep in the fast case
(hard-coded 3 second sleep vs two 1 second sleeps).

Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 92bc308bf168..51f986f19fee 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -286,7 +286,15 @@ test_tcp_forwarding_ip()
 	ip netns exec $nsa nc -w 4 "$dstip" "$dstport" < "$nsin" > "$ns1out" &
 	cpid=$!
 
-	sleep 3
+	sleep 1
+
+	prev="$(ls -l $ns1out $ns2out)"
+	sleep 1
+
+	while [[ "$prev" != "$(ls -l $ns1out $ns2out)" ]]; do
+		sleep 1;
+		prev="$(ls -l $ns1out $ns2out)"
+	done
 
 	if test -d /proc/"$lpid"/; then
 		kill $lpid
-- 
2.30.2


