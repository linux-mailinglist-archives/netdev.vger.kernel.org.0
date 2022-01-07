Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE48486E3E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343715AbiAGAAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:00:30 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:44544
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S245708AbiAGAA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:00:27 -0500
Received: from integral2.. (unknown [36.68.70.227])
        by gnuweeb.org (Postfix) with ESMTPSA id 575FCC17B7;
        Fri,  7 Jan 2022 00:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1641513623;
        bh=WzZ3THiNZ134dV91EsO3hDKhoOTzDcbFpG9HFQHAhJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGsgKQxjkRKN8/+wDKpCyl7VHvQLMo5iNUpPpDlWMeZRMTh/CSPkwIIrR5dsMEH2f
         rKfvWHjFwTTwx/FKloWxxN3VFy/NEEmuuUOfSpC5yuuclzri1x8LarrNe4AuFSdywc
         34dHqjfoynxVeMXKjxV7Z7r70lM9/uNO89YsgalZWnoKGXPgzwShioXDbsW6qKXFqb
         MviLqisFAesc3rRyRrBzCFL0X6SXiTkbO37Vg7353gh2/HdolQypeNkVs+aYhaKSsM
         KD2fFiUqoinaY6csLzxDjDucFCDRQqf2Dqm2HuPhW+GGOliYVkaW1vQeVLgrEWGZ4Q
         G6dz0GD16cI8g==
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
Subject: [RFC PATCH v4 2/3] net: Make `move_addr_to_user()` be a non static function
Date:   Fri,  7 Jan 2022 07:00:04 +0700
Message-Id: <20220107000006.1194026-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107000006.1194026-1-ammarfaizi2@gnuweeb.org>
References: <20220107000006.1194026-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to add recvfrom support for io_uring, we need to call
`move_addr_to_user()` from fs/io_uring.c.

This makes `move_addr_to_user()` be a non static function so we can
call it from io_uring.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

v4:
  * No changes *

v3:
  * No changes *

v2:
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
index 7f64a6eccf63..af521d351c8a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -267,8 +267,8 @@ int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *k
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

