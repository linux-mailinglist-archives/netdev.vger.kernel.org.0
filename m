Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDA928C948
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390200AbgJMH2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390091AbgJMH2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:28:44 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FEAC0613D0;
        Tue, 13 Oct 2020 00:28:44 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c6so10200366plr.9;
        Tue, 13 Oct 2020 00:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=0NQ6rBAGodZmng5U9FvOVx+JoVKAYom7BvJGxpJCao4=;
        b=JCeB98aqlxMGo+CULqPIXQnAZcJdcX/EmpMVzPzpwYPBqMm3J2s7xn9MXUZo3yUOaT
         ogO4qvqJ/JV84G2XhDb8Tg5RxnIwqFn6rOiZRry32hzyMJeFpbfY1dttFFIYHv49wl41
         oSy6yrnHUd1e+SK1Z20XMfN8pYjCGMFIqx0JR13Egc8FHy2JXFyQTwNqH+I1qMT9Oe1s
         to9JPInAdekIpuyTH7FiBsXQvQbJg1S2uFaKfRoCHRt3WDb1RdvcG8KL7yDWOzRWz2rg
         N5yhTOg/ucWpOFEDCobqB7xtOMO3MVJpj8YHYXpzHYrG8fZuS5Rnd5lCpl2WdhJIwoJu
         jFNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=0NQ6rBAGodZmng5U9FvOVx+JoVKAYom7BvJGxpJCao4=;
        b=spoMLzU5ztYrvhmO2HpXORXikFuiIrY/5yh4a7tJC3flDx7GwM7Riw2PaavGNMzaaH
         8dWXXfa69q62TXt5B9LCsGxELGytdW91bbkmBz0lEkjCcn3osryj3mT1/SuSKtsTMe64
         /MxqsmIxK2DEoDTVMz2Z7rRZFtQzSK6uAF7NUynt4Od/P8vR3ARDvRWb0bXI5m31g1jN
         H1cIwnUsIFE8A1kWilcBRBUv0upzQRQLXCpr1rgQJEj3WFHLqgIXWn+qMi0AHcThjmU3
         cELgsaeCqbgEIQ/7vfWkb7Po8/u+I8MN/V9dLE5DZrRCCqk/41uUGbNRY+L3yAigObfj
         368g==
X-Gm-Message-State: AOAM532Xf3HQx1laeLoLlV80AS9zSFl1kx0t/l4n8seP4CSCganqBVFf
        6xy9lVgBJmDTBisduXKcAPD3sGX3O2A=
X-Google-Smtp-Source: ABdhPJxiiCen6QQLRqOAm9vQEWxtVkW+t7lPhUFr5THqEM29AaDHUUqtj5RPRODRDUOvtBglFrXz5w==
X-Received: by 2002:a17:902:6b4a:b029:d3:e8f4:3356 with SMTP id g10-20020a1709026b4ab02900d3e8f43356mr27906581plt.0.1602574123605;
        Tue, 13 Oct 2020 00:28:43 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x18sm22663228pfj.90.2020.10.13.00.28.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:28:42 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 07/16] sctp: add encap_port for netns sock asoc and transport
Date:   Tue, 13 Oct 2020 15:27:32 +0800
Message-Id: <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
 <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

encap_port is added as per netns/sock/assoc/transport, and the
latter one's encap_port inherits the former one's by default.
The transport's encap_port value would mostly decide if one
packet should go out with udp encapsulated or not.

This patch also allows users to set netns' encap_port by sysctl.

v1->v2:
  - Change to define encap_port as __be16 for sctp_sock, asoc and
    transport.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |  2 ++
 include/net/sctp/structs.h |  6 ++++++
 net/sctp/associola.c       |  4 ++++
 net/sctp/protocol.c        |  3 +++
 net/sctp/socket.c          |  1 +
 net/sctp/sysctl.c          | 10 ++++++++++
 6 files changed, 26 insertions(+)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index f622945..6af7a39 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -27,6 +27,8 @@ struct netns_sctp {
 	struct sock *udp6_sock;
 	/* udp tunneling listening port. */
 	int udp_port;
+	/* udp tunneling remote encap port. */
+	int encap_port;
 
 	/* This is the global local address list.
 	 * We actively maintain this complete list of addresses on
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 0bdff38..aa98e7e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -178,6 +178,8 @@ struct sctp_sock {
 	 */
 	__u32 hbinterval;
 
+	__be16 encap_port;
+
 	/* This is the max_retrans value for new associations. */
 	__u16 pathmaxrxt;
 
@@ -877,6 +879,8 @@ struct sctp_transport {
 	 */
 	unsigned long last_time_ecne_reduced;
 
+	__be16 encap_port;
+
 	/* This is the max_retrans value for the transport and will
 	 * be initialized from the assocs value.  This can be changed
 	 * using the SCTP_SET_PEER_ADDR_PARAMS socket option.
@@ -1790,6 +1794,8 @@ struct sctp_association {
 	 */
 	unsigned long hbinterval;
 
+	__be16 encap_port;
+
 	/* This is the max_retrans value for new transports in the
 	 * association.
 	 */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index fdb69d4..336df4b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -99,6 +99,8 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->hbinterval = msecs_to_jiffies(sp->hbinterval);
 
+	asoc->encap_port = sp->encap_port;
+
 	/* Initialize path max retrans value. */
 	asoc->pathmaxrxt = sp->pathmaxrxt;
 
@@ -624,6 +626,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	 */
 	peer->hbinterval = asoc->hbinterval;
 
+	peer->encap_port = asoc->encap_port;
+
 	/* Set the path max_retrans.  */
 	peer->pathmaxrxt = asoc->pathmaxrxt;
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index dd2d9c4..5b74187 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1359,6 +1359,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Set udp tunneling listening port to default value */
 	net->sctp.udp_port = SCTP_DEFAULT_UDP_PORT;
 
+	/* Set remote encap port to 0 by default */
+	net->sctp.encap_port = 0;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 53d0a41..09b94cd 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4876,6 +4876,7 @@ static int sctp_init_sock(struct sock *sk)
 	 * be modified via SCTP_PEER_ADDR_PARAMS
 	 */
 	sp->hbinterval  = net->sctp.hb_interval;
+	sp->encap_port  = htons(net->sctp.encap_port);
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
 	sp->ps_retrans  = net->sctp.ps_retrans;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index c16c809..ecc1b5e 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -36,6 +36,7 @@ static int rto_alpha_max = 1000;
 static int rto_beta_max = 1000;
 static int pf_expose_max = SCTP_PF_EXPOSE_MAX;
 static int ps_retrans_max = SCTP_PS_RETRANS_MAX;
+static int udp_port_max = 65535;
 
 static unsigned long max_autoclose_min = 0;
 static unsigned long max_autoclose_max =
@@ -291,6 +292,15 @@ static struct ctl_table sctp_net_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "encap_port",
+		.data		= &init_net.sctp.encap_port,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &udp_port_max,
+	},
+	{
 		.procname	= "addr_scope_policy",
 		.data		= &init_net.sctp.scope_policy,
 		.maxlen		= sizeof(int),
-- 
2.1.0

