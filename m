Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6054E5E7EDF
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiIWPrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIWPqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:51 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35E6B9B;
        Fri, 23 Sep 2022 08:46:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7wZJllCccbgvhcC47xC/o/Rhiflx9ifWbT9JYh5zTe3p0817zsEwIIY7KuqXQqT2AMkUr3DOeAPKbyD69PnKIsuccffsNt6xZHjXubU1siGJcf0jYxkIExu/xQbBm3iK05TP6RaoGZa8uqVwWmp6lwMBdBY+aC2n55sx+qjY9adugqZIvfPhmOL/xy2RUKQyGnlZC2Y8C3jR2WWLWP5VMsd+8IkTgoLsKfEWT6ikLzF7SnRiCIaNY1iHxs3ja1F95eblMBZT4HDu+7DbNDln66j0jiz+gW+l+Nncj7DinPOs7xpBR1rz/XsfrU5PVqoE/7LTObwOiYKeWxtec3UWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQlg0GNxhAlw2+YJphOGYJj4HZ9HHgrPznZnlXhCY7M=;
 b=WUTrWo32A/OxxrM+S2FDuDcCET1JrtG53KxrRJoqfSxYvF3PG/SdOAR93sVQUsFZDgZJ7tLesm0Y8xja2OGs1zbUpOeLPwndB8ru5TuLiG/GMfyLjb2txFlnAaaHaUYBYddlBh5PC8IVTe/11qzO5epERBQ1otJjwC12i7E6yIIS7l6b+M2jQu8nXblLpKmigoHg1hoNzJ5iRaz4fYX2sZFkhmZgxCK1Veol5AWiHNiN4/JVTn2NrISFXG19QX4DQ/RkpwDqroWE/8rUJQ990C4gDPccK3gT5ytURN/97Amak82uo8iAtxYIqWM8oKsnUhnQfZN2bVZ486PscFtMdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQlg0GNxhAlw2+YJphOGYJj4HZ9HHgrPznZnlXhCY7M=;
 b=UaY7mAOCGWLRC6f9dzPT4Y6X5EG3hfMo7G1vAsZ70jbTebF/YqE/y9KCs7b6LSg/wkJPA8w37vMkrI75Qv6S8ybW3aT9gHDhsTiBiztYX/tMQdoc3HBrWT5GnEDuBUIAS2zzxAecBFpRGeG2g29WGXE1m5ZKTlAVcO+iwCivE3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8996.eurprd04.prod.outlook.com (2603:10a6:20b:42f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:43 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:43 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 04/12] net: dpaa2-eth: export the CH#<index> in the 'ch_stats' debug file
