Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6667C485C23
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245317AbiAEXLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:11:34 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:32794
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245310AbiAEXLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 18:11:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fY7jqNUAfm1D2iz74LwlxeCLpCtCY+PKkeKHdmgzr4Q1vU0crk5LhSbfO7m8+gwGe4IRtMtKmLPsEH75gTSHQBF/hRPmqXtm6G9HfrDFsPbB0mSDZp+hrhuX6EAs283TZH2HurTTuEABc8CgoWw25R2MO2J7NaKDSXQ8Hxz+ucMpXSi5/pf+pMeNeEQp0IGYyNqL7vgsahVxDL8H8MS7EiB6TKzddfUqj96yBukyUOgsqe7LNXh0s6UhbcXyY2mJHTKhkoeHvxIu7WQOX+UkAPtkXUxIeMEPlppCKNz+fLSlWmUvyhIdm+3mvpsRc/BjQmPl9dnnSo4aQp7+yEQK5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfzWkBPuJrJdZcx5BpTWPfHkYp79SJT1P7X193LG8bE=;
 b=e63AE5uFVZuP+STna0PZUfo+xGHNZZt3de+fdGmMat/FpMNDSbvSN+H/j0fFQxdGOa4LGTgWtDofengHCJhntWgSAz4UNcKwBIOxDqPw5iehMtCKtHGHhk9OywdH2dt7tMyXRBZxgZdGmJ2xuz1jroL7hGoeQWe3dD/k/BA3MT+Dr9q4LQDFG9ubBkxmZQ6WfxbN8X87xmD6L8elekTER7VOhQd8c1b6QoUC2s74TXQUEXShMK0v9+0ZtG/BCJYp1nHoMn6asWwXUetNzIixchC5D5Rs4jIbgoEDcxbVAezTYUFerBgzud/37lEaz8nAKP+evcYqTv9r2BmDTUP1HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfzWkBPuJrJdZcx5BpTWPfHkYp79SJT1P7X193LG8bE=;
 b=PR15uDFGa/mn0+H1KJYXJ/c+v9jh5gK/YRe2ITjf5GWPoLSMtf1cnfKsUpo0U9IpNdTkPhQ30xj0x8qDwxoKKphtoR9DstkF8iu/l5/hSb3pNsAzlKa979blyf9fC0xC7RDUFuKGzrDmAY42Se8/C55Q1pTNbDwFjfRNJtygjnQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 23:11:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 23:11:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 0/6] DSA initialization cleanups
