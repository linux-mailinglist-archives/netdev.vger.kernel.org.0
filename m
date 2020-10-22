Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B647E2963BE
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S367960AbgJVR3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:29:52 -0400
Received: from correo.us.es ([193.147.175.20]:54130 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900088AbgJVR3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00E421C439F
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD23BDA84D
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2882DA704; Thu, 22 Oct 2020 19:29:36 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C9CDDA858;
        Thu, 22 Oct 2020 19:29:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 19:29:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 70AB442EE393;
        Thu, 22 Oct 2020 19:29:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/7] netfilter: Drop fragmented ndisc packets assembled in netfilter
Date:   Thu, 22 Oct 2020 19:29:21 +0200
Message-Id: <20201022172925.22770-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201022172925.22770-1-pablo@netfilter.org>
References: <20201022172925.22770-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Georg Kohmann <geokohma@cisco.com>

Fragmented ndisc packets assembled in netfilter not dropped as specified
in RFC 6980, section 5. This behaviour breaks TAHI IPv6 Core Conformance
Tests v6LC.2.1.22/23, V6LC.2.2.26/27 and V6LC.2.3.18.

Setting IP6SKB_FRAGMENTED flag during reassembly.

References: commit b800c3b966bc ("ipv6: drop fragmented ndisc packets by default (RFC 6980)")
Signed-off-by: Georg Kohmann <geokohma@cisco.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index fed9666a2f7d..054d287eb13d 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -355,6 +355,7 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	ipv6_hdr(skb)->payload_len = htons(payload_len);
 	ipv6_change_dsfield(ipv6_hdr(skb), 0xff, ecn);
 	IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
+	IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
 
 	/* Yes, and fold redundant checksum back. 8) */
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
-- 
2.20.1

