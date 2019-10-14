Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB3D5B21
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 08:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbfJNGPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 02:15:32 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:41351 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729992AbfJNGPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 02:15:32 -0400
Received: by mail-pg1-f169.google.com with SMTP id t3so9447360pga.8;
        Sun, 13 Oct 2019 23:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=4kt8ltg5CXei01fbtUImKkvdU713LKFiqm1ftuV9G9c=;
        b=EcLNgWcbvwwIjW3H5ZAw2wi/CzqL3S2rxfGKb9+fqVM9u4bju5y9DmXbwr3lAd6M8W
         eUrfxfCq7f2UIOHxd0VRKa0QZ1x5Et+Vh79SUE5991FU0J5NS8Z+iRBWc2t9bb/AwXe9
         rYxBqwYqpABHMpmU9KKlwxNDFO7QDJgVnW5EMYKLsYjs49IPsjjr1LwC3cOMx/UGgCq3
         nlFkzvJ5UbTwseR8FaYYlMTJJo6SBRQtybEuumC7YsA1tgpcIjUTmTg6rJc/0xU8g28a
         sl1tjWxP0VjoWYet+FyVYqMczJZmR9mzPoCMEx4zCPirQnfzuk7F7VLB0HDeAIOt72yg
         fk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=4kt8ltg5CXei01fbtUImKkvdU713LKFiqm1ftuV9G9c=;
        b=NeIx09s52mci/m29bccH/4L3mDJ/uehTzYxhn6CKmUN3kDIKdkACXypADfqHZpZUDT
         WWcxNwMn9hZ6Y2017N8I3akxWzHB0ANqhpoiGBZBUqK7PZY/S6AI9qlDWxAXNcpBnxN1
         n2+QCzgQSeeX4jHWDiZ6TvSjgU/DUmjya3x3dBixWGlCdzO6t0D8rxvLTI6VB+a/m9tv
         Wjj4ujMeHFGfSMaPp8zTIZjNM1bxBFV9H4hg64akHEcU3MCvU4HPQ5EnJ0kQvRuym2IK
         qhZwBv9hX86dnR1anZM61Y1qrzw9VBcLhEhX2aDue67HFrgjmgy8MHisykHsJJk+Q2yI
         SvSw==
X-Gm-Message-State: APjAAAX1T+cHldBfdYF0e/O2PXHScoCHrFDfsNwneSjVpS5mWCq0n6jj
        0xUjWCxnA2IrgfJnL4FbJrUDqamV
X-Google-Smtp-Source: APXvYqy9sBQi5qexE7R0I56GoaOA0tcuyZ12NjEF+dBOzOO7RZh3lPAa9sGaONOMROfFLWUx1E5pVw==
X-Received: by 2002:a17:90a:1aa9:: with SMTP id p38mr35407928pjp.142.1571033731220;
        Sun, 13 Oct 2019 23:15:31 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t11sm14144439pjy.10.2019.10.13.23.15.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Oct 2019 23:15:30 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv3 net-next 4/5] sctp: add support for Primary Path Switchover
Date:   Mon, 14 Oct 2019 14:14:47 +0800
Message-Id: <06d05b274999621fef3e7a006444ac76dadb7725.1571033544.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <eedcaeabec9253902de381b75ffc00c007fcd2b6.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
 <eedcaeabec9253902de381b75ffc00c007fcd2b6.1571033544.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a new feature defined in section 5 of rfc7829: "Primary Path
Switchover". By introducing a new tunable parameter:

  Primary.Switchover.Max.Retrans (PSMR)

The primary path will be changed to another active path when the path
error counter on the old primary path exceeds PSMR, so that "the SCTP
sender is allowed to continue data transmission on a new working path
even when the old primary destination address becomes active again".

This patch is to add this tunable parameter, 'ps_retrans' per netns,
sock, asoc and transport. It also allows a user to change ps_retrans
per netns by sysctl, and ps_retrans per sock/asoc/transport will be
initialized with it.

The check will be done in sctp_do_8_2_transport_strike() when this
feature is enabled.

