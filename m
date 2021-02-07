Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BC83122A3
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhBGI1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhBGIYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:24:03 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C2CC06174A
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 00:23:22 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id w18so7714361pfu.9
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 00:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CGMHvSq3if5tp5UZkwnR7Oxg+sBArXFbBsUKFYjaXoo=;
        b=alkVTMYPkb3WtAgxyzkdI6u84MhmoU/ZuLV/7zJSihJj24xj9rzBI8TmclHJcz9w9C
         4Ra3oOAIgBeUXe9QNd2tsaRjA9E3GAshU3X/M2rS092PJBlsOqEyrXl+YQIeZBveoz6b
         Rwu3ES4yfhDzuGz+sH4IhclaL5N3G5noHQb/Db+v8YNmoud4GlklGUs6R/gGM8lCeMHG
         q7jsTETIk0MT5s+KF0HggshiCJeXZRGv6FoQLdnIOkEm2VrdGjvB3YHf891qPsWRSJ7N
         AFtC9HVINq3WwwnxSG571f0tCtu6yXRR/MpBz8hY5yR/Ik52FfwGf13XcBsYQXFBHKQX
         cqAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CGMHvSq3if5tp5UZkwnR7Oxg+sBArXFbBsUKFYjaXoo=;
        b=CnJOu64x4a+ggVferz4rOHLhwC7UOP/lbrGxWzyNRLIf38GkrAeF0dLS1Asi66u3My
         QLyYIeSSR/TCClEVsUNjEDVXLjf7EOmzv4R8pMe2n03eeBxIuaVUwTDD1VgSXHEmQpqF
         Acg5osjVakbY+XaQ5yog8Xrf6vJHFDNB7O8r9+HGfrkRM747VnLTXr7Ef13RHZlHp9Q3
         7f89N6+cTiBYFPG8E4eHMnPqC6GoDKxM5GKt6JEb+MqrIgNUfRLMV/tEjmfn2TWg1Tif
         EBXqk5CKAlr0XqymH/qi61Qfw9aOLM7Rey22tqsIDzeuGlPT9/V9IyTCpmVjadt3E2y6
         tkSw==
X-Gm-Message-State: AOAM532u/kOVinj3D/xuauV+Nu2XUrck0D0Enu18U7GKlW4/9343xhPJ
        6EFf++XVclWE80SNIwfgOc+JNT9FRjuTog==
X-Google-Smtp-Source: ABdhPJxy2qZwp4yvK8pYyWSp7pDWZtxUT7qlcQak6xPBVjh1Pe5xiJcgylk7Y9fUZqs7ks0aB5E77g==
X-Received: by 2002:a05:6a00:1506:b029:1bc:6f53:8eb8 with SMTP id q6-20020a056a001506b02901bc6f538eb8mr12496190pfu.36.1612686202005;
        Sun, 07 Feb 2021 00:23:22 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm4339285pjh.43.2021.02.07.00.23.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Feb 2021 00:23:21 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH net-next] rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket
Date:   Sun,  7 Feb 2021 16:23:14 +0800
Message-Id: <33e11905352da3b65354622dcd2f7d2c3c00c645.1612686194.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rxrpc_open_socket(), now it's using sock_create_kern() and
kernel_bind() to create a udp tunnel socket, and other kernel
APIs to set up it. These code can be replaced with udp tunnel
APIs udp_sock_create() and setup_udp_tunnel_sock(), and it'll
simplify rxrpc_open_socket().

