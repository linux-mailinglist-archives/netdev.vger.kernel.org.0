Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4965429E437
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgJ2HgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgJ2HY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BF4C08EA6F;
        Thu, 29 Oct 2020 00:06:02 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id e7so1548752pfn.12;
        Thu, 29 Oct 2020 00:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jd64SognjwqYRQuRMRSNbd08vn8VKgqQiHZBeDjXezk=;
        b=ckKZLJIhWPiIm8Y4HaXD5QDaspycUtrzv0Y8V+GOhz52XnRDedNY5Rn4K/xvwLSLXV
         8kLBZOpXykM9sZoQaDZtvwJDgJqVnoi5BET/1qOVcj28dBDWUDg1ypu9pbxX8tQDGlqy
         /hVkOuvCImVVHqMnpcJD3k/sIEI33A8ev6JoCChiX2j7AX5IzhHLwDILm70M9vXzLvyX
         /YHulwBjLVh3vIGX8L8iA8xv+F5V+WWDruhNzIAXop3sYHycikLk4JbOzu5I4iLCpZ2j
         FOwwWZeP95Si372Fx2uajFmhZwLUGrdLHc405vtOdGgS7/foH8vNiTqk3TUsR9HCmVNs
         D31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jd64SognjwqYRQuRMRSNbd08vn8VKgqQiHZBeDjXezk=;
        b=PZjBDXvR2ds2sr7+GKfyeQeOE5rvbcJsDIZNRn+Jv0uQOCQH29mM8RgUGwDOiyvIXa
         1wMt+HvtZy31STpPpOL+rPrQIqsAi85lDEXKQit1S5HtqMi610mMtSqCprNHwH+296PF
         0SKm2lDyIxKXbQu28pV/fJLLcgAlw14wMMyvXKvaSKzvW2yk0vRwapCMRL4p0DVb5mjV
         iyt4yW21GQAxYelbWsiEsWFvRLUYSKrmuJL5GFqlaOyOh+7n3FIyCJ0FzKgDkR76JJ9m
         w0P+Nvi+MfsIuOvZwtLYKzDBpTh0oZEn4gTQ/0V2faZUgnRHgj6R3PUAHJoQSvg+pjLd
         GnPw==
X-Gm-Message-State: AOAM530gwe4EmmJ9P9XOb54d1ZEacUvzGl+qZUQJlOEbEW+ED41DjqLf
        6x2MDthNzE57j2YWIQXgqexF4kxz3Ic=
X-Google-Smtp-Source: ABdhPJyJsojm6kvb0A+CKqF5ts5SkdNL+pbTZreTRBKOacbTYfriJoFP9rv91liwOuVbuzw/kBo79w==
X-Received: by 2002:aa7:8c50:0:b029:160:1240:493d with SMTP id e16-20020aa78c500000b02901601240493dmr2907704pfd.31.1603955161886;
        Thu, 29 Oct 2020 00:06:01 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m13sm1616003pjl.45.2020.10.29.00.06.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:06:01 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 05/16] sctp: create udp6 sock and set its encap_rcv
Date:   Thu, 29 Oct 2020 15:04:59 +0800
Message-Id: <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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
index 0f79334..8410c9a 100644
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

