Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014BD435189
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhJTRoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:44:54 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:56487
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230425AbhJTRox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:44:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ib4TI8T/9SrlNZdWOokwwrm3y9PPSfifOWjJFHAOmn4M1156ChkiWv5Wujc3MksJBvVD4IhjQIbVVh2Egm3iuwJvKjETg57a4O8giIfxqtVAbb32yjhHP10YFljPl26rBB4lOVQZfv/4ZCU9wKdmn4oPeSuY9R5Ao7HAcvH9/qXY7Z34lKSHKWup36bqcVxab1f6c8eHh1FqHmL01TU4AKQEgvWAtuukLs7GljpAXw6oZymKYns7ZsPVdzBW3Zl+UD69M5j93zeQO5Ue/6Z5bY0XdHOFlg2rCZvyVPKnnqFSpMfNCvmrxje5VFn3C24R9kM5+oAGeSXBe0qYPKFJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JgqdNMx3fDrwn7k6zifRRGr1AeHZRA8AaJVJUArafw=;
 b=bBZipHojlCzgxlzOJNPdozoulhThcSBSj65mpfrIMUn4toBWlZTyy33rZ+kqcjN2pRAP2MwWsEFpwqovlAhexI3/7Ylz5o48YhwSf0MpyixMxOmoyL4r+2OW0ybPZdY4mr28zTbe7cKTtLE6KaOF96A/Ku5il9w5MDmM142ZgQxTWhgJt3ghcCD3WXJ1qID1zuhge/3qbrXdvqWR468IKnK3gof0Tb/Hf8exSAUAgQ85FPO3wKmBPeLYXcvctanz2i4ZlVDIDXtmPzTzEEVn+exOa9j7cwgMxDqSXi/rKbVlsO3BSJMvgduFa6Q3xPhwaQ1tMbVg4B/i5X3nXVxpkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JgqdNMx3fDrwn7k6zifRRGr1AeHZRA8AaJVJUArafw=;
 b=F/bPn7xeRGfeRw30nTeXBwPvIGWOx9sFlJoKNTYUPaNOw0kJd6pBZJIQyKfsL6zII6ieZ7mK7yK/UZci20inFReXtEYy4jcy/y3ux/HZz8urIoHRH9nUCeTgEJX5c+Ehf9kZi6wQpNBHBfVbllUm6Lqxh/wYa6d0mha6a+1F8SY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2510.eurprd04.prod.outlook.com (2603:10a6:800:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 17:42:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:42:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH net-next 0/2] enetc: trivial PTP one-step TX timestamping cleanups
