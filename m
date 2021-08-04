Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B8D3E04C6
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbhHDPtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239479AbhHDPtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:49:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AE3C06179C;
        Wed,  4 Aug 2021 08:48:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so9345165pjb.2;
        Wed, 04 Aug 2021 08:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wuePCI4FbrrQHwWiYSThmxmEPxR9cgsWrPSKODj9+7k=;
        b=Jk784znaiM1kGzC+vnzHdPjoAikvb+/ECITQ/3FZg8UstIATIWcr++9Q07PlDBGGUP
         NaZtAJZxRgmuzD+K9iINe2MVdgMb/mgSYE/C/Bj76UmTmdwi8fd4jpzmmZwJDsK1FOA/
         a6dIAUbVehG2bmaGv8ISzhb4xGtOcaZUzaalkdrxO2XVqvlcDExhETpIyboptcHOh8Cw
         XGe8dv2qSlS0DpWz90Zb4PazuyjhgB35oqbYaygVIa9pkCAPFPhgyAlKD7EyNJ7bk6Jj
         b5pKYzVPji6Uy6hl0KdqHbU2d3BwrafaePd/GBBvDmVkIUQ7XGPqigf2ODNoQWg3Ubwz
         Qe3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wuePCI4FbrrQHwWiYSThmxmEPxR9cgsWrPSKODj9+7k=;
        b=EjWL80D/ydqnn5GsSiF/C/599CQpJArwtzlwSHR83zbR0fb+S/WKd//nuFdkHQTxd7
         rWAlaYWr6FDWdlcf5axDQ16HkW+lgb2CVM8O7/MCvJdnNAzN0/uvJ7K3r44Mvmkiabt5
         /aNpvrhI4zbwbxa9wZMKkt4nDL79Qjy3Oefpx+VxuTen+twXnmUqyqWN67EJP9+XlLTB
         shelGalwSYclkn/FolGNwhKwBbftgZK4X/7Y1kyajUgYL2iVdLWf4NI+kSZz09ZkQvW7
         05YSTgCUsy5rHDwi0ike/xsJrmxI1dnopT9uEmU6G6PqEXdi4dtQBHXzKIr0QQFKlgWn
         pBjg==
X-Gm-Message-State: AOAM533HWHdH3gYDmID0+Kgy9DCj7P0KyKxMnDcdnr4qlyy/z9ugbu2D
        W7hr7kkPnLHsj3b0oIfPOc8=
X-Google-Smtp-Source: ABdhPJzBS90sEosr/ccisMXoi2vHaMJWErjhjg312/0a223eplEcJU9XDsNw708hnm0IgxN4KHWaXA==
X-Received: by 2002:a17:90a:3fcc:: with SMTP id u12mr9997143pjm.5.1628092128953;
        Wed, 04 Aug 2021 08:48:48 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b15sm4007274pgj.60.2021.08.04.08.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:48:48 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [RESEND PATCH v5 4/6] Bluetooth: serialize calls to sco_sock_{set,clear}_timer
Date:   Wed,  4 Aug 2021 23:47:10 +0800
Message-Id: <20210804154712.929986-5-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804154712.929986-1-desmondcheongzx@gmail.com>
References: <20210804154712.929986-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, calls to sco_sock_set_timer are made under the locked
socket, but this does not apply to all calls to sco_sock_clear_timer.

Both sco_sock_{set,clear}_timer should be serialized by lock_sock to
prevent unexpected concurrent clearing/setting of timers.

Additionally, since sco_pi(sk)->conn is only cleared under the locked
socket, this change allows us to avoid races between
sco_sock_clear_timer and the call to kfree(conn) in sco_conn_del.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/sco.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 1246e6bc09fe..418543c390b3 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -459,8 +459,8 @@ static void __sco_sock_close(struct sock *sk)
 /* Must be called on unlocked socket. */
 static void sco_sock_close(struct sock *sk)
 {
-	sco_sock_clear_timer(sk);
 	lock_sock(sk);
+	sco_sock_clear_timer(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
 	sco_sock_kill(sk);
@@ -1110,8 +1110,8 @@ static void sco_conn_ready(struct sco_conn *conn)
 	BT_DBG("conn %p", conn);
 
 	if (sk) {
-		sco_sock_clear_timer(sk);
 		lock_sock(sk);
+		sco_sock_clear_timer(sk);
 		sk->sk_state = BT_CONNECTED;
 		sk->sk_state_change(sk);
 		release_sock(sk);
-- 
2.25.1

