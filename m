Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800F5117DD8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 03:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfLJCmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 21:42:49 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35243 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfLJCms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 21:42:48 -0500
Received: by mail-pl1-f194.google.com with SMTP id s10so6647649plp.2
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 18:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UGkMwhNrzg0G5Sg3aOYCNrL8WQaNG3IAsZb51Z5iri0=;
        b=MbllKa6s0an6YAbMpG2rW3n9tlpBBcJ/VlpeHuq9DkADaqeW1RABoeo0N92xBMCVu1
         gDIpSJkuLYaZx2tOzexP1UgefNzgHSfHk8DXCmcMGm5/KBMvFlXzJ0Rhj0GlXDcSsGd0
         Izz4tTF4gnKkH1rVrKGKtHcxpt3Kit4yHPrJ96uD6lQgMDHmq3rCiTqZazh44Sxz4oOX
         xrNKvHpwusD+SKiOuQsyEnOb5p9751rkiKP7rD4MJHjPU9Kv5ME7RM4MrRP5ChnK3JmU
         wVFJWfXbRXRGdnGuQ4D2Gr5qvMYiSyCAhzswBAXLgbhkCV97FkJObfCfCZLqhKj5XTs6
         YEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UGkMwhNrzg0G5Sg3aOYCNrL8WQaNG3IAsZb51Z5iri0=;
        b=QZsxgs5PiwF+gTC/n5h1FzO+U4tNdXkOuvxpG3g2LxK4+5rRbc/dsAEdEW0yH1lf74
         G03HyDtvc7Y3RUn93e2iHj4JRspamLbaX428tD/m7A1HmTeaWPZfg9jY/4R09o9Weh44
         5j0q/qr/DloIiJ/9dFtQ15tfxH9qhBJCzA6Qc6RRYnpq0gKzWmSBBMvkGOm1OBgWWTRG
         rGdeIt5zxD0UyYRB6KQ75iOhQ514dRm7u8IrE4nf1KGExFzu+2zOcpjuoccHQ/EKgBqJ
         +pCJZcg+Z+r93OknuQLi0/jFqouJ0/cJAzPdJTyRsVRtB3CnZqR2EvYZZoKPlYcYmoN0
         RwDQ==
X-Gm-Message-State: APjAAAVXd4G1NdOKxcf3Uf90Mqr3i0S0gViOlo0R3aKbCxp/jvCpgFqw
        UM5n8L71PJ+Cn8aTIuwt9Q==
X-Google-Smtp-Source: APXvYqz8TqkEQIS3mowh0BPTKudBu9D8KnJeV0EqBbauZYh8wC4gnvVsQStLl1Sfb8LRISEHiVA7cg==
X-Received: by 2002:a17:902:8306:: with SMTP id bd6mr33517680plb.303.1575945767974;
        Mon, 09 Dec 2019 18:42:47 -0800 (PST)
Received: from ip-10-0-0-90.ap-northeast-1.compute.internal (ec2-52-194-225-234.ap-northeast-1.compute.amazonaws.com. [52.194.225.234])
        by smtp.gmail.com with ESMTPSA id y38sm860805pgk.33.2019.12.09.18.42.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 18:42:46 -0800 (PST)
From:   kuni1840@gmail.com
To:     davem@davemloft.net, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, kuniyu@amazon.co.jp,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Subject: [PATCH v2 net-next] tcp: Cleanup duplicate initialization of sk->sk_state.
Date:   Tue, 10 Dec 2019 02:41:48 +0000
Message-Id: <20191210024148.24830-1-kuni1840@gmail.com>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuni1840@gmail.com>

When a TCP socket is created, sk->sk_state is initialized twice as
TCP_CLOSE in sock_init_data() and tcp_init_sock(). The tcp_init_sock() is
always called after the sock_init_data(), so it is not necessary to update
sk->sk_state in the tcp_init_sock().

Before v2.1.8, the code of the two functions was in the inet_create(). In
the patch of v2.1.8, the tcp_v4/v6_init_sock() were added and the code of
initialization of sk->state was duplicated.

Signed-off-by: Kuniyuki Iwashima <kuni1840@gmail.com>
---
 net/ipv4/tcp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8a39ee794891..09e2cae92956 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -443,8 +443,6 @@ void tcp_init_sock(struct sock *sk)
 	tp->tsoffset = 0;
 	tp->rack.reo_wnd_steps = 1;
 
-	sk->sk_state = TCP_CLOSE;
-
 	sk->sk_write_space = sk_stream_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 
-- 
2.17.2

