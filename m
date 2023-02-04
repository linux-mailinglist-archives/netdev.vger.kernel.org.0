Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D55068AA69
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbjBDNyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjBDNx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:59 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D2936690
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f38xodMpKP8mEyulTudAzWcevdJiXbE5RoGoa73K7AZO75n2ZFXr71TRvBm/GLI1XsgpARDaXgmNIjUO//OhqhPnWlL7fDwgjoMz8a4qusComyFaxDZfZT7sGdDAY8Emqqle4H5La2qMbFchxEoy8Z05zpqK1AuJ55DeLV7QabRXCZSmZhh2uVMPGc0dBBH6+WJgSuMLgACOdg+lcyT/57VLZQ7A4Y2jaJfwH4mkVFflAiZViXPIUvUCPuYCc8/hgAr+SRyQaTOQ45Py72v68bbC38Co4CP4Qrxza6Uty8TmBUa7YK8L6xSpTnQ2fuv+CigAUhFdFuKYfzvooob34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWz86TSIWf/nchPE348NiIrhi7d60mgikE0WHGlBhm0=;
 b=HsRPu6wzKH+dH4mgUImALTdLgojstZsJhWkkZ/Pl165eS62jZL+k12JnVXK62PLRe0V/oGnz6xIeARFZvW66arnP6Pf3lG7PCq94sZgifDRWbJ41rY2loziE4APTYc2w5H1GtzqWZ3Nwg15s1k4/kgfK3JSt2NSteY+g9PqJRkY/Lmbd7PitL1c92Uxt3yFe9F4OYC8lmF8xbtfUMnVBYHL6cPgIJytbM7zEkIw0SuX8T0MYOsy8XqHQKMPJgwYYWeKBh4q7KioxI4GnKirWHAz+NChuUvfRQT8dUNxDT+Z17CVJ/reJjcsFEiC/jAe7nYmhmikVb9AbyR580UqIdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWz86TSIWf/nchPE348NiIrhi7d60mgikE0WHGlBhm0=;
 b=k9K5wyah6+S8vwc546frESuFRAbsEXv4vr40Sqw6dSM2NwVO+oI4dHLAqgr7quSOvRW3YKxlHVy06JdbIm5NmDeJHI9Da8kO96BfgWWEeSciTRyg9N/o0KpVYpVaxv9nFT9JqXEihmEQNil0CDiDA0R4rlhSKbdFMsX2zBF3e/8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9047.eurprd04.prod.outlook.com (2603:10a6:20b:442::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 13/13] net: enetc: act upon mqprio queue config in taprio offload
