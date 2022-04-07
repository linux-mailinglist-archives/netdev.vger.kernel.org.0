Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C264F7228
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 04:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbiDGCkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 22:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbiDGCkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 22:40:21 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5218ADE903;
        Wed,  6 Apr 2022 19:38:21 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 7 Apr
 2022 10:38:20 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Thu, 7 Apr
 2022 10:38:19 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Haowen Bai <baihaowen@meizu.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] libbpf: potential NULL dereference in usdt_manager_attach_usdt()
Date:   Thu, 7 Apr 2022 10:38:17 +0800
Message-ID: <1649299098-2069-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

link could be null but still dereference bpf_link__destroy(&link->link)
and it will lead to a null pointer access.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 tools/lib/bpf/usdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 1bce2eab5e89..b02ebc4ba57c 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -996,7 +996,7 @@ struct bpf_link *usdt_manager_attach_usdt(struct usdt_manager *man, const struct
 	link = calloc(1, sizeof(*link));
 	if (!link) {
 		err = -ENOMEM;
-		goto err_out;
+		goto link_err;
 	}
 
 	link->usdt_man = man;
@@ -1072,7 +1072,7 @@ struct bpf_link *usdt_manager_attach_usdt(struct usdt_manager *man, const struct
 
 err_out:
 	bpf_link__destroy(&link->link);
-
+link_err:
 	free(targets);
 	hashmap__free(specs_hash);
 	if (elf)
-- 
2.7.4

