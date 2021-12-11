Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CDF4713DE
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 14:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhLKNCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 08:02:18 -0500
Received: from mail-gv0che01on2122.outbound.protection.outlook.com ([40.107.23.122]:53537
        "EHLO CHE01-GV0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229578AbhLKNCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 08:02:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLMpSN+ZPXIpAI7jGLef9NiiYLeSq7cZWc8UeemFfG888POuWWTtHEz3XueKwe3Up5zDboHw1cOPAZ3oqfO1Oc6uzYPbstQmNpx+LMm569MdjoQYtFRVQD5Hvp6dtE0aSpN03PUB6zkknsAc+6zsiZiTgXq2u+6+luhFTtTfomK15Ra+BbPwq6rr27YCdnIF2p5NMKYAdxRxXJwRkOVo8KKWdJj/DtWVHypUvKc8FCjDZ9L4fLA/1vDpQoHjgsKeP3O1VpietRu8Og7fOTqVSv+EhZhB/ONOueZnZwonnAd5HpAGmkHkq39C+x2s5D90J32Ue+wEPbx5ZLORBbHCqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IF0TBg/sB6hb1KuhDMOpyZpeVOUc7DyyeqDjz0oYhlc=;
 b=d/alYO+ha8+rW/E8skkAcUzB2Kh+rN2msZGkJDgojcsNeGQm7jnvQnkGLKgx7Mns4SYdQ0fDhs9uE74c2zk51iMWSuTZwUlcpuQSjIn6rMut29DXxzfozbV2BEeHu5w/mO4EhVjh6LdccyUG2RTbrbtxqKb1vnkEnIVtpx3h1XXTOEZGQVmqSqbhZuxMegk62ewbQ9c/We2W0BxIncTgNCXWc1dIiyIiZsAUIK5G7gbBJxpbrMPc5JA81B/GAl4AjUIU7z4lW8CTS7L98wJaRNU968Wzr0pu61CfFRc8ew2QosHQKN5QrN8HecSoYV5WRF8OxTElTWvYkbXGpbNt8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF0TBg/sB6hb1KuhDMOpyZpeVOUc7DyyeqDjz0oYhlc=;
 b=QReKv8vd6rskaqNiijLjUNy8hUroL/EtX0mPjmR/PsP7jZRO+UvuqQKsovIaehZndBXm6IkE3bhilTIHN9dyORs2easVLZmy0Bplu0yKfVQtsO7jXHg2sQnBaRNz1B4ksiPADSE2UlfYBXyrV/Ybp9RZhooda69np6ZNEs1RrX0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZRAP278MB0192.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:28::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Sat, 11 Dec
 2021 13:01:59 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4778.017; Sat, 11 Dec 2021
 13:01:58 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     philippe.schenker@toradex.com, andrew@lunn.ch,
        qiangqing.zhang@nxp.com
Cc:     davem@davemloft.net, festevam@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH net-next] net: phy: perform a PHY reset on resume
Date:   Sat, 11 Dec 2021 14:01:46 +0100
Message-Id: <20211211130146.357794-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <7a4830b495e5e819a2b2b39dd01785aa3eba4ce7.camel@toradex.com>
References: <7a4830b495e5e819a2b2b39dd01785aa3eba4ce7.camel@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0004.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::16) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c579e18c-aabe-4089-bb99-08d9bca6693d
X-MS-TrafficTypeDiagnostic: ZRAP278MB0192:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0192CE9A045EA27AB85CB42BE2729@ZRAP278MB0192.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QPC0mqce6Q3ge84Sb9zsi8Iy+SlLAqO6HxMLMYheL2d0NfVgzxbDQ5svFaI0BnwEes2rPeQfBXUgkAq2wxIxAQYJfVjcDxSTlya61iPKrWyyL1JOWDlIEGz64hBX/XbzPTqsyNteSUL31ktmlamjerwrIuJq5+uLP095vfh5Q0Vr4Z/7H8m6FKtk8k5z9jNZ2Hp0Iq3G2Gw7E300rO4nBBXs5IroxI99vTufqh36idx3Yiy3Ti5XsWxxKO4b5Rfn9VDUWgRUUeEO2413ZsnlZb4sHpEDT5axi88vNsjIlKs1AaMvDbVSnoeW5kKE5raF65MVEPjkglnv3ji20Hgq5RY1lWksLjc5KOpcIyKIqs4JmvN9T+ICNw3K2Tf4lXCJ2+2XBXMG9zWsuqQnm8JAbvqzjRRgiUkRiOqd6Lzxens2+HDLqCzogQIQZEvh53mMaNWPSfpxD5JEiafbXnfVbnm+vgh74SqdxgdatAeCyDxHAMayheIo6DD3Bo3QSstbvxbdr5Tgpfi1Ju78oYREe7fXNdbdTaw5FF8ijtUmJWrnGdBHQssIxH8g+70zD8KHGtHbUq+8tz6XKqd6CFU0sxO+OJBswT6/YQyLWTx87IkzTZCQAgHcadarYOnusWa8EhRHCEwICCgCsKBzzHFDKpWFrshqnXzQ29j1qcQSROJDUuh0S+6LHs6iQEQjzc/dZK2/BBKL2mGO05lneciRfTNcPEbcwr2kFA1yfs0mza5g54+vg2xv6FHh2vrO4lUQPO3XMgyf6gjQ5AagfaFzDqmdOwt7QiR0h0fNq1ICneY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39840400004)(376002)(136003)(186003)(316002)(8936002)(83380400001)(966005)(4326008)(66946007)(44832011)(26005)(6486002)(66476007)(6666004)(8676002)(508600001)(107886003)(5660300002)(38350700002)(36756003)(52116002)(2616005)(6506007)(86362001)(1076003)(2906002)(6512007)(38100700002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gl4eKX+iwgB1USkePlCf2va32P2MQ4tGHC8+11+XmojZyJ4Rbt69rphWr0i7?=
 =?us-ascii?Q?VMQtv1oze1MddGAhqQZFW8llYsSER2lqbDResyjxP9jaaqP3ORgjDVf8FzoD?=
 =?us-ascii?Q?TzsIXxUMEOPDWQdANMctYjJC0kJodhp/RZ4cb6yQw41fPm/Q+mKhXJo5DfLt?=
 =?us-ascii?Q?9EVlQ6tDbApX2j36FjfEdtoTlwlHs9mCBlb+t17fBm6cROtz8gkQBqH00cwv?=
 =?us-ascii?Q?anfg1KRoCIaY4UsYKuEse4GHqATSEnoXKDDIa6tQAykMl5McfpDDJCqr6R7J?=
 =?us-ascii?Q?sbxza8sa7L/c14HmQKE3d2QIQLXC8Xu9oFuYmBtUQQQ4+nkFntT9KP1Kr5Km?=
 =?us-ascii?Q?SDLPb1u/+VrbUJ8J5HSUFRYra1puLppXU21c0ZLOwZtQfP5Nn9QUxZw3Dm6y?=
 =?us-ascii?Q?6x5qem5MtlD+XGD19vKWfQimOaEpYTvzwjBiUT8+Y8EOi96rPWL3XwaUMZ+H?=
 =?us-ascii?Q?Fw62ICgK9WS1S8uXMmtSBaH1V/oV0zlfuh7YZrYUSq1xZZ7ZpXMBpcRy3PAi?=
 =?us-ascii?Q?k5z+tyA0fFbMKSoUSJWxEQjFjLE+5z4+4MRD9UPzGNoGhCeH7q/yKBRWZSqA?=
 =?us-ascii?Q?u9yr5Fc28v87likccHIL1H+1F96ygiGcfcR470eVz94OEOzJ5/1tAQBb08Be?=
 =?us-ascii?Q?5JMUR7pIZO148SL8s7aLMRzi49cLuI0HS0ptxkE6yRMeVq4PUuchv30M4jlo?=
 =?us-ascii?Q?3g4EQOpSrUkKYo4jssP8Gzs9I7LmlZ5WCqKR2n+eT/olXgmQCC6PtpEs2IID?=
 =?us-ascii?Q?cl8y+C6gNQZf0Htf7vOigQ8IDMqxe4UQZZZWmEfGvKHOhh9L00TLFpG75uK1?=
 =?us-ascii?Q?DJy2ATviDWhqvzlXr3fcT/6+txoXl56gXKt0AU6Q4q4re710y5vYlGY0olbG?=
 =?us-ascii?Q?/5m2JjMMdbAn32oNCZway/eqYsz5KI76JNnTEV8ZDhihT0hmrJruRSpV+2tQ?=
 =?us-ascii?Q?ayXBRUvvH/PHEq1w5+maHm/R/AUbLU55i5f8K+MG8xVtXmCJDq/imEtkfMNY?=
 =?us-ascii?Q?eN5ZofPnhpyIphogtcvLx4q0IhVYub7Xpxm9PtOXB3658cFTXAb1EFoYiEZv?=
 =?us-ascii?Q?E38s0dIM6ab1K3mBsGvW+iWZh3mpiEHkaCGyrawG0kQGQmdwfM0zODXdaelc?=
 =?us-ascii?Q?PS9R28V5d4rIHZ/tZ56m2FoZrktZ7IOgCbR4b0ETa0RAJ2z+0lApEEjFjfkZ?=
 =?us-ascii?Q?uaGfOnJlABR8aweztiKDheTYTI5GNLMicSlq+xp0fuzXAL8IDb3pxH7DLoxi?=
 =?us-ascii?Q?1R66QbdmweQd/iBA3XPlfM18Wca+PaAbx2vK3PrlN81amdBb7bOLpnbNgZ2j?=
 =?us-ascii?Q?lHBtoT8wzQHudjejn5Ymw/KZttZFQktfr6veGpwGpqeAMcxlswEupR0HuYd0?=
 =?us-ascii?Q?aLCzNBa9cxKaJaY44E/fjuBGsjIi8BwdX8NWsK7+eHM4TYt2e6qRe9MpSiTm?=
 =?us-ascii?Q?kGUEIU76jb0yr+wlbMGTD8ZQgaf0NFUVV6eyrc2fzjIOmNIaBaItojKP16IW?=
 =?us-ascii?Q?u4+MQgZZ1MtQcjZXpM5f0uVWyfs8D3x0/mftNVUAw7AoUf/xKwoELJeZEho8?=
 =?us-ascii?Q?FECDgXeH7pBULKS8pQ6n2IO28+0lmzjhe5MmuATru/a1v8EDFL7+fwr0n6bV?=
 =?us-ascii?Q?xROTPoHoAbqphaG4S5mkkXMmYqhGx9548MrPcGFkXapqgGQA2YZF4qXHswAF?=
 =?us-ascii?Q?H1Ua5w=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c579e18c-aabe-4089-bb99-08d9bca6693d
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2021 13:01:56.7385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qhd9DjtR+cqGiuSYB2KwKQo2cxMPCY4tB98YhmfCYTiiOritmCCveCPDnTd2CUHFRddXZE0ZORpWhcsxBlzB+3lvAoUn+HkMsmVLniXvyQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0192
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perform a PHY reset in phy_init_hw() to ensure that the PHY is working
after resume. This is required if the PHY was powered down in suspend
like it is done by the freescale FEC driver in fec_suspend().

Link: https://lore.kernel.org/netdev/20211206101326.1022527-1-philippe.schenker@toradex.com/
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

---

Philippe: what about something like that? Only compile tested, but I see no reason for this not solving the issue.

Any delay required on the reset can be specified using reset-assert-us/reset-deassert-us.

---
 drivers/net/phy/phy_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 74d8e1dc125f..7eab0c054adf 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1158,7 +1158,8 @@ int phy_init_hw(struct phy_device *phydev)
 {
 	int ret = 0;
 
-	/* Deassert the reset signal */
+	/* phy reset required if the phy was powered down during suspend */
+	phy_device_reset(phydev, 1);
 	phy_device_reset(phydev, 0);
 
 	if (!phydev->drv)
-- 
2.25.1

