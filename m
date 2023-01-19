Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB939673E28
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjASQFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjASQEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:04:50 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CDC84570
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:04:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dD0e7z/NsrwQp9dAu1K98l/Meox3t2HIkw5JBstDWnJB2IHH0t8rDafNd/MhKEJNWBKV4/pPh2054Ec2RMbzZUimhw94xkYzoSxTVyI2gG+k0Bx7A9auJ6IK8AxnspkwKAjS2JmyirHgtFfoeeZ0STaLLp6qBbt8brAMLv5P55mnI+eKLp9OqtUgZgRUUog1Zvqg3QCjdFX+YW6tGGG8CXcxFLG2GCzzHl30aj9EoH54L7Y+K8Z71a6lhH1XcWtoH6SEiQF+A9n65vvfcev18cj6bRdE/OWo2gpj/P/ae7T2wPUWijoWSAc+L9VbzpIDyfUzRemGfvI1ejFWbOxlsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSKFUkGb3c+ADGcnq/s66ATiWgBu+PcYRdHvi2c3iuE=;
 b=j64hOO+KAnh2U/2Thhn2PuHZZmlp7uFSxcmACPTmaTrLRG3I2jfx06cbYKEYY0WzyEOKSCEE9HZWeGo9VsVggnR224nP+UYlfug588AF5zkjKzBFFI30hlLxNLP/Fu9/JkKekaF79jRYmkt2e5kjoRmn+u8WpObcKtUINzR8Kb83XfkRYXS7ANbjHzc0oTqf87XrIlVnmsCnPx83yYBtZ7SU4F97ep14AraqaHK2Za9VJrDjYmiMkFZ0lthQh+kDaGIfITg42Gsstu9Z98M2PKBqUl4GKI52xvCYNmSnje65Jv+ZFgmaDWeOkqXtZXhSGAu43+eySXCHViD02NnciA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSKFUkGb3c+ADGcnq/s66ATiWgBu+PcYRdHvi2c3iuE=;
 b=HZdYciE0meKldpfGAVTNkZGERCIQocfpI5hRv9K1tRf2UIgZy21/FXq57aSHUGq5ieUWmrkiDTi7zOer+zeE5H1nHtmBmOTGptHlFIhbBLEzpX5v/wWwWTss2ebw3tit7d5erSIDwCGHNVPMZwYXM+6ycSrktv/vWbn9sUxbgdo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 16:04:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 16:04:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 0/6] ENETC MAC Merge cleanup
