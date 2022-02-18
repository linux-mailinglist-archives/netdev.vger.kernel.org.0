Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5AF4BBFA6
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 19:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbiBRSjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 13:39:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239306AbiBRSiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 13:38:54 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80054.outbound.protection.outlook.com [40.107.8.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8E124089
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 10:38:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hK20nzwDhxFc9M5a1gYdfkfecaZvGGoq39vfUowyiAhTDgxWmOF7IZHBR73x6LWRa3krUocV3pwezCNLTZA3uVliXoTYvNhD/n3emymCwyDFbwtACqt6SuLj4e7qYb50nzzUlep1bm0EgC/JbYK95QuZ0MXlFAODUcLRd7QOcW/9O06xPYnP5q5lSuN5SEKLx+x5KY+8UEQH/jj8SWJsy4hcmyjcZT2BVp0SHwM+c87GUM0Dx0HJNZsMsUZDk+6DSXQMoePHlB1YpE4plcjl9SeD8HunmU+M4FOv96z8RyOGYrDVBJgzrzNJgbX+ODBfrCHEmDdvHCeM0HdBCWcssg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saL+1VdggKX3w3BO2oANI5On1tnZl8HJSe1onXMfyCw=;
 b=HP4TkkHZgNVjQ/vtD5sunH4IaelkrbG2lFatLaaTfvBokLEZRAJrpWHS9BUZQf43/ZcoQrocfhe6SVLKkfqMdqe7KXQzPJIBYXyl8fFMIQGMRkcAxnir/wpbmIupF8F5I3HnrhL2+jjgLmCIdkJkyR7DYc2KUpA/KH749JLmsi57bYYx6b2RlPnbTDcBuJrGMszs4kgNuT7hZdxKELnyJ+abUXj0tq5WteaYbOJn9R0Uaf4dggIBGu4pB3oiFWzHnKPDTNTHUHfa2jWik5tO7ZMGVnSTHrMBVRyRkQo72b4uVm0mQjobAhXnIoXAObaZ2uuEZh7sAX/dXo/22PHPVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saL+1VdggKX3w3BO2oANI5On1tnZl8HJSe1onXMfyCw=;
 b=UZwhAhxeFAU7JDOzanpBHPdzeJbSeFIGqdW5IA7oFn5eipK2L8R9mKjKPerdjNeVE3owAlC/IKd5y3NYaKIJG+/N8KxvepbGi2zbc4m4T8vjKg2s0ueaMWcwkgNh32KqwGam36qwFRhP9XIy0HPQFeYTV3qnhDe4739uflZ3aiM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by PAXPR04MB9217.eurprd04.prod.outlook.com (2603:10a6:102:232::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.18; Fri, 18 Feb
 2022 18:38:33 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45%6]) with mapi id 15.20.4995.022; Fri, 18 Feb 2022
 18:38:33 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        richardcochran@gmail.com, Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net-next v2 2/2] dpaa2-eth: Update SINGLE_STEP register access
