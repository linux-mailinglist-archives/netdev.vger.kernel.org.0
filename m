Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CBC65B53A
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 17:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbjABQkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 11:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbjABQki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 11:40:38 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B381A2BE8;
        Mon,  2 Jan 2023 08:40:34 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/7] netfilter: conntrack: fix ipv6 exthdr error check
Date:   Mon,  2 Jan 2023 17:40:19 +0100
Message-Id: <20230102164025.125995-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230102164025.125995-1-pablo@netfilter.org>
References: <20230102164025.125995-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

smatch warnings:
net/netfilter/nf_conntrack_proto.c:167 nf_confirm() warn: unsigned 'protoff' is never less than zero.

We need to check if ipv6_skip_exthdr() returned an error, but protoff is
unsigned.  Use a signed integer for this.

Fixes: a70e483460d5 ("netfilter: conntrack: merge ipv4+ipv6 confirm functions")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 99323fb12d0f..ccef340be575 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -141,6 +141,7 @@ unsigned int nf_confirm(void *priv,
 	struct nf_conn *ct;
 	bool seqadj_needed;
 	__be16 frag_off;
+	int start;
 	u8 pnum;
 
 	ct = nf_ct_get(skb, &ctinfo);
@@ -163,9 +164,11 @@ unsigned int nf_confirm(void *priv,
 		break;
 	case NFPROTO_IPV6:
 		pnum = ipv6_hdr(skb)->nexthdr;
-		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum, &frag_off);
-		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+		start = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum, &frag_off);
+		if (start < 0 || (frag_off & htons(~0x7)) != 0)
 			return nf_conntrack_confirm(skb);
+
+		protoff = start;
 		break;
 	default:
 		return nf_conntrack_confirm(skb);
-- 
2.30.2

