Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC1D70E0C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 02:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387645AbfGWAUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 20:20:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43312 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfGWAUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 20:20:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so18163164pfg.10;
        Mon, 22 Jul 2019 17:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jTr8NEpJLgXf+jV4qfw5bEZ4uzJQSJikCB2UYlRQiNY=;
        b=GgT1DxXn19H5kgs/6tmTDka1Unz3KYgOmf5C8EHeJ4bWBieN2QqAU/MBU1/Et/zd1I
         8ABygMVKH+BZtz8d27Dl5AaCr5ncb2j7Tc9lh5osucQOaoxRYBA14qBbUG2PFbuU3jSG
         MHr1y7jQvWnJ0hl02vKe4kQqWCJQh6M6frLLfDk6WXD2qEaojgIeHidJbp+dkavHavY1
         dHpHbIa0NhOvlIMmbdsJnR45og+5yehMjgKFkvjmVSkXtVnG+vwbSHLHbV33l9dz1YWn
         m9M7imXmsI+HyQGW/Bjmc0oxswE1NY8TzEJVyZffDwsc/50hWrrpiwnrsRolJykHU6TP
         jPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jTr8NEpJLgXf+jV4qfw5bEZ4uzJQSJikCB2UYlRQiNY=;
        b=rLxWRg0AkW5ddAehaq+wUXl3yB5HtgiR6On4njCOehtf9Vo1T5yDtmGdAH4stwOgcn
         EfxWhr/LqYUZmDf+n6/scm4H+3NrOZCN5F3ucLixYB5qm3ejVmvPYfAuMAkyHFlHNp8v
         5OM1Y6OzSXtt0wqXCyYWWPJelpyCcYOLpYWTy9Q3JZ3dkS8bObbOJucZ4rNxKdN8brlU
         j/iybSVcaHDqTLanzF+HRwsJYFxIkyMeG5uBpc4I4rFUUTsxE2bNl7cb48ROHijpN31Q
         jkH+Chu9+l+wwREqxqyuEW7tuQdU2fW9/tIy3A8VsmietkmHZTz3AIBYyG0VsiBUrl1G
         qnzA==
X-Gm-Message-State: APjAAAXHcxTnqOHUkKr9du45ACdu74MeM7W2dyWESdb5zMuPdoLhV4On
        eqPqK0obLLzhSHhNFlvuBvUIKjvu
X-Google-Smtp-Source: APXvYqymCBbwNekus7+a2MiXSC1Q8VO2Onw/rqvrTE/PCGrv4x0c3BdeAZY3jnGKvhZlp0/bDMN0NA==
X-Received: by 2002:a63:58c:: with SMTP id 134mr77181797pgf.106.1563841248983;
        Mon, 22 Jul 2019 17:20:48 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id k64sm21718423pge.65.2019.07.22.17.20.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 17:20:48 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next 1/6] tcp: tcp_syn_flood_action read port from socket
Date:   Mon, 22 Jul 2019 17:20:37 -0700
Message-Id: <20190723002042.105927-2-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

This allows us to call this function before an SKB has been
allocated.

Signed-off-by: Petar Penkov <ppenkov@google.com>
---
 net/ipv4/tcp_input.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c21e8a22fb3b..8892df6de1d4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6422,9 +6422,7 @@ EXPORT_SYMBOL(inet_reqsk_alloc);
 /*
  * Return true if a syncookie should be sent
  */
-static bool tcp_syn_flood_action(const struct sock *sk,
-				 const struct sk_buff *skb,
-				 const char *proto)
+static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 {
 	struct request_sock_queue *queue = &inet_csk(sk)->icsk_accept_queue;
 	const char *msg = "Dropping request";
@@ -6444,7 +6442,7 @@ static bool tcp_syn_flood_action(const struct sock *sk,
 	    net->ipv4.sysctl_tcp_syncookies != 2 &&
 	    xchg(&queue->synflood_warned, 1) == 0)
 		net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
-				     proto, ntohs(tcp_hdr(skb)->dest), msg);
+				     proto, sk->sk_num, msg);
 
 	return want_cookie;
 }
@@ -6487,7 +6485,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	 */
 	if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
 	     inet_csk_reqsk_queue_is_full(sk)) && !isn) {
-		want_cookie = tcp_syn_flood_action(sk, skb, rsk_ops->slab_name);
+		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
 		if (!want_cookie)
 			goto drop;
 	}
-- 
2.22.0.657.g960e92d24f-goog

