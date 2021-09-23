Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8EE415664
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbhIWDlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239331AbhIWDke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6EB96113E;
        Thu, 23 Sep 2021 03:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368344;
        bh=e0KvK0LHn2MpqDG7+v7pq8V26y/44bSO2X5nywi2CUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQNGEp5z17AN88cM+fZeaOOUenBw8akhf4nEG6qgatkAmRpNyzAP1FaIBPA7XUfRl
         deisbUiLQp9SA7hYFqcwFboG+eRJ2UyegaKrY9uWYc8kB4EyesmYTQoxj6ktCAso2A
         kyLvGYEzUuM7st9MhKHZE6VdJvedO1A2I37PSlMLboyRTPcYYvKZ0u4u9HaWXz+AKk
         aiv36cT1KW6mMuSyaf0NsOKJzbPItL57dVN5/TyfVFrhjJzrghI851QD/akc3Lv/Yf
         37oa37inhgu7FHM88u7H89+RXEe+vPnnbMwJPfMsNbfKkAlqInuv243Po8kNix0fQ6
         RTxfLB8+R0K4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>,
        syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/19] bpf: Add oversize check before call kvcalloc()
Date:   Wed, 22 Sep 2021 23:38:40 -0400
Message-Id: <20210923033853.1421193-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 0e6491b559704da720f6da09dd0a52c4df44c514 ]

Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls") add the
oversize check. When the allocation is larger than what kmalloc() supports,
the following warning triggered:

WARNING: CPU: 0 PID: 8408 at mm/util.c:597 kvmalloc_node+0x108/0x110 mm/util.c:597
Modules linked in:
CPU: 0 PID: 8408 Comm: syz-executor221 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x108/0x110 mm/util.c:597
Call Trace:
 kvmalloc include/linux/mm.h:806 [inline]
 kvmalloc_array include/linux/mm.h:824 [inline]
 kvcalloc include/linux/mm.h:829 [inline]
 check_btf_line kernel/bpf/verifier.c:9925 [inline]
 check_btf_info kernel/bpf/verifier.c:10049 [inline]
 bpf_check+0xd634/0x150d0 kernel/bpf/verifier.c:13759
 bpf_prog_load kernel/bpf/syscall.c:2301 [inline]
 __sys_bpf+0x11181/0x126e0 kernel/bpf/syscall.c:4587
 __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
 __x64_sys_bpf+0x78/0x90 kernel/bpf/syscall.c:4689
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210911005557.45518-1-cuibixuan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 60383b28549b..9c5fa5c52903 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6839,6 +6839,8 @@ static int check_btf_line(struct bpf_verifier_env *env,
 	nr_linfo = attr->line_info_cnt;
 	if (!nr_linfo)
 		return 0;
+	if (nr_linfo > INT_MAX / sizeof(struct bpf_line_info))
+		return -EINVAL;
 
 	rec_size = attr->line_info_rec_size;
 	if (rec_size < MIN_BPF_LINEINFO_SIZE ||
-- 
2.30.2

