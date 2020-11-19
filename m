Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1852B8FF4
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 11:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgKSKMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 05:12:42 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:38467
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbgKSKMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 05:12:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6OEn96L7wh7pZ+H6jmj41ar7FM+KPDkW8QGVv5qK6iHLrMNagd5UMGys8ONJSfbwWVcDCSVehqpg45hGXc7chISh2a0gh76IsNFRPyZryFYvDmi3JeA1BIeRYAdNnn6O61MnYjM3ERF2du9zq5zT6TQsrr+vo2abywq1IS97VEYBRlknq6AJEETV2P0fTQQfn14jKT8tDLZ06KAYH3zIoaOpGeCF9TGpMiQJZuMl/fBszx0nd1QAGUVHrtl/NUNQwBnh6eg/8MzwroIxQKiBfoAeQLa+KtbRE3I8eZ7cULav8iFZr3vuRHX9xFQ0T6tWJuhdxg7KqZYfUm7MoNWMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdPAf3n8PeyFg3ZRGsz0tqVEClHxRlH9KkZzhyIaYyE=;
 b=i3AK81vM/JaiIGLKx7MZp45dd5xpoF3O8lSnuETy4VGsSl92Qpt813H9Wrb0nwmcqOqDQCnpVi2XMZi0hCh38NshJyf/UF2s6pF/hI3Nqr85nLiQiDQGkGlsLogoKjZuEMLw9mwS9fnb5u54xw4TYksXXAbgZOG1HR80YzRfzzb5x1KddIAExFXB/7Z7ma1sfZipGaC98PHsT3gbyxsFuaqRCWDQL94CuIc3BCIQ1Ppvn90me6Ugo0msecNiS9sGPRnf6ZNp9camKaueoMGo71952vcscHrxUPNITngH7Ei0/0y0kz3Au7uAueX9JjZwLcP7jAvsRD7K4kLio83PIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdPAf3n8PeyFg3ZRGsz0tqVEClHxRlH9KkZzhyIaYyE=;
 b=JcSyvMMNssra8ZgUenMJ4iQURpaLW9GCNmvH8jYOMtkykoIXhH6Si0JpRZXzRwBzcjG275oCOeUY0xFJze3gpYMJlk+7wA1Mrg2dEE1wVqox/PhyKCcHlJ6GSHM2pRcxX515yMR657RhBOSSVZlXSxbdbO4p7AYBH7USLWgiP10=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DB7PR04MB5402.eurprd04.prod.outlook.com (2603:10a6:10:8f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Thu, 19 Nov
 2020 10:12:34 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90%6]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 10:12:34 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next resend 2/2] enetc: Fix endianness issues for enetc_qos
Date:   Thu, 19 Nov 2020 12:12:15 +0200
Message-Id: <20201119101215.19223-3-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119101215.19223-1-claudiu.manoil@nxp.com>
References: <20201119101215.19223-1-claudiu.manoil@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM8P192CA0025.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::30) To DB8PR04MB6764.eurprd04.prod.outlook.com
 (2603:10a6:10:10d::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM8P192CA0025.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 10:12:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60d24af7-78cd-42e6-64e8-08d88c73a1d9
X-MS-TrafficTypeDiagnostic: DB7PR04MB5402:
X-Microsoft-Antispam-PRVS: <DB7PR04MB54025F2BE3168408D935826296E00@DB7PR04MB5402.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m3G3QwXHxYstmH/fww/LBdsE4jBIWqyxIHndSOO6VjuTztyn96hJoGx1fn75QS2ON5q6LPS1z1gSHbWGIdxSyBuwqrmB4t2FjOBxnR/8i1dUnfRKE8Oe4NUFVPmRYHYAoHN4jEJn4vU9LnuGgBvcCsxVSS2zenJGTE5hws4YD/GVEhJq0H/W2tqiGyB4htirc26zZoXUZ5qwcEnl6BiI2OOgQZ9Eckh1/Tv+KhtLj5l1sWKh8eXbXPtgX4gLnBUQ56L53Gpd7WR4jHul+PgR2FuYTtglHtwxbXga7TsZrbhW5B+T08b3kqjFWTzRVW6A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(6486002)(6916009)(6666004)(66476007)(186003)(66556008)(16526019)(26005)(66946007)(478600001)(7696005)(316002)(52116002)(54906003)(83380400001)(5660300002)(86362001)(4326008)(2616005)(2906002)(1076003)(36756003)(8676002)(44832011)(956004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NAPXm0yMO3ymHXvLEonpXHLais9GHvplHxenRxiFQ2UUSefHnhfUz0p8iC3Ioj9CCA727ZzLEkfrPuPXovR23HjjnrjvVBF/9CXf7kp6jT4fI8GirouT/70b/icndU76HtsVXsC3eNIuwVs2Rg8NA0x+wHSoUL9094G+wcGVmaurRJ/oB+6NDaYipOdU6hcSZn8pN80tjU/YPn0/RoQe+mvb4di/SAlvAuISce5ZyjSpI/a83KNRORVySup5ouQdTBBBEPQia6aEjxSkx/L6k5OfP4KrwUnSCObrfBwmMMDttZ9n2ZzT948cdaZiy06QR285DEz9Q+UKtuOqPerhx6ClnIg+tdKAomTHt3x42C62gjvCzcl9jR+VolevfmxpuFcyQpK0yZzDOBF5aCuLBZCFn2Q5MRDXlhne3uY3RQc+He/WENA0poiS/U+HcRrv+KPvD3kmgC4p3RhFeN1Y2OoCc9FKqlkWjp/CvgzY9V8ZUOQkHLA3rgsCEyZ3Z8/xyK1mCofDp2Px6feKkLqRKuV/c+KGqc2ywV0gZeMAeROZIzKrxfLMqfxlJdtdqRIQlVCLRLHEKsQZGBw7tGuU962PQonToFSgHHjHESuu7TMHGSFOISFQpnZ59ne3cN8+Bq/jhDcqAO9e88T3QFiIEw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d24af7-78cd-42e6-64e8-08d88c73a1d9
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 10:12:33.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OECN2EZydnN1FpfFl2QlZDFME3z+gyck708RNBrOq0rlv/Rs0iio93XQPmwrKyisuyh0DjjaOhG4rZFUqasoOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5402
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the control buffer descriptor (cbd) fields have endianness
restrictions while the commands passed into the control buffers
don't (with one exception). This patch fixes offending code,
by adding endianness accessors for cbd fields and removing the
unnecessary ones in case of data buffer fields. Currently there's
no need to convert all commands to little endian format, the patch
only focuses on fixing current endianness issues reported by sparse.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 84 +++++++++----------
 1 file changed, 39 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 827f74e86d34..aeb21dc48099 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -128,8 +128,8 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		return -ENOMEM;
 	}
 
-	cbd.addr[0] = lower_32_bits(dma);
-	cbd.addr[1] = upper_32_bits(dma);
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
@@ -506,16 +506,15 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 		return -ENOMEM;
 	}
 
