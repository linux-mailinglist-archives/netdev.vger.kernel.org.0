Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC645516929
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 03:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356271AbiEBBoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 21:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiEBBoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 21:44:20 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E178C25C5
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 18:40:53 -0700 (PDT)
Received: from fsav111.sakura.ne.jp (fsav111.sakura.ne.jp [27.133.134.238])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2421eQH1029023;
        Mon, 2 May 2022 10:40:26 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav111.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp);
 Mon, 02 May 2022 10:40:26 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2421eNB9028874
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 2 May 2022 10:40:25 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
Date:   Mon, 2 May 2022 10:40:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: [PATCH v2] net: rds: acquire refcount on TCP sockets
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
 <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
 <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
 <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
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
Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
---
Changes in v2:
  Add Fixes: tag.
  Move to inside lock_sock() section.

I chose 26abe14379f8e2fa and 8a68173691f03661 which went to 4.2 for Fixes: tag,
for refcount was implicitly taken when 70041088e3b97662 ("RDS: Add TCP transport
to RDS") was added to 2.6.32.

 net/rds/tcp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 5327d130c4b5..2f638f8b7b1e 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -495,6 +495,14 @@ void rds_tcp_tune(struct socket *sock)
 
 	tcp_sock_set_nodelay(sock->sk);
 	lock_sock(sk);
+	/* TCP timer functions might access net namespace even after
+	 * a process which created this net namespace terminated.
+	 */
+	if (!sk->sk_net_refcnt) {
+		sk->sk_net_refcnt = 1;
+		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
+	}
 	if (rtn->sndbuf_size > 0) {
 		sk->sk_sndbuf = rtn->sndbuf_size;
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
-- 
2.34.1