Date:   Fri, 18 Feb 2022 20:37:55 +0200
Message-Id: <20220218183755.12014-3-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220218183755.12014-1-radu-andrei.bulie@nxp.com>
References: <20220218183755.12014-1-radu-andrei.bulie@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0066.eurprd07.prod.outlook.com
 (2603:10a6:207:4::24) To VI1PR04MB5903.eurprd04.prod.outlook.com
 (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37fda9aa-2a5b-48c5-b6f6-08d9f30dde0c
X-MS-TrafficTypeDiagnostic: PAXPR04MB9217:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB92174CB8CF2812C6DFA499CAB0379@PAXPR04MB9217.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x8olVQPbeJrN/liI3n9wCaqaW9hLCp5up9FFIdZ25cmFJgqf18ASJtXII3Bu7G4sWoCzJSIHWSboWha2oZEkM9SWLVsZMY9xFgPaU5sYBOY1LTnbMdRB7BlVV8VACgISXzN6CBMzgFOLYWiTeHatexdWktPVj8hK77XKU1u6zeOHuzYNQPa5nIxnvdXpnZDmK3BLSkruFpUSDmbcVHYLB8jJq5YI4X61PVg7QUE4JcEyLaLVBS5ZiJW6dZP05ufh6o1CmM/4F3uoUFLvzrtaOp9PFy1JydjCoTpbkMEI4YstL72sA+Qx3806xN0UlrVzO974i9zuLe72Uoti6szrRzroiuyvEOkQmsGvGvNIxqctDeXDuPDl45eCjEeYjz/lJA6mSfvNNs/0N95PJWoFeKmXsh7AC8BK1aDegHg6iGF5kLw6PYBUOdz1hAmuMSOtoMaoBbDP50Uzdy6REWbSdNtJmMjs5YFMQi78UZKohHZdredDDIoOIsfkWroxOdrV/3C4DY8IspHzj5sJNhseB1lWVd1MAZee5V9vNp5bEnGBtk3fOnMwHQ2pZ1vo0qtXb6xXDEQGHAqY1XM6rW+/QUl05SK6+/cDWqMbV6sVYKteGCuOSqMFHCajV7No1Lmm9wn+mTd5jbPuAky8vmlenP9GkEZi5N/nc7TyzMqcABh/vqGkL7vixyjGqiG/PJvqXX/bCMy9OyTtNnASaHBitA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(1076003)(8676002)(26005)(2906002)(186003)(8936002)(6486002)(36756003)(86362001)(6512007)(52116002)(38350700002)(508600001)(6506007)(6666004)(83380400001)(38100700002)(5660300002)(66556008)(15650500001)(66476007)(66946007)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z8zInqtJnuSDpNg4qPLzG8PEELhh80INVI+oqzhycmkb6IdamqMJISE2G9q4?=
 =?us-ascii?Q?PQlpOd+QYdddt7er85ySqmLWJFy8C5v+TD2bCIGyJbrNGPcIl/m+F/ZLc7N4?=
 =?us-ascii?Q?LSzoBEd7VUKmoqVcyWig5HB2+eyN79ITq/XKrIRIdP2XrE3h5dq0xW/yZ0Ca?=
 =?us-ascii?Q?tTNN2MZ/lRh+/g0EzqJU8ZQpDKqITU4CpckUeyfUtvJMZC3+YoUXWcvscbnA?=
 =?us-ascii?Q?lkXH7kMZyDP0HkrtgVJKN6iFp4FPoNnLtFDyvcesjIR8AyDGpCooxT9eMAg5?=
 =?us-ascii?Q?6bNtT1ZComZx0bd88TEYMxMtN0VJJZDxemyfbB7hxAHMW9h8UQ3QMVFE5rya?=
 =?us-ascii?Q?V+kvV42lxxNJdNDoJYg8JkFqhecPL/yN4FIffROT2/y6rawdctUKEefxh6fi?=
 =?us-ascii?Q?wb7z8YwJim6ENLM7dfuaNfnVPdzyh/75Tq3tJofHTj7rarl4ElD9aUUH+CRP?=
 =?us-ascii?Q?b3n2HBtF+wwTuE177j1i6uDsCfEndzSezo3SqVQ6yWW4Zp9+jRL7IObcy/Mt?=
 =?us-ascii?Q?HNOxCDqyb2zE0Z0VMKww6CCmLymLyseAct/RkxMlnyFcU3x/JrQ28eEB38Mw?=
 =?us-ascii?Q?PRIQDuADw0YFX0zU7+WUotXmSUTTODYuQ8uXbl0bwX+IFh1iVC6U1Adq0vM3?=
 =?us-ascii?Q?zFxuaIkOFblVgydVDtAIrFZW4QOs7lJ7PjwD9FC6aobcLBJE9AXHZFluZV/3?=
 =?us-ascii?Q?jOtlWDsFuH0BIlQ6eajjly1moVuVDnFJFJYzRyneFjBtOcGc8KxG68L5bI6G?=
 =?us-ascii?Q?jAotgd6+sxyk0ZplpkYKErZ1QxokEDNEgGhkdQmiBSGHHPl6o0EaL6Vj/GPm?=
 =?us-ascii?Q?dMVW1Vg36hgTzDcr5sPUBGVwwYwpqjOW+vLj4Zj0Og/zvC0fmjskWlKHv4JW?=
 =?us-ascii?Q?HW6TcpmRhBAWjzTMczt6epT00OuPhq/061Zdb3tmgrg0ScVWGUPyaSlvTIuF?=
 =?us-ascii?Q?nL+ZlrvmeGzcYM68zIVYijufTZGX5uiKIQM3EjfeY8IEbcDlBMqw9P4kTKy9?=
 =?us-ascii?Q?kmMaHkPsWsDHW0vPMZ4j1RGacji8nZd5StLgMzFsn5ca21ejMaPCyn96gTsB?=
 =?us-ascii?Q?CX5/oAvvKrd/ahBulJyyPWX9l4LMzFy76zdodgSyccyJFHkk25tSzMCsLyyV?=
 =?us-ascii?Q?eCeAzwB3i3JyCNFQknzMPa1xmt0kOksb3RoltCxEXxPhjsrBDY/y7d3Sh5El?=
 =?us-ascii?Q?bRh61gmSQgP5PhOTZN13fIKx6EP3Yse0UbTXdwkpo8Bch3I5T+p+OGe7keKv?=
 =?us-ascii?Q?OwAsxfS9EPY7NeDbHyuzPZdlCghn+kDogbAJ5G2Cqu0z/k95lPjgyAx/WZCG?=
 =?us-ascii?Q?db2MSYLHyCsreCqSpkuhfnMHmXMcQVNJOzO6dctspZoB7y7bvBRpgkIy3jd/?=
 =?us-ascii?Q?ixSDP1RnHUka8mx4LVeKQqL3NmPeAbzH2F07u6Es8D6AetgMaPhD1k+rllt5?=
 =?us-ascii?Q?WgoMxyW9VPhVo5/1/aCC+x4m7ZnPcXZN5mE0+efHDPsCznlnRJBlSAE1UKW1?=
 =?us-ascii?Q?8MXKoVsw3F+htDW603TDgdfTq0PhPZbspmJmDdYdOSCRyLguB6iy0F8k0PyF?=
 =?us-ascii?Q?dBlde8Qkr2UY7aWL3XwXK+2fT6NoSMk9RjbvMJ476/Ks0tLTWjuzKl28ba3F?=
 =?us-ascii?Q?NTZ2hGbRHwlAyxwFxgGaG9rt1HixpUipxos7pmVi8AYDkdog/JMc1n0BNKNE?=
 =?us-ascii?Q?vYpF/A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37fda9aa-2a5b-48c5-b6f6-08d9f30dde0c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 18:38:33.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3yq1twlyoyWXlZgfN0Ah5+xCST6OG3LWvO9graq08zvW5N17bz0+iXTnupGDjx2pQhsYaSIAIpZ/x8w+PG2oKxwJDsdI+q9ATQ1brns6sw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9217
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPAA2 MAC supports 1588 one step timestamping.
If this option is enabled then for each transmitted PTP event packet,
the 1588 SINGLE_STEP register is accessed to modify the following fields:

-offset of the correction field inside the PTP packet
-UDP checksum update bit,  in case the PTP event packet has
 UDP encapsulation

These values can change any time, because there may be multiple
PTP clients connected, that receive various 1588 frame types:
- L2 only frame
- UDP / Ipv4
- UDP / Ipv6
- other

The current implementation uses dpni_set_single_step_cfg to update the
SINLGE_STEP register.
Using an MC command  on the Tx datapath for each transmitted 1588 message
introduces high delays, leading to low throughput and consequently to a
small number of supported PTP clients. Besides these, the nanosecond
correction field from the PTP packet will contain the high delay from the
driver which together with the originTimestamp will render timestamp
values that are unacceptable in a GM clock implementation.

This patch updates the Tx datapath for 1588 messages when single step
timestamp is enabled and provides direct access to SINGLE_STEP register,
eliminating the  overhead caused by the dpni_set_single_step_cfg
MC command. MC version >= 10.32 implements this functionality.
If the MC version does not have support for returning the
single step register base address, the driver will use
dpni_set_single_step_cfg command for updates operations.

All the delay introduced by dpni_set_single_step_cfg
function will be eliminated (if MC version has support for returning the
base address of the single step register), improving the egress driver
performance for PTP packets when single step timestamping is enabled.

Before these changes the maximum throughput for 1588 messages with
single step hardware timestamp enabled was around 2000pps.
After the updates the throughput increased up to 32.82 Mbps / 46631.02 pps.

Signed-off-by: Radu Bulie <radu-andrei.bulie@nxp.com>
---
Changes in v2:
 - move global function pointer into the driver's private structure
 - move common code outside the body of the callback functions
 - update function dpaa2_ptp_onestep_reg_update_method  and remove goto
   statement from paths that do not treat an error case

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 89 +++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 14 ++-
 2 files changed, 93 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index c4a48e6f1758..aab11d5da062 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -35,6 +35,75 @@ MODULE_DESCRIPTION("Freescale DPAA2 Ethernet Driver");
 struct ptp_qoriq *dpaa2_ptp;
 EXPORT_SYMBOL(dpaa2_ptp);
 
+static void dpaa2_eth_detect_features(struct dpaa2_eth_priv *priv)
+{
+	priv->features = 0;
+
+	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_PTP_ONESTEP_VER_MAJOR,
+				   DPNI_PTP_ONESTEP_VER_MINOR) >= 0)
+		priv->features |= DPAA2_ETH_FEATURE_ONESTEP_CFG_DIRECT;
+}
+
+static void dpaa2_update_ptp_onestep_indirect(struct dpaa2_eth_priv *priv,
+					      u32 offset, u8 udp)
+{
+	struct dpni_single_step_cfg cfg;
+
+	cfg.en = 1;
+	cfg.ch_update = udp;
+	cfg.offset = offset;
+	cfg.peer_delay = 0;
+
+	if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token, &cfg))
+		WARN_ONCE(1, "Failed to set single step register");
+}
+
+static void dpaa2_update_ptp_onestep_direct(struct dpaa2_eth_priv *priv,
+					    u32 offset, u8 udp)
+{
+	u32 val = 0;
+
+	val = DPAA2_PTP_SINGLE_STEP_ENABLE |
+	       DPAA2_PTP_SINGLE_CORRECTION_OFF(offset);
+
+	if (udp)
+		val |= DPAA2_PTP_SINGLE_STEP_CH;
+
+	if (priv->onestep_reg_base)
+		writel(val, priv->onestep_reg_base);
+}
+
+static void dpaa2_ptp_onestep_reg_update_method(struct dpaa2_eth_priv *priv)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	struct dpni_single_step_cfg ptp_cfg;
+
+	priv->dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_indirect;
+
+	if (!(priv->features & DPAA2_ETH_FEATURE_ONESTEP_CFG_DIRECT))
+		return;
+
+	if (dpni_get_single_step_cfg(priv->mc_io, 0,
+				     priv->mc_token, &ptp_cfg)) {
+		dev_err(dev, "dpni_get_single_step_cfg cannot retrieve onestep reg, falling back to indirect update\n");
+		return;
+	}
+
+	if (!ptp_cfg.ptp_onestep_reg_base) {
+		dev_err(dev, "1588 onestep reg not available, falling back to indirect update\n");
+		return;
+	}
+
+	priv->onestep_reg_base = ioremap(ptp_cfg.ptp_onestep_reg_base,
+					 sizeof(u32));
+	if (!priv->onestep_reg_base) {
+		dev_err(dev, "1588 onestep reg cannot be mapped, falling back to indirect update\n");
+		return;
+	}
+
+	priv->dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_direct;
+}
+
 static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
 				dma_addr_t iova_addr)
 {
@@ -696,7 +765,6 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 				       struct sk_buff *skb)
 {
 	struct ptp_tstamp origin_timestamp;
-	struct dpni_single_step_cfg cfg;
 	u8 msgtype, twostep, udp;
 	struct dpaa2_faead *faead;
 	struct dpaa2_fas *fas;
@@ -750,14 +818,12 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 			htonl(origin_timestamp.sec_lsb);
 		*(__be32 *)(data + offset2 + 6) = htonl(origin_timestamp.nsec);
 
-		cfg.en = 1;
-		cfg.ch_update = udp;
-		cfg.offset = offset1;
-		cfg.peer_delay = 0;
+		if (priv->ptp_correction_off == offset1)
+			return;
+
+		priv->dpaa2_set_onestep_params_cb(priv, offset1, udp);
+		priv->ptp_correction_off = offset1;
 
-		if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token,
-					     &cfg))
-			WARN_ONCE(1, "Failed to set single step register");
 	}
 }
 
