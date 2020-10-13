Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898DB28C944
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390161AbgJMH22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390091AbgJMH21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:28:27 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8241BC0613D2;
        Tue, 13 Oct 2020 00:28:27 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 1so4352735ple.2;
        Tue, 13 Oct 2020 00:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=m/TiQ2lE3m4wHvHFT6+tGQzF2YHGDHHA/t6tWuUFplI=;
        b=KkOHeQyo6RZwUmm55eI4756KtTSZjL7yXR7rQmlrZTH2vspBv5OtS+lWiJy1ocwu9o
         kZMQFLxMEgsyKOQORv88r86e6viBFWSGXvImsMeVY+pYANC8R74awzxrAdr/+0OFicry
         +mm5k5lP607RFOT74bO0/N49vhkGP3oIsN3nj1utVRxfEHWEkWT3TKM1M2VUaV1ktFtz
         jCkRJo7MmFCYwnHrmI6RqmgF/5VYp4O1kMD47rxvi5xcNooOMyr4RsEdsUGXt2e4gBZh
         2ilMWwE2aDvhqjB6Ap9g1BCFSLALcRxOOYhJGdM4hts6pc46YHi77VuV6MG/B16Y1af9
         A+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=m/TiQ2lE3m4wHvHFT6+tGQzF2YHGDHHA/t6tWuUFplI=;
        b=Vf7ZZSoBhAi/tGJGgmZw9fKflKyX2JvJQekZEkZ6B//ms0GJoGlul8P0/5CGAdG4EL
         4W6FyNeJvFqDE+rsPzKc0DRzUi8ln8Joa8UHfIkQqMqEe78fXUbo4llGiafH6OE67C89
         7/+gmPJzktSYVo265ZIBLu1jTqExByd/6ThqYV5L3aAIC0OESxkujnXJ/jpXCt2Diev2
         8SbNHfuBQYGZjMK0OyEtOELvsNHpOZfyXzRvd2LVFbjtsUifiIzZ6qBDuwixMT1vgdnP
         N7VDra9AjZvpADMQLCpixJKsB4LwxJYuFSf1nM8ZvyJC4uVby+TU4AO5cJHrkTXUFGMM
         7E9w==
X-Gm-Message-State: AOAM5313bbu81qSYtsU9YQ9kJffvx321uWYGG908J2B106LOQOU3w7rx
        18liuSnMjxdlAg0izIztX4NeUEsuFbI=
X-Google-Smtp-Source: ABdhPJwZfiJj93Vtq9dUob//y0QeY816BJW19Ay9seVdbPjf9XvjLyevb4WgMQ7zoTglHZbdK2kJoQ==
X-Received: by 2002:a17:902:a588:b029:d3:7f4a:28a2 with SMTP id az8-20020a170902a588b02900d37f4a28a2mr26848525plb.26.1602574106800;
        Tue, 13 Oct 2020 00:28:26 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a18sm20733153pgw.50.2020.10.13.00.28.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:28:26 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 05/16] sctp: create udp6 sock and set its encap_rcv
Date:   Tue, 13 Oct 2020 15:27:30 +0800
Message-Id: <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the udp6 sock part in sctp_udp_sock_start/stop().
udp_conf.use_udp6_rx_checksums is set to true, as:

   "The SCTP checksum MUST be computed for IPv4 and IPv6, and the UDP
    checksum SHOULD be computed for IPv4 and IPv6"

says in rfc6951#section-5.3.

v1->v2:
  - Add pr_err() when fails to create udp v6 sock.
  - Add #if IS_ENABLED(CONFIG_IPV6) not to create v6 sock when ipv6 is
    disabled.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h |  1 +
 net/sctp/protocol.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index 3d10bef..f622945 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -24,6 +24,7 @@ struct netns_sctp {
 
 	/* udp tunneling listening sock. */
 	struct sock *udp4_sock;
+	struct sock *udp6_sock;
 	/* udp tunneling listening port. */
 	int udp_port;
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2b7a3e1..49b5d75 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -869,6 +869,28 @@ int sctp_udp_sock_start(struct net *net)
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp4_sock = sock->sk;
 
+#if IS_ENABLED(CONFIG_IPV6)
+	memset(&udp_conf, 0, sizeof(udp_conf));
+
+	udp_conf.family = AF_INET6;
+	udp_conf.local_ip6 = in6addr_any;
+	udp_conf.local_udp_port = htons(net->sctp.udp_port);
+	udp_conf.use_udp6_rx_checksums = true;
+	udp_conf.ipv6_v6only = true;
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err) {
+		pr_err("Failed to create the SCTP udp tunneling v6 sock\n");
+		udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
+		net->sctp.udp4_sock = NULL;
+		return err;
+	}
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = sctp_udp_rcv;
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+	net->sctp.udp6_sock = sock->sk;
+#endif
+
 	return 0;
 }
 
@@ -878,6 +900,10 @@ void sctp_udp_sock_stop(struct net *net)
 		udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
 		net->sctp.udp4_sock = NULL;
 	}
+	if (net->sctp.udp6_sock) {
+		udp_tunnel_sock_release(net->sctp.udp6_sock->sk_socket);
+		net->sctp.udp6_sock = NULL;
+	}
 }
 
 /* Register address family specific functions. */
-- 
2.1.0

