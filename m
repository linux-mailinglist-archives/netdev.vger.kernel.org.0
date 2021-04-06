Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DC8354B04
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 04:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243471AbhDFCpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 22:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbhDFCpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 22:45:40 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DD5C06174A
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 19:45:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id a12so9405855pfc.7
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 19:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gl2BFEkCoDtmwGmzxzT5c7YxkCDCRL5qgOQzUI0dIQ4=;
        b=C7OflORWo003HRWv3LYbSA+lPOUhEcl7QTOc/rOXH7JQBrnJwSHD2NioMjydj0DaeQ
         8q5H8Hxd3GNllhL2o4K5ts06S4UeLlVsw1OYi5ESRK+gcTou2QEztxgexJELg4qW1goD
         X84DbKsodCdqVSFRSCj9ipbXkmrjsBsec9wO3ABOjlP80PYfuij5h/mASd+VTHtlsm2t
         ZQQ7xsigdMiMFJdaDnJ7tDkmFE4wZVvg+QKfyVD9hIYSDB8MhLH6wBDvHFgGXunsdxII
         Q5yIRhQxv+sWQtRxzhAksm332cj2MKL8Q3O9UXCgNwTsFDglq9GYPy6+/0ZhyR7rlxJA
         T2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gl2BFEkCoDtmwGmzxzT5c7YxkCDCRL5qgOQzUI0dIQ4=;
        b=QTVM946u+/k5ULc0dFrR5VknJFotnNhdohkYgGbB0aopw+l7DwH+P9BIaFvVArMjqy
         UR3mYOZKXeSK10Hoe6qCnbFLCua5ev9h/UBnUvcH9d9VTRai1wWRQHjaPXPpD9cvs1FW
         7Bm7brchjx/7NbR44kTab1WejUSRnxx8+8l5SL3w527o10gEVuO6K56xR7Pi/hW+tiKz
         xCzgKHLtNqlp7Oep6nW2p3/3S1zI0Sb9aU7+O9OBapldQKaQs7PWOmGdGPhYyzWxg+n4
         a25NwVOW0G5nqE33DBjlpkLyDmIiKavjypIY2AM9WwMPSGgtZKnHipkxcOWqz3A2Hbtw
         LWnQ==
X-Gm-Message-State: AOAM530rzeU7b2RNldgpRqUSbKeKknb1c1rUDVKhfN1srFygUKEeeKRN
        l8iqMyB0UQGfHppe3q5Nl/GQ1gbNyplvHwfk
X-Google-Smtp-Source: ABdhPJz5G8Je67f+YEuq9WjrMo1f+/JusrFUHAz88/dJ2YJrxIPVFkF88EF3PQeX20RYBqUmAvQ0Hw==
X-Received: by 2002:a62:ddd2:0:b029:1f1:533b:b1cf with SMTP id w201-20020a62ddd20000b02901f1533bb1cfmr25409528pff.56.1617677131323;
        Mon, 05 Apr 2021 19:45:31 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r26sm10441989pgn.15.2021.04.05.19.45.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Apr 2021 19:45:30 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>
Subject: [PATCH net] tipc: increment the tmp aead refcnt before attaching it
Date:   Tue,  6 Apr 2021 10:45:23 +0800
Message-Id: <c273cb4165a007c0125fac044def1416bd302fc7.1617677123.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li Shuang found a NULL pointer dereference crash in her testing:

  [] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
  [] RIP: 0010:tipc_crypto_rcv_complete+0xc8/0x7e0 [tipc]
  [] Call Trace:
  []  <IRQ>
  []  tipc_crypto_rcv+0x2d9/0x8f0 [tipc]
  []  tipc_rcv+0x2fc/0x1120 [tipc]
  []  tipc_udp_recv+0xc6/0x1e0 [tipc]
  []  udpv6_queue_rcv_one_skb+0x16a/0x460
  []  udp6_unicast_rcv_skb.isra.35+0x41/0xa0
  []  ip6_protocol_deliver_rcu+0x23b/0x4c0
  []  ip6_input+0x3d/0xb0
  []  ipv6_rcv+0x395/0x510
  []  __netif_receive_skb_core+0x5fc/0xc40

This is caused by NULL returned by tipc_aead_get(), and then crashed when
dereferencing it later in tipc_crypto_rcv_complete(). This might happen
when tipc_crypto_rcv_complete() is called by two threads at the same time:
the tmp attached by tipc_crypto_key_attach() in one thread may be released
by the one attached by that in the other thread.

This patch is to fix it by incrementing the tmp's refcnt before attaching
it instead of calling tipc_aead_get() after attaching it.

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/crypto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index f4fca8f..97710ce 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1941,12 +1941,13 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 			goto rcv;
 		if (tipc_aead_clone(&tmp, aead) < 0)
 			goto rcv;
+		WARN_ON(!refcount_inc_not_zero(&tmp->refcnt));
 		if (tipc_crypto_key_attach(rx, tmp, ehdr->tx_key, false) < 0) {
 			tipc_aead_free(&tmp->rcu);
 			goto rcv;
 		}
 		tipc_aead_put(aead);
-		aead = tipc_aead_get(tmp);
+		aead = tmp;
 	}
 
 	if (unlikely(err)) {
-- 
2.1.0

