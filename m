Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9B129E405
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgJ2H0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgJ2HY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:59 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B516CC08EA71;
        Thu, 29 Oct 2020 00:06:19 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y14so1552997pfp.13;
        Thu, 29 Oct 2020 00:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=YDqQ2Sn2AyCuVnszp8b8RNjs6d8vIK5S3JVlE5v5nOM=;
        b=D6P/4TEgppesVO+JazbyL4Q7yOwFraU8YCyJKuguOk8/Da3XqC4UXUmBp6Pk0PncEY
         XEF8oXS+XzTmkKRTWKAaFkVkpprWze3FkFaHARg6lFiytlI/aIUQY6cndu9tVLuBp/tt
         ZAYS2bDh8PgThAmiWNuAw1jSiM8Q7OD4LWf0iqu2gqB6yevFryWbjZR2QE3l4gmimSNH
         taRmhbkNCVEB2sfCOnEFdZJt2XRAPaPocvwp679ZH3PTc5q1n17MQkuIXfaE4DbZ2qY5
         FKJvFOiYHiWnyTfgYN28uNXT1TKL0PCDQKCZv10rUFCRQjtXSE3F63PaoH5V66RGKu5H
         mZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=YDqQ2Sn2AyCuVnszp8b8RNjs6d8vIK5S3JVlE5v5nOM=;
        b=r8MvLrLwC4kfuMJMEw3cZnh9N4+CL8GxkuvjDAnoHLOyk64hDvtm1ii6IkHsROZbDV
         R26WbRLYF12gFsPbkxTLBx+FVs4XFqUUXpd4mL5Ng8s7TBDghgJAtTilJIg5hzkTTz+s
         PC1ZXkKKGmn+0lHI7hM06KeC44JcNpfv/op5GzW6uQ131v+IVZGXby09rxpuzbI+P7G3
         QDBZKxG4fYbsFER9GU+o8E+ls/Hj4ZOCxMz0/iRNqYVJdxnnlhS/bsO9Ai+TLLKaekTb
         o0QuvuQKO/PKIS5V1eDxZC6QrssADS4zvREgxT94hG+hABlSfvEDju7jdT3BQ6riYXGs
         pCeQ==
X-Gm-Message-State: AOAM5304xmRNuZBL/ZrECp27XbxwhKP2jbBUCcUQZOthU1dFZl9QKEaY
        k1znQ9ygk5z3FX3Nx5tssVOWwjtwyGM=
X-Google-Smtp-Source: ABdhPJwGQWv8UQAhKdY5CRJuxZQHwAaZSf8JFQP938yHD77pnFKOO6x3T7dP/ToR5igVzSkJwdbiPw==
X-Received: by 2002:a17:90a:ed02:: with SMTP id kq2mr2962291pjb.8.1603955178905;
        Thu, 29 Oct 2020 00:06:18 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j23sm1438184pjn.42.2020.10.29.00.06.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:06:18 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 07/16] sctp: add encap_port for netns sock asoc and transport
Date:   Thu, 29 Oct 2020 15:05:01 +0800
Message-Id: <066bbdcf83188bbc62b6c458f2a0fd8f06f41640.1603955040.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
 <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
 <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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
v2->v3:
  - No change.
v3->v4:
  - Add 'encap_port' entry in ip-sysctl.rst.
v4->v5:
  - Improve the description of encap_port in ip-sysctl.rst.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 16 ++++++++++++++++
 include/net/netns/sctp.h               |  2 ++
 include/net/sctp/structs.h             |  6 ++++++
 net/sctp/associola.c                   |  4 ++++
 net/sctp/protocol.c                    |  3 +++
 net/sctp/socket.c                      |  1 +
 net/sctp/sysctl.c                      | 10 ++++++++++
 7 files changed, 42 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 25e6673..dad3ba9 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2642,6 +2642,22 @@ addr_scope_policy - INTEGER
 
 	Default: 1
 
+encap_port - INTEGER
+	The default remote UDP encapsulation port.
+
+	This value is used to set the dest port of the UDP header for the
+	outgoing UDP-encapsulated SCTP packets by default. Users can also
+	change the value for each sock/asoc/transport by using setsockopt.
+	For further information, please refer to RFC6951.
+
+	Note that when connecting to a remote server, the client should set
+	this to the port that the UDP tunneling sock on the peer server is
+	listening to and the local UDP tunneling sock on the client also
+	must be started. On the server, it would get the encap_port from
+	the incoming packet's source port.
+
+	Default: 0
+
 
 ``/proc/sys/net/core/*``
 ========================
diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index 247b401..a0f315e 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -27,6 +27,8 @@ struct netns_sctp {
 	struct sock *udp6_sock;
 	/* UDP tunneling listening port. */
 	int udp_port;
+	/* UDP tunneling remote encap port. */
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
index 4d12a0c..89dfd31 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1359,6 +1359,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Set UDP tunneling listening port to 0 by default */
 	net->sctp.udp_port = 0;
 
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

