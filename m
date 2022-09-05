Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917A35AD38B
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiIENPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbiIENO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:14:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587A013F86;
        Mon,  5 Sep 2022 06:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 440DACE1294;
        Mon,  5 Sep 2022 13:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE88C433C1;
        Mon,  5 Sep 2022 13:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662383693;
        bh=XtwJ1Z4l4nj4yoY9OB2vz1Xcm+BbDjAoknkQuB94iB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXvNOEdKtHDEbAv6xL5pIYP+jVAMe5ihocpsOZivGg1EsRj1EJu1Ehx+Avg6ET+DF
         x1TNwxx3hAy1LeivXC/qSYADjeAua9XpWHHMEqtRP0WjFPPh1LQe/FVbp2I7kCuiFm
         gTzm9X40QlavIaBMzY1pcD9umJj7QZkZzI2Ihst66uGGrqC7A0mouvN/OwjlGd3QCm
         mQRrG5hkD323tpH1uS0Fo5VErtBD7VDnGtmk0wUSF3LqsU41+qgt1vbbiPgOsSXVZX
         SOrCZYdb93+AugIdw2bym5tmj74YmRux8FgKMvrkNsDMhKrCHKzWxGQPEgTWeegldz
         ckyFKv1dq9fOg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v2 bpf-next 3/4] net: netfilter: add bpf_ct_set_nat_info kfunc helper
Date:   Mon,  5 Sep 2022 15:14:04 +0200
Message-Id: <fa02d93153b99bc994215c1644a2c75a226e3c7d.1662383493.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1662383493.git.lorenzo@kernel.org>
References: <cover.1662383493.git.lorenzo@kernel.org>
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
2.37.3

