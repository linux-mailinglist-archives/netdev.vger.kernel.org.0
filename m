Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A32F1B371
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfEMJ5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:57:14 -0400
Received: from mail.us.es ([193.147.175.20]:34122 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728154AbfEMJ4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:56:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 239284DE722
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 134C8DA712
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08343DA7A2; Mon, 13 May 2019 11:56:39 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09836DA712;
        Mon, 13 May 2019 11:56:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:56:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C986C4265A31;
        Mon, 13 May 2019 11:56:36 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/13] netfilter: nft_flow_offload: add entry to flowtable after confirmation
Date:   Mon, 13 May 2019 11:56:19 +0200
Message-Id: <20190513095630.32443-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190513095630.32443-1-pablo@netfilter.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is fixing flow offload for UDP traffic where packets only follow
one single direction.

The flow_offload_fixup_tcp() mechanism works fine in case that the
offloaded entry remains in SYN_RECV state, given sequence tracking is
reset and that conntrack handles syn+ack packets as a retransmission, ie.

	sES + synack => sIG

for reply traffic.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 6e6b9adf7d38..8968c7f5a72e 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -94,8 +94,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (help)
 		goto out;
 
-	if (ctinfo == IP_CT_NEW ||
-	    ctinfo == IP_CT_RELATED)
+	if (!nf_ct_is_confirmed(ct))
 		goto out;
 
 	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
-- 
2.11.0

