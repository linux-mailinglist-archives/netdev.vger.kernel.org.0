Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF19A392A13
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbhE0IwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:52:09 -0400
Received: from mail-db8eur05on2053.outbound.protection.outlook.com ([40.107.20.53]:51168
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235742AbhE0Ivt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 04:51:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfctNnPIOOgX/nO9npMCT1rTRM5Ix2viNXSYq2/SOGqbz0UeNZOJ2Ia8KHW/3ZRXIdo0ZUp6f14Ym6S7Hk7VxSoDfUtivCa5K7bVShbPFiIyigVODxDOVNw/W1ZP1ZdK0RtY633h898VppDc+hKUF+0lD4HG2MSWK0ojunVjhRMKkHX+LByYxXLedCuAezSyIY1c68HfcfSYq84Du9A2o0+6s6OIplMqkkhim+SCH98ZMjWkKLXuU/2Cv/nuOm9MsDoodK6fkJHU/KtTTBT5TEniaoEtSe4bacRudctXJD36pqEeNmxh5vntw8B89jrCj2rWxv0JCElSGpkVaa6uNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+KCjkpeLYx9zMENqCWUk1qvyJJAtYJIFudjGEP9EqY=;
 b=i9qsRp/7UOFn7pn5zokeh2TaRdcsacCalB1LKLgXxeXBRYKdsP/9ahuzv0UWOlKQ5kfWxxn5mmlAZkPGA1OvJwf64V5tqi+Sa16xXVBI+Ce85YsSKA2Vt6FglWGjJKr9gN9VkoqP4iKjTVStoa7vAIyPD0aXOOjzH+5I7aZhZmIg7MUzK+Ge9BQJtaunLjTrp43/i3pQZSqumP1uwno0xn+npCRTniL7OnJ75gxsujQuIavIe+fcBHUlktajDNTKhWlRIZWMuQ7B+nOILuuCYrAvyGaUdpBrGooiYn0BxDZ5FxiFfYr00N3TRZAtw2m12H29faztifnL5YaQUsD/Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+KCjkpeLYx9zMENqCWUk1qvyJJAtYJIFudjGEP9EqY=;
 b=gEfA1feUAcwBYNub5pMNi8Yc/usrOwGHFB3t2aF8LcCFNQvK9c0onwDDMPRrdYoZBtwU7iRanADoVN3RFDN+pH07wkJwBG5wW9wEW1H3+sYjGW/qw9u+yna+8vHyLyOlX6Oq3NU5b782VxCJmOwdWs5t1YGW3erbW1Djevv29KU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 27 May
 2021 08:50:13 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Thu, 27 May 2021
 08:50:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     f.fainelli@gmail.com, jonathanh@nvidia.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        andrew@lunn.ch, treding@nvidia.com
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next] net: stmmac: should not modify RX descriptor when STMMAC resume
Date:   Thu, 27 May 2021 16:49:11 +0800
Message-Id: <20210527084911.20116-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR06CA0125.apcprd06.prod.outlook.com
 (2603:1096:1:1d::27) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0125.apcprd06.prod.outlook.com (2603:1096:1:1d::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 08:50:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee295e71-e0b5-4185-2a3a-08d920ec70f1
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6971CACAF7923841916F692FE6239@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uxOE+kft5yuTOVlGpJfxHWsjgQ1rz57hGtj03TMKGPPYf0BR7K4V6hbZB3HKcJxA3p4cpTA8qlT7myHPsgSJvn+sEuNEqvyNnPHccrU/fvc0R62+7gqc7nY3Prd6U95uUNSjtmvT9QuogGwEi81wUM2BOQ211m7PCvzq1tHUIN4LaNkyQ/+qSMSvdPBzPCfrOkktc7+gzTutlTHWdHOAxA5UmmqgznPGxtcA8xisvC0LfYcakNztFf8v2ZAvNHOx0EI99JW4xEXEFv7jB8qEB6kiZNtxR6JZSQZEs51YqzEJy0Msv5yGlRVO0/4gbO2YU28eb6CoylilZNPA/dnNgfxqTEKf6X1gLUvtI6KbHXrAVxC0MlNzV3HODzWzqTMyDfMnLkWKFzoLooT2+Aq5C+t4zPJNwX6G91eFmthQyayAzThqPjkJypqKfTgDUICzuUlqlURS4CgmPSd9tylDlo6+uFuG/MXdcjgVfCCy4IfXmGPhT/ngKEEnhCKodNML5qNujyA2pbmo4eZEi4IW5W6P5YbXqMvA2oGDBeArdo0mFH4FRBYd5uJvZfDIbCmp6HiNYhtH6XpiiyPKLqGoyi1XVxjzW0ji62vZ9+8V7SHY9hVgiD1NZ0ltcNZ6yM43nveF6UKbVgxIj8CNwSd4oIVyDtXHk50nz+DeIZO/6efSWG2FpvH7rjcOexpRojCjhVdf6LRkzM4jY0WP+3rnZBKLDtL9vKz2feww4U6heEgcs4sXUzvk6hWNob+Hm9nMgy+40rA1Y6ZLjrZ+ElQ8flD2XxQewyMh0n6/K5+rvS8JUcBluPUdV/71Qvv1tCq0x5p/Tl0XlIQ6SOQbQNL+OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(36756003)(6506007)(66946007)(4326008)(66476007)(6666004)(66556008)(956004)(2616005)(921005)(966005)(38100700002)(83380400001)(6486002)(38350700002)(8676002)(186003)(86362001)(16526019)(478600001)(316002)(52116002)(7416002)(6512007)(1076003)(2906002)(8936002)(26005)(5660300002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ad4OtTDaoSO61ccLMBdWM7oD8i5DG8KRDzLWdPxBUBEZxN9yL5OX7Nzqgbn2?=
 =?us-ascii?Q?EHZBgHJwRVVqbFLpo0RJfds5vTCvzD1Nsvv4X4iRoRIy7blqs2aMFAhtxfBK?=
 =?us-ascii?Q?uW8o5RUoeEoT+Y65TPdSRkjHO0f5jtWcMhGbvsE0skWvWEORVF9IZT8Q8hyJ?=
 =?us-ascii?Q?g8Vbqlp8bxWIMvShi3mNfbdEW9Wx2Q5tpWSMVKLptHl0dUYtjblRPApMZ8kv?=
 =?us-ascii?Q?pI0D/ua0SFG0sOuoaK8KOH+sxvR1nN/I1OgiQSP4Z6ietiWHvVbSiRZc59Ny?=
 =?us-ascii?Q?IzpEzFibS6BWHq3+3KJdsZMeOogMlUl2lWv5MjZ+AAPRZtc03duxWxNVUIZe?=
 =?us-ascii?Q?kd+0lvLNcso3jcrsnrkkHNb/6JawBsEPHEb5jaLa3/UxK+tVeELLRhrFmkpq?=
 =?us-ascii?Q?B062RKpl7LEDbs4D+yuIicZ9oJLm3kwOXdf1rnl9rOCgPwtmvzmHxVKhZQXF?=
 =?us-ascii?Q?PY0tPtWIG7o2Pzg9wBqdPUJ24cmuhYoedHi2cu/5Tq0rFmSKGFklC85gfxuH?=
 =?us-ascii?Q?lc69h93jCMrKTJitIEQV9M7+gAwBCczax6rEt7x5oNZjjt3yZJrq+U0c/51N?=
 =?us-ascii?Q?Gn/aB6H88dn6JXRPUuZxYklGGdZTiyxv5jFqMGBe/vT0i+zlZgnEVL+U+Br6?=
 =?us-ascii?Q?b6ZWBdfrLRR5+AY2f6T7dH5ev3BxmQyWXQ5Ljmrq00LlDce+EutGursaX+R0?=
 =?us-ascii?Q?8V1SX5Sf9mcMseFg/iJmH66ZUvIIoTC8u0UYmPGolaD392PK4dutrDnlmWRb?=
 =?us-ascii?Q?p/28kyLpQE5vsJ2FpMpVyPOIyQdiiP7/lsV0beRVqb8vOkb6wPaejg1UOkD6?=
 =?us-ascii?Q?fvmL9LAuC3Izyb/MW9n58RABF+hQ0icj91GPmQcNjZDp2pujmTv0D3tgyAZY?=
 =?us-ascii?Q?ANv1MLFZLtnDlRr1XxMtVu46JXgtrfWqEvVis1ArzRQDZXfIzyMIe6JLKlsJ?=
 =?us-ascii?Q?TVRGLVfeKWv3SD0gGPrGlSgZAnSmduqYnlJUPRFRdyoJrx31lEfEd9xrTHM3?=
 =?us-ascii?Q?Wn9g42FBMrpyjGljgioZpOfgNDCJ2++WvfPNWKCE0i02rD6fhYCEmEH5Oe7x?=
 =?us-ascii?Q?r3XA39DM+lnuYE4F5fiW+pgxcGJ9ZfWWuQnM3pre9sMqtx2UlfbUbeBf4WtA?=
 =?us-ascii?Q?xfzjkmn8c8zZSM+TmehZ8ieJvVwo0Ch8mK+wcNB7ZtVH+PC0lvkY2iEgcCOK?=
 =?us-ascii?Q?QWOWKhP6BBAyzDQx5oXvyEUblnxGcskc1KQspcBH/QjzCDpCPmdCKGYsByYH?=
 =?us-ascii?Q?G6JrfUU9UAanGzrtkwHI4hbQ6pWX4lz19XEGIvVyPj60aSFpRqrMQjDFR57S?=
 =?us-ascii?Q?hrCByTpgp2UENOpET8xK5AaU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee295e71-e0b5-4185-2a3a-08d920ec70f1
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 08:50:13.0791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNUKC37OI38hrf7TbIPdX6x/MxytdQgKZt1ViLgUa+rEg7nzI/6xVPVJtv+3MLH0F5TY8xVcYp7W5PrYdGSc1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
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
It only asserts OWN and BUF1V bits in desc3 field, doesn't clear desc0/1/2 fields.

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

i.MX8MP STMMAC DMA width is 34 bits, so desc0/desc1 indicates the buffer
address, after system resume, the buffer address changes to
0x40_00000000. And the correct rx descriptor is 008 [0x00000000c4310080]:
0x6511000 0x1 0x0 0x81000000, the valid buffer address is 0x1_6511000.
So when DMA tried to access the invalid address 0x40_00000000 would
generate fatal bus error.

But for other 32 bits width DMA, DMA still can work when this issue happened,
only desc0 indicates buffer address, so the buffer address is 0x00000000 when
system resume.

There is a NOTE in the Guide:
In the Receive Descriptor (Read Format), if the Buffer Address field is all 0s,
the module does not transfer data to that buffer and skips to the next buffer
or next descriptor.

Also a feedback from SYPS:
When buffer address field of Rx descriptor is all 0's, DMA skips such descriptor
means DMA closes Rx descriptor as Intermediate descriptor with OWN bit set to 0,
indicates that the application owns this descriptor.

It now appears that this issue seems only can be reproduced on DMA width more
than 32 bits, this may be why other SoCs which integrated the same STMMAC IP
can't reproduce it.

Commit 9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume back") tried
to re-init desc0/desc1 (buffer address fields) to fix this issue, but it
is not a proper solution, and made regression on Jetson TX2 boards.

It is unreasonable to modify RX descriptors outside of stmmac_rx_refill() function,
where it will clear all desc0/desc1/desc2/desc3 fields together.

This patch removes RX descriptors modification when STMMAC resume.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
	V1: remove RFC tag, please come here for RFC discussion:
	    https://lore.kernel.org/netdev/cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com/T/
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bf9fe25fed69..2570d26286ea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7187,6 +7187,8 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
 		tx_q->mss = 0;
 
 		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
+
+		stmmac_clear_tx_descriptors(priv, queue);
 	}
 }
 
@@ -7251,7 +7253,6 @@ int stmmac_resume(struct device *dev)
 	stmmac_reset_queues_param(priv);
 
 	stmmac_free_tx_skbufs(priv);
-	stmmac_clear_descriptors(priv);
 
 	stmmac_hw_setup(ndev, false);
 	stmmac_init_coalesce(priv);
-- 
2.17.1

