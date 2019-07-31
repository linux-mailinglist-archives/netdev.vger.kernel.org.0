Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895C47C084
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfGaLwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:52:21 -0400
Received: from correo.us.es ([193.147.175.20]:59396 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfGaLwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 07:52:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A322B80762
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92FCAA590
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88B62DA708; Wed, 31 Jul 2019 13:52:13 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 791EDDA732;
        Wed, 31 Jul 2019 13:52:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 13:52:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0594E4265A31;
        Wed, 31 Jul 2019 13:52:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 8/8] netfilter: ebtables: also count base chain policies
Date:   Wed, 31 Jul 2019 13:51:57 +0200
Message-Id: <20190731115157.27020-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190731115157.27020-1-pablo@netfilter.org>
References: <20190731115157.27020-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

ebtables doesn't include the base chain policies in the rule count,
so we need to add them manually when we call into the x_tables core
to allocate space for the comapt offset table.

This lead syzbot to trigger:
WARNING: CPU: 1 PID: 9012 at net/netfilter/x_tables.c:649
xt_compat_add_offset.cold+0x11/0x36 net/netfilter/x_tables.c:649

Reported-by: syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com
Fixes: 2035f3ff8eaa ("netfilter: ebtables: compat: un-break 32bit setsockopt when no rules are present")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index fd84b48e48b5..c8177a89f52c 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1770,20 +1770,28 @@ static int compat_calc_entry(const struct ebt_entry *e,
 	return 0;
 }
 
+static int ebt_compat_init_offsets(unsigned int number)
+{
+	if (number > INT_MAX)
+		return -EINVAL;
+
+	/* also count the base chain policies */
+	number += NF_BR_NUMHOOKS;
+
+	return xt_compat_init_offsets(NFPROTO_BRIDGE, number);
+}
 
 static int compat_table_info(const struct ebt_table_info *info,
 			     struct compat_ebt_replace *newinfo)
 {
 	unsigned int size = info->entries_size;
 	const void *entries = info->entries;
+	int ret;
 
 	newinfo->entries_size = size;
-	if (info->nentries) {
-		int ret = xt_compat_init_offsets(NFPROTO_BRIDGE,
-						 info->nentries);
-		if (ret)
-			return ret;
-	}
+	ret = ebt_compat_init_offsets(info->nentries);
+	if (ret)
+		return ret;
 
 	return EBT_ENTRY_ITERATE(entries, size, compat_calc_entry, info,
 							entries, newinfo);
@@ -2234,11 +2242,9 @@ static int compat_do_replace(struct net *net, void __user *user,
 
 	xt_compat_lock(NFPROTO_BRIDGE);
 
-	if (tmp.nentries) {
-		ret = xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
-		if (ret < 0)
-			goto out_unlock;
-	}
+	ret = ebt_compat_init_offsets(tmp.nentries);
+	if (ret < 0)
+		goto out_unlock;
 
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
 	if (ret < 0)
-- 
2.11.0

