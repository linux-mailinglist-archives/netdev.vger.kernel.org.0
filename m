Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9207317A06F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCEHRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:17:39 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36431 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgCEHRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:17:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EC69021FED;
        Thu,  5 Mar 2020 02:17:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Mar 2020 02:17:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=s0qYfZbFvnV6XB5ztTTEQl41eOO4lx4A78HDpuJ2bUo=; b=sYoJ53wL
        EaBzUDT7oY1e4Pt2N0erGuQW3oMdJXvCUVyh2fGBcRcw95L4jTowCHlxq8bkh8ip
        t6Zrj5ltm7+wa/ijPUfWCxAdLAg5qZiRjR7un+8LWVJnXEoswr/3M6IygiKMzDFx
        3iDjvQsNycRYGgCBRJlEhwJ41l3C+kF3I6sNBovnVujZQYOY2ILCDAfbuTvUGR7U
        Z2/dGwuD90YmSuEBQ4ZpjzvbnBJpvWU6bhSDHpgIqxX8X8zV91TZhs6+ppFgK+rk
        8UZPd/W2jeuxrNKtx2nHhq9ozkhsSL7eoOzPX5kffVzGelf0mC9N7WyxXj+APQgc
        S0A3LrZ77MNEKA==
X-ME-Sender: <xms:kKdgXvkayRsx-BEcV07pICxaPUt1oW7pox8pFzXytBpSSLfTpHGMJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtledguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:kKdgXhRD2aC5LozM2NXL0ecaDmKa6lizNut7ZS8dtAK2JoglCXJgYA>
    <xmx:kKdgXswOotyJo7n6O49ZqQ_5715srvK_BeeCfGXbsDKyvMT78FdNhg>
    <xmx:kKdgXrJJlsgoIJV6L751myBgZMAYdscFfHCo__DdnwHZsjSY0dqZlw>
    <xmx:kKdgXpbmWtY48qIpTm-Xs3AEr02bbbpjI9fuyGPHgeChungUXEo2Uw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 528D43280063;
        Thu,  5 Mar 2020 02:17:35 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/5] net: sched: Make FIFO Qdisc offloadable
Date:   Thu,  5 Mar 2020 09:16:40 +0200
Message-Id: <20200305071644.117264-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305071644.117264-1-idosch@idosch.org>
References: <20200305071644.117264-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Invoke ndo_setup_tc() as appropriate to signal init / replacement,
destroying and dumping of pFIFO / bFIFO Qdisc.

A lot of the FIFO logic is used for pFIFO_head_drop as well, but that's a
semantically very different Qdisc that isn't really in the same boat as
pFIFO / bFIFO. Split some of the functions to keep the Qdisc intact.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/linux/netdevice.h |  1 +
 include/net/pkt_cls.h     | 15 ++++++
 net/sched/sch_fifo.c      | 97 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 107 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b6fedd54cd8e..654808bfad83 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -853,6 +853,7 @@ enum tc_setup_type {
 	TC_SETUP_FT,
 	TC_SETUP_QDISC_ETS,
 	TC_SETUP_QDISC_TBF,
+	TC_SETUP_QDISC_FIFO,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 53946b509b51..341a66af8d59 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -881,4 +881,19 @@ struct tc_tbf_qopt_offload {
 	};
 };
 
+enum tc_fifo_command {
+	TC_FIFO_REPLACE,
+	TC_FIFO_DESTROY,
+	TC_FIFO_STATS,
+};
+
+struct tc_fifo_qopt_offload {
+	enum tc_fifo_command command;
+	u32 handle;
+	u32 parent;
+	union {
+		struct tc_qopt_offload_stats stats;
+	};
+};
+
 #endif
diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index 37c8aa75d70c..a579a4131d22 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/skbuff.h>
 #include <net/pkt_sched.h>
+#include <net/pkt_cls.h>
 
 /* 1 band FIFO pseudo-"scheduler" */
 
@@ -51,8 +52,49 @@ static int pfifo_tail_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return NET_XMIT_CN;
 }
 
