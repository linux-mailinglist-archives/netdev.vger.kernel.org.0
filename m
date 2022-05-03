Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A387D5189EF
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 18:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbiECQdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 12:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbiECQc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 12:32:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0314435A9B;
        Tue,  3 May 2022 09:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99CE16170F;
        Tue,  3 May 2022 16:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D88C385A9;
        Tue,  3 May 2022 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651595366;
        bh=viFM4mh/Ezbm3iuW18ly6fZxpFHVtOopDssABTfamuA=;
        h=From:To:Cc:Subject:Date:From;
        b=n0sAsNsIFEZYCBOWbUzrrpqt8BQppIWjx+s49bgSRD/y4O91L4yjM7p8qnKI4NwGx
         P0jwz7IuL2Dns1vtILbs4WESk/vDoD2hCGcM3pNbmDKpwuYiuly+FWjeUFcxtuHE08
         xfBTHs6qJOgHqoNZixk3l9HP6tgplBflZM6f3uqr2jQNGwUmY9UtDtL3YwdnOh9Q2c
         aDrQMq2A9DCdz3ONPKqXcWnQWuyDrSjnEpjP2RaowDEE21VUoi9xLtM1gNoj/WT7we
         0p+NK/qOwX5FSOvHqxVYHrSn6HsT76A69RmBbAwBaMtFTwgJwlzdKa6jSvSSW0HhuD
         A6Asp8tqrmR9g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com, memxor@gmail.com
Subject: [PATCH bpf-next] net: netfilter: add kfunc helper to update ct timeout
Date:   Tue,  3 May 2022 18:29:14 +0200
Message-Id: <1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
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
2.35.1

