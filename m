Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DEC2C8521
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgK3N2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgK3N2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 08:28:39 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94241C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 05:27:58 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id f190so22130770wme.1
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 05:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=mH5uYMjJ1Qnu05+DOtOMOMfvviITz3XwXSBDGZs+pu4=;
        b=KHMv1XOfJvVvbrc3KuV9K6jsSOJqzbPbKpGC3sHMXR9iEKWnXJdtoCtadtFr5adBM8
         Q80W5c98t5bIVH13hPJ4DYpFhcadRnUOIfnEh4nx0wJINWp4XD2v1oi5jS6pue3QdWx2
         eju3QmETSU7GLpao3lQQtlCkQKdNkO9ij0w7/QiVq3vBvfjn9/45U/DjcGjAmfHDFx78
         s+DNvstmsu5ELVJokDKgaPkdbuH+yqyNGWQz51Yjo2PxucxEEdOr7aXGdAl/rQ2vB3uE
         dVn3DXWiaZblXptfpFSxwC75UjKEY0QWr3VCDsQuQm4hpoW3nR/Kva927s8SgcNayN2N
         C/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mH5uYMjJ1Qnu05+DOtOMOMfvviITz3XwXSBDGZs+pu4=;
        b=A+/QWkKiRRguGU5s/JZhFc3oeEyXdoZ8NyEZtCZ54X60GmkdNGJvaHt2fxdKfLvxQf
         r4K846us6cxU+z0VRMEsIXygtngnp6Wrr604coeRuGAjyp5VMjbg7aavEK37xSK7RlPu
         Oopg+yaahvwhCQ6TJSKBnC8WphsdF8EsLrpxJalV3rAl0gwBbpGCNhGEXIpLtiSbjsgS
         CS3rdKXLxIY+3pkKF/T65LxbOdh5xRi+7mIL/doMXq+pCoMxB4RPNjJnYvANvcnvNd4K
         +3Vb+W+9gNKDrZ8YevCxMxtL30j9Zb8q3L016X3ZEZmM56R49YknoTcFRVYKu1I7f06s
         UOtA==
X-Gm-Message-State: AOAM530tiezDr7s0j73ZXQOFMA/9aGO+JBRItar8+n+rIGGhO8um1L6P
        pg/yJ/tAvbTfFoAK+pjJkMKUZWw4y14Q2h79tMY=
X-Google-Smtp-Source: ABdhPJxYNJmN+4f/QM7YisMZha6INqQDfxcPJUrKPtkSpmXrymN5K6ICkTgwY5IckTxRGt3/tj8ozg==
X-Received: by 2002:a1c:9cc9:: with SMTP id f192mr23754245wme.143.1606742877016;
        Mon, 30 Nov 2020 05:27:57 -0800 (PST)
Received: from localhost.localdomain ([5.35.99.104])
        by smtp.gmail.com with ESMTPSA id t184sm13705837wmt.13.2020.11.30.05.27.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 05:27:56 -0800 (PST)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net
Subject: [PATCH v2] net/af_unix: don't create a path for a binded socket
Date:   Mon, 30 Nov 2020 16:27:47 +0300
Message-Id: <20201130132747.29332-1-kda@linux-powerpc.org>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the case of the socket which is bound to an adress
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

v2: move a new patch creation after the address assignment check.
---
 net/unix/af_unix.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 41c3303c3357..ff2dd1d3536b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1034,6 +1034,14 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	addr_len = err;
 
+	err = mutex_lock_interruptible(&u->bindlock);
+	if (err)
+		goto out_put;
+
+	err = -EINVAL;
+	if (u->addr)
+		goto out_up;
+
 	if (sun_path[0]) {
 		umode_t mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current_umask());
@@ -1045,14 +1053,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		}
 	}
 
-	err = mutex_lock_interruptible(&u->bindlock);
-	if (err)
-		goto out_put;
-
-	err = -EINVAL;
-	if (u->addr)
-		goto out_up;
-
 	err = -ENOMEM;
 	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
 	if (!addr)
-- 
2.16.4

