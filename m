Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1AD2FB8DA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392005AbhASNv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391329AbhASLZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 06:25:35 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6099FC061574
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 03:24:55 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d13so19314015wrc.13
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 03:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=fRRtmk5vKXIeEN5ATtqc9YeRhxKswlmBLafIT7BvxWc=;
        b=PtbtBUP1F7ioONriSFLzgDhOQQyQzwamRQ6YQ2UbgR9P1SJpmma0iVYnWFjvIuO5hs
         ksnpOXqA28p8iwOY/1B6tn7vEn9gBx4qbL4h6iySSoHEjHUyCKJ1ii7quO+XkkSM7IuX
         c9Xyv2m9MqNdyeo8InunBPVm05D0AsCqUJUKiIpeRBmGxLdKTHnvq6aVy4YOisuCYTWz
         nArr8f2AtTjuGUSgC1p1smZKcFl8QKR0mwY0K7B2KWmTGXPUnhP8DdW/RuMAyDXAm9Rc
         RMGA6pT17njTS6TCCt3DqGvHXigDRcUjLAych5aN9V9XxIC4COCafEe+ev23FRErM9aI
         Ancw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fRRtmk5vKXIeEN5ATtqc9YeRhxKswlmBLafIT7BvxWc=;
        b=tJD3B6hNNRdQ3LtK9kB9/GE5kXtGtmILtNDnGBpOti5a5qhx9J7l2KtiQvpBKnC7s1
         NcGOb6RjLXSnhu8n0RZIpYv1CP+tK+yqVoGa4kQRlUa9eQ+YZNH6BKoeoTDvSrai82Zp
         c6JkZem82jisVZjLxl0Ohz2GjU+7Wcg4mk93WXxxKDIZiGv+TX4kVLMmd8UW+gjWgOku
         5I3yWWdH5tffToBWzaQQXCShjhMIxBgX8TyeP9fPlhbb7z6Zdc21HN1m7NYRciaLci3e
         HAWaUmWxACtwbkw4GuJGC98GcBT1KBmPE45/ZkyTnEwnFDBrDdRI2vMQ3arvWLooB4j3
         EFhA==
X-Gm-Message-State: AOAM533RbhwJT3f+Hlpc/N0Rf7FsCeWvtwFogSheaAlcx7UZv82qMPMb
        0jjQhzpVLJig/dAc5KTLvVpDZojtogpVg9xc96U=
X-Google-Smtp-Source: ABdhPJzfsZ2biPon/ZVFVD8TZGyjILmNsThNXGf81zPtu9Lq0ZYnDjE4+3JWzRKEO8tDCa2h0u4+AA==
X-Received: by 2002:a5d:5146:: with SMTP id u6mr3938749wrt.46.1611055493958;
        Tue, 19 Jan 2021 03:24:53 -0800 (PST)
Received: from localhost.localdomain ([5.35.34.67])
        by smtp.gmail.com with ESMTPSA id n8sm35828230wrs.34.2021.01.19.03.24.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Jan 2021 03:24:53 -0800 (PST)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org
Subject: [PATCH v5] net/af_unix: don't create a path for a bound socket
Date:   Tue, 19 Jan 2021 14:24:46 +0300
Message-Id: <20210119112446.21180-1-kda@linux-powerpc.org>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of a socket which is already bound to an adress
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
---
 net/unix/af_unix.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 41c3303c3357..d8b1cfd872a3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1091,8 +1091,23 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 out_up:
 	mutex_unlock(&u->bindlock);
 out_put:
-	if (err)
+	if (err) {
+		struct path parent = { };
+		struct dentry *dentry;
+		int ret;
+
+		dentry = kern_path_locked(sun_path, &parent);
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
+
+		ret = vfs_unlink(d_inode(parent.dentry), path.dentry, NULL);
+		if (ret)
+			err = ret;
+		dput(path.dentry);
+		inode_unlock(d_inode(parent.dentry));
+		path_put(&parent);
 		path_put(&path);
+	}
 out:
 	return err;
 }
-- 
2.16.4

