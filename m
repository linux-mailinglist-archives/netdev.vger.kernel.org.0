Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B49042CBA
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438228AbfFLQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:52:48 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:46267 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502240AbfFLQws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:52:48 -0400
Received: by mail-qk1-f201.google.com with SMTP id 18so14236191qkl.13
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LAvvCh63rEf3Hma1oemsjvrm9WgK81lyDjCPwVpW+Lw=;
        b=pvMrjaKq0GjAXnx5zpHuSG3UFpQ4pQXtO1OAftetGn889FkgGt7vQypiQlz0r+5k+L
         8fsQPbtXW4Cdf5toduccYJgdQLpcAD348f2sP5nWTiglWFriYV0+pY2C59t5OLIJmap7
         ZWSa85QyfUa+ADBPuGJycMoBCT3Z8Du0+hG4Tp3C2Zm3axK2y1IpW0P0EtLEJ5H/9JNk
         7EDgcVluhm+5GzUpXdOEwU37Ql7BpZHKGKN4WlR1YE4Unspncv55eqBs7nBVO7I4Wkp5
         EdhBHCDyPgPI/TB4IaKX3hZuxW5Oi7WzOqwA/XyAWRuyRKTlOPVy2wAqYw2JbKUPsO9f
         VgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LAvvCh63rEf3Hma1oemsjvrm9WgK81lyDjCPwVpW+Lw=;
        b=W/XYEWnboiL5tyWqdEUHj5SeyjL4H1jF/v0ABeWeLM28aFvXvIfWBwphe7dMqNTgmD
         aOaWKNjzqt/+lAj1+abM6ljPNU0FvLOzEX6Q3f24Kd0GWTnEE/7tRRO91U/CFCfMaNme
         vO3RizHcrV9mGTsXj72BxrS821gC7lK1pLnBEOIbxGcsz32Z1WyMyq5EBiDkX8XWZ6lm
         jB3/6uOGCXOZ/ZJcdYg3YTp0TGkBtVktpcQIJWADz1MxNDiArmkD15W42gHKS0K9fucN
         2wLwJqDBKlUhE86Zqtg6isOVUpZKvLb8wwibhGNnMGZHEGYJ5T16RHk9Jw6knn2ZuuNP
         hyxw==
X-Gm-Message-State: APjAAAU99sbmRGd5S1pv7+l9OCSc0g4jr7BlO7Rn0ScxRWf+Jdz5FDbF
        BJ2T1IbugC3Ed0SWWpqzi+tqFLOG45iIxQ==
X-Google-Smtp-Source: APXvYqyD+vH4HQKIAnEvkV9UgCMd8NwFmZiMP8DzDQyYWn9dsQhZJJbMnAMpSsexeXLjEBidMiHUbM32/KB24g==
X-Received: by 2002:ac8:2e5d:: with SMTP id s29mr63172216qta.70.1560358367249;
 Wed, 12 Jun 2019 09:52:47 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:28 -0700
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
Message-Id: <20190612165233.109749-4-edumazet@google.com>
Mime-Version: 1.0
References: <20190612165233.109749-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 3/8] net/packet: constify prb_lookup_block() and __tpacket_v3_has_room()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Goal is to be able to use __tpacket_v3_has_room() without holding
a lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 273bffd2130d36cceb9947540a8511a51895874a..5ef63d0c3ad0a184a03429fdd52cad26349647d1 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1082,10 +1082,10 @@ static void *packet_current_rx_frame(struct packet_sock *po,
 	}
 }
 
-static void *prb_lookup_block(struct packet_sock *po,
-				     struct packet_ring_buffer *rb,
-				     unsigned int idx,
-				     int status)
+static void *prb_lookup_block(const struct packet_sock *po,
+			      const struct packet_ring_buffer *rb,
+			      unsigned int idx,
+			      int status)
 {
 	struct tpacket_kbdq_core *pkc  = GET_PBDQC_FROM_RB(rb);
 	struct tpacket_block_desc *pbd = GET_PBLOCK_DESC(pkc, idx);
@@ -1211,12 +1211,12 @@ static bool __tpacket_has_room(const struct packet_sock *po, int pow_off)
 	return packet_lookup_frame(po, &po->rx_ring, idx, TP_STATUS_KERNEL);
 }
 
-static bool __tpacket_v3_has_room(struct packet_sock *po, int pow_off)
+static bool __tpacket_v3_has_room(const struct packet_sock *po, int pow_off)
 {
 	int idx, len;
 
-	len = po->rx_ring.prb_bdqc.knum_blocks;
-	idx = po->rx_ring.prb_bdqc.kactive_blk_num;
+	len = READ_ONCE(po->rx_ring.prb_bdqc.knum_blocks);
+	idx = READ_ONCE(po->rx_ring.prb_bdqc.kactive_blk_num);
 	if (pow_off)
 		idx += len >> pow_off;
 	if (idx >= len)
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

