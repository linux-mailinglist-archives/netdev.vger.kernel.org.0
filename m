Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A03267E0F
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 07:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgIMF5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 01:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgIMF5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 01:57:04 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0806BC061573;
        Sat, 12 Sep 2020 22:57:03 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so9112667pgl.2;
        Sat, 12 Sep 2020 22:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L2601ptSXb6354ZGKXlq6HrTN3axEbz58J2HKuGGYWU=;
        b=FyayF2U2stxus5nipHGS9LqyIsgvxkZaCmO1YlyP+DMbSM9PkigzoMoAlBfUDlmEVe
         tWv0Bp8ZUA/KbaOMqZ0AeJY+VU9+iSmKbSd5WRrXXVIldnvYE8B4efGwdzV+ONlYTjj0
         kaGiQuey9eFdf/YxL47QFJpHwdfAEfGUfXn3VAfihSGiq+QQ+D4PHBb9l445MlnN48hQ
         zG9GxaL4wcQ97i8PnmU7HD5hU6uVFalP41lQ+I5mQIjjk9sZLROUBlu1rQMkDNnw6GYP
         FRbgOk7oO19H8Xbc1juAf1yKbcQyeZ1CYf8lG5+zULK5idwK12X/5PSQOlXpZKSIgofg
         /16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L2601ptSXb6354ZGKXlq6HrTN3axEbz58J2HKuGGYWU=;
        b=HjkzvJw0YlQlNIw2n7qBObWqrjMYxmkXAOPiU4ioFiEEsIfJAr/GEKk4iIAIBv17ef
         g0yHGUEyqfVUmuinsExMrJgaQydaex8TQX2UsjAnH4DQFXqpAeIPbXL8kGDmldYah7Et
         fcX9+RhyaB8VVjZQqH+JVHYVCHUHVxp7TYH5AFKKdnViKWnLBvM6FhwNn4XNKhoZF1Dv
         qzYqjODYX/UV+T/oH+5BFiguhcw7SY9V8a8mswUGfmD7ti0oAkggLLSQh4E7CiH/DdQI
         R4O6P5HWpLzCm+hjb2QtedkbeywhAgGF1Fq1vwBhHZoA/IYTRqKHgCzGR3HOZJj/svMg
         PO7Q==
X-Gm-Message-State: AOAM5320dD1P4YPECZYkEbTKR2tZvAH6PiszQ1RTlu58fDNg5KiqcFi6
        jBNccgbtt9Z1h94/QSierOKgowkTUb7sxh2mRl4=
X-Google-Smtp-Source: ABdhPJyQXnmDPXtE8b2CDhsuc1byOo1IygDKy+BpsxbAFNqfRqABlMjslC5YR8F85j/csblMLJzAsA==
X-Received: by 2002:a63:2209:: with SMTP id i9mr2077924pgi.130.1599976623233;
        Sat, 12 Sep 2020 22:57:03 -0700 (PDT)
Received: from localhost.localdomain ([49.207.209.61])
        by smtp.gmail.com with ESMTPSA id o20sm5722171pgh.63.2020.09.12.22.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 22:57:02 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: fix uninit value error in __sys_sendmmsg
Date:   Sun, 13 Sep 2020 11:26:39 +0530
Message-Id: <20200913055639.15639-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The crash report showed that there was a local variable;

----iovstack.i@__sys_sendmmsg created at:
 ___sys_sendmsg net/socket.c:2388 [inline]
 __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480
 
 that was left uninitialized.

The contents of iovstack are of interest, since the respective pointer
is passed down as an argument to sendmsg_copy_msghdr as well.
Initializing this contents of this stack prevents this bug from happening.

Since the memory that was initialized is freed at the end of the function
call, memory leaks are not likely to be an issue.

syzbot seems to have triggered this error by passing an array of 0's as
a parameter while making the initial system call.

Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
Tested-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
 net/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/socket.c b/net/socket.c
index 0c0144604f81..d74443dfd73b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2396,6 +2396,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 {
 	struct sockaddr_storage address;
 	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	memset(iov, 0, UIO_FASTIOV);
 	ssize_t err;
 
 	msg_sys->msg_name = &address;
-- 
2.25.1

