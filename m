Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C63B5E7FE6
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiIWQeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiIWQd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:57 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60069.outbound.protection.outlook.com [40.107.6.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9200613F2A3;
        Fri, 23 Sep 2022 09:33:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxNIbbZrm8dLpPaJE37IXh8E5nqP0JIK7CB+Mudw/CrED4Ce92GwEdaLsWGhICurkj2Wl0mq29YaQxsEBb44gk4XvOkJKeYQu7E9iVNN8yifU9yX9j4C92Vc3TwlNHorIzU5RIMNFIf/mg6rOFlLKrfiLzHnBEm2z+HASL73MZaNoCW5cAG9bnOF8D3tOtapRdZDb6tqYawkEe+q/tY2LoXT/b9m3hghc/h9IkucBCWCNbC27WpFsNS2suF18Z6YD1FQJk19WNj2l/+DoG+8WWyDYwgveTbcogE2oPxGa2b3FeNPbcuZOsRFU656ufWjjZdT8LvZQNP4oeB1MSly5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xp1J27hcDCtF1HUstcQHK5fAljx+vmIqXGLXWwbTue4=;
 b=SJcVEQ6iclqeMDukN+gbdjtmnEhxC5rd9kPYxZoZ+C5hQ86i40zoUjpBfqjnH98/AnM4FLRRlWydLNaBvCGaGtrDlU5Jln91z9L8B5/6VzSpOHmQPMZ78Hvz970xpbmd/1UDw+n2M1lws6M9e1b+0v/N9LFEAwdRxOhHdOoWLFLLc0uueIDGAghBwVcVS2kY56AJLU1wJHwnzyzzdL3q+f1VpsS6qYS9GUOXkY7L0QcZw4S7xwaEOQvNXcXfyOpwUol0oZ7g9nTOc5vwJBcGJCxBGZincNsG0syfdISWZ3+OfkNKa17JEOA9djKW90NOl6hqe9DETn9BKQe4T+C88Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xp1J27hcDCtF1HUstcQHK5fAljx+vmIqXGLXWwbTue4=;
 b=mlJxF2C7ZG6wgH3E8K0NLdBpVGfpckykrxAMAa6aV2BYq9hGjaUsm1R2D1cyCyVXUjY1m+f+xs9fGL+VfNPOqOXO7M+GA1ILdxx0/LMKrfimCJ3HxXvWPk2UlQO0vNzrF5u6ynxDahMmngPCAd8sagbRE5kWWDwDlHNqSsHwfB8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 11/12] net: enetc: use common naming scheme for PTGCR and PTGCAPR registers
