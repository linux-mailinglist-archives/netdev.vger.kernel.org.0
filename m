Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3528A02A
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 13:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgJJLYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 07:24:17 -0400
Received: from smtp.h3c.com ([60.191.123.50]:52168 "EHLO h3cspam02-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbgJJKWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 06:22:36 -0400
Received: from h3cspam02-ex.h3c.com (localhost [127.0.0.2] (may be forged))
        by h3cspam02-ex.h3c.com with ESMTP id 09A8wqlb054679
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 16:58:52 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([10.8.0.66])
        by h3cspam02-ex.h3c.com with ESMTPS id 09A8s6nc045991
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 10 Oct 2020 16:54:06 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from localhost.localdomain (10.99.212.201) by
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 10 Oct 2020 16:54:09 +0800
From:   Xianting Tian <tian.xianting@h3c.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Xianting Tian <tian.xianting@h3c.com>
Subject: [PATCH] bpf: Avoid allocing memory on memoryless numa node
Date:   Sat, 10 Oct 2020 16:44:17 +0800
Message-ID: <20201010084417.5400-1-tian.xianting@h3c.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.99.212.201]
X-ClientProxiedBy: BJSMTP02-EX.srv.huawei-3com.com (10.63.20.133) To
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66)
X-DNSRBL: 
X-MAIL: h3cspam02-ex.h3c.com 09A8s6nc045991
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In architecture like powerpc, we can have cpus without any local memory
attached to it. In such cases the node does not have real memory.

Use local_memory_node(), which is guaranteed to have memory.
local_memory_node is a noop in other architectures that does not support
memoryless nodes.

Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
---
 kernel/bpf/cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 6386b7bb9..2c885c00a 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -423,7 +423,7 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
 	struct xdp_bulk_queue *bq;
 
 	/* Have map->numa_node, but choose node of redirect target CPU */
-	numa = cpu_to_node(cpu);
+	numa = local_memory_node(cpu_to_node(cpu));
 
 	rcpu = kzalloc_node(sizeof(*rcpu), gfp, numa);
 	if (!rcpu)
-- 
2.17.1

