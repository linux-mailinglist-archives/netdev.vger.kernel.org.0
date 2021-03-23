Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9C03453FB
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhCWAiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhCWAiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:18 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCEDC061574;
        Mon, 22 Mar 2021 17:38:18 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id h3so9647173qvh.8;
        Mon, 22 Mar 2021 17:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=azpBQutchzCr3FplNtXl63QhozAq1NlwxEgz2eiaadY=;
        b=WTeos/u9ctlf+UF+ERbZ4ffmp0Z6ja9sDED3log40MO7KxDweIGvMlvFBWW58FzRwQ
         ExiqqrLVWUwbEbugB38tqWsYRqjRnLr60jEEeP0VbDfNg0AAWQmBf7s8JoHZ5bX7K08a
         E1+KyrEAYDtFUn/RuVdEymB1tC+0KflMTFV+H4hTEgKZiD2nYyObXIQaYXROi1TxekUj
         LbYClIkhO9HFULdCLq9dRR6oR/4L+lhX3g82OR8Xm1s5FRGjWUx9L+VYgZykzud/Qy/Q
         EMURF92OutO2xf/cTZncaY+yLOeAVoXZInlpZVNv6Om61kEtKxbck6gF1VeGsfEHgsHQ
         T7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=azpBQutchzCr3FplNtXl63QhozAq1NlwxEgz2eiaadY=;
        b=ai0E6c09POhp4pLtRqDENzz0cmLbHninuQfXRP8hW8kcSYaP8qfqB4pshQ8tkR31xd
         UEO5A2cv3hLD/ANxWeNtvmkjyj5kCRJCyVDBblLQ/FNhrqqKBtMdLqpiYjH4A21qk7ok
         AZh0qvjZOVXqBs9o0jpwyuwDigSbttrBnORNBW46uVClR+aEx5sPkWI2eYb1Zu1yIifD
         mT3klmVGxXquYzrhT/xxV7tKVChxyMyEZSD3CPcAscZs1w6JeqC1hf/vRCo4kqeRvp9S
         Gt4HhzKP6RQZH5CL5KtZ3ohlEHEroqFIcnldX2ujV4q5+jD5CnkPgJHz7FXsTwhdVJ7z
         PcaQ==
X-Gm-Message-State: AOAM533OHkZIA/0bxK5Yff/vBZzsciJiui6nq50sFP/RXXEMS3M+5gQW
        9ZwnTY460uKfzGo8un9zSQE4ERzv8p7tmQ==
X-Google-Smtp-Source: ABdhPJw0pzXwDKHdLNCw3KFOaWBhYYf1E4yAHymf5a96Qnm0/5HK3XHpWzR5BnvXbdH7ip1lBVspNA==
X-Received: by 2002:a05:6214:d47:: with SMTP id 7mr2422982qvr.48.1616459897261;
        Mon, 22 Mar 2021 17:38:17 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:16 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v6 01/12] skmsg: lock ingress_skb when purging
Date:   Mon, 22 Mar 2021 17:37:57 -0700
Message-Id: <20210323003808.16074-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
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

