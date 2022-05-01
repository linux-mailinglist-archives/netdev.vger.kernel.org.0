Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FD65164F6
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 17:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiEAPdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 11:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241060AbiEAPdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 11:33:47 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C60925E5
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 08:30:16 -0700 (PDT)
Received: from fsav314.sakura.ne.jp (fsav314.sakura.ne.jp [153.120.85.145])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 241FTFXI088399;
        Mon, 2 May 2022 00:29:15 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav314.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp);
 Mon, 02 May 2022 00:29:15 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 241FTFqV088396
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 2 May 2022 00:29:15 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
Date:   Mon, 2 May 2022 00:29:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: [PATCH] net: rds: acquire refcount on TCP sockets
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        OFED mailing list <linux-rdma@vger.kernel.org>
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
 <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
In-Reply-To: <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
for TCP socket used by RDS is accessing sock_net() without acquiring a
refcount on net namespace. Since TCP's retransmission can happen after
a process which created net namespace terminated, we need to explicitly
acquire a refcount.

Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
---
 net/rds/tcp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 5327d130c4b5..8015d2695784 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -493,6 +493,15 @@ void rds_tcp_tune(struct socket *sock)
 	struct net *net = sock_net(sk);
 	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
 
+	/* TCP timer functions might access net namespace even after
+	 * a process which created this net namespace terminated.
+	 */
+	if (!sk->sk_net_refcnt) {
+		sk->sk_net_refcnt = 1;
+		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
+	}
+
 	tcp_sock_set_nodelay(sock->sk);
 	lock_sock(sk);
 	if (rtn->sndbuf_size > 0) {
-- 
2.34.1

