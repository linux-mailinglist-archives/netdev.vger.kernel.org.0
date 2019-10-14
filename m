Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF38AD5B1D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 08:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbfJNGPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 02:15:15 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:40526 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfJNGPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 02:15:15 -0400
Received: by mail-pf1-f180.google.com with SMTP id x127so9767278pfb.7;
        Sun, 13 Oct 2019 23:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=hPmihtgKUBMWFLHb3GG5tiDUkbYL9TwWWzVf9MbRIa4=;
        b=rX4Mu0ojjX9OHlXvMKJS3J9WA024OEQDT7thjqXjVVlS6rfkqj5vaWhREBYVKBJ1Ms
         772MEqDI7n4fAcRqdNOLafeBSSBFGSz2b/3Mlz5sSHWryAkrS71IY6Qx0miBdd5jMDY7
         pRUe9n7jVShrR1kZJNf43uanQYa94nVfZ8Raaho8FrlfRhdxfJgWFO3pUiHfW9eQyJZ7
         iTzH9cWuc+JLjTKOeKiucQ0jVPiEKMy3OMUnV7B6EXYXiwuT78l/+qweR8nHce1iG/fP
         J/kxFtDK8xzKvNKacD+kkfEmKZfU2DE3aSEdcJSN3gAGxfGAWMuETN1Lcr5Uhs8dWIFI
         aF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=hPmihtgKUBMWFLHb3GG5tiDUkbYL9TwWWzVf9MbRIa4=;
        b=Bk2UE9nGEy671BQMs+JIbQH7CU37ozi4075bi5sFzqmn7XXqcNrZYvUATxUCy1yAIb
         xeLZ+0V+BzFDa6lG8nGSJ5Ikz2IvHL8KjCbGV0dWpDuros63ruQ8FGnfc5w1gS9oQ70X
         /iIc2q8GBgq3KKOHqvDUsu8q3OMUpaQUGH1UqUVXjzQmXSEUQhByR4gW1JRhSgGLrCUS
         Sj3zeQNg+PAo9y3iU6pZjI6lo88GP5mlDxUf3wJBX2hNRqxxaneTkGUC2yx+nY+LWLzj
         7PpmVAgVzo0HcJ9xBJ8UWsTzq+6ghLnJzpk/c8zQnre61UdQbsCaso44pq9r1YUaG9Nn
         XyCw==
X-Gm-Message-State: APjAAAUW+stsa4+k5zqelOMr8ZjK0djxzvxrpZ5WFbgQ4UBi4QiVJhUZ
        kzgtSohoZW7qei2rmPzJ1GT3POGQ
X-Google-Smtp-Source: APXvYqzeX4dWMClO5lx5IdaGVpzdS4b60cDh0wxoosgnVPAxqekmVIadO3G9HRsUWv/bP7YeRXYJyw==
X-Received: by 2002:a63:7a54:: with SMTP id j20mr11400603pgn.355.1571033713823;
        Sun, 13 Oct 2019 23:15:13 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s202sm20530034pfs.24.2019.10.13.23.15.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Oct 2019 23:15:13 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv3 net-next 2/5] sctp: add pf_expose per netns and sock and asoc
Date:   Mon, 14 Oct 2019 14:14:45 +0800
Message-Id: <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As said in rfc7829, section 3, point 12:

  The SCTP stack SHOULD expose the PF state of its destination
  addresses to the ULP as well as provide the means to notify the
  ULP of state transitions of its destination addresses from
  active to PF, and vice versa.  However, it is recommended that
  an SCTP stack implementing SCTP-PF also allows for the ULP to be
  kept ignorant of the PF state of its destinations and the
  associated state transitions, thus allowing for retention of the
  simpler state transition model of [RFC4960] in the ULP.

Not only does it allow to expose the PF state to ULP, but also
allow to ignore sctp-pf to ULP.

So this patch is to add pf_expose per netns, sock and asoc. And in
sctp_assoc_control_transport(), ulp_notify will be set to false if
asoc->expose is not set.

It also allows a user to change pf_expose per netns by sysctl, and
pf_expose per sock and asoc will be initialized with it.

Note that pf_expose also works for SCTP_GET_PEER_ADDR_INFO sockopt,
to not allow a user to query the state of a sctp-pf peer address
when pf_expose is not enabled, as said in section 7.3.

v1->v2:
  - Fix a build warning noticed by Nathan Chancellor.
