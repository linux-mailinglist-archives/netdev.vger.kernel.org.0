Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81732B6D2D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgKQSUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:20:30 -0500
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:10111
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730534AbgKQSU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 13:20:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIsyonGYJ/hQWFQbedmoweNUEbynbINGHabVs7AFcIkXELn/AQr7dzMcnxNF0O1A0lgACxto0J4WNtHiT1rWj+SVqC33dkvznZqSNLdYQSQB6smom0fjrcKtb0jQjvj6QSZ0BDhjJI1I56fuaJ6K7X7HLpvSXN8egNVJwQZISRDWa8H2h0p8qNPNAl/M2WhCpHIhCl8Fos6xnH/u3vUhoxQlJRWVdxcRvuId4yG/iwXP3tFBgkiVcbRbageq7ymZ8F0ZI1Xa0Xq6B1ERT4RqLdTID3tK1Mj9ohTiEQeHWYh4BGy+d82iC5MRsbuRdjGiPdWvVEvx6GVxAVjocjks9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdPAf3n8PeyFg3ZRGsz0tqVEClHxRlH9KkZzhyIaYyE=;
 b=i+m/UNljhCvRSovW4x1l90s6XTh0wysNsrR73eMz5ZD351Yyn5LsQOXD7v8i8YYOZo6ci3aBGuLnC7GjVsYIunuUseoIxcgW2yRsBa34us5+tvhKrQHylVQylzlXVQ4BOXIMcZ8EPufwT3Jy3i4cVMJpLhMgZMhW7JWJ+b0e0sKNyoukZIyPavY1ZuJnHq+dwZrEUdflx/O33o6cb7JMnKtYaQmMs9A7S2/krL6Z2kj8ld9ECaOW+Dzt+qO6b0i13ofr6VP5Bxdxe7ay+9xXKA46vcrmsvV7JzoXh3hcJIE4Zq81NO86Wysb0bwhsK6bvQxplIRZjTM2JPixh+hiHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdPAf3n8PeyFg3ZRGsz0tqVEClHxRlH9KkZzhyIaYyE=;
 b=oFwod9TpT+RR89TykQ5X2uk5f39E8IxpKn+F2zpPAY+pvStyYS/NkycTcke8wuFFhFN5CVtG09PeCpzqaT2AHsMlg5q9x9Hxp5I2q9IwVI4SmeYxgzjfFFsdu69IJqFFFS6knAx8bAFBpwp+FsrslLARZceCXVZhvlSubU+73i8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM8PR04MB7473.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 17 Nov
 2020 18:20:21 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3564.030; Tue, 17 Nov 2020
 18:20:21 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/2] enetc: Fix endianness issues for enetc_qos
Date:   Tue, 17 Nov 2020 20:20:04 +0200
Message-Id: <20201117182004.27389-3-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117182004.27389-1-claudiu.manoil@nxp.com>
References: <20201117182004.27389-1-claudiu.manoil@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM4PR07CA0022.eurprd07.prod.outlook.com
 (2603:10a6:205:1::35) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR07CA0022.eurprd07.prod.outlook.com (2603:10a6:205:1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 18:20:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 297103c5-4ea7-4b96-814b-08d88b2571c7
X-MS-TrafficTypeDiagnostic: AM8PR04MB7473:
X-Microsoft-Antispam-PRVS: <AM8PR04MB747399B37B7F1EB677C8EA2D96E20@AM8PR04MB7473.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9RzPv4UGp9sNLubxbCSsVkX58AIcVKFyCYXURpv03dKHuIBQMDVDLyEwZz8JHjz72Ni5nNOddjJ26cuWDf+kMGS8vm7ADU0XFO1awWzx3pAEThlVDCUP5sq2LQ5dTjkhfWR+oy5AeLGA/2apIvnqLFjYtbUcquRLFhER7eI8IX/I09anfuOZyKWXq004qY5VTVr2Lsx7nxIR958RK1h+XLeWIHsP6rG6kU76jbaDex/yEC4e5Q2EejaQzv6Ch+vGN4bI+5frcVbc/5chGbAtXKXtcbBCgQJ5nEyYZ0zOaYpxbHPLGvoHvC9OZZC5Gc/5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39850400004)(136003)(366004)(54906003)(478600001)(66946007)(66556008)(66476007)(44832011)(2616005)(26005)(956004)(7696005)(52116002)(6916009)(36756003)(2906002)(6666004)(86362001)(16526019)(4326008)(83380400001)(316002)(8936002)(1076003)(5660300002)(186003)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lTrEdJ5O6jnQg6SmyHb3+jF+bTl78MR756xpdPbwNiUHIFuQmW1Lms/GwoF49mCNK2AqFRHAAqm43auSGstP5SsjDNs9JQLkRJOaGRanVOnkLAfod5v1oSs6mVFzvHPgFM9VKDrX8Wa52MYtiZni9zv780GHq5ayUWZTdYr1WpagxREeMd96M3U6f6ciwb0S5FiFUSAzP6JkHA3WbwyuOHrbzVIFAaL1IDhx8wUM5yu3gY1xD+nTkiiRAdRCO4TWNHtRUsl8e6eJUdHvH8xT/IU/n64ySQNisuiTJor4wONJIXluULZmc9A/XkSU2nKy3DHGsFUmNXseQrjnMiyLXem5DlEfLnsFhFK1vty0dFFvWKoRUjoxN7gqN5fptD11+8IbCU/uRjy1H/Xj6PnOG5Hft4jBbn8rrBcLbrjczv0gqEMGRv3efNv4py4KlMJm3n1IY/37QttfhTA1CBIGno9EH8GFF5iV9DT/0HIaUtFQbFvWR0tru8b1c2fPOJeeueDkaeUHxAxcFOnnqJbIsQAShyTJGwL4wJ4wlX8lojaQah86vMUBKzZy2AGEcz4ykcCXCClhfgVM4lCY9JvGzbAG7NsiSgIWBM75Svlc6iadQxmOzfS3BJpsR+VTZRKUahcBCmm1ojoakmi11KeLQw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 297103c5-4ea7-4b96-814b-08d88b2571c7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 18:20:21.3905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q3So0LED+uoiQTVMqHlv5Bn1M2293PCNdWRRdAk9DWAy9obu3LNR/eu2WeqMMId9bBaCGPkkPsqedKxGFYN8Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7473
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

