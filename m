Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4288569AB93
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjBQMa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjBQMaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:30:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71E8C67835;
        Fri, 17 Feb 2023 04:30:05 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 4/6] netfilter: conntrack: remote a return value of the 'seq_print_acct' function.
Date:   Fri, 17 Feb 2023 13:29:55 +0100
Message-Id: <20230217122957.799277-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230217122957.799277-1-pablo@netfilter.org>
References: <20230217122957.799277-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

The static 'seq_print_acct' function always returns 0.

Change the return value to 'void' and remove unnecessary checks.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 1ca9e41770cb ("netfilter: Remove uses of seq_<foo> return values")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 460294bd4b60..57f6724c99a7 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -275,7 +275,7 @@ static const char* l4proto_name(u16 proto)
 	return "unknown";
 }
 
-static unsigned int
+static void
 seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
 {
 	struct nf_conn_acct *acct;
@@ -283,14 +283,12 @@ seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
 
 	acct = nf_conn_acct_find(ct);
 	if (!acct)
-		return 0;
+		return;
 
 	counter = acct->counter;
 	seq_printf(s, "packets=%llu bytes=%llu ",
 		   (unsigned long long)atomic64_read(&counter[dir].packets),
 		   (unsigned long long)atomic64_read(&counter[dir].bytes));
-
-	return 0;
 }
 
 /* return 0 on success, 1 in case of error */
@@ -342,8 +340,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_has_overflowed(s))
 		goto release;
 
-	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
-		goto release;
+	seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL);
 
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
 		seq_puts(s, "[UNREPLIED] ");
@@ -352,8 +349,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 
 	ct_show_zone(s, ct, NF_CT_ZONE_DIR_REPL);
 
-	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
-		goto release;
+	seq_print_acct(s, ct, IP_CT_DIR_REPLY);
 
 	if (test_bit(IPS_HW_OFFLOAD_BIT, &ct->status))
 		seq_puts(s, "[HW_OFFLOAD] ");
-- 
2.30.2

