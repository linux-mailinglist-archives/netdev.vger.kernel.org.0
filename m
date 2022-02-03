Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE244A8ECF
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355702AbiBCUi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:38:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43206 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354990AbiBCUg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:36:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91CF060ACB;
        Thu,  3 Feb 2022 20:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE53C340F2;
        Thu,  3 Feb 2022 20:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920617;
        bh=5H7ZWdZ/Wp1Y3BFdLHd5wftiDtn0QwxHwepFUjOJhtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoEAzh7YGywCYqdnYZMncrREXaP042nq1pkoRNKgr6wU0ka+ALFzaXwtP7ier3oWS
         jG0BGvLIucz7F6C9EMLKP+On9dwT8PoofMkFSytX4qkTpeMcsFOKrONHvKaUJSydtw
         4CBLccUlx4CxK9ILmx4NK2iN/9KXAEbje7WLuC3jDlKpl8h7KjQBvp+2UwHrtGto4f
         J3VOMm4jnXv/WNI5AgfvUa/ZhsuJf8I2NMq2q01cHOQp5zlwctKtMWrBgyf3zBLjvE
         zc77sdw1HyxrVPUt9jIiZFOnxnW6aFpLs1KSa+jGWm4fUw5t5mbocZo3I/2l3sPWyB
         1UuZjHs+XWQiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/7] netfilter: nf_conntrack_netbios_ns: fix helper module alias
Date:   Thu,  3 Feb 2022 15:36:47 -0500
Message-Id: <20220203203651.5158-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203651.5158-1-sashal@kernel.org>
References: <20220203203651.5158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 0e906607b9c5ee22312c9af4d8adb45c617ea38a ]

The helper gets registered as 'netbios-ns', not netbios_ns.
Intentionally not adding a fixes-tag because i don't want this to go to
stable. This wasn't noticed for a very long time so no so no need to risk
regressions.

Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netbios_ns.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 4c8f30a3d6d27..1c429f2186eaf 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -24,13 +24,14 @@
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
 module_param(timeout, uint, S_IRUSR);
@@ -47,7 +48,7 @@ static int netbios_ns_help(struct sk_buff *skb, unsigned int protoff,
 }
 
 static struct nf_conntrack_helper helper __read_mostly = {
-	.name			= "netbios-ns",
+	.name			= HELPER_NAME,
 	.tuple.src.l3num	= NFPROTO_IPV4,
 	.tuple.src.u.udp.port	= cpu_to_be16(NMBD_PORT),
 	.tuple.dst.protonum	= IPPROTO_UDP,
-- 
2.34.1

