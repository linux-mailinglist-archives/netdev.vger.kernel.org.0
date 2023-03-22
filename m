Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAB06C5A92
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCVXjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjCVXit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:38:49 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2048.outbound.protection.outlook.com [40.107.8.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F23223A41;
        Wed, 22 Mar 2023 16:38:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoQBd+W2fkNBvHJWgkx7y1/LtGiTKXi79xhpdnbrlVy5082jVZhyVKu2VQLXPQS64VN8U3eY0lUiMhAppb3qa4ynTgcPbS5szP15xhGSss2cNBkuhIQbSmjvwno7qia06d0syJQeiOoD19MMEoCeemKG6C2Tk0uCAbqPZmB1FsYfH+/ad/skNkqdYj245b9UVzvjTbAjGAZryx3WT/eAPBXoZoIvk8DoFuaxmbRZJaiyWxKZ3oDc4lwjNmr9xNm9602LQxxACaNSarFmMWkhDscf4HXtMUPCGF8hFPhJdtqBXcrT2GsjTbW7JuN233lDoleJq31REIGPNuy7U7si+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWoNA2qGlTD0NuWmXD6qB3Ml+r6i7UOgwiv8FaImTM8=;
 b=AVP7OChsL+YwSaeAVgtyEm1+lUZGdfEm2OR/cI2cAyKz2UbkWp+asbZLiW7gHajA1pOdGhiMNfzcLRDllaB4mcDfJEfrN4tXEvwkgiMKHSA051nRjHgbu84MRv0FZnp7RV/tOXp9CR+R6BqkyOS/NmMUvFWXBtd5awQ8HJbonQkY6E8e6UeSE2h/6kHWxzmoIcL/7BwtS0MS9okHIV5JgmOxiIPNO/BtAD/hDLgkidxhevPegjNBx9h4hyKrtSjZXOP4E5fDHj6E1CeZX2O/BJY7O+WlZ/gXV+UD0tf4roJL/sJ99yDXCTUPMMNygJfSnNSMuJDLzVt+DvOAgVFcTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWoNA2qGlTD0NuWmXD6qB3Ml+r6i7UOgwiv8FaImTM8=;
 b=U1Jgs9chbODeZsWgwdMMGaFADzDUJ5Q8+l2zBi6rjvo9o+70vdLNW6liUxClWMcgDnr03ngjmAWntdwnRAhD3YIkc2/CUkWfqa+q8WaaeeDe0J3cGefQGljUEGDMIuCkw9y9tXtUpe4h2kYgbzvJxhZHXtRBofahM4fpC5R7J0I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:38 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/9] net: dpaa: avoid one skb_reset_mac_header() in dpaa_enable_tx_csum()
