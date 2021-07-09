Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0303C1D9A
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhGICvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:51:09 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:49529 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231156AbhGICvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 22:51:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UfA5fvT_1625798894;
Received: from localhost(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0UfA5fvT_1625798894)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 09 Jul 2021 10:48:23 +0800
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Shuyi Cheng <chengshuyi@linux.alibaba.com>
Subject: [PATCH bpf-next v3 2/2] libbpf: Fix the possible memory leak caused by obj->kconfig
Date:   Fri,  9 Jul 2021 10:47:53 +0800
Message-Id: <1625798873-55442-3-git-send-email-chengshuyi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com>
References: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When obj->kconfig is NULL, ERR_PTR(-ENOMEM) should not be returned
directly, err=-ENOMEM should be set, and then goto out.

Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
---
 tools/lib/bpf/libbpf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6702b7f..5e550e7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7626,8 +7626,10 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 	kconfig = OPTS_GET(opts, kconfig, NULL);
 	if (kconfig) {
 		obj->kconfig = strdup(kconfig);
-		if (!obj->kconfig)
-			return ERR_PTR(-ENOMEM);
+		if (!obj->kconfig) {
+			err = -ENOMEM;
+			goto out;
+		}
 	}
 
 	err = bpf_object__elf_init(obj);
-- 
1.8.3.1

