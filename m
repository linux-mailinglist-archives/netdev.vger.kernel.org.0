Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A1225C333
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgICOrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:47:10 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50388 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbgICOZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:25:24 -0400
Received: from fsav303.sakura.ne.jp (fsav303.sakura.ne.jp [153.120.85.134])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 083EOgug082441;
        Thu, 3 Sep 2020 23:24:42 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav303.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp);
 Thu, 03 Sep 2020 23:24:42 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 083EOeGh082422
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Thu, 3 Sep 2020 23:24:40 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH v2] tipc: fix shutdown() of connectionless socket
To:     Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com,
        jmaloy@redhat.com, ying.xue@windriver.com,
        syzkaller-bugs@googlegroups.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        Wouter Verhelst <w@uter.be>
References: <0000000000003feb9805a9c77128@google.com>
 <1eb799fb-c6e0-3eb5-f6fe-718cd2f62e92@I-love.SAKURA.ne.jp>
 <8267b7c2-3dc9-41ec-5490-d1080a63be11@I-love.SAKURA.ne.jp>
 <20200902.155017.1839963224242775770.davem@davemloft.net>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <ed285b44-2b09-8116-bb9e-a3879f72eb4d@i-love.sakura.ne.jp>
Date:   Thu, 3 Sep 2020 23:24:34 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200902.155017.1839963224242775770.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Parthasarathy.

I have a question regarding commit 6f00089c7372ba97 ("tipc: remove SS_DISCONNECTING state").
That commit added

	sk->sk_shutdown = SEND_SHUTDOWN;

into tipc_shutdown(). What is the reason you chose SEND_SHUTDOWN despite how == SHUT_RDWR ?

Since Wouter commented that NBD expects SOCK_STREAM sockets, I think that passing TIPC's
stream socket is legal. And I can trigger hung task warning using a reproducer shown below.

----------
#include <fcntl.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <linux/nbd.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
        const int fd = open("/dev/nbd0", 3);
        int fds[2] = { -1, -1 };
        alarm(5);
        socketpair(PF_TIPC, SOCK_STREAM, 0, fds);
        ioctl(fd, NBD_SET_SOCK, fds[0]);
        ioctl(fd, NBD_DO_IT, 0); /* To be interrupted by SIGALRM. */
        return 0;
}
----------

Applying a patch shown below solves the hung task warning, but I can't evaluate
the side effect of this patch, for I don't know why you chose SEND_SHUTDOWN and
how TIPC socket works. Can we apply this patch?

----------
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2771,10 +2771,7 @@ static int tipc_shutdown(struct socket *sock, int how)
 
 	trace_tipc_sk_shutdown(sk, NULL, TIPC_DUMP_ALL, " ");
 	__tipc_shutdown(sock, TIPC_CONN_SHUTDOWN);
-	if (tipc_sk_type_connectionless(sk))
-		sk->sk_shutdown = SHUTDOWN_MASK;
-	else
-		sk->sk_shutdown = SEND_SHUTDOWN;
+	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	if (sk->sk_state == TIPC_DISCONNECTING) {
 		/* Discard any unreceived messages */
----------
