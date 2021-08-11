Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444C73E8C62
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbhHKItq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:49:46 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44052 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbhHKItn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:49:43 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id B22486005D;
        Wed, 11 Aug 2021 10:48:35 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/10] netfilter: ipt_CLUSTERIP: use clusterip_net to store pernet warning
Date:   Wed, 11 Aug 2021 10:49:02 +0200
Message-Id: <20210811084908.14744-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210811084908.14744-1-pablo@netfilter.org>
References: <20210811084908.14744-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need to use struct net for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 6d7ff14b9084..8fd1aba8af31 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -66,6 +66,7 @@ struct clusterip_net {
 	/* lock protects the configs list */
 	spinlock_t lock;
 
+	bool clusterip_deprecated_warning;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *procdir;
 	/* mutex protects the config->pde*/
@@ -544,10 +545,10 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 
 	cn->hook_users++;
 
-	if (!par->net->xt.clusterip_deprecated_warning) {
+	if (!cn->clusterip_deprecated_warning) {
 		pr_info("ipt_CLUSTERIP is deprecated and it will removed soon, "
 			"use xt_cluster instead\n");
-		par->net->xt.clusterip_deprecated_warning = true;
+		cn->clusterip_deprecated_warning = true;
 	}
 
 	cipinfo->config = config;
-- 
2.20.1

