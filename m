Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE8334BED5
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhC1UUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhC1UU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:26 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B87C061756;
        Sun, 28 Mar 2021 13:20:26 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id f9so11237541oiw.5;
        Sun, 28 Mar 2021 13:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vy5/4Xe03r6L+lMBgMmyiBEF4Wk2/4jX5bPzX7yT5rI=;
        b=P483kmrQ3hPUF4OTht4dqG0Z6pRHDLzc5oP9lJJGFY2L4ejtgUgn4UN/i3KxFRob66
         VPN0VfTGI+wp+s/WuhStq7zMUXRQnJc9KWeodKpxVIg0ixbzwyF4Vt7qhOlivVNVW4Ia
         XtZnHmc7QCGtGxl+8z7DLLuhtT/dLcxfawFT1FXxTxZ1/qmxpvjlHdvh+oFd7eApBqI4
         N/ZR9uhT6TKcsM1CPr74yPMrXCQhANsor8vyDcXIgnlLTHu4OEdMRNMC41zWf2UHyIDN
         BBFrc+4jcRy6YeuoXN4iJTjND/TrWBFWLZWgIFR9GIimDNFvA7qc0HMZpQaQ+g5KPc0K
         KZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vy5/4Xe03r6L+lMBgMmyiBEF4Wk2/4jX5bPzX7yT5rI=;
        b=ZLZotOI2fQLy2iZnnhFskHT5/RCn/CTiKUrtTiNBGI19veMvDS5IEk5SzGFhMQcbCh
         qZ3SNTaXhzyFFY0mYAnkOcNJPid0uu5REZ91tAS+Rk0EkIUGfJ9dfJujRAN1LZLCUsHp
         RXpRViW8vBBqqvuQpr7TW6XfKuFQjckutuR2JR4/rVQb/GOOkgLNyaOrmjv8dpIkT7+B
         BsLyPtzLp4Yi5xCXQFT+RhY4TYAoujyjtDJqa5rqTc8XUNlfuX3wXCwjeGSeCjyC6xRh
         4UlYhjekDHjG62ad7pGLEg5I6xkDGvLvFV7dDZzPO03fOIm+nbEZdfTK4QyDz6norjjT
         nGuQ==
X-Gm-Message-State: AOAM531ThPT9CduK+e/RcNVY4T5zzrDBIzyAckMHlKbJvmKOmFxjqt5H
        8j2AXWvazCuk4RucDxEEYBLypBCHfHye2Q==
X-Google-Smtp-Source: ABdhPJyot2nKFpKqC+iXRR7+VLJNuoXMNp5LWNiaTqRqv8hzgmAuzhfFE1QE/GcIET64Yp/XTmrDXg==
X-Received: by 2002:a05:6808:2d0:: with SMTP id a16mr16158619oid.83.1616962825391;
        Sun, 28 Mar 2021 13:20:25 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:25 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v7 06/13] skmsg: use GFP_KERNEL in sk_psock_create_ingress_msg()
Date:   Sun, 28 Mar 2021 13:20:06 -0700
Message-Id: <20210328202013.29223-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This function is only called in process context.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index d43d43905d2c..656eceab73bc 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -410,7 +410,7 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 	if (!sk_rmem_schedule(sk, skb, skb->truesize))
 		return NULL;
 
-	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
+	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_KERNEL);
 	if (unlikely(!msg))
 		return NULL;
 
-- 
2.25.1

