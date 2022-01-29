Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580EC4A2FA1
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 14:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349218AbiA2NDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 08:03:31 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:49208
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1344688AbiA2NDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 08:03:24 -0500
Received: from integral2.. (unknown [36.81.38.25])
        by gnuweeb.org (Postfix) with ESMTPSA id 7BC32C32BD;
        Sat, 29 Jan 2022 13:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1643461401;
        bh=/1T2B7uj38XWhZu+Pu1N5081eSZLYd6hVvWWUjEzQ8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNyRqeGbxKG+smEQDZjMeUjUQkXjH+77TtSKlncLItJoLgPi2Tx5ovEk5cI3TmM7n
         20ai42odw0MGaOKZiAuO+aB7WnBPTVRBjFXMn4lJ5PzPt1/yfoDQiDhuNU6uPJjOlH
         tcl7jDiV20U6sx9iu1H66idQQyfjEN/CoCLZrJU6gnatAsELHiCHszvXsITM3+VhVO
         j9WT+6WDdXGfllEfkFov9T7bPe+eXkF5RUINabKS7PwTq5HHeMUIqAcfRguRruSJea
         qrmxWJHEiICRfIeMmHQQn9vFQ1Yas0SrGt87yLGvJl4SzzqRjivr+KiR7wgOMfulYg
         8tTBUJOsOy1SQ==
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
Subject: [PATCH for-5.18 v1 2/3] net: Make `move_addr_to_user()` be a non static function
Date:   Sat, 29 Jan 2022 19:50:20 +0700
Message-Id: <20220129125021.15223-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
References: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To add recvfrom() support for io_uring, we need to call
move_addr_to_user() from fs/io_uring.c.

This makes move_addr_to_user() be a non static function so we can call
it from io_uring.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Nugra <richiisei@gmail.com>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
v1:
  - Add Alviro Iskandar Setiawan to CC list (tester).

RFC v4:
  * No changes *

RFC v3:
  * No changes *

RFC v2:
  - Added Nugra to CC list (tester).

---
---
 include/linux/socket.h | 2 ++
 net/socket.c           | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 8ef26d89ef49..0d0bc1ace50c 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -371,6 +371,8 @@ struct ucred {
 #define IPX_TYPE	1
 
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
+extern int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+			     void __user *uaddr, int __user *ulen);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec64;
diff --git a/net/socket.c b/net/socket.c
index 50cf75730fd7..9bc586ab4e93 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -268,8 +268,8 @@ int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *k
  *	specified. Zero is returned for a success.
  */
 
-static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
-			     void __user *uaddr, int __user *ulen)
+int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+		      void __user *uaddr, int __user *ulen)
 {
 	int err;
 	int len;
-- 
2.32.0

