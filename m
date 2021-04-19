Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FC9364129
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbhDSMAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:00:07 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:41088
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238912AbhDSMAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 08:00:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JluSMxycKK5nuWOnBVZBY4Je8MHGjcGgRev7cUHyNa3QApoG2Vf04RrhHkexR53bbbPYKVn/N46tr9qI7W8aBMBJSmy6Ug5NzrA1fuK1QIQ9800x4G/s76nsAQrVuuIVWMsIuNP2Z2MBK8OdDpfAzzYqudMsyVM9YVlQgTNQfq7OdmJrr6nMbNFoxcxY20nFUNip1ZR/C5HPDXrvw/A3x0FM7JG5SsV4lB8B2RXM4osQ6Plw3wZ4TUlvAMF3V5rYIvr0aSi4fGbT4hiNDzMRROJ3K8fCJ/k/d29U6BAjr29dPzkZ5D/E28WPc0KxEzXlxNMnJqp/D1cb03tDJHlIYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9I3qxrq+FZAs7YXVItzsJnGV99W9h1VLUvWsvaqQnk=;
 b=e1QUQmsqScG5yMj9wbNuvrw5UrU+5UTO82akIf6xVlvlxCeYSyrRFNUhADoM3kgNMFsaugxX1sqWjaN8b9MYBdjdGGPkv4HYVLmOr+s+qK4OLZxr4v2Eon9gnW5MAOWprT+MfWHUHu6qSWjn3ffZvXJnf0WH9UDLz34FlNWOeFPzDLZ/9p+2t0GuGceWxTD+Of8Cga4LiS3NvRVZCYoXHhhSX5p4PB/P6boNWEn8EEJJIIvfBBZs/Ty+CspWbQeF1RkUbRKTe1vHiQOEVRG7vhDvLMU0uOa/nFifsB1BB5sxcb6wodWyFU4LW96Mw79cspcv6mbjNpdO/bDcBtJwcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9I3qxrq+FZAs7YXVItzsJnGV99W9h1VLUvWsvaqQnk=;
 b=SwqpUO2ig5vRcWGlefSZfmQiQR08D5LBcAzmVSWjNk2gsZE6ydgZBK60vOoZIbKNapsbuRSV8xKjEPWYImcCoe8rNRNQ8NP5bHOZLNaX+tL7UAiXQ/xwQZDvEyXs8VZ3t2k98VSxIOX32OamDGmfLFePAxK4d9JVdAmI0T/wAFI=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Mon, 19 Apr
 2021 11:59:33 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%7]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 11:59:33 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-imx@nxp.com, jonathanh@nvidia.com, treding@nvidia.com,
        netdev@vger.kernel.org
