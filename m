Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228A7522168
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345091AbiEJQl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245207AbiEJQkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:40:37 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFAE55215
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 09:36:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVoyiI9ROXtu+pZscI990VgIpJMSEpKvSm0pdFRdbaGeNIf8ThdNRj5blP9olJCgah9dRzZZeBmdSEwLfs0mX9k+GkJ6EAXdV6SnQktckjib3Y7DcKdAWRCpuN14oKXDitsBOY1p2lO1D6skjXiwZxljEUYEMLPdcouKbB3or3b8kBX9FQg8yszpVTuYIXBE1wqyWVelunu+G7OtsZMOLOaOENERNM6XaD2BIMxh1hdIVgjS/gtnQ4IQeudhkzVPwogVDrqzmT9AVYVV5/1PEay/SSqaKnCTcm7uSw59HilyEe76pRhT6UXLFI+PloOoZsltPCl6nGjmuHqXxSF07g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoCvnvC1ugarnZJZwyADJHv2FLieaCDvSBD7ODdj1F4=;
 b=MugN16TWz0maJclgprrDvxerMUp/4ZOiW0oEfBtBuPlLLcwXDrPaz0ANWr7FPi27QSarmXbbQDUSMa6JTSyBcIvH5IWPwYwPW1iy1ctjpkH18dc9EVhr3N693QwHCbrwiHRCMc7rZgBPrXExFwiAVUBgkZ0tKRyt1+tE2x+MG3EPZsEk84+OXfA5gYI3Ysa0dYlfL+cftZzA/F8MmheoDywm+O+m5eNzGkutZR6VNLPkhUBGMsxdKzoV5LoJ8NHCT/Y2p1cCZR41giR8Z6edkUXnT8Ov0pqTa2OSL6wgJRfITHDO2EhaOYcucZu0aAtlz18ljHmynn+cBwbFQ9n8Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoCvnvC1ugarnZJZwyADJHv2FLieaCDvSBD7ODdj1F4=;
 b=OTcMXKP/wYxg3T755W63bUDaY7/KHRo/Oktf/FOhbSyqGiQzztbDT+UKMmTRbAycFxT35xuDHE7U6F91FMZssmv/hTEzLQy7ZuVVl7eP+3P7m/AD/ng6Y7p2dQx35pUmwFwK137+o+61Tlf78Ey/DwC4mwsXEWBhCg3tbYFuIE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9461.eurprd04.prod.outlook.com (2603:10a6:102:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 16:36:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:36:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 0/2] Count tc-taprio window drops in enetc driver
