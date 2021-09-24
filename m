Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B08A416F54
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245456AbhIXJow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:44:52 -0400
Received: from inva021.nxp.com ([92.121.34.21]:55412 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245352AbhIXJoh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 05:44:37 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B22492030C9;
        Fri, 24 Sep 2021 11:43:03 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4D9D12030C5;
        Fri, 24 Sep 2021 11:43:03 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 865B8183AC89;
        Fri, 24 Sep 2021 17:43:00 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com
Subject: [PATCH v5 net-next 9/9] net: dsa: felix: use vcap policer to set flow meter for psfp
Date:   Fri, 24 Sep 2021 17:52:26 +0800
Message-Id: <20210924095226.38079-10-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210924095226.38079-1-xiaoliang.yang_1@nxp.com>
References: <20210924095226.38079-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add police action to set flow meter table which is defined
in IEEE802.1Qci. Flow metering is two rates two buckets and three color
marker to policing the frames, we only enable one rate one bucket in
this patch.

Flow metering shares a same policer pool with VCAP policers, so the PSFP
policer calls ocelot_vcap_policer_add() and ocelot_vcap_policer_del() to
set flow meter police.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 32 +++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 25e132afd621..e6c3ccc17fe6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1343,6 +1343,7 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 
 #define VSC9959_PSFP_SFID_MAX			175
 #define VSC9959_PSFP_GATE_ID_MAX		183
+#define VSC9959_PSFP_POLICER_BASE		63
 #define VSC9959_PSFP_POLICER_MAX		383
 #define VSC9959_PSFP_GATE_LIST_NUM		4
 #define VSC9959_PSFP_GATE_CYCLETIME_MIN		5000
@@ -1850,7 +1851,10 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 	struct felix_stream stream = {0};
 	struct felix_stream_gate *sgi;
 	struct ocelot_psfp_list *psfp;
+	struct ocelot_policer pol;
 	int ret, i, size;
+	u64 rate, burst;
+	u32 index;
 
 	psfp = &ocelot->psfp;
 
@@ -1869,13 +1873,33 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 			ret = vsc9959_psfp_sgi_table_add(ocelot, sgi);
 			if (ret) {
 				kfree(sgi);
-				return ret;
+				goto err;
 			}
 			sfi.sg_valid = 1;
 			sfi.sgid = sgi->index;
 			kfree(sgi);
 			break;
 		case FLOW_ACTION_POLICE:
+			index = a->police.index + VSC9959_PSFP_POLICER_BASE;
+			if (index > VSC9959_PSFP_POLICER_MAX) {
+				ret = -EINVAL;
+				goto err;
+			}
+
+			rate = a->police.rate_bytes_ps;
+			burst = rate * PSCHED_NS2TICKS(a->police.burst);
+			pol = (struct ocelot_policer) {
+				.burst = div_u64(burst, PSCHED_TICKS_PER_SEC),
+				.rate = div_u64(rate, 1000) * 8,
+			};
+			ret = ocelot_vcap_policer_add(ocelot, index, &pol);
+			if (ret)
+				goto err;
+
+			sfi.fm_valid = 1;
+			sfi.fmid = index;
+			sfi.maxsdu = a->police.mtu;
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
@@ -1912,6 +1936,9 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 	if (sfi.sg_valid)
 		vsc9959_psfp_sgi_table_del(ocelot, sfi.sgid);
 
+	if (sfi.fm_valid)
+		ocelot_vcap_policer_del(ocelot, sfi.fmid);
+
 	return ret;
 }
 
@@ -1935,6 +1962,9 @@ static int vsc9959_psfp_filter_del(struct ocelot *ocelot,
 	if (sfi->sg_valid)
 		vsc9959_psfp_sgi_table_del(ocelot, sfi->sgid);
 
+	if (sfi->fm_valid)
+		ocelot_vcap_policer_del(ocelot, sfi->fmid);
+
 	vsc9959_psfp_sfi_table_del(ocelot, stream->sfid);
 
 	stream->sfid_valid = 0;
-- 
2.17.1

