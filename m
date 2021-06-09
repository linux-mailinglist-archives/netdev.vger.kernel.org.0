Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696983A1376
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 13:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbhFILwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 07:52:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8113 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhFILwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 07:52:23 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0QMS3s2YzYsXR;
        Wed,  9 Jun 2021 19:47:32 +0800 (CST)
Received: from dggema761-chm.china.huawei.com (10.1.198.203) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 19:50:22 +0800
Received: from huawei.com (10.175.127.227) by dggema761-chm.china.huawei.com
 (10.1.198.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 19:50:21 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <quentin@isovalent.com>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chengzhihao1@huawei.com>,
        <yukuai3@huawei.com>
Subject: [PATCH] tools/bpftool: Fix error return code in do_batch()
Date:   Wed, 9 Jun 2021 19:59:16 +0800
Message-ID: <20210609115916.2186872-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema761-chm.china.huawei.com (10.1.198.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 668da745af3c2 ("tools: bpftool: add support for quotations ...")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 tools/bpf/bpftool/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 7f2817d97079..3ddfd4843738 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -341,8 +341,10 @@ static int do_batch(int argc, char **argv)
 		n_argc = make_args(buf, n_argv, BATCH_ARG_NB_MAX, lines);
 		if (!n_argc)
 			continue;
-		if (n_argc < 0)
+		if (n_argc < 0) {
+			err = n_argc;
 			goto err_close;
+		}
 
 		if (json_output) {
 			jsonw_start_object(json_wtr);
-- 
2.31.1

