Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4B22871DE
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgJHJtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729206AbgJHJtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:49:10 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5E6C061755;
        Thu,  8 Oct 2020 02:49:10 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id u24so3853447pgi.1;
        Thu, 08 Oct 2020 02:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=m/TiQ2lE3m4wHvHFT6+tGQzF2YHGDHHA/t6tWuUFplI=;
        b=Mh2n3o6TWlMlmqxZvhfoaJ3SUM9HaSq59IXLN3qfTHtUB/SY8TbzX+uriDwYLr7Ryq
         Q3DJd8XEoAV8nQ3VllTImgs6k305bXg9g4TQWmLz6QHruzLgzOpgg9ocuwH4SLKXPEJ1
         usP3pRai+fJ0GtpMecN/7cJS1n5gTTDg3fjsMkrpnpkJA01+3U5FM8TO4lk/CITBjYrW
         IT7ss+h6xSNnUrj7mrXruMPgy3VTrfq0V9A2lmaFK9MKcgRhfZT5KFMMV/x9HFb26HlQ
         X6Q3A9Cuwd3mPZd14zjbBy96G7bFM8dHcuKZSK/XkZa7+Mg/++kouPaYZwgqEeVsknRn
         rl2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=m/TiQ2lE3m4wHvHFT6+tGQzF2YHGDHHA/t6tWuUFplI=;
        b=U/eAWJNVSP7gg6YZwqlXtB5A8S5k4FsNg7LkTA7WmjHth48uaITT2qbRRCVz+QZVun
         ODpGpuxoPQNzt/2QTnQ5sR3MKgDbMgPpAm09tgDTB6uZdTYjXInQfK1SUD9BvxEYaqDi
         JMOTwqZmgyC1nBj8lc2bVoZeUGv2kZgiryck95lROxBjRQTFMLW8Ie0XKsp2OyhNAADX
         MuZfN+L7eO0ifuVTH+VV7Golau7rp+fZeelRo5p9w5QkfWyz3/VAR0lV/88q8yYD1T5j
         9SFjK4VIj9gdx3OQpOHOs2Gq0pqgOdUXpqd2mLCFR3x8PlLaWhFRwJZjWV3slMVhQhMd
         SMzg==
X-Gm-Message-State: AOAM530rIOR76T+7mYS6fqXnu/cM6RqiHUVFX9jEJjuSlP1q80OUm/mJ
        a/tRvzFGsOEgF6JA2pTyLLRRWZ+zneU=
X-Google-Smtp-Source: ABdhPJwJ13I10zdzYVUNMDXLWstsg38SN77/XO3KdzzX+O7oqn8LGzuImkHHhFGvYAevB/yIAgDO7g==
X-Received: by 2002:a17:90a:46cd:: with SMTP id x13mr7389958pjg.101.1602150549827;
        Thu, 08 Oct 2020 02:49:09 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id in6sm5365987pjb.42.2020.10.08.02.49.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:49:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 06/17] sctp: create udp6 sock and set its encap_rcv
Date:   Thu,  8 Oct 2020 17:48:02 +0800
Message-Id: <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
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

