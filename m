Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF293A77C
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 18:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbfFIQuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 12:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731082AbfFIQuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 12:50:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78B7B206C3;
        Sun,  9 Jun 2019 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099005;
        bh=TRrM6aZo+7lDrh45y6Gia4GwOo80+JtUxdtJg7tGtfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZG2u1I4zScyy2Q5DeZptM5goI8AZbCsWqwzREBBYTr2GA37dAhQuLC5TzTJ9+l82
         2Gu4wc/rBEmD+MOL634KIes3vcbSZRMkhQP+7599mPnqFmrk6A1jZV7XZ7daJe4n0d
         GMO21TqfXl0krNVMp8gMuy/oyQfouttdjqOARsnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 4.14 02/35] Fix memory leak in sctp_process_init
Date:   Sun,  9 Jun 2019 18:42:08 +0200
Message-Id: <20190609164125.708731461@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
References: <20190609164125.377368385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 0a8dd9f67cd0da7dc284f48b032ce00db1a68791 ]

syzbot found the following leak in sctp_process_init
BUG: memory leak
unreferenced object 0xffff88810ef68400 (size 1024):
  comm "syz-executor273", pid 7046, jiffies 4294945598 (age 28.770s)
  hex dump (first 32 bytes):
    1d de 28 8d de 0b 1b e3 b5 c2 f9 68 fd 1a 97 25  ..(........h...%
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000a02cebbd>] kmemleak_alloc_recursive include/linux/kmemleak.h:55
[inline]
    [<00000000a02cebbd>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<00000000a02cebbd>] slab_alloc mm/slab.c:3326 [inline]
    [<00000000a02cebbd>] __do_kmalloc mm/slab.c:3658 [inline]
    [<00000000a02cebbd>] __kmalloc_track_caller+0x15d/0x2c0 mm/slab.c:3675
    [<000000009e6245e6>] kmemdup+0x27/0x60 mm/util.c:119
    [<00000000dfdc5d2d>] kmemdup include/linux/string.h:432 [inline]
    [<00000000dfdc5d2d>] sctp_process_init+0xa7e/0xc20
net/sctp/sm_make_chunk.c:2437
    [<00000000b58b62f8>] sctp_cmd_process_init net/sctp/sm_sideeffect.c:682
[inline]
    [<00000000b58b62f8>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1384
[inline]
    [<00000000b58b62f8>] sctp_side_effects net/sctp/sm_sideeffect.c:1194
[inline]
    [<00000000b58b62f8>] sctp_do_sm+0xbdc/0x1d60 net/sctp/sm_sideeffect.c:1165
    [<0000000044e11f96>] sctp_assoc_bh_rcv+0x13c/0x200
net/sctp/associola.c:1074
    [<00000000ec43804d>] sctp_inq_push+0x7f/0xb0 net/sctp/inqueue.c:95
    [<00000000726aa954>] sctp_backlog_rcv+0x5e/0x2a0 net/sctp/input.c:354
    [<00000000d9e249a8>] sk_backlog_rcv include/net/sock.h:950 [inline]
    [<00000000d9e249a8>] __release_sock+0xab/0x110 net/core/sock.c:2418
    [<00000000acae44fa>] release_sock+0x37/0xd0 net/core/sock.c:2934
    [<00000000963cc9ae>] sctp_sendmsg+0x2c0/0x990 net/sctp/socket.c:2122
    [<00000000a7fc7565>] inet_sendmsg+0x64/0x120 net/ipv4/af_inet.c:802
    [<00000000b732cbd3>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000b732cbd3>] sock_sendmsg+0x54/0x70 net/socket.c:671
    [<00000000274c57ab>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2292
    [<000000008252aedb>] __sys_sendmsg+0x80/0xf0 net/socket.c:2330
    [<00000000f7bf23d1>] __do_sys_sendmsg net/socket.c:2339 [inline]
    [<00000000f7bf23d1>] __se_sys_sendmsg net/socket.c:2337 [inline]
    [<00000000f7bf23d1>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2337
    [<00000000a8b4131f>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:3

The problem was that the peer.cookie value points to an skb allocated
area on the first pass through this function, at which point it is
overwritten with a heap allocated value, but in certain cases, where a
COOKIE_ECHO chunk is included in the packet, a second pass through
sctp_process_init is made, where the cookie value is re-allocated,
leaking the first allocation.

Fix is to always allocate the cookie value, and free it when we are done
using it.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |   13 +++----------
 net/sctp/sm_sideeffect.c |    5 +++++
 2 files changed, 8 insertions(+), 10 deletions(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2318,7 +2318,6 @@ int sctp_process_init(struct sctp_associ
 	union sctp_addr addr;
 	struct sctp_af *af;
 	int src_match = 0;
-	char *cookie;
 
 	/* We must include the address that the INIT packet came from.
 	 * This is the only address that matters for an INIT packet.
@@ -2422,14 +2421,6 @@ int sctp_process_init(struct sctp_associ
 	/* Peer Rwnd   : Current calculated value of the peer's rwnd.  */
 	asoc->peer.rwnd = asoc->peer.i.a_rwnd;
 
-	/* Copy cookie in case we need to resend COOKIE-ECHO. */
-	cookie = asoc->peer.cookie;
-	if (cookie) {
-		asoc->peer.cookie = kmemdup(cookie, asoc->peer.cookie_len, gfp);
-		if (!asoc->peer.cookie)
-			goto clean_up;
-	}
-
 	/* RFC 2960 7.2.1 The initial value of ssthresh MAY be arbitrarily
 	 * high (for example, implementations MAY use the size of the receiver
 	 * advertised window).
@@ -2595,7 +2586,9 @@ do_addr_param:
 	case SCTP_PARAM_STATE_COOKIE:
 		asoc->peer.cookie_len =
 			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
-		asoc->peer.cookie = param.cookie->body;
+		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
+		if (!asoc->peer.cookie)
+			retval = 0;
 		break;
 
 	case SCTP_PARAM_HEARTBEAT_INFO:
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -878,6 +878,11 @@ static void sctp_cmd_new_state(struct sc
 						asoc->rto_initial;
 	}
 
+	if (sctp_state(asoc, ESTABLISHED)) {
+		kfree(asoc->peer.cookie);
+		asoc->peer.cookie = NULL;
+	}
+
 	if (sctp_state(asoc, ESTABLISHED) ||
 	    sctp_state(asoc, CLOSED) ||
 	    sctp_state(asoc, SHUTDOWN_RECEIVED)) {


