Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300BD4C9AFE
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbiCBCK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237949AbiCBCKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:10:51 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8285B3DA;
        Tue,  1 Mar 2022 18:10:08 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4K7cs35l0nz1GBvl;
        Wed,  2 Mar 2022 10:05:27 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 10:10:06 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <ast@kernel.org>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next v2 4/4] bpf, sockmap: Fix double uncharge the mem of sk_msg
Date:   Wed, 2 Mar 2022 10:27:55 +0800
Message-ID: <20220302022755.3876705-5-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302022755.3876705-1-wangyufen@huawei.com>
References: <20220302022755.3876705-1-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
sk_msg_return(), and would be uncharged by sk_msg_free() again. When psock
is null, we can simply returning an error code, this would then trigger
the sk_msg_free_nocharge in the error path of __SK_REDIRECT and would have
the side effect of throwing an error up to user space. This would be a
slight change in behavior from user side but would look the same as an
error if the redirect on the socket threw an error.

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
 net/ipv4/tcp_bpf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1f0364e06619..7ed1e6a8e30a 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -138,10 +138,9 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 	struct sk_psock *psock = sk_psock_get(sk);
 	int ret;
 
-	if (unlikely(!psock)) {
-		sk_msg_free(sk, msg);
-		return 0;
-	}
+	if (unlikely(!psock))
+		return -EPIPE;
+
 	ret = ingress ? bpf_tcp_ingress(sk, psock, msg, bytes, flags) :
 			tcp_bpf_push_locked(sk, msg, bytes, flags, false);
 	sk_psock_put(sk, psock);
-- 
2.25.1

