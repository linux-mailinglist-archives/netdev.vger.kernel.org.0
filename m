Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F9C8B80E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfHMMHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:07:55 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41859 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfHMMHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:07:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so4330049pfz.8;
        Tue, 13 Aug 2019 05:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KThQsLYjfewdl28QuyIif2v6KSDzi1vGtGdeAeqU0LU=;
        b=H8Q3tZI6X+13+VDoFlTgcFkyaAxdYPmw1hsQ5FhMT1ha+pQjVj78IZHNlzCPfs0KD0
         gaulE74uwKfAykmEAIxT9r5WxSzP1WnAZQwfb2pqeSX/iFAJrJsqnexUYM/p5jwymPxk
         G/5eAbdb4pyuhxx1H+NVX7NvrQiPGjBHX+wbQNTwlDusU+w/WBasnfThFiXDggHl9Q2P
         05w+uGXZA+l/KTln80p/Y0QV7WCL9el8jw6zZNLwayRQjiFAN3KXG74xTmxLjUaotGbO
         ptCc56rs32qCC4N+8QNAmPTzGV01uH5I2phnXyko+aIdC0Wu6ZKow4jGb3bYeNRndEjs
         axCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KThQsLYjfewdl28QuyIif2v6KSDzi1vGtGdeAeqU0LU=;
        b=mJ1h3hqIJ97jR4eZ9r6fx+TDAO5IaZKBHDz9l0fb2KhcymgPgclZX3QSxVlFv5jwXB
         qBXNwZWwtjOuyptsZE0n+PKrkfvRqi4FJ0Pm9niLx0ZSOMocdwFmRcKVR4upAg3yPnKu
         +gmI+dACCfl8gkVSa6BsnwANDqgDzuqZPFJ90zTKh0VeqFgAXep35xoMlXKSGtMAso7g
         BRyfsndDtOF8/O2aoNIFWJdREHeGxR8p41tJCCy+RufAd8/enARunJkGU2Eqeldnlupi
         GklgfuQVmw1zkBjOodMnoX27zapy3faNnPdpzdDQg1BQ0/T8LBFo3wJ0NWlImW0vMNcH
         Lu0Q==
X-Gm-Message-State: APjAAAUrwgts+m88Vw+SwFjkSdKJf7CD1XfW2LDMRrFnkkfzsZeaiS4F
        8c4tJKcJ3Qb//QSaJLiNXmk=
X-Google-Smtp-Source: APXvYqwSPMZfyCOoJ95lHf5XVTNqRmKEM7/0NPpAnboVu/Yl1IfBpWsTuAW6uepdVXTpDYNYg0cDHA==
X-Received: by 2002:a63:2004:: with SMTP id g4mr32645374pgg.97.1565698073945;
        Tue, 13 Aug 2019 05:07:53 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:07:53 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 09/14] xdp_flow: Add netdev feature for enabling TC flower offload to XDP
Date:   Tue, 13 Aug 2019 21:05:53 +0900
Message-Id: <20190813120558.6151-10-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usage would be like this:

 $ ethtool -K eth0 tc-offload-xdp on
 $ tc qdisc add dev eth0 clsact
 $ tc filter add dev eth0 ingress protocol ip flower skip_sw ...

Then the filters offloaded to XDP are marked as "in_hw".

If the tc flow block is created when tc-offload-xdp is enabled on the
device, the block is internally marked as xdp and only can be offloaded
to XDP.
The reason not to allow HW-offload and XDP-offload at the same time is
to avoid the situation where offloading to only one of them succeeds.
If we allow offloading to both, users cannot know which offload
succeeded.

