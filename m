Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29865B3680
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiIILiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 07:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiIILiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 07:38:14 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA211377A8;
        Fri,  9 Sep 2022 04:38:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHfscxIs8uveC4JJ7R3etvX5fxFB8Wm0ErozAangdl6i7iySjK7YTtU/glg/RmjD+yREfQiyy1hLj0welMa5CjtQhnsW6h8zCGDAO01FhE2n/6LeWWbQByOxYshciCL245qNOekLiO9u/66FMAGzhjRbhx7jh9IaUbecAOZEQAjaVdiHjlYVZkyuJyYtdA7z2kEZFmPpAZcH2VL7RDToLOV5diySrSfXLkxb/ow+ZQyqV8mFvtxPlpUoPrm4UT1sgoSr5xgpsYD0aNgHFE+L71VIr9Ry5fPlRr29c8OSAn2aq5aUJdKDFOmGPcshl6OJZvLe6JhUlmgF3YgpYqpoIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQVu8Ge8RRL0j1nB9+ZeojwEOS5Lml1IG2c043Uy1W0=;
 b=kMwpR+kSRAv/FAr2/sZOWVwWqyRpThMvVR2qoVM7LbjpF4nfJNamC0hZ0QPcYgKcwV+Qmib1k/xm36CRxRcFWILNJqofUwnnLg4l9rDKu1gHMIXox32U1qoTobJE0MmiOV5gyAihyT3f+2TGNBFr+8NZ7FArUdryIhjcpzIaGzUaV9KjoByaAQgsQGNFNgWpJRKA53OfCYZOQSQ7KAjFV35eOa9o+z/LnItO3VMVJBnt2DlBpyD+YQGyEQdxDr7Q9YvwObXu3bhFxpHobwuHah57zPBeZB0nTKYzLrfUmbFjObrVo3y2BVgzuRxzGHcsTaSrlUz7nu1Uw8NCtHA5Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQVu8Ge8RRL0j1nB9+ZeojwEOS5Lml1IG2c043Uy1W0=;
 b=PuWFZp1ypFvgf9QJ3Ee38K6BOL75pl3ybonRgfPhhLVUha9yXHRAqkfycZxpahJbAAmMYvx0wvx4g21v4Dy6ceiXnGHZ44LoX8lD61AkbZjv9Rbw0BuMYK7T3fo//22x8dklE4/kYMQ5m+QwLhVFqDh8ukqDFuwPR2NMo8mY7yo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6616.eurprd04.prod.outlook.com (2603:10a6:20b:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 11:38:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Fri, 9 Sep 2022
 11:38:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] Standardized ethtool counters for NXP ENETC