Subject: [RFC net-next] net: stmmac: should not modify RX descriptor when STMMAC resume
Date:   Mon, 19 Apr 2021 19:59:21 +0800
Message-Id: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR02CA0173.apcprd02.prod.outlook.com
 (2603:1096:201:1f::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR02CA0173.apcprd02.prod.outlook.com (2603:1096:201:1f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 11:59:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c53a8c6-0881-4709-1463-08d9032a9873
X-MS-TrafficTypeDiagnostic: DB8PR04MB6795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB67958C3759556E935B639FAFE6499@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Kz85IKYxG5CXKJxq4b9iHm90smxgf+3RKBFEtrgPP1/s3Tr03m4a+EIjKQSkxlgJT2d1zMg6KjWlgz2uHGgOBC99EdfSMamcbUWfbeJHc4oI77Lwugra/cvveLKkw2THTkSESQXGYIfVyDA8qwfrjVohbz1gzK7ZEqhI3fJ9bfPo3Klw01PoYyJNd7gNxgKTiALkk8ArSVG4V2qodPM9qjn3AP3yYnFXp/TcvpEbe8Tsbk6hqI0nqAJtwp9TZKTitadVDfLrA4a7bSBHEayyuIl9lCasZACQuvJ8a64DHk3Bc9HVXbSRFYy6RHKCIIY10RXo7LO3rI+gSOp9JNYZv/4qslhFefT+RTlERG89wUgelos5nsYtPujeerV7KDM/uh32vMwjtkJNNf4QwdmDUuffYa9M77B7+V+qgmf2XBsK34//ThJAWCl7dKx0HvfcvaZTMOiREQZYtimum8ZtEbDIxVebBwUx+201lUryoEZcVNg/CwUMicGvi9Dr4zmGlkJ+oCq/ByjdsqLm4fZcQAHkvNRow9nISEqyNoIToJMIsAnbUqKk8Opk3bauc8UUCrDchC3cEeelRtan8lOo16PEMhvDXDfaOUV9H6SB6VkWMQ2aIIufaCELG2ZNthX3qT79Y0engAy8aTrEG7Bp+HBKFmzCRzxeIEA0IudMpJLAiNfQM3Q6W6/hBAQwF8F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(38100700002)(1076003)(38350700002)(8676002)(956004)(36756003)(16526019)(83380400001)(7416002)(26005)(186003)(4326008)(316002)(478600001)(6512007)(2616005)(86362001)(6486002)(8936002)(6506007)(6666004)(66946007)(2906002)(66476007)(5660300002)(52116002)(66556008)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2+kwc+XbJgBWhAEXoNr51SUQmBuUJTQuqSoJ7dzR3WWYE5oQlROP442U0gnO?=
 =?us-ascii?Q?hDPvY+ZkpjAU3e1tP1lyU5H47uZFOHpLlHiuTKUWpPbhYZuBF8fclXtzZ2Zw?=
 =?us-ascii?Q?iEBAPpO4qjaHzlX95dAf7NCaDYg9bZMlkIbOAc3v6AWpqhi21q586Wj0d238?=
 =?us-ascii?Q?7EjrBSaSJnrgNlS8ZBIs4CW+0kWgreUsk6tAI7VyHUM+e9P4LAAqyxz/DKkO?=
 =?us-ascii?Q?uFRfCribGmoJAc+pAjnwktBh+obxwTF/cATX21Cu22N0DdJiOJ6UPMqm/yn+?=
 =?us-ascii?Q?SjNSbsirRbC47dIn6QJ0lRqNCh/aZsa3TdPpkQj8/LiBmD4CHuWGE7yyUTsg?=
 =?us-ascii?Q?TIOiawj2k4ocQRFE+7yEagJ6L6rM2Qgj1b0VBOYiCZpHSBNia6mPZ/Se/5OQ?=
 =?us-ascii?Q?urkDvKvb3VTBUl/+/xVl7XNzskz3jDXcHRBnrkKnqqAZQp+pHCoFXax+ZL6K?=
 =?us-ascii?Q?ViWIKIvb2aypFJa5VIgLeBdkB3kG3ys9iqYuj2wo5drQwgWQFDmB1mSuwQZd?=
 =?us-ascii?Q?Jg9ZZw6xSJO5GQsJCgQvc7pyGEuE2c7I9PYhMpE84dVZPe4DQ/OuOMyBsEzn?=
 =?us-ascii?Q?BSNIx+daPNbDdjDkhimx38CHqnH0s+eLykFwRky4aFyM9xSdEW2y3UznPWqt?=
 =?us-ascii?Q?7LYRft3jfWZBLPGR2zKvQ0tb9fkdtDrKlYi3pU2oAt4bURt/vrlYr8ck9t3a?=
 =?us-ascii?Q?TVoJjVPxP+v++nD2zb17T7puud/EhTLDftpQH8GuinmCS6LC6LuqOsy7iKvV?=
 =?us-ascii?Q?zkSZGOT/yHJil9TsElV+j/f33m/Fcoa0zkKWzHnhRLFTPj9fVQsZhKuLqmFw?=
 =?us-ascii?Q?So4fEKIy5v0+HYYDnaHrLx7h2QWA1DMlLfH+jlLGYYusfl1gu9/bgq7YubF+?=
 =?us-ascii?Q?nvRAOZLhEpCr081fWeV7rU1kEQRMGXz766zFJ754FZdiBkvN4Knh3ixOnYOC?=
 =?us-ascii?Q?vnbTYK/5/Ixgmzwo4AsH9DsLa3jI+tuzU8MCObxhGLANeO/FLk0AMhQVUh/J?=
 =?us-ascii?Q?F2Scs4+AH0DKxDT8mSO8/L3P80fcnYabSxmWx3NpUyuWlPQODklT4nc3DQGw?=
 =?us-ascii?Q?ue5JR0qrDpYl5LgJm0cj5flKqAiFNyBwA3Qbf9Qm3vrIlqXyexZIYADPh9C8?=
 =?us-ascii?Q?lNnGxBHuFfROES6AUHISjJYHXjHZ6r2LuXXj5qVHrOLfWtsqFdYGyCC5x0vF?=
 =?us-ascii?Q?0SZD/lkqRAJ04R3mNMb/gzLrdqNbFqX50xWToHQwD2fh9JZD2WyKx/3c3Rbe?=
 =?us-ascii?Q?yBkPh7Q+d+N+DQitwrQT/Srf/gL5GWsBBPlxQPeo6u4sdGw2klqjiluzJdCC?=
 =?us-ascii?Q?62kr17mcqIwE7gAga7gjYMTk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c53a8c6-0881-4709-1463-08d9032a9873
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 11:59:33.2317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZoO0dNN5826FxWnDjL3euzB10nXaOrmkUtOIJkgWBMKSTx2D524UhKzGsEtR0TRwBHy2C/f7GC2q7/C0K0O3Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When system resume back, STMMAC will clear RX descriptors:
stmmac_resume()
	->stmmac_clear_descriptors()
		->stmmac_clear_rx_descriptors()
			->stmmac_init_rx_desc()
				->dwmac4_set_rx_owner()
				//p->des3 |= cpu_to_le32(RDES3_OWN | RDES3_BUFFER1_VALID_ADDR);
It only assets OWN and BUF1V bits in desc3 field, doesn't clear desc0/1/2 fields.

Let's take a case into account, when system suspend, it is possible that
there are packets have not received yet, so the RX descriptors are wrote
back by DMA, e.g.
008 [0x00000000c4310080]: 0x0 0x40 0x0 0x34010040

When system resume back, after above process, it became a broken
descriptor:
008 [0x00000000c4310080]: 0x0 0x40 0x0 0xb5010040

The issue is that it only changes the owner of this descriptor, but do nothing
about desc0/1/2 fields. The descriptor of STMMAC a bit special, applicaton
prepares RX descriptors for DMA, after DMA recevie the packets, it will write
back the descriptors, so the same field of a descriptor have different
meanings to application and DMA. It should be a software bug there, and may
not easy to reproduce, but there is a certain probability that it will
occur.

Commit 9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume back") tried
to re-init desc0/desc1 (buffer address fields) to fix this issue, but it
is not a proper solution, and made regression on Jetson TX2 boards.

It is unreasonable to modify RX descriptors outside of stmmac_rx_refill() function,
where it will clear all desc0/desc1/desc2/desc3 fields together.

This patch removes RX descriptors modification when STMMAC resume.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9f396648d76f..b784304a22e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7186,6 +7186,8 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
 		tx_q->mss = 0;
 
 		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
+
+		stmmac_clear_tx_descriptors(priv, queue);
 	}
 }
 
@@ -7250,7 +7252,6 @@ int stmmac_resume(struct device *dev)
 	stmmac_reset_queues_param(priv);
 
 	stmmac_free_tx_skbufs(priv);
-	stmmac_clear_descriptors(priv);
 
 	stmmac_hw_setup(ndev, false);
 	stmmac_init_coalesce(priv);
-- 
2.17.1

