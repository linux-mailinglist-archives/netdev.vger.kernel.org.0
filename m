Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00CF29273A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgJSM0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgJSM0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:26:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32E6C0613D0;
        Mon, 19 Oct 2020 05:26:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j8so5621404pjy.5;
        Mon, 19 Oct 2020 05:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=DR4Juetdp2wmKQu69ZewqLs9ujt7Fs4Ku72FITIp7pc=;
        b=sQ68S+s5JeuUWOaOqD3Thoieb5YO/+Wgsna9R9w7akoYcd0vteyTKPzrKEtWKX2Zo7
         ejJeuU7iHl8mvKa96rlamJom7nNOfSWAQT3eSUF4f5vdWStYMSxAMPgFwyoyIqcNxm2O
         y6HbiDB4vszXWcdKUDYgCV74+oHVEM0bfdPaK7D2vfM+SW9zqKvxADhLiBCJodOP8l/8
         O/D0w6pSy9aaRJKiTvJn9JcFptZpHmrwKaOSAJDerqxM3J+JKLSJ8RN0H1gQnYU89dBw
         eHFJWMD8XsqY6bbqvN3dtc1eC92MWHVwPJ+SOAIl/JxWTCaEVnyL+0tzbkoDhF79tieU
         5R+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=DR4Juetdp2wmKQu69ZewqLs9ujt7Fs4Ku72FITIp7pc=;
        b=L5j4euNiZ8JL8wjYj+rpv5qKGlgfNjh3iL7I7eiC98JFbO68Nj82/0ZdtKsC8ohPrj
         12qAK7SxHnvZchiFIUsKE9yooUiH6nSgECwiZ9Q+qeynNm58tA9ty8wVQgniixbs9uMd
         cEJHVdfeg+QhuXQyRcQDk87FhmYSsiS7wtFBhaK36OklCXQLVccQ4mT7lpk6jKMwdNWK
         Lr7U2KNIHl6IpJh+hAYGIUQifz9FWvaVBhJNjnJ8p2rtPOnyQCgeSE50IZFLYXO1p4Wq
         ur5PgaviuUaDJV6P+IocUhBRufzuIkDDy716MjuBHpuDqcvk5GMxfrvBsFQtA+3rPG5+
         UlhA==
X-Gm-Message-State: AOAM532UkKKQl8gQT1MhesLXiR6D0QNt5effHdzZ5PpDYa+dG/wYCdZE
        EwEMFmFZciK1SI0q20O93GQJMrJmUlo=
X-Google-Smtp-Source: ABdhPJxkiyCWRCSHdP+Um6xrTovnnR0BtNN/orNGDQwVJRsEyLpci/I9BHisQzG64cbqEwEW1QxCiA==
X-Received: by 2002:a17:902:7795:b029:d5:cc4a:f970 with SMTP id o21-20020a1709027795b02900d5cc4af970mr13620014pll.63.1603110378931;
        Mon, 19 Oct 2020 05:26:18 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x1sm12232212pjj.25.2020.10.19.05.26.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:26:18 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 05/16] sctp: create udp6 sock and set its encap_rcv
Date:   Mon, 19 Oct 2020 20:25:22 +0800
Message-Id: <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
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
index 8cc9aff..247b401 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -24,6 +24,7 @@ struct netns_sctp {
 
 	/* UDP tunneling listening sock. */
 	struct sock *udp4_sock;
+	struct sock *udp6_sock;
 	/* UDP tunneling listening port. */
 	int udp_port;
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6fb03fc..e1501e7 100644
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
+		pr_err("Failed to create the SCTP UDP tunneling v6 sock\n");
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

