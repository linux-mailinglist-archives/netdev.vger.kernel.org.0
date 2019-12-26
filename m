Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C533612AD86
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfLZQkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:40:13 -0500
Received: from correo.us.es ([193.147.175.20]:54788 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfLZQkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 11:40:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C275E34F2
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:40:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F3C5DA713
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:40:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 54C8ADA70F; Thu, 26 Dec 2019 17:40:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 35E7FDA710;
        Thu, 26 Dec 2019 17:40:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Dec 2019 17:40:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1577E4251481;
        Thu, 26 Dec 2019 17:40:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/4] netfilter: ebtables: compat: reject all padding in matches/watchers
Date:   Thu, 26 Dec 2019 17:39:55 +0100
Message-Id: <20191226163956.672174-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191226163956.672174-1-pablo@netfilter.org>
References: <20191226163956.672174-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot reported following splat:

BUG: KASAN: vmalloc-out-of-bounds in size_entry_mwt net/bridge/netfilter/ebtables.c:2063 [inline]
BUG: KASAN: vmalloc-out-of-bounds in compat_copy_entries+0x128b/0x1380 net/bridge/netfilter/ebtables.c:2155
Read of size 4 at addr ffffc900004461f4 by task syz-executor267/7937

CPU: 1 PID: 7937 Comm: syz-executor267 Not tainted 5.5.0-rc1-syzkaller #0
 size_entry_mwt net/bridge/netfilter/ebtables.c:2063 [inline]
 compat_copy_entries+0x128b/0x1380 net/bridge/netfilter/ebtables.c:2155
 compat_do_replace+0x344/0x720 net/bridge/netfilter/ebtables.c:2249
 compat_do_ebt_set_ctl+0x22f/0x27e net/bridge/netfilter/ebtables.c:2333
 [..]

Because padding isn't considered during computation of ->buf_user_offset,
"total" is decremented by fewer bytes than it should.

Therefore, the first part of

if (*total < sizeof(*entry) || entry->next_offset < sizeof(*entry))

will pass, -- it should not have.  This causes oob access:
entry->next_offset is past the vmalloced size.

Reject padding and check that computed user offset (sum of ebt_entry
structure plus all individual matches/watchers/targets) is same
value that userspace gave us as the offset of the next entry.

Reported-by: syzbot+f68108fed972453a0ad4@syzkaller.appspotmail.com
Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 4096d8a74a2b..e1256e03a9a8 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1867,7 +1867,7 @@ static int ebt_buf_count(struct ebt_entries_buf_state *state, unsigned int sz)
 }
 
 static int ebt_buf_add(struct ebt_entries_buf_state *state,
-		       void *data, unsigned int sz)
+		       const void *data, unsigned int sz)
 {
 	if (state->buf_kern_start == NULL)
 		goto count_only;
@@ -1901,7 +1901,7 @@ enum compat_mwt {
 	EBT_COMPAT_TARGET,
 };
 
-static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
+static int compat_mtw_from_user(const struct compat_ebt_entry_mwt *mwt,
 				enum compat_mwt compat_mwt,
 				struct ebt_entries_buf_state *state,
 				const unsigned char *base)
@@ -1979,22 +1979,23 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 /* return size of all matches, watchers or target, including necessary
  * alignment and padding.
  */
-static int ebt_size_mwt(struct compat_ebt_entry_mwt *match32,
+static int ebt_size_mwt(const struct compat_ebt_entry_mwt *match32,
 			unsigned int size_left, enum compat_mwt type,
 			struct ebt_entries_buf_state *state, const void *base)
 {
+	const char *buf = (const char *)match32;
 	int growth = 0;
-	char *buf;
 
 	if (size_left == 0)
 		return 0;
 
-	buf = (char *) match32;
-
-	while (size_left >= sizeof(*match32)) {
+	do {
 		struct ebt_entry_match *match_kern;
 		int ret;
 
+		if (size_left < sizeof(*match32))
+			return -EINVAL;
+
 		match_kern = (struct ebt_entry_match *) state->buf_kern_start;
 		if (match_kern) {
 			char *tmp;
@@ -2031,22 +2032,18 @@ static int ebt_size_mwt(struct compat_ebt_entry_mwt *match32,
 		if (match_kern)
 			match_kern->match_size = ret;
 
-		/* rule should have no remaining data after target */
-		if (type == EBT_COMPAT_TARGET && size_left)
-			return -EINVAL;
-
 		match32 = (struct compat_ebt_entry_mwt *) buf;
-	}
+	} while (size_left);
 
 	return growth;
 }
 
 /* called for all ebt_entry structures. */
-static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *base,
+static int size_entry_mwt(const struct ebt_entry *entry, const unsigned char *base,
 			  unsigned int *total,
 			  struct ebt_entries_buf_state *state)
 {
-	unsigned int i, j, startoff, new_offset = 0;
+	unsigned int i, j, startoff, next_expected_off, new_offset = 0;
 	/* stores match/watchers/targets & offset of next struct ebt_entry: */
 	unsigned int offsets[4];
 	unsigned int *offsets_update = NULL;
@@ -2132,11 +2129,13 @@ static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *base,
 			return ret;
 	}
 
-	startoff = state->buf_user_offset - startoff;
+	next_expected_off = state->buf_user_offset - startoff;
+	if (next_expected_off != entry->next_offset)
+		return -EINVAL;
 
-	if (WARN_ON(*total < startoff))
+	if (*total < entry->next_offset)
 		return -EINVAL;
-	*total -= startoff;
+	*total -= entry->next_offset;
 	return 0;
 }
 
-- 
2.11.0

