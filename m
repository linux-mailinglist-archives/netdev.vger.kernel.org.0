Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA5238D72F
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 21:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhEVTQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 15:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhEVTP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 15:15:58 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82190C06174A;
        Sat, 22 May 2021 12:14:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s4so11079212plg.12;
        Sat, 22 May 2021 12:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DcX8fhKGj8R427RducM9Ix+CQKTH1UdCiDQd5Xwx4xg=;
        b=D+54d9ffWQpaqYrrntfrvzAGdAd1QgOlVpkhz3uQVzK6ELaM0t6NnbQgCw+5aNan0g
         HQHQrdAwMTrpbmTaFZ8Z2+CZ53Z+TcZROpfD4Pvth2WwPAei8h/Fd6rEZV1nfxdUZcal
         SM5jmQwTXiIP3Bvih7uyfctv9KPYw3DafdxMt4VtcX55sFIyVTq+UniIGjgSN463XOrV
         2DivQL7UwHbteKAiS9zbjvENM5xirncUNp6hW8x/NPmOb3R+YesikdxuV61yQvIBArkl
         TSRENdUzYENwAMJnWE7wFPKJh5gx9TbA2uG/8at9I7anQE+izehFmRbduj+Z7SkTJxb4
         syeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DcX8fhKGj8R427RducM9Ix+CQKTH1UdCiDQd5Xwx4xg=;
        b=lbYsTe3BDkOiZsaxJy88E3Mdi+WVxm7ygZ4/MFpk+DnA5sshuo6ZM4i3yuSMX4Yx7p
         8LRUZpgPfal3T7Y5cwQtLfpBPFloVyGmYN3md9uIUItM0/qGqt9q33ltCjFGvRP6PdYH
         9pA6scoTcEHT5X25R9VqqdC/6559WRDD4xnDJvwaST5Q4OxzbB//AO3+XECPZDhFkJA/
         8UxgaYXT0LKdHSCuzq+Mv1z6zXWlsYwwPkHin0OQ5rmmrbMaZQGVJrxb6hUfHX+tkzWb
         nyowYklmNjwnBLioCRCO7SulKpxzQ3erqioH/uRECYGVdaW/PXka48zOnQ6PmliG4Irg
         fLbw==
X-Gm-Message-State: AOAM533CRR7iR3aaz+aMzN/ImgfrZmqBkuaycj68UomrrqyDrxRaAzQ0
        6b8qRsGXyZzXWjbjyVED6zn9aYmrwW2qvQ==
X-Google-Smtp-Source: ABdhPJx/EQ9Xv5OYmvfL0rfAfehaHbJm+Rf8GFBhJw92L0ENx+dYXSh2sfA3ZYrmxWwZ7CBgP8pYvg==
X-Received: by 2002:a17:902:b609:b029:ec:e80d:7ebd with SMTP id b9-20020a170902b609b02900ece80d7ebdmr18484134pls.75.1621710872004;
        Sat, 22 May 2021 12:14:32 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:14cd:343f:4e27:51d7])
        by smtp.gmail.com with ESMTPSA id 5sm6677531pfe.32.2021.05.22.12.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 12:14:31 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v2 6/7] skmsg: pass source psock to sk_psock_skb_redirect()
Date:   Sat, 22 May 2021 12:14:10 -0700
Message-Id: <20210522191411.21446-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
References: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

sk_psock_skb_redirect() only takes skb as a parameter, we
will need to know where this skb is from, so just pass
the source psock to this function as a new parameter.
This patch prepares for the next one.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 335fc60f5d22..7b2c25038a48 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -824,7 +824,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 }
 EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 
-static int sk_psock_skb_redirect(struct sk_buff *skb)
+static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
@@ -859,11 +859,12 @@ static int sk_psock_skb_redirect(struct sk_buff *skb)
 	return 0;
 }
 
-static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int verdict)
+static void sk_psock_tls_verdict_apply(struct sk_buff *skb,
+				       struct sk_psock *from, int verdict)
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
-		sk_psock_skb_redirect(skb);
+		sk_psock_skb_redirect(from, skb);
 		break;
 	case __SK_PASS:
 	case __SK_DROP:
@@ -887,7 +888,7 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
-	sk_psock_tls_verdict_apply(skb, psock->sk, ret);
+	sk_psock_tls_verdict_apply(skb, psock, ret);
 	rcu_read_unlock();
 	return ret;
 }
@@ -932,7 +933,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		}
 		break;
 	case __SK_REDIRECT:
-		err = sk_psock_skb_redirect(skb);
+		err = sk_psock_skb_redirect(psock, skb);
 		break;
 	case __SK_DROP:
 	default:
-- 
2.25.1

