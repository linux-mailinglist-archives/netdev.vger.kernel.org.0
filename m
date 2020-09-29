Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978B327CFE0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730657AbgI2Nua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730617AbgI2Nua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:50:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54B1C061755;
        Tue, 29 Sep 2020 06:50:29 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f18so4586072pfa.10;
        Tue, 29 Sep 2020 06:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=QbnzsGp5pnURiuLTAjTdwEtqIkPvBJMdIPJb7oM9S30=;
        b=lUrUCZ2+JUK+A1wEbeLWE2X/13Fcuskb6PnJZbH1gUZloWi1J3fHeAsrp8rl2BthSR
         UNWGFGPTATq+AXUsxpRff6SB1UbUmafRLZs+8bOVQw6I5OHIU4DByWtKzHbtj0hZeAPh
         9LQv+e8+IjjrUr38MrypTujSDvj54bkoqJZEMCXyEgHVwV7ntlQNqUVjz+2UxOG9UO8W
         2hKRoyxfk6E6rCotsytgcCUzZX8KFntt35U0P/iwa5RJ+TfBI5QPOUfQQhhPS9r2Al82
         uTwAkr0alU/7rkiTrC5h1lZzwLU0Jo8tHoLoBpYOhHZzuYXAZ6Mv+Lfb6vBbSk9ou8dQ
         W0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=QbnzsGp5pnURiuLTAjTdwEtqIkPvBJMdIPJb7oM9S30=;
        b=CD+g+gHdK2LoSGEavXmMF6IExgdFd5V8GmVPpdVry6NqGcbUggf1hRps6qGgTFRq6X
         HRO2EDm23KdOqnmNOUK4UN1hgTvjrMjAcNSOkiYSTdPSKzDy402gopDa1o7B0C6UwEud
         Q7yk6BR2jQ2zHEHd9kiO3dx8Tcat/DCNw5tXUO/1qi2pwEnuo5Vmm9xLp0SnjlXi31FM
         BbAm6aqWBJrgY797JTtYEvc9JodPVGPApGhN610zcVHoL9FbSYZDeruOtJ9SI0PMtHtM
         oOG3pC53hhKhfkSGQ61euqZqYoXzzdYPQuqmHblVHe7p/unLQ94YLvP8DWvOEuwDcQU9
         RS5w==
X-Gm-Message-State: AOAM532Kx+S/FQbnqblN8tjuff6Y5HWkUgaJqL7W/guuKmz75TTwSVOs
        NaKGnllm0Pstrv9o+VAuj2CIrWRqt54=
X-Google-Smtp-Source: ABdhPJxkkOrGFThDdpayhEqloiia6Qa6SpWmDK58ihyH/Mz6yEcw7dpDWiMlwW41fy7Y5zlubzkxkQ==
X-Received: by 2002:a17:902:8689:b029:d1:9bf7:230a with SMTP id g9-20020a1709028689b02900d19bf7230amr4836326plo.22.1601387428636;
        Tue, 29 Sep 2020 06:50:28 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g9sm5796741pfo.144.2020.09.29.06.50.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:50:27 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 08/15] sctp: add encap_port for netns sock asoc and transport
Date:   Tue, 29 Sep 2020 21:49:00 +0800
Message-Id: <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
 <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

encap_port is added as per netns/sock/assoc/transport, and the
latter one's encap_port inherits the former one's by default.
The transport's encap_port value would mostly decide if one
packet should go out with udp encaped or not.

This patch also allows users to set netns's encap_port by sysctl.

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
index 0bdff38..b6d0e58 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -178,6 +178,8 @@ struct sctp_sock {
 	 */
 	__u32 hbinterval;
 
+	__u16 encap_port;
+
 	/* This is the max_retrans value for new associations. */
 	__u16 pathmaxrxt;
 
@@ -877,6 +879,8 @@ struct sctp_transport {
 	 */
 	unsigned long last_time_ecne_reduced;
 
+	__u16 encap_port;
+
 	/* This is the max_retrans value for the transport and will
 	 * be initialized from the assocs value.  This can be changed
 	 * using the SCTP_SET_PEER_ADDR_PARAMS socket option.
@@ -1790,6 +1794,8 @@ struct sctp_association {
 	 */
 	unsigned long hbinterval;
 
+	__u16 encap_port;
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
index 953891b..8b788bd 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1353,6 +1353,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Set udp tunneling listening port to default value */
 	net->sctp.udp_port = SCTP_DEFAULT_UDP_PORT;
 
+	/* Set remote encap port to 0 by default */
+	net->sctp.encap_port = 0;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 53d0a41..9aa0c3d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4876,6 +4876,7 @@ static int sctp_init_sock(struct sock *sk)
 	 * be modified via SCTP_PEER_ADDR_PARAMS
 	 */
 	sp->hbinterval  = net->sctp.hb_interval;
+	sp->encap_port  = net->sctp.encap_port;
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