-	cbd.addr[0] = lower_32_bits(dma);
-	cbd.addr[1] = upper_32_bits(dma);
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
 	eth_broadcast_addr(si_data->dmac);
-	si_data->vid_vidm_tg =
-		cpu_to_le16(ENETC_CBDR_SID_VID_MASK
-			    + ((0x3 << 14) | ENETC_CBDR_SID_VIDM));
+	si_data->vid_vidm_tg = (ENETC_CBDR_SID_VID_MASK
+			       + ((0x3 << 14) | ENETC_CBDR_SID_VIDM));
 
 	si_conf = &cbd.sid_set;
 	/* Only one port supported for one entry, set itself */
-	si_conf->iports = 1 << enetc_get_port(priv);
+	si_conf->iports = cpu_to_le32(1 << enetc_get_port(priv));
 	si_conf->id_type = 1;
 	si_conf->oui[2] = 0x0;
 	si_conf->oui[1] = 0x80;
@@ -540,7 +539,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	si_conf->en = 0x80;
 	si_conf->stream_handle = cpu_to_le32(sid->handle);
-	si_conf->iports = 1 << enetc_get_port(priv);
+	si_conf->iports = cpu_to_le32(1 << enetc_get_port(priv));
 	si_conf->id_type = sid->filtertype;
 	si_conf->oui[2] = 0x0;
 	si_conf->oui[1] = 0x80;
@@ -550,8 +549,8 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	cbd.length = cpu_to_le16(data_size);
 
-	cbd.addr[0] = lower_32_bits(dma);
-	cbd.addr[1] = upper_32_bits(dma);
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
 
 	/* VIDM default to be 1.
 	 * VID Match. If set (b1) then the VID must match, otherwise
@@ -560,16 +559,14 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	 */
 	if (si_conf->id_type == STREAMID_TYPE_NULL) {
 		ether_addr_copy(si_data->dmac, sid->dst_mac);
-		si_data->vid_vidm_tg =
-		cpu_to_le16((sid->vid & ENETC_CBDR_SID_VID_MASK) +
-			    ((((u16)(sid->tagged) & 0x3) << 14)
-			     | ENETC_CBDR_SID_VIDM));
+		si_data->vid_vidm_tg = (sid->vid & ENETC_CBDR_SID_VID_MASK) +
+				       ((((u16)(sid->tagged) & 0x3) << 14)
+				       | ENETC_CBDR_SID_VIDM);
 	} else if (si_conf->id_type == STREAMID_TYPE_SMAC) {
 		ether_addr_copy(si_data->smac, sid->src_mac);
-		si_data->vid_vidm_tg =
-		cpu_to_le16((sid->vid & ENETC_CBDR_SID_VID_MASK) +
-			    ((((u16)(sid->tagged) & 0x3) << 14)
-			     | ENETC_CBDR_SID_VIDM));
+		si_data->vid_vidm_tg = (sid->vid & ENETC_CBDR_SID_VID_MASK) +
+				       ((((u16)(sid->tagged) & 0x3) << 14)
+				       | ENETC_CBDR_SID_VIDM);
 	}
 
 	err = enetc_send_cmd(priv->si, &cbd);
