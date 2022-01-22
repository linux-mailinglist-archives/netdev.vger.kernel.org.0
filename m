Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502BB496B8A
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 10:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiAVJmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 04:42:17 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:16731 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiAVJmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 04:42:16 -0500
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jgrlj06jlzZcDl;
        Sat, 22 Jan 2022 17:38:25 +0800 (CST)
Received: from k03.huawei.com (10.67.174.111) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 22 Jan 2022 17:42:14 +0800
From:   He Fengqing <hefengqing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>
CC:     <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [bpf-next] bpf: Fix possible race in inc_misses_counter
Date:   Sat, 22 Jan 2022 10:29:36 +0000
Message-ID: <20220122102936.1219518-1-hefengqing@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems inc_misses_counter() suffers from same issue fixed in
the commit d979617aa84d ("bpf: Fixes possible race in update_prog_stats()
for 32bit arches"):
As it can run while interrupts are enabled, it could
be re-entered and the u64_stats syncp could be mangled.

Fixes: 9ed9e9ba2337 ("bpf: Count the number of times recursion was prevented")
Signed-off-by: He Fengqing <hefengqing@huawei.com>
---
 kernel/bpf/trampoline.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 4b6974a195c1..5e7edf913060 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -550,11 +550,12 @@ static __always_inline u64 notrace bpf_prog_start_time(void)
 static void notrace inc_misses_counter(struct bpf_prog *prog)
 {
 	struct bpf_prog_stats *stats;
+	unsigned int flags;
 
 	stats = this_cpu_ptr(prog->stats);
-	u64_stats_update_begin(&stats->syncp);
+	flags = u64_stats_update_begin_irqsave(&stats->syncp);
 	u64_stats_inc(&stats->misses);
-	u64_stats_update_end(&stats->syncp);
+	u64_stats_update_end_irqrestore(&stats->syncp, flags);
 }
 
 /* The logic is similar to bpf_prog_run(), but with an explicit
-- 
2.25.1

