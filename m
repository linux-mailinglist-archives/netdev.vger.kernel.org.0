Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B274A2F9F
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 14:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345745AbiA2ND0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 08:03:26 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:49200
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1344137AbiA2NDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 08:03:23 -0500
Received: from integral2.. (unknown [36.81.38.25])
        by gnuweeb.org (Postfix) with ESMTPSA id 7EE99C32BF;
        Sat, 29 Jan 2022 13:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1643461400;
        bh=6AKi7hGS7R6OvLfjzdzvqyxbTBftpQs4lqMu0PZkje0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjO4sgN63FrHy6bikhKswx/BWUJkVQ1uuL4Gwwlu3eHF25ly2Tmol3gN5AgBVcjVa
         annwNyJNlwCtHMrjGMdCQOtUrAAHwKVn2+X46VvmUtmlr46I+DwAUjlpTq29UKHKid
         Y0x+yKBT1+zxtC6Uptj4NgHJrbPT+Pz3pkYmQpFz4mE9BJfsuzRqqZ1YNQ20pvn5Hy
         LP3Bhcy/F8b05rhjoFT9xtFheC12gVTF+ci2mutumZW8Bt+HQzscE3yZs4hXiG+RZo
         hUFrOM/krA5MrH/4VxnQmvweDAyC0dYbz91tsY74QaU0JwdgpZWXXE9yA9ry2qLzy2
         2OA9dRzAq6kGQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Nugra <richiisei@gmail.com>,
        Praveen Kumar <kpraveen.lkml@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH for-5.18 v1 1/3] io_uring: Rename `io_{send,recv}` to `io_{sendto,recvfrom}`
Date:   Sat, 29 Jan 2022 19:50:19 +0700
Message-Id: <20220129125021.15223-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
References: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation to add sendto() and recvfrom() support for
io_uring.
_____________________________________________________
The following call

    send(sockfd, buf, len, flags);

is equivalent to

    sendto(sockfd, buf, len, flags, NULL, 0);
_____________________________________________________
The following call

    recv(sockfd, buf, len, flags);

is equivalent to

    recvfrom(sockfd, buf, len, flags, NULL, NULL);
_____________________________________________________

Currently, io_uring supports send() and recv() operation. Now, we are
going to add sendto() and recvfrom() support. Since the latter is the
superset of the former, change the function name to the latter.

This renames:
  - io_send() to io_sendto()
  - io_recv() to io_recvfrom()

Cc: Nugra <richiisei@gmail.com>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
v1:
  - Rebase the work (sync with "io_uring-5.17" branch in Jens' tree).
  - Reword the commit message.
  - Add Alviro Iskandar Setiawan to CC list (tester).

RFC v4:
  - Rebase the work (sync with "for-next" branch in Jens' tree).

RFC v3:
  - Fix build error when CONFIG_NET is undefined for PATCH 1/3. I
    tried to fix it in PATCH 3/3, but it should be fixed in PATCH 1/3,
    otherwise it breaks the build in PATCH 1/3.

RFC v2:
  - Add Nugra to CC list (tester).

---
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e04f718319d..742e252a052a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4961,7 +4961,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_send(struct io_kiocb *req, unsigned int issue_flags)
+static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
@@ -5187,7 +5187,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
+static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_buffer *kbuf;
 	struct io_sr_msg *sr = &req->sr_msg;
@@ -5395,8 +5395,8 @@ IO_NETOP_PREP_ASYNC(sendmsg);
 IO_NETOP_PREP_ASYNC(recvmsg);
 IO_NETOP_PREP_ASYNC(connect);
 IO_NETOP_PREP(accept);
-IO_NETOP_FN(send);
-IO_NETOP_FN(recv);
+IO_NETOP_FN(sendto);
+IO_NETOP_FN(recvfrom);
 #endif /* CONFIG_NET */
 
 struct io_poll_table {
@@ -6771,13 +6771,13 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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

