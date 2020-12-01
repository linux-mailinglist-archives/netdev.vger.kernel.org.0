Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49102C9E1A
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgLAJeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgLAJeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 04:34:06 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D9CC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 01:33:20 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id e7so1569114wrv.6
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 01:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=QMf3ciSb3p1TUM3ZMsjWC2X/r5GiQeftLUE54jIL4uA=;
        b=DFuHkurtaSfBpT89lym/p//JGuSMFqM5mYL7cr8LUKfe3n/sNl7L0nLSNa5AKbRIDc
         3ZM57iP+Ft9UZeEYopqIGwkJ8fjB+0eHglyeQ6w9p93jJfeNAq0chvWmv/tHzi6CzX6h
         uSRDzJlBFNH1nESJv9It5YJrVaHE88PbWc7kKkVzE7aybEnxDiINd+IhS3MSF+hxLkSA
         M3jZYvHQEg5dlnvHDb1WQhBDYSsCEjuSOTU22Vs2MmKHOh1SV6yZjy1FvV7vEH1jwWX1
         Kdgx5FfkUYfRiMlBGSFtSPtjdxZJJ3aLy9XpfB2M174Y1SgETxz1HPJ6FVX/9Q1iCmDy
         0auQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QMf3ciSb3p1TUM3ZMsjWC2X/r5GiQeftLUE54jIL4uA=;
        b=gwkNKR5XcdG4dpbzRydQgJNe5U48ce+JeeAij+0SdmzSio06l0cSy2VbgH/5B+bb2C
         2oBp/Yk1yjDKgFTmz1b1dF7Q30UI4IpoMnD5fpAt9JEP3AWfSZmlhViF5SFCMwc1Q0Dy
         +eF8JxT0RUx939TMOZBwUiuOtrwOcp8NXwEdh8r7ossm7AEOGRXl3yI2DPAHHIZM1aRm
         uT26XyUeSJJW3h41nCErQC4Go4eG/nrqN42gkdSbwHkIVOfweopcQdCzrTwrwvgQRASv
         4IDPDzYnctplfllldaMN6OsDtQU8bJHfT/ROWuF3ngySUnYrHIAwph9hp/UfPPwRT/Dq
         bzaQ==
X-Gm-Message-State: AOAM530oRm7uVfOJauG9hfT4O/7FEwIrTF4yAjRSNVA6HakMEtFMkax+
        Co6u/mpDOnMjRfDv2r609OtFEMq0hKBt8GoUApM=
X-Google-Smtp-Source: ABdhPJwwLA662/moo5q95ma9jglCld+deJxKoj5KM/dNJnhhsvaasRdHofW62YH07SYrtmoM6MtWZA==
X-Received: by 2002:adf:e801:: with SMTP id o1mr2667599wrm.3.1606815198551;
        Tue, 01 Dec 2020 01:33:18 -0800 (PST)
Received: from localhost.localdomain ([5.35.99.104])
        by smtp.gmail.com with ESMTPSA id u66sm1893793wmg.30.2020.12.01.01.33.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Dec 2020 01:33:17 -0800 (PST)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net
Subject: [PATCH v3] net/af_unix: don't create a path for a binded socket
Date:   Tue,  1 Dec 2020 12:33:06 +0300
Message-Id: <20201201093306.32638-1-kda@linux-powerpc.org>
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

v2: move a new path creation after the address assignment check
v3: fixed goto labels on the error path
---
 net/unix/af_unix.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 41c3303c3357..70861e9bcfd9 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1034,6 +1034,14 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	addr_len = err;
 
+	err = mutex_lock_interruptible(&u->bindlock);
+	if (err)
+		goto out;
+
+	err = -EINVAL;
+	if (u->addr)
+		goto out_up;
+
 	if (sun_path[0]) {
 		umode_t mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current_umask());
@@ -1041,22 +1049,14 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		if (err) {
 			if (err == -EEXIST)
 				err = -EADDRINUSE;
-			goto out;
+			goto out_up;
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
-		goto out_up;
+		goto out_put;
 
 	memcpy(addr->name, sunaddr, addr_len);
 	addr->len = addr_len;
@@ -1088,11 +1088,11 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 out_unlock:
 	spin_unlock(&unix_table_lock);
-out_up:
-	mutex_unlock(&u->bindlock);
 out_put:
 	if (err)
 		path_put(&path);
+out_up:
+	mutex_unlock(&u->bindlock);
 out:
 	return err;
 }
-- 
2.16.4

