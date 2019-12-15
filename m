Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B471911F563
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 03:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLOCto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 21:49:44 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45048 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726865AbfLOCto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 21:49:44 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1igJyX-0003uy-94; Sun, 15 Dec 2019 03:49:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+f68108fed972453a0ad4@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ebtables: compat: reject all padding in matches/watchers
Date:   Sun, 15 Dec 2019 03:49:25 +0100
Message-Id: <20191215024925.10872-1-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <000000000000cd9e600599b051e5@google.com>
References: <000000000000cd9e600599b051e5@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.23.0

