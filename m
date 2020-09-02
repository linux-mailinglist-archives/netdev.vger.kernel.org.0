Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73BE25AA12
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIBLLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:11:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54864 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgIBLL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:11:26 -0400
Received: from fsav106.sakura.ne.jp (fsav106.sakura.ne.jp [27.133.134.233])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 082B9xWe021165;
        Wed, 2 Sep 2020 20:09:59 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav106.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav106.sakura.ne.jp);
 Wed, 02 Sep 2020 20:09:59 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav106.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 082B9tPc021145
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Wed, 2 Sep 2020 20:09:59 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: [PATCH] tipc: fix shutdown() of connectionless socket
To:     syzbot <syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
References: <0000000000003feb9805a9c77128@google.com>
Cc:     syzkaller-bugs@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <1eb799fb-c6e0-3eb5-f6fe-718cd2f62e92@I-love.SAKURA.ne.jp>
Date:   Wed, 2 Sep 2020 20:09:54 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <0000000000003feb9805a9c77128@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting hung task at nbd_ioctl() [1], for there are two
problems regarding TIPC's connectionless socket's shutdown() operation.
I found C reproducer for this problem (shown below) from "no output from
test machine (2)" report.

----------

int main(int argc, char *argv[])
{
        const int fd = open("/dev/nbd0", 3);
        ioctl(fd, NBD_SET_SOCK, socket(PF_TIPC, SOCK_DGRAM, 0));
        ioctl(fd, NBD_DO_IT, 0);
        return 0;
}
----------

One problem is that wait_for_completion() from flush_workqueue() from
nbd_start_device_ioctl() from nbd_ioctl() cannot be completed when
nbd_start_device_ioctl() received a signal at wait_event_interruptible(),
for tipc_shutdown() from kernel_sock_shutdown(SHUT_RDWR) from
nbd_mark_nsock_dead() from sock_shutdown() from nbd_start_device_ioctl()
is failing to wake up a WQ thread sleeping at wait_woken() from
tipc_wait_for_rcvmsg() from sock_recvmsg() from sock_xmit() from
nbd_read_stat() from recv_work() scheduled by nbd_start_device() from
nbd_start_device_ioctl(). Fix this problem by always invoking
sk->sk_state_change() (like inet_shutdown() does) when tipc_shutdown() is
called.

The other problem is that tipc_wait_for_rcvmsg() cannot return when
tipc_shutdown() is called, for tipc_shutdown() sets sk->sk_shutdown to
SEND_SHUTDOWN (despite "how" is SHUT_RDWR) while tipc_wait_for_rcvmsg()
needs sk->sk_shutdown set to RCV_SHUTDOWN or SHUTDOWN_MASK. Fix this
problem by setting sk->sk_shutdown to SHUTDOWN_MASK (like inet_shutdown()
does) when the socket is connectionless.

[1] https://syzkaller.appspot.com/bug?id=3fe51d307c1f0a845485cf1798aa059d12bf18b2

Reported-by: syzbot <syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 net/tipc/socket.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 2679e97e0389..ebd280e767bd 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2771,18 +2771,21 @@ static int tipc_shutdown(struct socket *sock, int how)
 
 	trace_tipc_sk_shutdown(sk, NULL, TIPC_DUMP_ALL, " ");
 	__tipc_shutdown(sock, TIPC_CONN_SHUTDOWN);
-	sk->sk_shutdown = SEND_SHUTDOWN;
+	if (tipc_sk_type_connectionless(sk))
+		sk->sk_shutdown = SHUTDOWN_MASK;
+	else
+		sk->sk_shutdown = SEND_SHUTDOWN;
 
 	if (sk->sk_state == TIPC_DISCONNECTING) {
 		/* Discard any unreceived messages */
 		__skb_queue_purge(&sk->sk_receive_queue);
 
-		/* Wake up anyone sleeping in poll */
-		sk->sk_state_change(sk);
 		res = 0;
 	} else {
 		res = -ENOTCONN;
 	}
+	/* Wake up anyone sleeping in poll. */
+	sk->sk_state_change(sk);
 
 	release_sock(sk);
 	return res;
-- 
2.18.4


