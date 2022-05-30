Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205285377E0
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbiE3I6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbiE3I6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:58:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B9E7220E;
        Mon, 30 May 2022 01:58:33 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LBTl26c7JzQkPB;
        Mon, 30 May 2022 16:55:26 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 16:58:31 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 16:58:31 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
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
        Albert Ou <aou@eecs.berkeley.edu>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next v3 1/6] bpf: Unify data extension operation of jited_ksyms and jited_linfo
Date:   Mon, 30 May 2022 17:28:10 +0800
Message-ID: <20220530092815.1112406-2-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220530092815.1112406-1-pulehui@huawei.com>
References: <20220530092815.1112406-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 kernel/bpf/syscall.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e0aead17dff4..2929a4aab82c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4095,14 +4095,15 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 		info.nr_jited_line_info = 0;
 	if (info.nr_jited_line_info && ulen) {
 		if (bpf_dump_raw_ok(file->f_cred)) {
+			unsigned long ladd;
 			__u64 __user *user_linfo;
 			u32 i;
 
 			user_linfo = u64_to_user_ptr(info.jited_line_info);
 			ulen = min_t(u32, info.nr_jited_line_info, ulen);
 			for (i = 0; i < ulen; i++) {
-				if (put_user((__u64)(long)prog->aux->jited_linfo[i],
-					     &user_linfo[i]))
+				ladd = (unsigned long)prog->aux->jited_linfo[i];
+				if (put_user((__u64)ladd, &user_linfo[i]))
 					return -EFAULT;
 			}
 		} else {
-- 
2.25.1

