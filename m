Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B332067EC3C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 18:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbjA0ROo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 12:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbjA0ROn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:14:43 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2121.outbound.protection.outlook.com [40.107.237.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A43F7DB4;
        Fri, 27 Jan 2023 09:14:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPYz0zw74e0JoXgV95ENbcL2cl19ltTPviCoozhgSWtsQ26XYcmZTUxgeMGdz6zPeR9WLad33LEj+T8HgGQrfVPcKVbOq/qnmPK5/yHe9IXOpjMEW+oOQzM0rzPA6TANEEWTxioJ7X+0f3KXxF08Q2w4/nuzJEtsQ5WeGFG4vRG6ChdIHCWNWJRmMDha9ka3UYn+8CNxOTb+xfxwEzMKL/HYyg/oSZ910Az//nmawgLj9FopIUI/mgGcMC3GqusoYhWiJA8V7sL9ghR1lBkY+1b5XPOmIFpqWUueyeP4HC8A9L8gagScSNJAIzsrr01zxhenfatHbUkpjy7vkXupNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czy2v6M4ryaBpInNib0cX5PLMuZELpiCPQB1DYc1JTg=;
 b=dFU98/HHS2kBLynoZFxO1oJ+11DPc5N7lVBpiPgT0cO7O/PKlULz9wLzT/7G9HuyqEoSk/X19bhXSpeKZ/ed4e6+lWbcdXLe71rf0oHklSdBYhY7sIqsFcCQ4/+QnRfkz1NLv6ImoVHsna0pzVXR0jEsFbBl3N2pGyJisKnnNs5sD69MHae/nWtLwMziGH11Lmx/Dnn2BNJSoKBfR+Oex15dXyoXQd7ieFI+0rm3ldlgXLsAJvcQpqcnIU5PFpVMt+x1mZCmRHHQyVDwRzVQTodrhv+4qQkK8knpJEYBYAW7mP+Y7wf5scpirAI0kv7mj2kQDaO9fktg3JHezaMtoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czy2v6M4ryaBpInNib0cX5PLMuZELpiCPQB1DYc1JTg=;
 b=DHyfDJh/BVP0eLWbpuujmVjF3rkZdswjIJnAdLBRQyd32nub0wb15YDKPU4jsEYimT7HfDcSSR5aRmzRiZ+7oDJ5StVW89Fm4jWl8YT+b2KdsHKsAD3W2B6KN+BfyuA80r1QwH5ssG9sfjWWI3D9sZMZK6eQhJK7RH8xxCkz3oo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by DS7PR10MB4862.namprd10.prod.outlook.com (2603:10b6:5:38c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 17:14:39 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 17:14:39 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Xiaolei Wang <xiaolei.wang@windriver.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v1 net] net: phy: fix null dereference in phy_attach_direct
Date:   Fri, 27 Jan 2023 09:14:27 -0800
Message-Id: <20230127171427.265023-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::32) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|DS7PR10MB4862:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b6cbd0b-52db-4df5-574b-08db0089f936
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1iUJcWMn7vV/BJMFYqYoVJSR+S5kgTlfqUaAWoQZAmcOCqWwDOSSXbXHgiE0tT8GViBq6p9Ozr21SfIpp9bhBTYiyU7+VqvTq9hFrVTmtBbfpvCAv3UndiGRcuXgUOHb1jz5s/drZvYHizxxF640Hya12ro5NSsvSoBWTqOi847clDPDvUJQTRjpCMM9I2PSAhb+VE3JIz3ZeZD35V1Py9IdfTv3GzJLx5KeH6B0hBdFMouGeObbfxpzfkEPZKQsuiKVmQeq9IyMpXBFS/Nxa/4b2E3ggfRAw2ItG3mYzqlhsbKgWWKWQcEM5DWZ85JW0mXkgb94SO+2WJD0grXqHnFUe/gvzm6//eEyfZErxzIHEZj4aw1bWPj2m8Mx50K16AzUtff/EmUwQcTER8yGWGAIhj7XuDbdQvzUScXBXkLxBCn3yt3Qq6FwBlnFF8dt0aM0eS2TiNTaCTrY/RUYj4362FPtelfdtN4Jrca/J1PKDsrhJOi/PGnC4N5YODEN8dZsOPwAssT2AiZdIdCDhSZ39eFW+rD6x6EcZzWO0w6qzUQ2j5OtcY6E6RL/4pOIeUUTgjiQcN3RWiuSFwVsYwldLZLwQLdR+Jsr+9tW37grpu1gefAjlq14l4HxG9wfKwuCryWv6E3J0yGLdGSWdgcpA6YvHdQRVJGo5zSlhF+X9sejPZq7lmr44XYCePJkkzB1wDIEojxFIztqbmOlHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39830400003)(396003)(366004)(346002)(136003)(376002)(451199018)(26005)(52116002)(6512007)(6666004)(186003)(6506007)(1076003)(2616005)(478600001)(6486002)(66476007)(66556008)(8676002)(4326008)(316002)(54906003)(66946007)(83380400001)(41300700001)(44832011)(7416002)(5660300002)(8936002)(2906002)(38100700002)(38350700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g8SQoYBPju9t7ze/ytiFv1tX09yRXYqjDLUm2AFRFLWp1UDq84xAFkGtJpU/?=
 =?us-ascii?Q?ybqw4mHrNfR40RIsEFXoDaPcebnAgeYe+Iy8NsHlEHm9RTMOK+MKlj61soN6?=
 =?us-ascii?Q?0TWYasxURhxcqscTX46oYmuaKigtKJ+HL+UN7KOE5PIJUH8Olddm0FzlXLjS?=
 =?us-ascii?Q?F4jNtGEcy2tR8xmgmMydut7heYfYefxbs9HelaJ/ZS1m30ZC+YWkNKooCWWZ?=
 =?us-ascii?Q?yf/dospdCREpdWt9URyS6WXV/l+MzzEuHTvPrIMnqax36/E5gDfXWoxKNHCJ?=
 =?us-ascii?Q?mtxQt5QC2kzRTHjyg45UaY4mSTAl5VYJxmhFHaPDZE8qCTCgnWE/u0jyY1NE?=
 =?us-ascii?Q?/xjD8Iyrqi2LUZK490SbhpUb5aOGNP6N9vBPzwc3uVwWsjRmwsOPnqZ0yx7h?=
 =?us-ascii?Q?n8oUzM3Wjgd9PT3DGiFsDE3gqpJ4FRaD1ge94yAuU25EvsFmK90MpAhx7hWi?=
 =?us-ascii?Q?Ji51xJWH/rjLiocMw3yL9J293ZpdacH2XjmRU8QhkbYzciBzLOd2hYs0lUyd?=
 =?us-ascii?Q?oPJnyaoL/YtsUxogQeH93kF2T7UXmd3ddcn9faAH2zoaiunCPsW9CMiSP8X1?=
 =?us-ascii?Q?aV0fOdnEyka2ENqm55Px5JH3AOQEfadeC5v0tvf9/dIHZLiH4JNQiZwdkR0O?=
 =?us-ascii?Q?SMuvVvxmbfGJ6auAnJVnb9E5hbzvvdBJHgsD0Xj9Vg8deCpu5rJ+pkxpZlcM?=
 =?us-ascii?Q?N70xO79lKfhOxc8reb18gPeQkdRxsnbHqh47siWS/PaxzlErJO9gJGPvjhhv?=
 =?us-ascii?Q?LVoiUWBFCAIjMYrD73IiALaHprhoGWw94+gyADcch8Yx0HDqNsyn2EA4x6tZ?=
 =?us-ascii?Q?2IHF/+yZkcbGQa4AVawjYlRqSRvy3dyB2qEiHc+6ZqjGF+hpNFIhB2mpM0Vv?=
 =?us-ascii?Q?iNF8HwS3/yFuUT8A20S7DmiJjTyaIZbOJ6ueP5EYWFnlG2dmFAw5rOoP8jsP?=
 =?us-ascii?Q?JEecv0mwVAVabi7rS2UZ/uSP0OZ1N9z07BeDgAI9oTZ3mapnKJWUFcphytVs?=
 =?us-ascii?Q?+Cjfiirhpzg9F7zxWzpWurqbqqWkDLtGbGfi8G2QHWmQkULcus1m7NDckuof?=
 =?us-ascii?Q?Gn+XAknZPVUtqKktWq3ndC3km/0g8kN0IzR2HqtllYng+OAIBBwSHj9CjS1E?=
 =?us-ascii?Q?+id2mOozhL18G5ET5gBROSFPxQudMt4dhSfgAH2RrWQU2p5H5MhNarFdUqG/?=
 =?us-ascii?Q?zJKtyucx8PKCjFLdPtxrC8/erV+794D4k0oz+lr/4TtkDscz9Jt6Z/BHBjvG?=
 =?us-ascii?Q?3jxeBqn8t9PKlAg9kpXsWYWihvv0jK6Gsil931Frqiz7INrOO772P4Sn0hWx?=
 =?us-ascii?Q?isuDzudotbudCnEzWaxT0SkItUB5gQy/IKEUfhCvcAbZtkNZGoqGN7X+VIa3?=
 =?us-ascii?Q?FPxIk8Ak1YstkeLMkDvyXk/GvxV3nGlnkGKIOBteyfaYsC/3NHHcxGV1/Rw9?=
 =?us-ascii?Q?/NE1xH51vDEdr4fLdHp013Gh/E8H3ufACTsLzsMNb4Nmv1idE/kwP08BlR99?=
 =?us-ascii?Q?HkEslelI9qnV2VpaLVOEFR/DT8eTCHJLAivvaahbJHnAp464wfoEXmaiFIDj?=
 =?us-ascii?Q?frcjOhuX/jTTOp4hxStn4JlAWcJXERsTbPW8Ql2zvhonZY+Z9AjQwf17zMVn?=
 =?us-ascii?Q?fQj9dJVAYqNyR5wRLqBxxhs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6cbd0b-52db-4df5-574b-08db0089f936
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 17:14:39.7164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pg6bQ2G5m8LaisUMZ66U7RCnZykEiao3BbYx/AjI7VskZSbIU6kTG5HHYEl9TtM6JKeLQ8vLcYR0hFTA3J8y0hJMCnUJuw5x/LxdLbvvwDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4862
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bc66fa87d4fd ("net: phy: Add link between phy dev and mac dev")
introduced a link between net devices and phy devices. It fails to check
whether dev is NULL, leading to a NULL dereference error.

Fixes: bc66fa87d4fd ("net: phy: Add link between phy dev and mac dev")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9ba8f973f26f..a3917c7acbd3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1538,7 +1538,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	 * another mac interface, so we should create a device link between
 	 * phy dev and mac dev.
 	 */
-	if (phydev->mdio.bus->parent && dev->dev.parent != phydev->mdio.bus->parent)
+	if (dev && phydev->mdio.bus->parent && dev->dev.parent != phydev->mdio.bus->parent)
 		phydev->devlink = device_link_add(dev->dev.parent, &phydev->mdio.dev,
 						  DL_FLAG_PM_RUNTIME | DL_FLAG_STATELESS);
 
-- 
2.25.1

