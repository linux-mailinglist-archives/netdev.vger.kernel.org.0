Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814F814C0A0
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 20:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgA1TIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 14:08:36 -0500
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:40971 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726303AbgA1TIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 14:08:36 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 94DD918225DF9;
        Tue, 28 Jan 2020 19:08:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:4321:4398:4605:5007:8603:10004:10400:11026:11473:11658:11914:12043:12296:12297:12438:12555:12760:12986:13069:13161:13229:13311:13357:13439:14096:14097:14181:14394:14659:14721:21080:21212:21433:21451:21627:21990:30034:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: brush21_4aa0e106f0634
X-Filterd-Recvd-Size: 2518
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Tue, 28 Jan 2020 19:08:32 +0000 (UTC)
Message-ID: <5a01f309d91c35fa10b8faa60f4b84a8cb7d13b0.camel@perches.com>
Subject: [PATCH] netfilter: Use kvcalloc
From:   Joe Perches <joe@perches.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 28 Jan 2020 11:07:27 -0800
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the uses of kvmalloc_array with __GFP_ZERO to
the equivalent kvcalloc.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/netfilter/nf_conntrack_core.c | 3 +--
 net/netfilter/x_tables.c          | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f4c4b46..d13054 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2248,8 +2248,7 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
 	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
 
-	hash = kvmalloc_array(nr_slots, sizeof(struct hlist_nulls_head),
-			      GFP_KERNEL | __GFP_ZERO);
+	hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head), GFP_KERNEL);
 
 	if (hash && nulls)
 		for (i = 0; i < nr_slots; i++)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ce70c25..e27c6c5 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -939,14 +939,14 @@ EXPORT_SYMBOL(xt_check_entry_offsets);
  *
  * @size: number of entries
  *
- * Return: NULL or kmalloc'd or vmalloc'd array
+ * Return: NULL or zeroed kmalloc'd or vmalloc'd array
  */
 unsigned int *xt_alloc_entry_offsets(unsigned int size)
 {
 	if (size > XT_MAX_TABLE_SIZE / sizeof(unsigned int))
 		return NULL;
 
-	return kvmalloc_array(size, sizeof(unsigned int), GFP_KERNEL | __GFP_ZERO);
+	return kvcalloc(size, sizeof(unsigned int), GFP_KERNEL);
 
 }
 EXPORT_SYMBOL(xt_alloc_entry_offsets);