Date:   Sat,  4 Feb 2023 15:53:07 +0200
Message-Id: <20230204135307.1036988-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: 98800733-4a27-4a32-3a97-08db06b73949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGxscZOjY/XimMgcVwD2Sgk1AiWLQCohzvrKofocEx4lEWhoiKlQxGAaI88l+d7f3zpWZUceB786JLS1ysU3E35bTLFp1T5rjLKicQ/injFRMYUpFb2bEOGWOtbqNqIiO9aHeWGHwu7+MIMwsrslNDnXvwwgRDsJCn6ya+grhActyhgR9JXxWCbysG1Gd5I3NEkOnQwHgxeVxyGa+MKeVy9pmRErkcP7z2O3wrLDuxrDEfiL8Ltwk+oPmoqFW9AQn5RxOcAktEQIADK7sT9OgySgJn5HhwXNiTlNy4L4KOSSV79Wsz/Uv83JuWmo2+tqzm/gsRH++Ut665uIuhREj2C2ZyJ7jiphnZvwQhykH6Xob2PbPSRqwyEsXjBJz/ykKbWGNP0gOjlsMM8zcnf+OP9K9bpX6wfWyDAVFsNCteEKUj4BCr7jKfMrIdwAmXHdX9DqV625OZJp75ZpgA++5v5ovUrtnUV5JAn+SRSGUSH+GvUzx0rhhoUNeCkr9i4h6NQ7cxK5gV+GcqY4HU8ukJXqmicGPH2m65vdjY4ByvBw7VQGqsAezlg/pIRC8Z3EhaItIt5L0jfFd5vItZt3jo7TgewZc6EzIg4f86bUMf+3+3d4TEnCklq37SvgwvWqbVdonAwfe/j7ZPPcqxUkxL9wt3FM9YwF0HBcHPLXlKcMo56irprI0DQhVpxET6CZOv3snd1ndREE5AisAfD5+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(7416002)(41300700001)(4326008)(8676002)(5660300002)(8936002)(6916009)(66476007)(54906003)(316002)(66946007)(66556008)(2906002)(44832011)(2616005)(83380400001)(478600001)(6486002)(52116002)(186003)(26005)(6512007)(6666004)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b+IfAVxLNIteS+VSkjGqA8RHkHRAj7EREGS1WqSfxc3SOGZYkSIDYAXsTN7c?=
 =?us-ascii?Q?3ZVL5RfHI1aSay3V/TMV75+T4034p6dStM0iny6DVigz1haUT8sqljz7ZUwI?=
 =?us-ascii?Q?QyeVsdKL/RAq6n5JpLF89aB/17t/9W8SY7BtGqv8ueTxM5d2U3WJ7QK8sa2k?=
 =?us-ascii?Q?OAS3pJxqWwqdlbice2X9NWVd1znNaR+yLYTLHWbvthj+xp6ZOm5L5qYko4Dp?=
 =?us-ascii?Q?J0e6oDF4Of6uYvgBr3HX7zdhxuMHy06fQqr3yNKYdb1uNyBo6RRG3cHXfkgt?=
 =?us-ascii?Q?lGmb6RF89xcSTbwLf0neZnCaEMUe/HYcMMm5EZiJ0/qD2JMH1OTP1BfGdt+r?=
 =?us-ascii?Q?Vj6uoLN9tpLiQMbm7yIdHFlJMtp9OZ2zprWWxTb9rumqLJazwegeXGexHQHE?=
 =?us-ascii?Q?DA7tntWymj17acxHxEtKn5ul4vgXorWF1x/6Hen6u2aw5iaONDFa/gOSRGp0?=
 =?us-ascii?Q?KFiA0VsNwmpvOhluQxmpevM6slXs51ABuKmuvdEV42ZfkQyyQu8m5zFBwJ/V?=
 =?us-ascii?Q?jYl9QMPD3gfFjlRgkry6mlzUFqH7ejJ+v5NY2VOapgMTj3PbTBSTZ0Zr51Zs?=
 =?us-ascii?Q?NPKvSAs0X3PGxAk4gDdrZuaRx+HzdaLhj8F8ANSPWu/VRPPjhjCG5hbPaJD1?=
 =?us-ascii?Q?W2xakWzGdFszMWpJvmTTyUYvQicFauNUbe2FxesUvQp/+cr4L1/a80cfhIab?=
 =?us-ascii?Q?VUUK8ULC+WtGmOc6xMihD7sPAWxsFndwsvMnqFbFvGEn1EsXz1Iz1R4+9pk7?=
 =?us-ascii?Q?WaGOdyCOJDCWCtg2n6QJ1o0xgj8pbOavqVUkNLDs1iOjcGcRnMRnd2i5HHsA?=
 =?us-ascii?Q?C3ORSf6wQ+2E6GFWafTjQorvpNRQeK5auak9RLIJcwV2IYZqp+Vh2XaICBx9?=
 =?us-ascii?Q?br1uJxMQXI+wEOHBY2gCqWUI2cAkjx7QhJS0FJFjkDtFzTBoBkSehiF91Ek0?=
 =?us-ascii?Q?M/tR2Jr/Dn1/ge5KP8isdKC0HAE0YG7u5Xs4GP2HOqaSejrDqwxPoEIx3nw7?=
 =?us-ascii?Q?qkI8jMtHa5mAAIxqKX50NtTtIYgeDncNwo5kP+EAwoZzPGlLqhXjjIs5oah+?=
 =?us-ascii?Q?eJOsu2mrQ4Xt5N+l+NSjDSzhJgHXLnew/h8+LYNHbPkQOHIzNFpwJ6uxQJ+Y?=
 =?us-ascii?Q?J5UTFvThfTT82+kDpoZthAZLOFUsY4hha3KKKaVqVi5NjgpukVsrS+v6JFwB?=
 =?us-ascii?Q?BgbJEG/FEqQzwdd4n1LbUoD0ieIhbesc55XSFrnh9f77msfV+TLFnC8cz4YA?=
 =?us-ascii?Q?lMiiF6SLbFGtyylx0N1bsAEDg6m9Qu295yhwFuOD7f19bHuOXhsIdzbZNQp4?=
 =?us-ascii?Q?IThBb9b+q3pAf47Votkn+xpL7w88uypSCzrmOaKn5+8bnd+cwT0t7gKASx5M?=
 =?us-ascii?Q?/OdGCPo1Ro4u/yolpCs2CQEkW2a9SyqmEBDSfUQU8kF6ysWArG3omi/LT6Yu?=
 =?us-ascii?Q?up6BDTCOuBNGquPoJLfzcQva8GyY0LbyshljGr49xnISAXDxKjS6iAJv0f9J?=
 =?us-ascii?Q?DGEgSTmtBSswUGUo9Pnavfq63gEv5sQDpOTbSqyZodLT2HCSDYkwDLqqbuIe?=
 =?us-ascii?Q?5eOaFxkA6WLnVoQNkM2zq2frBrQmG4bOEzX6TZeieqOmg2b3+ogepj9ddJlg?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98800733-4a27-4a32-3a97-08db06b73949
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:41.5126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rLzCdlhlSSarxMJBWlES9pn30erS4XfUA8NUohIENRyIeY4nl4bg2E/EuSFgLWxqZiF59E3UjgiW4X2h4W0zlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9047
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We assume that the mqprio queue configuration from taprio has a simple
1:1 mapping between prio and traffic class, and one TX queue per TC.
That might not be the case. Actually parse and act upon the mqprio
config.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v6: none

 .../net/ethernet/freescale/enetc/enetc_qos.c  | 20 ++++++-------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 6e0b4dd91509..130ebf6853e6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -136,29 +136,21 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct enetc_hw *hw = &priv->si->hw;
-	struct enetc_bdr *tx_ring;
-	int err;
-	int i;
+	int err, i;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
 	for (i = 0; i < priv->num_tx_rings; i++)
 		if (priv->tx_ring[i]->tsd_enable)
 			return -EBUSY;
 
-	for (i = 0; i < priv->num_tx_rings; i++) {
-		tx_ring = priv->tx_ring[i];
-		tx_ring->prio = taprio->enable ? i : 0;
-		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-	}
+	err = enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
+	if (err)
+		return err;
 
 	err = enetc_setup_taprio(ndev, taprio);
 	if (err) {
-		for (i = 0; i < priv->num_tx_rings; i++) {
-			tx_ring = priv->tx_ring[i];
-			tx_ring->prio = taprio->enable ? 0 : i;
-			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-		}
+		taprio->mqprio.qopt.num_tc = 0;
+		enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
 	}
 
 	return err;
-- 
2.34.1

