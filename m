Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE5C39615D
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhEaOkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:40:06 -0400
Received: from mail-am6eur05on2113.outbound.protection.outlook.com ([40.107.22.113]:28577
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233025AbhEaOhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 10:37:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvuW0M9NJH9ECmRJde7Oj5uapM48Wbyb/2PP9YdAn3DyVUQQiIZhmZIk1i/g/e/LN3F9RNk0BvyvSTHMZb77F4qh0qrRKHAL/iO74Tc21qsPAM0O8rjEMkAqeU2qkoEEQlHYPtnMiPEeVD2+GGBa5RkTjEw/+/O2FlglTEE4QBK7gFN15op5UouBwc6S/Iv56NZze7WGvv7J3k8yXs7dqcc2iU/e3YrWnfg+qri8Qo0roEBKPSuioXNL+wrQCTq7Wqs1KS+vbfkOg3iW9wPiRw3UxUHBEoxsh14o9u0SdmP8QE1xXt4HYnExiQ5OZtDjM5mJMxkLw8CPwIzDVr7eJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCIlyxVXoTX/u+Ehbc83bcxcKnV13yZZB54XutUckOE=;
 b=nXW5Fg2ywP7TN7FVK0iEjuk98mPXGaD0/Grw273jbD1WBS/P1c2Fwk0uvdcEsr3/z9myzJmqkar1fHFyN17+UoFsxybOLymii6am5nMbG3x9Cg1oOV6i/3vx7zDvCzkir+lo0yYO1DJCtnmSZlhhGtBbglLertwnjJYaOhtn6UOi9Gkp3LAmvTatZ2gsr1tohfXBnUEvOsggHXVhunvNOQnslMWHPvfHsox6f5P5RjkDnLDo/c3ulcTs5cu+o63RmNXOQutiy6ON9lv0hCgUw86n/epGjuUVao4BAr8w8xjqu9XmHuKHtQA5N1orfYSORm3r8EY/Vqxs1hxzk9pVIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCIlyxVXoTX/u+Ehbc83bcxcKnV13yZZB54XutUckOE=;
 b=uefW+RQtTEF0Wv/0aBUa4C6ea8XyxgbB+nQS2gE+kRvS5l3S1AAyskT73c/Xs95Y7PRUBVWm4vKXDecslMhCb/O4Ws9Dbm4gi2pavl6TyslsHJf6fsbul680N+0/AZVj/1yKpunpT7ZwNwRd515j3sAC3TnsiL4nhWRTjqgf2Lo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.29; Mon, 31 May 2021 14:33:28 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%4]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 14:33:28 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 4/4] net: marvell: prestera: try to load previous fw version