Date:   Thu, 19 Jan 2023 18:04:25 +0200
Message-Id: <20230119160431.295833-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0130.eurprd04.prod.outlook.com
 (2603:10a6:208:55::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: 03dabc0e-6b25-41a3-fdf8-08dafa36dfa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VrhLwNxiWrS+7JeFy6VzzMLQ1SLUgKpS8HWcu4Oy3+L4Y/5LZq5f4HncrH8I8XmaU4Co3So/UG+cnrg+ceOMEjYhnqeGzixfdWc9co3OfPsaly+u0x4uloQWZN+eiPVctva2//9DOABrK2yOBMeXPW1wNtFHgvqqOfzEwqxSruiyFuqurFnnHWogQwjDr0j+KHOO8C2d7/uVZCENQuv1xDEC1skMj/fRue27OE1wzWUIEblEU46+hhxBmayGLAovNDY/cYrcE2ZQPwT/ZpwVTFyPBQlqYERFseVi20Dv/4mmnkgorDDRZhYzrvl4lVWf9duVwt5dgYRSyj5NzKAPjc1YPzVUgC0lwPwc0vyXlTlq71njd8GUZqv0bDT9Usoem8dcyTCCO8RtUXJGE/cYfbWOdt6T9yTtbrq6TTMk/OD8Vs9lbC42l29KpnwlY6AiIZ8W+jcnB8cOPtSX4+KWfcqwOiXrqlL/Yq3OotrilZFbpT5BjeC3y9myErZKjytU8FlFLk+k/lEOndqmziAYqyB8OVmxyxxoxfKNobkqKSfwuYeJOsNdPYfxn1/Q/7F031WDlSRPAfBUCbAmdlvYeqlz5NKFzaskgbjtpTkkeVQzJQmTsWuiDBiD6B8+7bgJ/Fu8dfDwlfX1ONELclYhP0Jk6+749jfy+T1PUciZj6fbnVnS/S1hce1W4E19IRl53TzoTtZ70pqEjtn7QJeThA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(2906002)(41300700001)(83380400001)(6916009)(8676002)(66946007)(66476007)(66556008)(4326008)(36756003)(44832011)(2616005)(8936002)(316002)(5660300002)(54906003)(1076003)(6666004)(38100700002)(186003)(26005)(38350700002)(6506007)(52116002)(86362001)(478600001)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?donruc4VUCfH4YCatEJvRn9EG5rT7/2YlqztMptUTsmQO/61tS8VUqks1Kw3?=
 =?us-ascii?Q?+0Yg7nQYwekU33gdYsIvW1Xzzt7VgJJRJAqX2dsIHMlLRnceYDa4ucJ/Uc0B?=
 =?us-ascii?Q?kI2dX7ejxRk/aHB+i+4UCtkDdghNHwa6iGxxXzEExAMjPuM9twqnU9Ak8z8P?=
 =?us-ascii?Q?BcggrT3MFZBl6sTtQfH9QfPuyZE5RGcoIhbV+pgZGZUlMMCmNMwYwD+KQATr?=
 =?us-ascii?Q?sM4Zsc7aij3d6RI6EH9coY7vwmWI6HiQDb8SYL8iHvjD+ofn9wmBEFZBLHfx?=
 =?us-ascii?Q?jAOZxBcJzH7onaLed5O450XnCRfjD94ZP2bZds+aFnqKtZ9yF/Annf6MaIp0?=
 =?us-ascii?Q?Cj6XcKcpmN8m8DpmSx1schC5mf0P2D3QkqHj8P0HeE8TCWjUwMI0xv96mKdd?=
 =?us-ascii?Q?aPG8yrmd9IAMVr4JFVBS1TmF8qdaWjsowSUILFK2aP6Zfc6tdIQ19DfAzNVN?=
 =?us-ascii?Q?i6BN6EsG8ihh7AHJTjLnX7+saNYI3gq5KVD8uobo19ie1NtEDeNsGHu/l50G?=
 =?us-ascii?Q?P6Odwqq1L5WzWsklbJxpZ1cxN9Iv6QG9lrB3w/c7PhQQAKHMAOjkTcX9JLQo?=
 =?us-ascii?Q?Fccy86ET3F549R8VRzBU3kTpJsQiK0RPgbmLlTki5LkhjJKjOixOLuIiFytp?=
 =?us-ascii?Q?K4QIjIrbBfcUGY2xQ3La6iTc2THZ1WxYXZxAPJUZyybEepUCzCXRQn9RoV+4?=
 =?us-ascii?Q?jnQdZzXwSfN1PwpPNWvfWVMe93oReqmo1z7XVJX+ul7t9A++JXCm+3ZU1HZ0?=
 =?us-ascii?Q?RnrwO9Bs7LhSLk6aTN4lT93AbKVXYG8jB04lKgpslAQfom/phnE/LOAZP7JY?=
 =?us-ascii?Q?sZxkdykfp6xYgGRiizkwFKJWsXb9j3KJY7akjKQAtDXIZ2jibK9PgkzTC7gz?=
 =?us-ascii?Q?ppaWx/+U5TtkUcUCGZVn9WchYrrNa6Qfv73lvxc3f/WGwhrr/Q8jgN7thLSs?=
 =?us-ascii?Q?1z+eUocE9CWIiB+raiIACOb+t/nyvN+AebK+RWwmN4oOJKlv2NH4uTAAAvGK?=
 =?us-ascii?Q?m3riu1QbHip8Tdgxqb5Cjiz6af3z0eivHN1IZ+Nf1forDeAEgs2XN4xbLWMx?=
 =?us-ascii?Q?e/oRsP/ZDm1lv3lWfm13ztQdSyJZcMD6wD7Z1MYhOtToX1e4el8icZ6DHcG+?=
 =?us-ascii?Q?/FrdOGJwbGHwOvIlS9JD4Xl/i6gpw8VOGd3j2SaM7lh+QfQFOzjO9Cm/xKvs?=
 =?us-ascii?Q?UMiqHKGB0BvoO7kzPeqZPrF6acbHEfjnyaNBuzzRNUA+3JFwhXn9xPezR5Ce?=
 =?us-ascii?Q?qq0kVP/KYfkOFNJPwVhWGUAbK3hVwWYY1/xe7rO+d+jT+V/PGoINfzCOFpK1?=
 =?us-ascii?Q?Jew1hRIn0KpYIgpfUJeH7JBDYzIuviLha4KMfAtmWzoGWKpf9rfpuyqB3bRA?=
 =?us-ascii?Q?WCcCwNzl2ChsBKcoDpVsZF716W4Ng6WvKLw3ZjEU/J66sg7g1QLmTSYx8fc5?=
 =?us-ascii?Q?DIorLFASMA0oO4erHxar9e/P/qeH/d/FTBqEq+hL9Nmahmwm5oM90xE3ZPdN?=
 =?us-ascii?Q?cJlGsgWORqgV/FIg6EbFChq8vCxG2eXEHUt+izcicPwGQBnjrsu+OIt0T+Bs?=
 =?us-ascii?Q?tHWqOq6fvMdX5/mFonX2PzXyls18QGiFt93ey0xiHLKIkCfcJKOlTuZYY5bK?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03dabc0e-6b25-41a3-fdf8-08dafa36dfa5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 16:04:41.6846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DL8y/F9AEIICzvW9Hgu2dDflW4O1z6wcQ8jcQELDV5CNS4bkkwHVQweem0RgDu5HLOl8WEjbGhIy7IionX1Wtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparatory patch set for MAC Merge layer support in enetc via
ethtool. It does the following:

- consolidates a software lockstep register write procedure for the pMAC
- detects per-port frame preemption capability and only writes pMAC
  registers if a pMAC exists
- stops enabling the pMAC by default

Additionally, I noticed some build warnings in the driver which are new
in this kernel version, so patch 1/6 fixes those.

Vladimir Oltean (6):
  net: enetc: build common object files into a separate module
  net: enetc: detect frame preemption hardware capability
  net: enetc: add definition for offset between eMAC and pMAC regs
  net: enetc: stop configuring pMAC in lockstep with eMAC
  net: enetc: implement software lockstep for port MAC registers
  net: enetc: stop auto-configuring the port pMAC

 drivers/net/ethernet/freescale/enetc/Kconfig  |  10 ++
 drivers/net/ethernet/freescale/enetc/Makefile |   7 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  43 ++++++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   7 +-
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |   8 ++
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   2 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 112 +++++++++---------
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  86 ++++++--------
 8 files changed, 158 insertions(+), 117 deletions(-)

-- 
2.34.1

