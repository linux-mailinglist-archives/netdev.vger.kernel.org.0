Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCE551401A
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353636AbiD2BR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351100AbiD2BRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:17:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DF6BCB40;
        Thu, 28 Apr 2022 18:14:08 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KqDyf1fFXzhYlm;
        Fri, 29 Apr 2022 09:13:46 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Apr 2022 09:14:07 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Apr 2022 09:14:06 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pu Lehui <pulehui@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH bpf-next v2 1/2] bpf: Unify data extension operation of jited_ksyms and jited_linfo
Date:   Fri, 29 Apr 2022 09:42:39 +0800
Message-ID: <20220429014240.3434866-2-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429014240.3434866-1-pulehui@huawei.com>
References: <20220429014240.3434866-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found that 32-bit environment can not print bpf line info due
to data inconsistency between jited_ksyms[0] and jited_linfo[0].

For example:
jited_kyms[0] = 0xb800067c, jited_linfo[0] = 0xffffffffb800067c

We know that both of them store bpf func address, but due to the
different data extension operations when extended to u64, they may
not be the same. We need to unify the data extension operations of
them.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 kernel/bpf/syscall.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e9e3e49c0eb7..18137ea5190d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3871,13 +3871,16 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 		info.nr_jited_line_info = 0;
 	if (info.nr_jited_line_info && ulen) {
 		if (bpf_dump_raw_ok(file->f_cred)) {
+			unsigned long jited_linfo_addr;
 			__u64 __user *user_linfo;
 			u32 i;
 
 			user_linfo = u64_to_user_ptr(info.jited_line_info);
 			ulen = min_t(u32, info.nr_jited_line_info, ulen);
 			for (i = 0; i < ulen; i++) {
-				if (put_user((__u64)(long)prog->aux->jited_linfo[i],
+				jited_linfo_addr = (unsigned long)
+					prog->aux->jited_linfo[i];
+				if (put_user((__u64) jited_linfo_addr,
 					     &user_linfo[i]))
 					return -EFAULT;
 			}
-- 
2.25.1