Note that with this patch, the udp tunnel socket will always
bind to a random port if transport is not provided by users,
which is suggested by David Howells, thanks!

Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/rxrpc/local_object.c | 69 +++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 45 deletions(-)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 33b4936..546fd23 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -107,54 +107,42 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
  */
 static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 {
+	struct udp_tunnel_sock_cfg tuncfg = {NULL};
+	struct sockaddr_rxrpc *srx = &local->srx;
+	struct udp_port_cfg udp_conf = {0};
 	struct sock *usk;
 	int ret;
 
 	_enter("%p{%d,%d}",
-	       local, local->srx.transport_type, local->srx.transport.family);
-
-	/* create a socket to represent the local endpoint */
-	ret = sock_create_kern(net, local->srx.transport.family,
-			       local->srx.transport_type, 0, &local->socket);
+	       local, srx->transport_type, srx->transport.family);
+
+	udp_conf.family = srx->transport.family;
+	if (udp_conf.family == AF_INET) {
+		udp_conf.local_ip = srx->transport.sin.sin_addr;
+		udp_conf.local_udp_port = srx->transport.sin.sin_port;
+	} else {
+		udp_conf.local_ip6 = srx->transport.sin6.sin6_addr;
+		udp_conf.local_udp_port = srx->transport.sin6.sin6_port;
+	}
+	ret = udp_sock_create(net, &udp_conf, &local->socket);
 	if (ret < 0) {
 		_leave(" = %d [socket]", ret);
 		return ret;
 	}
 
+	tuncfg.encap_type = UDP_ENCAP_RXRPC;
+	tuncfg.encap_rcv = rxrpc_input_packet;
+	tuncfg.sk_user_data = local;
+	setup_udp_tunnel_sock(net, local->socket, &tuncfg);
+
 	/* set the socket up */
 	usk = local->socket->sk;
-	inet_sk(usk)->mc_loop = 0;
-
-	/* Enable CHECKSUM_UNNECESSARY to CHECKSUM_COMPLETE conversion */
-	inet_inc_convert_csum(usk);
-
-	rcu_assign_sk_user_data(usk, local);
-
-	udp_sk(usk)->encap_type = UDP_ENCAP_RXRPC;
-	udp_sk(usk)->encap_rcv = rxrpc_input_packet;
-	udp_sk(usk)->encap_destroy = NULL;
-	udp_sk(usk)->gro_receive = NULL;
-	udp_sk(usk)->gro_complete = NULL;
-
-	udp_tunnel_encap_enable(local->socket);
 	usk->sk_error_report = rxrpc_error_report;
 
-	/* if a local address was supplied then bind it */
-	if (local->srx.transport_len > sizeof(sa_family_t)) {
-		_debug("bind");
-		ret = kernel_bind(local->socket,
-				  (struct sockaddr *)&local->srx.transport,
-				  local->srx.transport_len);
-		if (ret < 0) {
-			_debug("bind failed %d", ret);
-			goto error;
-		}
-	}
-
-	switch (local->srx.transport.family) {
+	switch (srx->transport.family) {
 	case AF_INET6:
 		/* we want to receive ICMPv6 errors */
-		ip6_sock_set_recverr(local->socket->sk);
+		ip6_sock_set_recverr(usk);
 
 		/* Fall through and set IPv4 options too otherwise we don't get
 		 * errors from IPv4 packets sent through the IPv6 socket.
@@ -162,13 +150,13 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 		fallthrough;
 	case AF_INET:
 		/* we want to receive ICMP errors */
-		ip_sock_set_recverr(local->socket->sk);
+		ip_sock_set_recverr(usk);
 
 		/* we want to set the don't fragment bit */
-		ip_sock_set_mtu_discover(local->socket->sk, IP_PMTUDISC_DO);
+		ip_sock_set_mtu_discover(usk, IP_PMTUDISC_DO);
 
 		/* We want receive timestamps. */
-		sock_enable_timestamps(local->socket->sk);
+		sock_enable_timestamps(usk);
 		break;
 
 	default:
@@ -177,15 +165,6 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 
 	_leave(" = 0");
 	return 0;
-
-error:
-	kernel_sock_shutdown(local->socket, SHUT_RDWR);
-	local->socket->sk->sk_user_data = NULL;
-	sock_release(local->socket);
-	local->socket = NULL;
-
-	_leave(" = %d", ret);
-	return ret;
 }
 
 /*
-- 
2.1.0