Date:   Fri, 23 Sep 2022 19:33:09 +0300
Message-Id: <20220923163310.3192733-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aab1d65-86fe-4a14-67a0-08da9d816729
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+dMqarntZuxFb+uWuAreifqK3cvhwzdJvlfu9+6FTjhKWfjlYsLsRXqUJSF7b0zuEF35EqwwEDCiq/Ub4DWqQjrXvNLrj7sYp0KC1I7cJqxlUk1ef0FkjoqFS6eTLedr5rAzUWMvz5SS4G2mzhpv4J/xVzwNf2pD8W3vdTDZEFmev24l4eemI3BKhwhGc9gxKHLVFcCKfLP8CTu/dHJYAkAzbsuVyuZ0R6LGTcrKS6lSErq88sd/qiOVMCmLmi3X+PVsZZiT41G2prXd5qoAGgyRiytaTGIiF0zt8W041sM6Mbm6KHqdASh9Iv6U2s030sfcPMpbkIMI+ukkClKhkiugj6ddKsS/tuF2tXfIHaBMuYne4vRBHLqu6LUFuA1za2jEDvacLiRhwol0fvZZ/7jQ1oMzePBuv3/kRR+ZwGM808SVbPm69ruOVI0t7C+6aV3MbP3xt1JlioI7bJVAVMfpZLjbn4LMXk7qwwJQEr1W6N1PF8XZZtBSUDrRQy9Jk+u1U/OumIpUC7/oIFTKr9l3Njhzuhn6rX92qnbqG6u6zXk5iN+rCylnMdf9fsp/dgbgW0n5Q7mF5EoMoVXg/TwT0GdknAetTiyVD4bYKukZvktsL97kDNCgEcrvpYp+BwBaglvhR1QcD3wvquSEJ5ylhu1ACLO0dXMuSqz9wdiPnov0L3Xh2WbI89E5EV/C7X+ePLntG6jFirD6Jj+5duF5dpHNx/WJYDpKIDDkGj7j1Bfs45dAD7NbQmGorBLUHSSwfP4+OSRL54YBtUOZy/6xqMbdO1CDzKwlkT6d/c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(966005)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RIH+cp2Un8ndpEml3aFxX2W/bFQ5Jj80Oo1/XbCmuvQTs4Bi3GRGsi+UlFvP?=
 =?us-ascii?Q?A0O5hoDa8/5XReM1v1Xhig/Uua2BjNwJrSvpiK5R8+/y+L9gJbX5MbyxcFTL?=
 =?us-ascii?Q?2HD1pCFCl8GDBoztk7hHOnpv+sQ4IOChmhScSRkgMlHWsSx6srGYsNEJEXHb?=
 =?us-ascii?Q?AgTj3Vuuca32OR33VlCTFisCnH8A8LfT+rAtinoZzPTho/TCeHhizEWtpLSg?=
 =?us-ascii?Q?vFUS1osC1f4Ek5QX1Yr6ZNBN+td6bdsyveBLAOj5Eyg4lKp34ZmAyDkJVwAU?=
 =?us-ascii?Q?GAN46PXqQ7l/eF5jt68TJwIYMddac1HtaJuwkWlmbfdD+AN54FUKolACpMeS?=
 =?us-ascii?Q?BTgXj7CKmD3rih/qUKvENJhA8ODQp9PultVayvWbSO6PerwoWesymnsmh+ee?=
 =?us-ascii?Q?xDEeAtDhBRFmO8lIm08x6TvYMLBSalpriv/b4b9TuKP4ZcEuZq+UmgR35cAK?=
 =?us-ascii?Q?FcksXZXLLsjlldrgNWKiZfhunl8xrbI2VFl/8l6nXkI5M5C0OmrQi65Hetb3?=
 =?us-ascii?Q?WWpWp0tKAgC+T5hn3LTHPTaUnOtoQysBdUWWjf+GXpegyOCnv68caslEiB6D?=
 =?us-ascii?Q?2bM/yyGivhJ/YP7pzA+LjLmzOc+DK4a+YJo74Sm3pB9fglYGLocuIrMOVPAM?=
 =?us-ascii?Q?R3YoyzetX8UH18w1tmYEgORpQtqKN9/hgiThyox9ydhb2BlAAqBwtrantjNn?=
 =?us-ascii?Q?iWYOTk2h7FhPXvPZ4F4rAj4n8jkL7mhU3TiLRCJwn1SBQEPgckawbGc4g2Rh?=
 =?us-ascii?Q?hJMmeYnfRmP4ylCd7k+s2aAyBBIxeRbXJ7CxozU4F6IbrDMc7EXUzjO828/Q?=
 =?us-ascii?Q?WqLHwPJ+gWLFNQcknzQ6GDxWsckDgIuBiS8YDA0pa4wEyAc3NhQEyK6dr/91?=
 =?us-ascii?Q?SgQeUVCR/T2d6kM7JbZmdgp6VDaT8IYgVggdOW2+jBb0TtNXsBi9LlVn/j+G?=
 =?us-ascii?Q?q4P6qn3F6OXopCxxrmsES7TRfqm1+naRPDyCjPXGzqoiaZsCfXw5AqCEjz3m?=
 =?us-ascii?Q?k551Yw7Wom1ggY8EQHVb5uW59+cw5GkRF+rcAnzRpuZyuPGe1ZP2V3PconC3?=
 =?us-ascii?Q?Zu2Dq85IyNcTWp+6w3rY7lD5WkkwkxKy/IWiQmH8SqZqOpAlEqtJe88l2xTd?=
 =?us-ascii?Q?2KAFXgMvsHI31HWnQHHckVoDNWFg3ZjN32FyBaB8qixiFSOIJIqnSyDFMyUR?=
 =?us-ascii?Q?1x97xS7pf6uCs8HxOI9S7oUFdTFTZ8FSe54U52/UGqUKRCuvyulsQKakL/kO?=
 =?us-ascii?Q?J46Sgcr+7FvJ4DSHRXhsunDjJv6JAj3BHsngL9kQ7nbAlmwNtsyoMuUAEOlI?=
 =?us-ascii?Q?swyOca0HAD95XCZ7X/sCAV51Evwq6I73yQyfXjal+CSOPGJc7yz4pmwYHl7L?=
 =?us-ascii?Q?qK6vxB6XBxy4TZrG1D/9WCl2pbhbDj2ZaOCuLwfYkLBZqRHfyuV3EQIqeJi0?=
 =?us-ascii?Q?lsHF59SFEEGGuoNvZxhFzkB/e2mApkqQuoeAq0BLBGJBvjGmEBkjXT+CO5dr?=
 =?us-ascii?Q?2tSB3j5c8Ccj9XBpDsW5aZXRlscWtaJBZYQs6F99UycCPWZjuvsJ6hYcJGlS?=
 =?us-ascii?Q?zlahdXcCXoBweVbYPJTRzzWDJmnU3k9BqnmJL7LIBjtViZwlZl97SnXXpzRk?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aab1d65-86fe-4a14-67a0-08da9d816729
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:53.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C65rxkPiIfIhQ/eiXD2XMJTY7DOngYMCInKjXx460+CV7e0gkxIAJYL5z4BikurHHn3vBKcnuD+Fc30oHCI1QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Port Time Gating Control Register (PTGCR) and Port Time Gating
Capability Register (PTGCAPR) have definitions in the driver which
aren't in line with the other registers. Rename these.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new (actually taken from the separate preliminary
series at https://patchwork.kernel.org/project/netdevbpf/patch/20220921144349.1529150-2-vladimir.oltean@nxp.com/)

 drivers/net/ethernet/freescale/enetc/enetc_hw.h  | 10 +++++-----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 13 ++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 0b85e37a00eb..18ca1f42b1f7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -945,13 +945,13 @@ static inline u32 enetc_usecs_to_cycles(u32 usecs)
 }
 
 /* port time gating control register */
