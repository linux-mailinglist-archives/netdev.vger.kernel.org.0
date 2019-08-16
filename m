Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F8B8F919
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 04:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfHPCgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 22:36:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50418 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726652AbfHPCgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 22:36:46 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DEC0FDF054EDA62492E1;
        Fri, 16 Aug 2019 10:36:41 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 16 Aug 2019 10:36:35 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next v2] btf: fix return value check in btf_vmlinux_init()
Date:   Fri, 16 Aug 2019 02:40:44 +0000
Message-ID: <20190816024044.139761-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190815142432.101401-1-weiyongjun1@huawei.com>
References: <20190815142432.101401-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of error, the function kobject_create_and_add() returns NULL
pointer not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/sysfs_btf.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
index 4659349fc795..7ae5dddd1fe6 100644
--- a/kernel/bpf/sysfs_btf.c
+++ b/kernel/bpf/sysfs_btf.c
@@ -30,17 +30,12 @@ static struct kobject *btf_kobj;
 
 static int __init btf_vmlinux_init(void)
 {
-	int err;
-
 	if (!_binary__btf_vmlinux_bin_start)
 		return 0;
 
 	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
-	if (IS_ERR(btf_kobj)) {
-		err = PTR_ERR(btf_kobj);
-		btf_kobj = NULL;
-		return err;
-	}
+	if (!btf_kobj)
+		return -ENOMEM;
 
 	bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -
 				    _binary__btf_vmlinux_bin_start;



