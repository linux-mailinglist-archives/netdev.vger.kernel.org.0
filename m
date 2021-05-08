Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5138377443
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhEHWKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhEHWKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:17 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B9EC061763;
        Sat,  8 May 2021 15:09:14 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id j19so9303086qtp.7;
        Sat, 08 May 2021 15:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iDyoH4IWpKzUfHp//0ErURRULDPHH7w6/umK0bSTNNU=;
        b=XCLgfJEG/iJm6iSiofjM3joFRSbgy1lLkp08yOAwGo96l46eQsV/VpmI2ROEOc9ZHx
         f7rQ/YKEKYlFlQNq2tk22lbo7vyK3QFU3fDweKQZ+omGqnVgQTLH7tPr58PUhCklhzTv
         9kFcGDJo73E1YqVE4wWW+TUJkK+whxA5yPN/A77fybO5iH34S+trleJgheuSeNjVNETC
         GEbJE89kYqNGpgVI6w+g04wwvF1ziOyBC3HiiM/4swl5dCI8TkWDwkCnuJp+jQWq0EbT
         iY2oDTnrU6xWLLVGMpYDXF5xYiSISMOJAtdtifWsKhy1eyRnK3mD2bbm4OHMd1sYEevA
         YYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iDyoH4IWpKzUfHp//0ErURRULDPHH7w6/umK0bSTNNU=;
        b=U9INCCrAay1xxbyTw6R8Wqi8D0BvzC9H5kKgXXMmReOD2LO4fgWjttV6e0rYGmr+qZ
         e217V/5AeecxLwvFKc32U9o0P/2nXMWQcrMgIuI4f7EfIPnmSrtyUH2lTR/1BVxj0okX
         Las5hOVTbSUrFFGE90isFDQDlYj8VJKy+ZyuDD5BMa9/pDNdVwuUJbMGiYUKb9kpInaV
         OS2CA6jQr+6E1ORQp/H0MOFRsg0IhvxGmJbwr8lgB6aZmzMUoml/1nmbp21l3rHMa0gi
         O++cE4Q2iyAeXHTcZmC3DbLQjgrzx7VCKrHhBoQpWPRfwnj098OTCpNnfYDAOtRH67zJ
         11Tg==
X-Gm-Message-State: AOAM531MKcoBbw32Pfbk/qN6xpb+ygvbGTbPmPGjuRppsIk/xl2ShivI
        5l2rhWUFgF3aHYwviCzQ8BrkLaHYwUKV+Q==
X-Google-Smtp-Source: ABdhPJwBAa8oVG53RAgZylUlVsLZWMlMkcAlVEZKU7ih0IjtEhUQZNY+J80Nvd9m2cBin7r5qUmY3w==
X-Received: by 2002:a05:622a:10e:: with SMTP id u14mr15427950qtw.229.1620511753562;
        Sat, 08 May 2021 15:09:13 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 05/12] af_unix: prepare for sockmap support
Date:   Sat,  8 May 2021 15:08:28 -0700
Message-Id: <20210508220835.53801-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Unlike af_inet, unix_proto is very different, it does not even have
a ->close() or ->unhash(). We have to add some dummy implementations
to satisfy sockmap. Normally they are just nops, they are only used
for the sockmap replacements.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e08918c45892..0f9a6dcca752 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -487,6 +487,8 @@ static void unix_dgram_disconnected(struct sock *sk, struct sock *other)
 			other->sk_error_report(other);
 		}
 	}
+	sk->sk_prot->unhash(sk);
+	other->sk_prot->unhash(other);
 	sk->sk_state = other->sk_state = TCP_CLOSE;
 }
 
@@ -773,10 +775,23 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.show_fdinfo =	unix_show_fdinfo,
 };
 
+/* Nothing to do here, unix socket is not unhashed when disconnecting,
+ * and does not need a ->close(). These are merely for sockmap.
+ */
+static void unix_unhash(struct sock *sk)
+{
+}
+
+static void unix_close(struct sock *sk, long timeout)
+{
+}
+
 static struct proto unix_proto = {
 	.name			= "UNIX",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
+	.unhash			= unix_unhash,
+	.close			= unix_close,
 };
 
 static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
@@ -860,6 +875,7 @@ static int unix_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	sk->sk_prot->close(sk, 0);
 	unix_release_sock(sk, 0);
 	sock->sk = NULL;
 
-- 
2.25.1

