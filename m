Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8658480FC8
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 06:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238757AbhL2FDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 00:03:50 -0500
Received: from mail-dm6nam08on2097.outbound.protection.outlook.com ([40.107.102.97]:64800
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229871AbhL2FDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 00:03:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQ1+2+6sPKeMNDdT/ptxFQ8gomDTdIavt3mqvdk0GmZ6Fz2EVUUzyTAmn7tX09mJv+ELmCZA3s+a1YxvtU1xodTQYxIjxFDX+axHTRXEDR98OxhP/jYUn3MqyMbdHCcJqWRh91urazGSuXvdCqd7hZzy8Z6DLXMo+dNg4TkNu3ze9dWc7b/gADf2yEtJU9lnBPG7G14GQDtMfFYfoxO+9Lggs6MvD5r/uRzB9wxp1JyT2Zt5JVK4Rpy3LMkEj5r+YqKL1ka3xciQDhvxSanfDzXNU4d5dSU+nhfcNccTLQS3+44WL1fNj0Y4CgS+wLpBuDbA1/I1xFrLagyz5hBYYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3ytrGZq8hp3eblVUtZmeLt+/NPygH4U5QmMt+njLZ8=;
 b=XGX0M10jK3kTDHTcaqwlMOeoFBjO++pXI42GUW1UIZj2qXHBGIRl8ACUZPhpf5n/AJkMvdVfqz2+FcEFd/EDGRLpaLO1iX53LVyMhZd742aweOppdVw1lQgZYwc9EEvnGdTe+Cdtx5kQlUyIfebEJ9FahLsMMHt2S0qAc+grr5j5J6uRU7R+XrSkdBwPvkK7l7M1BQ5Sxij0owV7j9Fn8IFhHe4nq37PUfKY2BAiq+XFVUBeyobQlsEHG9V2dzdmB9usBkInav9lUrgnT9WKU8ljNrS4slK8JZbn/KHjWqWlSQtYJ+3igXPbWtEiLw+0JzPCpBXFuLi9lK9TGiHm3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3ytrGZq8hp3eblVUtZmeLt+/NPygH4U5QmMt+njLZ8=;
 b=tR6h+NQtKRu0+Ui3Lqvtb19FK46OfS7JR4k1ETJ+iEmd9/WtTjkqDjYc7F8TeQC+9LCSBENSWlS4yqvLS9iEXsSzrO90ij5ZD+raE885e46f1PjcyVAkxw6+SRQhmdcO+N1eggyP2gNs6DMxMszjvw9cI1QUW5zKaKUVv6cZSNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5441.namprd10.prod.outlook.com
 (2603:10b6:5:35a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 29 Dec
 2021 05:03:40 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 05:03:40 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 4/5] net: ethernet: enetc: name change for clarity from pcs to mdio_device
Date:   Tue, 28 Dec 2021 21:03:09 -0800
Message-Id: <20211229050310.1153868-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229050310.1153868-1-colin.foster@in-advantage.com>
References: <20211229050310.1153868-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f3aeb91-fde2-4096-37e3-08d9ca889490
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5441AE4B6E833E28D4F06CF5A4449@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fLBgUvGCb9Q/TQhFirF9yTxmsxTZU1D9d88ZSWIN+x4deLoeeyieJfvtc54gqZ3lyAixpUAZem4oIswEeHS6VDsZa1t2Xagw2605gh98RkL3az0LqGLI2GLEXsjUTbaSDX3zmr1QaeeZhr6ZXgMXL3lYJurDUL1BvnCO1dmUOBLVrrX+g9UNistzHy44Hg1XkIb0QmUUN/cidWjFnwyZZl9URxDbhZUBg9PFVzRvhEw/MY0yPFugRIO4xCqKs5dgwBvluZLp6QBlymRLwkM6u9eNlgdiwblQNKIp+dC4Jxm+IxNztzhhUa4khD4k2aug70wALRoYr+XrAKgny6OBKJMKq4ZyFPbAdx85XrbC3U4gk3vcrgpFhDKTqy8G/GlI8RlAOe5bcIfJVF/JtVAjhIBEx0U8czhEruuoSOyXv0rfpbmnPMNetUf3HaWxl718bTcKYPHlqaClPt49ALhq4uP/5lCglxxAklM6EyHdCKiC9jo+NOUhyiSrOHuXGDkNcmmURY2Imj6Tr5MgmjIeWQ4eo2lpgOo9v5cBV01ed2yF47zuZqkZIMEmYa0TSIG3LtRkKEEcTdDvdVpxJYPl7u301xVbTl7p5p35j+ZQCK9pCwKc18EEDOjSVYskyZGM/SVeEZCG1xd5C42KC0ihQIUOd8lTcqxjNyDcXJSTJ0cz/kysiHAyMcLc0/9q3IKrM2qMFQ9T+lCa/mhoXbUFJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39830400003)(376002)(346002)(366004)(42606007)(38100700002)(316002)(1076003)(54906003)(6666004)(66556008)(66946007)(66476007)(2616005)(6506007)(6512007)(38350700002)(86362001)(52116002)(26005)(508600001)(36756003)(4326008)(8936002)(5660300002)(186003)(7416002)(6486002)(44832011)(8676002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uK2jt8hDZ/zNhP/1JYr0ZuL26dI4S6RMU6AQs6vaN3+V45Yeu8NLZ7b7LR/n?=
 =?us-ascii?Q?+Ia7tw+oS6gY/ND8sa1y6DwaCY4Yv26z+FcPqUrCCukhalerOxy144BulWsz?=
 =?us-ascii?Q?54nWhCE2z1xc9qlM0GLr7kFV8d07yeROpiapZ1vzCFGAhVeldHBacfelISxP?=
 =?us-ascii?Q?o0wfSwQmHVIkqH3YEOIYGim8RGTEOMuLMjY1SkrgI4iDdx0LAWtHp7JkUU+4?=
 =?us-ascii?Q?730Zk0Vri4YKyxQs8JcMGN4eEFMXlgmz0/9MYCEm8zyrNaBlk3Vg8Mg5ruLj?=
 =?us-ascii?Q?xSvhOB49SRNpLZ6XVPMRXx3KySppRf5OoHdC+j85pfxEMqrMC2IgGeq3TWT9?=
 =?us-ascii?Q?FhISZkjWBNrUkOpT4YDfCalCM/A4eHj+Ua10/y8Jc2ps0RMo3URuTjZxfXRI?=
 =?us-ascii?Q?tJNb52XGRMBjGkPry19fJNfzWt6+vsb4ifn6r29V2iUbUqM2POEIBz+JJbdi?=
 =?us-ascii?Q?uWR3qhk7mICDuDvcMpB/HdYErOP3RX+Xib4HaUeT8wC4IL/rs/zOnKlvnd2M?=
 =?us-ascii?Q?emCwNLEkmZanWyj0XyXP+J36DR1aCT5oVXGmgO0NAxPeeJpS551g3jZVq0Z/?=
 =?us-ascii?Q?lL+Ud9rZnG+MhzrE7tBQSqmPGwVAqYhJepw4MT/3UI2YQAAZfquChsZjKuXA?=
 =?us-ascii?Q?6/Pa7lzzOvchdGvLq9paqyonlUdYlzfhweAGztQ670A1HQnNUPMRVvdR1WCZ?=
 =?us-ascii?Q?E5AKkdFoHYFJJ0XPLz1arH2IQe90EH1jVtdgkaxIWb2iwgxGk8tewgrRPvnY?=
 =?us-ascii?Q?i36zUaIgGm2+FtOEU+2DKYtaa3D2YPAg283LBowRoujiNmlF2Mdd5KOE7czS?=
 =?us-ascii?Q?SANZjJjpIXEAu4ZBPI5lqLuqvUrwRSCPPmV8KsxzfV8crL1J4tDouDsmdC3+?=
 =?us-ascii?Q?6Eb0NRZM7Hh2pQ7FHEN2bDc46s7dGxvRlbmYL+IAmDCAaWajBtFujJxP4/jD?=
 =?us-ascii?Q?ZyvoLDPlLcOLoN4kWRsg0Or3Ddx5BK3d1nseg1nK3L8cJPE2hBFXWR32pPI0?=
 =?us-ascii?Q?1b3OBnrgx7VmlYEUX5CGjBlgBzsegdMhZdWe/+8u7SVr8yUcwiuHyuVSmFCB?=
 =?us-ascii?Q?a350mP3TKXExIdRdUIUKt+hescFZ3gL2aCH6BEUNOwdTRwLmBm3XijlAQFn6?=
 =?us-ascii?Q?pz0E8D6Hcm3oWZ8n/SPKsF4Fq7g7u3m03UmqZUzjlY6FEN4YrEmYD+yJR7fE?=
 =?us-ascii?Q?xm7UUW3Kq87rqYJnf1bwpDAE9n6LGWCl8ddVu9WHRNdldvMeTlDBv9aFVg1/?=
 =?us-ascii?Q?DWQfx8vtdMRzRMkm5DhaOJAHPsryrb6bjRboj/7UjFu6nGckBRAhVqdzyceK?=
 =?us-ascii?Q?qnPpyJNCG8e+xbEE5BRL/+IgrFwwVdIdNh0wtBJRS9SU3gF66i12JDl7OZ0C?=
 =?us-ascii?Q?yawHIKL9naTr7aF6xTBGdQHA47NsPIWlIsz53Oe4OLNFe5nlvi6d8p5gG2W6?=
 =?us-ascii?Q?A5mvM+91Vl7WrUsi8b5rcJmUufzJy0jSM71Qb+9QSYBp7ooSUlLBuerJFu6g?=
 =?us-ascii?Q?HY4V6nO0CeQh2JwEIEcT6Q+lh4NoxpPRhDeVSw6yWWnCLoipbXINBqnpcbUM?=
 =?us-ascii?Q?2jyUhdmiAkcLfBH1YdypCVH0QMgCAgoIJwhSBNhMs51mFquDGCsJmm9PHv4F?=
 =?us-ascii?Q?gjN73tq0pFfSefSv4Ls57PAaH6J8N5ll5uWNUX+aLhglsPLELMdtNp5aZPKR?=
 =?us-ascii?Q?KEf52ZGxBUyoUQYhqBuXrn3bEW4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3aeb91-fde2-4096-37e3-08d9ca889490
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 05:03:40.7884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CdQs5hzAgmrc6HendciQ5/kIwcAan0h926C3ZT2k8iTkyrzhzHiWvxo2TJ3wa6JqMpwfFvf9w617xbPsoqjVJxOi3rGfsR4Ep7RDdkScmf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simple variable update from "pcs" to "mdio_device" for the mdio device
will make things a little cleaner.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index e36d2d2ba03d..ed16a5ac9ad0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -830,7 +830,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
 	struct phylink_pcs *phylink_pcs;
-	struct mdio_device *pcs;
+	struct mdio_device *mdio_device;
 	struct mii_bus *bus;
 	int err;
 
@@ -854,16 +854,16 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto free_mdio_bus;
 	}
 
-	pcs = mdio_device_create(bus, 0);
-	if (IS_ERR(pcs)) {
-		err = PTR_ERR(pcs);
-		dev_err(dev, "cannot create pcs (%d)\n", err);
+	mdio_device = mdio_device_create(bus, 0);
+	if (IS_ERR(mdio_device)) {
+		err = PTR_ERR(mdio_device);
+		dev_err(dev, "cannot create mdio device (%d)\n", err);
 		goto unregister_mdiobus;
 	}
 
-	phylink_pcs = lynx_pcs_create(pcs);
+	phylink_pcs = lynx_pcs_create(mdio_device);
 	if (!phylink_pcs) {
-		mdio_device_free(pcs);
+		mdio_device_free(mdio_device);
 		err = -ENOMEM;
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
 		goto unregister_mdiobus;
-- 
2.25.1

