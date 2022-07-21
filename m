Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A09257CC3D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiGUNnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiGUNnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:43:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4838321E;
        Thu, 21 Jul 2022 06:42:57 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h8so2356963wrw.1;
        Thu, 21 Jul 2022 06:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nOD2NCqNmcCUVH5+rBORHWkUbIugVPdYLDSth99BYJA=;
        b=He8SVI38KQbmoViBM1MO++k8Ep2tPx5SWBD+z2OicUjFnaFQMP5pvU+XjPxvYiR/4K
         qDtlRSDs01WPSgd7MKQuFscze3Co3ncHwbZ41atvDpytqyfUtmUX7Yd2txBBPg59ndSV
         CNugg1ZFc7H77ZYbCTKEGxVprP3kLZ5rjnFaSH10DRygqxHnpCDPjSEDbUDJ22pHSkUj
         UzY7mMpHJc+GGcHlHzkj2qDb2kVvEHSGSL0XRan5JCj/ggdUTpqoVUExPdPqgnXE5V9W
         /NWKaMBTlBInt7OFTMRAW0nEftVGZFUGHum2Atac7nI46VS4zDY2/nFrHVWzmdA7vWG+
         bh3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nOD2NCqNmcCUVH5+rBORHWkUbIugVPdYLDSth99BYJA=;
        b=31o2hp4QHRpZKJlVQf2DvhMRiikGm6PQCkFOxUq+1HxumAC/EIMsIYU8A+VimLxT/m
         8IKcgPFrdkF9SxcEZ5a8w7dmsG13hZK/BQrdAA3j4QxvbebZkU/GiuHvcC1pak2piJw0
         NXXTcTpBOhYJgbi3VAhtSTsodQkQr4BEnI9B2DLBWYsiqZuu1Co3yJLV0vGi0QS2fE5t
         wLbqcZ2LwMBDMkGGbYGmFQvBM5S+UyFjNoHe79zH39MyuVLnTwu8TUVmJF8JR4rxhfEQ
         Ry4hZ+3HHVO2ou3tHiCaNlFA6T7WAHhim63fmGbBMnsfzAqn1zCF+1UFy1UDDdhcPUeR
         eaYw==
X-Gm-Message-State: AJIora8aEXuBWPo68n7hqSCNR7b0Y4jJZYysQTBZ+wvy4SjTeHB2NeBq
        VV0k0tWMuY26K6YankZEGKUJl7x1Zi0tvQ==
X-Google-Smtp-Source: AGRyM1u+QWjt/8mVkKohHo5iSYjWTyuOs9+PQ0uL2z/0RZVRhTInaztbqGkM7bPpqtxUGXtgEHfwuw==
X-Received: by 2002:a05:6000:186a:b0:21d:ae19:b737 with SMTP id d10-20020a056000186a00b0021dae19b737mr35911727wri.317.1658410975908;
        Thu, 21 Jul 2022 06:42:55 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id 19-20020a05600c24d300b003a32490c95dsm5435958wmu.35.2022.07.21.06.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:42:55 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v7 06/13] net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