Date:   Thu, 23 Mar 2023 01:38:17 +0200
Message-Id: <20230322233823.1806736-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e153b579-4170-429d-6cc3-08db2b2e8fb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12qFDzNXxBtwnMzMx9dqUAQs3yzfb9dPTSTiPgxVM+R6d2yVnGz+Bq3aYmvrTzFZug8UKiIAbPIRYkn9vR7e9TXqvxvVK0CvGKsCGCJqY3QP10gZrp/lKWAfqisUTuwDYwvHpbeuLH2XMtHNyggT0wQLU1Qj+BdMa4JmipMNX4Y9dgoyCSepUyK9S3elHv8Ixqvs3A/kqjOxxuO+xGvn1GHkagjYQMCt1gavc0lqLgwHYZ6v7EGWVgzGXqKDO1993vbJb+getRGrS74Bwrb/M7D26aZxgxrzMpiQYicV/061KTPK0v/xjEhYTYfcilyqVVhfRqdXK0aGzprjodVbN9PXysHOC9y9D0nyI9aH3eUTwwOIA9J/eZf88vr+xEHddybm5uWxMuwPV4wt66dHjOVfA8IRwd+dnMO55fIDPf1JIUrSu8ejlm4imBGLKLDkd2on1wbzdnB1K2LsKA3342CZxOTjhizsKofIC9wAryEEVrqEtLNyDPJiyy8EphOHTkfZchwn2lljjLm/MEWvGypkHSkhgSvUPoj8buHAzTQAE7qMP6BR/UMds5GHx5+mr12BASewZuWWiM+fjEf/VC9hEid1Mg75hL+07O/LkXZEaLSeIzqxTTfTyjS5/6WBJgESzuOGreH2y9KuXW/5aHvfI92R1oEB2GDbFpGTSH8T3gfp3SV8VIb+/o7U5yJXcR1JsONGF6G+GNqAAUiqif2CYrPS86wDd5WKeo0xFArdoREzr++vx2C3caukQqMW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(66899018)(8936002)(186003)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HdXlWNh62kuoPvEAEOxZc+vAqB5IVImmyiZXHWXdRjOqGVprjoOKB+hb7TjQ?=
 =?us-ascii?Q?6B+d3gdNH/kJ1zCP4s+Qc//3V1cT2mBYnecetQD8nGGfbKPhuEg1Rhl/x5Zg?=
 =?us-ascii?Q?UAyBqjQA+v1CLfZX9FIfuJ39iwQbtNcg1OUokWVqtNn3ZDzGHnGtg8tATEn6?=
 =?us-ascii?Q?r8ZH7o+Oyqb3eVWCyvkuy3OEC/xyAYmdNEe95kxePJhVQjhJAViTJrLjrEOe?=
 =?us-ascii?Q?Vlmb+3mkZTtDohmOb00JhkgxldiwMqxq3io4sqNrR8crKv4a3PNYixamlg30?=
 =?us-ascii?Q?Lk1+TPbxXpoN7pBoeNaiWnEhNT9hj9YKJjML1d0oZZ2V6gJYzmXAB8lhsKt5?=
 =?us-ascii?Q?fTeknc2iwvirJqAPC+C8V+VSHIVrUO6HSDFf9T05KGqw1X4q3LJBFVNq3eZO?=
 =?us-ascii?Q?Nw+OTFyEIcyrGhhOMytbaNDm78LUz83RbxvtE5QWhQLP8dEpvjbXNxUMVScM?=
 =?us-ascii?Q?t7dMlNXOGsl4JopsB+gj7zvwZ0q5wORbl9/ypO2xnADfMaUBT2VbRr+J5Ubs?=
 =?us-ascii?Q?ammnrL54VXeaVVtIQScKXgebdD8P2yf5zTsfeqjlFvL7XqZKojoeziw0cZyz?=
 =?us-ascii?Q?DzjWeGnMJOLT6HSEIwB6lIYcA0JrqjsaRFSIusqUMNTOW2xA7DddPnMEqteC?=
 =?us-ascii?Q?cJCUL8XX6PklVQdIKvmh1ui7sq73QIx4oZ5BWvIDC6y/pQ2oD7xwdwDOhWXy?=
 =?us-ascii?Q?A0p9u1U0hYuLT2n+Z7K/7OWkEAR5Yd/hYD0lYWtlVZf9zE+gVXn5PzVva/ib?=
 =?us-ascii?Q?r+fYeUkTF00jzT1z/2sTgG2zIF3kdR0bD4/xRnS6iRo4wHb3khwAaJxtWu3x?=
 =?us-ascii?Q?CmIUE/IM5LnsXR7kuzU5Ub+M/0zoqiMiq/xx2IWiPQY2vHktaq8iD09U7h4N?=
 =?us-ascii?Q?YpAouvTvZwrcQdyNys1Q8VSLt9gmoqO+P/hevOimgrX9X/9u/UF+ws78dNPV?=
 =?us-ascii?Q?Nzge9O6P7lRG3OVkUyP97CFXnK5pEbIXn4JZBc5HtcCiGJn0KUKQ2Z+1Pgqj?=
 =?us-ascii?Q?BLb5Dw71QCbm+TTYm1zUVyGuf+rUYo1WfWuaX3qnGGQ0R7v8KU5NE/IkK8jc?=
 =?us-ascii?Q?vBYeXv6CmV3ncbffkHh1CWOMtdVd326Pqlmqqm0c9xd8OMKT+CbAXadmm4BL?=
 =?us-ascii?Q?QkHAA8MR+ho5Kc66rj3/03X7XUodpW+Wa4aYmJjxU617GJFyPWKdbSpI1MCr?=
 =?us-ascii?Q?H3RubJY+Cud4tASl2zKhRiHJ3Wp/urzSYB82RvJwG+3eNV1prOozIu+UDSDD?=
 =?us-ascii?Q?dLwnGEaJ7gWBnCFhOoIssQXPdoZOzMVjBDRuxSfU4u0ceZyqopppe5TYmfrL?=
 =?us-ascii?Q?SEOK9lNBq5QcMiIUFEnNOm5PpBo96QCmE8ErVkzg/tLVVdkdqhoF/r1mbG9N?=
 =?us-ascii?Q?QTDtui7DCcHfxbQbvoNtTpjYFli2fRV1nWb8B/gz2Bz2PFip5i4mLAUPObvz?=
 =?us-ascii?Q?KShf4O3kpX1nybNwJZY6u4KF/13kGHZM+o1cNT8b90wAbX3PbdhpAqwKxeM2?=
 =?us-ascii?Q?uAYH1nd0HjdijsYcMg/TE64AQLChfw3VfMeCDHGc3wsCq/g5WJvXYM9GF01w?=
 =?us-ascii?Q?/Aep0wxmiHdM7vRgKNsKh/rxzTUiw+zRe4H04UFupk7geMoogWmDgb92DJoQ?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e153b579-4170-429d-6cc3-08db2b2e8fb6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:38.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNPfb0VGiv0Kh2RkZXC+eBSwgmb3aP6dl7z2irn7+s9JBzVMdW7mzhGUr4bv1IB5/nCRrIPiUcm4PEX97JjJjg==
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

It appears that dpaa_enable_tx_csum() only calls skb_reset_mac_header()
to get to the VLAN header using skb_mac_header().

We can use skb_vlan_eth_hdr() to get to the VLAN header based on
skb->data directly. This avoids spending a few cycles to set
skb->mac_header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

