Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85FE38AF44
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 14:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242896AbhETMzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 08:55:05 -0400
Received: from mail-am6eur05on2070.outbound.protection.outlook.com ([40.107.22.70]:41185
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242808AbhETMxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 08:53:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvWvog/jAXZ+CHu0aKRfssGnwb6nKs+9GD04HaiNpqTOU69f4rnIU32Lg1mA9df9kV3d9MO3mD9cEAr9gqyvnl8PkJD5/+2flJ5XQX1taziXNKf/ks4BGfT2zzPuydKHoDUWB5W55WG8+aK36MgoYYdf3pKUsgVrbwKZkhrJJPvRvh0tVHvc+5fcrxf4XneZ/kRQkv1atjux+u0Jw6jklG7KXPR40w3yHDNZ4rKqywdHQURIu/TX1iAScL38yklWOfeDeG0r+cNJcwN7PA2HoN0V/POacWYCXU3R2ScKM5zDNB+jZ3oUtI4W+8yKlYyRdR9JI8nwR+U+ftt318r46g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipw5TmPIB0VYSze72pR/m0DdVCMChjEwVDAkFx+bL50=;
 b=OC4a9FwypnPVZN0Eas7tTjxGTKnDpR00RZQSquCiUIrNhFhqeswBAsgvUz+h7m1veVD9UB/7CcTMvsttjwMLHnmfGvbsw8o/qlLiJeajKgREArxCqJEjScSfg0bG7NKqu61FydAUYGIj3Nc47+GgzqLp09cZRVkZWR3EMZ1141QnSymSl/3ELaVUlZ8HcCId15A8XMFfelkXUQ7dwJKagfHs6dmdDptUXQDWy3Elp6EYa0FLLRSlMTWFAa3XGyHwfIKUPkIU+AOE/erLx8d56kI0oLLlzNDe/eZc6BIFlQG1FAzPv0Ag+LnQxfurhoZaFd7emyoIwjWNK1qZAJ3XMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipw5TmPIB0VYSze72pR/m0DdVCMChjEwVDAkFx+bL50=;
 b=GjaYId9aPEM0ICJgHtPwNDGvL/zxvhyEwVUneQwHtyCgMnlAkwDLLCg+nkutbdF3yEqXIrWDEGY136k0HD4DFhepthDj7dGvfNbOpoueKzLEhgmcje/n3+qaerZDRXakQ5vKOhjwgWCw5YR/dkXERU5uVH9Z3UC3a2/c1cp3w6w=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6345.eurprd04.prod.outlook.com (2603:10a6:10:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Thu, 20 May
 2021 12:51:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4129.034; Thu, 20 May 2021
 12:51:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net 2/2] net: stmmac: fix system hang if change mac address after interface ifdown
Date:   Thu, 20 May 2021 20:51:17 +0800
Message-Id: <20210520125117.1015-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210520125117.1015-1-qiangqing.zhang@nxp.com>
References: <20210520125117.1015-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR06CA0095.apcprd06.prod.outlook.com
 (2603:1096:3:14::21) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0095.apcprd06.prod.outlook.com (2603:1096:3:14::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32 via Frontend Transport; Thu, 20 May 2021 12:51:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99d00032-fe4c-465e-096e-08d91b8dfd66
X-MS-TrafficTypeDiagnostic: DB8PR04MB6345:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB634517E1BC7AE57A0D3B0EC8E62A9@DB8PR04MB6345.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: weWILU04lxGfCL0thB8HM/nIBV9YKzWKFOmWJCLGAG4Q6kjUoh4WgbGHZrVxmlybLXyClzwbi97zK2PQTJb0ixEwCMi5KAoj9pSUKPcGTKNVRyYxxq0+KlNJCCVO9o0mXip6M7mScBk1o2d4Lb1fHgN/G+hytJN+cZBGhFs08FymOsUMXRxxnhu4mECer2gyZ2dLTty1Iohfl7amEynL0v0DzfV/zpe5+sPJ0EFSDOxy92nmrfZcVBl6Zw1644B64egOfmJ3R5zkAAhJ2NYu8WCcAxpZlWntc4gnhqP4dWRnOhqiVJPriuutjH8j26lCrTpebPTSQpJ1HWEfns6AlZvc5zEu5w58z6FWSe+PXydPwsBa0GDUOqSDTM8hjZd3v5McP7Dg5G2nIj+IPNvoWAD6P/qCAPumpaSUff21DM7Bcuj2u02o/Z8OzoXdabiQwxiyIwcTE8UmnH/4FRhctWfT5x0LNL+FqsafoDofW7/04+eFxqhUg2TwGIjRz5DB14cIKF6DgcpU76SLYCgYJxt7gHED4v5eVELK5AgcwxPCBzQ4nQ0slKzXnsvQk2OCh9kN/HXnX43O9Z26Re9eTvPH7UHxB3xqV80k/ww8As/JJ9LhBytuDUoobcffS431uy1ksHcQZiDZLjOiMfh+ei/sQ3roS3CGnIQPmQ9kZuGLmW7F6CQTcSgvarr5L1fJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(38100700002)(38350700002)(6512007)(956004)(36756003)(52116002)(4326008)(8676002)(7416002)(1076003)(6506007)(5660300002)(86362001)(316002)(26005)(83380400001)(478600001)(2616005)(66946007)(6666004)(66476007)(66556008)(6486002)(2906002)(186003)(16526019)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o6K9mIckWmq9UfBF+Re6uwQWly3wynROghxGs0eDu4DhZEKe5ttB5WSq/TaS?=
 =?us-ascii?Q?nkQ6bmiRL9vVTSiQfr5cvfO+SjcEBhnI1g3XTKVCdhKukrkN5JGRq85omv+t?=
 =?us-ascii?Q?qoPJgrj3uqmKC5Ens4h2gWHfo2uJRghhqyN/+xsEH2poF/Cd3sToLtkeyfEz?=
 =?us-ascii?Q?iEaMpMxqHqnLcRI3GDegVfVVO6lQhbt0+q8/+4F0lL4HCfYF/NpCjbeOyUD1?=
 =?us-ascii?Q?6quif8tAprLNklWTNu3bs+0O3IJUz/O7GW9byh3Nlazufzd9T91cx/1LmYqd?=
 =?us-ascii?Q?JNrHV+fmRiztyQ19pimttQyc9/Ah97pA8NBNHj12tPK4CwVHkbV8Nlna8LPG?=
 =?us-ascii?Q?7sbbyh4YG0iYjDl7egpU+TJdC3pbGK0A8Tq23IJU6mKI0C5b4BAJz8eKB0eS?=
 =?us-ascii?Q?wd3nmcw6E7CQ8DO8atj8G4jJi35AWlDXchWfR/XLdaaqBHarYuB1Afnn/H1g?=
 =?us-ascii?Q?8C30eWKgm+TSjXKYBtQnTzFvWc5EDUlae9zF1XTaZlaJqyaCzE9ir3zF4PKl?=
 =?us-ascii?Q?A3qjxqHEklOmd+UVT154kkVT3ZVy9FnmiLeHoCIJUraReasJ/ud4ydfDjw7s?=
 =?us-ascii?Q?61EPCZKaEacuHws4JMQjTW/W9Kp/2jz9txr2Gy3/XrfJZ5rLl+SvhPqHrh8s?=
 =?us-ascii?Q?8Ja7DsYonyTEZM+UVbocsaRhv9kKjboCZDiw1Cz7Q3SU8uHxCj9F+Z2bo3vh?=
 =?us-ascii?Q?GsbuGbHHOQgvUnRXm3l18cw2IlOsbweqF9wpu5+9cDlVaP6YpXD3SXNhDfit?=
 =?us-ascii?Q?xjBcnqyhMFU8BOHIG5ZGH2VC3N8WYU+JCWjKuCEJ7OiMYBpl+/p7ItnCGAhn?=
 =?us-ascii?Q?USpnMwAKu0MS3WvfcxiFkk1g9eU1419h4CRkdKwim572pvP4+ji5oo9ZYC1e?=
 =?us-ascii?Q?GTljSXRQGaaR8NNL9KyBrszaOFYEDhJeb8mZ+96p7itMZfEAVXrObRtMXXKA?=
 =?us-ascii?Q?R6eBswh5LawQv1GIlIivz1gHsHQMGeDNBV+YiTxPDLeKRhSKEY5fs7xp5b32?=
 =?us-ascii?Q?+xDbNH1OBT+MsFanJxg0+myeKWt78QPJjwjWOkjwpm6WANfBTe9Rwae12iU5?=
 =?us-ascii?Q?GczO7kQRzG1Vi37dvemtmxhksuF6uYDhyboSl+R7K17LsZ0Wkx2YTvqxA8xn?=
 =?us-ascii?Q?tjXrAqABoAVQ8ppWnSy9ijS0zGjQ+TgibONB6rSaKIqi5a5XC4CFRiTnJfhP?=
 =?us-ascii?Q?/bhJ/SbxRRZ2ZCjdga0syPOFMkkCWoX9pqtkxtlut8sserwzCtLrzfmeQyiw?=
 =?us-ascii?Q?r1v4tz8uBp6p93zBiAa4QngjpkMp6kZAq/kfr2oBu0XI1snDCIlfGKiRVI1X?=
 =?us-ascii?Q?hG5YZkZxHdj9bGHQpboPpsTl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99d00032-fe4c-465e-096e-08d91b8dfd66
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 12:51:30.8383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTWExuoGviA1rfE5TZIinm7rcpC720G2X3nHuuw3UDUFdR82FnW22CG6f9AevWaoUE2OBUh1yiFpUNWUWfgfXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6345
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix system hang with below sequences:
~# ifconfig ethx down
~# ifconfig ethx hw ether xx:xx:xx:xx:xx:xx

After ethx down, stmmac all clocks gated off and then register access causes
system hang.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index df4ce5977fad..5d956a553434 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5891,12 +5891,21 @@ static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	int ret = 0;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	ret = eth_mac_addr(ndev, addr);
 	if (ret)
-		return ret;
+		goto set_mac_error;
 
 	stmmac_set_umac_addr(priv, priv->hw, ndev->dev_addr, 0);
 
+set_mac_error:
+	pm_runtime_put(priv->device);
+
 	return ret;
 }
 
-- 
2.17.1

