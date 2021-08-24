Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5843F6650
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhHXRWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:22:31 -0400
Received: from mail-eopbgr10043.outbound.protection.outlook.com ([40.107.1.43]:11494
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240156AbhHXRU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:20:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=boKb34qFCPEGh1Dm5cgHHC3mJdd+TaNol9x3EGOST88i/gOqcUvzggRHK6ZG0pLZUYWjdM2YmBNPb2zE8B2qgHJMDdsKmkw1VXFszXh6sjAPGRvXfduw1F2tUVpnN7l9AnxvPq0GbRdLgxQ4+FBfOkHcTOhvx0GgN77C46Ll7qJnGm8BaiUGeek2WPo6T+lVS+L+XibKfBSoP6cNV8NG/kZnB+ljM+CZrxhdnT5m5oPFVVZFoicnjfsRrG0LqqsdeMvpbbtv0kq3qwDRyNRcASRvNTVXMAdNlCJ07E9OGgT6GAXN/QqI0NVXwASzKYhK+lg17XbOsu/vNhI48E5e8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwDfFCyy6ghlTIUTr4LksXmDoj3fZF8r+tUbLm+jQ5M=;
 b=dAe9kHSQkSqaNGxeabBAjg0PtVWccZB7aLrILVMCEw9/Ekh+1pnUwsrm30OKyaFtb1pBAjv7m+nyivP0o4xIWCX8zGmEUvlrQ74GWdPMnojo24SEo7TaMXY+hfSQkaboo+KvSr8Lb+Iieilnx/PieZEQcS111aBaReHdn9CCmd680wb1xBZpWsEahFYyuwZ+aKEllm6cGjW5go0LBfOi/IlZ3URylVtSC7nfGlR2gwT79JMWmOn8aX0Q9zYsU/A7dD59QXv+iq/60x3vywu6UbTDd/jv3l0XsrWQZ1JuwkScM/CsQuGxKvcVOL3k+HWqASTDoJiFErfbdBv82fKuQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwDfFCyy6ghlTIUTr4LksXmDoj3fZF8r+tUbLm+jQ5M=;
 b=TbzGkshanr+ZI7nkD6zy7Sr9F1NDqdbLruY9auCLJFWEgVcVkdvedzcZi9JObPnQfIPRtNFCOWGgBWh/uh03J4+iFAAc+6gTZrxdnXYzl15Cqv0QvLeuCK0Js8as/sOz9XYVN1RSPIPZfKhpryyQUcKn4qzw68Rg04ZbPZhMzCk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 17:18:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 17:18:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: tag_sja1105: stop asking the sja1105 driver in sja1105_xmit_tpid
Date:   Tue, 24 Aug 2021 20:15:02 +0300
Message-Id: <20210824171502.4122088-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824171502.4122088-1-vladimir.oltean@nxp.com>
References: <20210824171502.4122088-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P195CA0024.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM9P195CA0024.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 17:18:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50145e67-afed-4997-e5aa-08d967232592
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-Microsoft-Antispam-PRVS: <VI1PR04MB422222914FBC099ADE082B46E0C59@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6U+tSrcgm1FdQCB2WFonxnrY6775MbH+Qi/yShUelYJtXS5+ehmqIBH7XFH91jG8umbCwNqIx1Rjeva0OCxK59O7x2SK+UJgP0dS/GyJKEuVCbLx1pwJS688rgkTUePg8ojEkEmyEzMsZHVq9VX5xhToZzCe6hopaZz3llgSBx9/0DIe72OhLjQvOJNtCOtxkx1Bct6ZmiUtecZMS6swKGGljpU9l8P3dMctOXsyn/dH9VJgFUNSXV33We/Wi9ULcjepj+VhRBoIbtmB2xNJ1WzuJn6BpcDrX4AhsD7xQ7cvgwtegqCfTqpubhQsSOF8MiHwPd7Xau8lIBwDzmHOpc+NpVWUybJqidwfbL9NoxIfEsEf/ZZNHAJuxjEEJ/MRwFvzOy6UZZ0pZUzErAXc27RER+IhMb91zqn6DBENUpZC2HhC+nlG9o68A5skP7QFVlIoiCGX5EuWgeP7rUkT6FTgc3qPPSSBWgQjCe081A8mGgxTOKyhPil0xcdPlv2zU5E8tQGnf/gIbZzkZsL1pkVcibKlqgT0VU9ldFSnGZ1XKaqPlN1OhOOYnrrfHV36UhnmjknHHGzZtESCZHvQmFrFanqsGNSInFVyhHsU1X1oJNzYuIlTyaXK9gMawqkpq5vmIF0E6ZRLWnvSyIImdaoMO7JHra8AsCoZtwzmJmCj/LTWTG1u9Mb7HaLE8fcWBveVEfh1rO06XySBTYBlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(6486002)(66476007)(36756003)(6506007)(478600001)(66556008)(6666004)(2906002)(52116002)(86362001)(66946007)(44832011)(6512007)(26005)(83380400001)(2616005)(956004)(186003)(38350700002)(38100700002)(6916009)(4326008)(316002)(54906003)(1076003)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r6lORRASFuzdoYquyy9Fod1j9Rzrxbi56dlDYYZ0zBKeYEbV8wdCIlCsP2tN?=
 =?us-ascii?Q?kGZClGVFCyhV2ZPtrg0Lq3LxNJm7USoO0HhGEBbSNSlc3A6B8pavFPrtCWNa?=
 =?us-ascii?Q?o6DrWHyBa72KC9868PoR+z8cGcFPXS+OmzwL1mC0atyvyKKsS6dtSgsPuQ2Q?=
 =?us-ascii?Q?qKXOIKrw812VaLgjZK2seAAozA59dRAr6Zj7U3wAOV2ajRwtlFcC2JlRb/ap?=
 =?us-ascii?Q?Bcvn2ez0VVuNcloH8DufHVYuReGlUhsKxuVYME0zmvWx3avIQltKVsEXu7ai?=
 =?us-ascii?Q?UN6V92NZQLzttFrD0Zq6Pvj4oMMgJmwDEfFgP6jCotm8kFeQkegD4fZyuRQx?=
 =?us-ascii?Q?sqeseA2ab9uBEsNmzyST0j1RXdJW/5cLBea+Is0kc8Zm3+Z4nXswfodBD+WG?=
 =?us-ascii?Q?kqGAJCrkbX7ad+hfOxhZ2RvSj3YT1Vh4ZBhXre21qio0nAdxFCjUeQQfhryn?=
 =?us-ascii?Q?h31kRptFbZYtLIXIIng4vD/pFMG2RALqRFng5WaCGf81dYQiGUNAfG9XgQjn?=
 =?us-ascii?Q?F1YPrYHR3HAiPuTPOKbZDuEUaDQXwyOb3HlFokNPc8NKwnnYqyviTxEz7L2/?=
 =?us-ascii?Q?TiOxkO3elxT+8dlyRJBna5jsorF4XUDvdV3YiRK1I4WN4HMsjtwAxqWigOxy?=
 =?us-ascii?Q?NX6MnqfEIwTZfVKWsVZ11BIqYlPlZ3iCtgWHEitG7Ind6Y2KLcNiCfoKnU+N?=
 =?us-ascii?Q?Yrtz3wYIWIfwNKXr4dgtJ2Hobaw8W9IWfavN+HYU5Wsf5mpb6/COzgjtEBdT?=
 =?us-ascii?Q?RV+L8LOzxgNNI8BQIDwX6OFuxWG5lAXSTTB8cPExO4OTbaU2t7ubfDky1tEn?=
 =?us-ascii?Q?X6eSOT6yI0xq/Y8tddCDl0ooJQqKgrupZBhNYIFa3zh2j4xUXwLGymBixVGL?=
 =?us-ascii?Q?UK0P3NNmqXFs1nWU1oRV0xtWtqpCJWcAkl5U6rdOw61aJE9Y2d2Jl3yw6l7v?=
 =?us-ascii?Q?XLjWvSRunrWLO5RO5q5/7g/5UC6NOtO/lBZz9wx74cPbXI8xZng3My2/dH0z?=
 =?us-ascii?Q?dJFMzmjqHSBc3nXRkO2QDwDZByYF2eBDJDM0q1k2oUx686RI6ECXfGWpqRyb?=
 =?us-ascii?Q?DWnBEVY10h0MXd7ZEzZkMn0mQhCtMRu3hlT856d+b4aKLAkQJAJ2bI2GapUd?=
 =?us-ascii?Q?2rhZa/5U5GeTxGoNr+Sut8rNKb2PCTTVs9gQDryp1BGqrogiak7/8cvXaU63?=
 =?us-ascii?Q?F+AkEnN6Zysv0sEb25XZRizUNRez2LoFtQCxjVFc9x2eAUGOL/ab+O5/bf1z?=
 =?us-ascii?Q?iO6vBB+Fxzfiqmu/VISgGxSG/AeVIbOkl8O/+02sbWVk1dD+xq1QXn2mpVlZ?=
 =?us-ascii?Q?qtpCGrMrEHFtoDfNqEm7jUYP?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50145e67-afed-4997-e5aa-08d967232592
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 17:18:10.2865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7FhaQTjkeyW2NU6V4J/4umggh5Ds3TApJwdrANsdV1i6b3ER2+CQXSZcGhH8ANz+Y0gFCu0zB59HI/BxwxXng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduced in commit 38b5beeae7a4 ("net: dsa: sja1105: prepare tagger
for handling DSA tags and VLAN simultaneously"), the sja1105_xmit_tpid
function solved quite a different problem than our needs are now.

Then, we used best-effort VLAN filtering and we were using the xmit_tpid
to tunnel packets coming from an 8021q upper through the TX VLAN allocated
by tag_8021q to that egress port. The need for a different VLAN protocol
depending on switch revision came from the fact that this in itself was
more of a hack to trick the hardware into accepting tunneled VLANs in
the first place.

Right now, we deny 8021q uppers (see sja1105_prechangeupper). Even if we
supported them again, we would not do that using the same method of
{tunneling the VLAN on egress, retagging the VLAN on ingress} that we
had in the best-effort VLAN filtering mode. It seems rather simpler that
we just allocate a VLAN in the VLAN table that is simply not used by the
bridge at all, or by any other port.

Anyway, I have 2 gripes with the current sja1105_xmit_tpid:

1. When sending packets on behalf of a VLAN-aware bridge (with the new
   TX forwarding offload framework) plus untagged (with the tag_8021q
   VLAN added by the tagger) packets, we can see that on SJA1105P/Q/R/S
   and later (which have a qinq_tpid of ETH_P_8021AD), some packets sent
   through the DSA master have a VLAN protocol of 0x8100 and others of
   0x88a8. This is strange and there is no reason for it now. If we have
   a bridge and are therefore forced to send using that bridge's TPID,
   we can as well blend with that bridge's VLAN protocol for all packets.

2. The sja1105_xmit_tpid introduces a dependency on the sja1105 driver,
   because it looks inside dp->priv. It is desirable to keep as much
   separation between taggers and switch drivers as possible. Now it
   doesn't do that anymore.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  6 ----
 drivers/net/dsa/sja1105/sja1105_main.c | 10 -------
 drivers/net/dsa/sja1105/sja1105_spi.c  | 10 -------
 include/linux/dsa/sja1105.h            |  1 -
 net/dsa/tag_sja1105.c                  | 38 +++++++++++++++++++++++---
 5 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 2e899c9f036d..5e5d24e7c02b 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -115,12 +115,6 @@ struct sja1105_info {
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
-	/* Both E/T and P/Q/R/S have quirks when it comes to popping the S-Tag
-	 * from double-tagged frames. E/T will pop it only when it's equal to
-	 * TPID from the General Parameters Table, while P/Q/R/S will only
-	 * pop it when it's equal to TPID2.
-	 */
-	u16 qinq_tpid;
 	bool can_limit_mcast_flood;
 	int (*reset_cmd)(struct dsa_switch *ds);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 976f06462223..2f8cc6686c38 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2295,15 +2295,6 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 		tpid2 = ETH_P_SJA1105;
 	}
 
-	for (port = 0; port < ds->num_ports; port++) {
-		struct sja1105_port *sp = &priv->ports[port];
-
-		if (enabled)
-			sp->xmit_tpid = priv->info->qinq_tpid;
-		else
-			sp->xmit_tpid = ETH_P_SJA1105;
-	}
-
 	if (priv->vlan_aware == enabled)
 		return 0;
 
@@ -2988,7 +2979,6 @@ static int sja1105_setup_ports(struct sja1105_private *priv)
 		}
 		sp->xmit_worker = worker;
 		skb_queue_head_init(&sp->xmit_queue);
-		sp->xmit_tpid = ETH_P_SJA1105;
 	}
 
 	return 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 08cc5dbf2fa6..d60a530d0272 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -575,7 +575,6 @@ const struct sja1105_info sja1105e_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105e_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
