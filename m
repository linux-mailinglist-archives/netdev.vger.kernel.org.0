Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D3863A53F
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiK1Jj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiK1Jj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:39:57 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2121.outbound.protection.outlook.com [40.107.6.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D60D5FB5;
        Mon, 28 Nov 2022 01:39:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkkveLrPcOIJdtWGNeJUJQfB1uZMKTH/S20MAFmzAQsbv51pgFM7ePp1CNNQX10DHvtZpDc654Dz+FxZ9IeeX31gYhyTQrYtpxpOM+999IZRJx1f0d+LaJteOh5EYnHusu4R8FIFLH0QLkEZNY3knVpfn4baAl3LFM2EPXkCD7WDN9skMZqdYnwJptCFbzvGq0Q0CfeXbQE6pdlHioMESnFfBei6OVDCOPJ0bKQ5w5dUVcTdxWddKaF1qvjUzsJP30IIE+DI17vdP58Q3vgRx3UclRkuDdvjDDGxyM1JgOBAG/83KP16KjDoobymatI0aip6b5CQh+Q3oZyD/ZHKzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GluQEbU/av3q4h2demcIKUkq0KP63uEi/8uX973dtbo=;
 b=kZFmQaSblDn0z0icW+N5oZ2ZcsohyKfjaiiDyZaMx47bqlPICtpw3TByoMgqFPP/SHitRB1WK8hO3n6jZGNpriX6VOHiF0CKL/cOYT53RgMGua3GMd4dAVqcOl4xcE+Gt2Lyt2+Euwgww2FPf7cQkbKevNR2Ytic2l9vFarKsQaGgiSEZV8UY6xClfDCuquhmigVaELj20enHbdRXPiRGcWS7C1sQSf3uEpz9elKFIKZi5ZkbE1UWcGDwlbLA30zhgjuuoSkj6q8Nto9yKYTpG+/vR8D5yVnCKUI1r8FlZPdWoSOp6mlKSBPE1+//9C6ujkNOhpE0/Cml27gafkfAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GluQEbU/av3q4h2demcIKUkq0KP63uEi/8uX973dtbo=;
 b=LNrEuf3HONpExvG+WvlmEld/liPgtBCeu8Xz2KBi0xoYd+Nq4p4BHjWfT8Yz/iH65Lu+mSEbvj1sDHsuvj5xGMRKjt+M9ckS+YtAng8irwKRjsJlTTMVC23gI9qk9VeEhr9ozzhru8eQRlxHS8f9yK+esy8PulEhIYTyJwabrfM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:38::26)
 by DBAP190MB0854.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:1b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:39:54 +0000
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::5912:e2b4:985e:265a]) by VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::5912:e2b4:985e:265a%3]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 09:39:54 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH v2] MAINTAINERS: Update maintainer for Marvell Prestera Ethernet Switch driver
Date:   Mon, 28 Nov 2022 11:39:34 +0200
Message-Id: <20221128093934.1631570-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0185.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::18) To VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:38::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1P190MB0317:EE_|DBAP190MB0854:EE_
X-MS-Office365-Filtering-Correlation-Id: 13aa830c-794d-4c99-fbc4-08dad12480eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BR8gQkbfmeUsRpcna79OAxh3kyYJ6qhSTC30SrfvPzRnMLKbKAokG+HBqYtDClM67qOeHvCNZeZ/93SRyTpqV9+UZA+/LZQh72xyIHZVs8Vd0jSX6QXtYTiZOiCB/lXleBAT8tLuelQIAnBEubbzqu3vc+AF1HiaQhJ/EWGFMumE1iuyZF9HrVE7nYswWDOuVb4JP8oBmfAorsRMjXIWzAtkd1YetT5QC/a2YUzuTtlwgkaj7fXqic4nDG7hst1XWuew2H6B1RkHTo6AhnqdjnlhoRo9Bw/jMOe1NGKh7qoQgjWUx0guF1MfKprnvZ5qeSKNSeZs/6LlW/lsn8Af3qptpKj43i55WSqGH4kkTrcN7R8s6Gj+qLjz93J5vkdeMREeLukdtBZAJf3P3AUOtfiCmR1xdr8zVHZp669YOOS/nMNIv3u2DMiGbQ1W4n5QpTkZsMF/b//57fMQmuyU6mHZofbJ90iXVlC26EkiUuwH5AIROyFOlMal9fAQkaB7ZBrT9ahvBEk5oYfrRdte1W8OveZgmSY1dLb0TMpbkdjvEbsrHYUqZQxKk1jKOyIP3clqEG/Si6hS6v5OCiU1OZOBWTN6I/Lc3fY1oZZgINtqOQSTLsBzyORNqXJ7cT4U5kThBtt11NPMBZTcQv14uZvfRW1FDJL0zbHsq58W9DUUv0tGz9/RlfGOvs2aVJqocLSsqX2d9FYqCHILcM9J7XOn5tNfOf0181f5E60xkG0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0317.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39830400003)(376002)(346002)(136003)(451199015)(966005)(107886003)(6506007)(6486002)(6666004)(83380400001)(86362001)(478600001)(52116002)(26005)(110136005)(6512007)(316002)(54906003)(2616005)(41300700001)(4744005)(5660300002)(44832011)(38350700002)(2906002)(38100700002)(4326008)(8676002)(15650500001)(186003)(1076003)(8936002)(66946007)(66556008)(66476007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AMLZCRVyR918ZHJ1KoHOAtDIEPXXtLEE4sSq/JOn1DZemZfZ9jnrvMsZV4c7?=
 =?us-ascii?Q?BTDt9Oc7PI4ixbMmbvfCcGx1cpWIW8ikS168QW/vpScM8g3wVZA1IHSHxCsF?=
 =?us-ascii?Q?MIjR1nBgDZgd3HQoMIprCTpUa7cKOL9qtoQpFxqOWKa+BpvEtCYQUWL9bNAh?=
 =?us-ascii?Q?i18x1SYYIxgHU/X6m3XwIFBDvOqx2wfzJDROtxKV+YTmbE8FGsRJ2kqGosHl?=
 =?us-ascii?Q?Bt7oRt6DXajbq/T6i4UID37J7S0irP2CYJGQLxzLN4r6kYBUFnaAkRPQInrI?=
 =?us-ascii?Q?qy3aZTdul3rnZV2EhJIXsUKd1kjmNxze22/ocbXdU2lDVzC827+KW+N4sQGe?=
 =?us-ascii?Q?iAPqLM5BqjJAxncOTUw1yaYN4Y2oz/o4g6kLEQrUsvVXfUf9UHY79GP1dXiD?=
 =?us-ascii?Q?STyLR031OHOp5INMdUqdNPfVGjzUXenP5fcXziCQrQR/SI2qqpUrUtpxkKx9?=
 =?us-ascii?Q?YRPSLkh7GW0asXcdscm4g2iJri1rAau7ZIefp5rzdo425qo2ibIH1LNKghfk?=
 =?us-ascii?Q?TE+ab50h7hJtlE8ky5dNv4WSJW6yyk3OuA2s0cT6c1GqncPMq/ug8R4LUrAj?=
 =?us-ascii?Q?owqhcBsBNXQA5ByLn3iIULOOl+Ww8jmGKv7N8QpvRGDR/5hbp/yRjmX9xtg2?=
 =?us-ascii?Q?lAIXKdsW6X3zd8xSVUfEFKg9EQSzxHHhT+yex1pDsVUpV8N0t5FAuOROze2z?=
 =?us-ascii?Q?8BJ5ib6Mr6UZu5U7mfmmb+kD5tbNIpiXiBAd5wll5fY7tUFoCpakas782W5P?=
 =?us-ascii?Q?vwdD9/+mSXjWCbhuVAruEWE0X7wOcOfZP6jZVcveN/ao+ArjrKQv/GJU1Iy+?=
 =?us-ascii?Q?+ysTz0Iu2WZGOKVFH0fma3NQ0M3nXJp8Vaw31KBMuT29WaF1VaItZ09+S9rQ?=
 =?us-ascii?Q?Nd0+lezo73htZQ1uao5+fb/WttnHdSvdUH2FU9rZz6tGVVcmB97oGRsm2chf?=
 =?us-ascii?Q?fYbgn5bNPU+ok411JvG4du2zewN7gqIaUqqEPkZvIHPeC4ZhbuuWhkpNXoKY?=
 =?us-ascii?Q?ghQtLpSq7eUwN5JdqMThgVcOmW82Em/QQFJjwk5sEm7U2UV+7ZjFuzGYpLEC?=
 =?us-ascii?Q?tgI3SwLE4KGpRNJ9/idQawAlUQ+hR08eKOMS8q+Tpf3uxZWxV7RZkVmtK0QD?=
 =?us-ascii?Q?YXGm3+EzHmhgDTc9Yyey9wt5klu63D0auwJ/Py27OCKVzRQ7/HgKQIKv7Yb3?=
 =?us-ascii?Q?pz62cl5RO4JmlI8jwMKzqayhHfaWZnBcflF1ojqIAmQdNqlvgXFXXey2X/hz?=
 =?us-ascii?Q?gOSs4iL04KA+7FaMPH0v1rI7shLEcMq9TV2XkAIAXkCNO1p9z8RQ3llCvFD2?=
 =?us-ascii?Q?Jjx37VGkSrsvtFbskNDwIX7uha+ZVIf2mqSQb56nTTH3wekhWGCnRBGNu5Fj?=
 =?us-ascii?Q?7iA4FnHeNRq502uw7AOWnX31YfM95CTGKYovbXZnfJdp6c8JawQHZFIE3LX8?=
 =?us-ascii?Q?/AH2cK6ut3MtwOfThEm0NSxOb4PfP6cM/kE4Py4EvwoWiql2Ot+SledeH2P/?=
 =?us-ascii?Q?M0AVGsTT2WYQGeXEglq+Xhk/hGuS0+mmYypZCDJjEjIE84xtTwFIl7knzGqV?=
 =?us-ascii?Q?NkwP0zOOK6NQnk/usFtvygyFQqQ4f5Oyf81Q9f53XJ18WM6H+tOdIrBUTID8?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 13aa830c-794d-4c99-fbc4-08dad12480eb
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:39:53.9885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WAEVVzXzMCg5sZ6Uat80uplMEHTeY/1FmvPrbV+MibiyqxY0GrkMIBHVvl1TmU04XMC+0y1/QFM4ZpVodzRhC4FRbAko8LqkJZt0QABZ65w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAP190MB0854
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taras Chornyi <tchornyi@marvell.com>

Add Elad Nachman as maintainer for Marvell Prestera Ethernet Switch driver.

Change Taras Chornyi mailbox to plvision.

Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61fe86968111..a2bae5fa66f2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12366,7 +12366,8 @@ F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 
 MARVELL PRESTERA ETHERNET SWITCH DRIVER
-M:	Taras Chornyi <tchornyi@marvell.com>
+M:	Taras Chornyi <taras.chornyi@plvision.eu>
+M:	Elad Nachman <enachman@marvell.com>
 S:	Supported
 W:	https://github.com/Marvell-switching/switchdev-prestera
 F:	drivers/net/ethernet/marvell/prestera/
-- 
2.25.1

