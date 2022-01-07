Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4688486E38
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343679AbiAGAA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:00:27 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:44530
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232802AbiAGAA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:00:26 -0500
Received: from integral2.. (unknown [36.68.70.227])
        by gnuweeb.org (Postfix) with ESMTPSA id E4084C1662;
        Fri,  7 Jan 2022 00:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1641513623;
        bh=zVcijoVrqichYyAtJLimzaz4WltQzNvqW5+uBLx1moE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jonuSsvKid7aFWo09ULcE9X/Ivakjju7B86QHHyLkURJK0RFHNUVvZ0cTMpZB5WpN
         Y4jpBIUuLajgMDhxVEraQe3eFfEUkv+6/gnBv3hh0HZ/5ECMNdfS12E6GTDnsI7QhT
         SHGNcihvMpC+toWsMr5MIva02CRP7Pb3FsQ7mhQEUHn+mn45r3kAMlRLbnoLUevtzH
         DOxXhq8b0GDQnNJv7ppT8v+ueilNy+kI5ADcspCsqja6K5rxR2vK8e0rFUWIBnUgtQ
         U4Rbia8DLXHJP50TFs7UF15PZhWBy6Wk2X13aJVekFBCzsdvB3P4P90aW38U5s0adE
         KN5nkG7Qtrs+w==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Nugra <richiisei@gmail.com>,
        Praveen Kumar <kpraveen.lkml@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [RFC PATCH v4 1/3] io_uring: Rename `io_{send,recv}` to `io_{sendto,recvfrom}`
Date:   Fri,  7 Jan 2022 07:00:03 +0700
Message-Id: <20220107000006.1194026-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107000006.1194026-1-ammarfaizi2@gnuweeb.org>
References: <20220107000006.1194026-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we can perform `send` and `recv` via io_uring. And now, we
are going to add `sendto` and `recvfrom` support for io_uring.

Note that:
Calling `send(fd, buf, len, flags)` is equivalent to calling
`sendto(fd, buf, len, flags, NULL, 0)`. Therefore, `sendto`
is a superset of `send`.

Calling `recv(fd, buf, len, flags)` is equivalent to calling
`recvfrom(fd, buf, len, flags, NULL, NULL)`. Therefore, `recvfrom`
is a superset of `recv`.

As such, let's direct the current supported `IORING_OP_{SEND,RECV}` to
`io_{sendto,recvfrom}`. These functions will also be used for
`IORING_OP_{SENDTO,RECVFROM}` operation in the next patches.

Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

v4:
  - Rebase the work (sync with "for-next" branch in Jens' tree).

v3:
  - Fix build error when CONFIG_NET is undefined for PATCH 1/3. I
    tried to fix it in PATCH 3/3, but it should be fixed in PATCH 1/3,
    otherwise it breaks the build in PATCH 1/3.

v2:
  - Added Nugra to CC list (tester).

---
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d5da4a898fe8..5e45e4d6969c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4947,7 +4947,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_send(struct io_kiocb *req, unsigned int issue_flags)
+static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
@@ -5173,7 +5173,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
+static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_buffer *kbuf;
 	struct io_sr_msg *sr = &req->sr_msg;
@@ -5381,8 +5381,8 @@ IO_NETOP_PREP_ASYNC(sendmsg);
 IO_NETOP_PREP_ASYNC(recvmsg);
 IO_NETOP_PREP_ASYNC(connect);
 IO_NETOP_PREP(accept);
-IO_NETOP_FN(send);
-IO_NETOP_FN(recv);
+IO_NETOP_FN(sendto);
+IO_NETOP_FN(recvfrom);
 #endif /* CONFIG_NET */
 
 struct io_poll_table {
@@ -6710,13 +6710,13 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_sendmsg(req, issue_flags);
 		break;
 	case IORING_OP_SEND:
-		ret = io_send(req, issue_flags);
+		ret = io_sendto(req, issue_flags);
 		break;
 	case IORING_OP_RECVMSG:
 		ret = io_recvmsg(req, issue_flags);
 		break;
 	case IORING_OP_RECV:
-		ret = io_recv(req, issue_flags);
+		ret = io_recvfrom(req, issue_flags);
 		break;
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout(req, issue_flags);
-- 
2.32.0

