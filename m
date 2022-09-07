Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8DF5B08D4
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiIGPlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiIGPlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:41:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC64D9E0FF;
        Wed,  7 Sep 2022 08:41:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oVxBS-00068v-LE; Wed, 07 Sep 2022 17:41:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 8/8] netfilter: nat: avoid long-running port range loop
Date:   Wed,  7 Sep 2022 17:41:10 +0200
Message-Id: <20220907154110.8898-9-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220907154110.8898-1-fw@strlen.de>
References: <20220907154110.8898-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looping a large port range takes too long. Instead select a random
offset within [ntohs(exp->saved_proto.tcp.port), 65535] and try 128
ports.

This is a rehash of an erlier patch to do the same, but generalized
to handle other helpers as well.

Link: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210920204439.13179-2-Cole.Dishington@alliedtelesis.co.nz/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_helper.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 067d6d6f6b7d..a95a25196943 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -201,8 +201,18 @@ EXPORT_SYMBOL(nf_nat_follow_master);
 
 u16 nf_nat_exp_find_port(struct nf_conntrack_expect *exp, u16 port)
 {
+	static const unsigned int max_attempts = 128;
+	int range, attempts_left;
+	u16 min = port;
+
+	range = USHRT_MAX - port;
+	attempts_left = range;
+
+	if (attempts_left > max_attempts)
+		attempts_left = max_attempts;
+
 	/* Try to get same port: if not, try to change it. */
-	for (; port != 0; port++) {
+	for (;;) {
 		int res;
 
 		exp->tuple.dst.u.tcp.port = htons(port);
@@ -210,8 +220,10 @@ u16 nf_nat_exp_find_port(struct nf_conntrack_expect *exp, u16 port)
 		if (res == 0)
 			return port;
 
-		if (res != -EBUSY)
+		if (res != -EBUSY || (--attempts_left < 0))
 			break;
+
+		port = min + prandom_u32_max(range);
 	}
 
 	return 0;
-- 
2.35.1