Date:   Thu, 21 Jul 2022 15:42:38 +0200
Message-Id: <20220721134245.2450-7-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3777; i=memxor@gmail.com; h=from:subject; bh=w8VO/QxKGUxR9qZh0rqSqCBnrsjyCJXvOL8V1doFII8=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfOZcGWtonkJ+ilX34n0IdoPMplDcB1TZ7nffCz Fx9m1Q+JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzgAKCRBM4MiGSL8RykhvEA CpKP0a0mJih81UObZI6pudbpl/YWSeZHaMlkzlc1wcy1h3pVjuLz8w8XlZWNs92tWx43WqqVnkAeS8 YvBjvOcnyrvkb3K2F+B+4GQkDObQVzNwFB3jbTM2d3QWK2jyQBkO+/vEFoH5CyfnUNAKnAbzt09ylm cwRYoF0Y+vhHkTXk+31oR7lnQb3tUVce2Q3lx75PqTxSAE8rYKgpD//dszBRCQQpFFk8uLxDmjl2a9 Gfq/rAqwwQSXT5NqnBjzjGAEZpopyvwqPeb3R6XainTOC4lFDRCT/zAD+O9+c5D7j801Ec2yjLw7fx z7gn1z1sGCKeek9KiN010TMkpjMoZjNtIJ9rLLdSAvszQrPoKw8IIP4wFy5WVw2oqwc6zQpP+Zk/pm i1Cq+WlfZfuE4U07m2NLTNu5PcmP2XA6OXrKXGLKGkCiwz3QfUEqXftsg2GVgwX+PM+H4ALTeSy31L 1p6u/4H6hAQqhr6S+ueCgnbmTgLFQsTdsZCdLYj1jvYA4mQy1ZVZES4/vaWp5E5WSmdaeswo6rHfMh dNwv+FdmGmGyCZLSZSwyOAtHpwhmOABjtBwDs0sDgG3bBNpfp03DDAL/HP1SfODWt7OqqwZpeVg0jY b3ukAMNdDKBNGzHBGUT2agOkPjZkA2+yvcnRGVqpI+2wvqLDXN+bC85mfO4g==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move common checks inside the common function, and maintain the only
difference the two being how to obtain the struct net * from ctx.
No functional change intended.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 net/netfilter/nf_conntrack_bpf.c | 52 +++++++++++---------------------
 1 file changed, 18 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index cf2096f65d0e..16304869264f 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -57,16 +57,19 @@ enum {
 
 static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 					  struct bpf_sock_tuple *bpf_tuple,
-					  u32 tuple_len, u8 protonum,
-					  s32 netns_id, u8 *dir)
+					  u32 tuple_len, struct bpf_ct_opts *opts,
+					  u32 opts_len)
 {
 	struct nf_conntrack_tuple_hash *hash;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
 
-	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
+	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts_len != NF_BPF_CT_OPTS_SZ)
+		return ERR_PTR(-EINVAL);
+	if (unlikely(opts->l4proto != IPPROTO_TCP && opts->l4proto != IPPROTO_UDP))
 		return ERR_PTR(-EPROTO);
-	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
+	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
 		return ERR_PTR(-EINVAL);
 
 	memset(&tuple, 0, sizeof(tuple));
@@ -89,23 +92,22 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 		return ERR_PTR(-EAFNOSUPPORT);
 	}
 
-	tuple.dst.protonum = protonum;
+	tuple.dst.protonum = opts->l4proto;
 
-	if (netns_id >= 0) {
-		net = get_net_ns_by_id(net, netns_id);
+	if (opts->netns_id >= 0) {
+		net = get_net_ns_by_id(net, opts->netns_id);
 		if (unlikely(!net))
 			return ERR_PTR(-ENONET);
 	}
 
 	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
-	if (netns_id >= 0)
+	if (opts->netns_id >= 0)
 		put_net(net);
 	if (!hash)
 		return ERR_PTR(-ENOENT);
 
 	ct = nf_ct_tuplehash_to_ctrack(hash);
-	if (dir)
-		*dir = NF_CT_DIRECTION(hash);
+	opts->dir = NF_CT_DIRECTION(hash);
 
 	return ct;
 }
@@ -138,20 +140,11 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	struct net *caller_net;
 	struct nf_conn *nfct;
 
-	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
-
-	if (!opts)
-		return NULL;
-	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts__sz != NF_BPF_CT_OPTS_SZ) {
-		opts->error = -EINVAL;
-		return NULL;
-	}
 	caller_net = dev_net(ctx->rxq->dev);
-	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts->l4proto,
-				  opts->netns_id, &opts->dir);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
 	if (IS_ERR(nfct)) {
-		opts->error = PTR_ERR(nfct);
+		if (opts)
+			opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 	return nfct;
@@ -181,20 +174,11 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 	struct net *caller_net;
 	struct nf_conn *nfct;
 
-	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
-
-	if (!opts)
-		return NULL;
-	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts__sz != NF_BPF_CT_OPTS_SZ) {
-		opts->error = -EINVAL;
-		return NULL;
-	}
 	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
-	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts->l4proto,
-				  opts->netns_id, &opts->dir);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts, opts__sz);
 	if (IS_ERR(nfct)) {
-		opts->error = PTR_ERR(nfct);
+		if (opts)
+			opts->error = PTR_ERR(nfct);
 		return NULL;
 	}
 	return nfct;
-- 
2.34.1

