Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F142202D2
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgGODOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 23:14:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43776 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726624AbgGODOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 23:14:35 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 236DFE6E48ADD26CEA9A;
        Wed, 15 Jul 2020 11:14:33 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Jul 2020
 11:14:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] tools/bpftool: Fix error return code in do_skeleton()
Date:   Wed, 15 Jul 2020 11:13:53 +0800
Message-ID: <20200715031353.14692-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error return code should be PTR_ERR(obj) other than
PTR_ERR(NULL).

Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside skeleton")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 tools/bpf/bpftool/gen.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 10de76b296ba..35f62273cdbd 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -305,8 +305,9 @@ static int do_skeleton(int argc, char **argv)
 	opts.object_name = obj_name;
 	obj = bpf_object__open_mem(obj_data, file_sz, &opts);
 	if (IS_ERR(obj)) {
+		err = PTR_ERR(obj);
+		p_err("failed to open BPF object file: %ld", err);
 		obj = NULL;
-		p_err("failed to open BPF object file: %ld", PTR_ERR(obj));
 		goto out;
 	}
 
-- 
2.17.1


