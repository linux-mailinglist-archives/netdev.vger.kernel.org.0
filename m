Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C975B5E75
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiILQnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiILQnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:43:16 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6E527FF7;
        Mon, 12 Sep 2022 09:43:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=chentao.kernel@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VPYHjKD_1663000981;
Received: from VM20210331-5.tbsite.net(mailfrom:chentao.kernel@linux.alibaba.com fp:SMTPD_---0VPYHjKD_1663000981)
          by smtp.aliyun-inc.com;
          Tue, 13 Sep 2022 00:43:10 +0800
From:   Tao Chen <chentao.kernel@linux.alibaba.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tao Chen <chentao.kernel@linux.alibaba.com>
Subject: [PATCH v2] libbpf: Support raw btf placed in the default path
Date:   Tue, 13 Sep 2022 00:43:00 +0800
Message-Id: <3f59fb5a345d2e4f10e16fe9e35fbc4c03ecaa3e.1662999860.git.chentao.kernel@linux.alibaba.com>
X-Mailer: git-send-email 2.2.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now only elf btf can be placed in the default path(/boot), raw
btf should also can be there.

Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
---
v2->v1: Remove the locations[i].raw_btf check
---
 tools/lib/bpf/btf.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index bb1e06e..46ec244 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -4657,11 +4657,10 @@ struct btf *btf__load_vmlinux_btf(void)
 {
 	struct {
 		const char *path_fmt;
-		bool raw_btf;
 	} locations[] = {
 		/* try canonical vmlinux BTF through sysfs first */
-		{ "/sys/kernel/btf/vmlinux", true /* raw BTF */ },
-		/* fall back to trying to find vmlinux ELF on disk otherwise */
+		{ "/sys/kernel/btf/vmlinux" },
+		/* fall back to trying to find vmlinux on disk otherwise */
 		{ "/boot/vmlinux-%1$s" },
 		{ "/lib/modules/%1$s/vmlinux-%1$s" },
 		{ "/lib/modules/%1$s/build/vmlinux" },
@@ -4683,10 +4682,7 @@ struct btf *btf__load_vmlinux_btf(void)
 		if (access(path, R_OK))
 			continue;
 
-		if (locations[i].raw_btf)
-			btf = btf__parse_raw(path);
-		else
-			btf = btf__parse_elf(path, NULL);
+		btf = btf__parse(path, NULL);
 		err = libbpf_get_error(btf);
 		pr_debug("loading kernel BTF '%s': %d\n", path, err);
 		if (err)
-- 
2.2.1

