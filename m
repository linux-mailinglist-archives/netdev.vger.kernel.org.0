Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1A5D0AD
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfGBN3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:29:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43714 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725922AbfGBN3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 09:29:30 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AEDEFF87C39AEE16812D;
        Tue,  2 Jul 2019 21:29:25 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 2 Jul 2019
 21:29:17 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <sdf@google.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH bpf-next] bpf: cgroup: Fix build error without CONFIG_NET
Date:   Tue, 2 Jul 2019 21:29:13 +0800
Message-ID: <20190702132913.26060-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NET is not set, gcc building fails:

kernel/bpf/cgroup.o: In function `cg_sockopt_func_proto':
cgroup.c:(.text+0x237e): undefined reference to `bpf_sk_storage_get_proto'
cgroup.c:(.text+0x2394): undefined reference to `bpf_sk_storage_delete_proto'
kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_getsockopt':
(.text+0x2a1f): undefined reference to `lock_sock_nested'
(.text+0x2ca2): undefined reference to `release_sock'
kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_setsockopt':
(.text+0x3006): undefined reference to `lock_sock_nested'
(.text+0x32bb): undefined reference to `release_sock'

Add CONFIG_NET dependency to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index e2e51b5..341cf2a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -998,6 +998,7 @@ config CGROUP_PERF
 config CGROUP_BPF
 	bool "Support for eBPF programs attached to cgroups"
 	depends on BPF_SYSCALL
+	depends on NET
 	select SOCK_CGROUP_DATA
 	help
 	  Allow attaching eBPF programs to a cgroup using the bpf(2)
-- 
2.7.4


