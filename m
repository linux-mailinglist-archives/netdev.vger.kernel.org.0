Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE34343291
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhCUMmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhCUMmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:42:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FEBC061574;
        Sun, 21 Mar 2021 05:42:48 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t20so5144969plr.13;
        Sun, 21 Mar 2021 05:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g+tW1sbTAqpwuW52zUYbzaaee2q2ruShFJBcwucBx5E=;
        b=XiA6rTP3tUPSPI6hyt2PJF73DMffNgyz6UhCPy3XGmAam71O/ipWaTKj5d/nCrEQbi
         KdtyB7XwXK7sC5pbK4sgWQPLDSUJbS2uyYyTj7cxOnZYljttD82DYYh/HT/+52eeH4mp
         F3wb9q0l8Nez93dbwj4n8gEhTlrvFxkiPnXjr4gvGyvAJu0a2NqBIzURKgRLhjWbf9zp
         jRnASQqb9Jb8rkynqo2Zb3f4k1owoipcd4s6p2wBFoaZ42vxkR0Y66qjhEP+iwxNd9WQ
         KLrAlP2tBjrtHDBghj02GL82/7/TwNypAjHBrZ9kDiAdBvbNOjnR6dmWfnGwlNAGkIbW
         U5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g+tW1sbTAqpwuW52zUYbzaaee2q2ruShFJBcwucBx5E=;
        b=GOaQJrLoj5GPpE953IlTcsKygJmGqo16of+/L6//q+kKHohNSm31ViDTnJ3nrCn5co
         u3lxIXmnYvpc0PfRojpTt9GtnrnhdN5WImebZUZf4hBZn6aCNwh2jLft1reqYqTJV0cZ
         nICpBn8XPBnqRWRYOmyoStN28l0kkGEbJ6Si4YK0k2WqQU8Z1GQ80KgXhNVVQgLMtutf
         YaYSJLzhjwXjQQbT9Jtq8F23JJ7qDn0ET/Rqf9odwtMvvDP/41osMx4nXnorsy5OXyg+
         bOzx7HOKpcRU+VomNfTFIHF6NpVO7/c2RmMjtw9OxxPc5o21OnhK5MAMWs/e27Cr6T71
         54eg==
X-Gm-Message-State: AOAM532IrTO1JduydW15xwQ+T4ItMIG6F7MQDgcmRsYgrvvPirWM9rYI
        v7BSoQAm3jRT1VweyieK3mg=
X-Google-Smtp-Source: ABdhPJz+OJ/ZFAzrrFtBcc/2CyGUqYIVMbXJ9R9GrI2c5h3HyAvdn/WHSbFzrlfRQIwM4cEsGwED9A==
X-Received: by 2002:a17:902:e882:b029:e6:caba:fff6 with SMTP id w2-20020a170902e882b02900e6cabafff6mr19385455plg.73.1616330567990;
        Sun, 21 Mar 2021 05:42:47 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id w5sm10047605pge.55.2021.03.21.05.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 05:42:47 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     andy.shevchenko@gmail.com, kuba@kernel.org, linux@roeck-us.net,
        David.Laight@aculab.com
Cc:     davem@davemloft.net, dong.menglong@zte.com.cn,
        viro@zeniv.linux.org.uk, herbert@gondor.apana.org.au,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: socket: use BIT() for MSG_*
