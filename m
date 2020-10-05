Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCDE2832C8
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 11:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJEJJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 05:09:29 -0400
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:32832
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbgJEJJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 05:09:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXQS+Um4pgGl9XYMTw4+LNWCnddNyI8i7jFYOW5XX9T1XaDWo7yEkOZuwmERr5oKoEDE1hpTL2EVynOT3VXOWSDvnzoFK5YZyOqrVhNsFsV6Dl6gtGGm9/uJsfvA9TcJ70Kyq5cFKC+beScafcOm5chsY+1RPQ/nrP1ym/pzhQ86qRwEJ0wgJMz3JmUVCKu10Fw/Oj7VPrC/d83+hGCJIV/r5jJjonK7i/iDlTfXr0mRg6g9Eum7PJ4ZZIYgM6KoNrlVPNXsEBlUJa6ekd/ir8yI5S3wXN7TqvC1kU5WWMEhH0SEuYduo6eoTJW4Oe/YU5MUV+bhmpB5s50elTbEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geg+kGNUghRkJIS6spJlmbiw9kj7tnZe9oLqlB8eZ5g=;
 b=nrCnvLtjgitDPpmu1Cri+g0NBLdjI9jQfkbDRBb9ILC1dTAOsLdvsYifDd+xpEXtzXOwrMtc3DwCE/xrZe0XgnSDJp6WC40bveA/0P12PNTJm3zoM5/CTpbRRjFxyHUgZsHefHaboHuzxVe04bztAkZTFvAPH68VK6yFeX9uYrS5tEfmC8XfeGeefjA4ZdDnHJG7aPO5jc8lZV+ArsPQfGzYaTLcSz6vjJZPFNZ2ApYoZrdz6TbYj9U7e+mj7sv5FHeSyxsUQxjNvRL6RWteuTFvF25YxgbVQUfWPSJBv/GBRJvr7SenjHnalLIWo0el2DRN1/idWMg56qmP/B0lFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geg+kGNUghRkJIS6spJlmbiw9kj7tnZe9oLqlB8eZ5g=;
 b=nySrxZDLNwkiuqn231Q93o9IHGBLldhhf5qXjHwvlv1wMSfqaoD7MjZRa3DaKICBodMPXNG2YYqNyBwmRbMgDsYaHnyP0EeJ+b7nw1BIjRU6IoSlNDVB92N8ZEjT6yA03hD1+RVMayT2ARDAIO7+Yj5ChJefuE5mb8hohy4hdw4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.39; Mon, 5 Oct
 2020 09:09:22 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 09:09:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net 1/2] net: mscc: ocelot: divide watermark value by 60 when writing to SYS_ATOP