Date:   Mon, 31 May 2021 17:32:46 +0300
Message-Id: <20210531143246.24202-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210531143246.24202-1-vadym.kochan@plvision.eu>
References: <20210531143246.24202-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR04CA0036.eurprd04.prod.outlook.com
 (2603:10a6:208:122::49) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM0PR04CA0036.eurprd04.prod.outlook.com (2603:10a6:208:122::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26 via Frontend Transport; Mon, 31 May 2021 14:33:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40a05c35-0768-43b5-df45-08d924410e6e
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB04596DB7C84C00EF982C952D953F9@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:216;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2n83S/Ib7T3HjIocBseR2q4odKnfKfVyj0hxQXfCK4TY8lSwku8eL8w0Dsc/NZ0aVcmGnpZJRO25oGrBT8dlBOuc/HDAIq0DtKQtJNU4rBDVkpQNUVHdUbv4BwHRwEdyXFZH6MQibXDQu5lRRuydRC3WECr2cNS8fsYZDph/tRWAh0xMFzr9W8HLM7dySQuNJQxb5pQUx7XyiGsLqKtGNzl6w0LEB7izNm7vbUjXk59Op6K7vz1OkVaYd4Lh8xjWCP1ru20D9rw71afrtCU5iyITmTSO3nT0I+LsTVv+lEKwBrmm7IrCMlo0QeAHgp78y4O5VMD08aXo0s31JmqfHoFWR9CIiNhAr+5yJMo/hOL0hI6RchHdLLCSI1kL6Uv6rQhTbMukqKg5Waf8BmkkUhrFOZwGwuE2WVAwYl9c9iQailsFoIs3uBRdrI1L7vQaxQ3LyJmjl2229yfuYPnGqi2V0GZLIY0F1jHNuHDZokBfQD8FqS69DGbhe/+kg/Yy+L+j8J35yu5kGVUjbApaYr3ddmMufsGmsbbCeEFmd79dG4lD84toQdjl/hqj1TUw9BHL2A4AueP7m4hjoHZPSgUVTvFJlQK6lmQUtZ+c+lsXf1TzLRmkE9FcuxV+3Hg7k/ouMhdU06gXsj2ujsTQFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39830400003)(136003)(366004)(16526019)(26005)(5660300002)(6506007)(8676002)(2906002)(6512007)(6486002)(38100700002)(38350700002)(44832011)(316002)(186003)(66476007)(54906003)(110136005)(478600001)(66946007)(86362001)(66556008)(2616005)(6666004)(4326008)(36756003)(83380400001)(1076003)(8936002)(956004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pFCaW++bP5OHBaEEcGWC/CVekvHYW8sasJGFGbjxpMG+bB880EcPlSYrcFx8?=
 =?us-ascii?Q?aXvK0hNC0YjpAFL5Dt5kyZWUru3VBa6CXTNSvs6m2d+0UwRMEq0Rkp2sIuoo?=
 =?us-ascii?Q?F5Pwnk8hcDdBiEyo4r7Ef7aUUqzY1nALsXJfJOBxwCDl+jp95JErzgtuwVJZ?=
 =?us-ascii?Q?P5LWcmvrivDpBZuo2BtUFhdRTA93D6RTjt4wq7gUZ7xOhDdPBA8htG63TM+/?=
 =?us-ascii?Q?zc01upWTTwNxakp67Zl/w+1YGeVjnTGx++zxKrF1bls3hQG5mcUVioTPWq9B?=
 =?us-ascii?Q?WHBctEChs4nVYY69QbGWQeVxVlFF77GEANWDfGSJrXsyX98cdQLpdC8f2CHo?=
 =?us-ascii?Q?br8u4sZd3YDmwUlzNqML+Q6WasKlh5MbqKQJD2CsCshoAwOaIn2mgLwQhx4D?=
 =?us-ascii?Q?jr26eMMzry81skJ/zywKqihmmSq3vJOdyL7uzzAW8JxEuBV4FREsNPoEKDzM?=
 =?us-ascii?Q?2NDDTg33ihHQKoW067opqwola3OGSzGsUKoqYFOjhm+jBKTBAoqSNd5+cDz7?=
 =?us-ascii?Q?QruKkLWipbTRxCXncPJh+Rvk9uEapF9sHL2rrHl9Bs3HLqnfBOuCuNvh/N3a?=
 =?us-ascii?Q?HYM4nohYB+nrmpA+m53/wAcJ/LqA+BP0+bhUDgOzoozmQY08XHGCQzYoQ2lo?=
 =?us-ascii?Q?ArurxfJAZvz+dF0UofQouK6jNi9xi4aCJlFRaApqvko9inyFhL3sL+KQpy8Z?=
 =?us-ascii?Q?hQUaDksxuJEH3dBlNXW5ixEyGmB5KruCwMTnOEP75Ks3nBA+CTZfeQ84RR00?=
 =?us-ascii?Q?QUTMNUbu7x5WkJY+gEgLrbzH9HdXzNl5JhQWTMw6XaC2+N3JLzuIeNnw+nT3?=
 =?us-ascii?Q?FBsW31J35sU/LKFC2+t3fW3OEzDvbWQTVM2zYdYc4ssegDpCV67+CC5wxeOk?=
 =?us-ascii?Q?xotTHrCxuta7Oy4DUbfQe4jIv8nJ5HIXgXg9kZ0P1PI+dRu4Nto7LKYl/RP5?=
 =?us-ascii?Q?HeaEV2bbO9mXGosEQeJes9f4URrp64qOlvIK2P+YcncHtcIpswATlnGyQfx+?=
 =?us-ascii?Q?H/VFHvcuZzFrSEXsYlgejjXsNvGDicyIg3Br8MC9A2lVh/zVgcKSMyYC5FUM?=
 =?us-ascii?Q?fAz9JXpp/1mGJygo1kTeikLp7ETohgt4ul6MV6hxOV6ovGDlvdcZLDjYaxvI?=
 =?us-ascii?Q?2CuQ6R2JsvkMMb+WaWvep3qwwAl4xAUzFPJjI4JxOQwBBlQiNDmLEVNKCTjC?=
 =?us-ascii?Q?iPXkpPCygG4rrDJB0CQEH+LHLl0NjA8LJis2LRogmLMigUK0TTxydOyTi0Ym?=
 =?us-ascii?Q?5xmky2psAkmYexqQtEpB+348gTjLyZy54SAaCcUxiwoBRHQYQokLWk2X5+L0?=
 =?us-ascii?Q?GsEWppgYLhdoDCQu8dGTphuO?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a05c35-0768-43b5-df45-08d924410e6e
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 14:33:28.5186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ESRc4HDSrDz8f2BfkEbF5j3PZGvOJblCpKAjlUosmzXQqSEi7kMtK/DDjNYjDsvTyB1t6j8VbrsnDsHlOY+GXA/gPhwVl4h1Nsc/rv7oUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Lets try to load previous fw version in case the latest one is missing on
existing system.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
Notes:
    RFC v2:
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