-#define ENETC_QBV_PTGCR_OFFSET		0x11a00
-#define ENETC_QBV_TGE			BIT(31)
-#define ENETC_QBV_TGPE			BIT(30)
+#define ENETC_PTGCR			0x11a00
+#define ENETC_PTGCR_TGE			BIT(31)
+#define ENETC_PTGCR_TGPE		BIT(30)
 
 /* Port time gating capability register */
-#define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
-#define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
+#define ENETC_PTGCAPR			0x11a08
+#define ENETC_PTGCAPR_MAX_GCL_LEN_MASK	GENMASK(15, 0)
 
 /* Port time specific departure */
 #define ENETC_PTCTSDR(n)	(0x1210 + 4 * (n))
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 2e783ef73690..ee28cb62afe8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -11,8 +11,7 @@
 
 static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 {
-	return enetc_rd(hw, ENETC_QBV_PTGCAPR_OFFSET)
-		& ENETC_QBV_MAX_GCL_LEN_MASK;
+	return enetc_rd(hw, ENETC_PTGCAPR) & ENETC_PTGCAPR_MAX_GCL_LEN_MASK;
 }
 
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
@@ -65,9 +64,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		return -EINVAL;
 	gcl_len = admin_conf->num_entries;
 
-	tge = enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET);
+	tge = enetc_rd(hw, ENETC_PTGCR);
 	if (!admin_conf->enable) {
-		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -115,11 +114,11 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
-	enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge | ENETC_QBV_TGE);
+	enetc_wr(hw, ENETC_PTGCR, tge | ENETC_PTGCR_TGE);
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
-		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
 
 	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
@@ -299,7 +298,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
-	if (enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
+	if (enetc_rd(hw, ENETC_PTGCR) & ENETC_PTGCR_TGE)
 		return -EBUSY;
 
 	priv->tx_ring[tc]->tsd_enable = qopt->enable;
-- 
2.34.1

