Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078CF475AC9
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbhLOOjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243419AbhLOOjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:39:45 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C36C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 06:39:44 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id kl7so3579893qvb.3
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 06:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T9kJhmae+NiQM4CxL8JsDWa/rj6WIR4pRBevUF+OCCI=;
        b=YS5VM/fTO5mMwwlZ+sD6UIC+Fb2L7hQh9/cIZuBAT7F2erqmPWfAakfcDdOM79ltZW
         I0zLnjjBV8r7w0fKdjf9LCUYXPOUZnmfbQJmIevT+K+OcCZEIu4bTAKz1gByY/6IhbtL
         H6MvmQv4mhx66mbistjP1opaPrQ09QSdjuiGyImoXoTSqQG7+Rr/auAHIUo8Em/Dc0x1
         KtsD7SPtwjH9mngohwqViQdru9/taFychqqPA5tZkl915wQAF6NZOywpbCp+geS2vNo0
         wuVRDyTDeRYLT9J5Q9pSYzsLokr64dRHyOxDKLa0J5cPOhAHIogndrWzFeV2UVuju5Rh
         8XFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T9kJhmae+NiQM4CxL8JsDWa/rj6WIR4pRBevUF+OCCI=;
        b=D+08lemdg5mqFVQMKyf/NjMa4d5AMCqD2qHdM3OGUF7hEH5ufYg7WhnCEDDMsBxpQB
         TL1d94h3d2iDjRgZEQoSEAI/BDzJY2m+iq04bitvpibgsu4OZCsetNdYyWteyBXsMTxA
         00qh7L4FH+e75yxgp4IxDcDbdA+VYwX8HYsBtpw6VJuD4J4lefJ6UqrqlewNhrCgy0/y
         m3Yx6l9gE1dm2AjwJtSIluQufsMpCmU0ed9a1A+wGM1OYCnarama2hUKCoMmHHHKqfzU
         2LWjqozxtiwZoUCkL1Q/GGPyu8atUi6gxlescVeNdTjS5GDSAtnr/GyUs51PHtth5Ncr
         bPWg==
X-Gm-Message-State: AOAM531yxoMUl9FIoTNK3DW5k8fAPEaKqzU9PnJGR8Wq3Zw3JoAWoSte
        EclmhFSjuwTfIH4vRSuWkHzRUxVCPH4=
X-Google-Smtp-Source: ABdhPJzyYTuya4j61oykDulHTNoROllp0a3aWzzOIg3HmF9+p0Zh4o+SXpl5U6kOSYjRsnnnPQnXCA==
X-Received: by 2002:ad4:5e8b:: with SMTP id jl11mr11338316qvb.18.1639579183953;
        Wed, 15 Dec 2021 06:39:43 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id o17sm1477786qtv.30.2021.12.15.06.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 06:39:43 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, theflow@google.com,
        Willem de Bruijn <willemb@google.com>,
        Syzbot <syzbot+1ac0994a0a0c55151121@syzkaller.appspotmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] net/packet: rx_owner_map depends on pg_vec
Date:   Wed, 15 Dec 2021 09:39:37 -0500
Message-Id: <20211215143937.106178-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Packet sockets may switch ring versions. Avoid misinterpreting state
between versions, whose fields share a union. rx_owner_map is only
allocated with a packet ring (pg_vec) and both are swapped together.
If pg_vec is NULL, meaning no packet ring was allocated, then neither
was rx_owner_map. And the field may be old state from a tpacket_v3.

Fixes: 61fad6816fc1 ("net/packet: tpacket_rcv: avoid a producer race condition")
Reported-by: Syzbot <syzbot+1ac0994a0a0c55151121@syzkaller.appspotmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 46943a18a10d..76c2dca7f0a5 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4492,9 +4492,10 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 	}
 
 out_free_pg_vec:
-	bitmap_free(rx_owner_map);
-	if (pg_vec)
+	if (pg_vec) {
+		bitmap_free(rx_owner_map);
 		free_pg_vec(pg_vec, order, req->tp_block_nr);
+	}
 out:
 	return err;
 }
-- 
2.34.1.173.g76aa8bc2d0-goog

