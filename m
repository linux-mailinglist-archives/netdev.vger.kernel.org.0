Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C064C3AF7
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 02:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbiBYBcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 20:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbiBYBcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 20:32:18 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD514A923;
        Thu, 24 Feb 2022 17:31:44 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4K4XGP6hzRz9sLk;
        Fri, 25 Feb 2022 09:28:13 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 09:31:41 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <bpf@vger.kernel.org>
CC:     <edumazet@google.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next 3/4] bpf, sockmap: Fix more uncharged while msg has more_data
Date:   Fri, 25 Feb 2022 09:49:28 +0800
Message-ID: <20220225014929.942444-4-wangyufen@huawei.com>
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

In tcp_bpf_send_verdict(), if msg has more data after
tcp_bpf_sendmsg_redir():

tcp_bpf_send_verdict()
 tosend = msg->sg.size  //msg->sg.size = 22220
 case __SK_REDIRECT:
  sk_msg_return()  //uncharged msg->sg.size(22220) sk->sk_forward_alloc
  tcp_bpf_sendmsg_redir() //after tcp_bpf_sendmsg_redir, msg->sg.size=11000
 goto more_data;
 tosend = msg->sg.size  //msg->sg.size = 11000
 case __SK_REDIRECT:
  sk_msg_return()  //uncharged msg->sg.size(11000) to sk->sk_forward_alloc

The msg->sg.size(11000) has been uncharged twice, to fix we can charge the
remaining msg->sg.size before goto more data.

This issue can cause the following info:
WARNING: CPU: 0 PID: 9860 at net/core/stream.c:208 sk_stream_kill_queues+0xd4/0x1a0
Call Trace:
 <TASK>
 inet_csk_destroy_sock+0x55/0x110
 __tcp_close+0x279/0x470
 tcp_close+0x1f/0x60
 inet_release+0x3f/0x80
 __sock_release+0x3d/0xb0
 sock_close+0x11/0x20
 __fput+0x92/0x250
 task_work_run+0x6a/0xa0
 do_exit+0x33b/0xb60
 do_group_exit+0x2f/0xa0
 get_signal+0xb6/0x950
 arch_do_signal_or_restart+0xac/0x2a0
 ? vfs_write+0x237/0x290
 exit_to_user_mode_prepare+0xa9/0x200
 syscall_exit_to_user_mode+0x12/0x30
 do_syscall_64+0x46/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
 </TASK>

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
 net/ipv4/tcp_bpf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ac9f491cc139..1f0364e06619 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -335,7 +335,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 			cork = true;
 			psock->cork = NULL;
 		}
-		sk_msg_return(sk, msg, tosend);
+		sk_msg_return(sk, msg, msg->sg.size);
 		release_sock(sk);
 
 		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
@@ -375,8 +375,11 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		}
 		if (msg &&
 		    msg->sg.data[msg->sg.start].page_link &&
-		    msg->sg.data[msg->sg.start].length)
+		    msg->sg.data[msg->sg.start].length) {
+			if (eval == __SK_REDIRECT)
+				sk_mem_charge(sk, msg->sg.size);
 			goto more_data;
+		}
 	}
 	return ret;
 }
-- 
2.25.1

