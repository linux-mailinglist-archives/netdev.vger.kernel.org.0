Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA4C5BE26F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiITJw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiITJwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:52:47 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3F86EF37;
        Tue, 20 Sep 2022 02:52:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VQIslnZ_1663667555;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VQIslnZ_1663667555)
          by smtp.aliyun-inc.com;
          Tue, 20 Sep 2022 17:52:42 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/2] net/smc: Unbind r/w buffer size from clcsock and make them tunable
Date:   Tue, 20 Sep 2022 17:52:22 +0800
Message-Id: <1663667542-119851-3-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1663667542-119851-1-git-send-email-guwen@linux.alibaba.com>
References: <1663667542-119851-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

Currently, SMC uses smc->sk.sk_{rcv|snd}buf to create buffers for
send buffer and RMB. And the values of buffer size are from tcp_{w|r}mem
in clcsock.

The buffer size from TCP socket doesn't fit SMC well. Generally, buffers
are usually larger than TCP for SMC-R/-D to get higher performance, for
they are different underlay devices and paths.

So this patch unbinds buffer size from TCP, and introduces two sysctl
knobs to tune them independently. Also, these knobs are per net
namespace and work for containers.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 Documentation/networking/smc-sysctl.rst | 18 ++++++++++++++++++
 include/net/netns/smc.h                 |  2 ++
 net/smc/af_smc.c                        |  5 ++---
 net/smc/smc_core.c                      |  8 ++++----
 net/smc/smc_sysctl.c                    | 21 +++++++++++++++++++++
 5 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
index 45ba152..6d8acdb 100644
--- a/Documentation/networking/smc-sysctl.rst
+++ b/Documentation/networking/smc-sysctl.rst
@@ -41,3 +41,21 @@ smcr_testlink_time - INTEGER
 	disabling TEST_LINK.
 
 	Default: 30 seconds.
+
+wmem - INTEGER
+	Initial size of send buffer used by SMC sockets.
+	The default value inherits from net.ipv4.tcp_wmem[1].
+
+	The minimum value is 16KiB and there is no hard limit for max value, but
+	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
+
+	Default: 16K
+
+rmem - INTEGER
+	Initial size of receive buffer (RMB) used by SMC sockets.
+	The default value inherits from net.ipv4.tcp_rmem[1].
+
+	The minimum value is 16KiB and there is no hard limit for max value, but
+	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
+
+	Default: 128K
diff --git a/include/net/netns/smc.h b/include/net/netns/smc.h
index d295e2c..582212a 100644
--- a/include/net/netns/smc.h
+++ b/include/net/netns/smc.h
@@ -20,5 +20,7 @@ struct netns_smc {
 	unsigned int			sysctl_autocorking_size;
 	unsigned int			sysctl_smcr_buf_type;
 	int				sysctl_smcr_testlink_time;
+	int				sysctl_wmem;
+	int				sysctl_rmem;
 };
 #endif
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0939cc3..e44ca70 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -379,6 +379,8 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
 	sk->sk_state = SMC_INIT;
 	sk->sk_destruct = smc_destruct;
 	sk->sk_protocol = protocol;
+	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(net->smc.sysctl_wmem));
+	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(net->smc.sysctl_rmem));
 	smc = smc_sk(sk);
 	INIT_WORK(&smc->tcp_listen_work, smc_tcp_listen_work);
 	INIT_WORK(&smc->connect_work, smc_connect_work);
@@ -3253,9 +3255,6 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 		smc->clcsock = clcsock;
 	}
 
-	smc->sk.sk_sndbuf = max(smc->clcsock->sk->sk_sndbuf, SMC_BUF_MIN_SIZE);
-	smc->sk.sk_rcvbuf = max(smc->clcsock->sk->sk_rcvbuf, SMC_BUF_MIN_SIZE);
-
 out:
 	return rc;
 }
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index ebf56cd..ea41f22 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2307,10 +2307,10 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 	if (is_rmb)
 		/* use socket recv buffer size (w/o overhead) as start value */
-		sk_buf_size = smc->sk.sk_rcvbuf / 2;
+		sk_buf_size = smc->sk.sk_rcvbuf;
 	else
 		/* use socket send buffer size (w/o overhead) as start value */
-		sk_buf_size = smc->sk.sk_sndbuf / 2;
+		sk_buf_size = smc->sk.sk_sndbuf;
 
 	for (bufsize_short = smc_compress_bufsize(sk_buf_size, is_smcd, is_rmb);
 	     bufsize_short >= 0; bufsize_short--) {
@@ -2369,7 +2369,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 	if (is_rmb) {
 		conn->rmb_desc = buf_desc;
 		conn->rmbe_size_short = bufsize_short;
-		smc->sk.sk_rcvbuf = bufsize * 2;
+		smc->sk.sk_rcvbuf = bufsize;
 		atomic_set(&conn->bytes_to_rcv, 0);
 		conn->rmbe_update_limit =
 			smc_rmb_wnd_update_limit(buf_desc->len);
@@ -2377,7 +2377,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 			smc_ism_set_conn(conn); /* map RMB/smcd_dev to conn */
 	} else {
 		conn->sndbuf_desc = buf_desc;
-		smc->sk.sk_sndbuf = bufsize * 2;
+		smc->sk.sk_sndbuf = bufsize;
 		atomic_set(&conn->sndbuf_space, bufsize);
 	}
 	return 0;
diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index 3224d30..b6f79fa 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -19,6 +19,9 @@
 #include "smc_llc.h"
 #include "smc_sysctl.h"
 
+static int min_sndbuf = SMC_BUF_MIN_SIZE;
+static int min_rcvbuf = SMC_BUF_MIN_SIZE;
+
 static struct ctl_table smc_table[] = {
 	{
 		.procname       = "autocorking_size",
@@ -43,6 +46,22 @@
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
+	{
+		.procname	= "wmem",
+		.data		= &init_net.smc.sysctl_wmem,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_sndbuf,
+	},
+	{
+		.procname	= "rmem",
+		.data		= &init_net.smc.sysctl_rmem,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_rcvbuf,
+	},
 	{  }
 };
 
@@ -69,6 +88,8 @@ int __net_init smc_sysctl_net_init(struct net *net)
 	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
 	net->smc.sysctl_smcr_buf_type = SMCR_PHYS_CONT_BUFS;
 	net->smc.sysctl_smcr_testlink_time = SMC_LLC_TESTLINK_DEFAULT_TIME;
+	WRITE_ONCE(net->smc.sysctl_wmem, READ_ONCE(net->ipv4.sysctl_tcp_wmem[1]));
+	WRITE_ONCE(net->smc.sysctl_rmem, READ_ONCE(net->ipv4.sysctl_tcp_rmem[1]));
 
 	return 0;
 
-- 
1.8.3.1

