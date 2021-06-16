Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D075B3A95C3
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhFPJRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:17:34 -0400
Received: from mail-eopbgr150073.outbound.protection.outlook.com ([40.107.15.73]:19938
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232328AbhFPJRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 05:17:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieMOd+ARO1qTxMoQB9msDin4YxiS7S7RujlzV8Dm8PsBhW1NSzxvy3wEPYg+hyU8vFYa7helqjyZ5Yd+Gc4HsAc5IZGroTh53GpD0XODm5YsP0HHh2BDCSrlNkbEGjVTk65YIiRIAPp13GQfXoeeZVmJ4RAN27sMV9SS0woBJTr5WQzhDlcP80T5MtiVbhvKkdJpdIZDzoJtaJcmlMGVLnqQ4gfneR2q7gSVrMYz/n8Pe3VEWstFAitpvy+pPwfqwueo/ktUsrtlVzlzxyHmqDyFpgEGpZy7MfRi8ofZXOkQQw8QLCl1rm2PZDanj5rxNGBcOfQV/7hdwKhrgQ6IRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUl1y4Jg7eMgXIC0FjWdnqzMrqLRLNIwrz3uZb/tj9o=;
 b=OFYbgunRCJ/nhEnbUaijZgqk5WZFQMG0uI7JcXOtl/bPCOSHzpsxMKjMFUIb7oNsVAHjCVHWCJwsK3gHfIs+anpSB7LWrtO4lyzH4DqJIYqeXhI0rrSpyWQo5uMXdpnaul0o7I8Sp3Hg5eFs51vtHBavNqegsMUIK2W4dICIxaRwVU3gT1NlgVbPhffsHQ7gIEm72s8ZjGJN//riuTZG/ic5n2maCTOJZlq/z+3eadRXdOjSu/J97cMGz5Fi96IhR5GgO5CIibcksglFUMHhliym+4fUy2dYL3cQNvYc9UHvxDLV5AWI06s8rHtmjE+kVuzOhYrOuHnVBdHUYkqcqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUl1y4Jg7eMgXIC0FjWdnqzMrqLRLNIwrz3uZb/tj9o=;
 b=mN5oqSojA8sUN5GgVKVB7HOp20seVjDxcm+NUJ/XY0XGe/v8rEv0MIHS123OCRV7R1w+QSHU8qVsQYlpAyQ6WmGjmWaW5r6IdzO9jga/vIT0aFZ4qNnbc2RNZmvtM6zkgFU7/SVaHbnhxQ0IXwqyBJWiXyfwAEarqLPEP/MbqTw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB4735.eurprd04.prod.outlook.com (2603:10a6:803:53::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 09:15:23 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 09:15:23 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Subject: [PATCH net 1/2] net: fec_ptp: add clock rate zero check
Date:   Wed, 16 Jun 2021 17:14:25 +0800
Message-Id: <20210616091426.13694-2-qiangqing.zhang@nxp.com>
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
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0081.apcprd02.prod.outlook.com (2603:1096:4:90::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 09:15:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69ac9730-82e5-4917-ccb7-08d930a74568
X-MS-TrafficTypeDiagnostic: VI1PR04MB4735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB47357F66A788F706CCACFD4FE60F9@VI1PR04MB4735.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:88;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9n96qghcHXq3Lkr6lpUNTaRoqkkARIF1x5aFBAb1jbb32hHguaVUxxk9TYmXdq8UMSpQc+stRRyzcX6qvi4FFWLosEioDr1JFfgR+WOKv3SeurxOOyxfowQ4sxD4yyhEk8UoO3dsXHPtNivV2OrlCxHYEFrAD4+Pwp6NJ8polUZKkYtCGbeqOvNAsA+/0+A5XX+139RgHHEdn1QTW+EuMvwVCZ+/IoU0XxfK7+gSsQD6NmMLmvfH2RQsAUAnAsBUWSD+y2Orvcc0QLzxTMiUP0u3P0Wzf4OKtaVDw+PhAatYXc1y5b8Ta8ZGt79NmWgciiEkswrmrRv/A5lyJUMk9KYytx3sVELLZJxWd1NfP0GHYGoVmAFcYNtGBCNCpV5RUgZ/CMcvytnBPlby+4uOyZFwCgpNRQJdPgH74AHN10A8voF0UWZAYqqznmkKmio8NfHUlacyEhwOqwH1wQ+gXRrKIlQRzhQaV36p+ZIcusIh26/ShzcHx5+PNEGX8STFvJjR7vNq2tNC/JfTU4XLs+Ka9T0XxTcxhMPYCcWvezhHTzHuOcWPVjMcgwOLCcOt2yjhRA2ewvGhf23RMh9+wcoICy8yWRJn1kAJFSU1l1e29Eddvs047tTKaPMMjgV1gLmxv087LD4p1YRJr+heOqSkWYBzq+F3JqgHmanScmiuEwt4ITUPV3z3Oxy1Uupn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(2906002)(36756003)(1076003)(186003)(38100700002)(26005)(83380400001)(16526019)(6512007)(8936002)(38350700002)(6506007)(66476007)(956004)(6486002)(86362001)(2616005)(5660300002)(8676002)(4326008)(316002)(7416002)(66946007)(4744005)(478600001)(66556008)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R9uFp25LTkmoujxbVOZ72RypVA9+vvZlqSqGryRAEU7w7IJBQLjiG9RDjiHs?=
 =?us-ascii?Q?WqkjwdT6raITBCigZNd0slc5b2agrUrcnw+vZ7pP/YVlA5gO1tBI5Kpus4No?=
 =?us-ascii?Q?fp1z+D7jqzb1lDcI2dFcb/t97naKd9P4rgAXukIzwqNlr1GzeJVMs5ev7sve?=
 =?us-ascii?Q?IX+Hqc13OZqJY9fgpZigIbxqCfJTPTsHXsKs0CBpv/fM0TTxcncg3kNRn5s0?=
 =?us-ascii?Q?wsqXi39EXuYD+s0i58UXs2fkwfHjuBnAAaCTkgsPveQRGHeFPupEzX1kSFem?=
 =?us-ascii?Q?rvsp5yFnrCwfGIwOuCJY8D0nyrFk8xi13S78/kCmMFQpzAaFvd/vx4ssIbUS?=
 =?us-ascii?Q?GQZxTDa+3+d2ibyWgDZAz7ZPkjPQsd0hjHwf+N4oV4EFnNMLv9eWzq5HCScY?=
 =?us-ascii?Q?LM5XW3JnyJo0SV6HWF/bTwr3lmPlXPPTfxuUkw/Pud/lp0fQrw5WksGYgL9c?=
 =?us-ascii?Q?FIQSdCQFdQJnf2wM23zp6PT0ol4CdxV67nE/bqxYof6TJ0ELCLvBL2hAlhBb?=
 =?us-ascii?Q?iiacYRi3FnRp4htF3vrx4Zil5yHj95FCeDbK8pT4VD+iUU0LLa6oyUD0Hb4R?=
 =?us-ascii?Q?sfON6X6MceZgQtpNwswCjCaLoR3C3VNN4kn3UJhIuknq4f9T2GrFCsULHnNm?=
 =?us-ascii?Q?bBpyvf6oxxzoC1i8csqWTCaU6uvcVN5UmjSFpn68f9w06wDPf7VEPX8/G0fy?=
 =?us-ascii?Q?Vzz3IbxQQIxXiqqthPwY7H8FS+YqbSaxej8NiraG06/erSdKTEt+QOusJY1D?=
 =?us-ascii?Q?3ckaXFPGTyKtqdPbRprB+kGI7TZzJp4WiU4t1wiDFkEKrm7jRcIY3uDSOsNb?=
 =?us-ascii?Q?89KW8p3OLVKLXrZtQJdUvDu3xUuNBiFM4say8sj2xvdSPFyfbB3vCU0T2xSm?=
 =?us-ascii?Q?QL3p2nN14aCtSuntt7gibhiY4kiuTHA8JVu/6w60wXEYbTVQXMi6qazf2v1F?=
 =?us-ascii?Q?/XZ8pAvuXnK7o2OURbNFxDe1Qhe6SV/qASzbz0curhTHal5bXGkJGsgVTooW?=
 =?us-ascii?Q?W363hDH2Yr6pjQcrYBNmV16igEpCT2pc9cQtsFfeOeQWKqheV9NqZXESxt3V?=
 =?us-ascii?Q?Z1IfMo8ioZuLA/vymwBjkEG/8Ps3+fBi+AAPZY7uujh+31bNWmY9iZ808HN5?=
 =?us-ascii?Q?UlQ8QEk5ANfOSH5i/ax3agMocpLhV1Bt+SRm/Zs/EjMTugEeuK/uX767JeVc?=
 =?us-ascii?Q?UpfdlY3CSkQYN3t0UFhxyudIhsmZsShNRuHjcNCOAPhz8uvr6gkQO1f7Hcmy?=
 =?us-ascii?Q?nzx/qG5v8+kTuks+ZbmDGhUVq3lQ8Yru56Zq2opncDxnrfIbPoFtoSqeru3H?=
 =?us-ascii?Q?WTiWxCSrcN0ggPhB9nq3rETL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ac9730-82e5-4917-ccb7-08d930a74568
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 09:15:23.4740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OJ6HLmOPIE8UJvGxzNx1PS7lU5sn3gyQCQw4GFu9NKw9cgD33pKgcV68ejS3ZGILyQ8QErZ3FkmcCiv6Ev0nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4735
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Add clock rate zero check to fix coverity issue of "divide by 0".

Fixes: commit 85bd1798b24a ("net: fec: fix spin_lock dead lock")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 1753807cbf97..7326a0612823 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -604,6 +604,10 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	fep->ptp_caps.enable = fec_ptp_enable;
 
 	fep->cycle_speed = clk_get_rate(fep->clk_ptp);
+	if (!fep->cycle_speed) {
+		fep->cycle_speed = NSEC_PER_SEC;
+		dev_err(&fep->pdev->dev, "clk_ptp clock rate is zero\n");
+	}
 	fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
 
 	spin_lock_init(&fep->tmreg_lock);
-- 
2.17.1

