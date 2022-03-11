Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3D54D5FC2
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348048AbiCKKgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348053AbiCKKgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:36:49 -0500
Received: from smtp.tom.com (smtprz02.163.net [106.3.154.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B3151BD064
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:35:35 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 41DBD44017A
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 18:35:35 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646994935; bh=93JeBi/0/ADhIZMBBUs1HqDG4uLkWcGGpcH0lW56i4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQKynntHrs+TQClSMNr5YAJh1fgg8wk6b77ONBQPN81i7cuXBWZ9lOmag7DjDIWNS
         hBaBux2jPCfxgoIIvPRvOaKGNz9QZqS4XfQytZ/FBnejMoaMLs04RabOEl13yRix8j
         VxLYYJ71vfMrbOp5fmDWXxgSQKegy5MhBFslLMF4=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -301430619
          for <netdev@vger.kernel.org>;
          Fri, 11 Mar 2022 18:35:35 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646994935; bh=93JeBi/0/ADhIZMBBUs1HqDG4uLkWcGGpcH0lW56i4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQKynntHrs+TQClSMNr5YAJh1fgg8wk6b77ONBQPN81i7cuXBWZ9lOmag7DjDIWNS
         hBaBux2jPCfxgoIIvPRvOaKGNz9QZqS4XfQytZ/FBnejMoaMLs04RabOEl13yRix8j
         VxLYYJ71vfMrbOp5fmDWXxgSQKegy5MhBFslLMF4=
Received: from localhost.localdomain (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 56B381541576;
        Fri, 11 Mar 2022 18:35:31 +0800 (CST)
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     sunmingbao@tom.com, tyler.sun@dell.com, ping.gan@dell.com,
        yanxiu.cai@dell.com, libin.zhang@dell.com, ao.sun@dell.com
Subject: [PATCH v2 2/3] nvme-tcp: support specifying the congestion-control
Date:   Fri, 11 Mar 2022 18:34:13 +0800
Message-Id: <20220311103414.8255-2-sunmingbao@tom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220311103414.8255-1-sunmingbao@tom.com>
References: <20220311103414.8255-1-sunmingbao@tom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mingbao Sun <tyler.sun@dell.com>

congestion-control could have a noticeable impaction on the
performance of TCP-based communications. This is of course true
to NVMe_over_TCP.

Different congestion-controls (e.g., cubic, dctcp) are suitable for
different scenarios. Proper adoption of congestion control would benefit
the performance. On the contrary, the performance could be destroyed.

Though we can specify the congestion-control of NVMe_over_TCP via
writing '/proc/sys/net/ipv4/tcp_congestion_control', but this also
changes the congestion-control of all the future TCP sockets that
have not been explicitly assigned the congestion-control, thus bringing
potential impaction on their performance.

So it makes sense to make NVMe_over_TCP support specifying the
congestion-control. And this commit addresses the host side.

Implementation approach:
a new option called 'tcp_congestion' was created in fabrics opt_tokens
for 'nvme connect' command to passed in the congestion-control
specified by the user.
Then later in nvme_tcp_alloc_queue, the specified congestion-control
would be applied to the relevant sockets of the host side.

Signed-off-by: Mingbao Sun <tyler.sun@dell.com>
---
 drivers/nvme/host/fabrics.c | 18 ++++++++++++++++++
 drivers/nvme/host/fabrics.h |  2 ++
 drivers/nvme/host/tcp.c     | 17 ++++++++++++++++-
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index ee79a6d639b4..ecd1ec4e473a 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -10,6 +10,7 @@
 #include <linux/mutex.h>
 #include <linux/parser.h>
 #include <linux/seq_file.h>
+#include <net/tcp.h>
 #include "nvme.h"
 #include "fabrics.h"
 
@@ -548,6 +549,7 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_TOS,			"tos=%d"		},
 	{ NVMF_OPT_FAIL_FAST_TMO,	"fast_io_fail_tmo=%d"	},
 	{ NVMF_OPT_DISCOVERY,		"discovery"		},
+	{ NVMF_OPT_TCP_CONGESTION,	"tcp_congestion=%s"	},
 	{ NVMF_OPT_ERR,			NULL			}
 };
 
@@ -829,6 +831,21 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 		case NVMF_OPT_DISCOVERY:
 			opts->discovery_nqn = true;
 			break;
+		case NVMF_OPT_TCP_CONGESTION:
+			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			if (strlen(p) >= TCP_CA_NAME_MAX) {
+				ret = -EINVAL;
+				kfree(p);
+				goto out;
+			}
+
+			kfree(opts->tcp_congestion);
+			opts->tcp_congestion = p;
+			break;
 		default:
 			pr_warn("unknown parameter or missing value '%s' in ctrl creation request\n",
 				p);
@@ -947,6 +964,7 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->subsysnqn);
 	kfree(opts->host_traddr);
 	kfree(opts->host_iface);
+	kfree(opts->tcp_congestion);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index c3203ff1c654..25fdc169949d 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -68,6 +68,7 @@ enum {
 	NVMF_OPT_FAIL_FAST_TMO	= 1 << 20,
 	NVMF_OPT_HOST_IFACE	= 1 << 21,
 	NVMF_OPT_DISCOVERY	= 1 << 22,
+	NVMF_OPT_TCP_CONGESTION	= 1 << 23,
 };
 
 /**
@@ -117,6 +118,7 @@ struct nvmf_ctrl_options {
 	unsigned int		nr_io_queues;
 	unsigned int		reconnect_delay;
 	bool			discovery_nqn;
+	const char		*tcp_congestion;
 	bool			duplicate_connect;
 	unsigned int		kato;
 	struct nvmf_host	*host;
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 10fc45d95b86..8491f96a39e5 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1487,6 +1487,20 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	if (nctrl->opts->tos >= 0)
 		ip_sock_set_tos(queue->sock->sk, nctrl->opts->tos);
 
+	if (nctrl->opts->mask & NVMF_OPT_TCP_CONGESTION) {
+		lock_sock(queue->sock->sk);
+		ret = tcp_set_congestion_control(queue->sock->sk,
+						 nctrl->opts->tcp_congestion,
+						 true, true);
+		release_sock(queue->sock->sk);
+		if (ret) {
+			dev_err(nctrl->device,
+				"failed to set TCP congestion to %s: %d\n",
+				nctrl->opts->tcp_congestion, ret);
+			goto err_sock;
+		}
+	}
+
 	/* Set 10 seconds timeout for icresp recvmsg */
 	queue->sock->sk->sk_rcvtimeo = 10 * HZ;
 
@@ -2650,7 +2664,8 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 			  NVMF_OPT_HOST_TRADDR | NVMF_OPT_CTRL_LOSS_TMO |
 			  NVMF_OPT_HDR_DIGEST | NVMF_OPT_DATA_DIGEST |
 			  NVMF_OPT_NR_WRITE_QUEUES | NVMF_OPT_NR_POLL_QUEUES |
-			  NVMF_OPT_TOS | NVMF_OPT_HOST_IFACE,
+			  NVMF_OPT_TOS | NVMF_OPT_HOST_IFACE |
+			  NVMF_OPT_TCP_CONGESTION,
 	.create_ctrl	= nvme_tcp_create_ctrl,
 };
 
-- 
2.26.2

