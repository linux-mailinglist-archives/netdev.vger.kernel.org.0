Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEABC68725D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjBBAg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBBAgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:36:49 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69DD728ED
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:36:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdZJKOR0JP4WvIgw3ikuVgzTux1Pd4YYtSbTYZWfcIvTWlrykUN/IIEpaH8PTERo+btDXunb8y8tWBngQlqTZ8Ukj4jIAJinm6RevSff17EUjlOvsPMZv/Lz3lMhrGMvV2WNXc5LHqoHf/A7WQ96QDCTFSKQDXnSX/yrbLl0DKsWfpMQ1UvMK9RSQeuhXq/aoA6eJLvk0x/qQClZhIM5oCHSWZZWKqPLA2apizFUq7AuP5OZUcDdbco5FnjzFjNo99rOk1UNiWY/1xhlLLVwnfRZrisfeu6Nhm+YVivX7OyjV6fpeuk+WixpkLLcYrzn+lEsY9YANxc5vbzhKjAJLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUkV8hVFtLj8XSHhnYa1NuwQqscyeHfh3LuHvJhwsi8=;
 b=hpfohRjuqQ7tGbWewnSm62DDQB03zOHelYKdwTjolqKH8qUNLFNyrJYtjnX79Mu04afCV1VxT2ezrvfaD0rlBt+l8dcoSGsL5dUqJGW5/cTbu0NukF02wlz4cjQHTJn1G5H9/evkaYpvJwJhc1CK+Odmj5NX6CU8ehk5+0thoxu+3nMqLcdWG7su5qcLkzohCjCbUhVuzqGWy/HRgvF9y1F6jSAu8y47K8QlqG5NQbvNWmKEwC2g9WS0oyTtcAIeFXKXiFxhn+X10EARtd+McK0QDpwniP0whtOZ3Gr+iq75NtKuer+Vwp/L9jQkCqxRKvpVqyyY04qi2b6HIaGvBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUkV8hVFtLj8XSHhnYa1NuwQqscyeHfh3LuHvJhwsi8=;
 b=g+81dO6DDZlDeIkdwzfgffaMoi9uQ8HF3K1/Fiwdmb1rfkPMkllMY+LoCXitTB7zpaVuDvO1Vt61ATZo+YkeFMwN56MUgkXbz3WdcQFisLCjhJahRjOhXqHubvmLtNyM1FRXmuGHofFYteYBENgseEGq5B4jDGt2CwqWPP+SfTY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:45 +0000
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
Subject: [PATCH v5 net-next 02/17] net: enetc: allow the enetc_reconfigure() callback to fail
Date:   Thu,  2 Feb 2023 02:36:06 +0200
Message-Id: <20230202003621.2679603-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: a4cbbd67-e130-4e8f-8413-08db04b58fee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oirv59xsPe4V/GoTp29IgJZsAqw5by1gK3U1CY1+cGDbOvQf+cc+cOjX0zngayaYicAMlTK0+FvLRPv5lcaWCjyMateasvQ71swICOdIMA4+Hhr7EUM5ERiDjTIhgIDwPhTyFDo7yoBn4ccWvm3dEm/d0ELWbIVZcBsEcuoeTigXd2lxt2tL5Dj2iADj6ccqJvpTmuzB0V6LEOyEfS+iK7Ig8/DzDpbZabkquGoJ4bFPAddAg4ucakmp6wVK/tMvOutgDDRUorXsFBQHcZ+dZ6Lj4ri3lFW5uoyLQAKASYP31quwetpbwFo0qZZO5V/bdbJB1JbQ1SV3ie9KA4i4H24oO7mqU1/dTDa/N7/4SHKuJplID1Gtu7wCjF6ncaSvWqy5pfsfL1TGhlNoTHMMWImK1Q5L5QQExSoybvko1LK70cILXqaq8mXXbB55vgag5cR0PLcPGOraKGci0EPqyyZS7qZV6RDblyj6K2RgNCdtdchqYiZEnQ5ebrAEwG/kbJ4rLcfB/lqWL1B1YFeGaYDtq59dh2qHlAi24yS9tPJVHGBV4K8a5iZThX4QjBjEKUmZSWyekESSe99sUfm4aFfy4dN40+O5/SiRARTD1jF3vCDmrPopReZJZm9Pl7AqB29irdEet69qWKGitZx8iXy3foAnHq6JTr7gOe4ZfDPVO3UPke2GYKqzsrL5Y2bLLcXMNmY9/+J3JoQJjqaang==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6DuxcsDd6Vd90HHmbkIJGLrvIuPjVwU3wyS0NwHiNGtfLqIYCEuevV6vcYBX?=
 =?us-ascii?Q?zHQFfIykIhFa+o875wAAeejt3BTDdgrioMJ/kThgLs8vEdd3L2BSgc+fdyoW?=
 =?us-ascii?Q?Os2W7U6Pfwvkc/OF6AukATaYFCkotQbChBj+FHD3JFOQ9+1pYHbAO2uNoTkh?=
 =?us-ascii?Q?UokoIZ8W4J65ztgeGBocpZhpUyFBwVE3XwgpPDtiiHvrf3XvF3ARDFdUh6+R?=
 =?us-ascii?Q?QQKQovnZg1Agjc/3idPY4xDz+O+706Ag1Tjl1lUM2pVGPD0En5+fGszCtdR7?=
 =?us-ascii?Q?nHJ/SkIB/Z+i2uYnD5iktJeqH38UoqwHSgpBoVRjYUcOWXLTo3KlWWXL0NLb?=
 =?us-ascii?Q?CpSDlgxpIzRNmaRiQQBK9ArhFbrHLSDn73dvM5LKa/tLYjAJhEyOkUtwx5p1?=
 =?us-ascii?Q?kdJHDnozHLBg976AkIM60Kf+wmr41wOf8IL7Qn0MxSfyQ3qpqygVSlWbv/Sc?=
 =?us-ascii?Q?O5LfF5+QlCiAVCi1XhzY3OFcLUhz7JnJd2prFxGNpNsa06I50wQd0V4iBP9z?=
 =?us-ascii?Q?Q2FX6ZOmaVgcCY+VSsbOcC4IKy6Ym/fYJaII/Rwxq+xjZL9hF21LMOzFGO6y?=
 =?us-ascii?Q?doIanKkwtmE5iSobU/mPuCWewkXYhBnWuAw+V/UBOTfnYu75uSba32DBD4Cl?=
 =?us-ascii?Q?UY7+ObWb+YS3tqynpm/NOXxnQqwO4F/1ZlxWLSPHpAJjHiSo7cGhQqIk2JKY?=
 =?us-ascii?Q?GfMM4zJ/rPda0Egnug4nayC6FwaNOzFWeqYyZHspVd7hjm7Sh2qLq/Kfwgxr?=
 =?us-ascii?Q?wbwT0sQj40KqBARFVFV/Lm22wSpYmKieg+n4bxQfGBZX5n+BjWKdoMoWz+0N?=
 =?us-ascii?Q?gLyJc16i2zKJEujJKKBI8dl8+Xa+7/BVH+Py/yaMnSLfi0wKQS+IPB+sEDgd?=
 =?us-ascii?Q?2FMxTLK1aS0GQgP6/1oAWFuKqUgKJd3TLsTY3UkRUBzoah1vHBYEqG+OEuSM?=
 =?us-ascii?Q?jrgSR/5mwkmpIXSx7lsnrPsVVhXPulJNYeSoZekvfk26D6qCf8KtarjgFoAZ?=
 =?us-ascii?Q?w/TFVs0KmO/UKvqQJKPRyTvvQYvZFp2RCmNtc5AiV+3wS8aVDEqxMxQFw1J3?=
 =?us-ascii?Q?g8wC3TEL9orfQMal2xKXjBsPr5T8qmt5BpyV2PgBBZzA913HVuTCORtvgCy5?=
 =?us-ascii?Q?bXKFTCGuw7+Q44JsXlQ4JfTGwRYWtvwsGJM1llObP136MwwgVHHIX11d7CYO?=
 =?us-ascii?Q?qSaoNTwSKJ+P8jeXevFDDZrH4gGIuZ0PFUR6Alb7mIscatrz14sdWhf6Okqg?=
 =?us-ascii?Q?tnzzC4NcQ+xPyl7p5Qsqzs+icL9OU5mwXkzZw8BRLzSkXPuQbWJjJlXbAjOx?=
 =?us-ascii?Q?RLNW/qLW/7n+7BKJ3aR2i3WtlPdVkO3e9g3qXtdh8i0klhSjbI7mkL6MJX3N?=
 =?us-ascii?Q?JZWHowE4F6FtzbIAvv4qInSrKkSbkKLIRq0xkfct7j0sVM4DMhtIEHmsnODy?=
 =?us-ascii?Q?ObjrKZtqWaeF2a+GiA7wtBV53sz6ixTi4NW7MM0z+B/pRkgkxRsBSW2GI+45?=
 =?us-ascii?Q?sX181e3fvDl+ln8SZdlcJ6x1UAS0CBAfjJVMBPopzGVaYztPwQ54mq4FIynK?=
 =?us-ascii?Q?XxaIkZHsEP+XPibsPOtR+tjCNMqPlnj6Cyq0rtIwWBa056quDGgYLbhiVjAJ?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4cbbd67-e130-4e8f-8413-08db04b58fee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:45.5140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 99o0Sy5vQJdfPCjxBO+Ukqe0EW0hAfGWnYhtNp2C488L90fJNv/PQO8AglVnaP3ePJt2aGl4H2cgbjQReM0fuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enetc_reconfigure() was modified in commit c33bfaf91c4c ("net: enetc:
set up XDP program under enetc_reconfigure()") to take an optional
callback that runs while the netdev is down, but this callback currently
cannot fail.

Code up the error handling so that the interface is restarted with the
old resources if the callback fails.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v2->v5: none
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3a80f259b17e..5d7eeb1b5a23 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2574,8 +2574,11 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	 * without reconfiguration.
 	 */
 	if (!netif_running(priv->ndev)) {
-		if (cb)
-			cb(priv, ctx);
+		if (cb) {
+			err = cb(priv, ctx);
+			if (err)
+				return err;
+		}
 
 		return 0;
 	}
@@ -2596,8 +2599,11 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	enetc_free_rxtx_rings(priv);
 
 	/* Interface is down, run optional callback now */
-	if (cb)
-		cb(priv, ctx);
+	if (cb) {
+		err = cb(priv, ctx);
+		if (err)
+			goto out_restart;
+	}
 
 	enetc_assign_tx_resources(priv, tx_res);
 	enetc_assign_rx_resources(priv, rx_res);
@@ -2606,6 +2612,10 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 
 	return 0;
 
+out_restart:
+	enetc_setup_bdrs(priv, extended);
+	enetc_start(priv->ndev);
+	enetc_free_rx_resources(rx_res, priv->num_rx_rings);
 out_free_tx_res:
 	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
 out:
-- 
2.34.1

