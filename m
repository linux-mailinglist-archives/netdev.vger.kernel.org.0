Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8B14A8D43
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354090AbiBCUaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:30:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35256 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354070AbiBCU34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:29:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D3E961A7B;
        Thu,  3 Feb 2022 20:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B7CC340E8;
        Thu,  3 Feb 2022 20:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920195;
        bh=IpJaUgCby7BfLwA8UIjAkqWSIcHsUn66qeLSJKTrifk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxX/2irktLXi/cy3PHI7NkqIR8zyp20FwuCDdJTywWFSRXqz+wpn8x5mbcCGLeNo8
         yGkKedGFgEbvme0c4FGMbW+9jVFJkRoxlqtrrygejUr3E/Y0Z0UIdZC8QHnCm2Ho+b
         ZN8bay+PzfeB40uMFOC8Rw10l/GFXIMYGZDHMg0dyfBeEawgzhg6H9iRPA9OTlnmcr
         ks9oVqUQdnG3PdKxQOvZJrh+Ae7DP1rOeWMW7Cguy1YPosS1b+YHJwxvqO9YhEYTh2
         AGQpok+GoTz1ZRXrr6ncYZdyOUXXkEIUGMPOXu8Gsp1RSJxaQWx3XoPVvNQkmXm3Fj
         dBdKs1GI9FZ2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 05/52] netfilter: nf_conntrack_netbios_ns: fix helper module alias
Date:   Thu,  3 Feb 2022 15:28:59 -0500
Message-Id: <20220203202947.2304-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index 7f19ee2596090..55415f011943d 100644
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
2.34.1

