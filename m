Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9008127CFDA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgI2NuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgI2NuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:50:03 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D3DC061755;
        Tue, 29 Sep 2020 06:50:03 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kk9so2691846pjb.2;
        Tue, 29 Sep 2020 06:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=0Iq5oxOzbbhd0aVMKoNrZJRhXFpOs9f+FQV8zzjXj1c=;
        b=mtwbM2QyyqVFjgnYmlijTjzNGYlifmogjjjDGaZs7+H0ycFgDOVLqQptsy7kO6oQUn
         c1h0/oNZMgKMTn9tiAcdPoI+HxjRLov2kvWRjVdGOzzDmv3laSrcB89+lof3RbQjPdWs
         VXzprzrzucmVdpaCCxhiR7k4XSjMXuCZ1Mug6jWkTu41CdnPKTHknRcbwobfeVqICh+J
         I4VyoRFeeW2vkfieo/QH8zGHO7vwfZl03X9C9SHGtC5y0KVNM5rwKq4+CRejIMsP0nGp
         /2++hAust0AEoKzLGr2rSaF1yncJW6s/FAQNNrpuAv/sSmqCdkzEeZFp4DriglOYHJhE
         3loQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=0Iq5oxOzbbhd0aVMKoNrZJRhXFpOs9f+FQV8zzjXj1c=;
        b=IJxfyfaqyLFuw/HYPnQZ5aBxSU4kr93VUf4BYTtpSyPWIojfaGYzvtbHmRxijNZRef
         hKXr+Pl8zqlgn9mhfubVQzBns/3yUOzIxCGaadRIOl5G/trZvgZ66548w7EZi0gP79vB
         VqwubtE5keyJ57V7nmAKn0tZbsqtQ+gRmtHMF9pSd/eHg8olnyr4PlxfNya79sQAyHa2
         9GgTB3Oh61qIxsMO8w0rRoocRt3scEZoFmx+UCql0E2Bmd0tXDPi4kMrsncX2r6c5UXu
         qyzAR6YLYejIQgAAPpCWjXzTMMikTZ6gq6uaIsfiuU/QKf76xUjo+B+DwCNqG6ZZu9I4
         XYAA==
X-Gm-Message-State: AOAM532BkVX3LzbVoCE5T58cptpc4yZ8O3y2PeN3iqMTOcds1KcxPek5
        1EEYLhq/cTpUKJY+T8fC8RYqyzAM/4c=
X-Google-Smtp-Source: ABdhPJzgDP1k9Kkwp+JQ+HUbQTEHVVkrFT/3bfbCI8Y+ZNT9MwiBhxAqf0eGhqNYoLUzseXEEEg8kQ==
X-Received: by 2002:a17:90a:f411:: with SMTP id ch17mr3861881pjb.38.1601387402072;
        Tue, 29 Sep 2020 06:50:02 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n28sm4891973pgb.51.2020.09.29.06.50.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:50:01 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 05/15] sctp: create udp4 sock and add its encap_rcv
Date:   Tue, 29 Sep 2020 21:48:57 +0800
Message-Id: <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the functions to create/release udp4 sock,
and set the sock's encap_rcv to process the incoming udp encap
sctp packets. In sctp_udp_rcv(), as we can see, all we need to
do is fix the transport header for sctp_rcv(), then it would
implement the part of rfc6951#section-5.4:

  "When an encapsulated packet is received, the UDP header is removed.
   Then, the generic lookup is performed, as done by an SCTP stack
   whenever a packet is received, to find the association for the
   received SCTP packet"

Note that these functions will be called in the last patch of
this patchset when enabling this feature.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h     |  5 +++++
 include/net/sctp/constants.h |  2 ++
 include/net/sctp/sctp.h      |  2 ++
 net/sctp/protocol.c          | 40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index d8d02e4..3d10bef 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -22,6 +22,11 @@ struct netns_sctp {
 	 */
 	struct sock *ctl_sock;
 
+	/* udp tunneling listening sock. */
+	struct sock *udp4_sock;
+	/* udp tunneling listening port. */
+	int udp_port;
+
 	/* This is the global local address list.
 	 * We actively maintain this complete list of addresses on
 	 * the system by catching address add/delete events.
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 122d9e2..b583166 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -286,6 +286,8 @@ enum { SCTP_MAX_GABS = 16 };
 				 * functions simpler to write.
 				 */
 
+#define SCTP_DEFAULT_UDP_PORT 9899	/* default udp tunneling port */
+
 /* These are the values for pf exposure, UNUSED is to keep compatible with old
  * applications by default.
  */
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 4fc747b..bfd87a0 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -84,6 +84,8 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *addr,
 struct sctp_pf *sctp_get_pf_specific(sa_family_t family);
 int sctp_register_pf(struct sctp_pf *, sa_family_t);
 void sctp_addr_wq_mgmt(struct net *, struct sctp_sockaddr_entry *, int);
+int sctp_udp_sock_start(struct net *net);
+void sctp_udp_sock_stop(struct net *net);
 
 /*
  * sctp/socket.c
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2583323..f194b60 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -840,6 +840,43 @@ static int sctp_ctl_sock_init(struct net *net)
 	return 0;
 }
 
+static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	skb_set_transport_header(skb, sizeof(struct udphdr));
+	sctp_rcv(skb);
+	return 0;
+}
+
+int sctp_udp_sock_start(struct net *net)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {NULL};
+	struct udp_port_cfg udp_conf = {0};
+	struct socket *sock;
+	int err;
+
+	udp_conf.family = AF_INET;
+	udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
+	udp_conf.local_udp_port = htons(net->sctp.udp_port);
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err)
+		return err;
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = sctp_udp_rcv;
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+	net->sctp.udp4_sock = sock->sk;
+
+	return 0;
+}
+
+void sctp_udp_sock_stop(struct net *net)
+{
+	if (net->sctp.udp4_sock) {
+		udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
+		net->sctp.udp4_sock = NULL;
+	}
+}
+
 /* Register address family specific functions. */
 int sctp_register_af(struct sctp_af *af)
 {
@@ -1271,6 +1308,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Enable ECN by default. */
 	net->sctp.ecn_enable = 1;
 
+	/* Set udp tunneling listening port to default value */
+	net->sctp.udp_port = SCTP_DEFAULT_UDP_PORT;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
-- 
2.1.0

