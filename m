Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7265A9D5E
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 18:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbiIAQoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 12:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiIAQoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 12:44:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6468C94EFC;
        Thu,  1 Sep 2022 09:44:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00CE161FC5;
        Thu,  1 Sep 2022 16:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B05EC433C1;
        Thu,  1 Sep 2022 16:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662050646;
        bh=z9F11EFtkiPQKlOjSzVgyi+OfMd3OG9O5NcAOuUr7+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTRiz1ylDQMlY2+cnsRLzOx6YpNyeM1HXp9y4pUHgBdyaCLuaMn+V3pKFYfJxEqGm
         hZX4S0/eNOTQrfZUndWn6ZVycggj2oTTtpuYyLic41gLITm56tKgr6qGghy33pfeRB
         BYnxXGOD43qLKetmPmfgfX0hy82xWF4WHXF8NW3v4/TVCduyIhesF0MWWvK7V3Npr3
         yrr1tW5mNyFo8AiE6FR4LKNO9aP3cHDgTLb1OA1GOkToe5qt8SO1Bq8OpuGe1MlSRO
         kNNNqtChMv0dBMAMK0LZPAr0/8W78r4n3nMv0jErrE2RifYu7ygs8QqGqj1b0Zv9Y9
         vOXMJ7wr8YBhQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH bpf-next 3/4] net: netfilter: add bpf_ct_set_nat_info kfunc helper
Date:   Thu,  1 Sep 2022 18:43:26 +0200
Message-Id: <8b08dbfa88ad08cf28626f7d0bf9388c151089e6.1662050126.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662050126.git.lorenzo@kernel.org>
References: <cover.1662050126.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
destination nat addresses/ports in a new allocated ct entry not inserted
in the connection tracking table yet.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c | 49 +++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 1cd87b28c9b0..85b8c7ee00af 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -14,6 +14,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_nat.h>
 
 /* bpf_ct_opts - Options for CT lookup helpers
  *
@@ -134,7 +135,6 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 
 	memset(&ct->proto, 0, sizeof(ct->proto));
 	__nf_ct_set_timeout(ct, timeout * HZ);
-	ct->status |= IPS_CONFIRMED;
 
 out:
 	if (opts->netns_id >= 0)
@@ -339,6 +339,7 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
+	nfct->status |= IPS_CONFIRMED;
 	err = nf_conntrack_hash_check_insert(nfct);
 	if (err < 0) {
 		nf_conntrack_free(nfct);
@@ -424,6 +425,51 @@ int bpf_ct_change_status(struct nf_conn *nfct, u32 status)
 	return nf_ct_change_status_common(nfct, status);
 }
 
+/* bpf_ct_set_nat_info - Set source or destination nat address
+ *
+ * Set source or destination nat address of the newly allocated
+ * nf_conn before insertion. This must be invoked for referenced
+ * PTR_TO_BTF_ID to nf_conn___init.
+ *
+ * Parameters:
+ * @nfct	- Pointer to referenced nf_conn object, obtained using
+ *		  bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
+ * @addr	- Nat source/destination address
+ * @port	- Nat source/destination port
+ * @manip	- NF_NAT_MANIP_SRC or NF_NAT_MANIP_DST
+ */
+int bpf_ct_set_nat_info(struct nf_conn___init *nfct__ref,
+			union nf_inet_addr *addr, __be16 *port,
+			enum nf_nat_manip_type manip)
+{
+#if ((IS_MODULE(CONFIG_NF_NAT) && IS_MODULE(CONFIG_NF_CONNTRACK)) || \
+     IS_BUILTIN(CONFIG_NF_NAT))
+	struct nf_conn *ct = (struct nf_conn *)nfct__ref;
+	u16 proto = nf_ct_l3num(ct);
+	struct nf_nat_range2 range;
+
+	if (proto != NFPROTO_IPV4 && proto != NFPROTO_IPV6)
+		return -EINVAL;
+
+	if (!addr)
+		return -EINVAL;
+
+	memset(&range, 0, sizeof(struct nf_nat_range2));
+	range.flags = NF_NAT_RANGE_MAP_IPS;
+	range.min_addr = *addr;
+	range.max_addr = *addr;
+	if (port) {
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+		range.min_proto.all = *port;
+		range.max_proto.all = *port;
+	}
+
+	return nf_nat_setup_info(ct, &range, manip) == NF_DROP ? -ENOMEM : 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
 __diag_pop()
 
 BTF_SET8_START(nf_ct_kfunc_set)
@@ -437,6 +483,7 @@ BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_ct_set_status, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_ct_change_status, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_ct_set_nat_info)
 BTF_SET8_END(nf_ct_kfunc_set)
 
 static const struct btf_kfunc_id_set nf_conntrack_kfunc_set = {
-- 
2.37.2

