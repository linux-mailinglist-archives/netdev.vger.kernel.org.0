Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A677345371
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhCVX5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:57:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58324 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhCVX4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:56:41 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1C2A26312A;
        Tue, 23 Mar 2021 00:56:32 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/10] netfilter: Fix fall-through warnings for Clang
Date:   Tue, 23 Mar 2021 00:56:20 +0100
Message-Id: <20210322235628.2204-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322235628.2204-1-pablo@netfilter.org>
References: <20210322235628.2204-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 1 +
 net/netfilter/nf_tables_api.c           | 1 +
 net/netfilter/nft_ct.c                  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index db7479db8512..4f33307fa3cf 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -397,6 +397,7 @@ dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			msg = "not picking up existing connection ";
 			goto out_invalid;
 		}
+		break;
 	case CT_DCCP_REQUEST:
 		break;
 	case CT_DCCP_INVALID:
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 224c8e537cb3..083c112bee0b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8557,6 +8557,7 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 							data->verdict.chain);
 				if (err < 0)
 					return err;
+				break;
 			default:
 				break;
 			}
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 882fe8648653..0592a9456084 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -527,6 +527,7 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 	case NFT_CT_ZONE:
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
+		break;
 #endif
 	default:
 		break;
-- 
2.20.1

