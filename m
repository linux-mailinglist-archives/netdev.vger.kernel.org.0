Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD701096FD
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfKYXlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:41:09 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2875 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKYXlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:41:08 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddc66970001>; Mon, 25 Nov 2019 15:41:11 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 Nov 2019 15:41:07 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 Nov 2019 15:41:07 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 23:41:07 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 25 Nov 2019 23:41:07 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ddc66920003>; Mon, 25 Nov 2019 15:41:06 -0800
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH] bpf: fix a no-mmu build failure by providing a stub allocator
Date:   Mon, 25 Nov 2019 15:41:03 -0800
Message-ID: <20191125234103.1699950-2-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191125234103.1699950-1-jhubbard@nvidia.com>
References: <20191125234103.1699950-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574725271; bh=ItfxI3SukozgOar1TIJJylL1lPIEpmSk6jTqYlDCsZk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=Cs9WEX27uK0N4VcEYIkXiSBDA6hmo4F10v1wLtg1J6+zbzvxborzChuEepH54npgq
         9IciI4WgskIYaqBZlxv04ol708B/ePBEw0gF3TSAVsBgECQlSMpS2gUgf05gXipznY
         3aV6jj7DjMFKdNI3sQqbw7e3221mlZuDxy1f1t0+r4n/ZHB2d1FDLTqD/m6YHE+zE1
         I25Hr+zLIbQ3z+mmZjRqb80Ci2IcfUUc3ImzIoFSdc9bzAqdMN+nNHL+uxunsu5+Ah
         i+dxGw22LGjJfWbFZTnSNdIRYn6GrknQF91B6wV/lKTfGqzl8Be+lTW/WzSomfCwne
         bqwoj9JH1TCqg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
added code that calls vmalloc_user_node_flags() and therefore requires
mm/vmalloc.c. However, that file is not built for the !CONFIG_MMU case.
This leads to a build failure when using ARM with the config provided
by at least one particular kbuild test robot report [1].

[1] https://lore/kernel.org/r/201911251639.UWS3hE3Y%lkp@intel.com

Fix the build by providing a stub function for __bpf_map_area_alloc().

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Reported-by: kbuild test robot <lkp@intel.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Song Liu <songliubraving@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 kernel/bpf/syscall.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e3461ec59570..cb3e13ee4123 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -128,6 +128,7 @@ static struct bpf_map *find_and_alloc_map(union bpf_att=
r *attr)
 	return map;
 }
=20
+#ifdef CONFIG_MMU
 static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
 {
 	/* We really just want to fail instead of triggering OOM killer
@@ -162,6 +163,12 @@ static void *__bpf_map_area_alloc(u64 size, int numa_n=
ode, bool mmapable)
 					   GFP_KERNEL | __GFP_RETRY_MAYFAIL |
 					   flags, __builtin_return_address(0));
 }
+#else /* CONFIG_MMU */
+static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
+{
+	return NULL;
+}
+#endif /* !CONFIG_MMU */
=20
 void *bpf_map_area_alloc(u64 size, int numa_node)
 {
--=20
2.24.0

