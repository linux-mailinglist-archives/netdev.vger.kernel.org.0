Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94AE3E04BF
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbhHDPtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239456AbhHDPs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:48:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B05FC0613D5;
        Wed,  4 Aug 2021 08:48:44 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so4188327pjb.2;
        Wed, 04 Aug 2021 08:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TRKYkdOIgWJ5EiGOGovL7BoCL888xKaE/ywEpPEztaE=;
        b=nGMnEBdsX4+MpiNfdvpcYZqkEXFJ4tGdh6hc/ltfFv7odyfHgRyqi3UYjNi9PRnx67
         YiVXS1xjUN9bFFrqHRt2ROQzvhtI9acxdZfguDZsnIA/Vf9kKZQGTyjuQXqcZhNvjF7j
         9xecdG/MkBcM/0CCWaBmiC5IvKJW+hXe5Hi09/awZOGg2YGlYNTOV3QPiPikv7QzChTA
         rwTdzsmSNMzcbyTFvR9QM1rcpiKsDcxxGASQRz+brZIY5M7vIVMQyj2zadSk/FXtMfP2
         zV8SY7Tr4vL8lZLL7MQ9JZ5oke67NmQnJwH/h9FdEdDq3mrSxfbzRozaDiJJ836PZSt9
         +ekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TRKYkdOIgWJ5EiGOGovL7BoCL888xKaE/ywEpPEztaE=;
        b=UxTVURf896xassJYsF4eDci21YCe3rbaXMmFsUAi8Vh2Ab+Q7F7u9/5GUbuARF3oMi
         gIRKoc7TcUCODDFdR8kUVip+mWtp0Wfg6PrkZ0dOllJ9gHW2Y7kyEF3JKMAd1gBwaXfy
         kESjfOG5mRaDz4DIHAEyf372aJSzI/7DM9R0ZwlEmGX4L0mpahcl3yWJMllEO/Q+I1cy
         SlGubvpRFnlDTuIRLntjhUhb4q+TGWTIRbXizxMjvEWC1CiH4tU0H3yAkRrHFsLeP0lO
         iBKtXKiccU6okRwl06CFNeTURfTRH2bPBRSG9Hpnk6ksoEcC/6Bb3LgDzZjxLgHAZlIm
         hUeg==
X-Gm-Message-State: AOAM533WesUG2opAQbeWR84TzJhmZ2vUqOJBnf/WbgOvUxik58sfA1uJ
        uHV0szckDgJOxpIB+CT1cf4=
X-Google-Smtp-Source: ABdhPJx42+g+x6dssj4TwISrbE5rseWzNenVqgOxng0l8sgY84Zpv57p0+bxmSe2pIZp5b98W4jm0w==
X-Received: by 2002:a05:6a00:888:b029:3c3:ff1:38e with SMTP id q8-20020a056a000888b02903c30ff1038emr10350145pfj.17.1628092124217;
        Wed, 04 Aug 2021 08:48:44 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b15sm4007274pgj.60.2021.08.04.08.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:48:43 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [RESEND PATCH v5 3/6] Bluetooth: switch to lock_sock in SCO
Date:   Wed,  4 Aug 2021 23:47:09 +0800
Message-Id: <20210804154712.929986-4-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804154712.929986-1-desmondcheongzx@gmail.com>
References: <20210804154712.929986-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since sco_sock_timeout is now scheduled using delayed work, it is no
longer run in SOFTIRQ context. Hence bh_lock_sock is no longer
necessary in SCO to synchronise between user contexts and SOFTIRQ
processing.

As such, calls to bh_lock_sock should be replaced with lock_sock to
synchronize with other concurrent processes that use lock_sock.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/sco.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 558f8874b65e..1246e6bc09fe 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -93,10 +93,10 @@ static void sco_sock_timeout(struct work_struct *work)
 
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
 
-	bh_lock_sock(sk);
+	lock_sock(sk);
 	sk->sk_err = ETIMEDOUT;
 	sk->sk_state_change(sk);
-	bh_unlock_sock(sk);
+	release_sock(sk);
 
 	sco_sock_kill(sk);
 	sock_put(sk);
@@ -199,10 +199,10 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 
 	if (sk) {
 		sock_hold(sk);
-		bh_lock_sock(sk);
+		lock_sock(sk);
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
-		bh_unlock_sock(sk);
+		release_sock(sk);
 		sco_sock_kill(sk);
 		sock_put(sk);
 
@@ -1111,10 +1111,10 @@ static void sco_conn_ready(struct sco_conn *conn)
 
 	if (sk) {
 		sco_sock_clear_timer(sk);
-		bh_lock_sock(sk);
+		lock_sock(sk);
 		sk->sk_state = BT_CONNECTED;
 		sk->sk_state_change(sk);
-		bh_unlock_sock(sk);
+		release_sock(sk);
 	} else {
 		sco_conn_lock(conn);
 
@@ -1129,12 +1129,12 @@ static void sco_conn_ready(struct sco_conn *conn)
 			return;
 		}
 
-		bh_lock_sock(parent);
+		lock_sock(parent);
 
 		sk = sco_sock_alloc(sock_net(parent), NULL,
 				    BTPROTO_SCO, GFP_ATOMIC, 0);
 		if (!sk) {
-			bh_unlock_sock(parent);
+			release_sock(parent);
 			sco_conn_unlock(conn);
 			return;
 		}
@@ -1155,7 +1155,7 @@ static void sco_conn_ready(struct sco_conn *conn)
 		/* Wake up parent */
 		parent->sk_data_ready(parent);
 
-		bh_unlock_sock(parent);
+		release_sock(parent);
 
 		sco_conn_unlock(conn);
 	}
-- 
2.25.1

