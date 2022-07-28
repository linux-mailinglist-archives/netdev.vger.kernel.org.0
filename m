Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06724584032
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiG1Nkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiG1Nkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:40:43 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3275D0F0;
        Thu, 28 Jul 2022 06:40:40 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LtsCv49nbzlVpr;
        Thu, 28 Jul 2022 21:38:03 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 28 Jul
 2022 21:40:37 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <jakub@cloudflare.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH bpf-next] skmsg: Fix wrong last sg check in sk_msg_recvmsg()
Date:   Thu, 28 Jul 2022 21:44:35 +0800
Message-ID: <20220728134435.99469-1-liujian56@huawei.com>
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

Fix one kernel NULL pointer dereference as below:

[  224.462334] Call Trace:
[  224.462394]  __tcp_bpf_recvmsg+0xd3/0x380
[  224.462441]  ? sock_has_perm+0x78/0xa0
[  224.462463]  tcp_bpf_recvmsg+0x12e/0x220
[  224.462494]  inet_recvmsg+0x5b/0xd0
[  224.462534]  __sys_recvfrom+0xc8/0x130
[  224.462574]  ? syscall_trace_enter+0x1df/0x2e0
[  224.462606]  ? __do_page_fault+0x2de/0x500
[  224.462635]  __x64_sys_recvfrom+0x24/0x30
[  224.462660]  do_syscall_64+0x5d/0x1d0
[  224.462709]  entry_SYSCALL_64_after_hwframe+0x65/0xca

In commit 7303524e04af ("skmsg: Lose offset info in sk_psock_skb_ingress"),
we change last sg check to sg_is_last(), but in sockmap redirection case
(without stream_parser/stream_verdict/skb_verdict), we did not mark the
end of the scatterlist. Check the sk_msg_alloc, sk_msg_page_add, and
bpf_msg_push_data functions, they all do not mark the end of sg. They are
expected to use sg.end for end judgment. So the judgment of
'(i != msg_rx->sg.end)' is added back here.

Fixes: 7303524e04af ("skmsg: Lose offset info in sk_psock_skb_ingress")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 net/core/skmsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 81627892bdd4..385ae23580a5 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -462,7 +462,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 
 			if (copied == len)
 				break;
-		} while (!sg_is_last(sge));
+		} while ((i != msg_rx->sg.end) && !sg_is_last(sge));
 
 		if (unlikely(peek)) {
 			msg_rx = sk_psock_next_msg(psock, msg_rx);
@@ -472,7 +472,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		}
 
 		msg_rx->sg.start = i;
-		if (!sge->length && sg_is_last(sge)) {
+		if (!sge->length && (i == msg_rx->sg.end || sg_is_last(sge))) {
 			msg_rx = sk_psock_dequeue_msg(psock);
 			kfree_sk_msg(msg_rx);
 		}
-- 
2.17.1

