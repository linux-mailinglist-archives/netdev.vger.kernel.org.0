Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A507D791A3
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfG2Q7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:59:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45907 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfG2Q7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:59:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so28329869pfq.12;
        Mon, 29 Jul 2019 09:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DpOVC8gqwK4YWrrBVYqACoZ5/dJGAtrFwzBZYKGC418=;
        b=PwTrhs9GDO2C1lLm5npHbadkws8nichD7hXZAHQynmtQYdjPBSHDndQTMqXusWnuVm
         GkfcNM5Gaq/bY8+z9lb3CSJ0hS4xPQcZZq1hoDvyJHUQavmWwmJNakvyjT/gPiTCd554
         mmAd2ViJ05BMJjRZAG9UdqWyjsnF2S+rwUxvMUlhXDEU/2BJsoW3iEpBsUSMN1q0szZY
         jwtMxcWK91BXcwKNYyICYAHz8XbQH7GMqNoz1S0USxCOlVAgZYzpvF2rcgeW3FHKWLdg
         JPDNobf0rypF4E5w7Lxs0NATV+V5NEZfjqlV8cgvD/ZFZWn8HC+ST0ZJEH54P18ePAXe
         1IRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DpOVC8gqwK4YWrrBVYqACoZ5/dJGAtrFwzBZYKGC418=;
        b=f2XpmYNNU+L5a8rrEmTgcVTU7J+ozQZ1Vpa/SO/5Ijioan4GH20FEawGO1pIeTxNqv
         ZsNOSebhvgWEDq/5g5xvcvyyLMeDQVrBjIEPCx+ZD6kJwGrqEZOOiAfHvECVTYeZvh8E
         gTjo2ICvYayYB0/vD2ndxl+BHdheuoKLf9FMUI9C53C+eY1ZE707Bh+cbLAXOxKnjUBN
         K3mIO9KE3iUMg4A7lKjVUZB9ynlTlNtO2KVs8QQYCYrXelpZq+izDbxy+gyTxr7J2Bji
         J/LxQh/rxOqcowrATNj18DAmlWhU7rxvRR3MQlTyFEO3yAjuB7ykU4WkRUwf6oTBViGO
         vFeQ==
X-Gm-Message-State: APjAAAVuy3kAz+gNz/9Wsz7O0rJAUw8M2hlEhA62YsxS2xW36KJPybrv
        7gh4SWx9dso8Qe7PbpNo5Zc5DLda
X-Google-Smtp-Source: APXvYqzI2huUC9uz6NqNo+LCkorMVs0NTxflv5ZeGUYlTqVuh3GAHJy+y3N9hRqwhexQK2BbX8G3yg==
X-Received: by 2002:aa7:9513:: with SMTP id b19mr37709135pfp.30.1564419571554;
        Mon, 29 Jul 2019 09:59:31 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id i198sm60784651pgd.44.2019.07.29.09.59.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:59:31 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        toke@redhat.com, Petar Penkov <ppenkov@google.com>
Subject: [bpf-next,v2 1/6] tcp: tcp_syn_flood_action read port from socket
Date:   Mon, 29 Jul 2019 09:59:13 -0700
Message-Id: <20190729165918.92933-2-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
In-Reply-To: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
References: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

This allows us to call this function before an SKB has been
allocated.

Signed-off-by: Petar Penkov <ppenkov@google.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
---
 net/ipv4/tcp_input.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c21e8a22fb3b..8892df6de1d4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6422,9 +6422,7 @@ EXPORT_SYMBOL(inet_reqsk_alloc);
 /*
  * Return true if a syncookie should be sent
  */
-static bool tcp_syn_flood_action(const struct sock *sk,
-				 const struct sk_buff *skb,
-				 const char *proto)
+static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 {
 	struct request_sock_queue *queue = &inet_csk(sk)->icsk_accept_queue;
 	const char *msg = "Dropping request";
@@ -6444,7 +6442,7 @@ static bool tcp_syn_flood_action(const struct sock *sk,
 	    net->ipv4.sysctl_tcp_syncookies != 2 &&
 	    xchg(&queue->synflood_warned, 1) == 0)
 		net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
-				     proto, ntohs(tcp_hdr(skb)->dest), msg);
+				     proto, sk->sk_num, msg);
 
 	return want_cookie;
 }
@@ -6487,7 +6485,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	 */
 	if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
 	     inet_csk_reqsk_queue_is_full(sk)) && !isn) {
-		want_cookie = tcp_syn_flood_action(sk, skb, rsk_ops->slab_name);
+		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
 		if (!want_cookie)
 			goto drop;
 	}
-- 
2.22.0.709.g102302147b-goog

