Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263D8345A8
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 13:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfFDLkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 07:40:15 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:60546 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfFDLkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 07:40:15 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 3B642440271;
        Tue,  4 Jun 2019 14:40:11 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "Dmitry V . Levin" <ldv@altlinux.org>,
        Baruch Siach <baruch@tkos.co.il>, Jiri Olsa <jolsa@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] bpf: fix uapi bpf_prog_info fields alignment
Date:   Tue,  4 Jun 2019 14:39:27 +0300
Message-Id: <f42c7b44b3f694056c4216e9d9ba914b44e72ab9.1559648367.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge commit 1c8c5a9d38f60 ("Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
applications") by taking the gpl_compatible 1-bit field definition from
commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
bpf_prog_info") as is. That breaks architectures with 16-bit alignment
like m68k. Widen gpl_compatible to 32-bit to restore alignment of the
following fields.

Thanks to Dmitry V. Levin his analysis of this bug history.

Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 include/uapi/linux/bpf.h       | 2 +-
 tools/include/uapi/linux/bpf.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 63e0cf66f01a..fe73829b5b1c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3140,7 +3140,7 @@ struct bpf_prog_info {
 	__aligned_u64 map_ids;
 	char name[BPF_OBJ_NAME_LEN];
 	__u32 ifindex;
-	__u32 gpl_compatible:1;
+	__u32 gpl_compatible;
 	__u64 netns_dev;
 	__u64 netns_ino;
 	__u32 nr_jited_ksyms;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 63e0cf66f01a..fe73829b5b1c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3140,7 +3140,7 @@ struct bpf_prog_info {
 	__aligned_u64 map_ids;
 	char name[BPF_OBJ_NAME_LEN];
 	__u32 ifindex;
-	__u32 gpl_compatible:1;
+	__u32 gpl_compatible;
 	__u64 netns_dev;
 	__u64 netns_ino;
 	__u32 nr_jited_ksyms;
-- 
2.20.1