NOTE: This makes flows offloaded to XDP look as if they are HW
offloaded, since they will be marked as "in_hw". This could be confusing.
Maybe we can add another status "in_xdp"? Then we can allow both of HW-
and XDP-offload at the same time.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 include/linux/netdev_features.h  |  2 ++
 include/net/pkt_cls.h            |  5 +++
 include/net/sch_generic.h        |  1 +
 net/core/dev.c                   |  2 ++
 net/core/ethtool.c               |  1 +
 net/sched/cls_api.c              | 67 +++++++++++++++++++++++++++++++++++++---
 net/xdp_flow/xdp_flow_kern_mod.c |  6 ++++
 7 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 4b19c54..ddd201e 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -80,6 +80,7 @@ enum {
 
 	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
+	NETIF_F_XDP_TC_BIT,		/* Offload TC to XDP */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -150,6 +151,7 @@ enum {
 #define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
 #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
 #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
+#define NETIF_F_XDP_TC		__NETIF_F(XDP_TC)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index e429809..d190aae 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -610,6 +610,11 @@ static inline bool tc_can_offload_extack(const struct net_device *dev,
 	return true;
 }
 
+static inline bool tc_xdp_offload_enabled(const struct net_device *dev)
+{
+	return dev->features & NETIF_F_XDP_TC;
+}
+
 static inline bool tc_skip_hw(u32 flags)
 {
 	return (flags & TCA_CLS_FLAGS_SKIP_HW) ? true : false;
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 6b6b012..a4d90b5 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -402,6 +402,7 @@ struct tcf_block {
 	struct flow_block flow_block;
 	struct list_head owner_list;
 	bool keep_dst;
+	bool xdp;
 	unsigned int offloadcnt; /* Number of oddloaded filters */
 	unsigned int nooffloaddevcnt; /* Number of devs unable to do offload */
 	struct {
diff --git a/net/core/dev.c b/net/core/dev.c
index a45d2e4..d1f980d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8680,6 +8680,8 @@ int register_netdevice(struct net_device *dev)
 	 * software offloads (GSO and GRO).
 	 */
 	dev->hw_features |= NETIF_F_SOFT_FEATURES;
+	if (IS_ENABLED(CONFIG_XDP_FLOW))
+		dev->hw_features |= NETIF_F_XDP_TC;
 	dev->features |= NETIF_F_SOFT_FEATURES;
 
 	if (dev->netdev_ops->ndo_udp_tunnel_add) {
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 6288e69..c7e61cf 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -111,6 +111,7 @@ int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
 	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
+	[NETIF_F_XDP_TC_BIT] =		 "tc-offload-xdp",
 };
 
 static const char
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3565d9a..4c89bab 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -37,6 +37,7 @@
 #include <net/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_ct.h>
 #include <net/tc_act/tc_mpls.h>
+#include <net/flow_offload_xdp.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
 
@@ -806,7 +807,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 				 struct net_device *dev,
 				 struct tcf_block_ext_info *ei,
 				 enum flow_block_command command,
-				 struct netlink_ext_ack *extack)
+				 bool xdp, struct netlink_ext_ack *extack)
 {
 	struct flow_block_offload bo = {};
 	int err;
@@ -819,13 +820,39 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 	bo.extack = extack;
 	INIT_LIST_HEAD(&bo.cb_list);
 
-	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	if (xdp)
+		err = xdp_flow_setup_block(dev, &bo);
+	else
+		err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
 	if (err < 0)
 		return err;
 
 	return tcf_block_setup(block, &bo);
 }
 
+static int tcf_block_offload_bind_xdp(struct tcf_block *block, struct Qdisc *q,
+				      struct tcf_block_ext_info *ei,
+				      struct netlink_ext_ack *extack)
+{
+	struct net_device *dev = q->dev_queue->dev;
+	int err;
+
+	if (!tc_xdp_offload_enabled(dev) && tcf_block_offload_in_use(block)) {
+		NL_SET_ERR_MSG(extack,
+			       "Bind to offloaded block failed as dev has tc-offload-xdp disabled");
+		return -EOPNOTSUPP;
+	}
+
+	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_BIND, true,
+				    extack);
+	if (err == -EOPNOTSUPP) {
+		block->nooffloaddevcnt++;
+		err = 0;
+	}
+
+	return err;
+}
+
 static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 				  struct tcf_block_ext_info *ei,
 				  struct netlink_ext_ack *extack)
@@ -833,6 +860,15 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 	struct net_device *dev = q->dev_queue->dev;
 	int err;
 
+	if (block->xdp)
+		return tcf_block_offload_bind_xdp(block, q, ei, extack);
+
+	if (tc_xdp_offload_enabled(dev)) {
+		NL_SET_ERR_MSG(extack,
+			       "Cannot bind to block created with tc-offload-xdp disabled");
+		return -EOPNOTSUPP;
+	}
+
 	if (!dev->netdev_ops->ndo_setup_tc)
 		goto no_offload_dev_inc;
 
@@ -844,7 +880,8 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 		return -EOPNOTSUPP;
 	}
 
-	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_BIND, extack);
+	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_BIND, false,
+				    extack);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_inc;
 	if (err)
@@ -861,17 +898,35 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 	return 0;
 }
 
+static void tcf_block_offload_unbind_xdp(struct tcf_block *block,
+					 struct net_device *dev,
+					 struct tcf_block_ext_info *ei)
+{
+	int err;
+
+	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, true,
+				    NULL);
+	if (err == -EOPNOTSUPP)
+		WARN_ON(block->nooffloaddevcnt-- == 0);
+}
+
 static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 				     struct tcf_block_ext_info *ei)
 {
 	struct net_device *dev = q->dev_queue->dev;
 	int err;
 
+	if (block->xdp) {
+		tcf_block_offload_unbind_xdp(block, dev, ei);
+		return;
+	}
+
 	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
 
 	if (!dev->netdev_ops->ndo_setup_tc)
 		goto no_offload_dev_dec;
-	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
+	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, false,
+				    NULL);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_dec;
 	return;
@@ -1004,6 +1059,10 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
 	/* Don't store q pointer for blocks which are shared */
 	if (!tcf_block_shared(block))
 		block->q = q;
+
+	if (tc_xdp_offload_enabled(q->dev_queue->dev))
+		block->xdp = true;
+
 	return block;
 }
 
diff --git a/net/xdp_flow/xdp_flow_kern_mod.c b/net/xdp_flow/xdp_flow_kern_mod.c
index fe925db..891b18c 100644
--- a/net/xdp_flow/xdp_flow_kern_mod.c
+++ b/net/xdp_flow/xdp_flow_kern_mod.c
@@ -410,6 +410,12 @@ static int xdp_flow_setup_block_cb(enum tc_setup_type type, void *type_data,
 	struct net_device *dev = cb_priv;
 	int err = 0;
 
+	if (!tc_xdp_offload_enabled(dev)) {
+		NL_SET_ERR_MSG(common->extack,
+			       "tc-offload-xdp is disabled on net device");
+		return -EOPNOTSUPP;
+	}
+
 	if (common->chain_index) {
 		NL_SET_ERR_MSG(common->extack,
 			       "xdp_flow supports only offload of chain 0");
-- 
1.8.3.1

