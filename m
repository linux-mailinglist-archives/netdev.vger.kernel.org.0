Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1556CAE08
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388583AbfJCSTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:19:45 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33390 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387866AbfJCSTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:19:44 -0400
Received: by mail-qt1-f195.google.com with SMTP id r5so4986562qtd.0
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 11:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QBQmvWk1kjVm3cYn2myGokbJMq+ScUnWxtOGmgaWdvc=;
        b=PzMsYJF45reyvsVm5wQ7X4Hy+OBVfbwkvS1XDJTTjHlIpoU0mZVfw2zaWvPo/4aY7P
         mBf5uKr7G5yWc3x2/da3U2cl1xwiZt+pFakWBhFd51LuU3xXvBNsj9SloO17RIe8mWXw
         6U9FeaXEVlreb5iXP052ySsGf1DydDozy3Crn7jMLyT+HHz6/Eh1O2p+dp463dAkyMO3
         FTXaO+2AnjaVwu8TfvCcp3iNiwdjrJQcwg1ivUnb7InRpU8VbiPNyft2meLPLCrDj8Ey
         v1SaFJMqV9Y7QKEK9GG6M/aGSR6q5BCQua/Qg38hgfuNV656CLq2RijJwHyVQk3ERiS8
         VNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBQmvWk1kjVm3cYn2myGokbJMq+ScUnWxtOGmgaWdvc=;
        b=C5kM0KzVCVK3p/1JpKPlWLA4gHSK9AkmMXEIBt4qjujGN/gVwAM0qS+AmTMpA9hHLJ
         oBqqX91eSF5hyMiiJe77ZiYKsIWWfDaSqwe42J5rnRGPsIO9iMDbDlWqIDoe4QTbP7Xw
         +BKX+2L+oavsLsj9ucvJ5FGK4AorCgsQBVEFzyzdQKqI1gYvP3L3SK1TtP5+dogU7hhX
         R+lbzKniUl0toM5Vi1RCZ9xHoq68G6zNMTWHQrIYYLeStOWg+it3DtE6furV4lvxjNX0
         bqvAy4tS/0Px4oZnlM9JN2N1TKsX5zPEy+P20AjPVorHq80plv8UaeUbYBg4/0gSfJkA
         eMPA==
X-Gm-Message-State: APjAAAUnbaloqQ7TI7s9ZgOGpjac3xSFZ24lRKaqUfRwkwVHk6omHiuQ
        WQ7Gtrju20KNW9/giSEEdhvNbg==
X-Google-Smtp-Source: APXvYqzCqipY5M+StPkB8A30OekJkDufva4u9pN+0CrWZT7+VFTF/RwwrM8g0cNJN1cJrgc6U+I4VQ==
X-Received: by 2002:a0c:fb07:: with SMTP id c7mr9619572qvp.29.1570126783125;
        Thu, 03 Oct 2019 11:19:43 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m91sm1592984qte.8.2019.10.03.11.19.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 11:19:42 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        atul.gupta@chelsio.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 3/6] net/tls: move tls_build_proto() on init path
Date:   Thu,  3 Oct 2019 11:18:56 -0700
Message-Id: <20191003181859.24958-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003181859.24958-1-jakub.kicinski@netronome.com>
References: <20191003181859.24958-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move tls_build_proto() so that TOE offload doesn't have to call it
mid way through its bypass enable path.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/tls/tls_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index a1203807a3ef..7bc2ad26316f 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -668,14 +668,11 @@ static int tls_hw_prot(struct sock *sk)
 			if (!ctx)
 				goto out;
 
-			spin_unlock_bh(&device_spinlock);
-			tls_build_proto(sk);
 			ctx->sk_destruct = sk->sk_destruct;
 			sk->sk_destruct = tls_hw_sk_destruct;
 			ctx->rx_conf = TLS_HW_RECORD;
 			ctx->tx_conf = TLS_HW_RECORD;
 			update_sk_prot(sk, ctx);
-			spin_lock_bh(&device_spinlock);
 			rc = 1;
 			break;
 		}
@@ -776,6 +773,8 @@ static int tls_init(struct sock *sk)
 	struct tls_context *ctx;
 	int rc = 0;
 
+	tls_build_proto(sk);
+
 	if (tls_hw_prot(sk))
 		return 0;
 
@@ -788,8 +787,6 @@ static int tls_init(struct sock *sk)
 	if (sk->sk_state != TCP_ESTABLISHED)
 		return -ENOTSUPP;
 
-	tls_build_proto(sk);
-
 	/* allocate tls context */
 	write_lock_bh(&sk->sk_callback_lock);
 	ctx = create_ctx(sk);
-- 
2.21.0

