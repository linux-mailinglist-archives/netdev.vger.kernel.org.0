Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D315170BEE
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 23:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgBZWzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 17:55:00 -0500
Received: from correo.us.es ([193.147.175.20]:36412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbgBZWy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 17:54:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF4251C438A
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:54:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D97F2DA8E6
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:54:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CEDCCDA72F; Wed, 26 Feb 2020 23:54:49 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0679CDA72F;
        Wed, 26 Feb 2020 23:54:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 23:54:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CBA3342EF4E0;
        Wed, 26 Feb 2020 23:54:47 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/6] netfilter: ipset: Fix forceadd evaluation path
Date:   Wed, 26 Feb 2020 23:54:38 +0100
Message-Id: <20200226225442.9598-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200226225442.9598-1-pablo@netfilter.org>
References: <20200226225442.9598-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

When the forceadd option is enabled, the hash:* types should find and replace
the first entry in the bucket with the new one if there are no reuseable
(deleted or timed out) entries. However, the position index was just not set
to zero and remained the invalid -1 if there were no reuseable entries.

Reported-by: syzbot+6a86565c74ebe30aea18@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and protocol version 7")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 71e93eac0831..e52d7b7597a0 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -931,6 +931,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		}
 	}
 	if (reuse || forceadd) {
+		if (j == -1)
+			j = 0;
 		data = ahash_data(n, j, set->dsize);
 		if (!deleted) {
 #ifdef IP_SET_HASH_WITH_NETS
-- 
2.11.0

