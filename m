Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32344C3AFA
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 02:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiBYBcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 20:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiBYBcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 20:32:18 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0045D4B1E0;
        Thu, 24 Feb 2022 17:31:44 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4K4XGQ5PcXz9sLq;
        Fri, 25 Feb 2022 09:28:14 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 09:31:42 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <bpf@vger.kernel.org>
CC:     <edumazet@google.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next 4/4] bpf, sockmap: Fix double uncharge the mem of sk_msg
Date:   Fri, 25 Feb 2022 09:49:29 +0800
Message-ID: <20220225014929.942444-5-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225014929.942444-1-wangyufen@huawei.com>
References: <20220225014929.942444-1-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

If tcp_bpf_sendmsg is running during a tear down operation, psock may be
freed.

tcp_bpf_sendmsg()
 tcp_bpf_send_verdict()
  sk_msg_return()
  tcp_bpf_sendmsg_redir()
   unlikely(!psock))
   sk_msg_free()

The mem of msg has been uncharged in tcp_bpf_send_verdict() by
sk_msg_return(), so we need to use sk_msg_free_nocharge while psock
is null.

This issue can cause the following info:
WARNING: CPU: 0 PID: 2136 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
Call Trace:
 <TASK>
 __sk_destruct+0x24/0x1f0
 sk_psock_destroy+0x19b/0x1c0
 process_one_work+0x1b3/0x3c0
 worker_thread+0x30/0x350
 ? process_one_work+0x3c0/0x3c0
 kthread+0xe6/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30
 </TASK>

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 net/ipv4/tcp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1f0364e06619..03c037d2a055 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -139,7 +139,7 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 	int ret;
 
 	if (unlikely(!psock)) {
-		sk_msg_free(sk, msg);
+		sk_msg_free_nocharge(sk, msg);
 		return 0;
 	}
 	ret = ingress ? bpf_tcp_ingress(sk, psock, msg, bytes, flags) :
-- 
2.25.1

