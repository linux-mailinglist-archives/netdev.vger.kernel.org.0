Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676322C2598
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732607AbgKXMYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbgKXMYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:24:41 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BCAC0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 04:24:40 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id w24so2696136wmi.0
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 04:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=pP55Q+kIzGHR5DVZIMhwPiqgB9NvurGHm8kvioXbkhk=;
        b=nMLMD7V2/hc7HK7AWpidD+GdfAmlh2NvFrARxPPhNIcRlZIUv6PpwwU4Xk/R0EwavE
         queVsVUCtnrBn2bo22DEBCz4kwz1jKAc6v7Hfum7cZd58zhZwTXOA7vvwTPQGeKC99qv
         U5e6pXNkc23Nn0J4rhiJ9DNH7uMSNQR4OZKIs2oUiSp2oz1YbzZatzGJvPNTdxtHE3s7
         Ows20XXWv/nOH/foFX5sCliDcdEizXtOltFxVjPG8EhtXpbbR6ffex5vvD2gWeIqd/1J
         HhJwM5zCg67aBP4T0gMjYRcul5CPQmiys+jy1V8n6nJNJk8MWQNQwhE1ykEZv8+RoKR/
         GnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pP55Q+kIzGHR5DVZIMhwPiqgB9NvurGHm8kvioXbkhk=;
        b=N95e5zNfZ+BPnIdIm+pCJUt9vLWpInxtNJ8FRQcP6l+qwpxjxXgTnmsNjtLv+YE30V
         7iPjIuYSCOLWdV27xyzwNz2WGy8gbeyGbrN4kJHNd8lBPjWoehdQUrmk4JhyMVgXjkkT
         M0em4zpTSDvWGlg/d7j+8WId5ZGfLcgtK92Is09zjv9/rVLKe78ClbQvAc5YlK2BeNcs
         fVdTk2kSBhLSswN8f9DWzmNgidsE9J873bN64U6as6vjEBdFA/wKuXg7zvY4WngRgJTC
         ypB88hwdZyGfU7PvKwGlnf4GN08PTRdR+EfwQbAVy51TXeeRCNkv3oo5rqF/IuQ1Y87x
         NzJw==
X-Gm-Message-State: AOAM530+OUCk3OaMF1sDiUevZB0pytFyNp24xB+5QODUAQ/dziocdfWK
        krKfJA1R4+fsTITEpeq4h9xNS6n6H1Q/TmGikHE=
X-Google-Smtp-Source: ABdhPJwXf9EN5d/bSBq6ERWdK7EOks8XqlIHW3nxaNNBedj0uuENVnBgMlAEvFBXSlaEpmYBKr9ECg==
X-Received: by 2002:a1c:a344:: with SMTP id m65mr4259821wme.77.1606220678456;
        Tue, 24 Nov 2020 04:24:38 -0800 (PST)
Received: from localhost.localdomain ([5.35.99.104])
        by smtp.gmail.com with ESMTPSA id u7sm5133044wmb.20.2020.11.24.04.24.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Nov 2020 04:24:37 -0800 (PST)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net
Subject: [PATCH] net/af_unix: don't create a path for a binded socket
Date:   Tue, 24 Nov 2020 15:24:21 +0300
Message-Id: <20201124122421.9859-1-kda@linux-powerpc.org>
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
---
 net/unix/af_unix.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 41c3303c3357..fd76a8fe3907 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1021,7 +1021,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	err = -EINVAL;
 	if (addr_len < offsetofend(struct sockaddr_un, sun_family) ||
-	    sunaddr->sun_family != AF_UNIX)
+	    sunaddr->sun_family != AF_UNIX || u->addr)
 		goto out;
 
 	if (addr_len == sizeof(short)) {
@@ -1049,10 +1049,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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

