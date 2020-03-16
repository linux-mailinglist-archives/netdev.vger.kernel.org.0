Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D761863F6
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 04:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgCPDxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 23:53:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35754 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbgCPDxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 23:53:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id g6so7365353plt.2;
        Sun, 15 Mar 2020 20:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=C249CL9vZbJjGY5SY9HaOYPXZNrUoazqr8vVdhSJLxc=;
        b=YbeX5UKoLAWoeqcw7Q/c9tQyAMJcC+JzZ9CnlGn1ov5ohmb8qb6dSbK23haVP5/FyF
         nh0GPdgl34Ie646XT9QBX8ixIYobJHzWAf19eQ7HtKIOpDZRmi5d+j4PaKK59JO1ZYN2
         BUx9mnikzXn6lmFRd5j96sK77UGDRYpw+5chW6ZsfhREn0A8R7KaaWabPBYcCwc7k95c
         PGdDHBe+LsdxMdsA06WIS/hoM9ruojvEjdHqz39klHVGY8EuV/qxJM0yrvf+145CISNt
         lZQ0V2YIte00cH+u12YGPlCxl0Q5BgG4eTLx2BpGi/16DYWe0XTXj9S4GZqYSAAhU6B0
         8e1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C249CL9vZbJjGY5SY9HaOYPXZNrUoazqr8vVdhSJLxc=;
        b=BivR4MCVcexaeOhjDXLRvU1LYcOD6T4FxTpFY6xDt/z9Sco9U3c0Wh58TbQ/DQIYOd
         mf2/SkCjJ/UDR7bKe8wtxRJj5ROf0b0bt93T2J73xVeJPbJW8e8zXOpky8cUPO9mhK4X
         kQR3bi8MK0xdXyD2cgnK9W3LvQ5sQUjlCSeaEEhKlX4fJabqnAM1xQFQgDmWQfAxKLdv
         GXCKj4IwbHui329N9k2KP85Xd4VpUHMcHIau3QP9/bmvGbSMdlXy9NUfdj67aYY7pTwO
         YbZHoY/S+Ae0u6I0NU5UhrYuBIxBoXb8e6GMDvIvi4a6nH7xXi54M+faOUWyzHnDU/rn
         tj6Q==
X-Gm-Message-State: ANhLgQ3i1XR2Si/AEOsNfPe3mH3f2ImyiN7/ld8FJwJrR67JNwV6y+fX
        9EltG15NcTmXP96pMmsKRbs=
X-Google-Smtp-Source: ADFU+vt8j7rx0vgN/MuXOrCtGwcpsFMUkwXZDEP+KtICMmp/pv9FflGadulya+vhgWSw7QEClX4Vsw==
X-Received: by 2002:a17:902:7583:: with SMTP id j3mr25527955pll.236.1584330808708;
        Sun, 15 Mar 2020 20:53:28 -0700 (PDT)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id h23sm14077457pfo.220.2020.03.15.20.53.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 20:53:28 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] sctp: fix refcount bug in sctp_wfree
Date:   Mon, 16 Mar 2020 11:53:24 +0800
Message-Id: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do accounting for skb's real sk.
In some case skb->sk != asoc->base.sk.

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc4..5f5c28b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9080,7 +9080,7 @@ static void sctp_wfree(struct sk_buff *skb)
 {
 	struct sctp_chunk *chunk = skb_shinfo(skb)->destructor_arg;
 	struct sctp_association *asoc = chunk->asoc;
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = skb->sk;
 
 	sk_mem_uncharge(sk, skb->truesize);
 	sk->sk_wmem_queued -= skb->truesize + sizeof(struct sctp_chunk);
@@ -9109,7 +9109,7 @@ static void sctp_wfree(struct sk_buff *skb)
 	}
 
 	sock_wfree(skb);
-	sctp_wake_up_waiters(sk, asoc);
+	sctp_wake_up_waiters(asoc->base.sk, asoc);
 
 	sctp_association_put(asoc);
 }
-- 
1.8.3.1

