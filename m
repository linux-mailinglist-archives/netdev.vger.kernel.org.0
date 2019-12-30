Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5860812CF7F
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 12:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfL3LWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 06:22:02 -0500
Received: from correo.us.es ([193.147.175.20]:59300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbfL3LWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D56144DE73E
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:21:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8C2EDA713
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:21:57 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BDCECDA712; Mon, 30 Dec 2019 12:21:57 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B29E6DA70F;
        Mon, 30 Dec 2019 12:21:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 36B0F41E4800;
        Mon, 30 Dec 2019 12:21:55 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/17] netfilter: nft_tunnel: add the missing nla_nest_cancel()
Date:   Mon, 30 Dec 2019 12:21:33 +0100
Message-Id: <20191230112143.121708-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

When nla_put_xxx() fails under nla_nest_start_noflag(),
nla_nest_cancel() should be called, so that the skb can
be trimmed properly.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index eb1740236526..23cd163689d5 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -443,10 +443,15 @@ static int nft_tunnel_ip_dump(struct sk_buff *skb, struct ip_tunnel_info *info)
 		if (!nest)
 			return -1;
 
-		if (nla_put_in6_addr(skb, NFTA_TUNNEL_KEY_IP6_SRC, &info->key.u.ipv6.src) < 0 ||
-		    nla_put_in6_addr(skb, NFTA_TUNNEL_KEY_IP6_DST, &info->key.u.ipv6.dst) < 0 ||
-		    nla_put_be32(skb, NFTA_TUNNEL_KEY_IP6_FLOWLABEL, info->key.label))
+		if (nla_put_in6_addr(skb, NFTA_TUNNEL_KEY_IP6_SRC,
+				     &info->key.u.ipv6.src) < 0 ||
+		    nla_put_in6_addr(skb, NFTA_TUNNEL_KEY_IP6_DST,
+				     &info->key.u.ipv6.dst) < 0 ||
+		    nla_put_be32(skb, NFTA_TUNNEL_KEY_IP6_FLOWLABEL,
+				 info->key.label)) {
+			nla_nest_cancel(skb, nest);
 			return -1;
+		}
 
 		nla_nest_end(skb, nest);
 	} else {
@@ -454,9 +459,13 @@ static int nft_tunnel_ip_dump(struct sk_buff *skb, struct ip_tunnel_info *info)
 		if (!nest)
 			return -1;
 
-		if (nla_put_in_addr(skb, NFTA_TUNNEL_KEY_IP_SRC, info->key.u.ipv4.src) < 0 ||
-		    nla_put_in_addr(skb, NFTA_TUNNEL_KEY_IP_DST, info->key.u.ipv4.dst) < 0)
+		if (nla_put_in_addr(skb, NFTA_TUNNEL_KEY_IP_SRC,
+				    info->key.u.ipv4.src) < 0 ||
+		    nla_put_in_addr(skb, NFTA_TUNNEL_KEY_IP_DST,
+				    info->key.u.ipv4.dst) < 0) {
+			nla_nest_cancel(skb, nest);
 			return -1;
+		}
 
 		nla_nest_end(skb, nest);
 	}
@@ -477,37 +486,42 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 	if (opts->flags & TUNNEL_VXLAN_OPT) {
 		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_VXLAN);
 		if (!inner)
-			return -1;
+			goto failure;
 		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_VXLAN_GBP,
 				 htonl(opts->u.vxlan.gbp)))
-			return -1;
+			goto inner_failure;
 		nla_nest_end(skb, inner);
 	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
 		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
 		if (!inner)
-			return -1;
+			goto failure;
 		if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
 				 htonl(opts->u.erspan.version)))
-			return -1;
+			goto inner_failure;
 		switch (opts->u.erspan.version) {
 		case ERSPAN_VERSION:
 			if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
 					 opts->u.erspan.u.index))
-				return -1;
+				goto inner_failure;
 			break;
 		case ERSPAN_VERSION2:
 			if (nla_put_u8(skb, NFTA_TUNNEL_KEY_ERSPAN_V2_HWID,
 				       get_hwid(&opts->u.erspan.u.md2)) ||
 			    nla_put_u8(skb, NFTA_TUNNEL_KEY_ERSPAN_V2_DIR,
 				       opts->u.erspan.u.md2.dir))
-				return -1;
+				goto inner_failure;
 			break;
 		}
 		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
-
 	return 0;
+
+inner_failure:
+	nla_nest_cancel(skb, inner);
+failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
 }
 
 static int nft_tunnel_ports_dump(struct sk_buff *skb,
-- 
2.11.0

