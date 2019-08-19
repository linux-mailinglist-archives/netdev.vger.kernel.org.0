Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D3F94D61
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfHSS7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:59:43 -0400
Received: from correo.us.es ([193.147.175.20]:37876 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbfHSS7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 14:59:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8EEB8F262E
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:50:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F43DD2B1F
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:50:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 749BED2B1D; Mon, 19 Aug 2019 20:50:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60AF5DA72F;
        Mon, 19 Aug 2019 20:50:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Aug 2019 20:50:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.209.241])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E6DE64265A32;
        Mon, 19 Aug 2019 20:50:09 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/5] netfilter: ebtables: Fix argument order to ADD_COUNTER
Date:   Mon, 19 Aug 2019 20:49:08 +0200
Message-Id: <20190819184911.15263-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190819184911.15263-1-pablo@netfilter.org>
References: <20190819184911.15263-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Todd Seidelmann <tseidelmann@linode.com>

The ordering of arguments to the x_tables ADD_COUNTER macro
appears to be wrong in ebtables (cf. ip_tables.c, ip6_tables.c,
and arp_tables.c).

This causes data corruption in the ebtables userspace tools
because they get incorrect packet & byte counts from the kernel.

Fixes: d72133e628803 ("netfilter: ebtables: use ADD_COUNTER macro")
Signed-off-by: Todd Seidelmann <tseidelmann@linode.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c8177a89f52c..4096d8a74a2b 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -221,7 +221,7 @@ unsigned int ebt_do_table(struct sk_buff *skb,
 			return NF_DROP;
 		}
 
-		ADD_COUNTER(*(counter_base + i), 1, skb->len);
+		ADD_COUNTER(*(counter_base + i), skb->len, 1);
 
 		/* these should only watch: not modify, nor tell us
 		 * what to do with the packet
@@ -959,8 +959,8 @@ static void get_counters(const struct ebt_counter *oldcounters,
 			continue;
 		counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
 		for (i = 0; i < nentries; i++)
-			ADD_COUNTER(counters[i], counter_base[i].pcnt,
-				    counter_base[i].bcnt);
+			ADD_COUNTER(counters[i], counter_base[i].bcnt,
+				    counter_base[i].pcnt);
 	}
 }
 
@@ -1280,7 +1280,7 @@ static int do_update_counters(struct net *net, const char *name,
 
 	/* we add to the counters of the first cpu */
 	for (i = 0; i < num_counters; i++)
-		ADD_COUNTER(t->private->counters[i], tmp[i].pcnt, tmp[i].bcnt);
+		ADD_COUNTER(t->private->counters[i], tmp[i].bcnt, tmp[i].pcnt);
 
 	write_unlock_bh(&t->lock);
 	ret = 0;
-- 
2.11.0


