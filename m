Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF85F3A137A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 13:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbhFILwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 07:52:37 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3813 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhFILwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 07:52:36 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0QKQ6Y0fzWtQk;
        Wed,  9 Jun 2021 19:45:46 +0800 (CST)
Received: from dggema761-chm.china.huawei.com (10.1.198.203) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 19:50:39 +0800
Received: from huawei.com (10.175.127.227) by dggema761-chm.china.huawei.com
 (10.1.198.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 19:50:38 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <jolsa@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <nathan@kernel.org>, <ndesaulniers@google.com>
CC:     <linux-perf-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>, <chengzhihao1@huawei.com>,
        <yukuai3@huawei.com>
Subject: [PATCH] perf llvm: Fix error return code in llvm__compile_bpf()
Date:   Wed, 9 Jun 2021 19:59:45 +0800
Message-ID: <20210609115945.2193194-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema761-chm.china.huawei.com (10.1.198.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: cb76371441d098 ("perf llvm: Allow passing options to llc ...")
Fixes: 5eab5a7ee032ac ("perf llvm: Display eBPF compiling command ...")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 tools/perf/util/llvm-utils.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/llvm-utils.c b/tools/perf/util/llvm-utils.c
index 3ceaf7ef3301..2de02639fb67 100644
--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -504,8 +504,9 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 			goto errout;
 		}
 
-		if (asprintf(&pipe_template, "%s -emit-llvm | %s -march=bpf %s -filetype=obj -o -",
-			      template, llc_path, opts) < 0) {
+		err = asprintf(&pipe_template, "%s -emit-llvm | %s -march=bpf %s -filetype=obj -o -",
+			       template, llc_path, opts);
+		if (err < 0) {
 			pr_err("ERROR:\tnot enough memory to setup command line\n");
 			goto errout;
 		}
@@ -524,7 +525,8 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 
 	pr_debug("llvm compiling command template: %s\n", template);
 
-	if (asprintf(&command_echo, "echo -n \"%s\"", template) < 0)
+	err = asprintf(&command_echo, "echo -n \"%s\"", template);
+	if (err < 0)
 		goto errout;
 
 	err = read_from_pipe(command_echo, (void **) &command_out, NULL);
-- 
2.31.1

