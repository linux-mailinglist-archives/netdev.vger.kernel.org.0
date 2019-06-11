Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC33C26C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391092AbfFKEkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:40:52 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41067 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387997AbfFKEkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:40:51 -0400
Received: by mail-qk1-f194.google.com with SMTP id c11so6832790qkk.8
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rfldYzKrLolzsa6VAryAXE4SNzFOc7lcGDJqbkGiI7M=;
        b=r0EKE5lyGtyk2Mz9kmTysDszqfHcTiXVzNNkogGxuuJLuBC4r/8o6e+ag+jBj1WCke
         XlCcjlOLzgm6AIIAhfPOAO30IDipCcYUNdrroLqhk2BSa7XzAc2bi1aSKGko1Ii8W6LK
         XhNsiplBfmQN7xqR6g9bGdUAIVZlY2f0SycebuVdQYBUzonE1J6USwjyJdcPzq8DivXq
         cSwLmjjez6kmnVyuJVTuVH1BW4oHj3voyD84uAr1a4XMWL6eAVOebZo8sSnW9rFmlylS
         Adps6w+Iav+CBaBPPSaVRe4sgQzJ+eOpxILaVz8MX9iYt0m5285BUrD9ubTUeJCXOJ8e
         +Iaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rfldYzKrLolzsa6VAryAXE4SNzFOc7lcGDJqbkGiI7M=;
        b=VA4j838RvuWnw0ABZMXK3FEgObJXAoncG7GkTBGq4mj4eb7v2e49X5YTnkqO4fhVol
         qghF6zxsgg8hKVhTPPeywrmJ0Dqts0AMr+WmJS+LECfZjtoDEkF6kAYkem/4KUVbng+t
         eeGsktOhC6t0Ua6LESC2g32BKS2LbYMjdaywGW/Iy2A94WpYGThmU0NnEVF5UYMotT9W
         2KF5n2uPXrekrmeGTyZjNnjIgzgKFpyTuqL/GxB1/+2OT+wVlbswRHzvcm4hONzJktO9
         VKD/CsnAnM+vRc0x3KtkDU0SwKY3OCq1ajCQvCkLntalf9wlRXzO2pVZ+osSGyPRop1M
         2afQ==
X-Gm-Message-State: APjAAAUvLCVkJ9jBsgoJnpFCZmYs1YK9dx/8qEIJWkiaRB54tUJD1gZL
        BNHo437Yt8Lo8cUlq52lK8EKXSGft0I=
X-Google-Smtp-Source: APXvYqwvtf63CPRwIgP/xduYoHPxyFwAg54vpKAm0SpMm2tVql6ovLoPUU0fkiUPBjD9TRglVeqFvw==
X-Received: by 2002:a37:480e:: with SMTP id v14mr59342270qka.344.1560228050426;
        Mon, 10 Jun 2019 21:40:50 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.40.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:40:49 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 01/12] net/tls: simplify seq calculation in handle_device_resync()
Date:   Mon, 10 Jun 2019 21:39:59 -0700
Message-Id: <20190611044010.29161-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We subtract "TLS_HEADER_SIZE - 1" from req_seq, then if they
match we add the same constant to seq.  Just add it to seq,
and we don't have to touch req_seq.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 43f2deb57078..59f0c8dacbcc 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -576,14 +576,13 @@ void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
 
 	rx_ctx = tls_offload_ctx_rx(tls_ctx);
 	resync_req = atomic64_read(&rx_ctx->resync_req);
-	req_seq = (resync_req >> 32) - ((u32)TLS_HEADER_SIZE - 1);
+	req_seq = resync_req >> 32;
+	seq += TLS_HEADER_SIZE - 1;
 	is_req_pending = resync_req;
 
 	if (unlikely(is_req_pending) && req_seq == seq &&
-	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0)) {
-		seq += TLS_HEADER_SIZE - 1;
+	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
 		tls_device_resync_rx(tls_ctx, sk, seq, rcd_sn);
-	}
 }
 
 static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
-- 
2.21.0