@@ -2407,6 +2473,9 @@ static int dpaa2_eth_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
 	}
 
+	if (priv->tx_tstamp_type == HWTSTAMP_TX_ONESTEP_SYNC)
+		dpaa2_ptp_onestep_reg_update_method(priv);
+
 	return copy_to_user(rq->ifr_data, &config, sizeof(config)) ?
 			-EFAULT : 0;
 }
@@ -4300,6 +4369,8 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 		return err;
 	}
 
+	dpaa2_eth_detect_features(priv);
+
 	/* Capabilities listing */
 	supported |= IFF_LIVE_ADDR_CHANGE;
 
@@ -4758,6 +4829,8 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	dpaa2_eth_free_dpbp(priv);
 	dpaa2_eth_free_dpio(priv);
 	dpaa2_eth_free_dpni(priv);
+	if (priv->onestep_reg_base)
+		iounmap(priv->onestep_reg_base);
 
 	fsl_mc_portal_free(priv->mc_io);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index b79831cd1a94..51ab08bdd1b3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -526,12 +526,15 @@ struct dpaa2_eth_priv {
 	u8 num_channels;
 	struct dpaa2_eth_channel *channel[DPAA2_ETH_MAX_DPCONS];
 	struct dpaa2_eth_sgt_cache __percpu *sgt_cache;
-
+	unsigned long features;
 	struct dpni_attr dpni_attrs;
 	u16 dpni_ver_major;
 	u16 dpni_ver_minor;
 	u16 tx_data_offset;
-
+	void __iomem *onestep_reg_base;
+	u8 ptp_correction_off;
+	static void (*dpaa2_set_onestep_params_cb)(struct dpaa2_eth_priv *priv,
+						   u32 offset, u8 udp);
 	struct fsl_mc_device *dpbp_dev;
 	u16 rx_buf_size;
 	u16 bpid;
@@ -673,6 +676,13 @@ enum dpaa2_eth_rx_dist {
 #define DPAA2_ETH_DIST_L4DST		BIT(8)
 #define DPAA2_ETH_DIST_ALL		(~0ULL)
 
+#define DPNI_PTP_ONESTEP_VER_MAJOR 8
+#define DPNI_PTP_ONESTEP_VER_MINOR 2
+#define DPAA2_ETH_FEATURE_ONESTEP_CFG_DIRECT BIT(0)
+#define DPAA2_PTP_SINGLE_STEP_ENABLE	BIT(31)
+#define DPAA2_PTP_SINGLE_STEP_CH	BIT(7)
+#define DPAA2_PTP_SINGLE_CORRECTION_OFF(v) ((v) << 8)
+
 #define DPNI_PAUSE_VER_MAJOR		7
 #define DPNI_PAUSE_VER_MINOR		13
 #define dpaa2_eth_has_pause_support(priv)			\
-- 
2.17.1

