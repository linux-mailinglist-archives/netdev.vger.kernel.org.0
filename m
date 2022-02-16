Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B654B914C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiBPTh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:37:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBPTh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:37:56 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70045.outbound.protection.outlook.com [40.107.7.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568A3C1C8A
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 11:37:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9LjhKl5vkVYSg+akei680+KL493c0UEbul4rxQBiGcokkmfXkk2uW/SHpwo7yFMiJ3zaG7HeCxzrgBcUYhpuAu05Y4dLtz+/2mjwFpuwXWO0nN/UvS1NQ5P7uz8SU1742mkpt2ZMHpd6WpFUUyLUgn23K9CDpDzkHByc2x0+kj+iKqcUiGdmfsVzku9kawn/e7PEsjhvawWH9uVr8r8KPGGVtc0jVq+8+p1AtEW+Zy8YyphIOUrDOoxsQ5WcvFjjnKZM8QmPbbIP7oV5ok6ultNQ9HNvXuNYtwTSbSZCNu5JToE5eMmmFppRnkNh/eOOnCF4R1XEahbLXPt3Ui0NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDBBEThnE809vchOY2CIrO4jr+oRRyw3otwJqOCkM68=;
 b=hX1vhoaHqD6wW1B/7OKg63C+1R/GNvEzd/o1ufvDrPB4/KxL31Ws5runHsr/w3GCZcrdSQ5f5ZI18WND3d4XPgtRmwAzVIcq4N7mJ5K5Fnnwhn7bVLKNx4qnTTeIO0nW7L0qWNb1XoMpQvkxWE9QnVwspuCv0a4Vaa1nbiuNAeFASLguSGVPULQu9s3SmMDs/LDzEJqEvYu5gOlVXH8KqfKpsIYTlq7etWcVA1ug82MSfMXKbA+dnwH0Zkq/Ol8+CSb5sJt0LXtUY2Gq+Nh8YMH199/f3hglxMJsQ3t0o9Mgod8Shv1KTVuC9N8PRh/2Xr2IwNbsjEeXeXpbahl8gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDBBEThnE809vchOY2CIrO4jr+oRRyw3otwJqOCkM68=;
 b=JJLDuwOhTKs72VayTiuS1U54tlAjPUThNEmj2Q3ip3S1oyiOVb4qZHcC2DyChzdy0S3zzlPClyOHF+LWGH5ba6lJDYW5E0USU1PyLKnuMQ1aJehIvzyteETwrEauQqmULRbtGlUG/ZCh6R06LkOnWvf94mLw++WRua2mSgPeMLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8803.eurprd04.prod.outlook.com (2603:10a6:20b:42e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 19:37:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 19:37:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next] net: dsa: delete unused exported symbols for ethtool PHY stats
Date:   Wed, 16 Feb 2022 21:37:26 +0200
Message-Id: <20220216193726.2926320-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0060.eurprd05.prod.outlook.com
 (2603:10a6:200:68::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1ce3cbb-f4ac-40e5-05f1-08d9f183c990
X-MS-TrafficTypeDiagnostic: AS8PR04MB8803:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB88031F7C64B376B91EE8E24DE0359@AS8PR04MB8803.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:94;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEUctjsYDVvs8Lm/zJatvr1p9WuH5rgweMgJzTXUyKkJ5crHIhLxpI99iy5E/an4mZk26GEAgYMMWUAThzymj9yx30kOjZu/3fOqgu6EeIzjbuF3+rI5kAq6+VZiIxfekhrCexTGiDKkL4T8yyvhZfQp7MDuQD9MTNtdvOKk9v1ac2NSJBStEUOMFnyqeF0FZfBUliAkXMgK+lAShtUY/NKrMipN4j2100S8zZbIbBi2roI4SckEXrH6fzaJLJ5Lf8MQTFqpnl1k5CGCRUE4OESgkEOAB4XpZGmYDLewamZcQnfVW/grVGnU65ZR80HPOgztF9Id8LjwE0zT9brv42NvAWctdCvDac80Yv7oEB70y7UwhBygbISPmZP5PJrc9D0tyuXyL617QWW2D10ICklxP0p7C7HTBKMg48SF9EHnBS+Vl3zxuvRpvQ/IqlBN+j25KK5m5LaUExts5lE8+7UZI5WXWmGkahU9IDam3ap7sqKSD+v2Pqweh5TDVsH5jm9+N8niyfDOVBasCkScAdidLxFfvPhzpGP3AzZrw/axlFv/egIWros50fXkdhGUl4wY1hGnZX9bqSH4zE+ngkl4U7RzfGkjbTtp5zY6hASOKiqYqQeGzjjd4gZhc4Zd8xlUwY7TEu9VonoKjvpGk3No4deKKZ75BeH2bj+n5+D6Z0ws4vgrjWgGiLcZMQgrbq7CNhAPf9q4WgYw2WizyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(508600001)(186003)(8936002)(26005)(2616005)(8676002)(4326008)(66476007)(66556008)(66946007)(1076003)(86362001)(2906002)(54906003)(44832011)(5660300002)(6506007)(6512007)(6666004)(6916009)(6486002)(52116002)(38350700002)(38100700002)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nIoIz9q+9GWep6T6phLsD7rC0t8OOPAZAe9cm/Arknd9o5zG9pmJwLoYZQJf?=
 =?us-ascii?Q?ZYH8bSniIy6bZPRlJVr7O1Yv2blgngoALAyDWvbly0bYMWQdz8bC5zEd/tdH?=
 =?us-ascii?Q?Y3d3TXJtyRsx5kzwj/qMVnvE/7DkPL7Y7JLqsm2huDw8xR3kwDSCPbWgUQfH?=
 =?us-ascii?Q?3hARLU+7uMM8N5whUMdUwN/ql/1hXPjdoKjocV7zLPnx+YlU6eM/NO1ox1h2?=
 =?us-ascii?Q?Hf4WABckYaqCEcwtqQ4qs98jcP9UOBw/fresSMW6YZHjQ4p7sVjwQBKVk+TR?=
 =?us-ascii?Q?5SZtr1yaZa5eH7tVvKsImwbDGx/eVukI4I+awlSfc+AinZG9Fb/2UQTXD+h3?=
 =?us-ascii?Q?luzBMJXCIL80dsa5KTPacHIB9ypitJfo0hu2Hhi105nMBlKmotToLaTuJHBI?=
 =?us-ascii?Q?Z4yQ5l//6aRc51Sx+JPENgQZpyHUquIIMUB5oeC/RX5ZXJcaDfi9VkfCmvzh?=
 =?us-ascii?Q?c+i9MN1uqr9UmYN7SwCSM5PIF7n3NkiMrtxNj2g6p6CmFxip0VYEn3asHstE?=
 =?us-ascii?Q?ApuUNH5hW3+tri0bThGF0Az0kfh6m7G2lUMY1JIyzGxjwV5vhUvHjlYRgb5v?=
 =?us-ascii?Q?GqXlVG22FAvvYhP8px8vl0dLgh2Eh2ON+cboLxZcZFHiPiJ9wvpgaVE64Uk0?=
 =?us-ascii?Q?shCObkYeEUvUw/HKPZGaZwH277YrCQhcENowBkhisljEQz2KM+P0Y8YrUH/9?=
 =?us-ascii?Q?BFMvN/RGRK6r8yz1W9AiPJG5nqa1ipxUm1R7Emo54Krc6prinWwFrYLzi9WI?=
 =?us-ascii?Q?xNaqLRz8GF3D27Hjd6J8iVYhQJuOKCFIhgGXtPBwqkcSr5+n3SEGBbcX8gZL?=
 =?us-ascii?Q?pwr3JBxrtqB9bylu1sDyQHTv+W9TUMNXvY/v9e/7nCrKfPcqELIZweJREvn9?=
 =?us-ascii?Q?vYuKp5hX8RPXsHCUqAj0+8s8BHJpg2HAVUfg8O95o9CRxWJg9kRa6PKQtuUU?=
 =?us-ascii?Q?Usm68odJJZM5WexwnRE30bFIpaZUteqXMekjjO17bQjfxkXRPwqTBWjuU/jo?=
 =?us-ascii?Q?FieUzEg1VzXxA5YD1DGHQHm3i4buxPv+TQGkz0B+DUXu5xkDvpbxioCIExPK?=
 =?us-ascii?Q?muHm8rTVaiIQE4hgknJ/Ziks3FDC5DTHQUu/LWPX+hYle/Qx/0tvS0J5OyX1?=
 =?us-ascii?Q?je6lh73aLV5cV7a3AK8mAUaY9LymZErzDhNjOMyjZe4eA7EC7X8NF4T6pWQr?=
 =?us-ascii?Q?eZcsRbHNw6DOUx1dlSZAY4vrGeI32p7c35eHm/PLtrGXH006bK08QC6FREux?=
 =?us-ascii?Q?wGZ6jd2at4jO+txg4XhXOOKvU9oxDF99OhasybzBt4WsjR4tcBP+GQ+Gw1o5?=
 =?us-ascii?Q?eapgjQfnk0FjDOEOPakhgsyBk6c3BesOx/ujsGnwWXxfD5wkFNQzFKwI4nPf?=
 =?us-ascii?Q?kxAnzwGQ5oRBM9/L8z1wsKXgr0D7v7Trkt6yxPOCWwWk2+cWp/YknR0eDCqa?=
 =?us-ascii?Q?/HKLVmDakS856va2EQ9yESAIJ0JsoLkAZqA/5I0CVyw/G1hZUYtBLgQx/RWJ?=
 =?us-ascii?Q?NNZBXmLL2jgHYN5tQCpjsfCZcSnLBdtReMnErJFHL/JxfTQjgMpGvo+pbiQ5?=
 =?us-ascii?Q?kHdPLE1NUWlioLRjAT4sbSAuG8CTGXiaRvhxM/L02rL0I7STS7AaV+DB1W9W?=
 =?us-ascii?Q?8U7vCkVYP9+679YaahCvBnU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ce3cbb-f4ac-40e5-05f1-08d9f183c990
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 19:37:37.6492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WPYmJCE1gwNRRFjC1/7xrANNMZgE4qkoTGYzcttH/7qUEnyWycCABml3HHfFhMxLzeNd1FMzxTvBLG3WH+Us0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8803
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduced in commit cf963573039a ("net: dsa: Allow providing PHY
statistics from CPU port"), it appears these were never used.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  3 ---
 net/dsa/port.c    | 57 -----------------------------------------------
 2 files changed, 60 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 85cb9aed4c51..1e1c9203270c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1256,9 +1256,6 @@ static inline bool dsa_slave_dev_check(const struct net_device *dev)
 #endif
 
 netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev);
-int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data);
-int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data);
-int dsa_port_get_phy_sset_count(struct dsa_port *dp);
 void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up);
 
 struct dsa_tag_driver {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index cca5cf686f74..c731af0adf04 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1300,63 +1300,6 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
 		dsa_port_setup_phy_of(dp, false);
 }
 