Date:   Sun, 21 Mar 2021 20:39:28 +0800
Message-Id: <20210321123929.142838-2-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210321123929.142838-1-dong.menglong@zte.com.cn>
References: <20210321123929.142838-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The bit mask for MSG_* seems a little confused here. Replace it
with BIT() to make it clear to understand.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 include/linux/socket.h | 71 ++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 385894b4a8bb..d5ebfe30d96b 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -283,42 +283,45 @@ struct ucred {
    Added those for 1003.1g not all are supported yet
  */
 
-#define MSG_OOB		1
-#define MSG_PEEK	2
-#define MSG_DONTROUTE	4
-#define MSG_TRYHARD     4       /* Synonym for MSG_DONTROUTE for DECnet */
-#define MSG_CTRUNC	8
-#define MSG_PROBE	0x10	/* Do not send. Only probe path f.e. for MTU */
-#define MSG_TRUNC	0x20
-#define MSG_DONTWAIT	0x40	/* Nonblocking io		 */
-#define MSG_EOR         0x80	/* End of record */
-#define MSG_WAITALL	0x100	/* Wait for a full request */
-#define MSG_FIN         0x200
-#define MSG_SYN		0x400
-#define MSG_CONFIRM	0x800	/* Confirm path validity */
-#define MSG_RST		0x1000
-#define MSG_ERRQUEUE	0x2000	/* Fetch message from error queue */
-#define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
-#define MSG_MORE	0x8000	/* Sender will send more */
-#define MSG_WAITFORONE	0x10000	/* recvmmsg(): block until 1+ packets avail */
-#define MSG_SENDPAGE_NOPOLICY 0x10000 /* sendpage() internal : do no apply policy */
-#define MSG_SENDPAGE_NOTLAST 0x20000 /* sendpage() internal : not the last page */
-#define MSG_BATCH	0x40000 /* sendmmsg(): more messages coming */
-#define MSG_EOF         MSG_FIN
-#define MSG_NO_SHARED_FRAGS 0x80000 /* sendpage() internal : page frags are not shared */
-#define MSG_SENDPAGE_DECRYPTED	0x100000 /* sendpage() internal : page may carry
-					  * plain text and require encryption
-					  */
-
-#define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
-#define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
-#define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
-					   descriptor received through
-					   SCM_RIGHTS */
+#define MSG_OOB		BIT(0)
+#define MSG_PEEK	BIT(1)
+#define MSG_DONTROUTE	BIT(2)
+#define MSG_TRYHARD	BIT(2)	/* Synonym for MSG_DONTROUTE for DECnet		*/
+#define MSG_CTRUNC	BIT(3)
+#define MSG_PROBE	BIT(4)	/* Do not send. Only probe path f.e. for MTU	*/
+#define MSG_TRUNC	BIT(5)
+#define MSG_DONTWAIT	BIT(6)	/* Nonblocking io		*/
+#define MSG_EOR		BIT(7)	/* End of record		*/
+#define MSG_WAITALL	BIT(8)	/* Wait for a full request	*/
+#define MSG_FIN		BIT(9)
+#define MSG_SYN		BIT(10)
+#define MSG_CONFIRM	BIT(11)	/* Confirm path validity	*/
+#define MSG_RST		BIT(12)
+#define MSG_ERRQUEUE	BIT(13)	/* Fetch message from error queue */
+#define MSG_NOSIGNAL	BIT(14)	/* Do not generate SIGPIPE	*/
+#define MSG_MORE	BIT(15)	/* Sender will send more	*/
+#define MSG_WAITFORONE	BIT(16)	/* recvmmsg(): block until 1+ packets avail */
+#define MSG_SENDPAGE_NOPOLICY	BIT(16)	/* sendpage() internal : do no apply policy */
+#define MSG_SENDPAGE_NOTLAST	BIT(17)	/* sendpage() internal : not the last page  */
+#define MSG_BATCH		BIT(18)	/* sendmmsg(): more messages coming */
+#define MSG_EOF	MSG_FIN
+#define MSG_NO_SHARED_FRAGS	BIT(19)	/* sendpage() internal : page frags
+					 * are not shared
+					 */
+#define MSG_SENDPAGE_DECRYPTED	BIT(20)	/* sendpage() internal : page may carry
+					 * plain text and require encryption
+					 */
+
+#define MSG_ZEROCOPY		BIT(26)	/* Use user data in kernel path */
+#define MSG_FASTOPEN		BIT(29)	/* Send data in TCP SYN */
+#define MSG_CMSG_CLOEXEC	BIT(30)	/* Set close_on_exec for file
+					 * descriptor received through
+					 * SCM_RIGHTS
+					 */
 #if defined(CONFIG_COMPAT)
-#define MSG_CMSG_COMPAT	0x80000000	/* This message needs 32 bit fixups */
+#define MSG_CMSG_COMPAT		BIT(31)	/* This message needs 32 bit fixups */
 #else
-#define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
+#define MSG_CMSG_COMPAT		0	/* We never have 32 bit fixups */
 #endif
 
 
-- 
2.30.2

