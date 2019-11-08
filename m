Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318F7F3FBB
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbfKHFVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:21:18 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:34559 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730268AbfKHFVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:21:17 -0500
Received: by mail-pl1-f179.google.com with SMTP id k7so3287755pll.1;
        Thu, 07 Nov 2019 21:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jc3l67xyQEPXPNEHSGvIuL4hU3WHuMxsFHqC+kHwtwo=;
        b=FCIob4ixx962E3QVUIB6PPRoeW8/5XT97nAqMKKwzrXAI/l6B78NafhJXcojLDApas
         /B7K3plJChqcJPBxmmVVhTQ9Mi4eZRZbVgvHTetZ7cqVt6oej7d+lFDH/xuB8fkcA+TS
         N6ukj6ICK43jNs+UTYpDyAGCbHDjrn9JBjbD9LJ9wWStKrz3uBXAntQcmeO0FZScScHm
         SfBL5huzC2KRuCGiNfXmB79khm/wlDIXe/mQQfxalsr38rPuuZJexZBby5FcQXk2kZDs
         L1fd/JfH84L8hbP9fv50UjCJWenTyfKl61XJcoGuy6rTYGr5/VkesC3TGjsUJh5qNCUb
         8TqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jc3l67xyQEPXPNEHSGvIuL4hU3WHuMxsFHqC+kHwtwo=;
        b=uVPmDS9vjsChz9XfO356jGwPU7QuEfrhATdZIG4wJ8+nqg3oQ/6vqpCoJCYPSHsjIj
         D4X1ABvW2OYqfljGZk06nikKVqdljqk0OXCGcyWaHssLvU3gh2/pFvgwZFTI1lfgQBBe
         ESdr4RfFdiiQcMJmjaivWXiVSFz4uaMkjQg7fmh7sbmSr/0WZf9rPKJzCB2jQFysRFvD
         oA7YYGoMKbU1LmA8WcKbgvd1XSolC4FTy+Q5XrhkGA89VOqRF1RcFmqMZHeqbNI9P79q
         iUKXWHNZ/0MYM7nqYTVg/c9mWBKb9l9wN9YzdVvOw1byd4r6MPS+aZTdE2Dbg2n67H8d
         QK3A==
X-Gm-Message-State: APjAAAU4M12LRLQV/LAOrw0/gLLegr9pa52qh6p/wrRk8PY/glyFTbcg
        G3YZFann6ROvOeA24qhCp/EMW/Ji
X-Google-Smtp-Source: APXvYqx3QXkolwErhbK37uQfAyhvXWAr/fScYJyIlhJFLShz6JTZi9p+6TsAu6zHgyN97kv42OkQ3A==
X-Received: by 2002:a17:90a:3390:: with SMTP id n16mr10306574pjb.53.1573190476348;
        Thu, 07 Nov 2019 21:21:16 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 31sm7135815pgy.63.2019.11.07.21.21.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 21:21:15 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv4 net-next 4/5] sctp: add support for Primary Path Switchover
Date:   Fri,  8 Nov 2019 13:20:35 +0800
Message-Id: <55f4edd068149ff8bd2c15023f181b07baef7ad0.1573190212.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <45e03c4050ed2f122b6a4e19ebd6a532087088d3.1573190212.git.lucien.xin@gmail.com>
References: <cover.1573190212.git.lucien.xin@gmail.com>
 <d008eb59f963118ae264e0151da79c382f16a69b.1573190212.git.lucien.xin@gmail.com>
 <7fa091e035b70859acbfd74ea06fcb3064c4bef7.1573190212.git.lucien.xin@gmail.com>
 <45e03c4050ed2f122b6a4e19ebd6a532087088d3.1573190212.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1573190212.git.lucien.xin@gmail.com>
References: <cover.1573190212.git.lucien.xin@gmail.com>
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

v3->v4:
  - add define SCTP_PS_RETRANS_MAX 0xffff, and use it on extra2 of
    sysctl 'ps_retrans'.
  - add a new entry for ps_retrans on ip-sysctl.txt.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 Documentation/networking/ip-sysctl.txt | 12 ++++++++++++
 include/net/netns/sctp.h               |  6 ++++++
 include/net/sctp/constants.h           |  2 ++
 include/net/sctp/structs.h             | 11 ++++++++---
 net/sctp/associola.c                   |  3 +++
 net/sctp/protocol.c                    |  3 +++
 net/sctp/sm_sideeffect.c               |  5 +++++
 net/sctp/socket.c                      |  1 +
 net/sctp/sysctl.c                      | 12 +++++++++++-
 9 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index ad374b4..33c1d16 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -2192,6 +2192,18 @@ pf_retrans - INTEGER
 
 	Default: 0
 
+ps_retrans - INTEGER
+	Primary.Switchover.Max.Retrans (PSMR), it's a tunable parameter coming
+	from section-5 "Primary Path Switchover" in rfc7829.  The primary path
+	will be changed to another active path when the path error counter on
+	the old primary path exceeds PSMR, so that "the SCTP sender is allowed
+	to continue data transmission on a new working path even when the old
+	primary destination address becomes active again".   Note this feature
+	is disabled by initializing 'ps_retrans' per netns as 0xffff by default,
+	and its value can't be less than 'pf_retrans' when changing by sysctl.
+
+	Default: 0xffff
+
 rto_initial - INTEGER
 	The initial round trip timeout value in milliseconds that will be used
 	in calculating round trip times.  This is the initial time interval
diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index 18c3dda..d8d02e4 100644
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
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index e88b77a..15b4d9a 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -296,6 +296,8 @@ enum {
 };
 #define SCTP_PF_EXPOSE_MAX	SCTP_PF_EXPOSE_ENABLE
 
+#define SCTP_PS_RETRANS_MAX	0xffff
+
 /* These return values describe the success or failure of a number of
  * routines which form the lower interface to SCTP_outqueue.
  */
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
index c183d0e..4725ca4 100644
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
index f86be7b..fbbf191 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1217,6 +1217,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Max.Burst		    - 4 */
 	net->sctp.max_burst			= SCTP_DEFAULT_MAX_BURST;
 
+	/* Disable of Primary Path Switchover by default */
+	net->sctp.ps_retrans = SCTP_PS_RETRANS_MAX;
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
index 5d1ad44..4740aa7 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -35,6 +35,7 @@ static int rto_beta_min = 0;
 static int rto_alpha_max = 1000;
 static int rto_beta_max = 1000;
 static int pf_expose_max = SCTP_PF_EXPOSE_MAX;
+static int ps_retrans_max = SCTP_PS_RETRANS_MAX;
 
 static unsigned long max_autoclose_min = 0;
 static unsigned long max_autoclose_max =
@@ -213,7 +214,16 @@ static struct ctl_table sctp_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_INT_MAX,
+		.extra2		= &init_net.sctp.ps_retrans,
+	},
+	{
+		.procname	= "ps_retrans",
+		.data		= &init_net.sctp.ps_retrans,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &init_net.sctp.pf_retrans,
+		.extra2		= &ps_retrans_max,
 	},
 	{
 		.procname	= "sndbuf_policy",
-- 
2.1.0

