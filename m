Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D151752CBEF
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 08:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiESGbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 02:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiESGbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 02:31:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F68E1EEDA;
        Wed, 18 May 2022 23:31:12 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L3g235St2zgYHN;
        Thu, 19 May 2022 14:29:47 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 19 May 2022 14:31:10 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] stcp: Use memset_after() to zero sctp_stream_out_ext
Date:   Thu, 19 May 2022 14:29:32 +0800
Message-ID: <20220519062932.249926-1-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use memset_after() helper to simplify the code, there is no functional
change in this patch.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 net/sctp/stream_sched.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 99e5f69fbb74..518b1b9bf89d 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -146,14 +146,11 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 
 		/* Give the next scheduler a clean slate. */
 		for (i = 0; i < asoc->stream.outcnt; i++) {
-			void *p = SCTP_SO(&asoc->stream, i)->ext;
+			struct sctp_stream_out_ext *ext = SCTP_SO(&asoc->stream, i)->ext;
 
-			if (!p)
+			if (!ext)
 				continue;
-
-			p += offsetofend(struct sctp_stream_out_ext, outq);
-			memset(p, 0, sizeof(struct sctp_stream_out_ext) -
-				     offsetofend(struct sctp_stream_out_ext, outq));
+			memset_after(ext, 0, outq);
 		}
 	}
 
-- 
2.17.1