-static int fifo_init(struct Qdisc *sch, struct nlattr *opt,
-		     struct netlink_ext_ack *extack)
+static void fifo_offload_init(struct Qdisc *sch)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	struct tc_fifo_qopt_offload qopt;
+
+	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
+		return;
+
+	qopt.command = TC_FIFO_REPLACE;
+	qopt.handle = sch->handle;
+	qopt.parent = sch->parent;
+	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_FIFO, &qopt);
+}
+
+static void fifo_offload_destroy(struct Qdisc *sch)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	struct tc_fifo_qopt_offload qopt;
+
+	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
+		return;
+
+	qopt.command = TC_FIFO_DESTROY;
+	qopt.handle = sch->handle;
+	qopt.parent = sch->parent;
+	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_FIFO, &qopt);
+}
+
+static int fifo_offload_dump(struct Qdisc *sch)
+{
+	struct tc_fifo_qopt_offload qopt;
+
+	qopt.command = TC_FIFO_STATS;
+	qopt.handle = sch->handle;
+	qopt.parent = sch->parent;
+	qopt.stats.bstats = &sch->bstats;
+	qopt.stats.qstats = &sch->qstats;
+
+	return qdisc_offload_dump_helper(sch, TC_SETUP_QDISC_FIFO, &qopt);
+}
+
+static int __fifo_init(struct Qdisc *sch, struct nlattr *opt,
+		       struct netlink_ext_ack *extack)
 {
 	bool bypass;
 	bool is_bfifo = sch->ops == &bfifo_qdisc_ops;
@@ -82,10 +124,35 @@ static int fifo_init(struct Qdisc *sch, struct nlattr *opt,
 		sch->flags |= TCQ_F_CAN_BYPASS;
 	else
 		sch->flags &= ~TCQ_F_CAN_BYPASS;
+
 	return 0;
 }
 
-static int fifo_dump(struct Qdisc *sch, struct sk_buff *skb)
+static int fifo_init(struct Qdisc *sch, struct nlattr *opt,
+		     struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = __fifo_init(sch, opt, extack);
+	if (err)
+		return err;
+
+	fifo_offload_init(sch);
+	return 0;
+}
+
+static int fifo_hd_init(struct Qdisc *sch, struct nlattr *opt,
+			struct netlink_ext_ack *extack)
+{
+	return __fifo_init(sch, opt, extack);
+}
+
+static void fifo_destroy(struct Qdisc *sch)
+{
+	fifo_offload_destroy(sch);
+}
+
+static int __fifo_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct tc_fifo_qopt opt = { .limit = sch->limit };
 
@@ -97,6 +164,22 @@ static int fifo_dump(struct Qdisc *sch, struct sk_buff *skb)
 	return -1;
 }
 
+static int fifo_dump(struct Qdisc *sch, struct sk_buff *skb)
+{
+	int err;
+
+	err = fifo_offload_dump(sch);
+	if (err)
+		return err;
+
+	return __fifo_dump(sch, skb);
+}
+
+static int fifo_hd_dump(struct Qdisc *sch, struct sk_buff *skb)
+{
+	return __fifo_dump(sch, skb);
+}
+
 struct Qdisc_ops pfifo_qdisc_ops __read_mostly = {
 	.id		=	"pfifo",
 	.priv_size	=	0,
@@ -104,6 +187,7 @@ struct Qdisc_ops pfifo_qdisc_ops __read_mostly = {
 	.dequeue	=	qdisc_dequeue_head,
 	.peek		=	qdisc_peek_head,
 	.init		=	fifo_init,
+	.destroy	=	fifo_destroy,
 	.reset		=	qdisc_reset_queue,
 	.change		=	fifo_init,
 	.dump		=	fifo_dump,
@@ -118,6 +202,7 @@ struct Qdisc_ops bfifo_qdisc_ops __read_mostly = {
 	.dequeue	=	qdisc_dequeue_head,
 	.peek		=	qdisc_peek_head,
 	.init		=	fifo_init,
+	.destroy	=	fifo_destroy,
 	.reset		=	qdisc_reset_queue,
 	.change		=	fifo_init,
 	.dump		=	fifo_dump,
@@ -131,10 +216,10 @@ struct Qdisc_ops pfifo_head_drop_qdisc_ops __read_mostly = {
 	.enqueue	=	pfifo_tail_enqueue,
 	.dequeue	=	qdisc_dequeue_head,
 	.peek		=	qdisc_peek_head,
-	.init		=	fifo_init,
+	.init		=	fifo_hd_init,
 	.reset		=	qdisc_reset_queue,
-	.change		=	fifo_init,
-	.dump		=	fifo_dump,
+	.change		=	fifo_hd_init,
+	.dump		=	fifo_hd_dump,
 	.owner		=	THIS_MODULE,
 };
 
-- 
2.24.1

