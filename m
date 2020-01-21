Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDB5143CE1
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAUMbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:31:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32858 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgAUMbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:31:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id b6so3029008wrq.0
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 04:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WURJ7vgVZmGkrqDGit1ay4OfmUl2vEoh8ehwRVPP35E=;
        b=ahOiuenVWWB3Dtz03h0TPw39sqD41Rfy/KE/+UzQNILFfpuuElAZgQfQA8g1KRDVqW
         jtVWvdvdYgsHGuhwLIcEcZXjD0qfZyQ69A3gpmL/PRB7Ysl1mVsrnSvPmVZUOvem46X7
         bnTOLqyFDXFrKvtqE81bIIlbf90g0gDgO+etg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WURJ7vgVZmGkrqDGit1ay4OfmUl2vEoh8ehwRVPP35E=;
        b=iD67hP6rcaXkeq/DGFusCuTf11MLnpvZIb3mkMiRa0jg+J3MDsqb7U5jUWz5hqrLPK
         idNeySV8KdrEKINr1/tPnqV3Xrz0ZsoH09DHD8Qo4KNaHNtljwbb7kKkUwgHeBs/sxAA
         xf5rOQLNriljjKSMklVTl8rb6kzod+fK7XNkpUNciALaE11fJMNc+IA+HDCSxN1/SOy1
         Th2rxz9NK5lpFcWsxdWvJWMn2y8pkBXVDd4CqWBUS42GdP2JRM3U/Vb8IJTHqY9H4S96
         G0P9Xc6sw55ORfR04sl1f8sVMRjgUmKhQnoOP5SL6j0qXULrzi1YBhxDWBSAlJ190MzL
         nmdw==
X-Gm-Message-State: APjAAAXTqquOWJilxKepLup9ZX6SKYnBrmB8csNzK/T4yzD1h8yhOk9Q
        QUFPbsy2+uennPWI8T8x5ntbVnQ/FuHI5g==
X-Google-Smtp-Source: APXvYqzxsWVRWpqbcsdDTLGOmT/G4jvT2+S+Y7fduTk2ha2+7bXF/JqQjxtRk/tjOTngCVQVotEhrg==
X-Received: by 2002:adf:e641:: with SMTP id b1mr5040241wrn.34.1579609909723;
        Tue, 21 Jan 2020 04:31:49 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id n1sm49685178wrw.52.2020.01.21.04.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 04:31:49 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
Subject: [PATCH net] net, sk_msg: Don't check if sock is locked when tearing down psock
Date:   Tue, 21 Jan 2020 13:31:47 +0100
Message-Id: <20200121123147.706666-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As John Fastabend reports [0], psock state tear-down can happen on receive
path *after* unlocking the socket, if the only other psock user, that is
sockmap or sockhash, releases its psock reference before tcp_bpf_recvmsg
does so:

 tcp_bpf_recvmsg()
  psock = sk_psock_get(sk)                         <- refcnt 2
  lock_sock(sk);
  ...
                                  sock_map_free()  <- refcnt 1
  release_sock(sk)
  sk_psock_put()                                   <- refcnt 0

Remove the lockdep check for socket lock in psock tear-down that got
introduced in 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during
tear down").

[0] https://lore.kernel.org/netdev/5e25dc995d7d_74082aaee6e465b441@john-XPS-13-9370.notmuch/

Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
Reported-by: syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
Suggested-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/skmsg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 3866d7e20c07..ded2d5227678 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -594,8 +594,6 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-	sock_owned_by_me(sk);
-
 	sk_psock_cork_free(psock);
 	sk_psock_zap_ingress(psock);
 
-- 
2.24.1

