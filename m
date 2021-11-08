Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2530A449D19
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbhKHUbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:31:55 -0500
Received: from mail-eopbgr00068.outbound.protection.outlook.com ([40.107.0.68]:12675
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239497AbhKHUby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 15:31:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiyoQTLrI42gNw0/lBlOCzo10d3+AXjNGKKyxzfjest33wqigGJyBuB9klqNYvsBsCZwgIm7+tn7f9g3CBAbqNfT5B7ylqh8WC6Arc64pmulindbi2N/Nl/Qe2TVJNxDU12yhVZJcvcH0urIkWI7Kw0HRhxjYi7GdFvhhGoM1A5t76kZzwOX7u8cdOPcxldUzCpaBaMxy/+SwTZiFKWvUlHMWS48EBtsr5tVtqfUs/LjBtiurmu5lwbo4Uu/yh26oZX4CtgGbJ3MUwkdlXq4bYvxcrnf8eSm1yrvlG0k4+8WAdGy+d+2AfaG7l/ZY8OKA5FvuLOl9KbXMKHBVf8vKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVsTRZq9WkcssXhpGm5Iw4+ekDFi1xfYdIEm9F1nyk8=;
 b=N36kcf9VIKhEQ8UJDWJWl1JGGZB3HZul1wrn9Bb4yCyNNqgJd3E8qAr3FE7Mwg68Rysn9JuuNuUfMbB2garMrWrC0evcP/YCMg8w6TsyhObgkCTmn5uoX7O3ewhayjzrhrLc6NG+/G1K7sO1kjuRxYATVNEiqG3EkAiyk5tAK2X3qZpRpZFXdCSA4ufgPkCio6GdTfHfyqOro4KQndz90KYfEm3llPa7He/zdVDEtTFMZ7h2RTWhWCCVHnuDUGtRrF03/DZVRRj9hbpLMjRGwcALwaY4K/+Gli+GFk3NHrJ6RqHF314quFifumuDsHEODszsOSsCqGnksfrKvnVGlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVsTRZq9WkcssXhpGm5Iw4+ekDFi1xfYdIEm9F1nyk8=;
 b=sX+9pLiFTnTJ0+uwyHEgcyzGSrLDc2AsuWouU6IILs/F0TrMshp5fOXduKR9nk1s7lHTAL+LcJKXM3wVCUbSZzbPt2qLyi7VGZ+nivLh6+dMA+4cFObxxjLugdjxbw85+BPbpycq23zzdJJkNgjsD9Sk8rvFoTxMhmqTroAUHcQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Mon, 8 Nov
 2021 20:29:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 20:29:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net] net: stmmac: allow a tc-taprio base-time of zero
