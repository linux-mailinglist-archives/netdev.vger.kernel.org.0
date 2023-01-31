Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BC4682DF0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjAaNcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjAaNcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:32:04 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EF614AA76;
        Tue, 31 Jan 2023 05:32:04 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/2] Revert "netfilter: conntrack: fix bug in for_each_sctp_chunk"
Date:   Tue, 31 Jan 2023 14:31:58 +0100
Message-Id: <20230131133158.4052-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230131133158.4052-1-pablo@netfilter.org>
References: <20230131133158.4052-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

There is no bug.  If sch->length == 0, this would result in an infinite
loop, but first caller, do_basic_checks(), errors out in this case.

After this change, packets with bogus zero-length chunks are no longer
detected as invalid, so revert & add comment wrt. 0 length check.

Fixes: 98ee00774525 ("netfilter: conntrack: fix bug in for_each_sctp_chunk")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 945dd40e7077..011d414038ea 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -142,10 +142,11 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 }
 #endif
 
+/* do_basic_checks ensures sch->length > 0, do not use before */
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
 for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
-	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch))) &&	\
-	(sch)->length;	\
+	(offset) < (skb)->len &&					\
+	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
 	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
 
 /* Some validity checks to make sure the chunks are fine */
-- 
2.30.2

