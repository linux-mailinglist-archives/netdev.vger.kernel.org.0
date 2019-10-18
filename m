Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BC6DC087
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 11:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442275AbfJRJGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 05:06:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53488 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727741AbfJRJGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 05:06:07 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7138B24653149FBE9F7C;
        Fri, 18 Oct 2019 17:06:04 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 17:05:54 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <rostedt@goodmis.org>, <mingo@redhat.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <andriin@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH bpf-next] bpf: Fix build error without CONFIG_NET
Date:   Fri, 18 Oct 2019 17:03:44 +0800
Message-ID: <20191018090344.26936-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NET is n, building fails:

kernel/trace/bpf_trace.o: In function `raw_tp_prog_func_proto':
bpf_trace.c:(.text+0x1a34): undefined reference to `bpf_skb_output_proto'

Wrap it into a #ifdef to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: a7658e1a4164 ("bpf: Check types of arguments passed into helpers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 kernel/trace/bpf_trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 52f7e9d..c324089 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1055,8 +1055,10 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	switch (func_id) {
 	case BPF_FUNC_perf_event_output:
 		return &bpf_perf_event_output_proto_raw_tp;
+#ifdef CONFIG_NET
 	case BPF_FUNC_skb_output:
 		return &bpf_skb_output_proto;
+#endif
 	case BPF_FUNC_get_stackid:
 		return &bpf_get_stackid_proto_raw_tp;
 	case BPF_FUNC_get_stack:
-- 
2.7.4