Date:   Fri,  9 Sep 2022 14:37:58 +0300
Message-Id: <20220909113800.55225-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0074.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b158e691-fe0f-4f0b-788b-08da9257c549
X-MS-TrafficTypeDiagnostic: AM6PR04MB6616:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9EuIakD4xLXfKMFLAbtpRM9yI4cAXpkdUhtQhOinr6RKZAa6TSz6KdPmwyrQT5yp31AW3Hi7M27VtM0Br/byLPthiIOrvoL78Vzqv9JreC2IaLk7YooXJlzTR5L24ttqndQLG2L6kdzsoNs9ePVJpAlTZtzy51iyZLjbK8pLrRn6S5uD8qcqPH1jkxUxBXDiNLURYblm6STEaOQDpWlAiDkjq9dKU78koQzYKOe21XjjXIK6hxxcJj/f/r3oqXKElo5+ki/wGCwCyO8u69lmy5JUPFZm8ek1TwiwbSU4yFdpwagipRRkfRB/JNmtHWoknahWPfHY7YGKSMqEq3KOa8L+KCdx9v6+fEvxIwBqm2KtxzH6Pya3b65pFSF2Y+2Mh9QD6vA1w3zV3lHd9auxCCirnzRKzrslv3RPVDKTYh5OZ2gDg7rItV7pivncPCvxWK0MnY0Jchmey2n1AxI1a6n7uOvYadC9gELj/ZSNAAqMy1ihEeKFEjJOKTUIRjvwXOX76enHKpUe2s532Czyiq8L5txulR7WndVj4HafTBEEks2hrWNlqNyiGJZAq6zAxZQFHX7JynUhjG4LSVGl8Z+4f7QmP2RtpGskiiBYp/gZ2zfYxCESSK78pfUOrtrQjiohBvkQN7+o07427D3d3C2KRlMOAvXRGOOTCsJIH54PISRyWplIbFlIa0an/Cix2EEmFwpusU3ZKrbpTEcpyp2jyDihx8EYxo62uq9rLzIcWLFftHAPoktPfCkOwXd0sG1D/uKeZZsGACQtlYF+gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(316002)(2616005)(83380400001)(66556008)(66476007)(4326008)(478600001)(36756003)(1076003)(186003)(44832011)(66946007)(4744005)(2906002)(52116002)(6512007)(6486002)(5660300002)(6506007)(54906003)(8936002)(26005)(86362001)(6666004)(8676002)(41300700001)(6916009)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gT2QdbNraX3DIV7cEy+I9sptk/kHrH8AFjcpmJuhSrRAJSgeqAh4QjP/G3O7?=
 =?us-ascii?Q?BYi1r8BjpRDHTWtZaJ/Sw9W39YmxClWJPFRgT1mfuPKTCpyhLOiOMQB6Nh9+?=
 =?us-ascii?Q?RVjzoSVJirxOUlHcu/++PsG2yvkmjOUTKtOJChQnUXlMyB8IefbvR02QckCd?=
 =?us-ascii?Q?fZvnvv+/DyJoTDNzz9bwiNfJeZRZpgUKZbB485F+JEp6C+vVRv88kVmCDRKi?=
 =?us-ascii?Q?eei4GTx+kS4pLARbFmc86Pk0r+kI7f3gpY3L4adjiYsG//jh+4i5T52EMmbU?=
 =?us-ascii?Q?GM/xBpPIREED5SIOqa8LDotzhdKUqo4l/y9hJRsq/3mFCYwhqoxKx4tgget6?=
 =?us-ascii?Q?xJgRRGsA5xIX73jJ9c8qur+HprAn7bqWzYe1NQG4ZCNa3VksQJJ1ABWAMtEl?=
 =?us-ascii?Q?ZjMcLdZ02rqUS7VezyzM8hZCB9VzyqDWXYBUJ7m/Dk5qjtSsM/px5g3hIo97?=
 =?us-ascii?Q?wZsLxk+z8OzMfeqJ3PwuvW6SSyrPugaTjeIQRGl3CMngR0LCs7qA7OfhbE3w?=
 =?us-ascii?Q?ZW2MeGB0wcbFf1vzGbtB5LUs18hGBN6mnoR7hAvyuwxb2zm79AqeeOFOxAsG?=
 =?us-ascii?Q?JDYN3R1XUY2Q4Dub0k03K1q5ZxngXoXigbNnh4tkZW1H/9OourakfHiAyLIz?=
 =?us-ascii?Q?ITrW7VgRNUwjmQZ7lY8fFhOG/IxeMNhS5CB73IrVJBG3GYFaPTwjEnOEWeVp?=
 =?us-ascii?Q?jBNhaJ4M+YE7NrMIyG3Ytd5GYHF0HILUfva8BP8YQuXzByTdwm2YsPsYx6/f?=
 =?us-ascii?Q?wJdkyL9sxmdvKBMeX1Y1bYR3JZMXJQjFHDbJgSwJU2ZP25hbzxnRp9cplBhd?=
 =?us-ascii?Q?ElJqXv6bkRPxJobJclB5X/cLfsRH5Vd51aAQfCSvZcBSVn2ov2BK2QfdLUwU?=
 =?us-ascii?Q?SeoXMmIJMfgRGMJpiHq4sWulpRe4yzJ06o3GxpX62O7qpMiZcDycKF7NVhnO?=
 =?us-ascii?Q?YGnpLJxLDvriaH1Zc+Thtc0rZqLg3jBYX8ScfJ3xcz0OshAdUps42YhOfBhg?=
 =?us-ascii?Q?q12mskDNNhOoz/R8ZcN85+DbbqEL6i7sQbMyMcOJ/1nPRo45azc6BKIfIsXe?=
 =?us-ascii?Q?GN/9w4u6uLk9tbAI0h33hNs1RSy7nVmMAzP6h/hsEWkaQISgpYCkl+J+mPhM?=
 =?us-ascii?Q?rsKsLQK4E87hzZtK58J0RHT0YUnKWcAzoni3iHueJKrb3mt+akempl0UwQO0?=
 =?us-ascii?Q?+WzbEzsNmvCVoWxcUzMwpMmjoDQBudPQ0jz5EC5d3fLVBJnxWaLjH+Tt0RXR?=
 =?us-ascii?Q?B7hCk5Um8jba0GeBPvwo6O0BNrYLGMcvkOaWa2g11RI6psu9qw7tlr5vvXYa?=
 =?us-ascii?Q?2YCPL/NForTvdQZK5eK4DJRfIdibZf+TRuFFfmL/WjPQ0oH29E2VDTrUNuBJ?=
 =?us-ascii?Q?bhcjk3l5/mhnO0fYVB7cxh0e7dq1bcKbfr092pDRHuNYsL7LbSWi4A2hG2u0?=
 =?us-ascii?Q?yNgnLRKwS4rPkz/sFRsuH1SSFzIKaCUtVNLiIblGY5EIHYm6pljfAXYvQdY1?=
 =?us-ascii?Q?6zuXiWrC6SX9gnKfhyDoRVDXUZHUymg6f3x2v7mshrdic3wfRc1cXhB3NB9S?=
 =?us-ascii?Q?qkmlv56Jwb/klTgAL4/fYCC42S/BBDaq8fufF0tEDRjgSty+95wAuGqpG0qC?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b158e691-fe0f-4f0b-788b-08da9257c549
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 11:38:09.8582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y4f+YINGE10ox8UBXQ3WJXnS5vDTqqDbaIlZOU+7uJ0Mx4fW2mFyTEH44ltaoQ/UojDIS4B+HyQEnJa43CDuKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6616
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is another preparation patch for the introduction of MAC Merge
Layer statistics, this time for the enetc driver (endpoint ports on the
NXP LS1028A). The same set of stats groups is supported as in the case
of the Felix DSA switch.

Vladimir Oltean (2):
  net: enetc: parameterize port MAC stats to also cover the pMAC
  net: enetc: expose some standardized ethtool counters

 .../ethernet/freescale/enetc/enetc_ethtool.c  | 235 +++++++++++++-----
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 106 ++++----
 2 files changed, 227 insertions(+), 114 deletions(-)

-- 
2.34.1

