Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B48F4209C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437300AbfFLJVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 05:21:11 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43986 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436698AbfFLJVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 05:21:11 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C1E5B7232FB05951CF92;
        Wed, 12 Jun 2019 17:21:07 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 12 Jun 2019
 17:21:00 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <davem@davemloft.net>,
        <jakub.kicinski@netronome.com>, <jonathan.lemon@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <xdp-newbies@vger.kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH bpf-next] bpf: Fix build error without CONFIG_INET
Date:   Wed, 12 Jun 2019 17:18:47 +0800
Message-ID: <20190612091847.23708-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_INET is not set, building fails:

kernel/bpf/verifier.o: In function `check_mem_access':
verifier.c: undefined reference to `bpf_xdp_sock_is_valid_access'
kernel/bpf/verifier.o: In function `convert_ctx_accesses':
verifier.c: undefined reference to `bpf_xdp_sock_convert_ctx_access'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: fada7fdc83c0 ("bpf: Allow bpf_map_lookup_elem() on an xskmap")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/linux/bpf.h | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4118f3d..72ca1e7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -725,13 +725,6 @@ void __cpu_map_insert_ctx(struct bpf_map *map, u32 index);
 void __cpu_map_flush(struct bpf_map *map);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
-bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
-				  struct bpf_insn_access_aux *info);
-u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
-				    const struct bpf_insn *si,
-				    struct bpf_insn *insn_buf,
-				    struct bpf_prog *prog,
-				    u32 *target_size);
 
 /* Return map's numa specified by userspace */
 static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
@@ -1107,6 +1100,15 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 				    struct bpf_insn *insn_buf,
 				    struct bpf_prog *prog,
 				    u32 *target_size);
+
+bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
+				  struct bpf_insn_access_aux *info);
+
+u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
+				    const struct bpf_insn *si,
+				    struct bpf_insn *insn_buf,
+				    struct bpf_prog *prog,
+				    u32 *target_size);
 #else
 static inline bool bpf_tcp_sock_is_valid_access(int off, int size,
 						enum bpf_access_type type,
@@ -1123,6 +1125,21 @@ static inline u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 {
 	return 0;
 }
+static inline bool bpf_xdp_sock_is_valid_access(int off, int size,
+						enum bpf_access_type type,
+						struct bpf_insn_access_aux *info)
+{
+	return false;
+}
+
+static inline u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
+						  const struct bpf_insn *si,
+						  struct bpf_insn *insn_buf,
+						  struct bpf_prog *prog,
+						  u32 *target_size)
+{
+	return 0;
+}
 #endif /* CONFIG_INET */
 
 #endif /* _LINUX_BPF_H */
-- 
2.7.4