Date:   Tue, 10 May 2022 19:36:13 +0300
Message-Id: <20220510163615.6096-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0097.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::38) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5d95bae-b981-4312-6253-08da32a33965
X-MS-TrafficTypeDiagnostic: PA4PR04MB9461:EE_
X-Microsoft-Antispam-PRVS: <PA4PR04MB9461843D5A56AAE69C1508E1E0C99@PA4PR04MB9461.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: igO+qzUt1+B7Mete0fKmosdq5IFOInckOB1Mkfdhoh8hNs2caFy+qMAujpB3RZdc8Fsoq/nt9gfjFFFmNsqDEnkgGvXi20enavNIzk3rPAtw1COZ7V5ZXzZaQJfV4OaSL+jn2SaiKWo4BGKhWcin2KPwZJy7z4iG5GyjrVhAXIi5XR8rSFtIjh5tn/+IFlsAP8OYUr9/L2jZN6WGNfKbXmgQxj4eV/LgbFW64FOjGg0mq2sQiwOEF74nTI3bmWF3AYidQhTrpa4SVV8q+DolWVIGvTDA/qQAWUdhITybliRGU1Y8Rjv54aHgR4uGXWTCPbhl70E6B/MTEkbCF7r4W01wZ+JtWxH+e2kLgpfnJ4lZy4M1q9vDHFB8a7PB1Pd+vpe4vk01JcTBRLhL92U2R8SQMDNnPJLe3GGhnIJqBZFBMUzTbYF5RKtgI7IA9U81PdbRVWNYFkbYvMM08BHYI9/tu1Oh7dc13k/XRBcVFFe4gS9qyPphF2dpYaRlZ69NSMleR3bb0KUaI2KGaP8Jllfeu29PQp4jARCOwv9YW0CGR011QCiOBitpk1vqjFTqeMNk6FBaLvotdxvPXH2n0N3rTf9l+Ghkd5RKT5w/4hqGnraZO82UGsBu67J4oZDpc5u6pAP7KAdI4MbPvCtRSvN2Q2TjEyPzBQZcXpkILoeSsRE9ObCpQ7UmvxXwHVemDuFprGwqUlJffpJ6OsLyMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6666004)(6486002)(508600001)(66946007)(52116002)(8676002)(66556008)(8936002)(66476007)(6506007)(4326008)(44832011)(4744005)(5660300002)(38100700002)(38350700002)(316002)(6916009)(36756003)(1076003)(2616005)(83380400001)(54906003)(186003)(6512007)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SFVOxbT1jbe9xh73KcCCnb8PHiThhreZwh/L5uuVGawTrNG+LGs3iXLkAogl?=
 =?us-ascii?Q?+MiDHnTw4p6Bk5j5H0bSXcuPKLZaonQrgCNyFgv01P4S80gNVXFTMwhZjzYG?=
 =?us-ascii?Q?NMYHwHK8Enpb8tswIFZfLMUm9Rciv/L/ETOrjODNOYv2x36KQtY/oHXU6Dxy?=
 =?us-ascii?Q?v6VjcbpzeFlzPONjFFngsvsIt1RYcdFawh8Q0nw9xaHlHuCfkmArQclWePDr?=
 =?us-ascii?Q?8AT8qMkgLb4Hne2l5Wq3phlYM/xoeaPjdND+nMHLaPWhJG8aruveGt8/IJbm?=
 =?us-ascii?Q?JDOYMYP0DPPq4TgTOd71tCyI597Ew/adGUr54rTYFQ5XMPScRkrGASYiGYWh?=
 =?us-ascii?Q?ScfJB/kQkf1jDJ6P5S5rGWQrCXdSs4vXg8ZE0jvevFhAnQSnUn3ZzRS/3gPM?=
 =?us-ascii?Q?NaFv6sZqvF52PQQiqjIZpY4aoofSiP3xChRum7EgmQECi595FFe9/xQZOMGT?=
 =?us-ascii?Q?PwhMpvb6xBGY7B6LbumaSgmyc5206bTQWKHa5lcMYILdA3WAYlamAaBXNVmq?=
 =?us-ascii?Q?2+jg2UbzePtQ0SZ5pYsR3cJHvOmjO5BGO+eH11oJ71HFXdbDJNI2eqzwAn1y?=
 =?us-ascii?Q?edomrc0nuNWOlG7giUztFaqxGGWvFunuM27H3WFu2RwqLRSug2djJWaVTU7V?=
 =?us-ascii?Q?Oajz+v/GmGbhd5pgQj1d6HWytcWDAVWBpyUSrVeIXIymcaXEMLkXB6/xNPiZ?=
 =?us-ascii?Q?hb0zGDDj+n7aQUOLHuNzYs1IEZpiGJuDnVQAslNax6lsbBUpkdscBrS//fA/?=
 =?us-ascii?Q?AwrpHmlzX8TOlPzXJeX05x3MtYQwkG5WJncbekhLKwzS58zhxOE5OXSJJj2d?=
 =?us-ascii?Q?ANvQ2pmFOXn1oD9o+norx7VmlL5hmklFpcUsaWY3fS9ddcQRLxl9paCzkYIJ?=
 =?us-ascii?Q?kQ+c9C4CFw1b+mHx80h1UJVkyZ2MTOYz5kqcGa8BZxUjRxuwofjZbEr4qBXp?=
 =?us-ascii?Q?tNOyrwnCmmAcc4nNZb3vahvzDCC99aDAzAfbKKWDenW3fRYGQn77QuD+3oCN?=
 =?us-ascii?Q?6KGNPyMtBKStnduo/yxNNq0KWL7i1Bat0ERAVDkDmxYXmt78OI4ZCxalEDFy?=
 =?us-ascii?Q?3dy0fkDiwC5cIoDABjgSj3htHyHguADZVxTylQIbF0EE7omCuUNxRRDzRUuZ?=
 =?us-ascii?Q?TNezUr9Qax47Q2PUGD7zcokyFrfCwlXmg6248Jv+ecX745W+TqEbBWkoZID3?=
 =?us-ascii?Q?GOBn6fu/urFNEcR4stgw5/Jtk0TLdgsnpS8smlU3NmVEptKeBsfKfzSDoOFO?=
 =?us-ascii?Q?gei6d64tHf8azhi9nQpZiceNs0ZYs0EGIeSyHZHxumOotUs5f6Ox7CaVUowE?=
 =?us-ascii?Q?BLAdIe2XNk9Id4TLV9J0bPIJThQf2b6xviUUDBti1JFZaktD68San60FdjPh?=
 =?us-ascii?Q?OwIyy6bYtXz1i7Cez2RtEjUF+HWWgb997F+9odfJkmTmgW4oK15Q7+th+iNP?=
 =?us-ascii?Q?6+kf1qIMEIZJ/3RUQ+RBW2CV88eDL8t15JzBhrdfc99j5CG8sOUHD3l0/+Kg?=
 =?us-ascii?Q?WtYruD3fN/AnGRC9YF6cVamqEdp9T1vXXRbwEUGTvFJDM4HwrdxEfPSV0rTp?=
 =?us-ascii?Q?511ovNycRSNj5HWsm8uSvDieuOT3ELLN3FgC8EaMKzDKiVuwCMRe7anQl5XT?=
 =?us-ascii?Q?/GJ8P2XRZEMeTxOkL56Dyjr6F4en/GNsVJvfiRcVfFgegvLvbbqdEAuKqvFX?=
 =?us-ascii?Q?w8lcDZIHcOo2Kaq2w24QxTiNn52vwa1j0xGCFbs5uZxGXvyrrf6xGZ5bAGW+?=
 =?us-ascii?Q?WUnfp59ngUCfvPo8AiRg306nYaczOuA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d95bae-b981-4312-6253-08da32a33965
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:36:25.2693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9VNm3pw//SEz2vWy7BcEgTeRB5aZMJI515NJNy3XM26WuJJ/p9hm5GDvpzC6IiFtHEv+Va+ir74ujjuMVE+zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9461
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes a patch from Po Liu (no longer with NXP) which
counts frames dropped by the tc-taprio offload in ethtool -S and in
ndo_get_stats64. It also contains a preparation patch from myself.

Po Liu (1):
  net: enetc: count the tc-taprio window drops

Vladimir Oltean (1):
  net: enetc: manage ENETC_F_QBV in priv->active_offloads only when
    enabled

 drivers/net/ethernet/freescale/enetc/enetc.c        | 13 +++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h        |  2 ++
 .../net/ethernet/freescale/enetc/enetc_ethtool.c    |  2 ++
 drivers/net/ethernet/freescale/enetc/enetc_hw.h     |  1 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c     |  6 ++----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c    |  6 ++++++
 6 files changed, 24 insertions(+), 6 deletions(-)

-- 
2.25.1

