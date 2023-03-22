Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598EC6C5A98
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjCVXjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCVXjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:39:02 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2048.outbound.protection.outlook.com [40.107.8.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA8123A72;
        Wed, 22 Mar 2023 16:38:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnbGuASKJyrwvVK55sI5/yLJb3Gg5zcZUPu6vuAzCWvgiM0AFZpFFspnBPh1/M3a/7o5P+NA/GBGmGCyKY6BBZQOzmrhUdUtpp4f4/eDRjdNJppX/qrLHT3ZaKj/vKioEtoYrLgJyrTFk6DVzB1Pq6EHznZNsBqKcxj52eyVKYS513qM6I3uiWKDe1eVnk/70GyMiPN4WFQRQnucQ0lRMXwrxNGgfSQSNiYha9w7Wa8MAhz/DKv9+LsI+PnudmJGI46ywbEYGdu7TSzR8VzXzUVpVH7CRW+2OVjVamIcBi2bd7R0siz1k1ofbEOGvIF+uW/GoO26BTx1TXtf0Prxkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gvZWsCCyqAJ0UnMvHTS+s1oXQwgirZc0CmpsDT8QaWw=;
 b=l9BaHXyr3ae0Cc7s4tMmWqp0S4KsjmMGwwWCxQMvtU7V7RX0VZsRWjvPMzSjbAGkCDx9NHlYvaloZUrPMRiAQ5jjoxbnRQqgFDEtvb6Frz91JC1HZIRgrIAyPqOyymZwBE6v63SBYh9Z+9n5M7qmDcmFJ223iJjeMc+kpWGMjxy7GxWeYVqG1Jswlm3Mhu4Q25pY2ZHpPDoCByedcX2en4rSwnPutXdpU8bp0r+Pt2bK/v+grxDFMO5htdYnsfl3GM8dvb+Jm0+IczGC+3+4RpS3C2FdLm4krRJZvKN1Lu2zRaJzftJEdc2cNItFo9SooRN/AfQ5MBjcLdJmmMTupQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvZWsCCyqAJ0UnMvHTS+s1oXQwgirZc0CmpsDT8QaWw=;
 b=ibahf7UA1CYvHfbk4pbN2KMUOEilBYpgCtVTArjCEB5FOqN1OCppGdiNcDDeeSyuaO118JU2EtCCmyeYme5kikg15mkZaDBxTHMsPr0DpD7O60eUogn5y024hnjvvwmX2r2gHn5/DHFAX3Dcfys8gPGCs+zB9qOfvLOKbvuiXdw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:40 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/9] net: dsa: tag_sja1105: don't rely on skb_mac_header() in TX paths
