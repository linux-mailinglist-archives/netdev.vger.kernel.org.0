Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247C4223B65
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgGQMbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 08:31:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44396 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726090AbgGQMbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 08:31:40 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E883FA2CBF099523156E;
        Fri, 17 Jul 2020 20:31:37 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 20:31:31 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <quentin@isovalent.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] tools/bpftool: Fix error handing in do_skeleton()
Date:   Fri, 17 Jul 2020 20:30:59 +0800
Message-ID: <20200717123059.29624-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200715031353.14692-1-yuehaibing@huawei.com>
References: <20200715031353.14692-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix pass 0 to PTR_ERR, also dump more err info using
libbpf_strerror.

Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside skeleton")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
---
v2: use libbpf_strerror
---
 tools/bpf/bpftool/gen.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index b59d26e89367..8a4c2b3b0cd6 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -302,8 +302,11 @@ static int do_skeleton(int argc, char **argv)
 	opts.object_name = obj_name;
 	obj = bpf_object__open_mem(obj_data, file_sz, &opts);
 	if (IS_ERR(obj)) {
+		char err_buf[256];
+
+		libbpf_strerror(PTR_ERR(obj), err_buf, sizeof(err_buf));
+		p_err("failed to open BPF object file: %s", err_buf);
 		obj = NULL;
-		p_err("failed to open BPF object file: %ld", PTR_ERR(obj));
 		goto out;
 	}
 
-- 
2.17.1