-	.qinq_tpid		= ETH_P_8021Q,
 	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= false,
 	.ptp_ts_bits		= 24,
@@ -608,7 +607,6 @@ const struct sja1105_info sja1105t_info = {
 	.part_no		= SJA1105ET_PART_NO,
 	.static_ops		= sja1105t_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
-	.qinq_tpid		= ETH_P_8021Q,
 	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= false,
 	.ptp_ts_bits		= 24,
@@ -641,7 +639,6 @@ const struct sja1105_info sja1105p_info = {
 	.part_no		= SJA1105P_PART_NO,
 	.static_ops		= sja1105p_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
-	.qinq_tpid		= ETH_P_8021AD,
 	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
@@ -675,7 +672,6 @@ const struct sja1105_info sja1105q_info = {
 	.part_no		= SJA1105Q_PART_NO,
 	.static_ops		= sja1105q_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
-	.qinq_tpid		= ETH_P_8021AD,
 	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
@@ -709,7 +705,6 @@ const struct sja1105_info sja1105r_info = {
 	.part_no		= SJA1105R_PART_NO,
 	.static_ops		= sja1105r_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
-	.qinq_tpid		= ETH_P_8021AD,
 	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
@@ -747,7 +742,6 @@ const struct sja1105_info sja1105s_info = {
 	.static_ops		= sja1105s_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.regs			= &sja1105pqrs_regs,
-	.qinq_tpid		= ETH_P_8021AD,
 	.tag_proto		= DSA_TAG_PROTO_SJA1105,
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
@@ -784,7 +778,6 @@ const struct sja1105_info sja1110a_info = {
 	.static_ops		= sja1110_table_ops,
 	.dyn_ops		= sja1110_dyn_ops,
 	.regs			= &sja1110_regs,
-	.qinq_tpid		= ETH_P_8021AD,
 	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
@@ -835,7 +828,6 @@ const struct sja1105_info sja1110b_info = {
 	.static_ops		= sja1110_table_ops,
 	.dyn_ops		= sja1110_dyn_ops,
 	.regs			= &sja1110_regs,
-	.qinq_tpid		= ETH_P_8021AD,
 	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
@@ -886,7 +878,6 @@ const struct sja1105_info sja1110c_info = {
 	.static_ops		= sja1110_table_ops,
 	.dyn_ops		= sja1110_dyn_ops,
 	.regs			= &sja1110_regs,
-	.qinq_tpid		= ETH_P_8021AD,
 	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
@@ -937,7 +928,6 @@ const struct sja1105_info sja1110d_info = {
 	.static_ops		= sja1110_table_ops,
 	.dyn_ops		= sja1110_dyn_ops,
 	.regs			= &sja1110_regs,
-	.qinq_tpid		= ETH_P_8021AD,
 	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 8c5601f1c979..171106202fe5 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -67,7 +67,6 @@ struct sja1105_port {
 	struct sja1105_tagger_data *data;
 	struct dsa_port *dp;
 	bool hwts_tx_en;
-	u16 xmit_tpid;
 };
 
 enum sja1110_meta_tstamp {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index a49308fbd19f..c054f48541c8 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -133,14 +133,44 @@ static struct sk_buff *sja1105_defer_xmit(struct dsa_port *dp,
 	return NULL;
 }
 
+/* Send VLAN tags with a TPID that blends in with whatever VLAN protocol a
+ * bridge spanning ports of this switch might have.
+ */
 static u16 sja1105_xmit_tpid(struct dsa_port *dp)
 {
-	struct sja1105_port *sp = dp->priv;
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_port *other_dp;
+	u16 proto;
+
+	/* Since VLAN awareness is global, then if this port is VLAN-unaware,
+	 * all ports are. Use the VLAN-unaware TPID used for tag_8021q.
+	 */
+	if (!dsa_port_is_vlan_filtering(dp))
+		return ETH_P_SJA1105;
+
+	/* Port is VLAN-aware, so there is a bridge somewhere (a single one,
+	 * we're sure about that). It may not be on this port though, so we
+	 * need to find it.
+	 */
+	list_for_each_entry(other_dp, &ds->dst->ports, list) {
+		if (other_dp->ds != ds)
+			continue;
+
+		if (!other_dp->bridge_dev)
+			continue;
+
+		/* Error is returned only if CONFIG_BRIDGE_VLAN_FILTERING,
+		 * which seems pointless to handle, as our port cannot become
+		 * VLAN-aware in that case.
+		 */
+		br_vlan_get_proto(other_dp->bridge_dev, &proto);
+
+		return proto;
+	}
 
-	if (unlikely(!dsa_port_is_sja1105(dp)))
-		return ETH_P_8021Q;
+	WARN_ONCE(1, "Port is VLAN-aware but cannot find associated bridge!\n");
 
-	return sp->xmit_tpid;
+	return ETH_P_SJA1105;
 }
 
 static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
-- 
2.25.1

