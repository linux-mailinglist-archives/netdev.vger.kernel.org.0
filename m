Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238302CD123
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbgLCITg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388237AbgLCITf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 03:19:35 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56556C061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 00:18:55 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id f190so2958786wme.1
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 00:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=5cCAkQp1r01osBGvpBVvh7sFjiHXFmaxAFBtCFRJuBU=;
        b=CJEbUskPdWWxgT+XJ9oCuHy1o0sKECKE8ldG5xnruak/jDVeLZwzrXCpLmh9owBgHa
         /qUYICUz0UvDxa5UAOD98VHWwCzW7oQP3880AjolVLQRHcXBVpHb2yFV7SXJj1vlOMzT
         tE0TQoUuHthl0huDC1rCbg2rbEDF7jxVEqu0HyQCvDvys0H0hbJaE7/v4m779jhWljCQ
         F1sTMP68x/1w7LizTLWNDTHq+y91bvGlQiJK6yVXX0sqbRZD9bcVVtZvNxKGZijfAn+g
         E816VS8rM13ilo8fUcEMV3MAU4xRIKrv+SJx9Ik14iUByglrZyIrSMjiTgCTW9edn5+i
         zHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5cCAkQp1r01osBGvpBVvh7sFjiHXFmaxAFBtCFRJuBU=;
        b=jFvEh+lpekwHvex0Y0pZWrpexLLp48FWeKq5KH4l/SiBbdQ7hrefHvNyYNfDQaxUDJ
         rApvpOa407dxbELNPKdOsvDiUS8MBtGwN1TgqHAj7tSyTy2NHW3bnPOC1JUclR+ZteWF
         NbMJlE1NrK13IrF5b+1meET26F3IVVZ0yRMG1DTf8zvvbaaGQcYumvXnpTbWJffeFpOD
         wmuyR6lZhhyI9lARK2Iv4cnNKIWie9CHSnX7iKT0B6TtDOu30Ki5KmAKn+jVcJ6pgvdw
         X+a6JyneHHcx/56HS1S+xo/VeZ7HrWAWuimHPtnuE+n/tJap0E/nb7mUi4cgSGJ6OtG7
         fsAg==
X-Gm-Message-State: AOAM530iia6pYoi6Y0xiHaIy/SjiuRweKPosGWjbHVaeklPZi5xxu2Wi
        R3sdPQVEX/SGfaqRFf7WS/k7XIzfBykHOTxgAqs=
X-Google-Smtp-Source: ABdhPJzMuUArhVqBhOjrsi33UM2nP3HdW9DcqLH2r0XAKiFkxsfqlEsc++I6h0w4p1YGqd4Y/Iftiw==
X-Received: by 2002:a1c:3b46:: with SMTP id i67mr1878805wma.108.1606983533829;
        Thu, 03 Dec 2020 00:18:53 -0800 (PST)
Received: from localhost.localdomain ([5.35.99.104])
        by smtp.gmail.com with ESMTPSA id l8sm713815wro.46.2020.12.03.00.18.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Dec 2020 00:18:53 -0800 (PST)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net
Subject: [PATCH v4] net/af_unix: don't create a path for a bound socket
Date:   Thu,  3 Dec 2020 11:18:44 +0300
Message-Id: <20201203081844.3205-1-kda@linux-powerpc.org>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the case of a socket which is already bound to an adress
there is no sense to create a path in the next attempts

here is a program that shows the issue:

int main()
{
    int s;
    struct sockaddr_un a;

    s = socket(AF_UNIX, SOCK_STREAM, 0);
    if (s<0)
        perror("socket() failed\n");

    printf("First bind()\n");

    memset(&a, 0, sizeof(a));
    a.sun_family = AF_UNIX;
    strncpy(a.sun_path, "/tmp/.first_bind", sizeof(a.sun_path));

    if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
        perror("bind() failed\n");

    printf("Second bind()\n");

    memset(&a, 0, sizeof(a));
    a.sun_family = AF_UNIX;
    strncpy(a.sun_path, "/tmp/.first_bind_failed", sizeof(a.sun_path));

    if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
        perror("bind() failed\n");
}

kda@SLES15-SP2:~> ./test
First bind()
Second bind()
bind() failed
: Invalid argument

kda@SLES15-SP2:~> ls -la /tmp/.first_bind
.first_bind         .first_bind_failed

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
v2: move a new path creation after the address assignment check
v3: fixed goto labels on the error path
v4: check the assigned address with bindlock held

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 net/unix/af_unix.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 41c3303c3357..489d49a1739c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1029,6 +1029,16 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	}
 
+	/* check if we're already bound to a path */
+	err = mutex_lock_interruptible(&u->bindlock);
+	if (err)
+		goto out;
+	if (u->addr)
+		err = -EINVAL;
+	mutex_unlock(&u->bindlock);
+	if (err)
+		goto out;
+
 	err = unix_mkname(sunaddr, addr_len, &hash);
 	if (err < 0)
 		goto out;
@@ -1049,10 +1059,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (err)
 		goto out_put;
 
-	err = -EINVAL;
-	if (u->addr)
-		goto out_up;
-
 	err = -ENOMEM;
 	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
 	if (!addr)
-- 
2.16.4

