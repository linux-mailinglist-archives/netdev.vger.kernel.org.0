Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B172518043F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgCJRCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:02:54 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55907 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgCJRCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:02:54 -0400
Received: by mail-pj1-f66.google.com with SMTP id a18so678580pjs.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 10:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=TdfByhLDihckpvfagXIJxLA6PemvneEJtXlhdTlGLBw=;
        b=tfy4izFxXZr0yVFbr6qxBd/vbV/8DHryCl7rQwkN6BH3vw9GeJmnKH3v3/4zH+JIon
         QgWrJYXz5hO9oBOFPzqinXAf0gFIjKK1A1Px2NK/ooB1gVZSX65RJMjnzSBRNykR5uEV
         Bl7ca7rtjo+sqXuB9zyDGQ6iHVfY17vSW1YY2E/OPggE47JBmxhmnxqDjaFzs8wjE2To
         2r+QrbcY4AUYJ7Wp4Vhzz9REidA+GnbrO4kIwkHjy1y+mdZRDuJqnYmxXc47D1xAkYuw
         okqSwxduvoXcB6sbg9nkrie8oyyv1ZC72CMapC1MvfbkxCZzOEqzExRk/Fpd1KRMeOta
         hEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=TdfByhLDihckpvfagXIJxLA6PemvneEJtXlhdTlGLBw=;
        b=SvspkEZbqVzrqz4IlBD/EQHBMzgDWCERZAr8VVoHgRLbMP6SujtsWDTabEMF6nKtd5
         pjCNDI0r9Gs8W+X+NH7J94FR5MQZyPdAEiTTfcot43fBMg9+QbCii7/H4Zp1ayFAFLlD
         T2taRLjwQYbVUWdBMLbr9QFyhapNBa4wybCQt07dTO3qF+Tv4f5JD0ZhNQvjbDo/oJeq
         7OtK8dJCPtE5oor/6KbR4cLcs5HYrzZkxhUyRuF5kTi2eDtwVQX7Be9wP7U/XQkBzXsJ
         0KvWk0D44pFhtggYBESiJtIAAL1vROjECMnXdAmc0kqEhXhgii4GNM5uyMHAKnpwqILq
         b2eg==
X-Gm-Message-State: ANhLgQ3pUwQFZHpR7Tar8mgZccpHxMtlL4PRT/VWCm1ZCzXfO49Bpz/L
        dpzGHViVWIItTRghI3P/xIkKaeHRVq8=
X-Google-Smtp-Source: ADFU+vt4HGtZjGgJSrKqr5TvomZlbp7wfZJTuybHwhHUz6TN9CYj8N/SHzOo5G+qETzinotFbJaA1g==
X-Received: by 2002:a17:90a:7187:: with SMTP id i7mr2691936pjk.6.1583859772809;
        Tue, 10 Mar 2020 10:02:52 -0700 (PDT)
Received: from localhost.localdomain ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id e15sm6384835pgr.60.2020.03.10.10.02.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 10:02:52 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        martin.varghese@nokia.com
Subject: [PATCH net-next] bareudp: Fixed bareudp receive handling
Date:   Tue, 10 Mar 2020 22:32:40 +0530
Message-Id: <1583859760-18364-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

Reverted commit "2baecda bareudp: remove unnecessary udp_encap_enable() in
bareudp_socket_create()"

An explicit call to udp_encap_enable is needed as the setup_udp_tunnel_sock
does not call udp_encap_enable if the if the socket is of type v6.

Bareudp device uses v6 socket to receive v4 & v6 traffic

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
Fixes: 2baecda37f4e ("bareudp: remove unnecessary udp_encap_enable() in bareudp_socket_create()")
---
 drivers/net/bareudp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 71a2f48..c9d0d68 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -250,6 +250,9 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
 	tunnel_cfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
 
+	if (sock->sk->sk_family == AF_INET6)
+		udp_encap_enable();
+
 	rcu_assign_pointer(bareudp->sock, sock);
 	return 0;
 }
-- 
1.8.3.1

