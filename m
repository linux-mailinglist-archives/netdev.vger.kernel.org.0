Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7D638910E
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347965AbhESOgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:36:11 -0400
Received: from mail-eopbgr50128.outbound.protection.outlook.com ([40.107.5.128]:4932
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347952AbhESOgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 10:36:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDwW0LMngTn2O6fRNulfZQtwyYcyEUrE0/LElGoCNLPcimokb01k9kCMoc17IljUny+66EQV8STaalLJKo+RHzlbJLHiw7wmvXXCCNzN0MjCQKyQlrYxDaEiOn1XLhF34kj73KL05S1ukvKbUEl11gRGSYOGzeGRN0D39dB0zIHDJ0R10HCH3W6GOjdDkApRsXxeeMdGnw6IsPlpcB/Nc53Xhpp943tDhN5L8XrJ9JNeybiDR+x2YD0W0uhl5iKDoaCZi280PlvOd5fdOp5ukVD0XhMJtGS4/0deN7Oikg3rOlFI9Ky84LqdseTmmx9xSAC+6HZvnXBoepB8RbV8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=at6np8YpD6vbG5XkPNhnpT8Ue/atgoAQkkRRXoPY2rU=;
 b=QPPixJzIv05ur3FQyBCJA1QJppaxwBaZeXSKfwOOdSbO0wpkRGiCZqJlJoTUJLq82eEQmEDNlwLCIhgBl8XrS4bYNlM31j4O/hfuTqd4Y/DEC3XFrENR6ah6rFlcLLLkScibblxI7ajC9cpPSxU+eBaQTQAl5Hb7faW/JQxI+85yphuAnfZRBMUx5211FGg1tGQJnyaOSG4Zs14p4FqCXolMmLOCnyTOk6amfFtUrshUtbKtaX6xKZK8zfkjL7lotE0WzxgKahJmztJfCindkicc6Msl66iCULEtCElw/Xki0Q+0e4QbX/ROkg5YHHioNWhTalnnRI9/CQIXq/IWFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=at6np8YpD6vbG5XkPNhnpT8Ue/atgoAQkkRRXoPY2rU=;
 b=CG3V5VP3MPoQhs8f69vECcvpS2Dk7Rf0Le7h2pACVlHp4PGRxx8NPpV6k9mee66QXSOf9IDWNasKELimPKmQKqb2+RkS6tSdSb/JU7dYVlMwsElZJHAzpaS620Be0eWEBtYwz7j5UVhpTxP5ABBLdRU5MCk3MLO+9oVy0lyGIBY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0058.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ca::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Wed, 19 May 2021 14:34:42 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 14:34:42 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 1/4] net: marvell: prestera: try to load previous fw version
