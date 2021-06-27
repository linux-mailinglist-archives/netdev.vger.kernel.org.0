Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21163B55A7
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 00:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhF0Wu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 18:50:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231742AbhF0Wuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 18:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624834110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9DTMqAiUjVgFsuTlbhIERFaFI8LvYnpEk0sSTBHsk0=;
        b=OP2UJVEAkt3DXZO9/rTxizfQ+N3M0sLIMq78S4SuZ/JHeIyE/BQ875T1/gnJNhI1UxFzxv
        KF/IJ/eyZVp+8mII6dRdbsTG8XAYSHixO8cCDH5nB1DCfogNKQAAuuTOLT5Pqs9xqz0OmE
        hfNse1/60G2rtlzOGi3UcgfcslY9twU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-fXGweDW4Pw6ykNDOYXFVDg-1; Sun, 27 Jun 2021 18:48:29 -0400
X-MC-Unique: fXGweDW4Pw6ykNDOYXFVDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D2FD1842154;
        Sun, 27 Jun 2021 22:48:28 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-243.rdu2.redhat.com [10.10.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA8785C1CF;
        Sun, 27 Jun 2021 22:48:27 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org
Subject: [PATCHv2 net-next 2/2] net: sock: add trace for socket errors
Date:   Sun, 27 Jun 2021 18:48:22 -0400
Message-Id: <20210627224822.4689-3-aahringo@redhat.com>
In-Reply-To: <20210627224822.4689-1-aahringo@redhat.com>
References: <20210627224822.4689-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will add tracers to trace inet socket errors only. A user
space monitor application can track connection errors indepedent from
socket lifetime and do additional handling. For example a cluster
manager can fence a node if errors occurs in a specific heuristic.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 include/trace/events/sock.h | 60 +++++++++++++++++++++++++++++++++++++
 net/core/sock.c             | 10 +++++++
 2 files changed, 70 insertions(+)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index a966d4b5ab37..12c315782766 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -201,6 +201,66 @@ TRACE_EVENT(inet_sock_set_state,
 			show_tcp_state_name(__entry->newstate))
 );
 
+TRACE_EVENT(inet_sk_error_report,
+
+	TP_PROTO(const struct sock *sk),
+
+	TP_ARGS(sk),
+
+	TP_STRUCT__entry(
+		__field(int, error)
+		__field(__u16, sport)
+		__field(__u16, dport)
+		__field(__u16, family)
+		__field(__u16, protocol)
+		__array(__u8, saddr, 4)
+		__array(__u8, daddr, 4)
+		__array(__u8, saddr_v6, 16)
+		__array(__u8, daddr_v6, 16)
+	),
+
+	TP_fast_assign(
+		struct inet_sock *inet = inet_sk(sk);
+		struct in6_addr *pin6;
+		__be32 *p32;
+
+		__entry->error = sk->sk_err;
+		__entry->family = sk->sk_family;
+		__entry->protocol = sk->sk_protocol;
+		__entry->sport = ntohs(inet->inet_sport);
+		__entry->dport = ntohs(inet->inet_dport);
+
+		p32 = (__be32 *) __entry->saddr;
+		*p32 = inet->inet_saddr;
+
+		p32 = (__be32 *) __entry->daddr;
+		*p32 =  inet->inet_daddr;
+
+#if IS_ENABLED(CONFIG_IPV6)
+		if (sk->sk_family == AF_INET6) {
+			pin6 = (struct in6_addr *)__entry->saddr_v6;
+			*pin6 = sk->sk_v6_rcv_saddr;
+			pin6 = (struct in6_addr *)__entry->daddr_v6;
+			*pin6 = sk->sk_v6_daddr;
+		} else
+#endif
+		{
+			pin6 = (struct in6_addr *)__entry->saddr_v6;
+			ipv6_addr_set_v4mapped(inet->inet_saddr, pin6);
+			pin6 = (struct in6_addr *)__entry->daddr_v6;
+			ipv6_addr_set_v4mapped(inet->inet_daddr, pin6);
+		}
+	),
+
+	TP_printk("family=%s protocol=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c error=%d",
+		  show_family_name(__entry->family),
+		  show_inet_protocol_name(__entry->protocol),
+		  __entry->sport, __entry->dport,
+		  __entry->saddr, __entry->daddr,
+		  __entry->saddr_v6, __entry->daddr_v6,
+		  __entry->error)
+);
+
 #endif /* _TRACE_SOCK_H */
 
 /* This part must be outside protection */
diff --git a/net/core/sock.c b/net/core/sock.c
index c30f8f4cbb22..ba1c0f75cd45 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -334,6 +334,16 @@ EXPORT_SYMBOL(__sk_backlog_rcv);
 void sk_error_report(struct sock *sk)
 {
 	sk->sk_error_report(sk);
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		fallthrough;
+	case AF_INET6:
+		trace_inet_sk_error_report(sk);
+		break;
+	default:
+		break;
+	}
 }
 EXPORT_SYMBOL(sk_error_report);
 
-- 
2.26.3

