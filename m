Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1AA3413DB
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 04:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhCSDxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 23:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbhCSDwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 23:52:51 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AA6C06174A;
        Thu, 18 Mar 2021 20:52:51 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id ay2so2326039plb.3;
        Thu, 18 Mar 2021 20:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sfnz0qBB7Xqx2oJDXonO+Zb1jNLuJwRHpBx0MWdaUPk=;
        b=grvzmjvn7yILucQnIiqPZ0SE4YunXci8wpbKE465kzbKfInEMH7h1apPcnZEatOrjY
         eHZZVe+xJ7r7ir2FZHE8clazVQ46zPxdfCwLVJohuxuWXPIO1fkMO4j/nTF9KvJWlVpP
         g9BgU867d4bWYW5RsriUKdgzVec6JuAGS9TzA3n74yB/X1/E6Mn6a1mE9ShWJ0529W7R
         GiMqRMvyW3U/FsFT1Csbs933kwPUsR5R8c+XKTP8zJrk4xBgzAcA53WwRPW+vGJsUfEk
         UfFHT9b553h95Icg41L5ILtUkgvWKZG3b7hstlLryXSDNQtHAReot72p9GzV2qUMmX+q
         +SfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sfnz0qBB7Xqx2oJDXonO+Zb1jNLuJwRHpBx0MWdaUPk=;
        b=BhnV0OxNPRrsvp+qM/6mvrOgl5XLqSgHP1L1YyRSx3+avf0xPW4yOJwru5JegR9Rqc
         vEKICYoRJxWBY2TW/3rTwr3WgHyurjpgRF8G6mvHmx7VHxd3MAndtOJFGkuN1+wGtmnU
         PiEOoI2Z+QhfVsFsDqdCH9grEcnSe+nOya6k666DSxb/jBaD/vFtGnBXvQNREWGRpWxB
         KXiRtf0H4QCqivtrI+rNGVPFKvCWPuTBJk3tQJ0k2Oj362QqLhiak8PK8A7SDBv3ete8
         sIPwtSwLwVU1oyt79FxsLlBsH25hnn44ZjqaiO08sJgODa5circ1afa3Cj0x1Zbn8dcY
         Kv6A==
X-Gm-Message-State: AOAM530nyODrhhUzeBuSz02EpwI5VnNfvA4vAvpXXEWQGWj/D+wCW0+t
        Im+CGvfmbTD9koHfobP8ic6Nr80NYe5t7Q==
X-Google-Smtp-Source: ABdhPJxwM4sWDm+qzdKz6puM1+0YgocT0BrGwvnYqprLDzsKxztN2H9J4+wxF+iNEhou6LKwmhFxQw==
X-Received: by 2002:a17:902:a707:b029:e6:52fd:a14d with SMTP id w7-20020a170902a707b02900e652fda14dmr13126876plq.34.1616125970383;
        Thu, 18 Mar 2021 20:52:50 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w26sm3593643pfn.33.2021.03.18.20.52.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Mar 2021 20:52:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH] sctp: move sk_route_caps check and set into sctp_outq_flush_transports
Date:   Fri, 19 Mar 2021 11:52:41 +0800
Message-Id: <9db6df3e544dd6ec6e4ec5091b0a750ac08d6e1b.1616125961.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sk's sk_route_caps is set in sctp_packet_config, and later it
only needs to change when traversing the transport_list in a loop,
as the dst might be changed in the tx path.

So move sk_route_caps check and set into sctp_outq_flush_transports
from sctp_packet_transmit. This also fixes a dst leak reported by
Chen Yi:

  https://bugzilla.kernel.org/show_bug.cgi?id=212227

As calling sk_setup_caps() in sctp_packet_transmit may also set the
sk_route_caps for the ctrl sock in a netns. When the netns is being
deleted, the ctrl sock's releasing is later than dst dev's deleting,
which will cause this dev's deleting to hang and dmesg error occurs:

  unregister_netdevice: waiting for xxx to become free. Usage count = 1

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: bcd623d8e9fa ("sctp: call sk_setup_caps in sctp_packet_transmit instead")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c   | 7 -------
 net/sctp/outqueue.c | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 6614c9f..a6aa17d 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -584,13 +584,6 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 		goto out;
 	}
 
-	rcu_read_lock();
-	if (__sk_dst_get(sk) != tp->dst) {
-		dst_hold(tp->dst);
-		sk_setup_caps(sk, tp->dst);
-	}
-	rcu_read_unlock();
-
 	/* pack up chunks */
 	pkt_count = sctp_packet_pack(packet, head, gso, gfp);
 	if (!pkt_count) {
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 3fd06a2..5cb1aa5 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1135,6 +1135,7 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 
 static void sctp_outq_flush_transports(struct sctp_flush_ctx *ctx)
 {
+	struct sock *sk = ctx->asoc->base.sk;
 	struct list_head *ltransport;
 	struct sctp_packet *packet;
 	struct sctp_transport *t;
@@ -1144,6 +1145,12 @@ static void sctp_outq_flush_transports(struct sctp_flush_ctx *ctx)
 		t = list_entry(ltransport, struct sctp_transport, send_ready);
 		packet = &t->packet;
 		if (!sctp_packet_empty(packet)) {
+			rcu_read_lock();
+			if (t->dst && __sk_dst_get(sk) != t->dst) {
+				dst_hold(t->dst);
+				sk_setup_caps(sk, t->dst);
+			}
+			rcu_read_unlock();
 			error = sctp_packet_transmit(packet, ctx->gfp);
 			if (error < 0)
 				ctx->q->asoc->base.sk->sk_err = -error;
-- 
2.1.0

