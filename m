Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B0333B25A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCOMRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:17:11 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:2245
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229734AbhCOMQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 08:16:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaoUb8Vzo7Mf3kSJGmwk44gHX8woAMZ85DN/ffvZMx18ZUKKdmjK2YgUcwE+4BDFXJdMrnsIOo+r+DuhJAJdujFGGZiLfkLRQnlYtqYbRnjuXZLYvLbfFhDXJJ8ndAwwd9HJkcazuGDh5Ya/y+nfxtIOaPZeo+LVRG9oOEst/pLZ8FIXiL9ME0yO2bH8OG6x7urtg7XEHAKAGLRi8KqUottoAoNt3bldiZ4JEc+STWTp5D54Izd2L4DjY2p0s5A4wwgegM1dXsvkgFIYnORXSonJKQecsiVPcBV8yNXiDOlaNOtSvOkHg+shuhvn+Jv54skb7ilEjmbKArv5ltnmfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t8mYXiuwJc5jYSNU6glW6vSUoEroNnuHeB+oIbyJUY=;
 b=I60XrEhiKPQY5xszIxHZlFR2bQhCRbBkn3VHLaKzmDNLKRj4b2deY5xL9V+rgb8u4hWfA1QWkzxUPx0uuvhNpA64xvGwEZIwyMGpwB3oWBREvn/Gi0J6TVL1TCrGN49nUS+0pXGqNwLKzGcKwJSPjVrwu2pFsHMKtfMWqUlF2L+t5/Of+D/4NbSWjY9UYKw1VC2Y4zLzudakepki4UByncNXSpUqf8jAM+x9pZmZLrvDCdku2UI+ZH1uDceZ/4S0k3sLJItC0jyjrM7gGShNI0dNYsFI1pAz2LbVtNS6nl47E6ZXNoTg5Zu7nrj3rs1YNcRyzIDyLz1xEUDMGIE7Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t8mYXiuwJc5jYSNU6glW6vSUoEroNnuHeB+oIbyJUY=;
 b=h5REsJ4atDoXYLLq10QHH3Ox/FygDpLgz+qlUT3jKlzuh3LV8qJQtxdrk1Ol9SCl7SzH5GNTYbp7KwRbmJyMaJRArqjtu1dkiPTE3fg71D5E2pASnvIOmR6U1E9YLz4BtcD9QZnQPID2wbZnjLzgruUZXn4Y/4qZowWK5iKkbRg=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3206.eurprd04.prod.outlook.com (2603:10a6:6:d::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 12:16:39 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 12:16:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 repost net-next 0/3] net: stmmac: implement clocks management
