Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB1DEF510
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 06:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbfKEFir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 00:38:47 -0500
Received: from mail-vs1-f73.google.com ([209.85.217.73]:55903 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKEFir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 00:38:47 -0500
Received: by mail-vs1-f73.google.com with SMTP id m15so3274225vsj.22
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 21:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=59/NSGO6V0+1kbnYoBGROlNG++E10xB27v0TuNC89Zo=;
        b=mAZW8dBoYVLDmrGU14snf1ECr6w2YJWSzeCbA9uVxaaTnu9lcH7/kIxlLQ2k+at2kR
         f7qygE8DLSy04sxJx+b9Cypq/eTDjXMJ0OpSRHy92eYIZauDAQ4+IitenOy5cyPGsk9d
         sdIHoKW24cc88GENOQBetZl/K8FBwoRv3CBBDBB68v1f3c/imJy54A3qaLZwg2rXPeSK
         AldBiiF2moqJUOQkdnDedHs7sXD10s57KG9Ox6vbUIaAXPMlMvGMobuFE5hoDf7d0iSu
         7eq68LRag3pMkOSB5tPK3pt71uqLy7tV5xEwuhcWF+woZx/EjArV8TOT3/eYVmBj3RYL
         EcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=59/NSGO6V0+1kbnYoBGROlNG++E10xB27v0TuNC89Zo=;
        b=BYQ3BMIgf5nTOfx1i+/pjIueF2BZ8tt3pfdtm9ZAycdJ2uo6KEPZurjWo3PONZ7t3z
         UnrV1Mw4mFL2MrIrqWMgbLCm2Pd9Pevr8D8IlZr+h4Op/8Bq0h2WYOQHSoHx5SLPEM+M
         mBEkUB/SCjvA3Ngir0jYgd97FUc/d/qLAZeScnb1HcwzerIlDtdXCL78CSPJR3pfrmN0
         qGuEkw1gjKnGrillsnSESCiDlo4EULJ/OItsgvQj9giQPUZ8vVkLZoZVT+3pJo5CODuX
         w+UIU5e9BgTXJHLrnMf9oK6UjQAW1PosFU8QVYetwjijjllWz5XZsJQxbUJDZuzOLBKc
         jAug==
X-Gm-Message-State: APjAAAU+5m7VVS7lneqDJO41qJyFEjyfEGe3qvhr3byewDqD2R57fKIt
        JE4CYo9ELyPz9eU5KhzOAZrnqODzMgAjjQ==
X-Google-Smtp-Source: APXvYqwbQDwaKMSSYTnuQ0FgFK/0c7G3A6ies6bYxmhN7O83LRZcyQGfKrZljAwowSBS4iTAAVUBzA7kJkcz0w==
X-Received: by 2002:a67:a40e:: with SMTP id n14mr14966568vse.230.1572932326598;
 Mon, 04 Nov 2019 21:38:46 -0800 (PST)
Date:   Mon,  4 Nov 2019 21:38:43 -0800
Message-Id: <20191105053843.181176-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net] net: prevent load/store tearing on sk->sk_stamp
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple of READ_ONCE() and WRITE_ONCE() to prevent
load-tearing and store-tearing in sock_read_timestamp()
and sock_write_timestamp()

This might prevent another KCSAN report.

Fixes: 3a0ed3e96197 ("sock: Make sock->sk_stamp thread-safe")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
---
 include/net/sock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8f9adcfac41bea7e46062851a25c042261323679..718e62fbe869db3ee7e8994bd1bfd559ab9c61c7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2342,7 +2342,7 @@ static inline ktime_t sock_read_timestamp(struct sock *sk)
 
 	return kt;
 #else
-	return sk->sk_stamp;
+	return READ_ONCE(sk->sk_stamp);
 #endif
 }
 
@@ -2353,7 +2353,7 @@ static inline void sock_write_timestamp(struct sock *sk, ktime_t kt)
 	sk->sk_stamp = kt;
 	write_sequnlock(&sk->sk_stamp_seq);
 #else
-	sk->sk_stamp = kt;
+	WRITE_ONCE(sk->sk_stamp, kt);
 #endif
 }
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

