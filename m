Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D136931A422
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBLSBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:01:48 -0500
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:11551
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231131AbhBLSBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:01:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj7TpSQ6Taix+Y7B0fMDQRi65PHDB3BX4pIEAVVlYHQlAPjQV1d4weIpRQXY/WpZnbfbxeJSen7Y1DClkH3q32cymhfBsaH+lyvs4x4FNsSO0gyGTGoMxNopvxj95Hmi4rb1kD3hRqusrSz8X6BdkJRAe/hJW8q5ZehovkuC3fGcLkDBhXlXfGnP32G4kTiJP0/WIjKrfl9886D/JCVIRDGnYxhAEXgyrtBLIPcDFCjAqmBLJf9Va0kl8eAUYe3uYhwDMknMrIMmZDj6PfeN0K27PLaStkr47z9IpPoPFcM2O2qnXHgAN3i6F5MQ33oxwDCrlgPfcDF0Ef+1pk21KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=694KkMnDLUt+nK1+dtlW4XX9QpxyY6noJ+ZVhnpJWjQ=;
 b=gMCIG/rX8eNGhuA4pcnk3YDDhXEjcbIE1SnAuC/guKk4kdueEGq7CKyHS2Z+QGWDf8mgqfoXhL+ZLCen5mPpaQSB6b6k7cq+hlDjz28aPieFibBDoKGhOEfAc4KjeA7iIBOg00IZd0AY7dwp0VMdKtMHRGKUFqenI6nZnt0ImojuI8HbHuCtE6UAMyXRx25Fyk2/NPwRTMU20Uqp2VF/fp6RGHK+3C23DivAerIasViPeQDw149ZPY1bLBv4JX3MnUVo5wSMd4YWTk3FyqwSjl9Pu50FJW0KHYs0hTwDWtPClraKZ3IBPfdrM2bzlz2chu3JDfexDFE8vDK/LhUJ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=694KkMnDLUt+nK1+dtlW4XX9QpxyY6noJ+ZVhnpJWjQ=;
 b=IxiTbJ8BszRju0WEUWVRIJFAc8vUfnA3YY0Ong2Mi8omgOl1AAN1bEbAgC71T8TMq8yGqlvZPmtmZsCYBlt6QZsIXIat3bzqHvEGXswZNTBFRxypG1R6/LNaG3upkn7T+sVqWHIfR2aQTmjNroShAsIgWCLtfbaz0E3ai2ZUju4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2495.namprd12.prod.outlook.com (2603:10b6:802:32::17)
 by SN6PR12MB4624.namprd12.prod.outlook.com (2603:10b6:805:e7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Fri, 12 Feb
 2021 18:00:56 +0000
Received: from SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451]) by SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451%3]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 18:00:56 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH 3/4] amd-xgbe: Reset link when the link never comes back
Date:   Fri, 12 Feb 2021 23:30:09 +0530
Message-Id: <20210212180010.221129-4-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::31) To SN1PR12MB2495.namprd12.prod.outlook.com
 (2603:10b6:802:32::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 18:00:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 76090f9f-d28d-4d90-0b34-08d8cf802510
X-MS-TrafficTypeDiagnostic: SN6PR12MB4624:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB46240B5FC942997CD09643A79A8B9@SN6PR12MB4624.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKrNG38NqX728PaCCg9j0Zk6NVjdiNwOOyN90ZD+QEuMxmDKDAIVkvvAmO9q02CV4zsSylLV7iesjDYBaSt7c1NtRAw9fKMsEUzLCHJsU1SX7EJXBVSDKQT/iT19qDWiOqqSXw5KXoFB+2Fl2C8h/TXs2mL3RjOYMOmKu0IYBh4wOs6ZSr1sQgLg4XZzMgtj5DpuyPj+kzFJ58p4h343XmhjiXiz2kApCTOM5vF7+MZ383uZJaAtjBnjj6R74BRq5AUEhZ5dlP9tMeh/iypQ47QB8Nhw7NvtWnSo3UVhayY6VG2zYujxilL74BR5qIDGzLukjVEeLG/X2ArfvJmkfd38r/9nm/3G+1OchaxlUomkdubPWqsqizAhTxxl0LYqw0QVUWpozodUyy6Gi8sqvR5YPibareTigGygCTr0pBvea5vz90RUZ0yBB0glw7+Qid7o8wybQglxJdJUK4eZzPcQcrGRCn6cyaQ2X5hmfEXl92JmHQKRBfRSAkcpp2hrLLrZzEa4sOjv9Vvg+Kq92w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2495.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(36756003)(316002)(1076003)(110136005)(6486002)(54906003)(5660300002)(66946007)(66556008)(66476007)(52116002)(86362001)(186003)(956004)(8936002)(2906002)(2616005)(83380400001)(4326008)(6666004)(7696005)(16526019)(26005)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?C2qkjXGpckhbShmZaKNfm2gSZ+LeBW+DodZhTWWdjldwx4bTfjSTUBxoxEuY?=
 =?us-ascii?Q?hBD6qVcpeeFwBCxnEP4ddOosSVFidxUn0Pwm1d3YUSYdQujgonCM8TEi5FFX?=
 =?us-ascii?Q?WUgycW93jgP9upYKKt4cwrOZfEybebjx4YQaMHWSKdvWBA77RvW2qPgfSa3k?=
 =?us-ascii?Q?GqMazVxDxPUAbEt1ZiKpAXC+xJ8nHToELNA6d6ffp4A0w2Of72QOB9dBcQqm?=
 =?us-ascii?Q?MYzes6YKa+HoDae3YWrdKo9YNK9IP0YsD9zROh+K95qOanxt34m5L0klhc15?=
 =?us-ascii?Q?B1YgyYYs+jKit6CtsMo7TRjlKeXf7fjd6QygSidosHaOgie6zf2TidYy1igb?=
 =?us-ascii?Q?XgH9SkRBAIZGowc7IZ8dxSmjVFdrE9CUCqZ3ptgVWWv9GD1icuYppjTrcxyE?=
 =?us-ascii?Q?V1bHh41KRKUiu+gQKs577407qIFFCglDLZGTnfEtVc+djkrPzxsysvp909mI?=
 =?us-ascii?Q?MjjvCI799VF/SZnF0WiAbbV1i754yvWj4IZL6EiXIYL0it+mGA5p7TpiVa+K?=
 =?us-ascii?Q?kLbUusmU4KOyJVfMrnM5l4SlikYZPn1UZXw9O/hgawZ6NIrmACAUYjVeLD18?=
 =?us-ascii?Q?gfCn35K7t0LVZmFNXmeReEeWHgRJJIGG2hJsc7F297aV6CSw4SSmXi7qZH20?=
 =?us-ascii?Q?BbHem+omisZ8ddrbkvLAZQFdzkueBXEkh476/g/qETSTdlcERguVNTkycKKE?=
 =?us-ascii?Q?YlHKI3V5Wuop4HCjd+IH2sCILiSg0j0wR3dgNKrTjU+OlNanOMkCxi1u0dwg?=
 =?us-ascii?Q?5CK8PIeByMep7qULnKbeqedG2QViC7/hKlw4pFvGHbVYvAxI2stYi/FzIkkp?=
 =?us-ascii?Q?uGkMAGjPq91NyqiKcvYHJhiUQ92WPyh7V27/rasP6s8jtW8pwfNcYOjYMrKy?=
 =?us-ascii?Q?ZoAUdYiKXwTNpjRTrKJYZUj95sQehjuJtitMOmhQXFH6LWFdgqFRbcrWbPk2?=
 =?us-ascii?Q?kgsB7zmuyA9yCp3x/ZxO8xGVBEneq/ruk0kelgWRRoLnnu2/8LOtsrD+CRrP?=
 =?us-ascii?Q?tzh7cnQyu+kXqvljGlWvjw5v4YpFKDYQwzjl+B4+mlHAbFZBxQTTFN7vMwY3?=
 =?us-ascii?Q?utFrawZdG5hTrcc5ebOv0ymcfFbbSl7Nw6m2kMKs9eYrJt0SCSqL/PzneQCO?=
 =?us-ascii?Q?b+Xi+hdF0Jcrg8ICk0OVQML59spnhHedM/ARdJnL/yEVJvlBJ4Uoh+DY2cyU?=
 =?us-ascii?Q?0QLsESImD1aDz4+4sIm2WM/Nii6m3Q3dAHTaCHtyUY2dxK8umsUj/inAAPSU?=
 =?us-ascii?Q?jdUbl0dw8FonsKh8Pvw1CF1EU2PCUDEKko8F7zdoKddU+hjDIYJhKQiilypr?=
 =?us-ascii?Q?MkDjpmkTSYKizyPaX4fD1R79?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76090f9f-d28d-4d90-0b34-08d8cf802510
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2495.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 18:00:55.9136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nAtYKMF6w/5oZ760Rpq5vSmO7hghBjhn+h3k2sGKmQqVCPjjSJRpwrcTLxyoqUX7f85mdefNKGkj/vaafFUC5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4624
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally, auto negotiation and reconnect should be automatically done by
the hardware. But there seems to be an issue where auto negotiation has
to be restarted manually. This happens because of link training and so
even though still connected to the partner the link never "comes back".
This would need a reset to recover.

Also, a change in xgbe-mdio is needed to get ethtool to recognize the
link down and get the link change message.

Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 19ee4db0156d..4e97b4869522 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1345,7 +1345,7 @@ static void xgbe_phy_status(struct xgbe_prv_data *pdata)
 							     &an_restart);
 	if (an_restart) {
 		xgbe_phy_config_aneg(pdata);
-		return;
+		goto adjust_link;
 	}
 
 	if (pdata->phy.link) {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 489f1f86df99..1bb468ac9635 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2607,6 +2607,14 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 	if (reg & MDIO_STAT1_LSTATUS)
 		return 1;
 
+	if (pdata->phy.autoneg == AUTONEG_ENABLE &&
+	    phy_data->port_mode == XGBE_PORT_MODE_BACKPLANE) {
+		if (!test_bit(XGBE_LINK_INIT, &pdata->dev_state)) {
+			netif_carrier_off(pdata->netdev);
+			*an_restart = 1;
+		}
+	}
+
 	/* No link, attempt a receiver reset cycle */
 	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
 		phy_data->rrc_count = 0;
-- 
2.25.1

