Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E1938B358
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243516AbhETPhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:37:23 -0400
Received: from mail-vi1eur05on2090.outbound.protection.outlook.com ([40.107.21.90]:8577
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240517AbhETPhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:37:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYA6Nat/v0kXeJhRUqNIDMbD023sPi5pXVKadTSOzDhMeNOuBoIbe0ug0NCoBQ8HNro67+boMUD3SdifbbsK28tosblO9dCGCbPWS//9pQn3p4vxmrvZ3GtYY4CI9TvMRmeignHcNUDqwICqsHWb7VC9zYvlM+1hCxcH8f6xlOyRR6DJ2vQNNg3cZnkX277XnYNyRioCpWRqfzhsQHKOSSyZkuxRbMYd3PeWUmmcdzqiWSikzx+bce5YU7hBN1xc5bWU5rICvpq67RhaGSby2UigoDIlnfA6GJksx3uXUnW0EqebYfo5U82bNebouT9YEaAeTEDnZ1KNd+k8RoHEKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05sY2SRMHPIV4oXtcsnvXFpQaIN1643PIPcK1mV8zyo=;
 b=I3TVmGrEX2o3Rg+6mG+TsUipiLH14e1oKyEkPOI4feRajtyGuP3F8vSCuH0elY8xw4fpfzhps0qwIFbmO0P5cL0RNnKEJF6xr1Ww/JQ9oXibWdNcW3qxKBr0IGby9YhUHMxAh5SBhrsysaBqvsLzqtLw3ZLtaEyIYr5jdEfnlRP13XfuW9fLeUn7WBs09pr7DAyTIe8lWYPiw9qLm7eaoHlfBKMmx7AJOIzi0Vam08a4rl0k7Fj7qWO3PbckbGzrUgnxHXUDskxrfw6EmoV5Ww8jYoY7GBYdmt8V44Xr2ciwLIklr59mCr28cvQ9E5JtcE8BL+0NAuLSUuemcnpKfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05sY2SRMHPIV4oXtcsnvXFpQaIN1643PIPcK1mV8zyo=;
 b=XVMXhaVJcDz4FIHedaXAyM15VllUm9CwmVc7438Eo29IjruX0JyIGIYpL0/OYZups840E1yZoxndAPMkAL+mPGKOzYXdLRmG+FWsbJTFzAxr+0YwakbvJpozgir+3PHi+CRhVyfdrN38bxvkH2lA1soMJDe8YCHe/+NfA5akoVc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Thu, 20 May 2021 15:35:47 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 15:35:46 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next v2 4/4] net: marvell: prestera: try to load previous fw version
