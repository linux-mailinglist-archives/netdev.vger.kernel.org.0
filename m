Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8909467DA8C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjA0AQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbjA0AQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:16:50 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAAF1448F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:16:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEr034IqdR8x4PGqHx0bjzX2+iRd7zTNw7sz0/1Jq6OoqQn3oQKrRxqvpDFE77v4a21Gth/yx8ttLHuPcSayb+huESOK74X0D5ToVkN3Vt+OQ+RZSJq3Ysl7CCXUVW+0rTbCEx7p097aNCOxU0UJ9rXyLfpNbeR7vuBg7LqXPal/SbCudn4YSSJCe9QR1pJl5bLBVe+qDIvwmMGqbn2vhZtCQcXQHTF5jifnrTVQw33nHmQOqPz0aD0XHsZQTv+nNPPn29iRZMtih179IqiHtVZ6gbknij+v9o+C44SWYjrLkG7LboINaUUyBNcuLGn1/tO7fmt/bgKQaKsNgHGyFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGWPF3JFAnqFexpDuqaIPumzIqsN/pGY4lE7w3nbQpk=;
 b=QdYJQNbXc+UPPqfYh2VieBgsTyDgZi1yv3eOWSz0f912c26OrjXL9+7tHqFqDpaBQZTafOpG2Nda9fP3+4xL/kzol0Em8C2EsvV1ifMWr5F2b+VunKtaLKOiV59pDJgbuD8MREtld/5Cio5TFQy6p5gmtIZ8HzIh+uKpuQn70cObHvALFn8lcZuEHr0dvW29F5xH8Z3h0RPDBem6oRmJ3fNtOIGnYmODJzYuM1qLNV2NlJa7EqPjwq6JSqFx6o0jzTT2lTPJ/Zoiw0FLYWCaBz2yc/eIY3JaSCPBhMeCf+GglTECn7dKYOWYgFi+/mXPR9brtHGx56x5gxEmmkcH3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGWPF3JFAnqFexpDuqaIPumzIqsN/pGY4lE7w3nbQpk=;
 b=J5zuOlKLxULKm72TPpSBPGFfDo8imqvIdldCOuhjPXRxYiE3wb8vM+/IyFtHRo/sc6h9o7Oyy8xVKMxuni6R25fjiZHCqygfkSQ5fKOyraHS1ixkU5GZuntlG9GuW58Y2T1XxJbCeS1ob+Jby7G8lw2SqozkbCwXDYAeK6iP3kY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:15:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:15:59 +0000
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
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v3 net-next 02/15] net: enetc: allow the enetc_reconfigure() callback to fail
Date:   Fri, 27 Jan 2023 02:15:03 +0200
Message-Id: <20230127001516.592984-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: fe5489fe-4ac0-40c9-a63f-08dafffbaa71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKGAsO1+6zjJ0DRPROAvGCogdViPO2BrictLof9wG1ajRXsJd8HKepD0D4z4A+8qaQFa/UdWTOilaU/GtCl1Am7HkvLaNCuFrGMbYFyAuLYSYSIZSDF99gsPf3M0cAN8+9fJJdCvfY3JhtxOkTxIy/zXhklrUGQPr1IbFX7QPnkQz0mUlYF2j0UYXvDsuErkja3C42ou3XtuH4rJIRo5/cQncZUIRWt0T+aZz9HEeWy8rvWhmYoHJNf/p3/BMWQA/0jbc7wNu+mnF6RFonHyXTqheuH+IPkKXNvcIPYmeQjyCevSWJvBBUELUOUR+S/RD5MhCbMcKNTGegOs2G4c4CPqNwp0PA9jS4zLzkle/36RRKmBzam+lsXP6wiKS8KmvDxJixeNI0XdvMZdO9hExzDkaegA8IBPorbxNJwxX5w3+92wd9/4fXGy59Bztjy05eib84LxlhL6D6f251ywuD+RwZvxalmbj84lNIQxrwNkJAvqurs5NGAuNkAOeo29CT0XxJEq9CuPA3ORMOwYRvOwDlx7gJD5sWapD8khzQRD5uAoXmAYuL7hhoo8mFbJ0rpfThtsSBdRKEgy1Iwb1bNGHcwgCdzWGZ8GXlp3eokxkR/pW3KM+Th+pz8KK2D6TkAx9/8FXg5H5QD69RDjicjqG8jGThymIF2o1kViqXqPA3JW48+PJHHLF9kOLc7Vm8W65FpfsxvyNU6BwGqt2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(6666004)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lW8eHwOIUagEHE/PjFf3SokjE6MWJv/Lw6aGmjvK2dEjpobeyCLxPetxa0ob?=
 =?us-ascii?Q?QfjcqcwL6XiLkxCbskrJfleZ/RfXn+RGZMFhPDGlkQa8FVejNyjh108uF7ID?=
 =?us-ascii?Q?IZ+GUepbPaM8Mw8LgdumssbLr9amG7ue/LqmCUxBPRc50vqdMtV4DlreaS06?=
 =?us-ascii?Q?pP0mooACzTCO9+darRaPKjnE8vLhhys73g0telnT42EoMEhVmpYQ33ApzF9I?=
 =?us-ascii?Q?B7GwbaFMJCJXL71Q8l7PZvIYcAidClepL5inu9k2K79HVXllMNjwSLgK6gh6?=
 =?us-ascii?Q?gZ4OWSIqkMUy/rnTtfEbfXSMmbhxcPfW5EtWBdW0RRHREW2qL02rTwfGB1M+?=
 =?us-ascii?Q?R2ZDn/HeeEjGeFZT3DKLBB7SCwzGxbTfwEhi70RK5XnjNdxjScpqph1UlvXA?=
 =?us-ascii?Q?xJBI3HxpxIqEIVr9p+2v5J6O+S00/R88opRppDMGgmKzO1g4IbAVXZzfkDtz?=
 =?us-ascii?Q?w8hg+CzKcw+xflewvvb8ZLaXJZmfOJ4QrsT/xxkLBZpiDG/msK+fKuRdbXpa?=
 =?us-ascii?Q?KZqr5g+FjfzQ2M59uRkQZsTmcLndtj9b+tCUaWXcH6jheF98bqEKTqR+pJFb?=
 =?us-ascii?Q?vY0Db526D5wiDtwtmA2ziqe9C0FIp9MaZZTa3Q9zn1O+f/3p8GFfY1lMxkv+?=
 =?us-ascii?Q?p8qrpfiE/Bd5Q5novQXjKOfH9QcVm/aB6BkQ98pvk3G8+2GYpcbLiMncVGJ7?=
 =?us-ascii?Q?5wdYMl9Et9LJpjWbp4+5UhQlk8ZjSY+ZhQz6s+KV6fG3+Q7iZLCA5qReuFP7?=
 =?us-ascii?Q?fx33FQnRcWFVtchEPIX9Grjkw/p/gYQFV/EGhCdMmusv0jfllYwgCpYTjQ2U?=
 =?us-ascii?Q?6jcCo2D6A0KkqP7T/YIWSY+JWhZTLI0gW2X4RZzCqGHCUAZaZD2EVFeLulcy?=
 =?us-ascii?Q?ViJzqYmVqeXd92/SqeXbwxZJoAcvo5hXyUuX4jiJEdkrStjt5YzzdahsRtZn?=
 =?us-ascii?Q?50cxUI/WVNEJt22GaCt949pYEmZeF61dWZFS0Ja7jG5TFDJGbbWDbjFOxBFQ?=
 =?us-ascii?Q?dDiShUJmaEmYaIh79c6C3xHgxAsHD/i8jAv3e12FqEPFNUl1GZ0CdPT4KF+Z?=
 =?us-ascii?Q?1hO6BtOjJxI554pNdvwhIv8zQFtv2LLNiRDiRx5taw8HL6La9eyh+6O1kyCn?=
 =?us-ascii?Q?MXj8d0Erwn2WE4Qru+kxuaGSFqXydjE6OXDhX/ppucxeIZItpvMqLEZmFAbZ?=
 =?us-ascii?Q?eyUeYNPJf0wSZY53D3XR8of2ovsZrJQ6oZWMyD/ffRDdwGyw87CbSXRXi5Y4?=
 =?us-ascii?Q?sGlPomKcN1qtJ8fDGS4Udi0kh3Lp2nk4dQw24JT+t1898nFgaMdZWzz0WD7v?=
 =?us-ascii?Q?XR+kr8LobIFn/iLsj8EqOGNKyFk9wY5pElu6gKK1+cF1j2XZCnafL8Iz50f3?=
 =?us-ascii?Q?NuTChBIN8yHRezdKltiwRwgUZy7DsdPNSxPQxNXUl+mVUEyG0ltyjWMJH8Js?=
 =?us-ascii?Q?d9SiEVyyqKqeDY5dFwXL+rl+Vcw5MXpmK+Ou7gKUdiME54pv6t8HEsChmkM9?=
 =?us-ascii?Q?NF93IKD9SK8pjXsmTNwyXaBMCcETWa8/eydJKd7bOkKWx9PXFBi8jchAR66t?=
 =?us-ascii?Q?JtpEdX1l5ytECCeBVW/0cfgVlhQKSxhxoXdcHwW1uybGfKZcp76QTFgztCAt?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5489fe-4ac0-40c9-a63f-08dafffbaa71
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:15:58.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1UUjoakztTQWs4ZnbNVSbE76Zjgn3KtJYOUbr4b8w1LCXJgqizGt4cWv4Sl9i9ZIPllHerYaxaUpoEjTIcADA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
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
---
v2->v3: none
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

