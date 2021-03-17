Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1612E33E6C4
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhCQCX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhCQCW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:22:56 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A78FC06174A;
        Tue, 16 Mar 2021 19:22:46 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so392971oto.2;
        Tue, 16 Mar 2021 19:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=azpBQutchzCr3FplNtXl63QhozAq1NlwxEgz2eiaadY=;
        b=vEpSf/o8xTjOQ+aoV8l6YvhNU7dr0v3f1DIX7YQpXgCsoklKyDWlY9/dmi1Eq+biHd
         U8ND+CFH72Ph3bcLrKqRs8fT8mq7tfdWoGHYzZ4xkZli9vOlPaxdXkA6RkGewX1qhA3A
         GWVOp3d8bo/LCjT3NJHWyreYqGKOebb5fdQr6fj4cr85FQ6fq/Hr6vAmnCSCbkMBjohT
         Tm9yQ9hCNKTbZ+9zmNdc/ZKSK4xTHKX6oa7R4kEHmFqPksqNd3RF+vzmTDZZ2ItVvR1Y
         l7kkmuJ/Gvtmnso00nOhvRvNQzJLgoGAbr6VKehlhf8Y2bhq8eoczsi+9/AUfV70M5j1
         nM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=azpBQutchzCr3FplNtXl63QhozAq1NlwxEgz2eiaadY=;
        b=V/F5Sx8zsOmY4+adUjCh8YJCxGJ+4aKIzCmFISaE8ubX5wEYTAGNfpRCmPMO6hOyLB
         Bwr+8Gy4+6NJDCPq+0SQ8xAfV20zOjGlO0FRkdjn97CgMbg7dhun/aFz0h9iua7RSq4y
         sAXL9VdiF4hqOlO1YguWsBeYxaA+3Pbq5K5Ui3AWafU84L24zsVG0pu0QTS/4Zqw+XpZ
         LOKE4veVQduwMa7njyVTt0WAmwT9XaI+siYMP7oPSHy0DBfp0p+P6X2K2N5OAldMlO/3
         VpGTY/gpOZgMUCjm0pwhUprynr/kZxMLSje9Gl+OtsaNRBSQPpjvtvfxLxws7nzP8E74
         bgmw==
X-Gm-Message-State: AOAM531HyXVX3XLqQd5dPW6Jka1bBo773+kZGixlrYT6KSfj3z+/+qK8
        3ay/8JcI6FozH0mfeVZKiwF5x5KKpHkMyw==
X-Google-Smtp-Source: ABdhPJzqnP6FrFyHthzZglIYUADlZtU+kEX9lrvbM0MM6nmnap1tIeqOGMqMTlxw35ydo/AixqrqbQ==
X-Received: by 2002:a9d:724d:: with SMTP id a13mr1461251otk.307.1615947765379;
        Tue, 16 Mar 2021 19:22:45 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:517b:5634:5d8e:ff09])
        by smtp.gmail.com with ESMTPSA id i3sm8037858oov.2.2021.03.16.19.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 19:22:45 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v5 01/11] skmsg: lock ingress_skb when purging
Date:   Tue, 16 Mar 2021 19:22:09 -0700
Message-Id: <20210317022219.24934-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
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