@@ -604,7 +601,7 @@ static int enetc_streamfilter_hw_set(struct enetc_ndev_priv *priv,
 	}
 
 	sfi_config->sg_inst_table_index = cpu_to_le16(sfi->gate_id);
-	sfi_config->input_ports = 1 << enetc_get_port(priv);
+	sfi_config->input_ports = cpu_to_le32(1 << enetc_get_port(priv));
 
 	/* The priority value which may be matched against the
 	 * frame’s priority value to determine a match for this entry.
@@ -658,8 +655,8 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 		err = -ENOMEM;
 		goto exit;
 	}
-	cbd.addr[0] = lower_32_bits(dma);
-	cbd.addr[1] = upper_32_bits(dma);
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
 
 	cbd.length = cpu_to_le16(data_size);
 
@@ -667,28 +664,25 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 	if (err)
 		goto exit;
 
-	cnt->matching_frames_count =
-			((u64)le32_to_cpu(data_buf->matchh) << 32)
-			+ data_buf->matchl;
+	cnt->matching_frames_count = ((u64)data_buf->matchh << 32) +
+				     data_buf->matchl;
 
-	cnt->not_passing_sdu_count =
-			((u64)le32_to_cpu(data_buf->msdu_droph) << 32)
-			+ data_buf->msdu_dropl;
+	cnt->not_passing_sdu_count = ((u64)data_buf->msdu_droph << 32) +
+				     data_buf->msdu_dropl;
 
 	cnt->passing_sdu_count = cnt->matching_frames_count
 				- cnt->not_passing_sdu_count;
 
 	cnt->not_passing_frames_count =
-		((u64)le32_to_cpu(data_buf->stream_gate_droph) << 32)
-		+ le32_to_cpu(data_buf->stream_gate_dropl);
+				((u64)data_buf->stream_gate_droph << 32) +
+				data_buf->stream_gate_dropl;
 
-	cnt->passing_frames_count = cnt->matching_frames_count
-				- cnt->not_passing_sdu_count
-				- cnt->not_passing_frames_count;
+	cnt->passing_frames_count = cnt->matching_frames_count -
+				    cnt->not_passing_sdu_count -
+				    cnt->not_passing_frames_count;
 
-	cnt->red_frames_count =
-		((u64)le32_to_cpu(data_buf->flow_meter_droph) << 32)
-		+ le32_to_cpu(data_buf->flow_meter_dropl);
+	cnt->red_frames_count =	((u64)data_buf->flow_meter_droph << 32)	+
+				data_buf->flow_meter_dropl;
 
 exit:
 	kfree(data_buf);
@@ -795,15 +789,15 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 		return -ENOMEM;
 	}
 
-	cbd.addr[0] = lower_32_bits(dma);
-	cbd.addr[1] = upper_32_bits(dma);
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
 
 	sgce = &sgcl_data->sgcl[0];
 
 	sgcl_config->agtst = 0x80;
 
-	sgcl_data->ct = cpu_to_le32(sgi->cycletime);
-	sgcl_data->cte = cpu_to_le32(sgi->cycletimext);
+	sgcl_data->ct = sgi->cycletime;
+	sgcl_data->cte = sgi->cycletimext;
 
 	if (sgi->init_ipv >= 0)
 		sgcl_config->aipv = (sgi->init_ipv & 0x7) | 0x8;
@@ -825,7 +819,7 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 			to->msdu[2] = (from->maxoctets >> 16) & 0xFF;
 		}
 
-		to->interval = cpu_to_le32(from->interval);
+		to->interval = from->interval;
 	}
 
 	/* If basetime is less than now, calculate start time */
@@ -837,15 +831,15 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 		err = get_start_ns(now, sgi->cycletime, &start);
 		if (err)
 			goto exit;
-		sgcl_data->btl = cpu_to_le32(lower_32_bits(start));
-		sgcl_data->bth = cpu_to_le32(upper_32_bits(start));
+		sgcl_data->btl = lower_32_bits(start);
+		sgcl_data->bth = upper_32_bits(start);
 	} else {
 		u32 hi, lo;
 
 		hi = upper_32_bits(sgi->basetime);
 		lo = lower_32_bits(sgi->basetime);
-		sgcl_data->bth = cpu_to_le32(hi);
-		sgcl_data->btl = cpu_to_le32(lo);
+		sgcl_data->bth = hi;
+		sgcl_data->btl = lo;
 	}
 
 	err = enetc_send_cmd(priv->si, &cbd);
-- 
2.17.1

