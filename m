Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AAB491BB7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352673AbiARDIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345895AbiARC7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:59:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0D0C061749;
        Mon, 17 Jan 2022 18:34:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 266BE6125B;
        Tue, 18 Jan 2022 02:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ED9C36AE3;
        Tue, 18 Jan 2022 02:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473260;
        bh=da7yra2sK83x182IbRNhsA3JLw2YPhWk5aj8Hqu+ro8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijsLD3oO/hUCmr/KUvUjQ9UL219tTFkkO0CUGIUMdgYmISNminSY/vEfQTYYkqAc9
         /GoEBzrr2tVIzucy8YdysX3C3t8udaAuYsNXZMyVHsu05oht5nYg53kJ6XN+Bo2L5k
         DLCAtEVs8Bdl5ywdmQhPRhGOQOF6tnHWoU3QzrnwfD4M0ptCKGSBjNdulQmkOJeukZ
         qWGM9uuHjBv7gXdCV2wrZetKe/rsx9ZgXUER7k2bGBkWmom9HnAyjYTakZVjX4MTTl
         jK3bP4XYoa8ncMe19LF0JSB4PAuXLWk0uy01OWLC96C9I+Mkvg+W+yhAyzByV4Dv/h
         0Dkb/KjjZG50g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 045/188] libbpf: Accommodate DWARF/compiler bug with duplicated structs
Date:   Mon, 17 Jan 2022 21:29:29 -0500
Message-Id: <20220118023152.1948105-45-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit efdd3eb8015e7447095f02a26eaabd164cd18004 ]

According to [0], compilers sometimes might produce duplicate DWARF
definitions for exactly the same struct/union within the same
compilation unit (CU). We've had similar issues with identical arrays
and handled them with a similar workaround in 6b6e6b1d09aa ("libbpf:
Accomodate DWARF/compiler bug with duplicated identical arrays"). Do the
same for struct/union by ensuring that two structs/unions are exactly
the same, down to the integer values of field referenced type IDs.

Solving this more generically (allowing referenced types to be
equivalent, but using different type IDs, all within a single CU)
requires a huge complexity increase to handle many-to-many mappings
between canonidal and candidate type graphs. Before we invest in that,
let's see if this approach handles all the instances of this issue in
practice. Thankfully it's pretty rare, it seems.

  [0] https://lore.kernel.org/bpf/YXr2NFlJTAhHdZqq@krava/

Reported-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211117194114.347675-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1b9341ef638b0..ddd51e6d3a761 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3358,8 +3358,8 @@ static long btf_hash_struct(struct btf_type *t)
 }
 
 /*
- * Check structural compatibility of two FUNC_PROTOs, ignoring referenced type
- * IDs. This check is performed during type graph equivalence check and
+ * Check structural compatibility of two STRUCTs/UNIONs, ignoring referenced
+ * type IDs. This check is performed during type graph equivalence check and
  * referenced types equivalence is checked separately.
  */
 static bool btf_shallow_equal_struct(struct btf_type *t1, struct btf_type *t2)
@@ -3730,6 +3730,31 @@ static int btf_dedup_identical_arrays(struct btf_dedup *d, __u32 id1, __u32 id2)
 	return btf_equal_array(t1, t2);
 }
 
+/* Check if given two types are identical STRUCT/UNION definitions */
+static bool btf_dedup_identical_structs(struct btf_dedup *d, __u32 id1, __u32 id2)
+{
+	const struct btf_member *m1, *m2;
+	struct btf_type *t1, *t2;
+	int n, i;
+
+	t1 = btf_type_by_id(d->btf, id1);
+	t2 = btf_type_by_id(d->btf, id2);
+
+	if (!btf_is_composite(t1) || btf_kind(t1) != btf_kind(t2))
+		return false;
+
+	if (!btf_shallow_equal_struct(t1, t2))
+		return false;
+
+	m1 = btf_members(t1);
+	m2 = btf_members(t2);
+	for (i = 0, n = btf_vlen(t1); i < n; i++, m1++, m2++) {
+		if (m1->type != m2->type)
+			return false;
+	}
+	return true;
+}
+
 /*
  * Check equivalence of BTF type graph formed by candidate struct/union (we'll
  * call it "candidate graph" in this description for brevity) to a type graph
@@ -3841,6 +3866,8 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 
 	hypot_type_id = d->hypot_map[canon_id];
 	if (hypot_type_id <= BTF_MAX_NR_TYPES) {
+		if (hypot_type_id == cand_id)
+			return 1;
 		/* In some cases compiler will generate different DWARF types
 		 * for *identical* array type definitions and use them for
 		 * different fields within the *same* struct. This breaks type
@@ -3849,8 +3876,18 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 		 * types within a single CU. So work around that by explicitly
 		 * allowing identical array types here.
 		 */
-		return hypot_type_id == cand_id ||
-		       btf_dedup_identical_arrays(d, hypot_type_id, cand_id);
+		if (btf_dedup_identical_arrays(d, hypot_type_id, cand_id))
+			return 1;
+		/* It turns out that similar situation can happen with
+		 * struct/union sometimes, sigh... Handle the case where
+		 * structs/unions are exactly the same, down to the referenced
+		 * type IDs. Anything more complicated (e.g., if referenced
+		 * types are different, but equivalent) is *way more*
+		 * complicated and requires a many-to-many equivalence mapping.
+		 */
+		if (btf_dedup_identical_structs(d, hypot_type_id, cand_id))
+			return 1;
+		return 0;
 	}
 
 	if (btf_dedup_hypot_map_add(d, canon_id, cand_id))
-- 
2.34.1