Date:   Mon,  8 Nov 2021 22:28:54 +0200
Message-Id: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0001.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.175.102) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Mon, 8 Nov 2021 20:29:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d13b47b1-2325-4b33-ffc4-08d9a2f66986
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-Microsoft-Antispam-PRVS: <VI1PR04MB569383A7CB9461A192D9B8D3E0919@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XX9qkU5Dkxs219FA4Pi2vrlwA6QyLcE0hsWUMJUefUnJ81preKqQ1qFv+peltpmoqh1FC3oez6oS0LvqGT/A51p/P5qJMRV/KMmJvD3nVmEOXNp2wpKSP22VuzO82SZZucjP2byi68qM4zoaqan+WCS7vicy2/Vs4uiyLBjzv44Td/tneTptKWxQn8c5sJdjRalnGnLkKRh38nx+0lyUFpVpNoK/1MHj0LeE6dant6ERYJvy6GSf4IcSAjTjhzYgyZ2YF8xudSmPb+Zzmqtz35D9o8KYePiWU6wjuJvFsdxabGBh1XWj79OSAD5KOfidR6rYle3tzliY7Unu5cYvBOaQKhEU6YyEVQFgd1/1QqTPwVzQqfnjAJyhbPSfzOw/L0YEdYqQQm967M9rr7ffUBzXSwOe8FbOfiRUjsMgvzWT7Ae3/DtIBHINbgJPI2njnGeHDI3/LCIrb0Fo1VgGRdnA6gO5u87qSdnB6gAVrknsueGbwDbPsDBsgIG+3THCDssrwRkmOzKFLnJa1FJRIXBG+gEi9s/Hugo8FdXE0bjUj+OGMRnfrQD4Wr0cb1eGNMbs+BfMI5UYC6q2QRDoEO6qEgBjkpqMbvmQbjxtb0Rkz1tHGzCwfyH+i67/jSlbZXMYD1u3OU9Nnyn6VRiOeZg1rbju8qR0/rVcYLs3cp6D7uFLO8DDWgB7nN7HdX/pCqCi/C3+DCHg7sc/j1lQEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(4326008)(6506007)(38100700002)(38350700002)(83380400001)(6916009)(186003)(316002)(7416002)(8936002)(54906003)(1076003)(8676002)(6666004)(956004)(2616005)(36756003)(6512007)(44832011)(66476007)(508600001)(6486002)(66946007)(52116002)(66556008)(2906002)(26005)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CxbTtRigIS8qkWmBSLUUDMFoHfGosTujEtXP81zy50CtgWswvWXKRpZr7woT?=
 =?us-ascii?Q?F+EPVnjptdRT4nYlZDv2jMlghm0Fx4VTLfmntnjY8hFx4hdaYHgKUxKQCpnm?=
 =?us-ascii?Q?xb+O8AbFUMl6wH0OQCmYtTn8zpSVC7f9x88df0vb+W+gDL5oTiFYN+kz0Yv9?=
 =?us-ascii?Q?/+FnfGQdKN/YQTVu7PyQzi/7n8DruSPzkeZ4J32JRsNIhtUw/jr5sQxH+tXv?=
 =?us-ascii?Q?dmtHMvLFMk0F7wJsp+tYuml+ccIaKpucayMN8HhbnCIu80mYyTbNjMhiszXJ?=
 =?us-ascii?Q?uTBQh+Vhue7opM40ZQeJjHnsyguVMFfYu4sVk4ZMxMd0FXCARY8vpeSpqYRC?=
 =?us-ascii?Q?XmQ4IuqQgDQtB/o/CwCGvtdyiflzsl3vXVPh1RBXes5P2nZLSaD9MJep5eyx?=
 =?us-ascii?Q?5rNhJk3SNUDN/cgve7Yf9GP9J11YbcNfeNYvy3H8R5pBU/yjOjyLKdZXuBQQ?=
 =?us-ascii?Q?1XMAk7jRZQCHK/rK5BZ3XI6PH4MdsIyaNHdvI0G4rkXcsG+mDePwIvhY7asj?=
 =?us-ascii?Q?GDmJBobqJP+hL4es8/fazbc36JVg/iEk3Tojd2B7AloQZML704YlLacxRpJ9?=
 =?us-ascii?Q?SPi93ZzyMjHuMLjss7xdlvxo0Acx+Ocic99xO2W6Q5FKXp5+XWpTZXmmkIf0?=
 =?us-ascii?Q?mrhzLSIROa7Id0NLyXkchjeNgA6juJ5dSGQFHtrennkwaQloAcaOQIRYL2CU?=
 =?us-ascii?Q?rQ7N/OTbpD4R9GSEpJsA3ZFRBS/P6b8CvJcpyw7MwLFZxXqg7tIczy/nqryk?=
 =?us-ascii?Q?JIARJ4ou39plHd2i7rLcsqBtExsvcglGQE6t56/REinXAf+sd3Zp9hEss5KA?=
 =?us-ascii?Q?ZVw1z/ZQmj/N1bdw92KO5WEieZEdPSTL5X/GMUv70NJ9uqpwrOdXzBeBDsCT?=
 =?us-ascii?Q?TKN+HnLYJYxWSXBGQzIftllPnwpEHr+Ua/sAAlyDxZK7bQ9WAzBkRH14F/eW?=
 =?us-ascii?Q?Xf1a+V5Zp7H90ISC80jemWLoYDTaE4E7pEPQti0G6M8WU1pcHu/OhdxvSyJH?=
 =?us-ascii?Q?9hZPz4Wh+DGsOdStjBN9fnqwrf74DTVWjn97WHItsEedM+dBrQAaWk2juunv?=
 =?us-ascii?Q?xtuk52kEDBZQpKQTLkNpZE5x2rKhY+tqCM/QvV/KLyNRNUj5sN38oOXPZ46t?=
 =?us-ascii?Q?wBOPoD1xPZA9KXOW7hoPN2cpLccL4QIJ9szfuJGIbzMdyMNOtGIGXuBJSHtN?=
 =?us-ascii?Q?BlbedbPZR2rhkniVs9YqwvmfxWDb2L9pQqWZLGJmkXfjc6zReXFuMw1ERJUU?=
 =?us-ascii?Q?/r2P0LKZ4WtP0O6giYwe1a8N+qEbUtoqdyetZiZCnN5WVX5uY6OPL2ehtXfn?=
 =?us-ascii?Q?8weAkP03ZWQh3kKrbJOpPobSa5b09l4QqqDFfNbGXUN4ilffxih6vZTcddBb?=
 =?us-ascii?Q?f6K7kk0AJZxyiG12X0DL6pOlrKatWXZCUxSwaeBcyejODlRYcpheRmF5lN08?=
 =?us-ascii?Q?KbSZOcbUkOWjpeXM3HH7sZCxJuN+jNsG+u5XQYwaZjQaUodeoAGenn0B84ny?=
 =?us-ascii?Q?QnfE8uXQ488Gf/9tAeTxpg+juW6l984gpXyCSJVnvyoQiUvWj3GujpVSpVYU?=
 =?us-ascii?Q?2dtOayhn7gjBiK+Hdr3UF/v6H9KrCCngREen52Mnl09wUxPeAt0U+hnTQOrJ?=
 =?us-ascii?Q?o1ZI/AZ3fKSDa7XQx3+GkIs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13b47b1-2325-4b33-ffc4-08d9a2f66986
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 20:29:06.8084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7rKpU12JXgVpgvPJ+hKBhyZLEydHdr1ro+ZKRs+2faySTdM3RlL2M0OriSx27iZVI5Zssk5nRceVFf3SEc4h8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
base_time is in the past") allowed some base time values in the past,
but apparently not all, the base-time value of 0 (Jan 1st 1970) is still
explicitly denied by the driver.

Remove the bogus check.

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 8160087ee92f..1c4ea0b1b845 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -786,8 +786,6 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 		goto disable;
 	if (qopt->num_entries >= dep)
 		return -EINVAL;
-	if (!qopt->base_time)
-		return -ERANGE;
 	if (!qopt->cycle_time)
 		return -ERANGE;
 
-- 
2.25.1

