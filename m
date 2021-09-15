Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285B240BF97
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 08:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhIOGWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 02:22:37 -0400
Received: from mail-bn8nam11on2125.outbound.protection.outlook.com ([40.107.236.125]:51361
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230428AbhIOGWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 02:22:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k62UV2gJFQ7H2baOa1TMIgYXO4dvU2MyHDiY5573FCfYEywHyGNBcmugGOFSEB/MwGNvdTBRniSzSuNzWXWgyz5cVUuxuS1OH3mo8YvD+wLwlirmalFEqQVglmVyJ6deMOCErb1EGrbDRKCIOnNadwRCp0LyA8Y8MaE5jO11rLRlgjbWE/SOmve1QE6n2J7KJAdjv6c5nO+mvb4kw0WbVYeuyb48v3811lWDgkAyaRtV/WcQTQX+9y1AV+OwnDLThvd3yDEGfjA+EZ6IAZHXQcfzS2qIDRXG8PALqghKSe9jmNIScL0gvdWaxtsR595Nf/i/pohxbKVUFlIXypgZAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dgTJKiqzTCr9dpGZsGNCXL5lhyFKhi75eHqp9eloRSk=;
 b=cMrWfJWwGHbkQ0QoKS4VfnYVh0ooocIgKxaHIkwHR2h4emg0OE4vREKTHkRVjBzQyyVzt5LszJkkwCfuWMeVjr4q/yCXJ1qw2+YN959vmAGE/Di+fuNIrNFZ7JbSnga36oYZEfIHaY5wwv72OIUvALrXgtKHf+TnliCFO6DOc8C+n1ykJ4qphOJy8ZFqJYMTriBYUv9B1tK6yOU9D7b8AkA+3BYwWnyvkSdc0Hb2WzcptHgm7ESCxIxVM3ZIrFclXRouikmWR9q7Rqw7+mS3VZFfDW7w5Ebk+xEma4szGrTqdiSL7OY044FP7m7fbDxY1/hg6YxwNY5jsgrJcBAZnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgTJKiqzTCr9dpGZsGNCXL5lhyFKhi75eHqp9eloRSk=;
 b=jRLEh3q0GlNF5L+5mJlQ7p5S+VSQcdggzZYNVfI01X5YxrpaYL5DDu3RBMsiT73ZbSpRRt6cTFZfJAJXLnJPm0Vps+96NAgMgacCnZQe3tviWjHtDk0wZzBcfkSLhAAM39YZrq2Rkwr5ZJ7HXw69dePQRIFb6nImvl1LYnMYuws=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1853.namprd10.prod.outlook.com
 (2603:10b6:300:10a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Wed, 15 Sep
 2021 06:21:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 06:21:14 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 net] net: ethernet: mscc: ocelot: bug fix when writing MAC speed
Date:   Tue, 14 Sep 2021 23:21:02 -0700
Message-Id: <20210915062103.149287-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:300:16::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR13CA0014.namprd13.prod.outlook.com (2603:10b6:300:16::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.5 via Frontend Transport; Wed, 15 Sep 2021 06:21:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 342db8f8-4aba-4ff0-9c38-08d9781104f1
X-MS-TrafficTypeDiagnostic: MWHPR10MB1853:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB18530C5433ABA8F2CE2505FBA4DB9@MWHPR10MB1853.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:489;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4prTJlSn7I3AtH37CSacU2WbIkQ2e/WgO1vsob7z4tA5kcH13mpLgl08muqjvH3qVQ8PY2AHkTbQ6EyW0+yEe2Xtypapp5DSFqVGwnsRBUS0ozNaYItk2DsjJJyUY/edoJ6Grjl8g1cdrj1jjBYav2P4SeMApYo92kqMof5Bxw1G/wfJBKBYEUmhlRXUxo+BPQcLofWIRqomvMUSPwpvoZpOk1swyLGTxVXeel0FZ1PVdbe4h6CbI8OPd6TJYNAtW+Wjh2UodNppx79286RWaDwZWav2pOB8EyI8vcUdD28kHE2ivB+FE7v/5hTYRri3NNbsq0JtxKN3eP6nJk/q9QKWVH8ykLyS+Lx6Z7+Kkcz3ZcKErmwBkOQXZDLI9RBjIm8gacx3odx31XWC3LHUsNLjpIQQGhThHB+PJF5nCeLX2uCl8oBzBGkSW9h0cO5NSPWOoL6STk983NqbOstL7zzm4n++XPipjSNDMZkQ4s7PIzLozFgH+FSSak+mVZbJHOCuLZEgwEO8nd8YOl6blhShn1KuEmtquwxX2hhyaRCFyevXQqLEIlxo0+bV7BRafnCGIcMD3H9wSxX+X8YeoDHaPHVq5gU57ryPDCTmA5CG3kj0LePHH464ZNcV/PYYq1u0HXfF8pBTEiQYw98hMLKFDSlHc71nV/aQxRtWS8bD0fyLq/6AMte6/tAGWuvATRnX/B5mDCOPLfL3zspVCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(376002)(39830400003)(396003)(2906002)(4326008)(66556008)(110136005)(38100700002)(956004)(1076003)(66946007)(316002)(26005)(186003)(6506007)(36756003)(66476007)(8936002)(52116002)(83380400001)(38350700002)(8676002)(5660300002)(44832011)(6512007)(478600001)(6666004)(6486002)(86362001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WC/Z9PIB1s9wHkUZRlk6P5RcUP1S4xrexosyQphOYKL+/YE7xmSNr/dGJqbm?=
 =?us-ascii?Q?fCW62wt4Opo0xrQ/diBVunyjYV91B1c1pFokbJfpi07a1PKqDEGxHB3M9NFN?=
 =?us-ascii?Q?Vf5P08zJ+/3AqOC74/3OaD5BbTxpx7kti3ev5hMgO3Sl5bnxiVzbGEbkdEwq?=
 =?us-ascii?Q?Y+dbLKOZEg7/YfcXICpenajbXcTu15Xxo/Ayaq8albrnVXR7fJsOZLp+QCHU?=
 =?us-ascii?Q?anFwUBibg9zYkD8Puu9UUqVOONk9FsvcrLzWRvBnHwUVl8biycjn4mTHCt+O?=
 =?us-ascii?Q?eaJHZExJOfzdtTKbafe0xs6vE44Bld0HH7U601bIVkXg3tNRUFf9cZ+kNKC6?=
 =?us-ascii?Q?Xv8ZJW5dwPrSF3p6TUfrn9zVP9qxLVrMS7/yREQzSflXvHDxFnRcm3JNW+XY?=
 =?us-ascii?Q?wGQCEfefelOYeO3L6cCNouMapH+G9FDP39PPpAxhhmXdJMwcjjOUL5popdMA?=
 =?us-ascii?Q?BwAESrhiFr13aQXIP6mSsoLVVFpUoRtRxCbZw8lWdF/+8wlz4tRuk9cwysDc?=
 =?us-ascii?Q?7gPxWWCpjAfTEwW1HXyvNSLh2G7GnZlljb5Cc9OFnB0Wce6v+4d7mNW/NuDP?=
 =?us-ascii?Q?zIPROv5KX/zKSIvSnbUDHn4mIokY6esDKzm8GhORi4unPHQM77OUdNmL2jPm?=
 =?us-ascii?Q?5o6+v6k6DyslmGgAsSKXYRRB+qADpfeB9EdAQ0drSwb5ztoe1gbKyiurgcAg?=
 =?us-ascii?Q?kw/krlKe+OJPtPfFtjKmRLcW+7DSh96ghEUQ/AsGkJNf7PRO9bOGRJE3Alqp?=
 =?us-ascii?Q?RQN0BrqnuxKfcGkf5+7CMN6FDRZkj0NoGI60Cnnopw8AH2P1EWMybDD9OWN0?=
 =?us-ascii?Q?gIgYOAt4P+S8N7fM2mCUZJCEGGi1/VBdAeopbFshG7ErxTfjAB1fo8h4rqNO?=
 =?us-ascii?Q?nWEQEqyBo+D/XnTmdDsFW6WPb7zN+VKxVyJ8Pg4MZkuvLexFXo/SSEs45J4V?=
 =?us-ascii?Q?plSMdkeah1nqhKUqkZYeTCXc1W5gSFMT/uV9CT1GU51XjvH4zu+gYL0H6C6u?=
 =?us-ascii?Q?k6mSIJUhDtVABVo2hpJlJ5hbUuOXOaOU6WzkH/QAAwgbVUYASutSyr4lD7Cy?=
 =?us-ascii?Q?kREey95x+r6UlQw+oBxgrV6gcbHTaBDJPhW+rkJBVcRAxka6AdSAF6QZFcuO?=
 =?us-ascii?Q?Uvee8ac+covXzbrYxYaDyWh2spNWpgLpZVqyUZI1Wi3sGAljStgfgW53WcVP?=
 =?us-ascii?Q?6R3FpiEwpsWYi4j1oSIqkitMgFvkaqT7JktFTZk1vFb5cGVHTQ7KCbIoFz8U?=
 =?us-ascii?Q?D8hJZxCkxIMf7OtZso5xCvSNOhTdXAWpCTeqzhg5tOTTwEdFrkSJwBRktWbS?=
 =?us-ascii?Q?MtnxraegIind4Kxn66dNVelu?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342db8f8-4aba-4ff0-9c38-08d9781104f1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 06:21:14.5304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dErehnNJ9IAliQY4kmv0NeNC9iGN2n9RDVVtcCsozDiRHstnrm9xEkO7paqSDb95Gwb5TW1d4mxzStPgDn6QeyA6xUwxyZdPKvL2uoyQVuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1853
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Converting the ocelot driver to use phylink, commit e6e12df625f2, uses mac_speed
in ocelot_phylink_mac_link_up instead of the local variable speed. Stale
references to the old variable were missed, and so were always performing
invalid second writes to the DEV_CLOCK_CFG and ANA_PFC_CFG registers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c581b955efb3..91a31523be8f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -566,11 +566,11 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	/* Take MAC, Port, Phy (intern) and PCS (SGMII/Serdes) clock out of
 	 * reset
 	 */
-	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
+	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(mac_speed),
 			   DEV_CLOCK_CFG);
 
 	/* No PFC */
-	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
+	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(mac_speed),
 			 ANA_PFC_PFC_CFG, port);
 
 	/* Core: Enable port for frame transfer */
-- 
2.25.1

