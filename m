Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B509617C531
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCFSPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:15:23 -0500
Received: from correo.us.es ([193.147.175.20]:40758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbgCFSPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 802DB15AEB5
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FD41DA3AB
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 657D1DA3A8; Fri,  6 Mar 2020 19:15:03 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41372DA3AB;
        Fri,  6 Mar 2020 19:15:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:15:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1CD104301DE0;
        Fri,  6 Mar 2020 19:15:01 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/11] netfilter: xt_recent: recent_seq_next should increase position index
Date:   Fri,  6 Mar 2020 19:15:05 +0100
Message-Id: <20200306181513.656594-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200306181513.656594-1-pablo@netfilter.org>
References: <20200306181513.656594-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

If .next function does not change position index,
following .show function will repeat output related
to current position index.

Without the patch:
 # dd if=/proc/net/xt_recent/SSH # original file outpt
 src=127.0.0.4 ttl: 0 last_seen: 6275444819 oldest_pkt: 1 6275444819
 src=127.0.0.2 ttl: 0 last_seen: 6275438906 oldest_pkt: 1 6275438906
 src=127.0.0.3 ttl: 0 last_seen: 6275441953 oldest_pkt: 1 6275441953
 0+1 records in
 0+1 records out
 204 bytes copied, 6.1332e-05 s, 3.3 MB/s

Read after lseek into middle of last line (offset 140 in example below)
generates expected end of last line and then unexpected whole last line
once again

 # dd if=/proc/net/xt_recent/SSH bs=140 skip=1
 dd: /proc/net/xt_recent/SSH: cannot skip to specified offset
 127.0.0.3 ttl: 0 last_seen: 6275441953 oldest_pkt: 1 6275441953
 src=127.0.0.3 ttl: 0 last_seen: 6275441953 oldest_pkt: 1 6275441953
 0+1 records in
 0+1 records out
 132 bytes copied, 6.2487e-05 s, 2.1 MB/s

Cc: stable@vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_recent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 0a9708004e20..225a7ab6d79a 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -492,12 +492,12 @@ static void *recent_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	const struct recent_entry *e = v;
 	const struct list_head *head = e->list.next;
 
+	(*pos)++;
 	while (head == &t->iphash[st->bucket]) {
 		if (++st->bucket >= ip_list_hash_size)
 			return NULL;
 		head = t->iphash[st->bucket].next;
 	}
-	(*pos)++;
 	return list_entry(head, struct recent_entry, list);
 }
 
-- 
2.11.0

