Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D123AE160
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFUBlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhFUBlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:07 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572D8C061574;
        Sun, 20 Jun 2021 18:38:54 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id y11so4404401qvv.0;
        Sun, 20 Jun 2021 18:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=G97gCZjh9rQZv8bBk4OP0YVYxo5Eni7OW7tcLJWnXqs=;
        b=UFr2Qy11BLZmpiXT1lAyoi+ngPlODXLPxTmMeBp9kfNLajtKawbj5LlRBssje2CIXe
         3dJoK/9DbUGCWz17SDaHZw2RueRR7Im31i9V2cVqBKxvIqr4PLtUAmu34mUMlArbO8PL
         NZTXQPEoSMcESH+nk5AvV0DACyxAkckZ7Elf8oRWNK+6Yo1B95kWLmGSydsvfvpk2TMJ
         +MDn39IU3xjr/XIsuUNCx3T95pKHZwUzCRD4UvCCaH3etNaC/cp1SQWI8laM5/l6m8BZ
         T0BrPqfgoj2IBsjqVnyogEAI6eJAXuE8dcXjbzXZrH3FDln2mD+dy0PAtRR7F35x4NZQ
         WEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G97gCZjh9rQZv8bBk4OP0YVYxo5Eni7OW7tcLJWnXqs=;
        b=LpJGtkyLtsbtT6MbB2NaJHJvBGhllQt2sYTP36t8wuII5TNWPjBo4282Tt6xhoBTGW
         geHXRW3ytAPT1h8UOg30l279XLntTtK/eE/Lw9lBRQ0FizSojiacrHgwKUnKGn6XVoiA
         OiQPoR8y3rTz5tMAvgY80+VJLIgEDpIQo10CE6HZsC1efGGfy8E1C1zCsT7t2WJfldd5
         WnPwLlwCiMqZ/ZTy//CC2UvcHbxVuYrU5uHwYxR8IaINIwtS8wW95CMGg05TqGSAyF0G
         hCsw4WE9qLmOmCGxAjrd4OSt+T6v7aknH7/DEQmS2DC2CsdBXvvbX4NBfc8YJHH2bf/n
         kR2Q==
X-Gm-Message-State: AOAM533I0NQl4KqfhQQ+tB+wEc2L9tN3I/hj4Mts0dSb4YehW0h44wqk
        36lnI0mdGt4C2nJAv15z/l74fYWjgcpz+Q==
X-Google-Smtp-Source: ABdhPJyImMySToZZL0Ah9oRKBnZab0BAxinn4SiciUGbnlVTNrDl6cPnqkOot8azyM3yk5axqmfm+A==
X-Received: by 2002:ad4:5a07:: with SMTP id ei7mr7966212qvb.46.1624239533311;
        Sun, 20 Jun 2021 18:38:53 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s6sm8853802qks.102.2021.06.20.18.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:38:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 02/14] sctp: add probe_interval in sysctl and sock/asoc/transport
Date:   Sun, 20 Jun 2021 21:38:37 -0400
Message-Id: <2ee4218230b6312e27f26f8296117a6eef5c5001.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PLPMTUD can be enabled by doing 'sysctl -w net.sctp.probe_interval=n'.
'n' is the interval for PLPMTUD probe timer in milliseconds, and it
can't be less than 5000 if it's not 0.

All asoc/transport's PLPMTUD in a new socket will be enabled by default.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  8 ++++++
 include/net/netns/sctp.h               |  3 +++
 include/net/sctp/constants.h           |  2 ++
 include/net/sctp/structs.h             |  3 +++
 net/sctp/associola.c                   |  2 ++
 net/sctp/socket.c                      |  1 +
 net/sctp/sysctl.c                      | 35 ++++++++++++++++++++++++++
 7 files changed, 54 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b0436d3a4f11..8bff728b3a1e 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2834,6 +2834,14 @@ encap_port - INTEGER
 
 	Default: 0
 
+plpmtud_probe_interval - INTEGER
+        The time interval (in milliseconds) for sending PLPMTUD probe chunks.
+        These chunks are sent at the specified interval with a variable size
+        to probe the mtu of a given path between 2 endpoints. PLPMTUD will
+        be disabled when 0 is set, and other values for it must be >= 5000.
+
+	Default: 0
+
 
 ``/proc/sys/net/core/*``
 ========================
diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index a0f315effa94..40240722cdca 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -84,6 +84,9 @@ struct netns_sctp {
 	/* HB.interval		    - 30 seconds  */
 	unsigned int hb_interval;
 
