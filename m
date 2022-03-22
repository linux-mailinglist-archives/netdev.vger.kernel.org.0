Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3A64E38CE
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 07:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbiCVGXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 02:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbiCVGX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 02:23:29 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF51D1138;
        Mon, 21 Mar 2022 23:22:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0V7uWHBg_1647930110;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V7uWHBg_1647930110)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Mar 2022 14:21:57 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     rostedt@goodmis.org
Cc:     mingo@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] bpf: Use swap() instead of open coding it
Date:   Tue, 22 Mar 2022 14:21:49 +0800
Message-Id: <20220322062149.109180-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean the following coccicheck warning:

./kernel/trace/bpf_trace.c:2263:34-35: WARNING opportunity for swap().
./kernel/trace/bpf_trace.c:2264:40-41: WARNING opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 kernel/trace/bpf_trace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 0009104dca82..36e0f459d152 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2253,15 +2253,13 @@ static void bpf_kprobe_multi_cookie_swap(void *a, void *b, int size, const void
 	const struct bpf_kprobe_multi_link *link = priv;
 	unsigned long *addr_a = a, *addr_b = b;
 	u64 *cookie_a, *cookie_b;
-	unsigned long tmp1;
-	u64 tmp2;
 
 	cookie_a = link->cookies + (addr_a - link->addrs);
 	cookie_b = link->cookies + (addr_b - link->addrs);
 
 	/* swap addr_a/addr_b and cookie_a/cookie_b values */
-	tmp1 = *addr_a; *addr_a = *addr_b; *addr_b = tmp1;
-	tmp2 = *cookie_a; *cookie_a = *cookie_b; *cookie_b = tmp2;
+	swap(*addr_a, *addr_b);
+	swap(*cookie_a, *cookie_b);
 }
 
 static int __bpf_kprobe_multi_cookie_cmp(const void *a, const void *b)
-- 
2.20.1.7.g153144c

