Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4145C58EA73
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 12:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiHJK2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 06:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiHJK2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 06:28:54 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE937822C
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:28:52 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id k26so26905385ejx.5
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Z4TBiHYZa5cQdOCeu843UgGsBkLEynXkB3CX7pAAB9A=;
        b=V1m6l0b5YriI1FTgHLiyoa5hiCu5qML/yv8tjy+eNeZ4uovOnkFlnqIHbSJT7ZK1ue
         ETiHZz4FsUBri7iZ5MgTwXaLMmRZDCft+Wk8Ht4B78BQpWG9UFkJaxSd1gcIHE4LzkXo
         GXS4ZmBsWlc57EiBFY5IsqeKp3fUts9QB3Npk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Z4TBiHYZa5cQdOCeu843UgGsBkLEynXkB3CX7pAAB9A=;
        b=6t18NZFkMFJVK6cwKTuy+Oc+pn+S5396yyeBb6GowC70lQOD3CkxgTA64Aygz70kco
         ErkFo1+BBACrvovXCLebmEBcaQplGb4r/W+zCFDUQ6cHcXK2hnFMazAPF0w/3/bWvfad
         GA25xgbo52ku/C641Kll+FJtWMaD4fZQr9lmGJe59A14p5prgdRJ0CeOdeSX2wD+H3mX
         Y56Hox4PIt8e2blNKvj1GHUq2g/9xR1yz+DvuUMt06HAhEYpEyydinltaNRW6jvTZ1Jd
         NhmTjPf0LI8Uaceb4H/KrDiXoIXitxu0s9UyFcQuyJpQI1gHiCisFfI1mYRmhD12hVwU
         vDjQ==
X-Gm-Message-State: ACgBeo1D69cwAy2HC87Q/j/+GFw9tOpEibmdVnNoVwlW015pGLyR68Rp
        kgstRsTBUAowBByeuixPxofx3qOMbyXigQ==
X-Google-Smtp-Source: AA6agR5T3ev7EsAH4p/lOtkqWiMgrQGUOrdpKe00VXpisEPsmcxBD+ghODZSYTiq03UyFLWlIqu6uw==
X-Received: by 2002:a17:906:8477:b0:730:a658:b286 with SMTP id hx23-20020a170906847700b00730a658b286mr20077065ejc.646.1660127330588;
        Wed, 10 Aug 2022 03:28:50 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id x24-20020a170906149800b00705cdfec71esm2169894ejc.7.2022.08.10.03.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 03:28:49 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, van fantasy <g1042620637@gmail.com>
Subject: [PATCH net] l2tp: Serialize access to sk_user_data with sock lock
Date:   Wed, 10 Aug 2022 12:28:48 +0200
Message-Id: <20220810102848.282778-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk->sk_user_data has multiple users, which are not compatible with each
other. To synchronize the users, any check-if-unused-and-set access to the
pointer has to happen with sock lock held.

l2tp currently fails to grab the lock when modifying the underlying tunnel
socket. Fix it by adding appropriate locking.

We don't to grab the lock when l2tp clears sk_user_data, because it happens
only in sk->sk_destruct, when the sock is going away.

Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Reported-by: van fantasy <g1042620637@gmail.com>
Tested-by: van fantasy <g1042620637@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/l2tp/l2tp_core.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7499c51b1850..9f5f86bfc395 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1469,16 +1469,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock = sockfd_lookup(tunnel->fd, &ret);
 		if (!sock)
 			goto err;
-
-		ret = l2tp_validate_socket(sock->sk, net, tunnel->encap);
-		if (ret < 0)
-			goto err_sock;
 	}
 
+	sk = sock->sk;
+	lock_sock(sk);
+
+	ret = l2tp_validate_socket(sk, net, tunnel->encap);
+	if (ret < 0)
+		goto err_sock;
+
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
 
-	sk = sock->sk;
 	sock_hold(sk);
 	tunnel->sock = sk;
 
@@ -1504,7 +1506,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
 	} else {
-		sk->sk_user_data = tunnel;
+		rcu_assign_sk_user_data(sk, tunnel);
 	}
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
@@ -1518,6 +1520,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
+	release_sock(sk);
 	return 0;
 
 err_sock:
@@ -1525,6 +1528,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock_release(sock);
 	else
 		sockfd_put(sock);
+
+	release_sock(sk);
 err:
 	return ret;
 }
-- 
2.35.3

