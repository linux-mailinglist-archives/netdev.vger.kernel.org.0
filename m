Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5824686F6
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385430AbhLDSZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:25:13 -0500
Received: from mail-dm6nam10on2095.outbound.protection.outlook.com ([40.107.93.95]:6433
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1385420AbhLDSZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:25:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oc/sj+go+YPdWDTAE8FTCI7N8QR8BlZZ4+Gi8fYH9grZIq1q1zfvhPOgTVY+YaTpCxPTpx25QunIR6Ejj871Xt7LoOUgu7+PMG9q2V8mEH5VBW5gV7XSNW8blxXVfQ7f6tQvmxRwpUIBuNSZy7ksVYcdbtAxz+prEcAM7CIQsi3lBd8cr5/P8PwmGfabsLy5sbs3TqATk5bw0jwWxrFU+rRrxgfBcnIrNWBmXiTeFi1tnIMLS+eRW2dJSXK2Wcx2xx42JB5CpZ8cJkf8hbdFdgjB2800Icpt5e35KSfTAtxA4sqat7sqCtqKbVMBoS6u6YsryC//9Oz2pME7+pwRJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6E97xQpLHdXc4y/GuYyoYK2mXx9cdmEpPZhyBlKjk8=;
 b=GlgbsfvCIVLW0o0DFu2RpxZbdZroSCSo8J88yahFdC0bp3qLG2ywiaeaQ7vIwkO7zDOKgqcdA6L4IWHRCjtxNAcdUveCJuss0Kn7wa0g+n6ehJJq3oYyBTvuIk7qAv3yXjpVqbelTjO4B2mK7xWhbLWlPzPH893SceN0WhOF9g6gEZgIYk4W1Aib9HYisIQ5fn/TTL5Xj7CoUc5RJ41iu7h/HOm4yPzEaOtiXKKq4lMhZ3Vd8I6nQS2nCKS5jUvFQx1D+uSzSKnSz5H6nFM+zh9xWsvvNjxOII9lI7M3aERbWinlPoTiWZkQQSl+Phj74E4W6sqJooX/7TGM4fK7FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6E97xQpLHdXc4y/GuYyoYK2mXx9cdmEpPZhyBlKjk8=;
 b=HMHP9dlH68HxASRZkTwEODjkzcF8V/pe+Be9ZoLFruP3fh6Sxd5jstBXH5KcB5XA7K3RGarqyC+4HYPE8H8BHz/tveC1WzyMbRlh3Z9ifBlhtRneNTsaXYqKB2Lvkr/d8NDc/O+DIbx4zCXn+QTmSdfgzbeHl0DCMRJZp7bL4XY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2061.namprd10.prod.outlook.com
 (2603:10b6:301:36::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sat, 4 Dec
 2021 18:21:42 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:21:42 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v3 net-next 2/5] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
Date:   Sat,  4 Dec 2021 10:21:26 -0800
Message-Id: <20211204182129.1044899-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204182129.1044899-1-colin.foster@in-advantage.com>
References: <20211204182129.1044899-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 18:21:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f122ce5-7496-46e4-b1ae-08d9b752eb95
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2061:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20613954854F6207AEA9248BA46B9@MWHPR1001MB2061.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1KExO/srB1PFZymb0PmTgJw8fyhks6p0MAy85W0verW6PeABg3COW51zft86aJyYzOhgIvtKGc1OGik8/kWzeatO2BbBKyVoZpcrqS9VZ3P/aCK7G6zQ6LM+quveWrLd3p3I2CEAIBrGkUFTB7MiGdIxGcVIv0BsTmJ8Vmd62Ka18xp1/maPsIPlQhZww8PVHKLx6Rrc2g12Up2AYLlvahA1+6C5GXgxEb/Dk4j6vPD9nn/0Dilr6FyVPpiiCz6Gwm047pRQrcFhYk7+C6nQMmO9Z4b59zR38fwJX3q0r3HA1sEDpAWJO4Yo066c7E/Jgpu+qlh0ut33xepHvFvG1BYpqQxvWNNQhHnTSQA6fylSG7qkUktALcOoLyD2NtN8gwT7Co52Y1VRbqQZVR+mXRakTI7qoqr16KEsATyu699cwqnbbDOVBgP61MUGtoY6WjC8Zl8Ae4VFrIpj57pe8wyaFKQNVwPEsO0Fhr24bijbRZtY3bOcqUM/zS1kt2S1FZ0naVhbsLBAycK/V3FSl+okoCqiUKjY12WzErQ6SYm5uSLw5m/fl6FApnkMwzzB9cz4NEfCHCDxbC2Tpmvn6SyzYHVWmaKBod+U45DXkZXR/UXn2O7YLOtgD7hIa9uM0XQSg9y2/HHXq/iiy0wXqRoLwlKZ+Cvco2NKdy7lsovR9a5Pg8wbVGR8JS7Hgir3m8bN6Y0rWgBOajc0o1yMQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39830400003)(346002)(54906003)(52116002)(7416002)(6486002)(2906002)(6506007)(36756003)(66556008)(8676002)(26005)(186003)(66476007)(316002)(8936002)(4744005)(83380400001)(2616005)(86362001)(6666004)(5660300002)(66946007)(956004)(38100700002)(4326008)(38350700002)(44832011)(508600001)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y7v8dJd85vDPiKM2UwFL00tvqwP5PBJ+RnoHcRtcoGdDBwuEMjwMyZFtNVEQ?=
 =?us-ascii?Q?RjLnw6Pbmfj4pT7KZrFdQ3825UW66rCYh/FhYqebuPZcSHvmyydOpTYM4JCJ?=
 =?us-ascii?Q?ZCo0qUqTjoWie7R93NlImastEWezmUA9HKSKqggf7Y5C7P9Qg9n5VD58j4+A?=
 =?us-ascii?Q?R2G9za5DefBuiRrJu+2umjscmZ+0ePvFZrDteB7HhtEsFIq6dYalzavV7Q1p?=
 =?us-ascii?Q?TTZVSVhEbICcsOdBz3NEoZT71u16qc16ZS/JUDAW2SN0+lK+aFSGTUIn+Bpv?=
 =?us-ascii?Q?tbEYKJEbajAo9RhoCfFdtEUPO6A3EXwwvaVzXvPU1nvIwzo8KBoYGRiEqBxi?=
 =?us-ascii?Q?cFNyl/E9J5Lqsw2fqEpI2dk2uJDgakt2QA/Syf8SiCTmcedfKiRW9mD9qQL4?=
 =?us-ascii?Q?FIvKedifJCznfInx2ycbiqKdQ1Z9ghIH42xAW/y2somOnKk4CMxAcQbVfg10?=
 =?us-ascii?Q?4T1hHwSVYDu6efLjWXOgTVTWw/HGREaNdXeskTewXC89vb+CQjeI9L/3V7Ho?=
 =?us-ascii?Q?k+y/SeN6orV1/8dNrxpJMt1El3Zm96GtIoS+bgoHAfHeq5hAcU2Kn0EyrMcy?=
 =?us-ascii?Q?h3ce/1iBRxbJ2GIT7Uj4ZR2HYC6k4NsouBJmRK90o6xPyCdajUUFyc3aPzAB?=
 =?us-ascii?Q?h7GMZTxfrRIEqi93TlcggSmHEVcWUr89kbkjPJm215ntLxJwxlu9GicAwz7M?=
 =?us-ascii?Q?jvNaAvl4Smge2UfHMWuOkh3AjXimFcwHC31rLvTQQ57MumVXSUUFTjCFIfMY?=
 =?us-ascii?Q?XBKGkrR/gdsITbV2Pewv2FsF3JBycjwTFXpJm8Dk8u+IEfODtWr+FdAMR5Yj?=
 =?us-ascii?Q?ekRoankWxoZt9aIFub8ykmghck7Q8fKbA1aiM7Rijlqt6Rybq31KsmPARqS6?=
 =?us-ascii?Q?pFOHWvSHdnRw+aflw0KUCFJqJVVUUV3NxGsmxE1e/yhXgvMtRbTq2/6SdVRU?=
 =?us-ascii?Q?SlIg9mNyz7/9YsabkI8Yx1QGjlkfZOc/W7eRw8HZ/Z13+vSBhXCqr9+Pdduz?=
 =?us-ascii?Q?ilZiyIY/9SKJuVm2sIMeBDjXCAKZKP0LuORLLX6R+Jyn6yNxdroK84vXOzr+?=
 =?us-ascii?Q?12yEGWx3mBiWLBF7v4ClvTzytBjHizJ84cHXePtetSorRRouEaV9XtlEA6Q/?=
 =?us-ascii?Q?OFE8RgA9+LMjmlIA7SGI0ogu5KCPlVWDadtUL064hwU7L+NZ5xR0lakWDbox?=
 =?us-ascii?Q?L3AaLXM89juYN9Su2dzfX+KOfWbFpbppZ20pgwSwqeXttWeGNIlTOQSmsb0t?=
 =?us-ascii?Q?ZMthCKrLurxOqsDAUChG44eCJrlTBJpGUekdWwPvyb5PcVOwjlxZzdJl12Gh?=
 =?us-ascii?Q?Y8zam/FTywpml9m5zx3/TAlYOOeNzO2kte+jx3Dfer7uRXRe4WMySTVtiYym?=
 =?us-ascii?Q?O/hdq23rfyxrxNK4c4ImyRukekYWUsJ1Igf9v92wl8FkhkP0fUVhW6mv07N/?=
 =?us-ascii?Q?4ry1jGrodXtCvNItcQqSuv+/6+EZVvYuofp87I5PuZ0agz0DEiwaYIC8YRzT?=
 =?us-ascii?Q?NoZRn4Rt+6gfkRtzVx4gjIhcRtaNyvhJY/T07SqLJm9QHK81zNCyloQachpq?=
 =?us-ascii?Q?sSttYBUQE1ALO8whRtvvIcgyrKA4WVDR0LOXNHOd3PrmhJKNpUsyRNahkAxD?=
 =?us-ascii?Q?A0WQEbsE2MfpNdptNojD75JgC5VFeTnJpQBx5cwuZCxdAermF5czfp9fQeTP?=
 =?us-ascii?Q?g6HYpTv65GLZRjGVYD1FAoHFeLA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f122ce5-7496-46e4-b1ae-08d9b752eb95
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:21:41.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lRLN9aQagRL1naLGU5qk5k8RxgChDIsGWdhAqnDcx6KIoiLKp0rfjNKIER2w/+jC5BUPv2qXrqmNpva3Lgq4d5wrtgjg1F2q3M54Wuis7lM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing felix devices all have an initialized pcs array. Future devices
might not, so running a NULL check on the array before dereferencing it
will allow those future drivers to not crash at this point

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0e102caddb73..4ead3ebe947b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -828,7 +828,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->pcs[port])
+	if (felix->pcs && felix->pcs[port])
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
-- 
2.25.1