Date:   Wed, 20 Oct 2021 20:42:18 +0300
Message-Id: <20211020174220.1093032-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:205::25)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM4PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:205::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:42:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10d45592-8016-4ff6-0c45-08d993f100b6
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2510:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2510166C30B2BC00EEAD1FC7E0BE9@VI1PR0401MB2510.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xpc93Vusz/VQGXHrzLy5ygW6v7rGHcg4trkir60dPBTcCXR7Yq88v6SMrpdZEOJ/aG+HG8pWciTi7OH/kyyc7FitdpISAS4+5wgLgie9Yy6vbLF+z3FzVUuKSjuRRw4uOxDfvDIvnxnuiOTWDcjcVQ01hNNlyw5k3Lm0WxJVAV/805lnED4xg01CU/w4te00xlWpmiVJpdNA6Bun4XH0qxDoii3MgsibAOQuYVGhsGB/HBX4Phgcyk3NczWLunpkBKEwWOBivWItFHBpuZZ3GPr4GwHyA/v9E7CCvN77ekx17WR5cMIueyKGwFn8yg2b3pVBOlN9KFnE9K/4kObDu0XkrmS9UEtcu3RxicihXVMk5HAndmEAZWuSxeL+bDjGvl7BPSR7mIC6HNsTeo9DozUXvbyGAiicrVKzMxL08FirZEqfX8f8W4LrYrcqhazzyyUczeK4GumZMBS/JrFGlao/pCOr9FuBQvnohaWTJB2IrBz9YSzhcVy3OD47RO847oFDOn1/9d2hdNI565KghW3NgqvQ15KPg6vF/CbtUsXO8gO5VOUniX48973+/f11b6Tu/l3SYbw3BgDTNKVc9TLBes6T91l82U+u57lJ7oLdTN8KKp+vStWLaoxRGWALz7JJ2Nctq3FFxE0biFi4Nxpvh2O4vDenb7xDXoRkv4XR96gSvOT5mS90s0UMXdO2pVWzm+txw1tCYVohN/uIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(4326008)(2906002)(8676002)(52116002)(44832011)(6666004)(5660300002)(316002)(86362001)(6512007)(1076003)(8936002)(110136005)(54906003)(186003)(2616005)(26005)(956004)(38100700002)(508600001)(38350700002)(36756003)(83380400001)(66476007)(66946007)(66556008)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kwkHnzv4B+HEto7R38Ns67FFaDMiJ6hsw3ml1oVP3TpJOTRjZM7+YansVmpj?=
 =?us-ascii?Q?JHlnXtEfPsudA7CG0QUQOk9tsUNyoPAvQ7mdxvjSm2nnC4ZCwOasiJcodFpI?=
 =?us-ascii?Q?j3oeWFFkhlmG2sYInVATZpjdutKdGgo0t2s/oVpNgF1qRIFyCRRn1NF/4NCo?=
 =?us-ascii?Q?8XkZZsHcHcrU19slqzGdZaUs252roy5Tk+6UO9pEEnFv/1X37mbRIMwcRpjY?=
 =?us-ascii?Q?ITMxWBF3yuiviV14yLyrufyas4jCmj9YYnK8qGmDGfyMLfFGjaTkDGV+I6n9?=
 =?us-ascii?Q?zcMNymiY+WqQ2twaxRUHrR+2c2Bj8hh7bhl5AKyktSbBdrwuoSDD6reUprK4?=
 =?us-ascii?Q?tVRJ57I1mILk63cm3kZq0z5uWaE8vTBVvdprI2wFGEn4NFL3uqMV1y+IWIXt?=
 =?us-ascii?Q?lKjILL2W/gedhIYedxrCyRychcAog+ZowJ5ej7+pdyaov92RhgpSsZljPV0h?=
 =?us-ascii?Q?8Z6GxrO2mWYPDy5t8ycWzJs21TKO9vsNZlOFbcbB/kP9zQIRi8Kc33Gz6Gsj?=
 =?us-ascii?Q?KrmAN4ciZNOGhUyCHUuk8mcW14rKCWHnEi1J/0Xh0nW0Q1bD1W3YuxC2beKq?=
 =?us-ascii?Q?5OU5Eo5jbJaHFmpSstcJjkWe2fS39GWUaP08TuPpHcb3BBEuRguP5r+M5e7i?=
 =?us-ascii?Q?XnCe7KzOXJY2N68d1RRhHKMAyaLRgKajmFU4hgJnJBx941EghU//aYdX70Kr?=
 =?us-ascii?Q?F2Tb8bRHoW4mMCbhsoHAHZSodlFi5Qp85vdv3sldQA1ChSYzvcoF5lZBAI6L?=
 =?us-ascii?Q?vyKWjl7h0PWsEGlDznqv4srTH12C2ZiTsei6PjD5uEksy6ca6m9aYTBS0SKr?=
 =?us-ascii?Q?Dozw2gyT5zCFJd6k/nE4HfOoR8wZ8xj25jY1gDIOtWDeaotb0bQUGYRWC0AH?=
 =?us-ascii?Q?wX58xe1IyBrp0Ho5hzLWwNgZOsaY6MFxWpQXvJcGmKipSvzLJkBNe+XiJFov?=
 =?us-ascii?Q?Ftuix2mu0Zm1kpT9Wi9dNjSwUjC71X7kaB0mw1qqwNffeTTM7USPONb2TpqH?=
 =?us-ascii?Q?Lwk1iDYSlPVK8rATgOuekl39smu6as2w432wD3pZngdmNkUdvH+8Lr0QxLUy?=
 =?us-ascii?Q?E4GDqrostlhunSSi4Fd/zqeo8WC8vUi4qEzREBXdMcyevMwkBZlK7bYC15de?=
 =?us-ascii?Q?GajPqsrxEedAsz+sHLJs7HqQL8ADZ41QA0/xTHfCO/i0ENQ+2gWpJoMdSRgN?=
 =?us-ascii?Q?cSWymImQRjBYRDKaQHxpVfGfyJYPEhm5nO3EDFEXF/mXV3hE4kOrg2xMw27p?=
 =?us-ascii?Q?HNqQARdlsvxRfHbIP9VyjLTnxOirUaiVdwZ6OFpEO4KKaAURLgKBZQNt8RI6?=
 =?us-ascii?Q?0ZrNWk+dSM9hpGoIo8+HCyYT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d45592-8016-4ff6-0c45-08d993f100b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:42:35.9756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xXf74JdPWQonlBWFD58hD5mfrxnK8dcqCOtLH0qAMCsOE9jTJxSPjl/rB5XqKfMPC7O0znSk+81h1/0y1suCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are two cleanup patches for some inconsistencies I noticed in the
driver's TX ring cleanup function.

Vladimir Oltean (2):
  net: enetc: remove local "priv" variable in enetc_clean_tx_ring()
  net: enetc: use the skb variable directly in enetc_clean_tx_ring()

 drivers/net/ethernet/freescale/enetc/enetc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

-- 
2.25.1