Date:   Wed, 19 May 2021 17:33:18 +0300
Message-Id: <20210519143321.849-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210519143321.849-1-vadym.kochan@plvision.eu>
References: <20210519143321.849-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0601CA0074.eurprd06.prod.outlook.com
 (2603:10a6:206::39) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0601CA0074.eurprd06.prod.outlook.com (2603:10a6:206::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Wed, 19 May 2021 14:34:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eda62854-34e9-4560-674f-08d91ad33d62
X-MS-TrafficTypeDiagnostic: HE1P190MB0058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB00587DFC3FE988A49386F0D9952B9@HE1P190MB0058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:254;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c+j5frUZE7BAyyNFkGdkXFhXmw79wJrrUEOqc/wIXve7enjeXJM/Gsm9wV12t6unj0qa/h5hp4vx6erHLtA9mO6y8PTigKhjB4GbbuDNhyN0LZIQykJ1N18GoISIXPjT8WX92jrdXPRcgXGAGfYfR6cVMcraGhiP3Cp4e6NlwWLJ+rqhwVjOcSWwbhuIYSzXBuZz0VYml2wOthgMbZogtP0Cljog2tNlgnfLr53qUkPuwW67uBjnRi6Fw2D0+G931k4VJMfsFfBQ/HZSt3W+4XbYocwYcnYUvS4KUBQaC5qgPyafUnEYP1uF877aHQHKVM7wVb+T1fJC7BOdVqa59DutfVsMs9IrTMQhip4rdl1fAmi82zQAOmol2bULETFyTmPGSgABmlWu+5F+RV/Kmf4pY8jkr0jsWLhvgQoqEgvckqsSwhKalzRDUIRFm1Ik1gA7HGotg87Qu//tNDtApCPVo8vKJlozY0meDJ3oLHmJb4cKxxMeqMADGvO/w4hqOuTpcckC9isplZknx6gOoblwvR9jPVZ7EnX7r9iKzXgJLjjVz/aoNXRaRK/OIBbRp9cLhxkD3tmFKLlXTNFL6r+faBMWuL7CQ7IesUwd8s+kzWjUE+2vPhNAqOStoHxbffYRFcPnDePwpFnUC8fkOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(39830400003)(136003)(346002)(66946007)(478600001)(4326008)(316002)(38350700002)(38100700002)(52116002)(5660300002)(16526019)(66476007)(110136005)(66556008)(186003)(6486002)(54906003)(2906002)(36756003)(8676002)(2616005)(956004)(26005)(86362001)(1076003)(6506007)(44832011)(8936002)(6512007)(6666004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RqHwS8XtOvjJc1JopveUWLBm6nLjNFi7eQzkqiwdTOvmGggbAyk6l3Q95Dn8?=
 =?us-ascii?Q?WmGZDViRN8aTQjQ/vTEhK4Ywl2R2Negc86kbqGp8Jd7jRrxG+KlQ983jfPgG?=
 =?us-ascii?Q?iAxYRsKCV8/eYaYZKh1uuDBazwLGwB1IRIx405ARrekJXRh8Ne8PStZfB7/v?=
 =?us-ascii?Q?9l1lvAmyyDx8k9QAK1lf6cNkMrc1wXNTLsYPHyExpfjxTR2lNuJDyAMAAK/r?=
 =?us-ascii?Q?xJwGhBNGrRnhhYMDDLe7K3P/Vfn2++qPtwxCI9y5Qyoz+WUtn1htk+89fhSj?=
 =?us-ascii?Q?z7roPI4YQd+6O0AOwG81WUccGlMPQW3b+svsJ2uYo64OUxxVctgr3hhAj9OI?=
 =?us-ascii?Q?k4a1ilfjWv1rikwN7njihEiFkIR6bZNPNPbMSlVMQDNuaRP9YN/uC7FLPKze?=
 =?us-ascii?Q?iIPySTF6EwLg7QzcriijYnicykvhBkdau2ovUkIZ18lUV4BEdd7vUKe30EHJ?=
 =?us-ascii?Q?d+JdAzRb5UWNiT/crFVSnc0dsSaDcf++rhYLWOq+EuaOOcKZpoRaiWSBJlGy?=
 =?us-ascii?Q?xKm4d0zHFGBI1w+ze3sTzIofexgLG+TrSKx12t9EUzN7NrqD/Go/fKU4fav9?=
 =?us-ascii?Q?5c14ykmB2I1VBVOziKrjcP4POjY27U4EET/s6KAkQSFaI7tzk+owTOUDMIj8?=
 =?us-ascii?Q?NSgfB+z7BEZVHr5+ZqqG4ipx+uBuirgQ5p0HkFLammel+v3HFVJheexjV4oC?=
 =?us-ascii?Q?URP9G9tUl2YnJytW1zZqtZX7YcvMZL5LIXHAIJFBzu3xYwq/+VGZFyrSNRqy?=
 =?us-ascii?Q?4fezvlE9ix6aV8quC0K2jHKZcxKrJg8qd+XwHzSpHLg7rXv7Wy9+f+FWdrwe?=
 =?us-ascii?Q?BST1dQy2EI1itFgMuiWg83FrW7SZn/xoFqOPjlBYFOk5EDYV3IlYCyJzBJpH?=
 =?us-ascii?Q?PPbStEAsfCiSmAWOSHG/x60epYouCxpcnc+vh2/lG0C1Pyymwy0syCO6Vf2M?=
 =?us-ascii?Q?T6ZUGSgqxXeP7ued260HqaPG9+lZtYxhh3K5ulHDYqRfXZ6grFBBJ/Oa6MGF?=
 =?us-ascii?Q?j3Yldt7j7Lk61JFQf90c9u3C3JJW/ECWfIeM4K3joNra/p3UD3c7FLjxuzLs?=
 =?us-ascii?Q?LgZeSIAH82goBqfgsD5sdeq7gdFn1UXfAP/VbEQ4ydG9z6tjeLhKet+cspqc?=
 =?us-ascii?Q?gD0nKTJNrplfSYUMk4czUwncdhrnQSZQVgvRJyMjUkHeK4Kz07lBwiy+vKrQ?=
 =?us-ascii?Q?ekYZIeQWtNjo2UGPFWRwgJpMpvZJIoQdPVFwAQhOdEgilCH9fZMEYVx50nYZ?=
 =?us-ascii?Q?VtZ8N72fe2AOggrcWA/yxmTa0m7E6StWjdYGv7pR1WK2U+gCnOpqCH/aLAQZ?=
 =?us-ascii?Q?QGsXu9QZR2cGczYkGQqeJDdY?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: eda62854-34e9-4560-674f-08d91ad33d62
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 14:34:42.1315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SC2D4s36j1XvtNgj7PfNgn4+fmwXu8pUieH3faLHc716Erny9E3TNU/uHJ96zaWsc9+iK1AEO4VhqFV0vlUcAYOktUwdkOd6mok8V9rC/ss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Lets try to load previous fw version in case the latest one is missing on
existing system.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_pci.c  | 75 ++++++++++++++-----
 1 file changed, 56 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 298110119272..d384dcacd579 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -166,6 +166,8 @@ struct prestera_fw_evtq {
 };
 
 struct prestera_fw {
+	struct prestera_fw_rev rev_supp;
+	const struct firmware *bin;
 	struct workqueue_struct *wq;
 	struct prestera_device dev;
 	u8 __iomem *ldr_regs;
@@ -576,25 +578,24 @@ static void prestera_fw_rev_parse(const struct prestera_fw_header *hdr,
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
@@ -609,11 +610,51 @@ static int prestera_fw_hdr_parse(struct prestera_fw *fw,
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
+			ver_maj--;
+			goto pick_fw_ver;
+		} else {
+			dev_err(fw->dev.dev, "failed to request firmware file\n");
+			return err;
+		}
+	}
+
+	if (ver_maj < PRESTERA_SUPP_FW_MAJ_VER)
+		dev_warn(fw->dev.dev,
+			 "using older FW version %u.%u than expected %u.%u\n",
+			 ver_maj, ver_min,
+			 PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
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
@@ -632,30 +673,26 @@ static int prestera_fw_load(struct prestera_fw *fw)
 
 	fw->ldr_wr_idx = 0;
 
-	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
-		 PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
-
-	err = request_firmware_direct(&f, fw_path, fw->dev.dev);
+	err = prestera_fw_get(fw);
 	if (err) {
 		dev_err(fw->dev.dev, "failed to request firmware file\n");
 		return err;
 	}
 
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

