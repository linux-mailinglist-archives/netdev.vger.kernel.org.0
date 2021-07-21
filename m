Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6BD3D0B63
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 11:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbhGUIix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 04:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238159AbhGUIZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 04:25:44 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8FDC061574
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 02:06:19 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id a6so1275464pgw.3
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 02:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j+YeTU4Z4GeNADjUpvlf1LXOdoqL7nhVd6Ldmr5c+tU=;
        b=UhCsn0ggojdUmIpE2/H3RSvF8mXliP8Uxtt8Fs+ByMdmFQL3dp+Kj4iB6//9XxKT5u
         Xpa9mYeY81wFebtlVVP72J/sogsGM4MVXlK4XUp1G+/LDCV0kjv9V0H15V+LO/w0qySF
         ovwjTn8TGo+yXxbZV5+6N2WXOvR8LZZcLi9IqdXNJfdwLhXhqsLhfEhn/ijk77bpwPH9
         psBRqj5X0oKIZest5eGbXFZMp+TsCCswx6xNq+GFW2+/YRa5Ug0j8yu+5OkL7CV9Tcm3
         fCEdLRF5fObxV2urTcaCYCXHy2xW+zmk3Au02dT37BDL/F6U1zfgHmOzRYc6kCImORVB
         3Jyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j+YeTU4Z4GeNADjUpvlf1LXOdoqL7nhVd6Ldmr5c+tU=;
        b=tUh8/PyB5CNDk4nn2FE0c+nXm7TKHNd2On5qOOrdGDfDz/M75ACatiy7rwNnk0+s+H
         aRvkOeyDGYpzy6hssbNZtF7fJKemTf+NjIv8J867WUKKrKAICnZ8sXlNlr+Oudx3/7iM
         dpWV7UJ2oevZftuxhe/ZyJlQIQdWts4xDxckiaYhPPOLXEIZMiqSroz4UqXqwoKVh0Yf
         RJBEwi3U97qYYB1ta3oQ+jtL55/r8lKmIfwnv1Ee4FUQyQCYvYkxrboiYeJaTG8EK+kR
         s4NicWtJ5hyKAHPOlfDsxoY3quRNRd8OQbwucycxbe/a9vwIeEdFMhMhhCSFL/OCImXe
         N7gQ==
X-Gm-Message-State: AOAM533/ScpADXtIcpzgijXKUaLDxfLRhcyyp0Ia3M9arHtHRNdgawWe
        ke3gF4REKDMzwDP0YT7jlzA=
X-Google-Smtp-Source: ABdhPJwX+eEOMaIVhs0+oNGmurHeD2GZsXJ9ZOGGeggE980WccVAKkRxqOnyTNmVIeIzVcW9/oxGYQ==
X-Received: by 2002:aa7:95a1:0:b029:359:ca4e:d25d with SMTP id a1-20020aa795a10000b0290359ca4ed25dmr628793pfk.51.1626858379059;
        Wed, 21 Jul 2021 02:06:19 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7460:f7c2:e664:b708])
        by smtp.gmail.com with ESMTPSA id l2sm25592244pfc.157.2021.07.21.02.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 02:06:18 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] tcp: avoid indirect call in tcp_new_space()
Date:   Wed, 21 Jul 2021 02:06:14 -0700
Message-Id: <20210721090614.68297-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For tcp sockets, sk->sk_write_space is most probably sk_stream_write_space().

Other sk->sk_write_space() calls in TCP are slow path and do not deserve
any change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 149ceb5c94ffcd4499d3054fae31bd296a9e0bcd..bef2c8b64d83a0f3d4cca90f9b12912bf3d00807 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5383,7 +5383,7 @@ static void tcp_new_space(struct sock *sk)
 		tp->snd_cwnd_stamp = tcp_jiffies32;
 	}
 
-	sk->sk_write_space(sk);
+	INDIRECT_CALL_1(sk->sk_write_space, sk_stream_write_space, sk);
 }
 
 static void tcp_check_space(struct sock *sk)
-- 
2.32.0.402.g57bb445576-goog

