Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB145C187
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfGAQ52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:57:28 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34426 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbfGAQ52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:57:28 -0400
Received: by mail-pg1-f196.google.com with SMTP id p10so6338608pgn.1
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=m73zpQ3RUbZ++pUg/1sY1Yqn90IGmJDz42wSnQwxdv8=;
        b=PW4FgFCAjY9nE5e+O3eeWWGWkDvBMDhgpd2UItHfNoV5l17o5TQZgacU57hCXfLb9N
         Ii+KhxeOFAK2FFkTmmh5W3OmKBepOTuBPL/qHQvjq0sYUfdflfVT3ITX1leNpfyxSTe2
         PnY8jApP/HaJZEjWoOxXkqm5aamvazJ36Ujt4sdo/Bwxue5JPa8j8pGYGVIxfGby2xn7
         /JBpPD/wX/zu5EUn3yXVdpFpesDbHG0j7tsBIYdJwV8sD81LjLoeX9g7UkTj1m2c/NQR
         xIUtRkLvu3/I9gkYIfu481+5EnfIcYM9EMiksnj/5OVwHArXjdkst+inERClxa01qx/z
         +Nbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m73zpQ3RUbZ++pUg/1sY1Yqn90IGmJDz42wSnQwxdv8=;
        b=aBtw8PwOc/2NCgD67ZXR/85BRy3E7ndJgsZXAa9zCxhVeYTCgxwqXA2lusIcPs9Ha/
         /riDdJnFDeyTaXgdFNtdia9hlftZCFnnFx9I0MBQRgF/nJIjlXnrSfZSW3AyC4xlwVV1
         CoxIn0ncdSe851kpYLCm+36w2M8ATRAzFGCy73bRl+uO37kWghig8oXYQvqUHqJqkCzU
         72vNtN6S1pJeoo00LxwRvC8/+uEskki7w9L5g9Oj8vaa49HiOjB2OyHxBKhwksezmF7u
         WcdyLiqIHmiswTFSws0m4Oy4kZS42CjmDwLSqTPf4dfJV4B0YAfFlR/zjfvXDpoIJMc3
         RUcw==
X-Gm-Message-State: APjAAAVI0nO4u2FuDVFolhrGHE1qp6a4Xv2HSu7lwXtMkm7TlHpiOVdH
        RPpxI6M71OJBchbfdWJasw3GR/5e
X-Google-Smtp-Source: APXvYqxQ9DEwe9BHXFbYddhJvnscuAWHRWt4OSTk8T4Sp4bbndoorAg8bwejImgOVyo+h6k93TemBQ==
X-Received: by 2002:a63:fa57:: with SMTP id g23mr18181559pgk.75.1562000247075;
        Mon, 01 Jul 2019 09:57:27 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p65sm11624325pfp.58.2019.07.01.09.57.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 09:57:26 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net, davem@davemloft.net
Subject: [PATCH net-next] tipc: remove ub->ubsock checks
Date:   Tue,  2 Jul 2019 00:57:19 +0800
Message-Id: <d59889f395b2c224131046c832fe1a8056209107.1562000239.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both tipc_udp_enable and tipc_udp_disable are called under rtnl_lock,
ub->ubsock could never be NULL in tipc_udp_disable and cleanup_bearer,
so remove the check.

Also remove the one in tipc_udp_enable by adding "free" label.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/udp_media.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 62b85db..287df687 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -759,7 +759,7 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 
 	err = dst_cache_init(&ub->rcast.dst_cache, GFP_ATOMIC);
 	if (err)
-		goto err;
+		goto free;
 
 	/**
 	 * The bcast media address port is used for all peers and the ip
@@ -771,13 +771,14 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 	else
 		err = tipc_udp_rcast_add(b, &remote);
 	if (err)
-		goto err;
+		goto free;
 
 	return 0;
-err:
+
+free:
 	dst_cache_destroy(&ub->rcast.dst_cache);
-	if (ub->ubsock)
-		udp_tunnel_sock_release(ub->ubsock);
+	udp_tunnel_sock_release(ub->ubsock);
+err:
 	kfree(ub);
 	return err;
 }
@@ -795,8 +796,7 @@ static void cleanup_bearer(struct work_struct *work)
 	}
 
 	dst_cache_destroy(&ub->rcast.dst_cache);
-	if (ub->ubsock)
-		udp_tunnel_sock_release(ub->ubsock);
+	udp_tunnel_sock_release(ub->ubsock);
 	synchronize_net();
 	kfree(ub);
 }
@@ -811,8 +811,7 @@ static void tipc_udp_disable(struct tipc_bearer *b)
 		pr_err("UDP bearer instance not found\n");
 		return;
 	}
-	if (ub->ubsock)
-		sock_set_flag(ub->ubsock->sk, SOCK_DEAD);
+	sock_set_flag(ub->ubsock->sk, SOCK_DEAD);
 	RCU_INIT_POINTER(ub->bearer, NULL);
 
 	/* sock_release need to be done outside of rtnl lock */
-- 
2.1.0