+	/* The interval for PLPMTUD probe timer */
+	unsigned int probe_interval;
+
 	/* Association.Max.Retrans  - 10 attempts
 	 * Path.Max.Retrans	    - 5	 attempts (per destination address)
 	 * Max.Init.Retransmits	    - 8	 attempts
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 14a0d22c9113..449cf9cb428b 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -424,4 +424,6 @@ enum {
  */
 #define SCTP_AUTH_RANDOM_LENGTH 32
 
+#define SCTP_PROBE_TIMER_MIN	5000
+
 #endif /* __sctp_constants_h__ */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 1aa585216f34..bf5d22deaefb 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -177,6 +177,7 @@ struct sctp_sock {
 	 * will be inherited by all new associations.
 	 */
 	__u32 hbinterval;
+	__u32 probe_interval;
 
 	__be16 udp_port;
 	__be16 encap_port;
@@ -858,6 +859,7 @@ struct sctp_transport {
 	 * the destination address every heartbeat interval.
 	 */
 	unsigned long hbinterval;
+	unsigned long probe_interval;
 
 	/* SACK delay timeout */
 	unsigned long sackdelay;
@@ -1795,6 +1797,7 @@ struct sctp_association {
 	 * will be inherited by all new transports.
 	 */
 	unsigned long hbinterval;
+	unsigned long probe_interval;
 
 	__be16 encap_port;
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 336df4b36655..e01895edd3a4 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -98,6 +98,7 @@ static struct sctp_association *sctp_association_init(
 	 * sock configured value.
 	 */
 	asoc->hbinterval = msecs_to_jiffies(sp->hbinterval);
+	asoc->probe_interval = msecs_to_jiffies(sp->probe_interval);
 
 	asoc->encap_port = sp->encap_port;
 
@@ -625,6 +626,7 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	 * association configured value.
 	 */
 	peer->hbinterval = asoc->hbinterval;
+	peer->probe_interval = asoc->probe_interval;
 
 	peer->encap_port = asoc->encap_port;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a79d193ff872..d2960ab665a5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4989,6 +4989,7 @@ static int sctp_init_sock(struct sock *sk)
 	atomic_set(&sp->pd_mode, 0);
 	skb_queue_head_init(&sp->pd_lobby);
 	sp->frag_interleave = 0;
+	sp->probe_interval = net->sctp.probe_interval;
 
 	/* Create a per socket endpoint structure.  Even if we
 	 * change the data structure relationships, this may still
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 55871b277f47..b46a416787ec 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -55,6 +55,8 @@ static int proc_sctp_do_alpha_beta(struct ctl_table *ctl, int write,
 				   void *buffer, size_t *lenp, loff_t *ppos);
 static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
 			     void *buffer, size_t *lenp, loff_t *ppos);
+static int proc_sctp_do_probe_interval(struct ctl_table *ctl, int write,
+				       void *buffer, size_t *lenp, loff_t *ppos);
 
 static struct ctl_table sctp_table[] = {
 	{
@@ -293,6 +295,13 @@ static struct ctl_table sctp_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "plpmtud_probe_interval",
+		.data		= &init_net.sctp.probe_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_sctp_do_probe_interval,
+	},
 	{
 		.procname	= "udp_port",
 		.data		= &init_net.sctp.udp_port,
@@ -539,6 +548,32 @@ static int proc_sctp_do_udp_port(struct ctl_table *ctl, int write,
 	return ret;
 }
 
+static int proc_sctp_do_probe_interval(struct ctl_table *ctl, int write,
+				       void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct ctl_table tbl;
+	int ret, new_value;
+
+	memset(&tbl, 0, sizeof(struct ctl_table));
+	tbl.maxlen = sizeof(unsigned int);
+
+	if (write)
+		tbl.data = &new_value;
+	else
+		tbl.data = &net->sctp.probe_interval;
+
+	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
+	if (write && ret == 0) {
+		if (new_value && new_value < SCTP_PROBE_TIMER_MIN)
+			return -EINVAL;
+
+		net->sctp.probe_interval = new_value;
+	}
+
+	return ret;
+}
+
 int sctp_sysctl_net_register(struct net *net)
 {
 	struct ctl_table *table;
-- 
2.27.0

