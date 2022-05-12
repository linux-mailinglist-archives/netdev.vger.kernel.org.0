Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDFF5252AF
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356523AbiELQew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356520AbiELQet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:34:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1463220AE6F;
        Thu, 12 May 2022 09:34:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6D1161FF5;
        Thu, 12 May 2022 16:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C045C385B8;
        Thu, 12 May 2022 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652373288;
        bh=Dk3UjQ+Ua/LqhSJZTLHE/fCFSPqqkDMye0Hl82XZuZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jxjc7LrLQMmQDhzpSSvad1mr2Ksl5OPjxpdHShwOORhgG1RKx/bloTsvM7FeAckRj
         5tNpLUdV8mH65ywHE6ecPA1RiBTR1VU0YFvK1Woazxu1TtdUqtkeP/u4fIZEca4M9x
         CeKcjR/I076kg4d2s2eOAAr05aU/Is4p4AGUbBvF8Ya3SdWFBt2dvBdAA+jLVYfb2v
         iFBTeHPnJvwMNq3U9fGEXS1jyfwcpyOoXds23p+4R6WjZThken1IiHrj/CHDxZcX3O
         /27SRbcVXjL7Z6AH3K1xc9vWhr7cq/wSAkHmLvpYhW0NqXVGNv507TLpZ+NUeBozoU
         XMknh3R1lMlOA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com, memxor@gmail.com
Subject: [PATCH v2 bpf-next 1/2] net: netfilter: add kfunc helper to update ct timeout
Date:   Thu, 12 May 2022 18:34:10 +0200
Message-Id: <98cb7b20eb889fc096354a0d791cf2b47fb42f1c.1652372970.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652372970.git.lorenzo@kernel.org>
References: <cover.1652372970.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_ct_refresh_timeout kfunc helper in order to update time
nf_conn lifetime. Move timeout update logic in nf_ct_refresh_timeout
utility routine.

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/netfilter/nf_conntrack.h |  1 +
 net/netfilter/nf_conntrack_bpf.c     | 20 ++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c    | 21 +++++++++++++--------
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 69e6c6a218be..02b7115b92d0 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -205,6 +205,7 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		       u_int16_t l3num, struct net *net,
 		       struct nf_conntrack_tuple *tuple);
 
+void nf_ct_refresh_timeout(struct nf_conn *ct, u32 extra_jiffies);
 void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			  const struct sk_buff *skb,
 			  u32 extra_jiffies, bool do_acct);
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index bc4d5cd63a94..d6dcadf0e016 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -217,16 +217,36 @@ void bpf_ct_release(struct nf_conn *nfct)
 	nf_ct_put(nfct);
 }
 
+/* bpf_ct_refresh_timeout - Refresh nf_conn object
+ *
+ * Refresh timeout associated to the provided connection tracking entry.
+ * This must be invoked for referenced PTR_TO_BTF_ID.
+ *
+ * Parameters:
+ * @nf_conn      - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
+ * @timeout      - delta time in msecs used to increase the ct entry lifetime.
+ */
+void bpf_ct_refresh_timeout(struct nf_conn *nfct, u32 timeout)
+{
+	if (!nfct)
+		return;
+
+	nf_ct_refresh_timeout(nfct, msecs_to_jiffies(timeout));
+}
+
 __diag_pop()
 
 BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
 BTF_ID(func, bpf_xdp_ct_lookup)
 BTF_ID(func, bpf_ct_release)
+BTF_ID(func, bpf_ct_refresh_timeout);
 BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_tc_check_kfunc_ids)
 BTF_ID(func, bpf_skb_ct_lookup)
 BTF_ID(func, bpf_ct_release)
+BTF_ID(func, bpf_ct_refresh_timeout);
 BTF_SET_END(nf_ct_tc_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_acquire_kfunc_ids)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0164e5f522e8..f43e743728bd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2030,16 +2030,11 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
 
-/* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
-void __nf_ct_refresh_acct(struct nf_conn *ct,
-			  enum ip_conntrack_info ctinfo,
-			  const struct sk_buff *skb,
-			  u32 extra_jiffies,
-			  bool do_acct)
+void nf_ct_refresh_timeout(struct nf_conn *ct, u32 extra_jiffies)
 {
 	/* Only update if this is not a fixed timeout */
 	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
-		goto acct;
+		return;
 
 	/* If not in hash table, timer will not be active yet */
 	if (nf_ct_is_confirmed(ct))
@@ -2047,7 +2042,17 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 
 	if (READ_ONCE(ct->timeout) != extra_jiffies)
 		WRITE_ONCE(ct->timeout, extra_jiffies);
-acct:
+}
+
+/* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
+void __nf_ct_refresh_acct(struct nf_conn *ct,
+			  enum ip_conntrack_info ctinfo,
+			  const struct sk_buff *skb,
+			  u32 extra_jiffies,
+			  bool do_acct)
+{
+	nf_ct_refresh_timeout(ct, extra_jiffies);
+
 	if (do_acct)
 		nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), skb->len);
 }
-- 
2.35.3

