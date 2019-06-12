Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0088C42CB9
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502238AbfFLQwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:52:46 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:43151 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502234AbfFLQwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:52:44 -0400
Received: by mail-pg1-f201.google.com with SMTP id z15so3216322pgk.10
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bCWjeERdRXyT+vLqOH3lrInmnOxGtlt6uejzf/5POw0=;
        b=MqBokmo/QJS14HbhX5siOTkupcMu6hl9Q5Rixh6j418jNC6fFePZuPkpHlU7BoEbjI
         7SPBbqALeCwGBP46fp4agV3JbpoahMIsLR2Hs4/mdgqUNj5APPktahOI7SW1hZVnoD5b
         eZ1fbPHvw8IbQY0jOZlos99W6b92E12Mcd3rR7fY5VoSpmUiBRCHkH1eoyRt0nEpxaN6
         59EBuNez8tKf0mijldBYZDTefGVPXtIsjvrkVjqKL/ZUqbQMsWel30kef2fA7ml7+azj
         tykhrW6y3FWIJXmOlKoqYOoLHY0XnhI4jJLQLgKxSphCoTmmlNX5dec6sIiBDeHRMC/5
         8NCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bCWjeERdRXyT+vLqOH3lrInmnOxGtlt6uejzf/5POw0=;
        b=LkX71hnNO+KHStpglfE3PgloA/rad6/ZMiiNA1nerhpVdVGlsNpqsiaFFtXbDkJwD6
         Eyb7fUf10avyAMIyAonpsylNmqWYivasdpKbwhQGt/4L1VQbF+NeJEH3kRRXsaaHhHFp
         Bbpmi+oZUROgoHS1ppyR0Kf66/LrJWwV5hTjHI6yqyYC16EWKH1SBzMiNE5R1hNgyZwk
         iugrjKTdkdZgmkex2apuhyoAf/DC6U55Ztz9v0zexOt5L/Jmd2azlgRCqSOcdLkW0cWZ
         k8HTUi9CXBoOPs7ZjGtORqIyincDW8DO4ATHSImLgXCzZYmRJSuRA8ByakguQ1wN308n
         H7jA==
X-Gm-Message-State: APjAAAVbWl41ftUAZ+582uBj4CNiJWGzHoceuxIWzUV8QiTuB/6xkFNn
        QJM/sXDNv/PwnIy5scBjqhg4Cbb0ctY6Iw==
X-Google-Smtp-Source: APXvYqzydRTsiWsdYw8obDN5+qVd57smV9fpDG5IIcXE5hiuqlRUKqX1lTTHhH2yaPCBSOd4xPr3+Xa2rnuhFQ==
X-Received: by 2002:a63:1208:: with SMTP id h8mr25193113pgl.377.1560358363728;
 Wed, 12 Jun 2019 09:52:43 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:27 -0700
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
Message-Id: <20190612165233.109749-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190612165233.109749-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 2/8] net/packet: constify packet_lookup_frame() and __tpacket_has_room()
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

Goal is to be able to use __tpacket_has_room() without holding a lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 66fcfd5b51f82a861795e002e91d3cbc69ab545a..273bffd2130d36cceb9947540a8511a51895874a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -460,10 +460,10 @@ static __u32 __packet_set_timestamp(struct packet_sock *po, void *frame,
 	return ts_status;
 }
 
-static void *packet_lookup_frame(struct packet_sock *po,
-		struct packet_ring_buffer *rb,
-		unsigned int position,
-		int status)
+static void *packet_lookup_frame(const struct packet_sock *po,
+				 const struct packet_ring_buffer *rb,
+				 unsigned int position,
+				 int status)
 {
 	unsigned int pg_vec_pos, frame_offset;
 	union tpacket_uhdr h;
@@ -1198,12 +1198,12 @@ static void packet_free_pending(struct packet_sock *po)
 #define ROOM_LOW	0x1
 #define ROOM_NORMAL	0x2
 
-static bool __tpacket_has_room(struct packet_sock *po, int pow_off)
+static bool __tpacket_has_room(const struct packet_sock *po, int pow_off)
 {
 	int idx, len;
 
-	len = po->rx_ring.frame_max + 1;
-	idx = po->rx_ring.head;
+	len = READ_ONCE(po->rx_ring.frame_max) + 1;
+	idx = READ_ONCE(po->rx_ring.head);
 	if (pow_off)
 		idx += len >> pow_off;
 	if (idx >= len)
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

