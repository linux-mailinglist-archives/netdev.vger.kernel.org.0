Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5AA1E340A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 02:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgE0A3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 20:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgE0A3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 20:29:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4829FC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 17:29:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p192so1853638ybc.12
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 17:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=M+zpk3jA+779uDSsVYHEQLQf4U3UltneMSql7OeISrg=;
        b=Sw1fLrONPSImZ13jO7MUZSgosJhwPybdfdEQLHZpI5jdjy54TUKslwbrrjMrZ9hM7h
         P+UoZNHMPlpDT8e9QGvuUCv8Y1nHoXikd7JoSvdNwlngoTJWiaPm/5/tXkkp5NLK/lK0
         PP0CLwedzXYIaFzHP4fA78zfeT9iQXHSUupvy+ipx5xG8UCCQWh+8+zsrp6fDLfLnut3
         p2KW+J0BMi7FH1ny8d9pDjZi7WGhiuqEGJx754D9Vb7aQ3hhjnTlo0tNWlMOJc32dVoB
         3lSoRwCCtu5QrHst8zgdX0A7Nb/WeGGXrefWqwLt/NkxJEywL8GoSaVMlUcACkFgxXZm
         jJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=M+zpk3jA+779uDSsVYHEQLQf4U3UltneMSql7OeISrg=;
        b=El/iMKJ8MrgYRkYAcNsJzxJj0+j90oTtHG2MCBxfAmw5fDhvMr73HayyREu+wpDla3
         LqpVcVWw548E2gqxG+qtJ1Datrzyt9ap1m/VHeRMHPQuOK4tyxEuDi/Lrh5YvSAYQdX3
         n49cd6h0tOlQCVdYQND5BQ45EmLjtFI72yZfOyKrY517VEoHstoNgHt+T+nyD3S5m+LL
         fZIKZQrbXhPuEdGc3/3Ab9yTvftH6ohrDQdJE1thAsnbX8GkRIojtgkM5M3VzTfFZgFS
         wXsmPPel/oiaVTcesUNbJF5N31ZbKlKcZQywthUj8fP79wLMPupgXSbGG01LDsAGlJkx
         BbsQ==
X-Gm-Message-State: AOAM530QCsG4j0hI9RUFG5CYJ7DmFztPNx85EGSEDBx0XOFKFES9osh4
        nx04AmEE9hEtcqF8HWbyUdZrYnhrp5M51Q==
X-Google-Smtp-Source: ABdhPJydAluUWDnjk5dKk4/YRVEaWSwWHRwypvXCpoXG0bcLMWMPXU4j/5ucnz0eDAS8hTTExWeerHmEM/7vyw==
X-Received: by 2002:a25:60c4:: with SMTP id u187mr5599395ybb.509.1590539339321;
 Tue, 26 May 2020 17:28:59 -0700 (PDT)
Date:   Tue, 26 May 2020 17:28:56 -0700
Message-Id: <20200527002856.212293-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH net] crypto: chelsio/chtls: properly set tp->lsndtime
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP tp->lsndtime unit/base is tcp_jiffies32, not tcp_time_stamp()

Fixes: 36bedb3f2e5b ("crypto: chtls - Inline TLS record Tx")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index dccef3a2908b391e772944d504d953a062001d9f..e1401d9cc756cea07f7ad310c17fed29e0f3e9db 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -682,7 +682,7 @@ int chtls_push_frames(struct chtls_sock *csk, int comp)
 				make_tx_data_wr(sk, skb, immdlen, len,
 						credits_needed, completion);
 			tp->snd_nxt += len;
-			tp->lsndtime = tcp_time_stamp(tp);
+			tp->lsndtime = tcp_jiffies32;
 			if (completion)
 				ULP_SKB_CB(skb)->flags &= ~ULPCB_FLAG_NEED_HDR;
 		} else {
-- 
2.27.0.rc0.183.gde8f92d652-goog

