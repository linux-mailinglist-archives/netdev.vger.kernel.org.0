Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F143B0C7B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhFVSLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbhFVSK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:56 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2AEC09B040;
        Tue, 22 Jun 2021 11:05:06 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id bj15so40003158qkb.11;
        Tue, 22 Jun 2021 11:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bkonEhF9Dq3Mjip06DwVmVRI4QWy6PqKhH0gbNgAnj0=;
        b=Y2I+MQOvyvPVLPqicBPeniHIOy+LlOeKWIWa0uXzTOI5n2/ePkLkEQ1L5QubhD1pRF
         nNC0r4nX/QWLcpyUgGlFZV2wCzuQswWSVfLVyhnI1B0lYmVGH+gaXKrF83601cbnV5w7
         5gCsOkXUfWKiAeq9i6DsDMPUJuLTr6+sVVjXweqY/Gsn9RqlIWU8xb2R4mYan8CS0s28
         jkUUh7i0rd9Au/eTD92r4vGquwcIcCpwtIrDbG5IWPzdQR5h4fs4Dvp1NdyUYBZ4BoAF
         4d6JeBnrxyybmvfQpsZMg6z77MvpaelyMO2fTKzrnd2tdYgDeNn+CvMFTOdZzGEIM1PZ
         4F1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bkonEhF9Dq3Mjip06DwVmVRI4QWy6PqKhH0gbNgAnj0=;
        b=e2oPmb9MSH8ABMjMVKSX8DomeYqkHFdlkCqhvsjsAbDHtqZfyQN6YFn0VstV4CksmQ
         HGr1tc8Zx5QQyldXnygvjplaesdj1N0l0PHFgsVYAChKEls0ScJ9O5EoBU5unDebPIuC
         nRvA5XUk73CH8NoNabV4posFHNNYWV9T+USENINiwKdX5S2W3XSXxhdRJ7XDYsggWGlF
         1Jw3Lk26QNFDNtyRsRpquPF1J5+jRtaEuRd19J8Y46XNjNrxaY5Vmvtm/mIIba3M0HC4
         SS6nQF5XIJUTIIwbo4W9M1MLurhi/QAxv7R19fX+jQillwW1TqzVWYwAAX38Mth8mtjK
         Rc5A==
X-Gm-Message-State: AOAM533zZzmeewoD0IzpmCErA51n/IT4/nJ36snqoCYEunYXCbIrnKK8
        tLywou6FOJlshlTAo+z4/jY7WzHaE81gWQ==
X-Google-Smtp-Source: ABdhPJwS9mvJkQ4+aEKOrl4REajWg/p6JrmC5IazlkDjez63qCvYbP7PjYFaFpGYWboS+qnEdE50PQ==
X-Received: by 2002:a37:a8ca:: with SMTP id r193mr2395749qke.455.1624385103453;
        Tue, 22 Jun 2021 11:05:03 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x9sm2224184qtf.76.2021.06.22.11.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:03 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 02/14] sctp: add probe_interval in sysctl and sock/asoc/transport
Date:   Tue, 22 Jun 2021 14:04:48 -0400
Message-Id: <55d8108c02e0fe4f3e31e2968123fef50be2a1c3.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
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
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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

