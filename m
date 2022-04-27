Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C00B5117B3
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiD0Lxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiD0Lxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:53:33 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74DE13BBCC;
        Wed, 27 Apr 2022 04:50:21 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KpH4q0CkhzCrmM;
        Wed, 27 Apr 2022 19:45:47 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 27 Apr
 2022 19:50:19 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH bpf-next] bpf, sockmap: Call skb_linearize only when required in sk_psock_skb_ingress_enqueue
Date:   Wed, 27 Apr 2022 19:51:50 +0800
Message-ID: <20220427115150.210213-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb_to_sgvec fails only when the number of frag_list and frags exceeds
MAX_MSG_FRAGS. Therefore, we can call skb_linearize only when the
conversion fails.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 net/core/skmsg.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cc381165ea08..22b983ade0e7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -524,16 +524,20 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 {
 	int num_sge, copied;
 
-	/* skb linearize may fail with ENOMEM, but lets simply try again
-	 * later if this happens. Under memory pressure we don't want to
-	 * drop the skb. We need to linearize the skb so that the mapping
-	 * in skb_to_sgvec can not error.
-	 */
-	if (skb_linearize(skb))
-		return -EAGAIN;
 	num_sge = skb_to_sgvec(skb, msg->sg.data, off, len);
-	if (unlikely(num_sge < 0))
-		return num_sge;
+	if (num_sge < 0) {
+		/* skb linearize may fail with ENOMEM, but lets simply try again
+		 * later if this happens. Under memory pressure we don't want to
+		 * drop the skb. We need to linearize the skb so that the mapping
+		 * in skb_to_sgvec can not error.
+		 */
+		if (skb_linearize(skb))
+			return -EAGAIN;
+
+		num_sge = skb_to_sgvec(skb, msg->sg.data, off, len);
+		if (unlikely(num_sge < 0))
+			return num_sge;
+	}
 
 	copied = len;
 	msg->sg.start = 0;
-- 
2.17.1

