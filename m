Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D296B3DFFD7
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbhHDLE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbhHDLEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 07:04:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51BAC0613D5;
        Wed,  4 Aug 2021 04:04:09 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so3069167pjd.0;
        Wed, 04 Aug 2021 04:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TRKYkdOIgWJ5EiGOGovL7BoCL888xKaE/ywEpPEztaE=;
        b=Nnd8twf4rEgY2TlB+F0iTD+c7owlni5fLgZW89siB3upvnIKQhe1SVLxBm6ttpBBKQ
         zYMGghl8Dr6byrvyPW/fGv9Mz8OeXmaE0eux/tauYcYCPVcNUTP5z+Kc7kPM/9pCU4EU
         7aIJVDH4IC/egfbrCULR7SNLwJZaQqlFQjAnxNBE24KOsGSydQ8uftEs8A157SgvMfRC
         9XYoRlA2Mv2Zkc3lmQSRKjo7KjZsFnRcSk6hJGEGkJWzq9iLY/xr8xUteH0HzQ4cJkNt
         oLcYfUZpO8KAdwPA7n3pE8lkaLjzNMVFtT9yvEoXjOltgPiqSxE/r7At3QGWGISwcdp9
         laaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TRKYkdOIgWJ5EiGOGovL7BoCL888xKaE/ywEpPEztaE=;
        b=ffhusX4xDmYVJN2Z+ToYSWku5tO+Vo+Ez0Ne4hIKde9VitrfoZBW7N7mElv/Fsf8W7
         /KfvSU8gh4dKGhR8EI67Bxr6uCbpZ23qx1yHQOIhnYgNjNQJWTgAdLkyZaqoaD/hVhP3
         i4bVXETgvtNDKgu4KS/CEtnZjVzEPNG15ArkAxitj9WSWMS5WtxRtfTkQUik7YU+lQQ+
         FmACCivYt4EaRWNcJzlu6xHHorrudNE81ymj370xxP4s4yIcG+k0BjDn40XL6diNVA9A
         9lH9OEGSBI4D3z59rhY6uv96L32XityDcnpEePTqMy6q++iM0v6x6zW0yzc/eZLhlOlt
         WegA==
X-Gm-Message-State: AOAM532cu3uZGL6r41PLvSZ2I9wCAekhETIIaTUE2I4PeRvSmrcb4n/c
        eLPwiXNMnOCHI5jB052Edng=
X-Google-Smtp-Source: ABdhPJyyxVGnR/0AchNWivoqpbLq+TyM45ed7PlSNndLnq22S/qQ5HnA87pIpqEOgWKXrrN+gBtL0Q==
X-Received: by 2002:a62:17d8:0:b029:3b1:c2b0:287c with SMTP id 207-20020a6217d80000b02903b1c2b0287cmr23906446pfx.23.1628075049278;
        Wed, 04 Aug 2021 04:04:09 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id k4sm2206147pjs.55.2021.08.04.04.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 04:04:08 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v5 3/6] Bluetooth: switch to lock_sock in SCO
Date:   Wed,  4 Aug 2021 19:03:05 +0800
Message-Id: <20210804110308.910744-4-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804110308.910744-1-desmondcheongzx@gmail.com>
References: <20210804110308.910744-1-desmondcheongzx@gmail.com>
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

