Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98971679636
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjAXLIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjAXLI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:08:27 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2072.outbound.protection.outlook.com [40.107.13.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE65730FA
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:08:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxZwaHlHkzR0Sb34ldhCT+zzeZYRkytfuw5D7KTMHifrPOfQLOwx7+8zYB8nvIzGjTkWTj04GeX65hW8IDUSiofjwRCRjMlN/y0ME849zrkZMrV02EA3WyyEnN8ebznJMQEld1BiqN7xf2NW4QTGqEsz5NZ3OOTLS2s9c4/nXCmodpnvzr7UUAz7cF5v+MBMS5xeyhZsw/QKjTaQlKVxMAZB5NERY6Nr57l+C6C7iaYr6SsCY15JykGppWWy29o865/X4xuzwqrHwBRPqzEMCafigdv8xCBSiD8VvO1HIkKMeigxfi8IwEAA6D57ceBDCqxKT997d6fxFDIechbAIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9lN7Q0LnzjIdEJw47zFKf2mWZu7uyIPP7D5P+i2iJM=;
 b=VXyg0MKNSwbruAqd9wHJqn2SupgR7ZtFmdjSwHjyetvUbudJFj8+8MHX13AE4YJ7f+SnQq4BXTrivSs+OF3y/Db/x7zz2UuRw54XMiXCT1eERP7r4wX4Ra/rBEPkFvs4eLDT2+GJ/5pY/MNne/SX+tGMmXhNheQ/UQ26fnfSIWAX+pAr0mk3otuGzrrbT0Gq4MfTphD6rCoo+c4yFYrM02V2CBc89Ghc0tzVi5cyXstLMiO90paWScHiyyr+qc1WftSk9dBfonBJ8cch4CjvVNd92EW/bPcBEjP8tzIGjixajDP7Ey2c3nVqKxnmzs48DOkPNf0QkZFk4ZPFw+7/FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9lN7Q0LnzjIdEJw47zFKf2mWZu7uyIPP7D5P+i2iJM=;
 b=Oq3T4be8P8xiIbuCUefPiQwWFDRAbaYPwyOAkPOhcB2gLlZo+5EgGMHIeNswlaEIQ7NCLXJfY6KJJ70JX7ZdvXpZClWYZoPvN/tbNOITWmlNzmmS+KOk2DOmEpZu/XYMrFxvi7LwQClR+nkTBap5sgg4LakOXzQR/HMEYku1NF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7173.eurprd04.prod.outlook.com (2603:10a6:20b:122::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 11:08:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 11:08:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next] net: ethtool: fix NULL pointer dereference in stats_prepare_data()
Date:   Tue, 24 Jan 2023 13:08:01 +0200
Message-Id: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0082.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7173:EE_
X-MS-Office365-Filtering-Correlation-Id: bc65004d-fc90-4b59-fa44-08dafdfb484b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8FTcKerdiGdwkbmeHJOIbJks4R6uMAQSGXdq8tT1hZ0blOhmvorNM82TBt+RSU5mFqh/wDI5u5Tk1jN5z/WEYCokTXLBJ12zrOeXhTPR1IqK2cQz7Ykfq3eQf/w0no/wyZO+DkCMi2aZ+clM0PI9dPLQhAQVlksW+OX5TTV3wlIPmhXIAllVqlLjA5LzM5fCthO3hMBzW8P1EAzczNhhnjm2ZN4Ahugd6xEU7jY4THK1OzG12DwnrCT8EqTK3KdLpF5zxtFJTVNIpPc6TbviJjNu1BMfQWXmKuGVS2vhdv7iNR9eD62ZFsygtVQpvpglVy8Ekm/j6QCEVd6Pw7rerHUEXXO0qs4B3XsoSnN9K53W9cFB4Ccpss4UuqtHr7GyPlaam7crdP2MseNnXwxL2T/G71kwJXmFoIuuPelXDV0Y2f8ytBVBjaBtrF2XWJ24wBOhazsfIsEw9vG2nUcBCodUueVGWCgamzOI1hVxz0fPBul9mbnxsYcf/VZ4anj9/3teNdAQdFlRfNwORaK80MGtBLVrbTYxmdGnfarOqjOi9/kFiCkej7KtwBEqMBw2yIXji3ifX8bty3gDwjRnPK0SxZNmWJXddXKsjIc7dySGP1FQ96OTwZxR0197TqKqe+7+YLSr4qRIbIY5AjfWpK11AAwmtX2yocuGsGKc6qUuEEdAjwiGTpCUMXnLuv/UF7Bah7dq3BK882xKta/VQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(2616005)(1076003)(38350700002)(38100700002)(2906002)(41300700001)(8936002)(44832011)(5660300002)(8676002)(6916009)(66899015)(54906003)(6506007)(316002)(4326008)(36756003)(83380400001)(66476007)(66946007)(86362001)(66556008)(478600001)(6486002)(6666004)(52116002)(26005)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?veijyvrgqxR3cF31T3wF64Y033SxywarrgPJkUHa+gK3AEffd11UKiFwn/aA?=
 =?us-ascii?Q?ydDHKYam8BCD3oeldC8bcEWX1BkRFTju+Gzv7vHiLVQ/FLzgSL2xT2p4sRUv?=
 =?us-ascii?Q?Wl6d1vpieNzHAW4Dl6KVft+RAVlsXp5TA3N0QZ2LLF5t7UMQAo7NX2fRn0LA?=
 =?us-ascii?Q?9IX2EmvFivC1Q3JKrDvo/cg6dI3PSOJ89J/RZltkYYTksmOn8iv3QxUI0nqN?=
 =?us-ascii?Q?uMfpytDnxO/sFnTaf3Tf9OkfOszG81Y5yiMFTYO4nzEn/nOpLujbv5x7gFY7?=
 =?us-ascii?Q?YCa9UnryhDqjuzGjyjvx3pi1UlagPT2OjZBC9KwmxS8TmByuO1wFnVylM7bR?=
 =?us-ascii?Q?W0LfcTPBFVCr1zM7nigfCV2LEbo/M5WQr3S7/Fmudyxpnr0oC8AIHNgH+v7b?=
 =?us-ascii?Q?tD+5SHz4H7bSQCdZY37KCIAQElZhGeU3Ntmr0utOH5elqoc0TSLbEZNT9snE?=
 =?us-ascii?Q?h4l2yTeTeVkygm7441lo+1VUsH04pGGA8VnVAv4A9pLlngw3E1i6HNg1FcZW?=
 =?us-ascii?Q?CkICh4UrbArwff5eO62rwOJFRmrd+3yv+jnEZv+2SS8rjwABEzOv6uRcEuIU?=
 =?us-ascii?Q?8SQtcv55LQymq98257ey+DrLN8QbnJbwL8RhcDgbwVTMloCHt7zroAUas14P?=
 =?us-ascii?Q?wXVtoniFYLGL9ReQuitIfPaJShognK9XlBXFoyyaaTdBKpIxu7G4jWN/8utV?=
 =?us-ascii?Q?4T48Rsb0zYb85wUEt5ETmjczTIKX4L0lRZusWvgpAc7E+eWhAfpG5l2Z72SP?=
 =?us-ascii?Q?/52W8qTULMOlB2wdJs3PMlqaXa+urpJVTJssAhDKG35Bsx/ykLLpWFh+BWEH?=
 =?us-ascii?Q?G0AYB7beDkDueebc8L8chsbcf6TX+fnfpP7PoFZGeJwxIEc/n+BJVPdjh9e6?=
 =?us-ascii?Q?1sjxq7koH3SjZpHDxocDdzkzQIYo3jeSz+MkvbhrpY8mw+/d4E15RVQUAbZo?=
 =?us-ascii?Q?Tznxo2nw1tUGmZU3/nGCWTghkUPE0HoxYK0imgYcLPtii/Xj/8WE2J599djZ?=
 =?us-ascii?Q?VWuJA4OGr51zcOPUqnlVygfV/CvOJHbyFEG+L7Q25H407NPMKBtNpRs+2XOY?=
 =?us-ascii?Q?Ukw0euDmwnpYU2wRM9Ebz/x7LKzUC8+kxBNCJbPAIKobI98e/JMBczMZ00aN?=
 =?us-ascii?Q?vxzBGBVg6Jv8FiWQ1/Q2hoEXwrq5Upe5GKZchzgdr7/sRQhD9YN0avFyrGuo?=
 =?us-ascii?Q?lj/PCvvM/58oF2T5OwAbQXHBcXqZq1oipItXsNBJ8huCgIAsZuakME19Ko/c?=
 =?us-ascii?Q?KlfD1eLhlLzg1WYxOLwkzOg49ASkwxVrXj44bDLiFttZu3sC/miuDFJJywuc?=
 =?us-ascii?Q?FeDd9uN6J5L+588u1FW41TDiMFHdLHp5UsIQ5lZHwOq7ZS6jW2TgrC9vLRhc?=
 =?us-ascii?Q?EqdKNysU4HF5RSnjxSbZKpAdeMSfsJQ5+H4zl7M8TLiO7wTcq2bWvlTG7yb4?=
 =?us-ascii?Q?CaArBYvW07YpBH/Dcuhs6ei3Mry8uMKDoUI+P4bPZ4KFgVnk6B8k5Zp4kZJx?=
 =?us-ascii?Q?Os64bqiw6UqBijpoF9rVMZbjd3mwuTK1ZXFxF2NsDg6UbqHjD61NckskWlnF?=
 =?us-ascii?Q?d0ZcOPaY8oP8DX05OztZ/X2Re+Aaa1APGXgPL4vfZV32TH3h5w6EdjNzNcc4?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc65004d-fc90-4b59-fa44-08dafdfb484b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 11:08:12.2122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhvE8w72tktKIb2fo1UFeQ9h4MmBh66Y8/QHRS4CT5fcoxIYfAdsG7Jx9qAlv2VgZR6oVt/VArrKXeSYoRT9bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7173
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following call path:

ethnl_default_dumpit
-> ethnl_default_dump_one
   -> ctx->ops->prepare_data
      -> stats_prepare_data

struct genl_info *info will be passed as NULL, and stats_prepare_data()
dereferences it while getting the extended ack pointer.

To avoid that, just set the extack to NULL if "info" is NULL, since the
netlink extack handling messages know how to deal with that.

The pattern "info ? info->extack : NULL" is present in quite a few other
"prepare_data" implementations, so it's clear that it's a more general
problem to be dealt with at a higher level, but the code should have at
least adhered to the current conventions to avoid the NULL dereference.

Fixes: 04692c9020b7 ("net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ethtool/stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index 7294be5855d4..010ed19ccc99 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -117,9 +117,9 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 			      struct genl_info *info)
 {
 	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
+	struct netlink_ext_ack *extack = info ? info->extack : NULL;
 	struct stats_reply_data *data = STATS_REPDATA(reply_base);
 	enum ethtool_mac_stats_src src = req_info->src;
-	struct netlink_ext_ack *extack = info->extack;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
-- 
2.34.1

