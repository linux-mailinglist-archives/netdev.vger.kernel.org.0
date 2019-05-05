Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D66114308
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 01:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfEEXdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 19:33:22 -0400
Received: from mail.us.es ([193.147.175.20]:34102 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbfEEXdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 19:33:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 717B811ED86
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DC74DA708
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5346DDA702; Mon,  6 May 2019 01:33:16 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48661DA702;
        Mon,  6 May 2019 01:33:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1F8154265A31;
        Mon,  6 May 2019 01:33:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/12] netfilter: conntrack: limit sysctl setting for boolean options
Date:   Mon,  6 May 2019 01:32:57 +0200
Message-Id: <20190505233305.13650-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We use the zero and one to limit the boolean options setting.
After this patch we only set 0 or 1 to boolean options for nf
conntrack sysctl.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/conntrack.h           |  6 ++---
 net/netfilter/nf_conntrack_standalone.c | 48 ++++++++++++++++++++++-----------
 2 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index f19b53130bf7..806454e767bf 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -24,9 +24,9 @@ struct nf_generic_net {
 
 struct nf_tcp_net {
 	unsigned int timeouts[TCP_CONNTRACK_TIMEOUT_MAX];
-	unsigned int tcp_loose;
-	unsigned int tcp_be_liberal;
-	unsigned int tcp_max_retrans;
+	int tcp_loose;
+	int tcp_be_liberal;
+	int tcp_max_retrans;
 };
 
 enum udp_conntrack {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index c2ae14c720b4..e0d392cb3075 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -511,6 +511,8 @@ static void nf_conntrack_standalone_fini_proc(struct net *net)
 /* Log invalid packets of a given protocol */
 static int log_invalid_proto_min __read_mostly;
 static int log_invalid_proto_max __read_mostly = 255;
+static int zero;
+static int one = 1;
 
 /* size the user *wants to set */
 static unsigned int nf_conntrack_htable_size_user __read_mostly;
@@ -624,9 +626,11 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_CHECKSUM] = {
 		.procname	= "nf_conntrack_checksum",
 		.data		= &init_net.ct.sysctl_checksum,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 	[NF_SYSCTL_CT_LOG_INVALID] = {
 		.procname	= "nf_conntrack_log_invalid",
@@ -647,33 +651,41 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_ACCT] = {
 		.procname	= "nf_conntrack_acct",
 		.data		= &init_net.ct.sysctl_acct,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 	[NF_SYSCTL_CT_HELPER] = {
 		.procname	= "nf_conntrack_helper",
 		.data		= &init_net.ct.sysctl_auto_assign_helper,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	[NF_SYSCTL_CT_EVENTS] = {
 		.procname	= "nf_conntrack_events",
 		.data		= &init_net.ct.sysctl_events,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 #endif
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 	[NF_SYSCTL_CT_TIMESTAMP] = {
 		.procname	= "nf_conntrack_timestamp",
 		.data		= &init_net.ct.sysctl_tstamp,
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 #endif
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC] = {
@@ -744,15 +756,19 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LOOSE] = {
 		.procname	= "nf_conntrack_tcp_loose",
-		.maxlen		= sizeof(unsigned int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LIBERAL] = {
 		.procname       = "nf_conntrack_tcp_be_liberal",
-		.maxlen         = sizeof(unsigned int),
+		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
 		.procname	= "nf_conntrack_tcp_max_retrans",
@@ -887,7 +903,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.procname	= "nf_conntrack_dccp_loose",
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1 	= &zero,
+		.extra2 	= &one,
 	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_GRE
-- 
2.11.0

