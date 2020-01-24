Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB431485E4
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389504AbgAXNYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:08 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51341 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387562AbgAXNYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:07 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AAB4F21F32;
        Fri, 24 Jan 2020 08:24:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=s6b6Oaqtwf1QGFWjrmUSx7+5QjC2lX0XKUK9cb5tOJo=; b=CCIHGLEy
        3mD96LhguI4SXOc2zp85pDbV2P5v1yD8nQjtAkIHkYlaUNpAakLoRSDsCHBvYNrE
        bTUgZqD7SZg4kriSbJcEMap7QXvzq6t4DKJnC7ZrWGMONrtkv3HA1krEJQpPYjIT
        keIuFc9+PUfCaHiGfWpqAMiGzW26ufSWv/YyOKJfUJu8kgjNFfuxSPZ2TZQ3oyGD
        ohjoxjP5gwmX6XbSBbzjRIwmLljxtDLZdKv65SU/E1W/IPPAKNWS0roeqln9zyOP
        0iEpD2fXWjlWFq5MGQ298Ger0DpiAh1aNLVYZ2F9FWGqcTLS+hP33utH8GUaPrSI
        gE50aLi2kIBSlQ==
X-ME-Sender: <xms:9u8qXtN7LjvXogJcUD7oVmEc-guBg-WpKikcF554UaATeEOzaKywRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:9u8qXtgm0gEUMpEM5BagZpbAPt8R6V5iNhpdYtKw1JAhIGJBa-IMQw>
    <xmx:9u8qXisIMEMpEOnaiyi3AAOJe-DvU5X-foQBWFtJmwEMnw2gC2P2kw>
    <xmx:9u8qXrTwItzGly6SWs3hTneLPNBsdqyPQtqUg6g8NKb8pPuyhgN0Eg>
    <xmx:9u8qXimuzVwUK2Kcr4cTWHNdusiopjawEM9v8sGOyHuILSZbDyheHw>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8CE3430610F6;
        Fri, 24 Jan 2020 08:24:04 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/14] net: sched: Make TBF Qdisc offloadable
Date:   Fri, 24 Jan 2020 15:23:06 +0200
Message-Id: <20200124132318.712354-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Invoke ndo_setup_tc as appropriate to signal init / replacement, destroying
and dumping of TBF Qdisc.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/linux/netdevice.h |  1 +
 include/net/pkt_cls.h     | 22 ++++++++++++++++
 net/sched/sch_tbf.c       | 55 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5ec3537fbdb1..11bdf6cb30bd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -850,6 +850,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_TAPRIO,
 	TC_SETUP_FT,
 	TC_SETUP_QDISC_ETS,
+	TC_SETUP_QDISC_TBF,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 47b115e2012a..ce036492986a 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -854,4 +854,26 @@ struct tc_ets_qopt_offload {
 	};
 };
 
+enum tc_tbf_command {
+	TC_TBF_REPLACE,
+	TC_TBF_DESTROY,
+	TC_TBF_STATS,
+};
+
+struct tc_tbf_qopt_offload_replace_params {
+	struct psched_ratecfg rate;
+	u32 max_size;
+	struct gnet_stats_queue *qstats;
+};
+
+struct tc_tbf_qopt_offload {
+	enum tc_tbf_command command;
+	u32 handle;
+	u32 parent;
+	union {
+		struct tc_tbf_qopt_offload_replace_params replace_params;
+		struct tc_qopt_offload_stats stats;
+	};
+};
+
 #endif
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 7ae317958090..78e79029dc63 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -15,6 +15,7 @@
 #include <linux/skbuff.h>
 #include <net/netlink.h>
 #include <net/sch_generic.h>
+#include <net/pkt_cls.h>
 #include <net/pkt_sched.h>
 
 
@@ -137,6 +138,52 @@ static u64 psched_ns_t2l(const struct psched_ratecfg *r,
 	return len;
 }
 
+static void tbf_offload_change(struct Qdisc *sch)
+{
+	struct tbf_sched_data *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	struct tc_tbf_qopt_offload qopt;
+
+	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
+		return;
+
+	qopt.command = TC_TBF_REPLACE;
+	qopt.handle = sch->handle;
+	qopt.parent = sch->parent;
+	qopt.replace_params.rate = q->rate;
+	qopt.replace_params.max_size = q->max_size;
+	qopt.replace_params.qstats = &sch->qstats;
+
+	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TBF, &qopt);
+}
+
+static void tbf_offload_destroy(struct Qdisc *sch)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	struct tc_tbf_qopt_offload qopt;
+
+	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
+		return;
+
+	qopt.command = TC_TBF_DESTROY;
+	qopt.handle = sch->handle;
+	qopt.parent = sch->parent;
+	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TBF, &qopt);
+}
+
+static int tbf_offload_dump(struct Qdisc *sch)
+{
+	struct tc_tbf_qopt_offload qopt;
+
+	qopt.command = TC_TBF_STATS;
+	qopt.handle = sch->handle;
+	qopt.parent = sch->parent;
+	qopt.stats.bstats = &sch->bstats;
+	qopt.stats.qstats = &sch->qstats;
+
+	return qdisc_offload_dump_helper(sch, TC_SETUP_QDISC_TBF, &qopt);
+}
+
 /* GSO packet is too big, segment it so that tbf can transmit
  * each segment in time
  */
@@ -407,6 +454,8 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 
 	sch_tree_unlock(sch);
 	err = 0;
+
+	tbf_offload_change(sch);
 done:
 	return err;
 }
@@ -432,6 +481,7 @@ static void tbf_destroy(struct Qdisc *sch)
 	struct tbf_sched_data *q = qdisc_priv(sch);
 
 	qdisc_watchdog_cancel(&q->watchdog);
+	tbf_offload_destroy(sch);
 	qdisc_put(q->qdisc);
 }
 
@@ -440,6 +490,11 @@ static int tbf_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tbf_sched_data *q = qdisc_priv(sch);
 	struct nlattr *nest;
 	struct tc_tbf_qopt opt;
+	int err;
+
+	err = tbf_offload_dump(sch);
+	if (err)
+		return err;
 
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
-- 
2.24.1

