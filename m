Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842BD3769A5
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 19:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhEGRsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 13:48:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49122 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhEGRst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 13:48:49 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F11C564152;
        Fri,  7 May 2021 19:47:01 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/8] netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check
Date:   Fri,  7 May 2021 19:47:35 +0200
Message-Id: <20210507174739.1850-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507174739.1850-1-pablo@netfilter.org>
References: <20210507174739.1850-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not assume that the tcph->doff field is correct when parsing for TCP
options, skb_header_pointer() might fail to fetch these bits.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_osf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index e8f8875c6884..0fa2e2030427 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -186,6 +186,8 @@ static const struct tcphdr *nf_osf_hdr_ctx_init(struct nf_osf_hdr_ctx *ctx,
 
 		ctx->optp = skb_header_pointer(skb, ip_hdrlen(skb) +
 				sizeof(struct tcphdr), ctx->optsize, opts);
+		if (!ctx->optp)
+			return NULL;
 	}
 
 	return tcp;
-- 
2.30.2

