Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CCF5C04C3
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 18:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiIUQxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 12:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiIUQwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 12:52:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ED026D5;
        Wed, 21 Sep 2022 09:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21CE56321F;
        Wed, 21 Sep 2022 16:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A97C43148;
        Wed, 21 Sep 2022 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663778947;
        bh=akY1mgEVyy3ZwXfna5ZaVWvRHj3N1Eptf79C5SCKZmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbYc1wrhaqVTwaOaYqE0X2luD1SzII8kC1K9ysGYqjMIq/gVbSltxpnPgi0O1OqPt
         DV8aw84Qiz2MjBMVeui+CUhLCGIE49/Cj/H+ek3a25KN1QxgMXhI72+Ui+gyZa+o2i
         HoQQELNChKPUUs8vr09NAUumtjWjugcM+H69Hl5jAOb0zy7qDgiY/x/nGllE/b4OF8
         SW7wJNkGRRO4JsNlUYeAmCFM4EoKeVaXiLAe50RF+MVb+JkHJWXtxDJC5o6pWQmf58
         HmwiruEBjSOKqdf9cmJwReKbYhgTz+Img1Z7yYugUSwO6nrlvet6PfGsiSCSM7CytA
         QUynm/Jb0wFKA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v3 bpf-next 2/3] net: netfilter: add bpf_ct_set_nat_info kfunc helper
Date:   Wed, 21 Sep 2022 18:48:26 +0200
Message-Id: <9567db2fdfa5bebe7b7cc5870f7a34549418b4fc.1663778601.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663778601.git.lorenzo@kernel.org>
References: <cover.1663778601.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 net/netfilter/nf_conntrack_bpf.c | 47 +++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 67df64283aef..756ea818574e 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -17,6 +17,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_nat.h>
 
 /* bpf_ct_opts - Options for CT lookup helpers
  *
@@ -137,7 +138,6 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
 
 	memset(&ct->proto, 0, sizeof(ct->proto));
 	__nf_ct_set_timeout(ct, timeout * HZ);
-	ct->status |= IPS_CONFIRMED;
 
 out:
 	if (opts->netns_id >= 0)
@@ -390,6 +390,7 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
+	nfct->status |= IPS_CONFIRMED;
 	err = nf_conntrack_hash_check_insert(nfct);
 	if (err < 0) {
 		nf_conntrack_free(nfct);
@@ -475,6 +476,49 @@ int bpf_ct_change_status(struct nf_conn *nfct, u32 status)
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
+ * @port	- Nat source/destination port. Non-positive values are
+ *		  interpreted as select a random port.
+ * @manip	- NF_NAT_MANIP_SRC or NF_NAT_MANIP_DST
+ */
+int bpf_ct_set_nat_info(struct nf_conn___init *nfct,
+			union nf_inet_addr *addr, int port,
+			enum nf_nat_manip_type manip)
+{
+#if ((IS_MODULE(CONFIG_NF_NAT) && IS_MODULE(CONFIG_NF_CONNTRACK)) || \
+     IS_BUILTIN(CONFIG_NF_NAT))
+	struct nf_conn *ct = (struct nf_conn *)nfct;
+	u16 proto = nf_ct_l3num(ct);
+	struct nf_nat_range2 range;
+
+	if (proto != NFPROTO_IPV4 && proto != NFPROTO_IPV6)
+		return -EINVAL;
+
+	memset(&range, 0, sizeof(struct nf_nat_range2));
+	range.flags = NF_NAT_RANGE_MAP_IPS;
+	range.min_addr = *addr;
+	range.max_addr = range.min_addr;
+	if (port > 0) {
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+		range.min_proto.all = cpu_to_be16(port);
+		range.max_proto.all = range.min_proto.all;
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
@@ -488,6 +532,7 @@ BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_ct_set_status, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_ct_change_status, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_ct_set_nat_info, KF_TRUSTED_ARGS)
 BTF_SET8_END(nf_ct_kfunc_set)
 
 static const struct btf_kfunc_id_set nf_conntrack_kfunc_set = {
-- 
2.37.3

