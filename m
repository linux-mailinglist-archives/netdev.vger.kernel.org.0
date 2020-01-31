Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A9B14F2AD
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 20:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgAaTYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 14:24:39 -0500
Received: from correo.us.es ([193.147.175.20]:36808 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbgAaTYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 14:24:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 721F8FC5F9
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 20:24:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62F35DA715
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 20:24:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 56997DA711; Fri, 31 Jan 2020 20:24:36 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EC86DA70F;
        Fri, 31 Jan 2020 20:24:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 20:24:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 19B9742EFB81;
        Fri, 31 Jan 2020 20:24:34 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/6] netfilter: Use kvcalloc
Date:   Fri, 31 Jan 2020 20:24:24 +0100
Message-Id: <20200131192428.167274-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200131192428.167274-1-pablo@netfilter.org>
References: <20200131192428.167274-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>

Convert the uses of kvmalloc_array with __GFP_ZERO to
the equivalent kvcalloc.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 3 +--
 net/netfilter/x_tables.c          | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f4c4b467c87e..d1305423640f 100644
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
index ce70c2576bb2..e27c6c5ba9df 100644
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
-- 
2.11.0

