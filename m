Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBA52933CF
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 06:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391375AbgJTEOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 00:14:15 -0400
Received: from inva021.nxp.com ([92.121.34.21]:37644 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgJTEOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 00:14:12 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 13B752004D2;
        Tue, 20 Oct 2020 06:14:10 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DC8922003DC;
        Tue, 20 Oct 2020 06:14:02 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 1DE1A40305;
        Tue, 20 Oct 2020 06:13:54 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        Jose.Abreu@synopsys.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: [RFC, net-next 1/3] net: dsa: ethtool preempt ops support on slave ports
Date:   Tue, 20 Oct 2020 12:04:56 +0800
Message-Id: <20201020040458.39794-2-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
References: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preempt_set and preempt_get are new functions of ethtool ops, which
is to configure frame preemption according to 802.1qbu and 802.3br.
Add them on slave ports of DSA framework, so that DSA devices can
support to configure frame preemption by using ethtool.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 include/net/dsa.h | 12 ++++++++++++
 net/dsa/slave.c   | 26 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 35429a140dfa..85b196ade511 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -499,6 +499,18 @@ struct dsa_switch_ops {
 	int	(*get_ts_info)(struct dsa_switch *ds, int port,
 			       struct ethtool_ts_info *ts);
 
+	/*
+	 * ethtool --set-frame-preemption
+	 */
+	int	(*set_preempt)(struct dsa_switch *ds, int port,
+			       struct ethtool_fp *fpcmd);
+
+	/*
+	 * ethtool --show-frame-preemption
+	 */
+	int	(*get_preempt)(struct dsa_switch *ds, int port,
+			       struct ethtool_fp *fpcmd);
+
 	/*
 	 * Suspend and resume
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e7c1d62fde99..f51a1575266c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1281,6 +1281,30 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
 	return ds->ops->get_ts_info(ds, p->dp->index, ts);
 }
 
+static int dsa_slave_set_preempt(struct net_device *dev,
+				 struct ethtool_fp *fpcmd)
+{
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_switch *ds = p->dp->ds;
+
+	if (!ds->ops->set_preempt)
+		return -EOPNOTSUPP;
+
+	return ds->ops->set_preempt(ds, p->dp->index, fpcmd);
+}
+
+static int dsa_slave_get_preempt(struct net_device *dev,
+				 struct ethtool_fp *fpcmd)
+{
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_switch *ds = p->dp->ds;
+
+	if (!ds->ops->get_preempt)
+		return -EOPNOTSUPP;
+
+	return ds->ops->get_preempt(ds, p->dp->index, fpcmd);
+}
+
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
@@ -1571,6 +1595,8 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_rxnfc		= dsa_slave_get_rxnfc,
 	.set_rxnfc		= dsa_slave_set_rxnfc,
 	.get_ts_info		= dsa_slave_get_ts_info,
+	.set_preempt		= dsa_slave_set_preempt,
+	.get_preempt		= dsa_slave_get_preempt,
 };
 
 /* legacy way, bypassing the bridge *****************************************/
-- 
2.18.4

