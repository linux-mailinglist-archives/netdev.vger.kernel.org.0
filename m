Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E0F135335
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgAIGb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 01:31:56 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:49454
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726541AbgAIGbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:31:55 -0500
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 28EB620AAB;
        Thu,  9 Jan 2020 06:31:48 +0000 (UTC)
From:   Martin Schiller <ms@dev.tdt.de>
To:     arnd@arndb.de, davem@davemloft.net
Cc:     andrew.hendry@gmail.com, edumazet@google.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Martin Schiller <ms@dev.tdt.de>,
        syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com,
        syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
Subject: [PATCH] net/x25: fix nonblocking connect
Date:   Thu,  9 Jan 2020 07:31:14 +0100
Message-Id: <20200109063114.23195-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CAK8P3a0LdF+aQ1hnZrVKkNBQaum0WqW1jyR7_Eb+JRiwyHWr6Q@mail.gmail.com>
References: <CAK8P3a0LdF+aQ1hnZrVKkNBQaum0WqW1jyR7_Eb+JRiwyHWr6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes 2 issues in x25_connect():

1. It makes absolutely no sense to reset the neighbour and the
connection state after a (successful) nonblocking call of x25_connect.
This prevents any connection from being established, since the response
(call accept) cannot be processed.

2. Any further calls to x25_connect() while a call is pending should
simply return, instead of creating new Call Request (on different
logical channels).

This patch should also fix the "KASAN: null-ptr-deref Write in
x25_connect" and "BUG: unable to handle kernel NULL pointer dereference
in x25_connect" bugs reported by syzbot.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Reported-by: syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com
Reported-by: syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
---
 net/x25/af_x25.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 2efe44a34644..d5b09bbff375 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -766,6 +766,10 @@ static int x25_connect(struct socket *sock, struct sockaddr *uaddr,
 	if (sk->sk_state == TCP_ESTABLISHED)
 		goto out;
 
+	rc = -EALREADY;	/* Do nothing if call is already in progress */
+	if (sk->sk_state == TCP_SYN_SENT)
+		goto out;
+
 	sk->sk_state   = TCP_CLOSE;
 	sock->state = SS_UNCONNECTED;
 
@@ -812,7 +816,7 @@ static int x25_connect(struct socket *sock, struct sockaddr *uaddr,
 	/* Now the loop */
 	rc = -EINPROGRESS;
 	if (sk->sk_state != TCP_ESTABLISHED && (flags & O_NONBLOCK))
-		goto out_put_neigh;
+		goto out;
 
 	rc = x25_wait_for_connection_establishment(sk);
 	if (rc)
-- 
2.20.1

