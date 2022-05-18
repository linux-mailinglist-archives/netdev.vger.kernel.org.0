Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654F752B7FB
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbiERKoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 06:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiERKob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 06:44:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DFF527E1;
        Wed, 18 May 2022 03:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 056CBB81F01;
        Wed, 18 May 2022 10:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFD3C385AA;
        Wed, 18 May 2022 10:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652870667;
        bh=1Guf1hPJj/JEquIG4ZMVdMfdSuPhpCfvybZJUTNG85E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhnFi6A1vPhjPIsCtZ9E1A305/JcrsaAAwMDZ0VHZLNM2blxnUm228laiHuFJXdWk
         Ku8w6aApfprEQzFBa9aWzQwkV0xm8OKR3Ou/uy1dC8N3aY6Wn2Xs34HRgqCjTgjXtY
         ISlpf4NrtksNEQwMghTLIlygvSqTNKNNqY2z+2lKGigCVJ+gYcyTOPeOrRUB7FDlC8
         qSo2DNh6DnDQrbyVDLDGAEcOS5BJJ59MIG8YbTSUEfY32rP2bOeD4fODN1d7k9WZGa
         UuHLP01gTsizqKfPUG6RvJs9x8mQ8k4j4+zG+gnpfc+yIIdyZJSi4JnV77bHfxvdXs
         nJ3cFHhvQS4TQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v3 bpf-next 3/5] net: netfilter: add kfunc helper to update ct timeout
Date:   Wed, 18 May 2022 12:43:36 +0200
Message-Id: <9651ce53e74ce0d0b200fe9d40875e5119ba6c94.1652870182.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652870182.git.lorenzo@kernel.org>
References: <cover.1652870182.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_ct_refresh_timeout kfunc helper in order to update
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
index bc4d5cd63a94..a9271418db88 100644
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
+void bpf_ct_refresh_timeout(struct nf_conn *nfct__ref, u32 timeout)
+{
+	if (!nfct__ref)
+		return;
+
+	nf_ct_refresh_timeout(nfct__ref, msecs_to_jiffies(timeout));
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

