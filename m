Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34051635F0
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 23:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgBRWVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 17:21:12 -0500
Received: from correo.us.es ([193.147.175.20]:57496 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgBRWVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 17:21:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C360303D0C
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 23:21:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E282DA3AA
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 23:21:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 310EADA3A5; Tue, 18 Feb 2020 23:21:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53188DA3C2;
        Tue, 18 Feb 2020 23:21:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 23:21:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2AE9B42EE38E;
        Tue, 18 Feb 2020 23:21:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/9] netfilter: flowtable: skip offload setup if disabled
Date:   Tue, 18 Feb 2020 23:20:55 +0100
Message-Id: <20200218222101.635808-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200218222101.635808-1-pablo@netfilter.org>
References: <20200218222101.635808-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nftables test case
tests/shell/testcases/flowtable/0001flowtable_0

results in a crash. After the refactor, if we leave early via
nf_flowtable_hw_offload(), then "struct flow_block_offload" is left
in an uninitialized state, but later users assume its initialised.

Fixes: a7965d58ddab02 ("netfilter: flowtable: add nf_flow_table_offload_cmd()")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 83e1db37c3b0..06f00cdc3891 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -847,9 +847,6 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 {
 	int err;
 
-	if (!nf_flowtable_hw_offload(flowtable))
-		return 0;
-
 	if (!dev->netdev_ops->ndo_setup_tc)
 		return -EOPNOTSUPP;
 
@@ -876,6 +873,9 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	struct flow_block_offload bo;
 	int err;
 
+	if (!nf_flowtable_hw_offload(flowtable))
+		return 0;
+
 	err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd, &extack);
 	if (err < 0)
 		return err;
-- 
2.11.0

