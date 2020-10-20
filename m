Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4E2294187
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395560AbgJTRgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:36:25 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:12423
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391371AbgJTRgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 13:36:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzpdNuGFOGBp7lSQz/K5Cr3GVA2fviBpxubefshf6lXjTxXAoAd1BoFLL6eSQnVl0yfBzee0ZOtpiVNpi97ipm3Q9HXffGEWYqvvKG+1jbYuV7P55Wgbj6nQWN2BZ0A5Ji3e8BjsfPlP/QJJeNfEpLWyN+TRH68mLIN/yJOQB2dTF7dU/3LuQl5Zn3GKZ2+8KXanzXIvF98JWTTJI7z3it7AtbNvG8bIebnheq0Z3hlRUcscixXSDQ/k+xzJAkoRtnK997EkTNZx8QSwtNYI2HANrZ9EA+qv/xjUiFTzaiQkYbnAnBiPYtdJM5s6eAbvbD2Qo5HVJvsOeGM2VCF0Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rl8utXFTrDe3yS9hQlqSCbXJ+Nz7JrFnDQmNdRPOjl4=;
 b=ftlFwRG9QkTYosenOQPlPnVN/UU8CIvwWidhLCmtK7+oHPaN4zJlgVm24boYTYHrVBNwXkjTvYTCbiIoYZWeXSTwsJOON7FPkhdCchSef4plf5B0jy+nzHwNeaCHBm2kXtdZWj/NbgaV6Rr5O8pm1s9JXRuHcE7ftJVlgBYVbc93zE02hoW/qUxi0cc3X9Hy44VC+fFM0z5xwz8oXITFwNn+Odt6lIBPxb40QTU9XdhF+5bevlU2J01XKhWm7UcpbxlOucfd2sdXEDRWw8iDnp5SmjUzunjQpZu/DW7YTSbXX2eu+7oJybaVXergObSVtFcDJ69XiGwEoD4vSdvVLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rl8utXFTrDe3yS9hQlqSCbXJ+Nz7JrFnDQmNdRPOjl4=;
 b=k8XUjBzpEVJ3Ko4vX6rYPStHe14ZH99xamLZMjwjNXYIj8uE9xm0sTwrmpoPjrlQI7PvV8rWaHJfrCPFKtw1IJhGXY9Q3yE2+2aaYYvUgWM/qVfOLwYrPHWolq5fYMHJ1q8NL3iW5Tm2/1qb3GRcPgZE1NiprwQIb2r0l+p+6F4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM8PR04MB7298.eurprd04.prod.outlook.com (2603:10a6:20b:1df::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 20 Oct
 2020 17:36:21 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 17:36:21 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, james.jurack@ametek.com
Subject: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb headroom
Date:   Tue, 20 Oct 2020 20:36:05 +0300
Message-Id: <20201020173605.1173-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22 via Frontend Transport; Tue, 20 Oct 2020 17:36:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 36c35917-845e-4bde-1166-08d8751ea866
X-MS-TrafficTypeDiagnostic: AM8PR04MB7298:
X-Microsoft-Antispam-PRVS: <AM8PR04MB7298B9F8531BE9C6FC4E8715961F0@AM8PR04MB7298.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yzNPCl0QsvOATw/BxeHEu956+4L6qSpkpLnj7kRxQkJlcNwIeR9k45eVkWmLvPqIvBqRKZd4Ym9EzqpXB0q86EnICyee4yNk780VDeJwUODqVHoFkjEpluF5TEMdzCyPYUtEHd62F2zTnXdchMnREpL8oya1GpHMC+KNdFm3zyorLyEYnlmuysV/zMTqJ4/cM5QUlYV/upEHQA8NoRHWT/haMGl3megnwMuu8tMeTRPoAgJxnXwJOl2FgVn978y29TotkrwVLPmiuayNC9UEyDcXheKdf1vhslqmxD3nCk4quKhZwISOauDYG1pbI5iG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(2616005)(316002)(956004)(66946007)(7696005)(478600001)(6486002)(52116002)(4326008)(1076003)(54906003)(5660300002)(6666004)(26005)(8676002)(2906002)(36756003)(6916009)(66556008)(86362001)(16526019)(8936002)(186003)(66476007)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kTSbc9iJrWXgVEq+4j8ncg1oVCyjtMNSA6ysCgNgwkUM3I84/eIFbssjbhBKgTmSq5r6weZHQGhdB3nXOXE8RTz7KYTcF7rhU9EYp6tT8PyQdnx/xgLpivaOdIGFHwbNKzJsIAJg6xy9x12mDF883zdER5BFwcpGkItdz9YojhkjTP6XDSGM4HUhGGjdZS6u6fGLhX5o6WCeeSXRG9pEg/h8IxjCeheNl9OsCEh7qaqGpjJBAmBFk5MU389OvTGC257Ob6n7z/1A7UX9Cdll25N/MnUy8x59dstywg24/u5ymtmA6sk2eSFG8ekIeJHUQ2vhP39t9OcvqlJj1qhfX/lvuyhf9PZ/xRlu3WAyu9UZ7m86exnActjz7FkyfQroeuBSez51ZyIYTsN4i5DrgqwxnIq+2GxnonVs2V5P6RqWNhBF3tAlwODOa1T1j7SnQlWo3/+2t5d1Ew3M6i10Z/bcAqK5bKINEByrEznDcZfwmsmBYLhpYgUuft3iMNKfVoumoBmYR09cWZc5SQ1s/sxxDPBQt3T56Tk55OcY5v0mfKTLTgi02R5PAQgDQfD0S0Cf5oM5YykWNs3AiZPI9ju17F8b0NDYhAxMDIGALqMaQZ+10kQhzrHqVLEjeBMCwcoMbc5t416j+0C2hGKf/w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c35917-845e-4bde-1166-08d8751ea866
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 17:36:20.9504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qecGgIPCEnk3EDNAP1HQ6cbmyYl7q4rqKDTYceM5/B2C+HAe9vJ6njWxypc23k/EGKXe8XTFSfWRWOnT4oS+Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7298
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When PTP timestamping is enabled on Tx, the controller
inserts the Tx timestamp at the beginning of the frame
buffer, between SFD and the L2 frame header. This means
that the skb provided by the stack is required to have
enough headroom otherwise a new skb needs to be created
by the driver to accommodate the timestamp inserted by h/w.
Up until now the driver was relying on the second option,
using skb_realloc_headroom() to create a new skb to accommodate
PTP frames. Turns out that this method is not reliable, as
reallocation of skbs for PTP frames along with the required
overhead (skb_set_owner_w, consume_skb) is causing random
crashes in subsequent skb_*() calls, when multiple concurrent
TCP streams are run at the same time on the same device
(as seen in James' report).
Note that these crashes don't occur with a single TCP stream,
nor with multiple concurrent UDP streams, but only when multiple
TCP streams are run concurrently with the PTP packet flow
(doing skb reallocation).
This patch enforces the first method, by requesting enough
headroom from the stack to accommodate PTP frames, and so avoiding
skb_realloc_headroom() & co, and the crashes no longer occur.
There's no reason not to set needed_headroom to a large enough
value to accommodate PTP frames, so in this regard this patch
is a fix.

Reported-by: James Jurack <james.jurack@ametek.com>
Fixes: bee9e58c9e98 ("gianfar:don't add FCB length to hard_header_len")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 41dd3d0f3452..d0842c2c88f3 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3380,7 +3380,7 @@ static int gfar_probe(struct platform_device *ofdev)
 
 	if (dev->features & NETIF_F_IP_CSUM ||
 	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
-		dev->needed_headroom = GMAC_FCB_LEN;
+		dev->needed_headroom = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 
 	/* Initializing some of the rx/tx queue level parameters */
 	for (i = 0; i < priv->num_tx_queues; i++) {
-- 
2.17.1

