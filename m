Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87A96E9F7D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbjDTW4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbjDTW4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:22 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2070.outbound.protection.outlook.com [40.107.14.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0A755AA;
        Thu, 20 Apr 2023 15:56:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/L4bMmhIxqcCps26KJ2qsIeXdBZz0tvkVTTfnoOvW2sjSMJnjf5RZuRW+PGHRQ3jWgK7yxhm7yub/zA51sfdcmqZImmDHRd3xW7k/8/v1xV2jexpvYWU8OPdc2f8a3oXxqbHO7anv6F6qZ8q4SJhjf+HWygLTKf9uGmuLIs4h2mH5/AZZDaxNok2Y2sPTeIata/3x5G9IvaDev/r5ISQsqHxA68v0M+AScsFoJAiB4Os9zgRxgtb7SXZ4GnGrOag81N3cif8wxyPn8YD5iREC5WLBFSN3i0fbCd98EFsVV6/mY4BpmBbyb/+0MDT7tyV6nK9MlVPJR6eyPkMjWdQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BNBllRY2kMskBkefqHjux2zmaTfona/fmbPs+u0Rwss=;
 b=gJoi3xET4UN+LwJin58naW9hdlvjky0lPvtbUtPNPW7V4e0kWIQfBCBNraLU+cwPcmxnAtMXlWMM24aCYanIke+959LLrM/158V66mxMOOjuCfig+P8UmqsU26DHb0y6z55WnTgUeOrJPHSQdmRmJNTXHjJ+Zt83D+ZA0+2qPb4HsUTq2tW6JuD38/ugkVG90BOhoPcR+b7rMaLXRaDzfkpKbrYWUOO8iqQ9RvG0639k+iC4vV0PoeqZDX+bIVymep+jPyzj8HbskeadDP7ER8jqcJVH8UZw3Z8jb4kjRt0RpfqBkCXhifS412c7lfyWBheb+mkAZswpuBwtse+toA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNBllRY2kMskBkefqHjux2zmaTfona/fmbPs+u0Rwss=;
 b=DDjjMJ9y/LrAhXaZG/guDhjeeBUxhAFjTrYxXXxmPakoe6AjuDouAZqYX8eRPPcflbUt5VO05Tgr+bse0K2mqkVvpzrMfMJ5uk0hY3ad+riEbflS9eUA1UVBDgcc8FK9GVfjlrl5X79/uQeELfG96nRxa6DoEg5ENxzuTdKDYKg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9213.eurprd04.prod.outlook.com (2603:10a6:150:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:14 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH v2 net-next 3/9] net: dpaa: avoid one skb_reset_mac_header() in dpaa_enable_tx_csum()
Date:   Fri, 21 Apr 2023 01:55:55 +0300
Message-Id: <20230420225601.2358327-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: 740889cd-4b4c-452b-e7c8-08db41f27168
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zopiOZN95nyFLCtHFwczPWGx7TA7CbxOHhKxAWSLwRjhAl2q6nV7VDoP32EMj2sQYle9m/SJF7LiBcOQovZHB8Wml06JL1BwwfAwdhc6pjRRBBmo4KjOqeiozWHK79izFm8e3+ZbyVIvt/x7Z0tiuohIooTJD3JiJ/DQ4VXCTJHX2mEHZ8GIJjXiL7mpyoKatNfgpn2ZOJBz2eFFXBot8/Uxn3lsndcpaJuKwBEhjshSrxhk0ZzW+n3bKfi+mXnx5paSIBAiNe5vuDKAD3WM1l8CrIY7Hd+r5V2LW/K9kKIE9AFvW692uHznbDmrMYj0+IQaijghkXglUqvqFoNbnIU826v2dWjYt43H/bYpgd4O9lpKDh5wooZSV3oCf05+1CpAfW+XfnAJckq0QZnLVq8Vl5n600SY0OVYccd3aiL2sxjN7OLw1ZUzw1o3wSEg2FUKWik0PXBqDjFLwHSZ/mKmFYeO1GPbnAttyXoV5kpX3554lU0pbmrRRkxLnwYDWN4k6A69qjWFq2/7H6mdcccoRuyj8U1SdHyhl0hpAcEpvwkZzyAd5wdk/5MCBJhRr1CxRMtHZ7rCqVSKgm15wpURwGremURrdg1TLN6O0K8iqw3ivD27Yp5CyX/wNMbr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(2906002)(38350700002)(38100700002)(86362001)(66899021)(478600001)(54906003)(316002)(41300700001)(66476007)(66946007)(66556008)(6916009)(4326008)(26005)(1076003)(6506007)(6512007)(6666004)(6486002)(52116002)(186003)(36756003)(8936002)(8676002)(83380400001)(5660300002)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ae8Y7RebDJgBCgaYfNynzCIjx+DQODXw1jbJ0Bfnar0bb5Cj+ROCvwRCFOwd?=
 =?us-ascii?Q?GDKam3Go+tnZV3Gcs4oNxF7PqE1QwoFut8b8/zk5MsQTkvx+zd+7AwHiQ+KA?=
 =?us-ascii?Q?5nGXKIGQZn7k0ntMO6QRrGfy+5SjHmc7hBYwXDSARj76MGbJuhyv5o63PK9a?=
 =?us-ascii?Q?5PIOVp3PDTOf0SfeN/dPIkLF8jxsxgCq38zx5NSvVUFh4WPoauLqhFpvZmPi?=
 =?us-ascii?Q?bvyNqRSjg+FxZaC0A0XtdbHWhsfRN3MQEROcBfbrModaJzr5vXSLgMAIRHQr?=
 =?us-ascii?Q?8WzBrTo7h6n3xDgcBBswZ4aCSjEWEDanWCBcNuoSVYlgEY/nXoMTXpw/iuja?=
 =?us-ascii?Q?dyE8BB9mUs/kjTtNpZ8vFzDs6ogLIuIAoGnJ4+4jYgDUfPFg5lqvfSbVRZXx?=
 =?us-ascii?Q?S4+DVZl6F9j1TUr9LNPhCvbphbU8YN6oIXij7P+gv1/fXz/Y8s6xUuL7YfVL?=
 =?us-ascii?Q?01h49GKW08EdYEJkrOhc3RO3cxMYTLlGw3Z6hktW62kDwpB3rQsVpgOn/n43?=
 =?us-ascii?Q?tf/tv96OU6sViEQl2A+bh3c0IC9NRQLAxPN4o7kopVIBoY1WNQ0xpT+Yk8md?=
 =?us-ascii?Q?Bhjof8ZsJ4+Dvtpn0vI2zFPdfGM2oDza3bHzEQrTQfueQ4S92lKCpWsr+D1k?=
 =?us-ascii?Q?vXN/nou3KFIa4wDNczajuJIqCEaL072/kZdPYMLfnowb5Eq4F04w/h9+EixX?=
 =?us-ascii?Q?Wafo26F4oVadj5KhdC+gMHTz+UaN0moLEDIAtZV6JQKpXRMahXGL5GIfoISy?=
 =?us-ascii?Q?lCTbax1090htrxtaj2VAbmdtpFKmWHMU38hJVm1wAq7gVz+/W6wetdkxT0Vu?=
 =?us-ascii?Q?DkqZvd2d1dMHuL0ZRgCtNPqRnlWBPfGTVby9BvRS8rSaw6OoNv6xiT3VjIdu?=
 =?us-ascii?Q?LlhH9Ags+wbumNn5qijWOGjQ0uFcaA2rE2JdyXgi6gvoBRB3y19nySl+jBB5?=
 =?us-ascii?Q?yxBhAvtjT9wBVv0h2ihB73uvHx36sl+HD5IUj3YATPdv1NGxKFrz6KntEFjy?=
 =?us-ascii?Q?QVXzp1iBZmNuZKbMQCdfjEnyf+t85cM9TnuTgge9l0sKX063otdum7kmLDbn?=
 =?us-ascii?Q?2H6zPFx46XkShTw2vaFkZWnQ843VPtEt65qMZrbQpgrH1T2Zc7+LxTO+pvvC?=
 =?us-ascii?Q?fRkfWOD3zA7EXH6HeHzN0er7OmkA2U/5ENY/odwObTxfYWyv0+Ii+MhrGZJp?=
 =?us-ascii?Q?0+xR5TJgviLwQwbAe9oHVYexOLKcKbSjZbTyHcptgpQvZ5JN3oyOybLq+mGr?=
 =?us-ascii?Q?08IRdJbIXejjQetD4VaJpf97/0wooxdgH5OZZcA+6TfqCJ2wiCD+AyGvIEVT?=
 =?us-ascii?Q?medAh6AxPH00m3M7scqlqjjE9uzYS8azlprifTupo25ml2nNsFuUjhLAuC0/?=
 =?us-ascii?Q?2Gd9V7yxCodDZgflxjLdSBjXCc2/dS6ESSffywK1TC6coQhXpHuKN2XfWvCN?=
 =?us-ascii?Q?rzmpAuhzxO8iWz6nhgCjoQ+Ynqxf23g3UY/lRedBRo2i80ZVdwAbQReIs0O3?=
 =?us-ascii?Q?CzWFEAlsKFiH4tp60aUZbetr14/0gtMPFLkIfBX2MShZT9g6YldNM/q0y6Lh?=
 =?us-ascii?Q?zkvdJVni94KE5+tJBri+Nv99oBRleanfa/MiXt60mPhA1rghmsJhcVDGkd6P?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 740889cd-4b4c-452b-e7c8-08db41f27168
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:14.5078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEhX7h+3Rybu3H4Yzy5bRC6SFLUxCzfPRBnuGz8RuVfC7gw8T0glfSR7II7TkrjpVQFiO/F5bmU59Kz/mlOaEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears that dpaa_enable_tx_csum() only calls skb_reset_mac_header()
to get to the VLAN header using skb_mac_header().

We can use skb_vlan_eth_hdr() to get to the VLAN header based on
skb->data directly. This avoids spending a few cycles to set
skb->mac_header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Cc: Madalin Bucur <madalin.bucur@nxp.com>

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 9318a2554056..1fa676308c5e 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1482,13 +1482,8 @@ static int dpaa_enable_tx_csum(struct dpaa_priv *priv,
 	parse_result = (struct fman_prs_result *)parse_results;
 
 	/* If we're dealing with VLAN, get the real Ethernet type */
-	if (ethertype == ETH_P_8021Q) {
-		/* We can't always assume the MAC header is set correctly
-		 * by the stack, so reset to beginning of skb->data
-		 */
-		skb_reset_mac_header(skb);
-		ethertype = ntohs(vlan_eth_hdr(skb)->h_vlan_encapsulated_proto);
-	}
+	if (ethertype == ETH_P_8021Q)
+		ethertype = ntohs(skb_vlan_eth_hdr(skb)->h_vlan_encapsulated_proto);
 
 	/* Fill in the relevant L3 parse result fields
 	 * and read the L4 protocol type
-- 
2.34.1

