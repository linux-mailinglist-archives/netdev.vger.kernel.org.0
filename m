Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C40EE453
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 16:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfKDP6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 10:58:02 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:34361 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfKDP6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 10:58:02 -0500
Received: by mail-pg1-f201.google.com with SMTP id w9so12900683pgl.1
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 07:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HMe5DRB8AC9JrE3VKbMRpPZl6ZMcGBxER5z6oqAgwXw=;
        b=es8WftUjhs72ibN6P6EPFuXDxCi8Wz5gwEUYe65AXKWRa19k2U8YC0Soy2zJvrJcuP
         whqGo7QKiP778vFNdEARa2sOrwbeoPNa2D7Y2hw2AR/OnqMAeL9kph9HkcGQM0BEGkdB
         YUpnWElMZ7Um63HruXzncjhcNXc5SqEFSVv4n12pkP7qujZMo1LMpzmGMHLcYJt9gbME
         HqYVoS7jfbKNEGauhARQcj+f/di4UXO5bRxLMz+B7G464F9cSpFrPAjPl7USBpU8Dn3T
         UX4ZVtdzOzTDoT1sewY5gYjNz9yys4uy6greMGZpNoyi5dy97cCHQyqdD0RynqcrUlII
         SV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HMe5DRB8AC9JrE3VKbMRpPZl6ZMcGBxER5z6oqAgwXw=;
        b=XcFNwx4FDJP7ZVNu/7r4LzqQ+lh0QPa7Wwmw0zpKH4Cak1P+oO0VD6W1eyx+wNU23t
         T6vnrlUuUYF8alVOfDIsHK4rsNPOlqhoThq3r1tQYXpKrUJDQkDuVq86AAJBXpg+9aR0
         DnnLCB4roXdMTEM05rxg7iADeD5JYsWcNa5YMYcDDvMvrvsvJteeiu6sGeXg+N3Zi4d+
         vzMQW7TfXUYB2mWyPNlNdtTktx6ViHUdYpi4p3t5/gxOGiEGvGMJKbAmYyl6vWBBDKnY
         owi3SmQ+zYpmEXHTSnfji+7PR49rVWkv1G10nLaTVbQGIypDYGO2Ib/YPnjCtHGdFMxf
         CFaQ==
X-Gm-Message-State: APjAAAXyI0E3SKgZ8u7HhbFgRl8qe0V9NHQg3x6cqjZoqEDqjSybHa62
        XMzlIwNo0LnsLJC7vfLBWCR7BE1WZNPf0Q==
X-Google-Smtp-Source: APXvYqw75/YQIxGyFZ4V50aUctgoU8r9CgQJs1MQh4CiBdECfTjRybea8qGkqK0yU8KwpeAosw2wh0vCegaPpw==
X-Received: by 2002:a63:5762:: with SMTP id h34mr31492886pgm.235.1572883081011;
 Mon, 04 Nov 2019 07:58:01 -0800 (PST)
Date:   Mon,  4 Nov 2019 07:57:55 -0800
Message-Id: <20191104155755.18916-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net] dccp: do not leak jiffies on the wire
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thiemo Nagel <tnagel@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some reason I missed the case of DCCP passive
flows in my previous patch.

Fixes: a904a0693c18 ("inet: stop leaking jiffies on the wire")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Thiemo Nagel <tnagel@google.com>
---
 net/dccp/ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 0d8f782c25ccc031e5322beccb0242ee42b032b9..d19557c6d04b58a3eccad3d7971522fad666157b 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -416,7 +416,7 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
 	RCU_INIT_POINTER(newinet->inet_opt, rcu_dereference(ireq->ireq_opt));
 	newinet->mc_index  = inet_iif(skb);
 	newinet->mc_ttl	   = ip_hdr(skb)->ttl;
-	newinet->inet_id   = jiffies;
+	newinet->inet_id   = prandom_u32();
 
 	if (dst == NULL && (dst = inet_csk_route_child_sock(sk, newsk, req)) == NULL)
 		goto put_and_exit;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

