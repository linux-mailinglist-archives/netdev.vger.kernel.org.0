Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A22F32E3DA
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 09:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCEIme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 03:42:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCEImN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 03:42:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE2AE64F11;
        Fri,  5 Mar 2021 08:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614933733;
        bh=mgxBLmLXHhIZquaeQklM8mANN4oNT1voBTTYJbZRqF4=;
        h=Date:From:To:Cc:Subject:From;
        b=Nsuz6zi9ZRmhDY6rbc7gE+6wo2JedEJwMFUpoBAmNFDgAxra49iHRWTky1ss2Z9mI
         5CP3Rq/dbQbU6wXSLflPlwIhR+zq9s10j3tgnxbMbZ0IXhKlM9OqhaDvIytsM31Gtr
         Me+NCGj8JvwREpWAWL75JAxBdEbYY18JEGKMl0JxmOUSVb2+Ow5+phytN0/E0RhP08
         J8BLaCKwMTYVqnfUypGx43tV6GKZZyk8nHrvaoI1RNXFPcsmifmG1+HtTw+qSpkxrM
         6eo8YVZW1kGX0WOpUSkioxumzAaE5SS4WndADMViejYN8v11NZuXSnqI6zmvFyF6R7
         LYyIbc/4xJAGQ==
Date:   Fri, 5 Mar 2021 02:42:09 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] netfilter: Fix fall-through warnings for Clang
Message-ID: <20210305084209.GA138063@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
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
index b07703e19108..1f53459e30e9 100644
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
2.27.0

