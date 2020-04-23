Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA01B5327
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgDWDbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:31:52 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37980 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbgDWDbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 23:31:52 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2CC5AF169594084096EF;
        Thu, 23 Apr 2020 11:31:49 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Apr 2020 11:31:47 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <dan.carpenter@oracle.com>,
        <andrii.nakryiko@gmail.com>
Subject: [PATCH bpf-next v2 1/2] bpf: Change error code when ops is NULL
Date:   Thu, 23 Apr 2020 11:33:13 +0800
Message-ID: <20200423033314.49205-2-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200423033314.49205-1-maowenan@huawei.com>
References: <20200422093329.GI2659@kadam>
 <20200423033314.49205-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is one error printed when use BPF_MAP_TYPE_SOCKMAP to create map:
libbpf: failed to create map (name: 'sock_map'): Invalid argument(-22)

This is because CONFIG_BPF_STREAM_PARSER is not set, and
bpf_map_types[type] return invalid ops. It is not clear to show the
cause of config missing with return code -EINVAL, so add pr_warn() and
change error code to describe the reason.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 kernel/bpf/syscall.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d85f37239540..7686778457c7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -112,9 +112,10 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
 		return ERR_PTR(-EINVAL);
 	type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
 	ops = bpf_map_types[type];
-	if (!ops)
-		return ERR_PTR(-EINVAL);
-
+	if (!ops) {
+		pr_warn("map type %d not supported or kernel config not opened\n", type);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
 	if (ops->map_alloc_check) {
 		err = ops->map_alloc_check(attr);
 		if (err)
-- 
2.20.1

