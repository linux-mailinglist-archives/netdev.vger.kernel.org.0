Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C55E576DD2
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 14:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiGPMUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 08:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiGPMUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 08:20:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA77E1AF35;
        Sat, 16 Jul 2022 05:20:49 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LlS2P5CQpzlVmJ;
        Sat, 16 Jul 2022 20:19:09 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 20:20:47 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 20:20:47 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next 5/5] selftests/bpf: Remove the casting about jited_ksyms and jited_linfo
Date:   Sat, 16 Jul 2022 20:51:08 +0800
Message-ID: <20220716125108.1011206-6-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220716125108.1011206-1-pulehui@huawei.com>
References: <20220716125108.1011206-1-pulehui@huawei.com>
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

We have unified data extension operation of jited_ksyms and jited_linfo
into zero extension, so there's no need to cast u64 memory address to
long data type.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 tools/testing/selftests/bpf/prog_tests/btf.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index e852a9df779d..db10fa1745d1 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -6613,8 +6613,9 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 	}
 
 	if (CHECK(jited_linfo[0] != jited_ksyms[0],
-		  "jited_linfo[0]:%lx != jited_ksyms[0]:%lx",
-		  (long)(jited_linfo[0]), (long)(jited_ksyms[0]))) {
+		  "jited_linfo[0]:%llx != jited_ksyms[0]:%llx",
+		  (unsigned long long)(jited_linfo[0]),
+		  (unsigned long long)(jited_ksyms[0]))) {
 		err = -1;
 		goto done;
 	}
@@ -6632,16 +6633,17 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 		}
 
 		if (CHECK(jited_linfo[i] <= jited_linfo[i - 1],
-			  "jited_linfo[%u]:%lx <= jited_linfo[%u]:%lx",
-			  i, (long)jited_linfo[i],
-			  i - 1, (long)(jited_linfo[i - 1]))) {
+			  "jited_linfo[%u]:%llx <= jited_linfo[%u]:%llx",
+			  i, (unsigned long long)jited_linfo[i],
+			  i - 1, (unsigned long long)(jited_linfo[i - 1]))) {
 			err = -1;
 			goto done;
 		}
 
 		if (CHECK(jited_linfo[i] - cur_func_ksyms > cur_func_len,
-			  "jited_linfo[%u]:%lx - %lx > %u",
-			  i, (long)jited_linfo[i], (long)cur_func_ksyms,
+			  "jited_linfo[%u]:%llx - %llx > %u",
+			  i, (unsigned long long)jited_linfo[i],
+			  (unsigned long long)cur_func_ksyms,
 			  cur_func_len)) {
 			err = -1;
 			goto done;
-- 
2.25.1

