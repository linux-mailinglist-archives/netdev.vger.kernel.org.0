Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8586848E3FE
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239150AbiANFtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:49:07 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:42805 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231322AbiANFtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:49:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V1nD.MX_1642139340;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V1nD.MX_1642139340)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 13:49:00 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [RFC PATCH net-next 6/6] net/smc: Introduce tunable linkgroup max connections
Date:   Fri, 14 Jan 2022 13:48:52 +0800
Message-Id: <20220114054852.38058-7-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114054852.38058-1-tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces tunable sysctl knob max_lgr_conns to tune the max
connections in one linkgroup. This knob is net-namespaceify.

Currently, a linkgroup is shared by SMC_RMBS_PER_LGR_MAX connectiosn at
max, which is 255. This shares one QP, and introduces more competition,
as connections increases, such as smc_cdc_get_free_slot(), it shares
link-level slots. The environment and scenario are different, so this
makes it possible to tunable by users, to save linkgroup resources or
reduce competition and increase performance.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 include/net/netns/smc.h |  1 +
 net/smc/af_smc.c        |  1 +
 net/smc/smc_core.c      |  2 +-
 net/smc/smc_sysctl.c    | 11 +++++++++++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/smc.h b/include/net/netns/smc.h
index f948235e3156..4f55d2876d19 100644
--- a/include/net/netns/smc.h
+++ b/include/net/netns/smc.h
@@ -17,5 +17,6 @@ struct netns_smc {
 #endif
 	int				sysctl_wmem_default;
 	int				sysctl_rmem_default;
+	int				sysctl_max_lgr_conns;
 };
 #endif
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0650b5971e0a..f38e24cbb4a7 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2937,6 +2937,7 @@ static __net_init int smc_net_init(struct net *net)
 					   SMC_BUF_MIN_SIZE);
 	net->smc.sysctl_rmem_default = max(net->ipv4.sysctl_tcp_rmem[1],
 					   SMC_BUF_MIN_SIZE);
+	net->smc.sysctl_max_lgr_conns = SMC_RMBS_PER_LGR_MAX;
 
 	return smc_pnet_net_init(net);
 }
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 8935ef4811b0..b6e70dd0688d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1817,7 +1817,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		    (ini->smcd_version == SMC_V2 ||
 		     lgr->vlan_id == ini->vlan_id) &&
 		    (role == SMC_CLNT || ini->is_smcd ||
-		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
+		     lgr->conns_num < net->smc.sysctl_max_lgr_conns)) {
 			/* link group found */
 			ini->first_contact_local = 0;
 			conn->lgr = lgr;
diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index 6706fe1bd888..5ffcf6008c20 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -10,6 +10,8 @@
 
 static int min_sndbuf = SMC_BUF_MIN_SIZE;
 static int min_rcvbuf = SMC_BUF_MIN_SIZE;
+static int min_lgr_conns = 1;
+static int max_lgr_conns = SMC_RMBS_PER_LGR_MAX;
 
 static struct ctl_table smc_table[] = {
 	{
@@ -28,6 +30,15 @@ static struct ctl_table smc_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_rcvbuf,
 	},
+	{
+		.procname	= "max_lgr_conns",
+		.data		= &init_net.smc.sysctl_max_lgr_conns,
+		.maxlen		= sizeof(init_net.smc.sysctl_max_lgr_conns),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_lgr_conns,
+		.extra2		= &max_lgr_conns,
+	},
 	{  }
 };
 
-- 
2.32.0.3.g01195cf9f

