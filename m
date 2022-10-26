Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDC760E21B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiJZNXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiJZNXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:23:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5ED469EE1;
        Wed, 26 Oct 2022 06:22:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 09/10] netfilter: nft_inner: add geneve support
Date:   Wed, 26 Oct 2022 15:22:26 +0200
Message-Id: <20221026132227.3287-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026132227.3287-1-pablo@netfilter.org>
References: <20221026132227.3287-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geneve tunnel header may contain options, parse geneve header and update
offset to point to the link layer header according to the opt_len field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nft_inner.c                | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 05a15dce8271..e4b739d57480 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -783,6 +783,7 @@ enum nft_payload_csum_flags {
 enum nft_inner_type {
 	NFT_INNER_UNSPEC	= 0,
 	NFT_INNER_VXLAN,
+	NFT_INNER_GENEVE,
 };
 
 enum nft_inner_flags {
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index c43a2fe0ceb7..19fdc8c70cd1 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -17,6 +17,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <net/gre.h>
+#include <net/geneve.h>
 #include <net/ip.h>
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
@@ -181,6 +182,22 @@ static int nft_inner_parse_tunhdr(const struct nft_inner *priv,
 	ctx->flags |= NFT_PAYLOAD_CTX_INNER_TUN;
 	*off += priv->hdrsize;
 
+	switch (priv->type) {
+	case NFT_INNER_GENEVE: {
+		struct genevehdr *gnvh, _gnvh;
+
+		gnvh = skb_header_pointer(pkt->skb, pkt->inneroff,
+					  sizeof(_gnvh), &_gnvh);
+		if (!gnvh)
+			return -1;
+
+		*off += gnvh->opt_len * 4;
+		}
+		break;
+	default:
+		break;
+	}
+
 	return 0;
 }
 
-- 
2.30.2

