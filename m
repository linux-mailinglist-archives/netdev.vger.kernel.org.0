Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E285355AB
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349236AbiEZVg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349203AbiEZVgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:36:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1D25EBDA;
        Thu, 26 May 2022 14:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D96861BC2;
        Thu, 26 May 2022 21:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58650C34113;
        Thu, 26 May 2022 21:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600969;
        bh=0nxV5JIhLJ+pnLRElLxIATOfedgUhd5e1x5KgmKysGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvUNCmiupPfL2Khz0DGtYW7QzxRB+/M14HGoo9kryaWdjafScCxFIK/YgchZCcau0
         G6ddN7lC8X8MO0S0vxUkhjlQoy+EDdp7hvAwiQRCVI4HLCjUI5QzrLF4DDvCLyGpti
         FYJiKhYJl8QfJzWpqvWwMGBGvYelEy5C+VCPT1hKeZvFpIuuKCo/tzFiPsxqW7FXby
         E0lzvhVcmWQhCVctzqvufsm/U7uzhZdEqL8UI3eloXoOz9EdSyPRAEw4aTyadpJpek
         rrlHQdFTx4QKSLlr4V7xLZ0IhEwI7B1BcXni3vv7WMi5hh4/el/QgmqwWzITzb+4jm
         G2f/oCzkc/vag==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 11/14] net: netfilter: add kfunc helper to update ct timeout
Date:   Thu, 26 May 2022 23:34:59 +0200
Message-Id: <c32e587692b64d298245b52bc709209bf79b930e.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/netfilter/nf_conntrack.h |  1 +
 net/netfilter/nf_conntrack_bpf.c     | 23 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c    | 21 +++++++++++++--------
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a32be8aa7ed2..6ce4d2ecbc7b 100644
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
index 5169405dd9d1..c50f4c1e5b3a 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -219,16 +219,39 @@ void bpf_ct_release(const struct nf_conn *nfct)
 	nf_ct_put((struct nf_conn *)nfct);
 }
 
+/* bpf_ct_refresh_timeout - Refresh nf_conn object
+ *
+ * Refresh timeout associated to the provided connection tracking entry.
+ * This must be invoked for referenced PTR_TO_BTF_ID.
+ *
+ * Parameters:
+ * @nfct__ref    - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
+ * @timeout      - delta time in msecs used to increase the ct entry lifetime.
+ */
+void bpf_ct_refresh_timeout(const struct nf_conn *nfct__ref, u32 timeout)
+{
+	struct nf_conn *nfct;
+
+	if (!nfct__ref)
+		return;
+
+	nfct = (struct nf_conn *)nfct__ref;
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
index 91f890972f9e..0aafefe9014c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2055,16 +2055,11 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
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
@@ -2072,7 +2067,17 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 
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