Date:   Thu, 20 May 2021 18:35:00 +0300
Message-Id: <20210520153500.22930-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210520153500.22930-1-vadym.kochan@plvision.eu>
References: <20210520153500.22930-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM4PR0101CA0065.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::33) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM4PR0101CA0065.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 15:35:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cd24824-bfde-4859-5f50-08d91ba4f024
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB02684679A1AE4158DBFB38BD952A9@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:216;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RP571Y7hY8CRi2HhaGVjk45hcTdbVjblgkmPLjQTfvC5UzZ4VlJHvYtHNkyuOSpgb6a6pLNnUU+GGdklq1h5kxorHPAKzj4250tA9JVMj3pQS57Bibdoo29VDvjsxgOVlEsr//Psm3ZofG4vjrOb7ar5OrjSVveU8ubcWVFPfY0no3iNt7SG1tRcoc0K167L3W0eJKMIgeKrc4iNw1DtMP+4UHOsoZvnOQYxzSaNIlFrDQhlciELP7hwRQR/g7okxpEplk7aV7eVZYhuHGymuMloRBHMNoYMFXsznu6FUKOOgl6v36dgUz/C89zVSmuxL2Oj5/HZC3WUYC3cmAYx34ZRJHEFKMsSlqVhHzq9LQ71z9Kpr3f0gwuexTnt+0c7zp8rHuQpINL9Ac1cknOgt9y021frBXp2kYSe2oWD/4h+Ifh6pAofLIkvmUCxlkEJLs7akCoh01iKVVCjPGNJ9ZEEA6zq2puHvSupIYmV75bJH1c8Or46yWDYieMxu32uZXSA/uNEbj1THsNQiuXSUFuNfVv5L8mxXBD2srjfTOfn1LE0i9+IJnH2cyoRs12p+Qf5wFZsroEdPnI0/oF43MSRVWOPEN4p7mGEkASHlu3oA1TwapROf03lWOxe3YZzYGxDNnmEUZ36dBb01Giz+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39830400003)(346002)(366004)(6666004)(26005)(5660300002)(4326008)(6512007)(66476007)(8676002)(66946007)(316002)(66556008)(110136005)(956004)(54906003)(36756003)(186003)(16526019)(52116002)(1076003)(2906002)(8936002)(83380400001)(38100700002)(38350700002)(86362001)(2616005)(44832011)(6506007)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+PRCXYixVFsl1z9024c/9hf3FhWTTRk6rIrdJHVe1hVtkpDM7JVGpMXVNYxB?=
 =?us-ascii?Q?YH7fn2ff5ixTSEsXbSmTGyULDm28MCTPf8ixPGKJB7gD19BVIvwCZVT4wcH1?=
 =?us-ascii?Q?dl0QIY8jW526uMQ7NITkJGtW1cjIKQaPoTnat0SyA7IxfGNum5Eht01nvkqP?=
 =?us-ascii?Q?A4+sBFO1bvJzWlNzVKlDV0y+pKgRfKm8iPNO54axyyk3tSDqfL6Z/h9JUaHK?=
 =?us-ascii?Q?DCY8oQlmmD3ZaKE8huYTGn+5pBq6uUeRgsvd4V8IuEbT8wbh4tQhWImANBTt?=
 =?us-ascii?Q?Yv40zpii/cwCxUS9QScLHqHofygngdI0KdEwR768dc1I/Pq6d/M4sX+9Cxi6?=
 =?us-ascii?Q?5NxKaLfRkiZ2wly4omYRmgaWappweY8MWdXIattRAsSnWQI0V8jKSE3F+6pq?=
 =?us-ascii?Q?OvhuTRdTbTcSylWoA4pyMcdIf/jFKF+plzMi3Rz7BbEUZCZlXa2ujLGr0//Y?=
 =?us-ascii?Q?EKt1V+X+64k5Nt2A82EZQn16zZf2xFbSHnRq58Y52yudcVT3+W54tPiOAbye?=
 =?us-ascii?Q?dFdoq+R3ajiCUijc4qcyP/lcMUWjKhsU+WKH0ZEo/jLPAQla0NqIaaaTOrMp?=
 =?us-ascii?Q?ZAQMADMaNLFjtNS7CCH1KUyz/q3WrnLP0E06TPjL+C91EECvC8iYpu6alqj7?=
 =?us-ascii?Q?2+4nc2nmcb5IOKpNxXPyYGfYpZozSlvRkyaeXFSWvYXtIpDrkYH/pOHdipUL?=
 =?us-ascii?Q?xrxNS5YbvafojqZemy1HBg7qyzoml6nWYTyJk0E5fxSqIQJbFWuqXb9tDT19?=
 =?us-ascii?Q?PQGRTp+4dAvBqVFzmEkyROGcYu+4ALXY+94UxXJ0Zbll6MKr9WaO5wKBuyh5?=
 =?us-ascii?Q?2bTZ95nXNcXiSoWvdXRoZrRqhIHv4nQK0SOUEp3VO0lsWiTRk14vgHXQn4qV?=
 =?us-ascii?Q?NUfBH9MYxapsE8gukLpjWVnjJXfGFRvnp/8ysmP7IktSFBqi8N2VwUOapMMC?=
 =?us-ascii?Q?bTBBb3XlWXbskHr25BrqpTpJWS8pfCQVE8bVAs1/LFLkGc0Av77kbstXh5uw?=
 =?us-ascii?Q?JUKJQbLfDf5PJMQOwYl8crOs9OUpeGynokvMjjZQ58TsY3AKs9+0Mmx22B+3?=
 =?us-ascii?Q?3qyY4mt5HO5NG1HuwYPj5wOYuo0qaMxG+v2cAKZcAX3vK9z657T7mEhZ41tj?=
 =?us-ascii?Q?OUwLsJAHqpue5pm6Obe+/vZTdmuXEH9gaRnjpD/plnEIGAF2P73bFmjQf0zK?=
 =?us-ascii?Q?ncU4EDrrRZ4oMaa3RVyQydfMi6Smi9amQCi5L2Xi6ySLYqGv3Rh8ecDndF+I?=
 =?us-ascii?Q?bo/SYouK5ePHxgGvwYQSsk3c02qTYhLRZfzHGKCEz9Db4TugCvrh31XHvkQ2?=
 =?us-ascii?Q?N0xm+zmErEn0D64A6f4eIPK5?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd24824-bfde-4859-5f50-08d91ba4f024
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:35:46.8617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnHXb9956wO/qEdoq3KNgzta8gBX1C4TTRmj6faQL2otzDMqIsbjYuXCd8i2WNq0JrZBtt49yI1HiIl3GpTX2kxIDq/cbVIaaD8lqMtoCEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Lets try to load previous fw version in case the latest one is missing on
existing system.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---

