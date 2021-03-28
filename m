Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E00A34BEC1
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhC1UUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhC1UUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:22 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A197C061762;
        Sun, 28 Mar 2021 13:20:20 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id n140so11217342oig.9;
        Sun, 28 Mar 2021 13:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=azpBQutchzCr3FplNtXl63QhozAq1NlwxEgz2eiaadY=;
        b=ovD8zUGLx3KDEpOyeqLkWSsJquWK/TxG/Jg0z1IX4kDG8RQ4p/nCNSuDqFulV/gASz
         Yd+qtq8UYoorLFn8NbYu7w0b6m7JKxzG7s8JJWh5qdquis1vl849DrgulJa60SfuY0sH
         1QKVc+17y0Wo5vQ2ZPTv8anaz/T5x5mNuT1ohCS4JqAv1j7tDqdGWutjpbvd3/0KsKFA
         XHwdPNh/dTRO8DoZP/3UasSgnRV4etaNhVaYBjvr3kX/FVwvLKlAsXZsy4kTj4wnSmxI
         lG/9QE/TkmRWu6rrusBe8iso9wpVvlVb57yiULMqC9NHF7RtMRXYytG9lMFdZJROMagO
         GIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=azpBQutchzCr3FplNtXl63QhozAq1NlwxEgz2eiaadY=;
        b=A4ZfD7skEANcIAhPKEflQMJY0JL5GUaKAX35rfrdTxEKZ6JTK22NAL3UTpDq3RuPAm
         u02yKiQ1R9HKWoN/7CClW0bQReBTcwE8SbSaayFn7UduCf8blQIz/y4xAfHifOzM/zDi
         VK4eSgm4TlOF18hBsaDBBffKL6u2LVgqrPf4IRine+88lDoXbSjv+UfLcRw5XDvs9Ixp
         j/LGKRR+HyfDGV9vNJ7t74EgxME00fX3ee41M4eCKfd0cw15Tcrxh8SUTQT0p8qHe4zM
         YOn7NHTqaUkh/AZbSNHNAbpDrd8ncBB2DcYpUdxGNz4eT+HvKawchfH8pEPtHy1mB44i
         UTxQ==
X-Gm-Message-State: AOAM531+yssQE9WLzXKo2VCVWjxwj5ZK+Dz/S9ri5Pn9hGBW1uzyyE02
        ++ACUIgDon+L16X9InVZVofkNi2o/S9GsA==
X-Google-Smtp-Source: ABdhPJwu987Qf55cWQYIC3uYEaRJEF2/2X41Jxso05nEbV/VmR1bz3XQWRQkI94Jsdc7n+30AOzjYA==
X-Received: by 2002:a05:6808:1413:: with SMTP id w19mr16658869oiv.20.1616962819371;
        Sun, 28 Mar 2021 13:20:19 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:19 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v7 01/13] skmsg: lock ingress_skb when purging
Date:   Sun, 28 Mar 2021 13:20:01 -0700
Message-Id: <20210328202013.29223-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently we purge the ingress_skb queue only when psock
refcnt goes down to 0, so locking the queue is not necessary,
but in order to be called during ->close, we have to lock it
here.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 07f54015238a..bebf84ed4e30 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -634,7 +634,7 @@ static void sk_psock_zap_ingress(struct sk_psock *psock)
 {
 	struct sk_buff *skb;
 
-	while ((skb = __skb_dequeue(&psock->ingress_skb)) != NULL) {
+	while ((skb = skb_dequeue(&psock->ingress_skb)) != NULL) {
 		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 	}
-- 
2.25.1

