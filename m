Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7E44F03DB
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 16:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356167AbiDBOVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 10:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238049AbiDBOVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 10:21:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062F112D0B4;
        Sat,  2 Apr 2022 07:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0D8261045;
        Sat,  2 Apr 2022 14:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A04AC340EE;
        Sat,  2 Apr 2022 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648909164;
        bh=QWVeTrZeTkA+qj+dn9O7kAQehod9W2oDkLB8GeEtdcA=;
        h=From:To:Cc:Subject:Date:From;
        b=E3Gbbu3aL69IrboKkFIrVgBNjL7V+iPuPUbgwliM1wiXPLi2hRifgj7DcZlzPmCa2
         oUs3JxghjUe6DsNdJOxg0RzzhMhH6T/ve4Vc78MGPzU2+I2RjZFrf4UOsaEVG0x+FH
         04ZIRIApTTVIEeZx7g/K04GWHTmhY8rsHy+Q7NFWLbnvJYGqsCX8KMszwk5wxi31J5
         3aDosPiuTj4/O0xKSq5GWjf+0hMsLChtVbz6LVq0+jbPsqEP77EcxtvxwnWWOYlBmb
         nkOvMN8eY3hmEWrBai4JOsRSADXxbPmUy9uPprcZfA7WyO2plRmAOWcP39puFhLIVE
         8b8Qbtc6x22hA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com, memxor@gmail.com,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next] net: netfilter: reports ct direction in CT lookup helpers for XDP and TC-BPF
Date:   Sat,  2 Apr 2022 16:19:14 +0200
Message-Id: <aa1aaac89191cfc64078ecef36c0a48c302321b9.1648908601.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
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

Report connection tracking tuple direction in
bpf_skb_ct_lookup/bpf_xdp_ct_lookup helpers. Direction will be used to
implement snat/dnat through xdp ebpf program.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index fe98673dd5ac..bc4d5cd63a94 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -38,6 +38,7 @@
  * @l4proto    - Layer 4 protocol
  *		 Values:
  *		   IPPROTO_TCP, IPPROTO_UDP
+ * @dir:       - connection tracking tuple direction.
  * @reserved   - Reserved member, will be reused for more options in future
  *		 Values:
  *		   0
@@ -46,7 +47,8 @@ struct bpf_ct_opts {
 	s32 netns_id;
 	s32 error;
 	u8 l4proto;
-	u8 reserved[3];
+	u8 dir;
+	u8 reserved[2];
 };
 
 enum {
@@ -56,10 +58,11 @@ enum {
 static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 					  struct bpf_sock_tuple *bpf_tuple,
 					  u32 tuple_len, u8 protonum,
-					  s32 netns_id)
+					  s32 netns_id, u8 *dir)
 {
 	struct nf_conntrack_tuple_hash *hash;
 	struct nf_conntrack_tuple tuple;
+	struct nf_conn *ct;
 
 	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
 		return ERR_PTR(-EPROTO);
@@ -99,7 +102,12 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 		put_net(net);
 	if (!hash)
 		return ERR_PTR(-ENOENT);
-	return nf_ct_tuplehash_to_ctrack(hash);
+
+	ct = nf_ct_tuplehash_to_ctrack(hash);
+	if (dir)
+		*dir = NF_CT_DIRECTION(hash);
+
+	return ct;
 }
 
 __diag_push();
@@ -135,13 +143,13 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	if (!opts)
 		return NULL;
 	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts->reserved[2] || opts__sz != NF_BPF_CT_OPTS_SZ) {
+	    opts__sz != NF_BPF_CT_OPTS_SZ) {
 		opts->error = -EINVAL;
 		return NULL;
 	}
 	caller_net = dev_net(ctx->rxq->dev);
 	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts->l4proto,
-				  opts->netns_id);
+				  opts->netns_id, &opts->dir);
 	if (IS_ERR(nfct)) {
 		opts->error = PTR_ERR(nfct);
 		return NULL;
@@ -178,13 +186,13 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 	if (!opts)
 		return NULL;
 	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
-	    opts->reserved[2] || opts__sz != NF_BPF_CT_OPTS_SZ) {
+	    opts__sz != NF_BPF_CT_OPTS_SZ) {
 		opts->error = -EINVAL;
 		return NULL;
 	}
 	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
 	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts->l4proto,
-				  opts->netns_id);
+				  opts->netns_id, &opts->dir);
 	if (IS_ERR(nfct)) {
 		opts->error = PTR_ERR(nfct);
 		return NULL;
-- 
2.35.1

