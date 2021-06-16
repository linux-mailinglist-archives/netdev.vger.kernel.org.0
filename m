Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6043A95C7
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhFPJRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:17:38 -0400
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:46362
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232322AbhFPJRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 05:17:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFeqp2CZgjj8xriO/QAKBVAmeRgPGnJAV+5gvbwOoZJOHfY2XRBfyJRXzZrL/5IXZ96WIOEoCkGbi6nKx9z5W/GTeq9BM7utuWke+F6W1gy31VN8wJ2+HDKXDCC2DKJT1dR33wuT8UQo6CJtIpGxPmPjtNvzX+eFIVLSkVwheC73bCQMuMkAZ5eoRAxBF9l6obz/JO8Gjk/ZOo2G2LsOBdpusS/G9ra9oV3zBCRirls/aCyCs7Uk+E1LJakBJD+4QOrEMusI2xL/zWWqSvxVqnQpwBj4IzkmWxlGZqHeJZt4xyRAhrRTVQwGBnjXxqo89fi/KHr/LiG9XHrCuL8fww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8r0RcEEPidCAPGUlXARw+T2Pw8jT6UwcuOajhYiiWE=;
 b=aSl4KyAaYpChmyq0K72Xb9l3vypjcstFGqkjmEwLA29rAmHiaBfzjUqO8HURzo8i3ZF6Gh5ipo9AmimUHOdZizDcfAhD/KHQL+4RYI3BkgkK48TF8pGYCBF6JPTD4fRvQbzVgAKX01uQu358TNVIV4I9aH3crswTH23t91D+3/dls2b4ZyC34mnCVcvOJjNzvD8vyWHdYc69gPVTsXun8rYZWPq4K0aITrxIIXeWqailPjIjmXmtJA4u6cL/PgAJJQC7gcq1ElOuRVCy3w7iyjT5VFWAlinqMVjymdx79mqfoDfVA+X+l+9QtD+hTFl96XNhKmufPUS+VK+pwGWgcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8r0RcEEPidCAPGUlXARw+T2Pw8jT6UwcuOajhYiiWE=;
 b=P7MNd1lA/4M2/5NvI9TgcNLZlx0sxz6V1TbM4YWSSKlgyW4xCWkTSODvbpYfWEHO2CTDkmeQxf7SYd/ncUmCk24zo9sn9K83BlXoulQrYELZmZ6M0JHnZWomnOw7EfiDwZBE69EKIdvSkJa5q7MhM8Mog0ZK7yA8RrmqA7zYCK0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB4735.eurprd04.prod.outlook.com (2603:10a6:803:53::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 09:15:27 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 09:15:27 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Subject: [PATCH net 2/2] net: fec_ptp: fix issue caused by refactor the fec_devtype
Date:   Wed, 16 Jun 2021 17:14:26 +0800
Message-Id: <20210616091426.13694-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210616091426.13694-1-qiangqing.zhang@nxp.com>
References: <20210616091426.13694-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To VI1PR04MB6800.eurprd04.prod.outlook.com
 (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0081.apcprd02.prod.outlook.com (2603:1096:4:90::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 09:15:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8de3302-36f4-4fde-32f5-08d930a747ae
X-MS-TrafficTypeDiagnostic: VI1PR04MB4735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB473570A63DAA86D1840FED06E60F9@VI1PR04MB4735.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z+gXvn0ffG/uEF/QGvjPlMtFG9ClQ9aCwREVpuDmNhKjka2Gfgv+KNUly3rtoEwM0IU6v3BWRFqlWpcSYukhKj8tVrXqP+WZex0dxI0ntZVoFKuz77vcwty+Gk5pjCzLJvMp005xoyy37Cwhnea7NM4G7r1vfnexputXHinBzotbBfq6iKN8y39EBwIqCD39VclnH7iYihBTLxaGtpg1ITpHCQCZg5I7PCmjHfRzw14ZveVVrTDvtnMUkN85mEYVafGJYbmTs057SDeVa5AQA4660hZPLioEi68CJv4Ci4KMSCXs9qQ8CP2uojWNkBqmiyGzsvxvFh6Pmo8bTU+cMWMdbTh1ysAFaIhcI1aoG/hPlL4udl8hfywg9vz9sAFsjpP8Wn6gthGj7OudAruFWdRqu0mfoEHOc8TqAWISqn+V1iCGm1e2XcQuIcoZRN7eLdilE6eOUySsJx0vethh7PqIyPCxo5xP66kkZlYgCShd3CeysvPDxf0WhDKVyUAB0jb+7m3TGVp5if+zJzb6W7JN3eeba0Hc9uSiF7XdNX643YgAvXtnllSCRsn/HYlYCHmcR6+Trj/ORELV7j57Pv1ygYZkhWgaG+jKO+DqsDVmaTO7w+G3XYzg8hZQwzn839B4GRhExgzYmUbNKD4CPMM1It6Q0PrShxdSc1EPKgSk6bP3fSEmS0Fz02d4tdrP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(2906002)(36756003)(1076003)(186003)(38100700002)(26005)(83380400001)(16526019)(6512007)(8936002)(38350700002)(6506007)(66476007)(956004)(6486002)(86362001)(2616005)(5660300002)(8676002)(4326008)(316002)(7416002)(66946007)(478600001)(66556008)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8N2ATCvVgZwkOZLS9pIVMMaxDmqYhcFzEJBXXYx3lMtgjp52S5AAGvKSZOuX?=
 =?us-ascii?Q?beLSNqJffc1qjkQS1w4nMcc+YV5CWEJZHyZDcp5nzdWf3B/BVHtdF4RIzP+9?=
 =?us-ascii?Q?U854yVyaXjsSO2imfjf2oVFQc+7Fxvolbtk2ELa8Oblj3+fGZARlOgKDvFNd?=
 =?us-ascii?Q?xjcGohWef8ln/z/Ru5RyZWBvFWL+bcL6E5lfW+7cZhSEQTyBdhUg7bAjs3an?=
 =?us-ascii?Q?vdMxH/bGuflFmT8xv+hVs0lvDIbrRWcKkk3PrIImUWb7L+Sq+Jhlhz9k1PJv?=
 =?us-ascii?Q?cY0WMPc7MeGzEFHg3GXsfenDSORUKw4W2wL/Jwn8ugZZzUl26smsI0bGYd21?=
 =?us-ascii?Q?oJ1hpfRb3aHo0qzMEzX936gLwzbb6SMJyB4/azopa5uygwdmK1myS2EvrAEM?=
 =?us-ascii?Q?YE7igBYR50O8Cq8aFAPeIqrKkWQQQfjQD+9OJuDbJigxOGx8cJIFdSIAhzxc?=
 =?us-ascii?Q?LQa9VWCvSMxMZkY1pH9uxPRL47J6RS3zfog7FqC6JKDPZzViNTFCBHJ/P6OL?=
 =?us-ascii?Q?JHXEjFtO5edVQTVpDlN1cV7tSFQnOSVwDG5Ps+hYATQFgOrZX72FHTxlLz5s?=
 =?us-ascii?Q?avEk+ePOYNrpGhGiJJzeM/rb3r30tlGLP8DNX32LXo20Exc08bwMXvPPkMcc?=
 =?us-ascii?Q?CC8mWwkawBysxjmRaEut7tVkMPyt0W46M1nHychHhrHNMYFVoa2FWko+toAB?=
 =?us-ascii?Q?aGB7QKPLJ3Vu7dYqpxpnfXZYVz6tuCNIjH5hMq9JPM1BrCqT+OIpNHziQf0L?=
 =?us-ascii?Q?5OmJPQDo14crgTdKpssRyQZHPy3/I1w0+fAuim/Q4nQTb89Mmpt2Jk3W32fC?=
 =?us-ascii?Q?4mDzPc3T5fqlxGKgfJMzkMk4pRIwV28ulVB0OEdnuk7s+Z86f1ig9xphlUlv?=
 =?us-ascii?Q?d4XISHDI1MW61tutp/3OZyYxzxkXh9onKAfdpJv2EAk8pYW6giSXcBeKgibW?=
 =?us-ascii?Q?0ZDynQySjwhwJhICjU5n+Cd8LNLBFqzm1kk6igXzHsQnTyybdQkQrEici5St?=
 =?us-ascii?Q?By0FAUWEJCivxWzWKEERbgDFM7eD147/vGpJ+2rlv6cx3KHF+L5SISlEOx3E?=
 =?us-ascii?Q?T1DOpeOPoprIGwJoH0KkmLOozbTBJOFUFqsLY9GJzQMtqAtptiKm5iOqbi7d?=
 =?us-ascii?Q?La38QrWlyf0cX7RksBxRcTef4cBOMeHgo3ql93163662924m4JatOxkccaY3?=
 =?us-ascii?Q?nxw6kYEGE0dAmIF4JU3Cn+V/PU3S0bZ1KOKF82Z+EDQDggok2PmWPZF8fVDV?=
 =?us-ascii?Q?qJ42f3HGRy9lSRlNM/W5gTWdjR6gVHUiIKHG8JaYHZYPNB/G8cLsh9qoHG87?=
 =?us-ascii?Q?6wQIjdw53s8zctXyXeqQZWkw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8de3302-36f4-4fde-32f5-08d930a747ae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 09:15:27.2833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JN6St/3cSKzVEMdpOAgG2g/M/M/HOFcSEpdJ4AHC1rZB3FoitzXpIsZLhTzxM0eeyDqcSMVgsTqAx0X89YA9tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4735
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit da722186f654 ("net: fec: set GPR bit on suspend by DT configuration.")
refactor the fec_devtype, need adjust ptp driver accordingly.

Fixes: da722186f654 ("net: fec: set GPR bit on suspend by DT configuration.")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 7326a0612823..d71eac7e1924 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -215,15 +215,13 @@ static u64 fec_ptp_read(const struct cyclecounter *cc)
 {
 	struct fec_enet_private *fep =
 		container_of(cc, struct fec_enet_private, cc);
-	const struct platform_device_id *id_entry =
-		platform_get_device_id(fep->pdev);
 	u32 tempval;
 
 	tempval = readl(fep->hwp + FEC_ATIME_CTRL);
 	tempval |= FEC_T_CTRL_CAPTURE;
 	writel(tempval, fep->hwp + FEC_ATIME_CTRL);
 
-	if (id_entry->driver_data & FEC_QUIRK_BUG_CAPTURE)
+	if (fep->quirks & FEC_QUIRK_BUG_CAPTURE)
 		udelay(1);
 
 	return readl(fep->hwp + FEC_ATIME);
-- 
2.17.1

