Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC33E51E6
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhHJESH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbhHJER4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 00:17:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D64C0617A0;
        Mon,  9 Aug 2021 21:17:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so2484346pjr.1;
        Mon, 09 Aug 2021 21:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PIWCbgM5Czh7o4d4UfSqkTS5fg/4+RhME2M18GpOuag=;
        b=pwTexxRixX5EhmzkxTh7FMxGNvqV9ze34Qr4Bzn5NPPY6WnQRULpEnoir2DXVPpOxx
         6p+jOxunC6evidzVWTlVIcBcuRZNI8S2HWVo+bguvhlEQratAVPWIzj+KmLvqSrriqRG
         BMMdbiivUWz6RpLUp2RbojwpAugGFaUfOYbN533tcYnHY0GtnP1PHDaOlcAuurZbl9S9
         B0GDLf3tbs9KjVEL7LNnG/7WghpodWi/v6cnCfJCra5X30Emz8PyqHBCXo6u+GlkkoU3
         bp01ClAEqNzTLcXL1eiQbTqYIwZ3A7T9FM4Hp792CX0/7neCTWArq087lhcAnzkzdmgP
         JFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PIWCbgM5Czh7o4d4UfSqkTS5fg/4+RhME2M18GpOuag=;
        b=aFTK4u8s65uuhkDRj5+MsZ5lAyi8xrBzrAV+H3u857taG1jvh0DzZ4o6MaKISA2DH7
         +jGPwS1UTZUlu5S6oj61kdJsFQPB9MPAyV5sWmbJ6LPjxP4YyjDN3R/KtOK+FBnlCEzk
         Rfe8YhVxxeZ4j77s71/VTPO/v4ZFllkjHUEmyKYM/ifBt8rLMklwvzcpySKO5k+CKu5S
         annmNo23jquhe9Mz38lsdBxORlNbwwCNKOiY1jfBEgFHX7zzUiLVb4ma/5Lt9wJynvJk
         wCvEHN0i+TCVUL9OtEROVkeCb8XWDypfAbxxe5akG+vxjvSj+X1B0DR57OO4/HSJiFF9
         Uc1Q==
X-Gm-Message-State: AOAM532Z3RphCQ7NSWd7OjYSlNLmLx+O54s5k5ql89Xyd52JOcvfsjri
        pwkt2xiEevF5Rw0qiBz9Fgc=
X-Google-Smtp-Source: ABdhPJy81yXzWOUbPLBKMsCXP3TKxPGR2kEyBsjPiXG8i5OT0sgiNBZ7/dun7wF8qqDyV1S3rjlrzg==
X-Received: by 2002:a17:902:e890:b029:12c:d39d:20bb with SMTP id w16-20020a170902e890b029012cd39d20bbmr23680005plg.83.1628569039325;
        Mon, 09 Aug 2021 21:17:19 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b8sm20132478pjo.51.2021.08.09.21.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 21:17:18 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v6 3/6] Bluetooth: switch to lock_sock in SCO
Date:   Tue, 10 Aug 2021 12:14:07 +0800
Message-Id: <20210810041410.142035-4-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810041410.142035-1-desmondcheongzx@gmail.com>
References: <20210810041410.142035-1-desmondcheongzx@gmail.com>
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
index 94a3aa686556..68b51e321e82 100644
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
@@ -193,10 +193,10 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 
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
 
@@ -1105,10 +1105,10 @@ static void sco_conn_ready(struct sco_conn *conn)
 
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
 
@@ -1123,12 +1123,12 @@ static void sco_conn_ready(struct sco_conn *conn)
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
@@ -1149,7 +1149,7 @@ static void sco_conn_ready(struct sco_conn *conn)
 		/* Wake up parent */
 		parent->sk_data_ready(parent);
 
-		bh_unlock_sock(parent);
+		release_sock(parent);
 
 		sco_conn_unlock(conn);
 	}
-- 
2.25.1

