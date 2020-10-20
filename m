Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B5F2935D1
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405221AbgJTHcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:32:51 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36876 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405194AbgJTHct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:32:49 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4734E1A0794;
        Tue, 20 Oct 2020 09:32:47 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 619361A074F;
        Tue, 20 Oct 2020 09:32:39 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id F103840327;
        Tue, 20 Oct 2020 09:32:26 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: [PATCH v1 net-next 5/5] net: dsa: felix: add police action for tc flower offload
Date:   Tue, 20 Oct 2020 15:23:21 +0800
Message-Id: <20201020072321.36921-6-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add police action to set flow meter table which is defined
in IEEE802.1Qci. Flow metering is two rates two buckets and three color
marker to policing the frames, we only enable one rate one bucket in
this patch.

Flow metering shares a same policer pool with VCAP policers, it calls
ocelot_vcap_policer_add() and ocelot_vcap_policer_del() to set flow
meter table.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_flower.c | 32 +++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_flower.c b/drivers/net/dsa/ocelot/felix_flower.c
index 71894dcc0af2..d58a2357bab1 100644
--- a/drivers/net/dsa/ocelot/felix_flower.c
+++ b/drivers/net/dsa/ocelot/felix_flower.c
@@ -363,6 +363,8 @@ static void felix_list_stream_filter_del(struct ocelot *ocelot, u32 index)
 		if (tmp->index == index) {
 			if (tmp->sg_valid)
 				felix_list_gate_del(ocelot, tmp->sgid);
+			if (tmp->fm_valid)
+				ocelot_vcap_policer_del(ocelot, tmp->fmid);
 
 			z = refcount_dec_and_test(&tmp->refcount);
 			if (z) {
@@ -466,6 +468,8 @@ static int felix_psfp_set(struct ocelot *ocelot,
 	if (ret) {
 		if (sfi->sg_valid)
 			felix_list_gate_del(ocelot, sfi->sgid);
+		if (sfi->fm_valid)
+			ocelot_vcap_policer_del(ocelot, sfi->fmid);
 		return ret;
 	}
 
@@ -559,7 +563,9 @@ int felix_flower_stream_replace(struct ocelot *ocelot, int port,
 	struct felix_streamid stream = {0};
 	struct felix_stream_gate_conf *sgi;
 	const struct flow_action_entry *a;
+	struct ocelot_policer pol;
 	int ret, size, i;
+	u64 rate, burst;
 	u32 index;
 
 	ret = felix_flower_parse_key(f, &stream);
@@ -595,6 +601,32 @@ int felix_flower_stream_replace(struct ocelot *ocelot, int port,
 			stream.sfid_valid = 1;
 			kfree(sgi);
 			break;
+		case FLOW_ACTION_POLICE:
+			if (f->common.chain_index != OCELOT_PSFP_CHAIN) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action only be offloaded to PSFP chain");
+				return -EOPNOTSUPP;
+			}
+
+			index = a->police.index + FELIX_POLICER_PSFP_BASE;
+			if (index > FELIX_POLICER_PSFP_MAX)
+				return -EINVAL;
+
+			rate = a->police.rate_bytes_ps;
+			burst = rate * PSCHED_NS2TICKS(a->police.burst);
+			pol = (struct ocelot_policer) {
+				.burst = div_u64(burst, PSCHED_TICKS_PER_SEC),
+				.rate = div_u64(rate, 1000) * 8,
+			};
+			ret = ocelot_vcap_policer_add(ocelot, index, &pol);
+			if (ret)
+				return ret;
+
+			sfi.fm_valid = 1;
+			sfi.fmid = index;
+			sfi.maxsdu = a->police.mtu;
+			stream.sfid_valid = 1;
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
-- 
2.17.1