Date:   Fri, 23 Sep 2022 18:45:48 +0300
Message-Id: <20220923154556.721511-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923154556.721511-1-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8996:EE_
X-MS-Office365-Filtering-Correlation-Id: c62ca720-0f5a-4555-d255-08da9d7ad07b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dgsnjLXENgwmmqEULjdKgTNC02G811SkpI9ap0BE6Fs9wi4i5PqUaeYxBypVf/c2wRdqkZif29fmHYZk62gIlFKCbXlmuAXd59o8gHFYNragJrA9cXNtenXdfVEKCisEOzM0syE3IUCd25Ac8bj9D196GSl78SY0hCqF3GcKDMw/AgwjrWU22Ymm3KD6QRquodMP85N9XDuScobRC7kodf4I/+RMMLUewdZND9RaYU2a+NqrTexpjigYev+1oN1b+GF2xWJawEPVP12gUMHvgyr5YA3AMf6ug/BGk2U65bmMoEriw/zJpTxyDdei/drBS4/j72NHmNKFq68LsFwIsSv+1lX/2YvU3oCsCGcsPO4qBuodyYTT6/c0aDTjArfLIs6MLq/Qdm6tyro2BMprR57WZNKZ3yhZd7qeo7CslHQishnuU+jsJzB32rRzaZitG0duQACm1Ur6hi3WoH5C3Du/MsfNma2ULUH4h2z6P1PxS9xyQyxsjgm++SGgu0TstGXltronkO94mbrmxIuS7po2ocPZVT2Dp6aUxDKWlR2ttCbU5t7Wm3ZhXuasI6LtIFZ6kG5YkzTgl21cw5nyRtmdDEbnRAecQebP5qRUU7gw1tLjjtrbDtkmqZqY4Do27xUxhTsSsvu9D09eRAsoBEtp3QRfWuxt3T37TcR1sthJL5A3j6JJqxeGaQaKfary2JSblkv6OoiiH+Pc8ZZTHT0g9rAr/3NozowixcKEPjY8fuHF2jF2Od73SMh1l4gWBIBZMmNXesOTPeshU70RhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(6486002)(36756003)(316002)(54906003)(2616005)(4326008)(38350700002)(1076003)(38100700002)(6512007)(26005)(86362001)(52116002)(66476007)(110136005)(186003)(6506007)(83380400001)(66946007)(2906002)(66556008)(478600001)(8676002)(41300700001)(5660300002)(44832011)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IyuVvSJkd5oNneAENvTiJQRtzdB4DIkT/gY0LuYSuMPo90IBk+tREOW6GNYh?=
 =?us-ascii?Q?r1jC/5jDq9COeaVPuwik0PatKpUYcEitOZx6nWJbrTK+shgYrmzV7j5TfHya?=
 =?us-ascii?Q?AZhyHSvThQbrh/W4LPOwe0jPkPDuGOuTWJMhzlv8rOMCLbFO+YplvOtmk+15?=
 =?us-ascii?Q?DOfgHw86pmKqvXmJSMG4ovGHEIwt/jXrrxcM+vZFV2aijJrNqq4obualR4RO?=
 =?us-ascii?Q?fo5igohoFntuaEvZAorlPPbLjGAcxE8vDM0/j1c4HEAoBg0QzKGDYggmmu1Q?=
 =?us-ascii?Q?nxVHJNUnun3UasZXEl+loofJubsJzHMelICKe62gBsGwufeIYJAgfKO79/dg?=
 =?us-ascii?Q?bMFe+r0eOiPbF/XNRsFQMC/AyteuWR88KDvZnei9QDkOIyu3TurAfVDRYwnj?=
 =?us-ascii?Q?0qHS0z/dXAPtEnjIpwbuVITv7Yz11w7xZp+44Q9k2D5jEPCkKoU/ZcKGJxFU?=
 =?us-ascii?Q?H/vggr5oBJkzxpYiZ6symndLeg+RwRFwcG27uPEXB9ROJV8GqxW3K9w+dhAw?=
 =?us-ascii?Q?Ee4AmW9IzmXQKKKCfYuilDEHWxUmKQDLqNuPruTVfRdC8TQtCKcU4aaqakkX?=
 =?us-ascii?Q?mLbraFvyDOzAQ6MTIeN1YGbgDXltfBaJN9uoSFty2SZzPMCzwDUIlTtEgQMX?=
 =?us-ascii?Q?1L9tUsV6gMaCXWa0h91PceMpsV7VCqFmIWOj2+9BQHbGX1piI9IN75pBQJOJ?=
 =?us-ascii?Q?geQcu1hP0n1DrhAhGHz1A+QudoL2haO8MLsO+4ndwOkGgxJmD0R6ztEhdd17?=
 =?us-ascii?Q?Hdnhsr/lwWk6GHemOI4vBx0+IVa0qmGOFxkLHZhdv0DfRwyp/VxIUz6lXHio?=
 =?us-ascii?Q?Y4JxgU8z2anAbI8Gm1LH2Pc/m21cwEqp5RJieptUQe9O8BW4oCdpRC4RSzo3?=
 =?us-ascii?Q?ytqmpV5XIvhSEsiCwFUB6XlK2O4xqhSRRg1qgZBvfqbi/mOMv/4e4mocXFeu?=
 =?us-ascii?Q?tjv+dhkBqa+tYPjDYuBe4V5GVs7DrnbgU1EZwL5zmG+wbcbfmSI1B8o+PEk/?=
 =?us-ascii?Q?FVhGjNax/QVxV5t4cJuf5mun0FWfgTtRO+SM/6Uv52zR4JvEXnobMofyHAE0?=
 =?us-ascii?Q?V/ObBaSJNDsUmk9wseIDAZ57X3Cx+u9UOFlw5auoRPLwWCRqJ34j0G/FdM+y?=
 =?us-ascii?Q?3il6L7UX9x3BOYpX2sMDBTmI3PAK52SPsGqYbELacVXfve2m+pdsHhmG/cMI?=
 =?us-ascii?Q?DeFU0pVdbzJnWf1o/KdJn1KrEsBROk6mYSN2Pnj8PkGuqSIzIbXRyb0ZRiwg?=
 =?us-ascii?Q?7BoC/WG5SjrwwfzKUGM9LCiIGzTAE9cGWA0+Pe3q4URl2bekbx4Um5APWioE?=
 =?us-ascii?Q?J3HBmEbt4BOLJKXQxSPl1taB0fDcyBw0x6mnl/x4Wch6iE59jEUPslW6GtAg?=
 =?us-ascii?Q?wNemx7RhEIZoEjD4fwlhAERHsa+H07i9Ln4Vtr0Kamss2f0XmErBRM99BJjB?=
 =?us-ascii?Q?jL2hFqkeZnAZRsodwP5FpI2Zyp4ORCeZhgXCANTmbQBrxPteAZDAyDN9sCBM?=
 =?us-ascii?Q?pIqb6akMVBx8U/d65JBR89bphJ54R9wXAI2BgFLw0dyeWQ1dJBJSh4BIIv7q?=
 =?us-ascii?Q?p6/G/1pSRvOJ4DHXHOZobl/w2PR/eqic7zl/zvWO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c62ca720-0f5a-4555-d255-08da9d7ad07b
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:43.7268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PDo3WE/jV/nC30lJ3SmzNz13Wm57hHvnXZzi3xMttUyq0nlVhmDkPKvYYjGsn0t78TsFqt60Iy4lsp6OT3A+Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8996
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just give out an index for each channel that we export into the debug
file in the form of CH#<index>. This is purely to help corelate each
channel information from one debugfs file to another one.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 8356af4631fd..54e7fcf95c89 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -98,14 +98,14 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 	int i;
 
 	seq_printf(file, "Channel stats for %s:\n", priv->net_dev->name);
-	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s\n",
-		   "CHID", "CPU", "Deq busy", "Frames", "CDANs",
+	seq_printf(file, "%s  %5s%16s%16s%16s%16s%16s%16s\n",
+		   "IDX", "CHID", "CPU", "Deq busy", "Frames", "CDANs",
 		   "Avg Frm/CDAN", "Buf count");
 
 	for (i = 0; i < priv->num_channels; i++) {
 		ch = priv->channel[i];
-		seq_printf(file, "%4d%16d%16llu%16llu%16llu%16llu%16d\n",
-			   ch->ch_id,
+		seq_printf(file, "%3s%d%6d%16d%16llu%16llu%16llu%16llu%16d\n",
+			   "CH#", i, ch->ch_id,
 			   ch->nctx.desired_cpu,
 			   ch->stats.dequeue_portal_busy,
 			   ch->stats.frames,
-- 
2.25.1

