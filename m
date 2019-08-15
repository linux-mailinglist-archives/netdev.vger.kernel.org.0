Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B8D8EE13
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732931AbfHOOU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:20:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43564 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732815AbfHOOU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 10:20:59 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1ECB17154EB0F9A7E1E7;
        Thu, 15 Aug 2019 22:20:32 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Thu, 15 Aug 2019 22:20:22 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] btf: fix return value check in btf_vmlinux_init()
Date:   Thu, 15 Aug 2019 14:24:32 +0000
Message-ID: <20190815142432.101401-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
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
---
 kernel/bpf/sysfs_btf.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
index 4659349fc795..be5557deb958 100644
--- a/kernel/bpf/sysfs_btf.c
+++ b/kernel/bpf/sysfs_btf.c
@@ -30,16 +30,13 @@ static struct kobject *btf_kobj;
 
 static int __init btf_vmlinux_init(void)
 {
-	int err;
-
 	if (!_binary__btf_vmlinux_bin_start)
 		return 0;
 
 	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
-	if (IS_ERR(btf_kobj)) {
-		err = PTR_ERR(btf_kobj);
+	if (!btf_kobj) {
 		btf_kobj = NULL;
-		return err;
+		return -ENOMEM;
 	}
 
 	bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -



