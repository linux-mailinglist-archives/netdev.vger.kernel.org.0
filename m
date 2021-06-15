Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740A13A73AD
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhFOCZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbhFOCZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:25:30 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CB8C0613A2;
        Mon, 14 Jun 2021 19:23:25 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 5so2526854qkc.8;
        Mon, 14 Jun 2021 19:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+UdaHYvUCGtywdH+/61KW/Rjo4BNhU+1cStUbcIix1E=;
        b=ZNvnigzBKsLC/rUhO5wakJH3YNjwWixQA7eU+sE4SkVL/OuBYvsTHJNO3pkuP8kXlH
         f/nu3OgPFgbs3HmKzE6UyxaCduDSLGbqwqY5AWdIZlnoEGEMa1zBSgrz+APwu4G082mC
         Mn7PAjFvlxyRh8Tiy0eu264HSwp4XcVpLd5yFQNX9uzFSTVnOVJLexzIdwkeoCCT9oOv
         FNPLk6zlBnudePUtSFAugLKvqAiYVssaoxPWhO058r3J3c1ly83BaZvvqRXShWya1HT7
         goPStDkt9TrI/H4mgWHhfwnRatQxm7mm6jyPG4DOO9ywMY1nLIHYLhjSDqTY6KEk36jz
         l3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+UdaHYvUCGtywdH+/61KW/Rjo4BNhU+1cStUbcIix1E=;
        b=WKVXoyPV8d8QZIbQdJa+Ppo0uB3sJs84LSuz5vtu4Qj2WGOvnV3CLymQWcJGXM3Ssg
         BAd8adtxr+BbzsnGtqjl5td9LPpIt6ySHnVUKkhWwRu+PTrlNE001k2WnLQmTAvO1AJr
         czfUEk/mOWq4FVfe+AsILUor8noSeoxxdU2IlB8MjUmMwcXrCAWO4Y/HaXCxGDLgSxcJ
         FpJm9bSyoaIhSXSry4kxtm8tpdaeFeLNwctvhB8ftuc1S3/N2a4w7S7FVHUPBsYRvB2b
         zuq2GnoNiOA+mlotokwtTEwNshDJg8omiLSbfu7WZPlXt1g4vrmSFcX1wb8oPnvzkINd
         pfaw==
X-Gm-Message-State: AOAM5330JPivvZIX3IFy00YOF1JufaBcFw8ANZlr3lxNkEQ0IF2hzkT2
        8pZpInpv0/+YX+ja2FVQV72Guwh2svHtgQ==
X-Google-Smtp-Source: ABdhPJyCdV3nNzXXHRgjB6Y6pCSwBbefB9bH8FqYGc2gsiIiuC0EQpkFUTRDnbJSTDCylrgGPEtpwA==
X-Received: by 2002:ae9:ed96:: with SMTP id c144mr19104878qkg.401.1623723240386;
        Mon, 14 Jun 2021 19:14:00 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9a1:5f1d:df88:4f3c])
        by smtp.gmail.com with ESMTPSA id t15sm10774497qtr.35.2021.06.14.19.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:14:00 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH RESEND bpf v3 4/8] skmsg: clear skb redirect pointer before dropping it
Date:   Mon, 14 Jun 2021 19:13:38 -0700
Message-Id: <20210615021342.7416-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
References: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

When we drop skb inside sk_psock_skb_redirect(), we have to clear
its skb->_sk_redir pointer too, otherwise kfree_skb() would
misinterpret it as a valid skb->_skb_refdst and dst_release()
would eventually complain.

Fixes: e3526bb92a20 ("skmsg: Move sk_redir from TCP_SKB_CB to skb")
Reported-by: Jiang Wang <jiang.wang@bytedance.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f9a81b314e4c..4334720e2a04 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -843,12 +843,14 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	 * a socket that is in this state so we drop the skb.
 	 */
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
+		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 		return;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
 	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
+		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 		return;
 	}
-- 
2.25.1

