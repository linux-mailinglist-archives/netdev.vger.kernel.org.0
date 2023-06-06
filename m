Return-Path: <netdev+bounces-8642-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C80A725072
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 00:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F3B71C20BD5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 22:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6940334D66;
	Tue,  6 Jun 2023 22:59:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEB37E4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 22:59:00 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 362BE1739;
	Tue,  6 Jun 2023 15:58:59 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 3/5] netfilter: conntrack: fix NULL pointer dereference in nf_confirm_cthelper
Date: Wed,  7 Jun 2023 00:58:49 +0200
Message-Id: <20230606225851.67394-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606225851.67394-1-pablo@netfilter.org>
References: <20230606225851.67394-1-pablo@netfilter.org>
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

From: Tijs Van Buggenhout <tijs.van.buggenhout@axsguard.com>

An nf_conntrack_helper from nf_conn_help may become NULL after DNAT.

Observed when TCP port 1720 (Q931_PORT), associated with h323 conntrack
helper, is DNAT'ed to another destination port (e.g. 1730), while
nfqueue is being used for final acceptance (e.g. snort).

This happenned after transition from kernel 4.14 to 5.10.161.

Workarounds:
 * keep the same port (1720) in DNAT
 * disable nfqueue
 * disable/unload h323 NAT helper

$ linux-5.10/scripts/decode_stacktrace.sh vmlinux < /tmp/kernel.log
BUG: kernel NULL pointer dereference, address: 0000000000000084
[..]
RIP: 0010:nf_conntrack_update (net/netfilter/nf_conntrack_core.c:2080 net/netfilter/nf_conntrack_core.c:2134) nf_conntrack
[..]
nfqnl_reinject (net/netfilter/nfnetlink_queue.c:237) nfnetlink_queue
nfqnl_recv_verdict (net/netfilter/nfnetlink_queue.c:1230) nfnetlink_queue
nfnetlink_rcv_msg (net/netfilter/nfnetlink.c:241) nfnetlink
[..]

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Tijs Van Buggenhout <tijs.van.buggenhout@axsguard.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c4ccfec6cb98..d119f1d4c2fc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2260,6 +2260,9 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 		return 0;
 
 	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return 0;
+
 	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
 		return 0;
 
-- 
2.30.2