v2->v3:
  - set pf_expose to UNUSED by default to keep compatible with old
    applications.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h     |  8 ++++++++
 include/net/sctp/constants.h | 10 ++++++++++
 include/net/sctp/structs.h   |  2 ++
 include/uapi/linux/sctp.h    |  1 +
 net/sctp/associola.c         | 13 ++++++++++---
 net/sctp/protocol.c          |  3 +++
 net/sctp/socket.c            | 13 +++++++++++--
 net/sctp/sysctl.c            | 10 ++++++++++
 8 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index bdc0f27..f97d342 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -97,6 +97,14 @@ struct netns_sctp {
 	int pf_enable;
 
 	/*
+	 * Disable Potentially-Failed state exposure, ignored by default
+	 * pf_expose	-  0  : disable pf state exposure
+	 *		-  1  : enable  pf state exposure
+	 *		-  2  : compatible with old applications (by default)
+	 */
+	int pf_expose;
+
+	/*
 	 * Policy for preforming sctp/socket accounting
 	 * 0   - do socket level accounting, all assocs share sk_sndbuf
 	 * 1   - do sctp accounting, each asoc may use sk_sndbuf bytes
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 823afc4..2818988 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -286,6 +286,16 @@ enum { SCTP_MAX_GABS = 16 };
 				 * functions simpler to write.
 				 */
 
+/* These are the values for pf exposure, UNUSED is to keep compatible with old
+ * applications by default.
+ */
+enum {
+	SCTP_PF_EXPOSE_DISABLE,
+	SCTP_PF_EXPOSE_ENABLE,
+	SCTP_PF_EXPOSE_UNUSED,
+};
+#define SCTP_PF_EXPOSE_MAX	SCTP_PF_EXPOSE_UNUSED
+
 /* These return values describe the success or failure of a number of
  * routines which form the lower interface to SCTP_outqueue.
  */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 503fbc3..9a43738 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -215,6 +215,7 @@ struct sctp_sock {
 	__u32 adaptation_ind;
 	__u32 pd_point;
 	__u16	nodelay:1,
+		pf_expose:2,
 		reuse:1,
 		disable_fragments:1,
 		v4mapped:1,
@@ -2053,6 +2054,7 @@ struct sctp_association {
 
 	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
 	     temp:1,		/* Is it a temporary association? */
+	     pf_expose:2,       /* Expose pf state? */
 	     force_delay:1;
 
 	__u8 strreset_enable;
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index f4ab7bb..d99b428 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -935,6 +935,7 @@ struct sctp_paddrinfo {
 enum sctp_spinfo_state {
 	SCTP_INACTIVE,
 	SCTP_PF,
+#define	SCTP_POTENTIALLY_FAILED		SCTP_PF
 	SCTP_ACTIVE,
 	SCTP_UNCONFIRMED,
 	SCTP_UNKNOWN = 0xffff  /* Value used for transport state unknown */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 4f9efba..46763c5 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -86,6 +86,7 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->max_retrans = sp->assocparams.sasoc_asocmaxrxt;
 	asoc->pf_retrans  = sp->pf_retrans;
+	asoc->pf_expose   = sp->pf_expose;
 
 	asoc->rto_initial = msecs_to_jiffies(sp->rtoinfo.srto_initial);
 	asoc->rto_max = msecs_to_jiffies(sp->rtoinfo.srto_max);
@@ -796,8 +797,11 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		 * to heartbeat success, report the SCTP_ADDR_CONFIRMED
 		 * state to the user, otherwise report SCTP_ADDR_AVAILABLE.
 		 */
-		if (SCTP_UNCONFIRMED == transport->state &&
-		    SCTP_HEARTBEAT_SUCCESS == error)
+		if (transport->state == SCTP_PF &&
+		    asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
+			ulp_notify = false;
+		else if (transport->state == SCTP_UNCONFIRMED &&
+			 error == SCTP_HEARTBEAT_SUCCESS)
 			spc_state = SCTP_ADDR_CONFIRMED;
 		else
 			spc_state = SCTP_ADDR_AVAILABLE;
@@ -820,7 +824,10 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 
 	case SCTP_TRANSPORT_PF:
 		transport->state = SCTP_PF;
-		spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
+		if (asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
+			ulp_notify = false;
+		else
+			spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
 		break;
 
 	default:
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 08d14d8..a18c7c4 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1220,6 +1220,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Enable pf state by default */
 	net->sctp.pf_enable = 1;
 
+	/* Ignore pf exposure feature by default */
+	net->sctp.pf_expose = SCTP_PF_EXPOSE_UNUSED;
+
 	/* Association.Max.Retrans  - 10 attempts
 	 * Path.Max.Retrans         - 5  attempts (per destination address)
 	 * Max.Init.Retransmits     - 8  attempts
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 939b8d2..669e02e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5041,6 +5041,7 @@ static int sctp_init_sock(struct sock *sk)
 	sp->hbinterval  = net->sctp.hb_interval;
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
+	sp->pf_expose   = net->sctp.pf_expose;
 	sp->pathmtu     = 0; /* allow default discovery */
 	sp->sackdelay   = net->sctp.sack_timeout;
 	sp->sackfreq	= 2;
@@ -5521,8 +5522,16 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 
 	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
 					   pinfo.spinfo_assoc_id);
-	if (!transport)
-		return -EINVAL;
+	if (!transport) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	if (transport->state == SCTP_PF &&
+	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
+		retval = -EACCES;
+		goto out;
+	}
 
 	pinfo.spinfo_assoc_id = sctp_assoc2id(transport->asoc);
 	pinfo.spinfo_state = transport->state;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 238cf17..5d1ad44 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -34,6 +34,7 @@ static int rto_alpha_min = 0;
 static int rto_beta_min = 0;
 static int rto_alpha_max = 1000;
 static int rto_beta_max = 1000;
+static int pf_expose_max = SCTP_PF_EXPOSE_MAX;
 
 static unsigned long max_autoclose_min = 0;
 static unsigned long max_autoclose_max =
@@ -318,6 +319,15 @@ static struct ctl_table sctp_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "pf_expose",
+		.data		= &init_net.sctp.pf_expose,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &pf_expose_max,
+	},
 
 	{ /* sentinel */ }
 };
-- 
2.1.0

