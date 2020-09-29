Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD6D27CFDC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgI2NuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgI2NuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:50:11 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B416C061755;
        Tue, 29 Sep 2020 06:50:11 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k8so4615591pfk.2;
        Tue, 29 Sep 2020 06:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Mcp71Li2jeDCKDUTmLEX1lM2xlcdhbiRa5IPyXEKtXY=;
        b=L7WY8hO52hXp6TSMCnleWTUSPYEJcELKK/Lnkf54hDv50ZdsnWGwgbUZ7HD4SagO/o
         alnknLO7exXwYVtaadMIUt4rmL+rlYkXWoWX+7rWUh3/SHbmXLycG+q6TFzxJLvdgHEb
         oRT/gBMqWDz5J8Iv9GTJgyXLhUk+d2S00JNLPI3ADed2f4jGJlM0kOvASzFwk3PfXpNL
         AldYz41kZW1ZZhLOQPy6aU3kP3omgqxiskKFoBnwvWPBTQ2qU2yHu1wVK2J2LSxlcoob
         j1A7cVwPWbbKp5sj7jvmbDa72aA1p2OXMuee8a/TUNoEAdZi3z8W/NpWKE8nDdT2SE2s
         qsiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Mcp71Li2jeDCKDUTmLEX1lM2xlcdhbiRa5IPyXEKtXY=;
        b=RTpCsvbAQ3b4irVxWq/JBEPjGGit9nOOXKyDxWspVUxXfecrGBJ+qjnQmHhIem7nAn
         LkWvBhweG9nTgasR7modY54VWbEcJKbewetwxMI2qFgS2U+C+lWJFY5dv3XyJjUY+Vtk
         gmHNzVcacYfkplRJ4DVoeOO9xrwHhTsRK5D9J4XVsBdotAEZ6ek1Yh2ZDJaxc6WMgSDd
         570uVozWfNXJidykeFsm0uRmsNDbyykiXqo3Hj7/i7nbIK7laDYrKEV93/Gr827HS8h4
         cTaWFnGlIW47YpZlQ96YqCfSCVV2+vT9kiiwPRvSqv7pW2+ZZybZ1NU9lYKW4SNlBxLq
         RuXg==
X-Gm-Message-State: AOAM532ox4/Rttzuk7HEWIFQJhlO2KoBuGqZNlJOOiFZyeQuHk9exiei
        jqijL6QRugMfhv8OcDHFlZtcYUJMy+E=
X-Google-Smtp-Source: ABdhPJx2ASqprsHqBolZoU6KcZ8VDKmXbpTWm/7SrdEvPvMixhsJ+8LXQgMAYuy4a7wu66BVcvz1Wg==
X-Received: by 2002:a62:242:0:b029:14f:8e68:e7c6 with SMTP id 63-20020a6202420000b029014f8e68e7c6mr4266930pfc.54.1601387410574;
        Tue, 29 Sep 2020 06:50:10 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s16sm4858175pgl.78.2020.09.29.06.50.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:50:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 06/15] sctp: create udp6 sock and set its encap_rcv
Date:   Tue, 29 Sep 2020 21:48:58 +0800
Message-Id: <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the udp6 sock part in sctp_udp_sock_start/stop().
udp_conf.use_udp6_rx_checksums is set to true, as:

   "The SCTP checksum MUST be computed for IPv4 and IPv6, and the UDP
    checksum SHOULD be computed for IPv4 and IPv6"

says in rfc6951#section-5.3.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h |  1 +
 net/sctp/protocol.c      | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

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
index f194b60..0aaa24d 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -866,6 +866,25 @@ int sctp_udp_sock_start(struct net *net)
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp4_sock = sock->sk;
 
+	memset(&udp_conf, 0, sizeof(udp_conf));
+
+	udp_conf.family = AF_INET6;
+	udp_conf.local_ip6 = in6addr_any;
+	udp_conf.local_udp_port = htons(net->sctp.udp_port);
+	udp_conf.use_udp6_rx_checksums = true;
+	udp_conf.ipv6_v6only = true;
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err) {
+		udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
+		net->sctp.udp4_sock = NULL;
+		return err;
+	}
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = sctp_udp_rcv;
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+	net->sctp.udp6_sock = sock->sk;
+
 	return 0;
 }
 
@@ -875,6 +894,10 @@ void sctp_udp_sock_stop(struct net *net)
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