Date:   Mon, 15 Mar 2021 20:16:45 +0800
Message-Id: <20210315121648.10408-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK0PR01CA0058.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK0PR01CA0058.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 12:16:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ea525ef2-cc8d-4e5d-6265-08d8e7ac2f3c
X-MS-TrafficTypeDiagnostic: DB6PR04MB3206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB32069357C49B30BD92E4149AE66C9@DB6PR04MB3206.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMp0qUpQZ0tyumkBdacowJb2WNmWjliCZMsXhZDihL4FTZ2uTrXuQoZ675QccrIXT0YzJHk2NeOajSdHc21bDwbAydRt4oeuVu8zTcOb5riiIpOG3+s63WFwgEGu8DrNpZnG9qhvXqVCb1q9/PUw1OwrUWX2wulcaiwO7NvovIHGXVK29bMsT1GMtkTHgeKWrI8au0O08Arc7zohEXnxU2xoYULISi1Zp7hwciyk+VJlk7U/LpR5mjLp+hOeWQga/KFMRw1p8zyM0OcN0HKcaQ+3gVlj79WGAPoodvkvKzRADFqFBXsxsarcZlEVVeyh3jC0UdYgsQF/uYDJomu/Z9tkKAAB+GmHNFpU/CH2MKxmblF3WQisWZPxSD7974vE59FJSIKEqbkcLxCyD4+c7mdZk3QadDKyzHo54WJoL4zVsXhj+/EN+nLtlxRLpXvi950liS1QtQcGUoncRX8Dsv0rBfBWb559noqPxzGDP16jmaVufcx5Md+EFBmAx2IqnDRVF68zsRcRcGyYnQII89IqkBtW8xIXWPAoYYch6lts2eC/gC9M+tvnUAcg7UCxoBNWYjKqeukOr+aLwcb6hJkYdk8fdnb6jJRJ3wfudZUR7NlymB4NaEw1bVBcIbjO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(4326008)(316002)(6486002)(2616005)(5660300002)(8936002)(1076003)(186003)(2906002)(16526019)(6506007)(6512007)(8676002)(478600001)(26005)(956004)(52116002)(66476007)(36756003)(86362001)(83380400001)(66946007)(66556008)(6666004)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?f/iw7j372rkIGbUDQ2ueR4oyG/M7cQiP54O4hdE8t+OmgUK4zh2acGuIqHA0?=
 =?us-ascii?Q?ytzE1jYAMrCIhRK6C70pl+I9LoiEMD77J3LYVBK4Gr3iqnhFQr6Ct8x86RdK?=
 =?us-ascii?Q?C4h0apB5i52NFyDueDKIbgie+nb0QA1wk/pxxbnS1nOYZN5OA5BMwU7I7Slz?=
 =?us-ascii?Q?lyqXOmpTGGiXjmxW1QR/JDGIps2qMzpZDR7RwFs7IYZqT2FcLCuwDt7/dkyu?=
 =?us-ascii?Q?cztyn0ikpA50YQbfz8AAZxpnVcY1sRzDURLvxhfbG1DciJ80dGe4ZpFkAhHJ?=
 =?us-ascii?Q?BzxKA57ubAzL5TxhK7fG95aCXKGLcOrtcCc65M6wyGrRMg7ICjqFl98u4CTR?=
 =?us-ascii?Q?U+kz5uM2YU4sqgc7Y5KQ93CZJevQL++vgYbOx2pcKSTi6QysTh5HCKf6lwnA?=
 =?us-ascii?Q?BaTiQh8u0IEKN3fKQJ2p1FuWd1DUWs+smgvWt2LeyYBFgHk8Hnw27TOvSFQp?=
 =?us-ascii?Q?rxV/sHnplV+JaWGpD1pHnYCLjBfDyLal5BUJ7VyjuqvgtpQen5BDHAEPUv+N?=
 =?us-ascii?Q?YhgLC/R5Sz9VZn8QBUwyxt905DhKr3gv2s+oISd4x3xBfIuABRMpL+FRw5kC?=
 =?us-ascii?Q?viV2vb6PwXMWwfHaQQYKaQuZDNweZb4FMImzmZZWuEzgt2BFZRSWJe1lSbtH?=
 =?us-ascii?Q?j85j32qUcGWRUXOl+4Y/jcZHh0odX/G9/DXR3A3bi3ancP7kDYyA03He1Z7D?=
 =?us-ascii?Q?5RuOcGejxHVQPXtuecvDLNtGkSMc+/Zbb77htyI8gnWACZBaabmDwON57+Lx?=
 =?us-ascii?Q?kT31GH67O6oTkG/gsXnvLACEBMx9/nlwnaoPmKEjh2MwouarLTiE/epINhSC?=
 =?us-ascii?Q?A5bhwltIfvh9F0zygZ8trOE4W+oyAVJxx5xZPVaBJ5xTlpXSVbBKkqeik9p+?=
 =?us-ascii?Q?4jXH0qmFFwdKQU3ep9VqxXByI+OjX8l9zjrKce27UVZvf5NbYu2inGssU2k6?=
 =?us-ascii?Q?QYwNxVr88cbS7H2cYyLOB2FxlmP8bA/okvtxdBMar1jQTkftY0SoPdGKaqp3?=
 =?us-ascii?Q?G0AeftDh+yLC8CuTYFBHCfGKi1/ZFP/bvTF0EyFhvBFhuuOMJeBHAHgWpmk2?=
 =?us-ascii?Q?Av0N9RxN40hyw6bCqmMD/dt+fab20Z3Z/PFH58hfKyy4NXDV4eN3XEKXRtzC?=
 =?us-ascii?Q?+VVTFAS3E1o5ksIleFKnIEznd3T8fM1aq54KsK15qgDCTAP4MqwXDSzr1Tsj?=
 =?us-ascii?Q?dII8nEItkWod3yk9OlUUDUJ/276PW//i+b53ysPPVm3QEDXsxOEQqkHW7a4s?=
 =?us-ascii?Q?6Tn58Lpj3rj47Ix9HEjWUpUs/btqCU/eMue9dPiT/iDa5eVmH3tyQOpLrPrO?=
 =?us-ascii?Q?J/syWs0oHLO1eVVC/G/FiDfu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea525ef2-cc8d-4e5d-6265-08d8e7ac2f3c
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 12:16:38.9606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2AhQNuzcwmOSyG5HH1UyVYytk3RHgv7E1yF5cceWcwUaDCrliWHxsmh4RCNNOcP1dE1admgRuKv3zh0OnFjRVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set tries to implement clocks management, and takes i.MX platform as an example.

---
ChangeLogs:
V1->V2:
	* change to pm runtime mechanism.
	* rename function: _enable() -> _config()
	* take MDIO bus into account, it needs clocks when interface
	is closed.
	* reverse Christmass tree.
V2->V3:
	* slightly simple the code according to Andrew's suggesstion
	and also add tag: Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Joakim Zhang (3):
  net: stmmac: add clocks management for gmac driver
  net: stmmac: add platform level clocks management
  net: stmmac: dwmac-imx: add platform level clocks management for i.MX

 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  60 ++++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  85 ++++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 111 ++++++++++++++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  24 +++-
 include/linux/stmmac.h                        |   1 +
 6 files changed, 221 insertions(+), 61 deletions(-)

-- 
2.17.1