Note this feature is disabled by initializing 'ps_retrans' per netns
as 0xffff by default, and its value can't be less than 'pf_retrans'
when changing by sysctl.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |  6 ++++++
 include/net/sctp/structs.h | 11 ++++++++---
 net/sctp/associola.c       |  3 +++
 net/sctp/protocol.c        |  3 +++
 net/sctp/sm_sideeffect.c   |  5 +++++
 net/sctp/socket.c          |  1 +
 net/sctp/sysctl.c          |  9 +++++++++
 7 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index f97d342..c41ffdf 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -89,6 +89,12 @@ struct netns_sctp {
 	 */
 	int pf_retrans;
 
+	/* Primary.Switchover.Max.Retrans sysctl value
+	 * taken from:
+	 * https://tools.ietf.org/html/rfc7829
+	 */
+	int ps_retrans;
+
 	/*
 	 * Disable Potentially-Failed feature, the feature is enabled by default
 	 * pf_enable	-  0  : disable pf
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 9a43738..3cc913f 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -184,7 +184,8 @@ struct sctp_sock {
 	__u32 flowlabel;
 	__u8  dscp;
 
-	int pf_retrans;
+	__u16 pf_retrans;
+	__u16 ps_retrans;
 
 	/* The initial Path MTU to use for new associations. */
 	__u32 pathmtu;
@@ -897,7 +898,9 @@ struct sctp_transport {
 	 * and will be initialized from the assocs value.  This can be changed
 	 * using the SCTP_PEER_ADDR_THLDS socket option
 	 */
-	int pf_retrans;
+	__u16 pf_retrans;
+	/* Used for primary path switchover. */
+	__u16 ps_retrans;
 	/* PMTU	      : The current known path MTU.  */
 	__u32 pathmtu;
 
@@ -1773,7 +1776,9 @@ struct sctp_association {
 	 * and will be initialized from the assocs value.  This can be
 	 * changed using the SCTP_PEER_ADDR_THLDS socket option
 	 */
-	int pf_retrans;
+	__u16 pf_retrans;
+	/* Used for primary path switchover. */
+	__u16 ps_retrans;
 
 	/* Maximum number of times the endpoint will retransmit INIT  */
 	__u16 max_init_attempts;
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 46763c5..a839244 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -86,6 +86,7 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->max_retrans = sp->assocparams.sasoc_asocmaxrxt;
 	asoc->pf_retrans  = sp->pf_retrans;
+	asoc->ps_retrans  = sp->ps_retrans;
 	asoc->pf_expose   = sp->pf_expose;
 
 	asoc->rto_initial = msecs_to_jiffies(sp->rtoinfo.srto_initial);
@@ -628,6 +629,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 
 	/* And the partial failure retrans threshold */
 	peer->pf_retrans = asoc->pf_retrans;
+	/* And the primary path switchover retrans threshold */
+	peer->ps_retrans = asoc->ps_retrans;
 
 	/* Initialize the peer's SACK delay timeout based on the
 	 * association configured value.
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index a18c7c4..ea1de9b 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1217,6 +1217,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Max.Burst		    - 4 */
 	net->sctp.max_burst			= SCTP_DEFAULT_MAX_BURST;
 
+	/* Disable of Primary Path Switchover by default */
+	net->sctp.ps_retrans = 0xffff;
+
 	/* Enable pf state by default */
 	net->sctp.pf_enable = 1;
 
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index e52b212..acd737d 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -567,6 +567,11 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
 					     SCTP_FAILED_THRESHOLD);
 	}
 
+	if (transport->error_count > transport->ps_retrans &&
+	    asoc->peer.primary_path == transport &&
+	    asoc->peer.active_path != transport)
+		sctp_assoc_set_primary(asoc, asoc->peer.active_path);
+
 	/* E2) For the destination address for which the timer
 	 * expires, set RTO <- RTO * 2 ("back off the timer").  The
 	 * maximum value discussed in rule C7 above (RTO.max) may be
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index eccd689..38d102b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5078,6 +5078,7 @@ static int sctp_init_sock(struct sock *sk)
 	sp->hbinterval  = net->sctp.hb_interval;
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
+	sp->ps_retrans  = net->sctp.ps_retrans;
 	sp->pf_expose   = net->sctp.pf_expose;
 	sp->pathmtu     = 0; /* allow default discovery */
 	sp->sackdelay   = net->sctp.sack_timeout;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 5d1ad44..adf264a 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -213,6 +213,15 @@ static struct ctl_table sctp_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
+		.extra2		= &init_net.sctp.ps_retrans,
+	},
+	{
+		.procname	= "ps_retrans",
+		.data		= &init_net.sctp.ps_retrans,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &init_net.sctp.pf_retrans,
 		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
-- 
2.1.0