Date:   Thu,  6 Jan 2022 01:11:11 +0200
Message-Id: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0081.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48cb28a4-3df7-4f6f-2a6e-08d9d0a0b4c3
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB30692DF87F59F8E451003B91E04B9@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5C3pVxq788OHoiJxKz6k13IVsabG2ihJnncX0vSig7xcTuK6RHrFd9BWNyl4/hMCtW2ivXiSSoQG1Lk/OskmkgcaBdWyG5Q7LNmTSOzMMLupnjI8RpqJweF6Lcs5puHljM4C+HDrsSi9eBzrDqepVEvAHkJnzJsRa6rWfAyBdjGrzkLNl9bPSu7gL26ERarYT8Ve9+WGBaHH0qW9zhC0XoEYLQhZY4btnpiT7l97QbMTW/wpcV7nMSuYVeQ7p6DVljSOvLc1WdDgB8PzlianOW+71xNRrmP4sTKdLsorNnTXdM/67P6SU3pbul2r0N7S8G2SeEP9tEa95ewGsV1dOua/RkTVDImgQSCZcazOovj1JkwPQ6q2XNmIfqYzIlMGuRS6P5l3Famkzafxs53LUI4K9mhRj9nlubfUqTAs7wRjKYvQfz65F9ZoYYAvb107Xk4Yl+HXpr0f6Wq+h//XTYc0hZ0ALn7seg85NdR4sNhdedg6UfS/ZQiMxnZEgcU1NtLb3/1RmGgl/u9sspKNbnzJPlspJkSPG2JMv+lS4HrfSwu43PwuPB542NCK1AwBorBpCa4FpBlvBcP7EytaFDz8foW1/RhbjyRzqEOI+9NTb4FB5FNi+Q36AMawdGgZ/NTsc01B58dIAeLzfGhKZWgDkx/5vHxRfROIZeSgwIZ4Hx9v+jNR8kxXq5YS6Vfxh542siLlL3dJWnbSEk9JziSJUc7Fjreen+cPPfuRUx8Y4qBIfn4kzKiS7ZU3+Nmac9Q94SMMzV2K2fEsxHoQBNJp8/Vl+n4Ixd4R6GJOOs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(66476007)(66556008)(66946007)(36756003)(4744005)(1076003)(38350700002)(38100700002)(966005)(54906003)(508600001)(6486002)(6916009)(8676002)(4326008)(6512007)(316002)(2616005)(2906002)(6666004)(44832011)(6506007)(52116002)(8936002)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pJUL6nBch84MCqc5d8D2G7JG03y5Kby+DsC9dJ+kPnhdLZwmUvv/UcsoIw7C?=
 =?us-ascii?Q?AuTBftNQbcfelJbic65/BxK4cjn0WcKq6rtAZ5tncgauy3sbcD19XTguk8qR?=
 =?us-ascii?Q?bc8vcoeZw4L1P/JbwO1HPPh1I4PeEOWIsV7gNIeZOLvfgVIjEOkqkzM5ovw5?=
 =?us-ascii?Q?6yvnBJptuhI4PQ/yI767QfNnq2TMKoqzi5Ouhi0nefjCNd8Q5OzvQRrjvaUn?=
 =?us-ascii?Q?dxql1OWEVvRDWKl4JvLYKHNFoM0kE7U7Ju2s3bzh0EgHrYt8NT0SNGg4uPF2?=
 =?us-ascii?Q?6Dq7drHZELPKAUJ9RUGlB4IyUIYqM3Njs1pkmzsxtdGeIKP95EtLv4hEkHR4?=
 =?us-ascii?Q?lK5aGU7M2inLroJs1i2QDB0I0UGxijiHEjBgnYVllx03Lghz6ky7rYhdOsMj?=
 =?us-ascii?Q?GP+q/eGHsudX/h3d8X6N8xLs4h/M74p0TzrHhqoy3fx+FF4qkZ50YzcPt0mx?=
 =?us-ascii?Q?H7YfOSODXQ4JspHg6vZG2hc7CjusFE3Y6H/UtGPBGD+PAsKhEi8/hKOKGgYo?=
 =?us-ascii?Q?ny7yusEYG31JxQRDNtK23N8qi2qL7up2hDu3eH51+UFP7146LKJm+/MPtkFP?=
 =?us-ascii?Q?ISOKyBz6P/1C+IOKToTxhLl2rbHZmZ8FQrcmG0nMRSHDuPG3VtuR25ImoA+o?=
 =?us-ascii?Q?8wRXbVy580s8TGlqHOW2nYeL/j/QelGIH0Xlzh0FbmJ8yH1FOR0mU13bx/HB?=
 =?us-ascii?Q?PffnynTz34QxLwyWybwNpPxL2G9mcczew8nF1FpWlKmIvHKRjbGQzUemb3Zd?=
 =?us-ascii?Q?yvgalY8huDkO6enbKlQ799uo0DuBNtzaTDpq4pHXtB0c91WnH+7Vx/JIubOu?=
 =?us-ascii?Q?3J5bwMscKbtvs+oXB5K7okk1v1WnARVsW5/THLWLgQzuTahJR4ux0GS5MASN?=
 =?us-ascii?Q?Uf832e0hZFhisa3kVYRX0ONgEPBUWRJ8Rb694HYabmyoxGZK/UJSOas25vr2?=
 =?us-ascii?Q?IPCZInfkyySzlbBnUDj90Ea892nxGQFmjDYKmnWg6rW2YBAKA1UGubeDIQn6?=
 =?us-ascii?Q?WnttOphWoBW8n/wPlJl9we18UVCf6n6ccXMN4IaeXvmVgmeBlY4OgibJBU0v?=
 =?us-ascii?Q?l43oD8xbahiAhsXHfe6vXUoJDUs55N/Tm9fri2UD+0I+F/Kp4OWebFY+Pcv9?=
 =?us-ascii?Q?E55QPdhRnNq+sXsBdqopyDEoDYTsqe9ljI63+Qoe6ibldfEc0xl5JGrKfNoU?=
 =?us-ascii?Q?FgY0NjFeXaurtLkK1tgoLU72XJ/JcFeZbJXJ80+w/woCeAynhakGZG9lAU58?=
 =?us-ascii?Q?aVwCKqMaD3MmSrpxCqrvzG+qX2j4ZG+Z5eCnfH5y7+XLfaBMti7HJ5iUOSLG?=
 =?us-ascii?Q?EqldziR8zAgSvPR/SqZhVz/dFw7ZaWc0rhEUquTVz3kBkM0ZModoUxWXDdg1?=
 =?us-ascii?Q?x7ce8nAuUBY6mfvVvjy3zFiY8LIh/IlNVetBPmvBFAY2dW8CPQHUoZlbe9y1?=
 =?us-ascii?Q?RcX0ap9zayhrXmx8L5ZPWXuu2cyLK/W1j3SPbmprE6NV/ONkgnWZEm0odKIZ?=
 =?us-ascii?Q?XppzN/ohJsw5c3pJCVN+pdqmoCZIZU5rJ8HLiNV0jRZd2AxF5fBBSTnoZFHr?=
 =?us-ascii?Q?MjJGeKer2OrcatBHmlKNfOHGjYPvMnyODEsZiWVWv7ixv2glprBivrxMpa/C?=
 =?us-ascii?Q?eickQEMz0SLwP73WfyNpRSY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48cb28a4-3df7-4f6f-2a6e-08d9d0a0b4c3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 23:11:29.8013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyxFpZlmYAeC4pUjIJZBzgtdXMoJK3vaz1/pZp3ByXozttAF3yPtTaZtkKw6VE4B99qflWWOf2UM27ucAV1fwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches contain miscellaneous work that makes the DSA init code
path symmetric with the teardown path, and some additional patches
carried by Ansuel Smith for his register access over Ethernet work, but
those patches can be applied as-is too.
https://patchwork.kernel.org/project/netdevbpf/patch/20211214224409.5770-3-ansuelsmth@gmail.com/

Vladimir Oltean (6):
  net: dsa: reorder PHY initialization with MTU setup in slave.c
  net: dsa: merge rtnl_lock sections in dsa_slave_create
  net: dsa: stop updating master MTU from master.c
  net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
  net: dsa: first set up shared ports, then non-shared ports
  net: dsa: setup master before ports

 net/dsa/dsa2.c   | 69 ++++++++++++++++++++++++++++++++++++------------
 net/dsa/master.c | 29 +++-----------------
 net/dsa/slave.c  | 12 ++++-----
 3 files changed, 60 insertions(+), 50 deletions(-)

-- 
2.25.1

