Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A273FF91D
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 05:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346912AbhICDYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 23:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346850AbhICDYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 23:24:37 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BA4C061575;
        Thu,  2 Sep 2021 20:23:38 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id t4so4522195qkb.9;
        Thu, 02 Sep 2021 20:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z2TIbdagXcaWWWrKNIoFXHmD13F3+NqjgPeng5YExhs=;
        b=FOMxo65QbZFWiuiiakd9mSMn0fT8f8fRLZCysmNZhTTkjb4QVTMTzsLc6YJI8302f5
         zVs3bKsd9DTssqTcmIXnBlv52txNJxJ0MVVqz1X7+Z0rurJAwc1ajpmbofYWrqmSwkWf
         A/aruQ3B6d7VtzC1z/cWet91FnUb+RbeCPBY0ut8m5bY7ZQwY6jcItPIiTuG3aOsnmvp
         jHDGHIj6eLGrD8jLWfB3axvlRLGiPmzDjm6hjX9HfMo211IHRjC4ZzpjbeNvG3hEIcgs
         HTJATs/syNcQilI1M1tyx7q8Q+7q79Ngtc5iySq4yyZm5FNaPCguvbIoCLz0gL9Gtegu
         KsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z2TIbdagXcaWWWrKNIoFXHmD13F3+NqjgPeng5YExhs=;
        b=CswCrSbS0wdG9W6ZTveBWMM/GfHQEvU6an0yevu4A1Wui+8zQNZ3S3evQY27/AJbgd
         GBviz5lkmq84N7n9BUVBI3Feg9E77q79QgaJ9wY64kV8kyXoLlfvHQ5AnY7ajBIi9A3j
         PUWE84qfgkkl+BYj05fMM5SNQhYPfoQQag1/rXouIzhpBITfYYBseKr7WFA6EdIyiFld
         JoOonvQurYjo8u5uylCrr3PQdLvaSg/O20SzDpoIzaEK24ksAhAQz+Wzup47yMAxCtpU
         DEHVVtNSoJvvVOI+lSJZ+46XGv2cCiLO/ofbEYfjgs9TVNoWS3ydrZGjMpbQcscOEagr
         Ampw==
X-Gm-Message-State: AOAM533Hnd5AUhLC4vtZ0ypJvJxtUBkd8B5FI5zXNB7aCWH7Z6aIP2Zc
        uxzkNOhMaLVymm+iV6cy2lE=
X-Google-Smtp-Source: ABdhPJyZ1UhzB071YjvxohQuczY3hJrv5OHltRis3AVKMf7YIxLRgrP6r3MTtzeQLX6/bJlL7dkBKQ==
X-Received: by 2002:a37:634d:: with SMTP id x74mr1323996qkb.453.1630639417541;
        Thu, 02 Sep 2021 20:23:37 -0700 (PDT)
Received: from localhost.localdomain (pool-72-82-21-11.prvdri.fios.verizon.net. [72.82.21.11])
        by smtp.gmail.com with ESMTPSA id v5sm2984729qkh.39.2021.09.02.20.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 20:23:37 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: [PATCH 2/2] Bluetooth: fix init and cleanup of sco_conn.timeout_work
Date:   Thu,  2 Sep 2021 23:13:06 -0400
Message-Id: <20210903031306.78292-3-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210903031306.78292-1-desmondcheongzx@gmail.com>
References: <20210903031306.78292-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before freeing struct sco_conn, all delayed timeout work should be
cancelled. Otherwise, sco_sock_timeout could potentially use the
sco_conn after it has been freed.

Additionally, sco_conn.timeout_work should be initialized when the
connection is allocated, not when the channel is added. This is
because an sco_conn can create channels with multiple sockets over its
lifetime, which happens if sockets are released but the connection
isn't deleted.

Fixes: ba316be1b6a0 ("Bluetooth: schedule SCO timeouts with delayed_work")
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/sco.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 4a057f99b60a..6e047e178c0a 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -133,6 +133,7 @@ static struct sco_conn *sco_conn_add(struct hci_conn *hcon)
 		return NULL;
 
 	spin_lock_init(&conn->lock);
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
 
 	hcon->sco_data = conn;
 	conn->hcon = hcon;
@@ -197,11 +198,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_chan_del(sk, err);
 		release_sock(sk);
 		sock_put(sk);
-
-		/* Ensure no more work items will run before freeing conn. */
-		cancel_delayed_work_sync(&conn->timeout_work);
 	}
 
+	/* Ensure no more work items will run before freeing conn. */
+	cancel_delayed_work_sync(&conn->timeout_work);
+
 	hcon->sco_data = NULL;
 	kfree(conn);
 }
@@ -214,8 +215,6 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	sco_pi(sk)->conn = conn;
 	conn->sk = sk;
 
-	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
-
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
 }
-- 
2.25.1

