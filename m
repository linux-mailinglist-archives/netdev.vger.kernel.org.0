Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039AB5AFD2A
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiIGHLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiIGHLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:11:05 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B4C86FEB;
        Wed,  7 Sep 2022 00:11:01 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MMtdP2BrXznV6P;
        Wed,  7 Sep 2022 15:08:25 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 7 Sep
 2022 15:10:58 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <jakub@cloudflare.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH bpf] skmsg: schedule psock work if the cached skb exists on the psock
Date:   Wed, 7 Sep 2022 15:13:11 +0800
Message-ID: <20220907071311.60534-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In sk_psock_backlog function, for ingress direction skb, if no new data
packet arrives after the skb is cached, the cached skb does not have a
chance to be added to the receive queue of psock. As a result, the cached
skb cannot be received by the upper-layer application.

Fix this by reschedule the psock work to dispose the cached skb in
sk_msg_recvmsg function.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 net/core/skmsg.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 188f8558d27d..ca70525621c7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -434,8 +434,10 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 			if (copied + copy > len)
 				copy = len - copied;
 			copy = copy_page_to_iter(page, sge->offset, copy, iter);
-			if (!copy)
-				return copied ? copied : -EFAULT;
+			if (!copy) {
+				copied = copied ? copied : -EFAULT;
+				goto out;
+			}
 
 			copied += copy;
 			if (likely(!peek)) {
@@ -455,7 +457,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 				 * didn't copy the entire length lets just break.
 				 */
 				if (copy != sge->length)
-					return copied;
+					goto out;
 				sk_msg_iter_var_next(i);
 			}
 
@@ -477,7 +479,9 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		}
 		msg_rx = sk_psock_peek_msg(psock);
 	}
-
+out:
+	if (psock->work_state.skb && copied > 0)
+		schedule_work(&psock->work);
 	return copied;
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
-- 
2.17.1