Date:   Thu, 23 Mar 2023 01:38:20 +0200
Message-Id: <20230322233823.1806736-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 26f6f6d2-24cd-40fe-ba01-08db2b2e910d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZyGIY/Mby61nmcbD8uuQRQ4+HADOft4FJ/QrDIZVk99Kv4FXrTKM9CdpKHvPX8mPGuxy5SkPiPnr3V7NCAJZozDFLI2ERIw5Nvc6eEGwu4W6lrG3pVhrybN/KVN4C28vDbTG4lCEyjQ56jT3Pa726RvQRy+6ixGLVa7CsmFPV7wTz3nJapa2wA48MoeI5lgqgUAox2QksGboUV55DhftDSoDdPvwZ9tMEAiz6yvemqtwGzxbiP/Q5y2h70d+OcP9b9TcSqI3BerPSYweoKwNp8wRnDtDzT38IMnBsquX6m6TehSa9semE6QG5V+QY20LO9D9vtUqS9kLAXSgZzDh3u9cl0hXYOcmMd2M2hnmR1sqRlCZbsWSbInnZV1gwnwWZ45M+BAU7xQFsSIYfDAFMNXoiZy7PR1T8KYHEWGTXx3PGJ36Z6b5FE8cq9Om9u+NXenvR1CFC3B3k6+TxAFLhsrAeNiX49XiOBg8Y5dcZu9zJkvjpY7XAfX/sqxczivEVHFYfzZu2wemqNwLblxbD77YJNWc4KAPUSCZjH94WaacTmNto5NaFE1Z1wGgHJ1f/Bs171pEXszX7I48VOZJEVgtYYG2WcgLIJqXA88wfU0GSdsK5q6XLS6h23/cBFX5GzlegDIR/RThet2oGzPS+xTbKkKp8IyugwBvdKbXkOA+hZuyhunADx5ZetY0z+hm3f5GT2aV529rEk9y4+/tmxlIBu4miqabKTlwiAY5FrID22kBZu+ls5H6fXrcDTp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(8936002)(186003)(4744005)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MOFnQdWMeNquhs/DbxylVnS/HVsfon2Lco7boXhpWYWDIjwXIyU8feE7AIIv?=
 =?us-ascii?Q?EH63zc9uOcF7PJvBlvzrxZrPCP68eK4F01xzXthF67XdhzdnaMN3pFtviS8e?=
 =?us-ascii?Q?ux07VaNG0RQZFB6eMfYoN9ZcxUfIgf6M1g+XbqucCPt9tqdsqLlURq/7oI9o?=
 =?us-ascii?Q?AWT56BAj7RphuX1SwdfPw5QALiv6s6lfp2E5/caZJYgPly7WCZtWd0OW6ylE?=
 =?us-ascii?Q?SmxFkzSRwQIFJPlCwE6kmJftn6NKeOInmEqiq9WgWo1J4UjaiAr3tUGxewh2?=
 =?us-ascii?Q?PQE/0yoDuxj6lQrUVIWNbUw0OmgpfGjZ+qjL/S7Gu6NEE7U8bacjDtEmJ6O9?=
 =?us-ascii?Q?xnjkDV3+uj1vr2eISuusxhy6JP1eCVbxM7H9u07ipsx1vqKmJqJUemjpguR+?=
 =?us-ascii?Q?sMY7F+2Nu006dseT2kZdxcCw+54aobvUpEvqxEbaLkDcgDFb+I3Thlnow/wd?=
 =?us-ascii?Q?iPLPjeOl5tOi6ZqGbJ98PBWCWr8rZ7wvSnib0HKPdCrqYvqPW0d4gaW8KjCN?=
 =?us-ascii?Q?VYyRhssMFUHtlZ6yvKOeK88wZoGMdECrrKtE9wwYAoUCW7cbrnjj1gJbz0j4?=
 =?us-ascii?Q?3UIb1KZ3k9r3p9vylbfa1JHjS1q+QIsFzcsOWb4+i3LqUn9OKYPU361v7aih?=
 =?us-ascii?Q?qONqnojrfUmgTG3WxlpUADmzGP51+bEerVfTbYtsq/TBViAyotVe+cuvN6J0?=
 =?us-ascii?Q?cTVZcLLUv3lcVxODyHizW8/DTNjlquiWIpEBk7DTCfk/zEV9jVTgwa8O89qu?=
 =?us-ascii?Q?dSVEh+mpxVoL21T1cDMh/whmbKkc2plr4Q/pjxGA29pIf780n7KR4xcpmxaH?=
 =?us-ascii?Q?iOdtx+qHyGO670a/B7NpsnIc5QswIAvJL4BolIuSu8cnOqG0qj1O5UFhkMEW?=
 =?us-ascii?Q?aKJsJhSiCR24heyJkfUiGDxLwuIePcJEdQew1TAufiACID5XJAhfMH7ZLpHY?=
 =?us-ascii?Q?CVlpaUIk9anhRYIJyDmNvIgizRjfF1GqhIDp/ydXV5Z9Pk/diT4nouYJS00Q?=
 =?us-ascii?Q?oS/tidHw28Ntx2EcxkvoFn64Dd7RwvLUauJHPYJXphX+2XUj7EusM26cbQoj?=
 =?us-ascii?Q?EM02y3blaNA7g3nogT5l/OTsGR49O99Nf1U63b7o3HMDBa7J53AqRRuR5j8l?=
 =?us-ascii?Q?sVeAvcM36MpizFXTYRMsvr1G4F48UsMBRZr0Oaka3maxPVfygarHT5mDC40J?=
 =?us-ascii?Q?LlnrrjPuBZ4w/bfJ60ING90HSei/Sla+laB9qWMJGS11mvmzKfIQ4z8jIgFb?=
 =?us-ascii?Q?zpSfGOwYU61mkdlajZB9b+PlZXfz6AFRe02s0iqvWLnb+fj9OxkbilEJ6x91?=
 =?us-ascii?Q?DHUohEr6ngVfwPoPTK4NTHxWVV3TNWHMI9GbpYi0ITQIV+GrNE36YxKXt0Jo?=
 =?us-ascii?Q?20HV1aTsU6fzmvgBP5syUcxIZnvD1tcZU8zWG8ad/ZLhBIbdvUZu0YTVJ9ca?=
 =?us-ascii?Q?zAMY9ANjB0KYtWDaTdbAEX6r5dqAJFXaw+Vxu3QpRYpE8sYXXnRtZ/e2F6fY?=
 =?us-ascii?Q?CmTiNJqXupZ3HCe3SDDv6i3ewqKDVy/Iov1Im1/J66QjgUqDr5allWvxthzk?=
 =?us-ascii?Q?Kld43Acv0kOjNr3TWOY52bE463jQOjdUokmKdKQpgN3NGW2w+C1L5hq0/ONu?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f6f6d2-24cd-40fe-ba01-08db2b2e910d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:40.6549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dTpbyWDKq3sDrrTeR74HpG3/4q1fNiHOOeaNhfx9kGAOvaWiiS8eNgOPOFBlD+R0Wnft7OJkfqspFEWzntV+BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7263
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_mac_header() will no longer be available in the TX path when
reverting commit 6d1ccff62780 ("net: reset mac header in
dev_start_xmit()"). As preparation for that, let's use
skb_vlan_eth_hdr() to get to the VLAN header instead, which assumes it's
located at skb->data (assumption which holds true here).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_sja1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 1c2ceba4771b..a7ca97b7ac9e 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -256,7 +256,7 @@ static struct sk_buff *sja1105_pvid_tag_control_pkt(struct dsa_port *dp,
 			return NULL;
 	}
 
-	hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+	hdr = skb_vlan_eth_hdr(skb);
 
 	/* If skb is already VLAN-tagged, leave that VLAN ID in place */
 	if (hdr->h_vlan_proto == xmit_tpid)
-- 
2.34.1

