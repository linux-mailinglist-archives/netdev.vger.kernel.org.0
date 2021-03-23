Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352B7345409
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhCWAjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhCWAid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:33 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538DAC061574;
        Mon, 22 Mar 2021 17:38:33 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id a11so13824933qto.2;
        Mon, 22 Mar 2021 17:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cio+qgcDvmruwG8aqOjWedfunYy04m3r9xm+A6tj84M=;
        b=SoMmBYaYtkk1KN69z5WwbB8MT/noBpcPN1pTUi/j41fRbpaqzIsToALvOdUqEb//6h
         J9NtygfsEclltiHRx3jVHvYl78/qCzo1bZgdcJHqmYT4HdPhfJJFfP9d5BSLgRvhcBRJ
         rFLeTaPYmQPuvwr6qXHJQH5pz17lTq4j3kL8iHChOvXOby8te2cNyltZIjbCLgtj1ejI
         59QrB8UdIylzL7jfNk8nvGEu9WF3JjNba62aEo/vCcvRyfoernXe5qdClMm1a8uRg7U3
         19qIBi9/dIhYX70IHoqE2Frdv8emJ9CvoG0L3lekGFvRmSduOX4h1XOj+gyB7nTGFWvk
         mKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cio+qgcDvmruwG8aqOjWedfunYy04m3r9xm+A6tj84M=;
        b=itzeqrQMU91q0I9iRT5EY1vCnS7w4+NzW4L1axTJR2wl/c1QYL/h66ilMWY5pRUxia
         rUOkmqL2IzfbB3aZqALRaVmyio7MO831HbzzYGhQh2Tw3FYjp6EAqGtG7Be1rPVchdpT
         LB52uL1mX0iBTA7NZ2Rpy75pUxdSc+2Rrlm4HKQNufptCALcY536UIWFtWrDTm6GmUem
         bq2g8rTGmIQfzXKgKrdVou08auF28YRBIUtCYV+CwzwYSj/RhnjvBwQPoi94KU6d2GM7
         0HGv+js3HMbvfIQPXSmDwrdR9pnUrONRrsj1QYBLGRN9pCn0I8NdaflnB1i2zkc3jpST
         J0vQ==
X-Gm-Message-State: AOAM530HT57DcAiPSpcXmZpPqH0Sqq+gmmT3rAZbBqc0KEFvLSIkN9PK
        5cvQ3NqYpvrRzpHWvZVw6orUgrEGKx4ecA==
X-Google-Smtp-Source: ABdhPJxW5WQ7Nkthq8IfYNQ0vV9grQMwn/HOus8Bkv+6anATYj3yI1SddCuuyYqME/78bmI9afI2jw==
X-Received: by 2002:ac8:4809:: with SMTP id g9mr2298634qtq.295.1616459912454;
        Mon, 22 Mar 2021 17:38:32 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:32 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v6 11/12] sock_map: update sock type checks for UDP
Date:   Mon, 22 Mar 2021 17:38:07 -0700
Message-Id: <20210323003808.16074-12-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now UDP supports sockmap and redirection, we can safely update
the sock type checks for it accordingly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index d04b98fc8104..9ed040c7d9e7 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -549,7 +549,10 @@ static bool sk_is_udp(const struct sock *sk)
 
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
-	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
+	if (sk_is_tcp(sk))
+		return sk->sk_state != TCP_LISTEN;
+	else
+		return sk->sk_state == TCP_ESTABLISHED;
 }
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
-- 
2.25.1

