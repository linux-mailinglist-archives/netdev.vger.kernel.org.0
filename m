Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D26510DF2D
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 21:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfK3UGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 15:06:09 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37958 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3UGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 15:06:09 -0500
Received: by mail-pf1-f196.google.com with SMTP id x185so3569787pfc.5
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 12:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6HI4Har6lFqncUxKqGa6gfftrxQdSXTJWPdm4fenMw=;
        b=r7Jo3KUdoQde2bTzCNqIAVfvdKuuiuzvwk8a2oZfS/1B697KdYEr8TJWJVrSBAoDom
         tv1Ovhc62HZ3OWvBympt8PerxXI5bIR3qqGjW7rHTfE+z0n7fLABtDN+srt3Nmjz7/pP
         /tJnefhCXx8ae27tRWIujEGMriqSRR9RBa6NV8MZUvbsrgnppuejrZbIBjKfwqtd1Grj
         eg+lTflopLsNcHeg361eBs4k0Oowhy5xW5r6niqBu0nDX1v6ZG3jtnWDO4WlDyQLfWP7
         /nbFSU57DtA/vikVAIOXJkTh0ryXui3DtiyfCjEsTPyDT9JrIZXYjD6UBgkez2zjRZgS
         wIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6HI4Har6lFqncUxKqGa6gfftrxQdSXTJWPdm4fenMw=;
        b=Hg4pWY7YI1zwrBP3+FC1oOboGQmJdxd9m+/7k0Gzd28FkQtsUWPgrp9Gy4+Spshptu
         SzPbDXFd3Gbeq25TnwRZ5YzknupU10bO1D/k63vZ5EDf/d4gqV85/J6GMeIJukUnu10l
         DNXNzF68ZUKNe2I7mI3sFvvLd+O+UhXmKQNcinATUub5+++K5GkjAPTSaAki7grRSDwP
         DdiXn/TXMjVnD6fGLmeOSFhQqF68ypI5Yb7laQeO8WrcLbphCEXdzWODf32/ERkYbQ1b
         ZT7s3TqOgGqZAFKryF0D1BYs96cZcVsgc+S9TqEYE26FAle5js8aebkIz7O3tu+9z4LS
         Qpyg==
X-Gm-Message-State: APjAAAW2jtPsPeYA8B/qM655zkw1GuKzAd8yLMolaIN3PTfjTJ+G/L7t
        KbGPtT4jdM7mkoUCX80hvNN0eGpw0V0=
X-Google-Smtp-Source: APXvYqwaZ1XnnYgmQCksdiPEvxzC9XtgS15ytDKvkJt7Cr6Cw95eRvJh852cc2xluppSflIeNH9j7w==
X-Received: by 2002:a65:41c6:: with SMTP id b6mr22702835pgq.390.1575144367002;
        Sat, 30 Nov 2019 12:06:07 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id 143sm6012578pfz.67.2019.11.30.12.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Nov 2019 12:06:06 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+9fe8e3f6c64aa5e5d82c@syzkaller.appspotmail.com
Subject: [Patch net] netrom: fix a potential NULL pointer dereference
Date:   Sat, 30 Nov 2019 12:05:40 -0800
Message-Id: <20191130200540.2461-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that the skb gets removed between skb_peek() and
skb_dequeue(). So we should just check the return value of
skb_dequeue().  Otherwise, skb_clone() may get a NULL pointer.

Technically, this should be protected by sock lock, but netrom
doesn't use it correctly. It is harder to fix sock lock than just
fixing this.

Reported-by: syzbot+9fe8e3f6c64aa5e5d82c@syzkaller.appspotmail.com
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netrom/nr_out.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netrom/nr_out.c b/net/netrom/nr_out.c
index 44929657f5b7..9491a0c02bce 100644
--- a/net/netrom/nr_out.c
+++ b/net/netrom/nr_out.c
@@ -131,9 +131,6 @@ void nr_kick(struct sock *sk)
 	if (nr->condition & NR_COND_PEER_RX_BUSY)
 		return;
 
-	if (!skb_peek(&sk->sk_write_queue))
-		return;
-
 	start = (skb_peek(&nr->ack_queue) == NULL) ? nr->va : nr->vs;
 	end   = (nr->va + nr->window) % NR_MODULUS;
 
@@ -151,6 +148,8 @@ void nr_kick(struct sock *sk)
 	 * Dequeue the frame and copy it.
 	 */
 	skb = skb_dequeue(&sk->sk_write_queue);
+	if (!skb)
+		return;
 
 	do {
 		if ((skbn = skb_clone(skb, GFP_ATOMIC)) == NULL) {
-- 
2.21.0

