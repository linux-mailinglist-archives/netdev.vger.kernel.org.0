Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDAB369FCF
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733022AbfGPA1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:27:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32797 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731522AbfGPA1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:27:00 -0400
Received: by mail-pg1-f195.google.com with SMTP id m4so8513033pgk.0;
        Mon, 15 Jul 2019 17:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LqcoMtaNS2RyrNWMcSC9GoOqSA0YEyg/awjs8A8RAME=;
        b=Px/FQsa3tSQJxXoLMUjaU9OndIbOBbnGY6k/SM58InTW8lafOP8SVcbAO7TzsH8RcD
         4ZzyahnvMOzpTO4W4QvpZZ3B+qN6v6Efo84vfHRO+O/3SImibsE1ilVILwq3Qr0gdeyy
         JjBWS1itZDaZakY9twJ7M5lN3meT12Lp+djeRthA0fnjVMnPCwj5ktMAeidgljSGerGm
         5edeyV8t4uLoBgsIj4KmlZfeT8h4YSzBS9lcB05USYszMM3YX4MS6T+/BqndAqjqwOyT
         VjDKTOihYwQ/iqp/dDL/9zjJoWHE0qJo7mvLmE3Fg4kDTWIDLZkbksNOYf2V5mcc/kiZ
         XwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LqcoMtaNS2RyrNWMcSC9GoOqSA0YEyg/awjs8A8RAME=;
        b=WHtSFBKnNLM7FURJvXRU40cXEf9b0kOC3OvFlDKl6E4Nemm+Xle1qMe6fzvcoEnJOz
         cv2BFnehW617WffBKFz7fsT5cS1fhA/LDcDfcxByAbcX59lgoNA2fuOV/kQA7QREuSht
         dBQpwOV/xyXjmFSp6+BMRYW9dpDnwGpltZVg7byw7um5DvEK5FyQWDPqmb8NWbtOz3a1
         QB4jDQNnqnoUo6Fu6iUVUhwQ4td0PjlDZNJFTsOvMD5fGGw8cBj0D33achjQ+Z9u6vG7
         AsrKSoJ6qOzh4JmWGJ+Y99/moWAJCyDmRp3W/6r2RxQ3TbaNDuVvGtipBIGW5aCow8h5
         uVFg==
X-Gm-Message-State: APjAAAXx9TJ9Zm1FxiFw5+fgW9HIFz2WJc1QkiuKCOJkUabbfrSKSIoJ
        h4XhE5KzuzdolAJgQTiPBBxMtcN6
X-Google-Smtp-Source: APXvYqwidKBy4tABnC017nexDQQeED0DnsOUQX/Ksqw0wUmKNC4joiiHAkqklDoV3FEEOsVN4cNitg==
X-Received: by 2002:a17:90a:d14a:: with SMTP id t10mr32657581pjw.85.1563236819862;
        Mon, 15 Jul 2019 17:26:59 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id q24sm16775444pjp.14.2019.07.15.17.26.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:26:59 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next RFC 1/6] tcp: tcp_syn_flood_action read port from socket
Date:   Mon, 15 Jul 2019 17:26:45 -0700
Message-Id: <20190716002650.154729-2-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
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
2.22.0.510.g264f2c817a-goog

