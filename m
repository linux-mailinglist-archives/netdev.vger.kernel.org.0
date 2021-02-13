Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187B331AC3D
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBMO1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 09:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhBMO1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 09:27:20 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035E3C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 06:26:39 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id cl8so1218833pjb.0
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 06:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J8Ta1yDXeqpmb6T1Nr8l1AmKwNzd7v9zbe1u35MIaOM=;
        b=MlhbhwVPije/YrBbXIAzetbvKgDbLfGz+XPdfsRmY4GHzmqbnh3XDrmDse3nb117rb
         XMh+Uf4yo/IJVL07mW+RaIbt/lDDQm0qJiWJB5v72SvOCNCcyj603c1VY4D3iIErvB2j
         KtIgBe8gJruiewpz/DjcOTlJa02nb7kndsLAVR4vvCHL5m59BkvxoIQ1WMW4p/f2Ga80
         pg32HY4R6uyxkTxkgO+LZNgA9+w0HhzFSYaT+XxsOSBsuhHAgBIDrLYTjbSLmmfI62CF
         RvUJ2jobEM3aYJvjqdlKnkrUcHZ5MYQFr0szxeLy6wbws9oJSQwlkcHmCSmHJURas0Ka
         LZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J8Ta1yDXeqpmb6T1Nr8l1AmKwNzd7v9zbe1u35MIaOM=;
        b=K9h1vbBWX4MZrm5gzIGIOH3LxbgiYez5iQviDF+RhepNrT4HIOck3v5vAChF5hOiZN
         iiZwPvTrVXQ1OK1YeBVpC4YtimB8LBEw00H4Vddp0DELvIo7HO+p5/58IinbgIrlZTSg
         oMcjDsoz+rjJ3CcrgZjOMhIhGWfAqdRY80svws1raZC+8MnS95v1IQvHZf/RDnf/RNzy
         W9iWIqH1c3Y3AcE+SiMn0blwg/TnWdvobO/VLeJlDFYNTGQafaa8RM4BbajqgsHZE8f3
         JRq90FDxj5MJJjJHUpfAHUFB3VdSUx5CqOVUD0ECtvJ5iYIawnrbwepEAJKbw6M1KIQj
         7alQ==
X-Gm-Message-State: AOAM532WAVB1tig4ENAWO7jb8zZkkWE7xmA7Uy3tJuvRXZNOZ4DcGv+B
        grKWEdDS2Vk5WSJn4Qb39o4=
X-Google-Smtp-Source: ABdhPJy55TRpen5aoMGLLUz4OEWzn4RzOKFq8b/29ChFd4Q/uzkyeVSKz+C0q/F+QeXQMpz4/ksmZA==
X-Received: by 2002:a17:902:26a:b029:e2:f436:15d8 with SMTP id 97-20020a170902026ab02900e2f43615d8mr7222349plc.31.1613226399464;
        Sat, 13 Feb 2021 06:26:39 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:449f:1ef7:3640:824a])
        by smtp.gmail.com with ESMTPSA id v23sm12361589pgo.43.2021.02.13.06.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 06:26:38 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wei Wang <weiwan@google.com>, Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next] tcp: tcp_data_ready() must look at SOCK_DONE
Date:   Sat, 13 Feb 2021 06:26:34 -0800
Message-Id: <20210213142634.3237642-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

My prior cleanup missed that tcp_data_ready() has to look at SOCK_DONE.
Otherwise, an application using SO_RCVLOWAT will not get EPOLLIN event
if a FIN is received in the middle of expected payload.

The reason SOCK_DONE is not examined in tcp_epollin_ready()
is that tcp_poll() catches the FIN because tcp_fin()
is also setting RCV_SHUTDOWN into sk->sk_shutdown

Fixes: 05dc72aba364 ("tcp: factorize logic into tcp_epollin_ready()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Wei Wang <weiwan@google.com>
Cc: Arjun Roy <arjunroy@google.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e32a7056cb7640c67ef2d6a4d9484684d2602fcd..69a545db80d2ead47ffcf2f3819a6d066e95f35d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4924,7 +4924,7 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 
 void tcp_data_ready(struct sock *sk)
 {
-	if (tcp_epollin_ready(sk, sk->sk_rcvlowat))
+	if (tcp_epollin_ready(sk, sk->sk_rcvlowat) || sock_flag(sk, SOCK_DONE))
 		sk->sk_data_ready(sk);
 }
 
-- 
2.30.0.478.g8a0d178c01-goog

