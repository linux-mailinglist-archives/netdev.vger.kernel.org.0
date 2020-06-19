Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70B1200B56
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731917AbgFSOWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:22:31 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:7233 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgFSOWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:22:25 -0400
Received: from vishal.asicdesigners.com (chethan-pc.asicdesigners.com [10.193.177.170] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05JELtbf002529;
        Fri, 19 Jun 2020 07:22:15 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, rahul.lakkireddy@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 4/5] cxgb4: add support to fetch ethtool n-tuple filters
Date:   Fri, 19 Jun 2020 19:51:38 +0530
Message-Id: <20200619142139.27982-5-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200619142139.27982-1-vishal@chelsio.com>
References: <20200619142139.27982-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to fetch the requested ethtool n-tuple filters by
translating them from hardware spec to ethtool n-tuple spec.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 110 ++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 5c588677877d..3dd28e5856ba 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1589,10 +1589,104 @@ static struct filter_entry *cxgb4_get_filter_entry(struct adapter *adap,
 	return f;
 }
 
+static void cxgb4_fill_filter_rule(struct ethtool_rx_flow_spec *fs,
+				   struct ch_filter_specification *dfs)
+{
+	switch (dfs->val.proto) {
+	case IPPROTO_TCP:
+		if (dfs->type)
+			fs->flow_type = TCP_V6_FLOW;
+		else
+			fs->flow_type = TCP_V4_FLOW;
+		break;
+	case IPPROTO_UDP:
+		if (dfs->type)
+			fs->flow_type = UDP_V6_FLOW;
+		else
+			fs->flow_type = UDP_V4_FLOW;
+		break;
+	}
+
+	if (dfs->type) {
+		fs->h_u.tcp_ip6_spec.psrc = cpu_to_be16(dfs->val.fport);
+		fs->m_u.tcp_ip6_spec.psrc = cpu_to_be16(dfs->mask.fport);
+		fs->h_u.tcp_ip6_spec.pdst = cpu_to_be16(dfs->val.lport);
+		fs->m_u.tcp_ip6_spec.pdst = cpu_to_be16(dfs->mask.lport);
+		memcpy(&fs->h_u.tcp_ip6_spec.ip6src, &dfs->val.fip[0],
+		       sizeof(fs->h_u.tcp_ip6_spec.ip6src));
+		memcpy(&fs->m_u.tcp_ip6_spec.ip6src, &dfs->mask.fip[0],
+		       sizeof(fs->m_u.tcp_ip6_spec.ip6src));
+		memcpy(&fs->h_u.tcp_ip6_spec.ip6dst, &dfs->val.lip[0],
+		       sizeof(fs->h_u.tcp_ip6_spec.ip6dst));
+		memcpy(&fs->m_u.tcp_ip6_spec.ip6dst, &dfs->mask.lip[0],
+		       sizeof(fs->m_u.tcp_ip6_spec.ip6dst));
+		fs->h_u.tcp_ip6_spec.tclass = dfs->val.tos;
+		fs->m_u.tcp_ip6_spec.tclass = dfs->mask.tos;
+	} else {
+		fs->h_u.tcp_ip4_spec.psrc = cpu_to_be16(dfs->val.fport);
+		fs->m_u.tcp_ip4_spec.psrc = cpu_to_be16(dfs->mask.fport);
+		fs->h_u.tcp_ip4_spec.pdst = cpu_to_be16(dfs->val.lport);
+		fs->m_u.tcp_ip4_spec.pdst = cpu_to_be16(dfs->mask.lport);
+		memcpy(&fs->h_u.tcp_ip4_spec.ip4src, &dfs->val.fip[0],
+		       sizeof(fs->h_u.tcp_ip4_spec.ip4src));
+		memcpy(&fs->m_u.tcp_ip4_spec.ip4src, &dfs->mask.fip[0],
+		       sizeof(fs->m_u.tcp_ip4_spec.ip4src));
+		memcpy(&fs->h_u.tcp_ip4_spec.ip4dst, &dfs->val.lip[0],
+		       sizeof(fs->h_u.tcp_ip4_spec.ip4dst));
+		memcpy(&fs->m_u.tcp_ip4_spec.ip4dst, &dfs->mask.lip[0],
+		       sizeof(fs->m_u.tcp_ip4_spec.ip4dst));
+		fs->h_u.tcp_ip4_spec.tos = dfs->val.tos;
+		fs->m_u.tcp_ip4_spec.tos = dfs->mask.tos;
+	}
+	fs->h_ext.vlan_tci = cpu_to_be16(dfs->val.ivlan);
+	fs->m_ext.vlan_tci = cpu_to_be16(dfs->mask.ivlan);
+	fs->flow_type |= FLOW_EXT;
+
+	if (dfs->action == FILTER_DROP)
+		fs->ring_cookie = RX_CLS_FLOW_DISC;
+	else
+		fs->ring_cookie = dfs->iq;
+}
+
+static int cxgb4_ntuple_get_filter(struct net_device *dev,
+				   struct ethtool_rxnfc *cmd,
+				   unsigned int loc)
+{
+	const struct port_info *pi = netdev_priv(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct filter_entry *f;
+	int ftid;
+
+	if (!(adap->flags & CXGB4_FULL_INIT_DONE))
+		return -EAGAIN;
+
+	/* Check for maximum filter range */
+	if (!adap->ethtool_filters)
+		return -EOPNOTSUPP;
+
+	if (loc >= adap->ethtool_filters->nentries)
+		return -ERANGE;
+
+	if (!test_bit(loc, adap->ethtool_filters->port[pi->port_id].bmap))
+		return -ENOENT;
+
+	ftid = adap->ethtool_filters->port[pi->port_id].loc_array[loc];
+
+	/* Fetch filter_entry */
+	f = cxgb4_get_filter_entry(adap, ftid);
+
+	cxgb4_fill_filter_rule(&cmd->fs, &f->fs);
+
+	return 0;
+}
+
 static int get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
 		     u32 *rules)
 {
 	const struct port_info *pi = netdev_priv(dev);
+	struct adapter *adap = netdev2adap(dev);
+	unsigned int count = 0, index = 0;
+	int ret = 0;
 
 	switch (info->cmd) {
 	case ETHTOOL_GRXFH: {
@@ -1648,7 +1742,23 @@ static int get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
 	case ETHTOOL_GRXRINGS:
 		info->data = pi->nqsets;
 		return 0;
+	case ETHTOOL_GRXCLSRLCNT:
+		info->rule_cnt =
+		       adap->ethtool_filters->port[pi->port_id].in_use;
+		return 0;
+	case ETHTOOL_GRXCLSRULE:
+		return cxgb4_ntuple_get_filter(dev, info, info->fs.location);
+	case ETHTOOL_GRXCLSRLALL:
+		info->data = adap->ethtool_filters->nentries;
+		while (count < info->rule_cnt) {
+			ret = cxgb4_ntuple_get_filter(dev, info, index);
+			if (!ret)
+				rules[count++] = index;
+			index++;
+		}
+		return 0;
 	}
+
 	return -EOPNOTSUPP;
 }
 
-- 
2.21.1

