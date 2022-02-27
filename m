Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704A24C5B69
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 14:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiB0Nvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 08:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiB0Nvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 08:51:49 -0500
X-Greylist: delayed 606 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Feb 2022 05:51:12 PST
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E6C2DD2;
        Sun, 27 Feb 2022 05:51:12 -0800 (PST)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 21RDeA2M026055-21RDeA2P026055
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Sun, 27 Feb 2022 21:40:15 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: cgroup: remove WARN_ON at bpf_cgroup_link_release
Date:   Sun, 27 Feb 2022 21:40:08 +0800
Message-Id: <20220227134009.1298488-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

When syzkaller injects fault into memory allocation at
bpf_prog_array_alloc, the kernel encounters a memory failure and
returns non-zero, thus leading to one WARN_ON at
bpf_cgroup_link_release. The stack trace is as follows:

 __kmalloc+0x7e/0x3d0
 bpf_prog_array_alloc+0x4f/0x60
 compute_effective_progs+0x132/0x580
 ? __sanitizer_cov_trace_pc+0x1a/0x40
 update_effective_progs+0x5e/0x260
 __cgroup_bpf_detach+0x293/0x760
 bpf_cgroup_link_release+0xad/0x400
 bpf_link_free+0xca/0x190
 bpf_link_put+0x161/0x1b0
 bpf_link_release+0x33/0x40
 __fput+0x286/0x9f0

Fix this by removing the WARN_ON for __cgroup_bpf_detach.

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 kernel/bpf/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 514b4681a90a..fdbdcee6c9fa 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -896,8 +896,8 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
 		return;
 	}
 
-	WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
-				    cg_link->type));
+	__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
+				    cg_link->type);
 
 	cg = cg_link->cgroup;
 	cg_link->cgroup = NULL;
-- 
2.25.1

