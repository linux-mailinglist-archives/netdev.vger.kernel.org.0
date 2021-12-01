Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDA146459D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 04:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241642AbhLAD62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 22:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241638AbhLAD6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 22:58:23 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3801BC061748
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 19:55:03 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id m15so22154459pgu.11
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 19:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YaeKFsX1KofNItzE7OLhurInohiFOUCQOEHbA1sAEqI=;
        b=3onNIi9mMlCHbRc8pIiWSdbZzQ8bSTlCWcl/1Pm4RpVXT+eR3gK6MiBNvoUmicZO2k
         66rFF1/d+vKp/9a9Vlk3Sjav/WR+tm1daMeX8nbKKigFNW/VF3lmTmf1PgO5hZFgW5vB
         6Lfq0dK3eB7FxfowyvXCFp23SEu5gwBo4DPV1gHEXuHU+TpEZlc4Sn0JN6ZzCP95al6+
         KcWn/hIPpo6OlXDiLD4YCDdAXX8Wyl9y3ayLxEP+Ve4NBmIgr90t4jhU5ddtMwOeuRCC
         w9HNj4d7Bn8GaY1UN8YFOuChjhqYlyHHJDiJpS1iqCWoR9xzes6IN0xvbIUM536Y9P3/
         JJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YaeKFsX1KofNItzE7OLhurInohiFOUCQOEHbA1sAEqI=;
        b=EjxOOXvl2n6e4zt9vZ5Tk5PQlvEH6sePPKvKqThLN5p/GNJjBcNNnWmN5KVSkkirid
         RmJsNxTRJETQlgSDvo/3HSGpMJx8bDnRkCnbOAvlCS50jSbV5EeUd1XJKDsVLVK0SmWI
         ibtixmwXJtwCulMsdbJH/Z6eF3t3A/KGCkqkV/LX5THnxhkKwwXtJQ4AQiusQ9aX6KAt
         q+tfgjHCV8DW1ncIYDMZBfxYrB7Rl4RojTf6iSqGfitaJ98vrkLO7fgitx5mrayAafmB
         4Cu8n3n6bJjaeh7jst2yJ+Vn7HlY0tT4OCM6Du6a2GVwToUEDQuo565lBvTM19SWM63t
         kDAQ==
X-Gm-Message-State: AOAM531tGfIw6XrJQ9TwQGueO7gN89g7n2oV71T8jiFz8hoqLG02MJ0u
        Us+NhiV4J2p4k07IxxUY15yJdQ==
X-Google-Smtp-Source: ABdhPJytno4BKM7xrhKQupoYZLnpjJGyxc7I60G48S15ovrjedr1oSfP6RAn6nfrdDL6eOljCajehg==
X-Received: by 2002:a05:6a00:2387:b0:49f:af00:d5d0 with SMTP id f7-20020a056a00238700b0049faf00d5d0mr3721734pfc.1.1638330902605;
        Tue, 30 Nov 2021 19:55:02 -0800 (PST)
Received: from C02F52LSML85.bytedance.net ([139.177.225.236])
        by smtp.gmail.com with ESMTPSA id f3sm21679043pfg.167.2021.11.30.19.54.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Nov 2021 19:55:01 -0800 (PST)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH bpf-next] libbpf: Let any two INT/UNION compatible if their names and sizes match
Date:   Wed,  1 Dec 2021 11:54:50 +0800
Message-Id: <20211201035450.31083-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

commit:67c0496e87d193b8356d2af49ab95e8a1b954b3c(kernfs: convert
kernfs_node->id from union kernfs_node_id to u64).

The bpf program compiles on the kernel version after this commit and
then tries to run on the kernel before this commit, libbpf will report
an error. The reverse is also same.

libbpf: prog 'tcp_retransmit_synack_tp': relo #4: kind <byte_off> (0),
spec is [342] struct kernfs_node.id (0:9 @ offset 104)
libbpf: prog 'tcp_retransmit_synack_tp': relo #4: non-matching candidate
libbpf: prog 'tcp_retransmit_synack_tp': relo #4: non-matching candidate
libbpf: prog 'tcp_retransmit_synack_tp': relo #4: no matching targets
found

The type before this commit:
	union kernfs_node_id	id;
	union kernfs_node_id {
		struct {
			u32		ino;
			u32		generation;
		};
		u64			id;
	};

The type after this commit:
	u64 id;

We can find that the variable name and size have not changed except for
the type change.
So I added some judgment to let any two INT/UNION are compatible, if
their names and sizes match.

Reported-by: Chengming Zhou <zhouchengming@bytedance.com>
Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 tools/lib/bpf/relo_core.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index b5b8956a1be8..ff7f4e97bafb 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -294,6 +294,7 @@ static int bpf_core_parse_spec(const struct btf *btf,
  *   - any two FLOATs are always compatible;
  *   - for ARRAY, dimensionality is ignored, element types are checked for
  *     compatibility recursively;
+ *   - any two INT/UNION are compatible, if their names and sizes match;
  *   - everything else shouldn't be ever a target of relocation.
  * These rules are not set in stone and probably will be adjusted as we get
  * more experience with using BPF CO-RE relocations.
@@ -313,8 +314,14 @@ static int bpf_core_fields_are_compat(const struct btf *local_btf,
 
 	if (btf_is_composite(local_type) && btf_is_composite(targ_type))
 		return 1;
-	if (btf_kind(local_type) != btf_kind(targ_type))
-		return 0;
+	if (btf_kind(local_type) != btf_kind(targ_type)) {
+		if (local_type->size == targ_type->size &&
+		    (btf_is_union(local_type) || btf_is_union(targ_type)) &&
+		    (btf_is_int(local_type) || btf_is_int(targ_type)))
+			return 1;
+		else
+			return 0;
+	}
 
 	switch (btf_kind(local_type)) {
 	case BTF_KIND_PTR:
@@ -384,11 +391,17 @@ static int bpf_core_match_member(const struct btf *local_btf,
 	targ_type = skip_mods_and_typedefs(targ_btf, targ_id, &targ_id);
 	if (!targ_type)
 		return -EINVAL;
-	if (!btf_is_composite(targ_type))
-		return 0;
 
 	local_id = local_acc->type_id;
 	local_type = btf__type_by_id(local_btf, local_id);
+	if (!btf_is_composite(targ_type)) {
+		if (local_type->size == targ_type->size &&
+		    btf_is_union(local_type) && btf_is_int(targ_type))
+			return 1;
+		else
+			return 0;
+	}
+
 	local_member = btf_members(local_type) + local_acc->idx;
 	local_name = btf__name_by_offset(local_btf, local_member->name_off);
 
-- 
2.11.0