Date:   Mon,  5 Oct 2020 12:09:11 +0300
Message-Id: <20201005090912.424121-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005090912.424121-1-vladimir.oltean@nxp.com>
References: <20201005090912.424121-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR06CA0198.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::19) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR06CA0198.eurprd06.prod.outlook.com (2603:10a6:802:2c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Mon, 5 Oct 2020 09:09:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c8e68ee-5751-4551-fbbe-08d8690e5958
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28616AE2A09213190633E5A8E00C0@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVa+0N4Jdj0Fvp9kkVYg8a0gNJ5bRt1uPT3dLDzmedHzdXv2nmHatso3iT1umoIId/njnGEX0mZJIWwhlAY6Qf4qe+pI2cJXR4WJoATD5JebGrN7g8XgWgwvQwilGjzLoz6V8KFQHeeB4XXhnPoeTYOiE2lkWD2MLJcOLomfqaVLJMQBsFPkgXMGZHVluoNtc344/VxGQRI1efSF8XEC2tPQ9PNcUJj7o7nsvdyFPoRsOuwSVuIquZaUGJCzXZii2dfthDA8CxkZJBtw4HliAt9l/Ayp86MwEp9QLutd2jIDfnjQcdDno5mwN2xGq+UflWUY/zHJto9LC4mU6mIpyR0uS9mbB4X41t6ENbiQ9st9a/7ULot7rTDZoJKB8+fe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(52116002)(186003)(16526019)(1076003)(66556008)(66476007)(8676002)(2906002)(2616005)(956004)(478600001)(83380400001)(86362001)(36756003)(69590400008)(4326008)(316002)(5660300002)(6512007)(6506007)(26005)(6666004)(6916009)(44832011)(8936002)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kTnx1ommCw/7MEBEs3Je0bvHGmaj0NMWM/90WLFqhXwbwd8nIszmlh4yg2LELYAHLONrOYG9YGd5uFalnajs1Qtad6x5x+RL5Yy0AkHZxmmFOxQ+bAbGxJd8jksQJm421z6FVAnqXaLdED+mbL/pzbkxgdaV2qy4iXGZsisLHNfT17rjon2NW3z9WiiSqeaxsnIBJSmmknfVAEuBOJ2aWjzb8wPtVDb8BeNtu9+bhJ5ZvX1bVuQNdzDuqVXfidPljc4LL9cM8ndwzlkdeznrHm6USqv8yY/DOQlfa9pGBytDBVFVjPbjwVN0D0Lp8zR9Ci2c0rxzM+ebplOpjZwmVFhiTbt2Tj+h6FnQyKHxGPkrrwHIJTolfSXU/aIaxbA3xGVgMkveS9JLRUQDronvJGEdesvPwB6dvsAFp+uDuwBYTwUM4cpfnnViilJyrCAO/ZagVBCgbAM4bNvq42oa06XnIIQYtdTgSvvYqB444SFtjCPnJ4Uda/hM9UqyavkawNCaIvRl62DEN7qd5NQa7zMMsQ5Xu90F+w6rV0Rdsf5AZXDxzmShL/FF3ZNfEtI0Jjt+JY0SsE17fAkIUDGeKKQEZI2q6TSgD3XbzYcA6dqOHiM1aBb5IUbGVgvbUGE9TwYjCw7Kw8iZFJHJYl3bAA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8e68ee-5751-4551-fbbe-08d8690e5958
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 09:09:22.6575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bwOTnUSQziRhyEUC9pQiDx0jd/0q/MMRIb+bkbpdpA2SybiWqxAcVV5b1xGtTTLRcoIzNPiKUqTs/eW65Z3RqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tail dropping is enabled for a port when:

1. A source port consumes more packet buffers than the watermark encoded
   in SYS:PORT:ATOP_CFG.ATOP.

AND

2. Total memory use exceeds the consumption watermark encoded in
   SYS:PAUSE_CFG:ATOP_TOT_CFG.

The unit of these watermarks is a 60 byte memory cell. That unit is
programmed properly into ATOP_TOT_CFG, but not into ATOP. Actually when
written into ATOP, it would get truncated and wrap around.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e026617d6133..f435dc4d5573 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1253,7 +1253,7 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int maxlen = sdu + ETH_HLEN + ETH_FCS_LEN;
 	int pause_start, pause_stop;
-	int atop_wm;
+	int atop, atop_tot;
 
 	if (port == ocelot->npi) {
 		maxlen += OCELOT_TAG_LEN;
@@ -1274,12 +1274,12 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_STOP,
 			    pause_stop);
 
-	/* Tail dropping watermark */
-	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
+	/* Tail dropping watermarks */
+	atop_tot = (ocelot->shared_queue_sz - 9 * maxlen) /
 		   OCELOT_BUFFER_CELL_SZ;
-	ocelot_write_rix(ocelot, ocelot->ops->wm_enc(9 * maxlen),
-			 SYS_ATOP, port);
-	ocelot_write(ocelot, ocelot->ops->wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
+	atop = (9 * maxlen) / OCELOT_BUFFER_CELL_SZ;
+	ocelot_write_rix(ocelot, ocelot->ops->wm_enc(atop), SYS_ATOP, port);
+	ocelot_write(ocelot, ocelot->ops->wm_enc(atop_tot), SYS_ATOP_TOT_CFG);
 }
 EXPORT_SYMBOL(ocelot_port_set_maxlen);
 
-- 
2.25.1

