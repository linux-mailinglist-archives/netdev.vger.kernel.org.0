Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE954D9B58
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 13:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348368AbiCOMhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 08:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbiCOMhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 08:37:08 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C1B53B4A;
        Tue, 15 Mar 2022 05:35:56 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KHt864HwHz9sYl;
        Tue, 15 Mar 2022 20:32:06 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 15 Mar
 2022 20:35:53 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sdf@google.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH bpf-next] net: Use skb->len to check the validity of the parameters in bpf_skb_load_bytes
Date:   Tue, 15 Mar 2022 20:39:16 +0800
Message-ID: <20220315123916.110409-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The data length of skb frags + frag_list may be greater than 0xffff,
so here use skb->len to check the validity of the parameters.

And modify bpf_flow_dissector_load_bytes and bpf_skb_load_bytes_relative
in the same way.

Fixes: 05c74e5e53f6 ("bpf: add bpf_skb_load_bytes helper")
Fixes: 4e1ec56cdc59 ("bpf: add skb_load_bytes_relative helper")
Fixes: 089b19a9204f ("flow_dissector: switch kernel context to struct bpf_flow_dissector")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 net/core/filter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9eb785842258..61c353caf141 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1722,7 +1722,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
 {
 	void *ptr;
 
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset >= skb->len))
 		goto err_clear;
 
 	ptr = skb_header_pointer(skb, offset, len, to);
@@ -1753,10 +1753,10 @@ BPF_CALL_4(bpf_flow_dissector_load_bytes,
 {
 	void *ptr;
 
-	if (unlikely(offset > 0xffff))
+	if (unlikely(!ctx->skb))
 		goto err_clear;
 
-	if (unlikely(!ctx->skb))
+	if (unlikely(offset >= ctx->skb->len))
 		goto err_clear;
 
 	ptr = skb_header_pointer(ctx->skb, offset, len, to);
@@ -1787,7 +1787,7 @@ BPF_CALL_5(bpf_skb_load_bytes_relative, const struct sk_buff *, skb,
 	u8 *end = skb_tail_pointer(skb);
 	u8 *start, *ptr;
 
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset >= skb->len))
 		goto err_clear;
 
 	switch (start_header) {
-- 
2.17.1