Notes:
    RFCv2:
        1) Get rid of automatic decrementing of
           major version but hard code it.
    
        2) Print error message with file path if
           previous FW could not be loaded.

 .../ethernet/marvell/prestera/prestera_pci.c  | 83 ++++++++++++++-----
 1 file changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 5edd4d2ac672..a250d394da38 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -17,6 +17,9 @@
 #define PRESTERA_SUPP_FW_MAJ_VER	3
 #define PRESTERA_SUPP_FW_MIN_VER	0
 
+#define PRESTERA_PREV_FW_MAJ_VER	2
+#define PRESTERA_PREV_FW_MIN_VER	0
+
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
 
 #define PRESTERA_FW_HDR_MAGIC		0x351D9D06
@@ -172,6 +175,8 @@ struct prestera_fw_evtq {
 };
 
 struct prestera_fw {
+	struct prestera_fw_rev rev_supp;
+	const struct firmware *bin;
 	struct workqueue_struct *wq;
 	struct prestera_device dev;
 	u8 __iomem *ldr_regs;
@@ -595,25 +600,24 @@ static void prestera_fw_rev_parse(const struct prestera_fw_header *hdr,
 static int prestera_fw_rev_check(struct prestera_fw *fw)
 {
 	struct prestera_fw_rev *rev = &fw->dev.fw_rev;
-	u16 maj_supp = PRESTERA_SUPP_FW_MAJ_VER;
-	u16 min_supp = PRESTERA_SUPP_FW_MIN_VER;
 
-	if (rev->maj == maj_supp && rev->min >= min_supp)
+	if (rev->maj == fw->rev_supp.maj && rev->min >= fw->rev_supp.min)
 		return 0;
 
 	dev_err(fw->dev.dev, "Driver supports FW version only '%u.%u.x'",
-		PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
+		fw->rev_supp.maj, fw->rev_supp.min);
 
 	return -EINVAL;
 }
 
-static int prestera_fw_hdr_parse(struct prestera_fw *fw,
-				 const struct firmware *img)
+static int prestera_fw_hdr_parse(struct prestera_fw *fw)
 {
-	struct prestera_fw_header *hdr = (struct prestera_fw_header *)img->data;
 	struct prestera_fw_rev *rev = &fw->dev.fw_rev;
+	struct prestera_fw_header *hdr;
 	u32 magic;
 
+	hdr = (struct prestera_fw_header *)fw->bin->data;
+
 	magic = be32_to_cpu(hdr->magic_number);
 	if (magic != PRESTERA_FW_HDR_MAGIC) {
 		dev_err(fw->dev.dev, "FW img hdr magic is invalid");
@@ -628,11 +632,52 @@ static int prestera_fw_hdr_parse(struct prestera_fw *fw,
 	return prestera_fw_rev_check(fw);
 }
 
+static int prestera_fw_get(struct prestera_fw *fw)
+{
+	int ver_maj = PRESTERA_SUPP_FW_MAJ_VER;
+	int ver_min = PRESTERA_SUPP_FW_MIN_VER;
+	char fw_path[128];
+	int err;
+
+pick_fw_ver:
+	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
+		 ver_maj, ver_min);
+
+	err = request_firmware_direct(&fw->bin, fw_path, fw->dev.dev);
+	if (err) {
+		if (ver_maj == PRESTERA_SUPP_FW_MAJ_VER) {
+			ver_maj = PRESTERA_PREV_FW_MAJ_VER;
+			ver_min = PRESTERA_PREV_FW_MIN_VER;
+
+			dev_warn(fw->dev.dev,
+				 "missing latest %s firmware, fall-back to previous %u.%u version\n",
+				 fw_path, ver_maj, ver_min);
+
+			goto pick_fw_ver;
+		} else {
+			dev_err(fw->dev.dev, "failed to request previous firmware: %s\n",
+				fw_path);
+			return err;
+		}
+	}
+
+	dev_info(fw->dev.dev, "Loading %s ...", fw_path);
+
+	fw->rev_supp.maj = ver_maj;
+	fw->rev_supp.min = ver_min;
+	fw->rev_supp.sub = 0;
+
+	return 0;
+}
+
+static void prestera_fw_put(struct prestera_fw *fw)
+{
+	release_firmware(fw->bin);
+}
+
 static int prestera_fw_load(struct prestera_fw *fw)
 {
 	size_t hlen = sizeof(struct prestera_fw_header);
-	const struct firmware *f;
-	char fw_path[128];
 	int err;
 
 	err = prestera_ldr_wait_reg32(fw, PRESTERA_LDR_READY_REG,
@@ -651,30 +696,24 @@ static int prestera_fw_load(struct prestera_fw *fw)
 
 	fw->ldr_wr_idx = 0;
 
-	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
-		 PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
-
-	err = request_firmware_direct(&f, fw_path, fw->dev.dev);
-	if (err) {
-		dev_err(fw->dev.dev, "failed to request firmware file\n");
+	err = prestera_fw_get(fw);
+	if (err)
 		return err;
-	}
 
-	err = prestera_fw_hdr_parse(fw, f);
+	err = prestera_fw_hdr_parse(fw);
 	if (err) {
 		dev_err(fw->dev.dev, "FW image header is invalid\n");
 		goto out_release;
 	}
 
-	prestera_ldr_write(fw, PRESTERA_LDR_IMG_SIZE_REG, f->size - hlen);
+	prestera_ldr_write(fw, PRESTERA_LDR_IMG_SIZE_REG, fw->bin->size - hlen);
 	prestera_ldr_write(fw, PRESTERA_LDR_CTL_REG, PRESTERA_LDR_CTL_DL_START);
 
-	dev_info(fw->dev.dev, "Loading %s ...", fw_path);
-
-	err = prestera_ldr_fw_send(fw, f->data + hlen, f->size - hlen);
+	err = prestera_ldr_fw_send(fw, fw->bin->data + hlen,
+				   fw->bin->size - hlen);
 
 out_release:
-	release_firmware(f);
+	prestera_fw_put(fw);
 	return err;
 }
 
-- 
2.17.1