-int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data)
-{
-	struct phy_device *phydev;
-	int ret = -EOPNOTSUPP;
-
-	if (of_phy_is_fixed_link(dp->dn))
-		return ret;
-
-	phydev = dsa_port_get_phy_device(dp);
-	if (IS_ERR_OR_NULL(phydev))
-		return ret;
-
-	ret = phy_ethtool_get_strings(phydev, data);
-	put_device(&phydev->mdio.dev);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(dsa_port_get_phy_strings);
-
-int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data)
-{
-	struct phy_device *phydev;
-	int ret = -EOPNOTSUPP;
-
-	if (of_phy_is_fixed_link(dp->dn))
-		return ret;
-
-	phydev = dsa_port_get_phy_device(dp);
-	if (IS_ERR_OR_NULL(phydev))
-		return ret;
-
-	ret = phy_ethtool_get_stats(phydev, NULL, data);
-	put_device(&phydev->mdio.dev);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(dsa_port_get_ethtool_phy_stats);
-
-int dsa_port_get_phy_sset_count(struct dsa_port *dp)
-{
-	struct phy_device *phydev;
-	int ret = -EOPNOTSUPP;
-
-	if (of_phy_is_fixed_link(dp->dn))
-		return ret;
-
-	phydev = dsa_port_get_phy_device(dp);
-	if (IS_ERR_OR_NULL(phydev))
-		return ret;
-
-	ret = phy_ethtool_get_sset_count(phydev);
-	put_device(&phydev->mdio.dev);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(dsa_port_get_phy_sset_count);
-
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
 {
 	struct dsa_switch *ds = dp->ds;
-- 
2.25.1

