Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79234436792
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhJUQZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhJUQZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D97C061348
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:06 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a15-20020a17090a688f00b001a132a1679bso3560863pjd.0
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ol7MeYN99tKYniOogeOey/QfrV6TG+g6eFWfS4txJpo=;
        b=KZtBrCjjXo0pkSZrR5ERebhFCQlU9s7iPMDAtGefDA9qsxe66PybmG5w8gYX6iTVYS
         x8nHY0J5pT0XW4SsLa8VoTn1PFGrygxg9E6n05eNRfGHT1a7ehJ8pDxEAPf6ZKZEX+zt
         Lm1G3Ps2y6aHx5ghjUrnes6Tz3g6aCMWTGWdLxDbDRDQBhouGaoRhLj7u0HDMFCKGa6A
         W4Ls623z1b3JcribQtI2vstDREuMNc0QNNMN75KmYJ8FYH0CV/vBQggzS9vtq6Ww2cVU
         o/WykO1Y9gr1AYQV0N2SmWIGlXA6BaSgO68MokORE3fdn0LxxGVREpGNc5N91YeetJ2K
         pz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ol7MeYN99tKYniOogeOey/QfrV6TG+g6eFWfS4txJpo=;
        b=8Rfgxa591N3y8ShhX9yJLE0TwSAaDFsfUcWSsD6FZgD1lxhDSsZLw7/TyiuvhAkQxj
         cCKnfUI5gKO3uvSeBf7LifIA0Q4k8P9GHBYnNO6gU/wvLH1u8GV1LvqANxuhKW4F/qIo
         sFRRgTyGjNlzjVKiYYep1AHGcBmapaIfcoIaWg625L5ot7cuwgH9pdoO/66HRLoyg2Is
         E+yalnCdMsCVK1V3qktHI59WPaByD8wF5VLfutlphh/TtacTeml9srKMqQElhaaJRHmc
         gsgsCoCuCJzdAIBQFl48f2qK9QypMjEqvq9wJYMDpCXOtd0YRdf4qazKkMpc5sNZ3MvH
         0dig==
X-Gm-Message-State: AOAM531YTmEZ3AOVOEH8xbhhPuNf4WMeli1C5b/NzFkza04ZyB7RwIg9
        cfpE60xEm/k/gTCcOILCmM8=
X-Google-Smtp-Source: ABdhPJyEKzxD5tOnqPnuVGlRZhHVudoh8Moh8At6h+i/W2fELL6dmYKhPudkPVmTB2ANqPbuwA9gXg==
X-Received: by 2002:a17:90b:4b83:: with SMTP id lr3mr7764529pjb.45.1634833386502;
        Thu, 21 Oct 2021 09:23:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 3/9] net: avoid dirtying sk->sk_napi_id
Date:   Thu, 21 Oct 2021 09:22:47 -0700
Message-Id: <20211021162253.333616-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk_napi_id is located in a cache line that can be kept read mostly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/busy_poll.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 40296ed976a9778ceb239b99ad783cb99b8b92ef..4202c609bb0b09345c0f1c5105adf409a3a89f74 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -130,7 +130,8 @@ static inline void skb_mark_napi_id(struct sk_buff *skb,
 static inline void sk_mark_napi_id(struct sock *sk, const struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
+	if (unlikely(READ_ONCE(sk->sk_napi_id) != skb->napi_id))
+		WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
 #endif
 	sk_rx_queue_set(sk, skb);
 }
-- 
2.33.0.1079.g6e70778dc9-goog

