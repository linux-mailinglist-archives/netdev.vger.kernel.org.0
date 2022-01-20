Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7368494E52
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244250AbiATMwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:52:24 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38728 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243858AbiATMwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:52:20 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3EECB6006E;
        Thu, 20 Jan 2022 13:49:20 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/5] netfilter: nf_conntrack_netbios_ns: fix helper module alias
Date:   Thu, 20 Jan 2022 13:52:08 +0100
Message-Id: <20220120125212.991271-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120125212.991271-1-pablo@netfilter.org>
References: <20220120125212.991271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The helper gets registered as 'netbios-ns', not netbios_ns.
Intentionally not adding a fixes-tag because i don't want this to go to
stable. This wasn't noticed for a very long time so no so no need to risk
regressions.

Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netbios_ns.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 7f19ee259609..55415f011943 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -20,13 +20,14 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
+#define HELPER_NAME	"netbios-ns"
 #define NMBD_PORT	137
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("NetBIOS name service broadcast connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_netbios_ns");
-MODULE_ALIAS_NFCT_HELPER("netbios_ns");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 static unsigned int timeout __read_mostly = 3;
 module_param(timeout, uint, 0400);
@@ -44,7 +45,7 @@ static int netbios_ns_help(struct sk_buff *skb, unsigned int protoff,
 }
 
 static struct nf_conntrack_helper helper __read_mostly = {
-	.name			= "netbios-ns",
+	.name			= HELPER_NAME,
 	.tuple.src.l3num	= NFPROTO_IPV4,
 	.tuple.src.u.udp.port	= cpu_to_be16(NMBD_PORT),
 	.tuple.dst.protonum	= IPPROTO_UDP,
-- 
2.30.2

