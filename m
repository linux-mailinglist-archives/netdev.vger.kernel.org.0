Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9299E4395CD
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhJYMQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbhJYMQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:16:41 -0400
X-Greylist: delayed 69 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Oct 2021 05:14:18 PDT
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B48C061348
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 05:14:18 -0700 (PDT)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 87AEA2E19CB;
        Mon, 25 Oct 2021 15:13:06 +0300 (MSK)
Received: from sas2-d40aa8807eff.qloud-c.yandex.net (2a02:6b8:c08:b921:0:640:d40a:a880 [2a02:6b8:c08:b921:0:640:d40a:a880])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id Dxf9on6fH3-D6umiVbT;
        Mon, 25 Oct 2021 15:13:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635163986; bh=wwORDBwWC2HI1hVUur0PkhEfeaL0su2hjidUnYrVcSE=;
        h=Date:Subject:To:From:Message-Id:Cc;
        b=en8ioFQIqk3FiJLewulAAazykge3zCmEQHKLFIKdTzp+8kUZj1wJHK88pVudGovOX
         zG6g3Mna6V6OeqgFJUaIRfQFKwjepivx7mdc6NuZWzA0VrCt2te9TeK3fGxAMZRknw
         nRAMSJOvkaAcbvp6SJHT2c0CiEFkV1CFlJQCM2SM=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (2a02:6b8:c07:895:0:696:abd4:0 [2a02:6b8:c07:895:0:696:abd4:0])
        by sas2-d40aa8807eff.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id m7VxuhwG7r-D6xC6djq;
        Mon, 25 Oct 2021 15:13:06 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     hmukos@yandex-team.ru, mitradir@yandex-team.ru,
        zeil@yandex-team.ru, brakmo@fb.com
Subject: [PATCH] tcp: Use BPF timeout setting for SYN ACK RTO
Date:   Mon, 25 Oct 2021 15:12:53 +0300
Message-Id: <20211025121253.8643-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting RTO through BPF program, SYN ACK packets were unaffected and
continued to use TCP_TIMEOUT_INIT constant. This patch makes SYN ACK
retransmits use tcp_timeout_init() function instead.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 net/ipv4/tcp_minisocks.c        | 4 ++--
 net/ipv4/tcp_timer.c            | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 0d477c816309..41663d1ffd0a 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -870,7 +870,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 
 		if (req->num_timeout++ == 0)
 			atomic_dec(&queue->young);
-		timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
+		timeo = min(tcp_timeout_init((struct sock *)req) << req->num_timeout, TCP_RTO_MAX);
 		mod_timer(&req->rsk_timer, jiffies + timeo);
 
 		if (!nreq)
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0a4f3f16140a..8ddc3aa9e3a6 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -590,7 +590,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			 * it can be estimated (approximately)
 			 * from another data.
 			 */
-			tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((TCP_TIMEOUT_INIT/HZ)<<req->num_timeout);
+			tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((tcp_timeout_init((struct sock *)req)/HZ)<<req->num_timeout);
 			paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
 		}
 	}
@@ -629,7 +629,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		    !inet_rtx_syn_ack(sk, req)) {
 			unsigned long expires = jiffies;
 
-			expires += min(TCP_TIMEOUT_INIT << req->num_timeout,
+			expires += min(tcp_timeout_init((struct sock *)req) << req->num_timeout,
 				       TCP_RTO_MAX);
 			if (!fastopen)
 				mod_timer_pending(&req->rsk_timer, expires);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 20cf4a98c69d..0954e3685ad2 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -430,7 +430,7 @@ static void tcp_fastopen_synack_timer(struct sock *sk, struct request_sock *req)
 	if (!tp->retrans_stamp)
 		tp->retrans_stamp = tcp_time_stamp(tp);
 	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
-			  TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
+			  tcp_timeout_init((struct sock *)req) << req->num_timeout, TCP_RTO_MAX);
 }
 
 
-- 
2.17.1

