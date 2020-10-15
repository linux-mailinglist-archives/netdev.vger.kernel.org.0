Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A177A28F6CA
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389969AbgJOQbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:31:06 -0400
Received: from correo.us.es ([193.147.175.20]:47278 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389906AbgJOQax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:30:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E1B22E2C5A
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:30:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D44EADA796
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:30:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C9CE1DA78F; Thu, 15 Oct 2020 18:30:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE82CDA72F;
        Thu, 15 Oct 2020 18:30:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 18:30:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7EEB342EF4E2;
        Thu, 15 Oct 2020 18:30:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 8/9] netfilter: flowtable: bridge port support
Date:   Thu, 15 Oct 2020 18:30:37 +0200
Message-Id: <20201015163038.26992-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201015163038.26992-1-pablo@netfilter.org>
References: <20201015163038.26992-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update hardware destination address to the master bridge device to
emulate the forwarding behaviour.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/netfilter/nf_flow_table.h | 1 +
 net/netfilter/nf_flow_table_core.c    | 4 ++++
 net/netfilter/nft_flow_offload.c      | 6 +++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 1b57d1d1270d..4ec3f9bb2f32 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -172,6 +172,7 @@ struct nf_flow_route {
 			u32		ifindex;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
+			enum flow_offload_xmit_type xmit_type;
 		} out;
 		struct dst_entry	*dst;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 725366339b85..e80dcabe3668 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -100,6 +100,10 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	if (dst_xfrm(dst))
 		flow_tuple->xmit_type = FLOW_OFFLOAD_XMIT_XFRM;
+	else
+		flow_tuple->xmit_type = route->tuple[dir].out.xmit_type;
+
+	flow_tuple->dst_cache = dst;
 
 	flow_tuple->dst_cache = dst;
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d440e436cb16..9efb5d584290 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -54,6 +54,7 @@ struct nft_forward_info {
 	u32 iifindex;
 	u8 h_source[ETH_ALEN];
 	u8 h_dest[ETH_ALEN];
+	enum flow_offload_xmit_type xmit_type;
 };
 
 static int nft_dev_forward_path(struct nf_flow_route *route,
@@ -83,7 +84,9 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
 		case DEV_PATH_VLAN:
 			return -1;
 		case DEV_PATH_BRIDGE:
-			return -1;
+			memcpy(info.h_dest, path->dev->dev_addr, ETH_ALEN);
+			info.xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+			break;
 		}
 	}
 
@@ -91,6 +94,7 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
 	memcpy(route->tuple[dir].out.h_dest, info.h_source, ETH_ALEN);
 	memcpy(route->tuple[dir].out.h_source, info.h_dest, ETH_ALEN);
 	route->tuple[dir].out.ifindex = info.iifindex;
+	route->tuple[dir].out.xmit_type = info.xmit_type;
 
 	return 0;
 }
-- 
2.20.1

