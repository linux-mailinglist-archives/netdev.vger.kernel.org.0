Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483294D589F
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345910AbiCKDDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345897AbiCKDDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:03:33 -0500
Received: from smtp.tom.com (smtprz01.163.net [106.3.154.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44B68C4B60
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 19:02:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 4AE2C44014A
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:02:26 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646967746; bh=nLgk51poUCRUSZi9wNWoz/pgzjUVdty8YV18a/uDvxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2gcxj/qpRx7YdsZCe8ljz2trLrBja9qgr1aR9GtR63QP1Cup/Nuqbi0GYTFrZtl8
         kB+wb0J/j7aT+A5CxDxjEGOwdlQnBdaSN2BgCuvQHIf6oe12TkLtbQgXKii/P3B0w4
         a9rtZFJ6tbYooE6SE7HKhDp0ywrVIL2/S59IHA2o=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID 2136282242
          for <netdev@vger.kernel.org>;
          Fri, 11 Mar 2022 11:02:26 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646967746; bh=nLgk51poUCRUSZi9wNWoz/pgzjUVdty8YV18a/uDvxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2gcxj/qpRx7YdsZCe8ljz2trLrBja9qgr1aR9GtR63QP1Cup/Nuqbi0GYTFrZtl8
         kB+wb0J/j7aT+A5CxDxjEGOwdlQnBdaSN2BgCuvQHIf6oe12TkLtbQgXKii/P3B0w4
         a9rtZFJ6tbYooE6SE7HKhDp0ywrVIL2/S59IHA2o=
Received: from localhost.localdomain (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 45AA215414F8;
        Fri, 11 Mar 2022 11:02:22 +0800 (CST)
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
Subject: [PATCH 2/3] nvme-tcp: support specifying the congestion-control
Date:   Fri, 11 Mar 2022 11:01:12 +0800
Message-Id: <20220311030113.73384-3-sunmingbao@tom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220311030113.73384-1-sunmingbao@tom.com>
References: <20220311030113.73384-1-sunmingbao@tom.com>
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
 drivers/nvme/host/fabrics.c | 12 ++++++++++++
 drivers/nvme/host/fabrics.h |  2 ++
 drivers/nvme/host/tcp.c     | 15 ++++++++++++++-
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index ee79a6d639b4..79d5f0dbafd3 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -548,6 +548,7 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_TOS,			"tos=%d"		},
 	{ NVMF_OPT_FAIL_FAST_TMO,	"fast_io_fail_tmo=%d"	},
 	{ NVMF_OPT_DISCOVERY,		"discovery"		},
+	{ NVMF_OPT_TCP_CONGESTION,	"tcp_congestion=%s"	},
 	{ NVMF_OPT_ERR,			NULL			}
 };
 
@@ -829,6 +830,16 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 		case NVMF_OPT_DISCOVERY:
 			opts->discovery_nqn = true;
 			break;
+		case NVMF_OPT_TCP_CONGESTION:
+			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			kfree(opts->tcp_congestion);
+			opts->tcp_congestion = p;
+			break;
 		default:
 			pr_warn("unknown parameter or missing value '%s' in ctrl creation request\n",
 				p);
@@ -947,6 +958,7 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
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
index 10fc45d95b86..f2a6df35374a 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1487,6 +1487,18 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	if (nctrl->opts->tos >= 0)
 		ip_sock_set_tos(queue->sock->sk, nctrl->opts->tos);
 
+	if (nctrl->opts->mask & NVMF_OPT_TCP_CONGESTION) {
+		ret = tcp_set_congestion_control(queue->sock->sk,
+						 nctrl->opts->tcp_congestion,
+						 true, true);
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
 
@@ -2650,7 +2662,8 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
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

