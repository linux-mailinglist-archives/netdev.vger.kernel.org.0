Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A1B202ADD
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 15:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgFUNxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 09:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729862AbgFUNxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 09:53:21 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB86CC061794;
        Sun, 21 Jun 2020 06:53:20 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id i3so16415361ljg.3;
        Sun, 21 Jun 2020 06:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rj9ZnFm4R5tkYfd96VY13f/6M27NvR0zKjQa2qTEj6s=;
        b=PRrmT/kIqR6/3oQkRNh6tonCdS34cPBT1mCriBx6e1dxP8fVmryxBVXmqCCANsUvX3
         f/IMAe7F5mRvjyqZEIZp5v6er26qBOZpOEn3V5ZroZSHYT/di5EfgPTlpcdq+wc2TFuQ
         AyzfvhvCFz/EANRJU3XHqKuWjpf/z4dF8U5hq+IMmObDIQaaR4Pv7OkRWjr8PnTdv3pK
         oQtaJxqxqCvOavyr/QRs3e7Y4gQBcP4oRr3QXHp7UU+ImQEr3rTty3Z5o8A9db8nz+qF
         lfkl+1f9X6h0kmjAfKPM+qasH5s30UlfupkaM8UDc6X6Zn1IHFRAn8fCqt8nFowB8KeS
         1+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rj9ZnFm4R5tkYfd96VY13f/6M27NvR0zKjQa2qTEj6s=;
        b=O52bh37yFsoQQNvwaI8+ocYjKkfjQf5kQKdfVMuuq6csEWPWWsnk5cb8suUm4oKAe5
         +k/znm6jQoQay+kgTjIvL4l4UefanBl72Gq71guaw5Eq+sb13wDf8qrUU6Nq3hCBicdN
         QqmdYW+tsJ25pS9QClWTYfjY8XkXR/eq3ZGQCeF3iDqGpejVcAbjE8Fik1zL6HFagFFc
         cwgf7fgzq+m/ci1ZOG5hSCKDtvgRWe0Oim+RDvVBRSTs28/iTYFtyUcgiS0GvB5t8CZH
         drMtrKwEmziJWa6YPwqSsq2Z+5XWhN3hWmOInWJH3lAXYtQywjkhpIvkdBuRz+vnjH68
         MNUQ==
X-Gm-Message-State: AOAM531f9mpKZ3p7IKPe8U3FOSqCnBBCVgeY1PbYc0aMVQsaiMfFazCH
        qyS+AuUyCQL8RR1XPWO45hsWeqGHHfVoCw==
X-Google-Smtp-Source: ABdhPJzq9OQuDuEoVWt9yw0RiH+IDcaqJVjQOSfQrPd2eiRIMaJqCUxeJT9Kb+QO1lx+H+Lnoqi4fw==
X-Received: by 2002:a2e:85d8:: with SMTP id h24mr6089524ljj.274.1592747599268;
        Sun, 21 Jun 2020 06:53:19 -0700 (PDT)
Received: from pc-sasha.localdomain ([146.120.244.6])
        by smtp.gmail.com with ESMTPSA id 132sm2745516lfl.37.2020.06.21.06.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 06:53:18 -0700 (PDT)
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
To:     asmadeus@codewreck.org
Cc:     lucho@ionkov.net, ericvh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.kapshuk@gmail.com
Subject: [PATCH] net/9p: Validate current->sighand in client.c
Date:   Sun, 21 Jun 2020 16:53:12 +0300
Message-Id: <20200621135312.78201-1-alexander.kapshuk@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200621084512.GA720@nautica>
References: <20200621084512.GA720@nautica>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix rcu not being dereferenced cleanly by using the task
helpers (un)lock_task_sighand instead of spin_lock_irqsave and
spin_unlock_irqrestore to ensure current->sighand is a valid pointer as
suggested in the email referenced below.

Signed-off-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Link: https://lore.kernel.org/lkml/20200618190807.GA20699@nautica/
---
 net/9p/client.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index fc1f3635e5dd..15f16f2baa8f 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -787,9 +787,14 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	}
 recalc_sigpending:
 	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+		if (!lock_task_sighand(current, &flags)) {
+			pr_warn("%s (%d): current->sighand==NULL in recalc_sigpending\n",
+				__func__, task_pid_nr(current));
+			err = -ESRCH;
+			goto reterr;
+		}
 		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		unlock_task_sighand(current, &flags);
 	}
 	if (err < 0)
 		goto reterr;
@@ -869,9 +874,14 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	}
 recalc_sigpending:
 	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+		if (!lock_task_sighand(current, &flags)) {
+			pr_warn("%s (%d): current->sighand==NULL in recalc_sigpending\n",
+				__func__, task_pid_nr(current));
+			err = -ESRCH;
+			goto reterr;
+		}
 		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		unlock_task_sighand(current, &flags);
 	}
 	if (err < 0)
 		goto reterr;
--
2.27.0

