Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637DB29273E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgJSM0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbgJSM0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:26:36 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2BCC0613D0;
        Mon, 19 Oct 2020 05:26:36 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id e7so5906368pfn.12;
        Mon, 19 Oct 2020 05:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Wqdx6TvNLjNAKe3Cl+m74emPKACgsPJgGCH97yUVs7Y=;
        b=gQF9KitsX99l3hukGrcrx4whAQJfjjoFIbY6kmduMaVnGBEylEzCihjzgwh+bKNBP2
         BfUwwgm55v5I7VmT+LzmZ83KTQBlogLK5wu4gRt1U4zONn0Nw0SM8H1JdY+bfVH+1Imo
         S3f+uNiwaGlvw/nuwGHCviVsfhOS1E9XcUXF/TuB9j7KOhkYPLcqWET0SPkl5bum0nF/
         jSeetDMy6SepggQkcRb/U7aacyrC9M9YO2VIkyI/zfUErcKjv1lISvedrtB6Fy2MT6fK
         6VVEA6gLJOGYKRbPOtw0Ef6l5RHLXJVkWD/IFGDznlB9EYcOipediAMWQEruJ5de6JxU
         ga/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Wqdx6TvNLjNAKe3Cl+m74emPKACgsPJgGCH97yUVs7Y=;
        b=MLvmzL+TPI+d1992UqMba2ICer+3D7utz9K0lGmpYZd6U/sKZ9y96V/MCD96AS1hPi
         zo4Ctp6rFRCwdtOZ3of+/UpGaEUwq6B80j7Oiaxk5i8cCFvtxDLr9qWwkvznFDmK7Yhi
         4gmPDxEYobE8YCtm3CKyAvYZZMTbdC0t0+XwVA39ItclRdOatATnzdwRbT908SycCC/K
         kTv5ObKCWILS/U/1inVReJWBzcvpdbszdVfmabrFB1G+dHV1r79DU7juaS+3571HmTp+
         LOU2AH1OvLumgRqGCeZVL8GYpS3ieBaEQn0JT65ZgU1LmBPWfkPqeYf4NtVikfEw6fk2
         r6pA==
X-Gm-Message-State: AOAM533XW518bvubUVIh0uxuJK8ss58XfaYLy3C9rmstrESEBTeFbU0p
        tx6wc+nlGCMUsdSHnQPFHdu3Ug9I0xk=
X-Google-Smtp-Source: ABdhPJziFE52laDgyWOBlRFx7u+HqP3U+iump7wsGNkYOTF3MrIH2WKkuWcwvEXRibOJNXJ0yTXGvA==
X-Received: by 2002:a63:e502:: with SMTP id r2mr4726962pgh.362.1603110395825;
        Mon, 19 Oct 2020 05:26:35 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s126sm11983457pgc.27.2020.10.19.05.26.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:26:35 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 07/16] sctp: add encap_port for netns sock asoc and transport
Date:   Mon, 19 Oct 2020 20:25:24 +0800
Message-Id: <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  9 +++++++++
 include/net/netns/sctp.h               |  2 ++
 include/net/sctp/structs.h             |  6 ++++++
 net/sctp/associola.c                   |  4 ++++
 net/sctp/protocol.c                    |  3 +++
 net/sctp/socket.c                      |  1 +
 net/sctp/sysctl.c                      | 10 ++++++++++
 7 files changed, 35 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 837d51f..3909305 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2640,6 +2640,15 @@ addr_scope_policy - INTEGER
 
 	Default: 1
 
+encap_port - INTEGER
+	The default remote UDP encapsalution port.
+	When UDP tunneling is enabled, this global value is used to set
+	the dest port for the udp header of outgoing packets by default.
+	Users can also change the value for each sock/asoc/transport by
+	using setsockopt.
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
index aa8e5b2..7c729d7 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1359,6 +1359,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Set UDP tunneling listening port to default value */
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

