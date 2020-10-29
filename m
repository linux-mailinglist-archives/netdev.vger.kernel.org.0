Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A0C29E65D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgJ2I0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:26:18 -0400
Received: from mail-vi1eur05on2040.outbound.protection.outlook.com ([40.107.21.40]:48928
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726942AbgJ2I0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 04:26:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfQVsy0WAKfosIYuzEREXx86QBTM7fNcgiiD8JggXZRozS7qn1ys/1Q5CZGxTPu43/jp08uU0yyckk0KeebC7eWo7KXtJN/NhukRnHbwChKWonOvSx6nBeilsttBQ2bahLfo17iPUUhSzYz5hzpcbbWM6qJSHN+bwbGHvIXsPaKxsAcBIAU9sG38sYNxIUD0Jfxm2MP6ITJmcCtLRM4ivs69o8UwP0pkhOOP2W0G9m3/pi7l5mniqJ+HIO9k54UeBeTpjLv7t0/r9pQIJ2ROH55enqY8ET+YaqB60Rt2+r2211TV6t+QZeD7l33p94dk9dOFhULiFfY1yQlHc8HF5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5QEkr9pMV050y8DcWqibxme2N/Jru5rBHtKOUnzxSw=;
 b=FzLMeZ9q7UXJA1Id/kdfw0PSJ1Eo5TcGrhZyWtwOF+y5Ng3YpigRQr0N+mntq5X7pyRYmnqVutNM6qZSlkW9pX6TqbiDd8KbE7QtPw8xUm4JCQ51X+t5Bk7pU0tYu9LKtbt44aRIksJack/PY+2ITM2UnY+3hxZb16pa/5Xf+1V4uYZ1JWf2vH5mnGO7xgiy162QeHwsFP1F8CPWszYaDbkdJ7AVHSEeGf0UeXxjqCzcRuy88Dr+Q0DnBoYWX534+1X8MkqXKEitjUGf1j0bFXxgx4cEgaRWYpaDF0iixgVc2pCq+z1Wxc8ITMEBkJaWwYRdo4zJDHQCZZXabE8DMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5QEkr9pMV050y8DcWqibxme2N/Jru5rBHtKOUnzxSw=;
 b=DpC5u2Vlz+yMzRoSp/9uuPLpXzrZOuMxzrTYbM5ldP+65t56/4lhaWiEccAMN6oDbmpPaIJODuPJuoZKrt/O/3d/zXGSh7F360O7baNmtumWH9cyzATnLBKL7N31/BrOfzU9ZFftZMtdK7zbNVmkRsDKoq12/e1XlGDTqoQABcA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR0402MB3827.eurprd04.prod.outlook.com (2603:10a6:208:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Thu, 29 Oct
 2020 08:11:10 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3477.029; Thu, 29 Oct 2020
 08:11:10 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, james.jurack@ametek.com
Subject: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP
Date:   Thu, 29 Oct 2020 10:10:56 +0200
Message-Id: <20201029081057.8506-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM9P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::17) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 29 Oct 2020 08:11:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6eaf9ab2-c887-46a4-76d2-08d87be23215
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3827:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3827FF6453C94266489C45FF96140@AM0PR0402MB3827.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ml5BKnuFRZt9ofPz/QYpzR+2gX2MFnoYCQjn4lzacNn0Myyaeh2WG8X9Nns56K48qlufQg2HuBvbhqMJMlZ3bJM3ttvEdwuudNXiZIKEVK5gXgUx3b2sSNJuFIf58BHHBYY5oi0u1n5bmsQQAa5Z7sttT7Baevj/vTvdxJ3B2pMU+BZsB1tVXoIVLMH4oD57Bpq3i2nNeki9heur5gOYI1x/HhXMzCASsrwibOA26TZSO5V4oIK7cnaDBW6CgDM5r9UH4ppl5nJFa6pk0tkXBMFtnm9sYtahTOyBrSZ76IZ3XO/lLG/zdQIacQOr2od5P8wR3byADSBJusrBSvoRLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(2616005)(8676002)(26005)(956004)(54906003)(86362001)(36756003)(316002)(66556008)(6916009)(66946007)(66476007)(83380400001)(8936002)(186003)(1076003)(5660300002)(6486002)(478600001)(4326008)(16526019)(44832011)(6666004)(2906002)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KoQHBAw9jWgn7V+DQqu5jEDAFbp1GmqiaV/rcu8QKTgqkFUi6dhQKUBkGaZ7KOAb0EwMzXyJwMNEiUvUw7maWKtRB8G6TIY/qjcQdRsIKnKXtgVefLLLXS89/JxbColKTbahYD5QtX3pU3mHBaTzPzuNhYSzQdx8tiyAvxHaikbroMUuAeDmwfLKEwxMvCii65hOzPTBtu5PKBUqkS6EsZZLg6LHJya94NRWdjzYMGZiOjSmirp8AvAVJ5tjjehWnFc7pUSUgmz2063XOxRSbuEQ4SjzBr43ecaSyAikbWlX97pbZbNTl5xA+5R0IvUKjqzOMICPEaOORXJtHTxoUlLrQBonBEJUC2mf84qfYuSO0NhBrYNQuvZKPXcKuK9U6v4z33EixJifgpYvfVwPxfjPSLzhb2Rl16pzR8E4lbmnHbUSZEBjZpsjrOsb/gbWYcA+pMGgbrDAkvII/hr9lx/3K7njiXePvOAT4Unaf4HxHzJbJw2Z+Nuxgc6zmxRBM1w+TDuiYGB7IUtwVs/lMtUUVGj2uf53dWhjyNOvXa4dMqyuBXdE47wjK0+14R0yZyny/AC4K1bm3YBTcvx7TuIPNxk6ujNYAfdJXcpOG2wb8mjV6iyyWy0u16dV37Uaxk0gtBgFKj2CbLqSYXMp/g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eaf9ab2-c887-46a4-76d2-08d87be23215
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 08:11:10.7797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: miSs7xF5DRZg1RsilwskHLbwFAquUuc1DxkMstVn9+tayHg1aeFYslFQl9NUgAGvqj2uEkfEjQ03v7zwrnAXJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When PTP timestamping is enabled on Tx, the controller
inserts the Tx timestamp at the beginning of the frame
buffer, between SFD and the L2 frame header.  This means
that the skb provided by the stack is required to have
enough headroom otherwise a new skb needs to be created
by the driver to accommodate the timestamp inserted by h/w.
Up until now the driver was relying on skb_realloc_headroom()
to create new skbs to accommodate PTP frames.  Turns out that
this method is not reliable in this context at least, as
skb_realloc_headroom() for PTP frames can cause random crashes,
mostly in subsequent skb_*() calls, when multiple concurrent
TCP streams are run at the same time with the PTP flow
on the same device (as seen in James' report).  I also noticed
that when the system is loaded by sending multiple TCP streams,
the driver receives cloned skbs in large numbers.
skb_cow_head() instead proves to be stable in this scenario,
and not only handles cloned skbs too but it's also more efficient
and widely used in other drivers.
The commit introducing skb_realloc_headroom in the driver
goes back to 2009, commit 93c1285c5d92
("gianfar: reallocate skb when headroom is not enough for fcb").
For practical purposes I'm referencing a newer commit (from 2012)
that brings the code to its current structure (and fixes the PTP
case).

Fixes: 9c4886e5e63b ("gianfar: Fix invalid TX frames returned on error queue when time stamping")
Reported-by: James Jurack <james.jurack@ametek.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: added this patch as the actual fix

 drivers/net/ethernet/freescale/gianfar.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 41dd3d0f3452..7b735fe65334 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1829,20 +1829,12 @@ static netdev_tx_t gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		fcb_len = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 
 	/* make space for additional header when fcb is needed */
-	if (fcb_len && unlikely(skb_headroom(skb) < fcb_len)) {
-		struct sk_buff *skb_new;
-
-		skb_new = skb_realloc_headroom(skb, fcb_len);
-		if (!skb_new) {
+	if (fcb_len) {
+		if (unlikely(skb_cow_head(skb, fcb_len))) {
 			dev->stats.tx_errors++;
 			dev_kfree_skb_any(skb);
 			return NETDEV_TX_OK;
 		}
-
-		if (skb->sk)
-			skb_set_owner_w(skb_new, skb->sk);
-		dev_consume_skb_any(skb);
-		skb = skb_new;
 	}
 
 	/* total number of fragments in the SKB */
-- 
2.17.1

