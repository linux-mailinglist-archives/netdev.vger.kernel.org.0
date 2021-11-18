Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3EA4565B3
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 23:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhKRW3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 17:29:42 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58272 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhKRW3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 17:29:37 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 25FBC64AF1;
        Thu, 18 Nov 2021 23:24:28 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 10/11] netfilter: flowtable: fix IPv6 tunnel addr match
Date:   Thu, 18 Nov 2021 23:26:17 +0100
Message-Id: <20211118222618.433273-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118222618.433273-1-pablo@netfilter.org>
References: <20211118222618.433273-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Will Mortensen <willmo@gmail.com>

Previously the IPv6 addresses in the key were clobbered and the mask was
left unset.

I haven't tested this; I noticed it while skimming the code to
understand an unrelated issue.

Fixes: cfab6dbd0ecf ("netfilter: flowtable: add tunnel match offload support")
Cc: wenxu <wenxu@ucloud.cn>
Signed-off-by: Will Mortensen <willmo@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index d6bf1b2cd541..b561e0a44a45 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -65,11 +65,11 @@ static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
 		       sizeof(struct in6_addr));
 		if (memcmp(&key->enc_ipv6.src, &in6addr_any,
 			   sizeof(struct in6_addr)))
-			memset(&key->enc_ipv6.src, 0xff,
+			memset(&mask->enc_ipv6.src, 0xff,
 			       sizeof(struct in6_addr));
 		if (memcmp(&key->enc_ipv6.dst, &in6addr_any,
 			   sizeof(struct in6_addr)))
-			memset(&key->enc_ipv6.dst, 0xff,
+			memset(&mask->enc_ipv6.dst, 0xff,
 			       sizeof(struct in6_addr));
 		enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS);
 		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
-- 
2.30.2

