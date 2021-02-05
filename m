Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5212A310180
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhBEASd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:18:33 -0500
Received: from correo.us.es ([193.147.175.20]:40578 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhBEASQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 19:18:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DD25A2A325B
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 01:17:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7315DA78D
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 01:17:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BC37BDA78A; Fri,  5 Feb 2021 01:17:33 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16FA5DA73F;
        Fri,  5 Feb 2021 01:17:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Feb 2021 01:17:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id DDA8942EF9E1;
        Fri,  5 Feb 2021 01:17:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update deleted entry
Date:   Fri,  5 Feb 2021 01:17:24 +0100
Message-Id: <20210205001727.2125-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205001727.2125-1-pablo@netfilter.org>
References: <20210205001727.2125-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@mail.kfki.hu>

When both --reap and --update flag are specified, there's a code
path at which the entry to be updated is reaped beforehand,
which then leads to kernel crash. Reap only entries which won't be
updated.

Fixes kernel bugzilla #207773.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=207773
Reported-by: Reindl Harald <h.reindl@thelounge.net>
Fixes: 0079c5aee348 ("netfilter: xt_recent: add an entry reaper")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_recent.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 606411869698..0446307516cd 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -152,7 +152,8 @@ static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
 /*
  * Drop entries with timestamps older then 'time'.
  */
-static void recent_entry_reap(struct recent_table *t, unsigned long time)
+static void recent_entry_reap(struct recent_table *t, unsigned long time,
+			      struct recent_entry *working, bool update)
 {
 	struct recent_entry *e;
 
@@ -161,6 +162,12 @@ static void recent_entry_reap(struct recent_table *t, unsigned long time)
 	 */
 	e = list_entry(t->lru_list.next, struct recent_entry, lru_list);
 
+	/*
+	 * Do not reap the entry which are going to be updated.
+	 */
+	if (e == working && update)
+		return;
+
 	/*
 	 * The last time stamp is the most recent.
 	 */
@@ -303,7 +310,8 @@ recent_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 		/* info->seconds must be non-zero */
 		if (info->check_set & XT_RECENT_REAP)
-			recent_entry_reap(t, time);
+			recent_entry_reap(t, time, e,
+				info->check_set & XT_RECENT_UPDATE && ret);
 	}
 
 	if (info->check_set & XT_RECENT_SET ||
-- 
2.20.1

