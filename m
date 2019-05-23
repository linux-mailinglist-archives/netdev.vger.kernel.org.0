Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0402E28C6A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388329AbfEWVgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:36:01 -0400
Received: from mail.us.es ([193.147.175.20]:46952 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388240AbfEWVgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 17:36:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 930E2C1A71
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 841CEDA70C
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 79D54DA709; Thu, 23 May 2019 23:35:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06EFFDA704;
        Thu, 23 May 2019 23:35:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CA6664265A32;
        Thu, 23 May 2019 23:35:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/11] netfilter: nat: fix udp checksum corruption
Date:   Thu, 23 May 2019 23:35:42 +0200
Message-Id: <20190523213547.15523-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523213547.15523-1-pablo@netfilter.org>
References: <20190523213547.15523-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Due to copy&paste error nf_nat_mangle_udp_packet passes IPPROTO_TCP,
resulting in incorrect udp checksum when payload had to be mangled.

Fixes: dac3fe72596f9 ("netfilter: nat: remove csum_recalc hook")
Reported-by: Marc Haber <mh+netdev@zugschlus.de>
Tested-by: Marc Haber <mh+netdev@zugschlus.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index ccc06f7539d7..53aeb12b70fb 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -170,7 +170,7 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
 	if (!udph->check && skb->ip_summed != CHECKSUM_PARTIAL)
 		return true;
 
-	nf_nat_csum_recalc(skb, nf_ct_l3num(ct), IPPROTO_TCP,
+	nf_nat_csum_recalc(skb, nf_ct_l3num(ct), IPPROTO_UDP,
 			   udph, &udph->check, datalen, oldlen);
 
 	return true;
-- 
2.11.0

