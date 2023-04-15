Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAAD6E32E8
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjDORgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjDORgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:36:07 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2045.outbound.protection.outlook.com [40.107.15.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8463A8E;
        Sat, 15 Apr 2023 10:35:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF28YG6x3iMQCIEtmijFpwxM2RY+S7IzQXmBgQ0+2VIlSbmiQ/PCkrZTApjicr6aMGtswT53AstfkuSfjHcg+rN3Nwy1MZzgHe7H5TYplXalGcBM7SxUQsi24vGEwtEbpo3fEWLgAwq4JaYD/cSZp+VwmTia7Jf3WFqOF9Xsmz7PG1Lvptqc8pwdc+6UA7ZOFzmcDx+p58ytGaAZ1+uQLZVYbScVJPOx97AzdmUhfdwfHdF8lXykgEzwIMAY0yr9K0qYp/ILSlSLsqxOsG5hBnSqoSMxGBGfwsdj4zGLYNCpc7A0vsGfl03tvIIWdpJMG4cERfC8akhGQbYEUm2mPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Amb4UHMS6czfmm1idpvdJ4tLo1E3iW3fC9/FCArbcYE=;
 b=mGFHOVNl60/9T9RFOx/fGVz0e6lI1TSISZjkhRQ5wJ9tvs9p0vSSI7CbeLTYoveRua1CFrPzj/6PlpYUP6gk1taeAk5mFFv9paWHYr4LEzHJuZsOTH/R7IItdxcp3uZLE6xaf/5RT4VyjhG1Qk8sNH0NCvluQ2Qau2cUNUyvBtKcFw7rWVYR2avkz7M/9S+SSuf8uK662d/82T9X4Ezp0uSeHktPYXkGkCrPUzIAsaYFVvLnBIK4zOk98BdToHL0KxkEyALTybKgA6lMhipD4AMT3ZFp9MqUdo32KjaM+x/e/rZO5MjuKE058CA3GjJQcgZ9kti5FOWlkM8Y4FVmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Amb4UHMS6czfmm1idpvdJ4tLo1E3iW3fC9/FCArbcYE=;
 b=guVcJbqmPqbib8v7Wt1OrHuuL2O5LwbfbDTUoWi+nY0zR5UsXOzBsam+2f2ro3i/JNJjJbMrDAMHzlMdpae61G5RJmOWRA+fjuTvNE7IwtxFRGpULzMcq1LqhZ6qAijxSFSVKiBSRpaYae1zBXf0I3bhgf19q8w7EWtR0Ytzf8Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8322.eurprd04.prod.outlook.com (2603:10a6:20b:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:35:56 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:35:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] ethtool mm API improvements
Date:   Sat, 15 Apr 2023 20:34:52 +0300
Message-Id: <20230415173454.3970647-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: 91195951-4d5f-4ed5-c952-08db3dd7de48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jus6VnZmGfoNFnSTVNN/h+y4j8/F2Tg2G1kDccEOobJt8JvfD49ohulAOkmUj8yPpH/QlBDS93iw2mBJZJOaUmRSr+qTD2pGW6pFoMH+f24gINjNvzAIPhOYJTxAQYSdw7EJ3Ze+NLDgaJX18atpl4XZLYiHdlLTfjpxzXa4RpOT+miT/xBb6KvUlHnmzb2yJEPl47a88Pwfz6EbmMCO+3rQxjcaiP6SgvYXKF5A8M8P18sMuGwCho3sIvA2o4bJfgtQJdMsq3+WaX/0Xtvs9cLhWllhi37Z6MyC7hHKg8DEtozQBMUOwjujPcmhFyCKZAg3WwjUACWyXetU1gJ7GKZ0mQLd8GvorziX7mkb47/6pquc9l5ofGp8BEIJGLqF8qqSfaH6xCjBvr3+EZY+9LWH3nJMeWiD5RGc+9DOzyRs3LmWEHdC5ClG5KcYkSE72ZSqGnq91aEuaYmqUJCloi3z6yaPRBISZmnf7InSO5+Wzbt+1CUhmgCs8jDHboZ6+Q2GiXzlMnunmtmDFb28sRbx3eTCn867/fMHty0ggin8g86o/4zMl4BELLBUeB9Jxp33h70hoezv+cLAkUI+PHI+dl9So3Tr2wDBc8ZxcXM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199021)(54906003)(478600001)(83380400001)(1076003)(2616005)(6506007)(38100700002)(186003)(36756003)(6512007)(26005)(38350700002)(86362001)(6486002)(6666004)(966005)(2906002)(41300700001)(66476007)(316002)(66556008)(66946007)(4326008)(6916009)(44832011)(8676002)(4744005)(8936002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RDajhXFqeIb8NADH6ONv6I0Kf2aCSqjUdbVCkcqjeBIAqUYfqK8YoD54/56t?=
 =?us-ascii?Q?gf5AFwk0GmPIhtS/byjxaOC9+idLkYgZOm1v+QqFPfaOK5kCeKsW/gUG9hPy?=
 =?us-ascii?Q?X7GioWOFRD5OcUkNSaeoaI9xCPg8WK9WNgQatoFnPdFrFXgDNOHdqvHBMwgw?=
 =?us-ascii?Q?DjsCC4m797vDOauubTGqCueuhcZ3e0uWR5iMfAvLDcPzM6WsCQC358VKvu+i?=
 =?us-ascii?Q?HIgoh0oJrfAmQrVnSNqT78rJ6s4KuZSQSY+xuvxfUki16eS7JfjevIy6Pv/r?=
 =?us-ascii?Q?TGZQbDGdEb9pYkJw1SFrp1Y6A82ET6auxd+zZmAFfDbqS19oYGo25PmFdYag?=
 =?us-ascii?Q?pFljjIcH+KIX6vU9OUYHQa70MDTO/e66q/e78vYm3vLFQkasSwb9v5lv7xy7?=
 =?us-ascii?Q?JvHQbKaaBVURM8rGi6c9sxGHe49RCZSR/PYKyC8T4rY8wFIlpzjhJWETW3V7?=
 =?us-ascii?Q?aQ2in5Pgl2FH3xIcitzfIU0NJpebr12gd71WkJFx5PS6kKlxvH1ZdZ1Cq7PH?=
 =?us-ascii?Q?r1lSFOMxXgoWsdwV2hCg59b14XMUEudAXMpnkQPW6J5oOsSPed/X92mIcuEY?=
 =?us-ascii?Q?2L2BCHvaG/3Eb25/G5pTkD7wYqfeBVJphjFm7Lmr67tehm92+ui8w+CvE6Kq?=
 =?us-ascii?Q?IMUJCX+yY3OoEH70xcYG3WRswtOFqVFCd30/dO4HDyllIvoJKdGILz6eKTgB?=
 =?us-ascii?Q?7RZLyAkPgr5xxmBnfhIYCeSSjTpZX8IJAJK+OxQ/V4oh+ggY+C24msCR8DdZ?=
 =?us-ascii?Q?kNa3vSXxQm052/U6QXl/zpFMb1CMRfBMV2kwliiKIbp+A5qdLvVhfo9FsCh2?=
 =?us-ascii?Q?pbO4ky6zJeebuyNGi4oa2kzY8IDZ3GU7cIk0LXH8+58JUDIJblBrrsdl+2Oo?=
 =?us-ascii?Q?9iDoztYnIMJ9nqO5jB2qPWebYLKWrDeqDT2PMydCiC8i9bo68bezh27hlJHl?=
 =?us-ascii?Q?+IXwnutuqBYIR0/Dyzlc2Gxi5RbGZuRfS2CtYm/XHYhh35VWLI4ql0aQNZGS?=
 =?us-ascii?Q?6Licot74+hcK9tYKRaHWh2nyU6GKjM2LCAzOcncyVCnnzR6SsaHcQvdT/OZ5?=
 =?us-ascii?Q?c0H4ch0DcpDhPuLqxs3thunBYR8NckPZTedI5EHxnUdjjwans1mhImP2z/Ac?=
 =?us-ascii?Q?FwdmlJbG8ABQGzZar6R8wep/LZzrbOQXEWEL+85hqp7JFwFLEK41BfoHGYJ3?=
 =?us-ascii?Q?rm8yUUUaiT5ABmu4gkeUXU+DKoFnzQEHLpvAdzgeRum6jg5EpN1l+OLPnRAC?=
 =?us-ascii?Q?ScMNIJuvZmHZL23nurZYXqBxR2cKsn3TfNNjwZLeZoXNcYsdF+E50M7+Ek41?=
 =?us-ascii?Q?E/7TIRpAGA6uH6XJvrdTPiuZUvnkkHAjOGQl3C9keCRw4hkZoy4tUSDPR/Gt?=
 =?us-ascii?Q?ySskTBpcagPAmhaIKBYye+tJzWumT4kH/9qztp1hANo1mxDJsRpUwsn9CDiv?=
 =?us-ascii?Q?AW0MZGlSHCk8+eqm4Xyso9WKvtGLi65PxKfLqtMA5/ieOrYqvLCW1X8QqdgH?=
 =?us-ascii?Q?mjP3b3r5rah/CkNqveo6/9qfwt5Lh8AyiLXJZC2zKBu7+r6LDlFPep3OMAfe?=
 =?us-ascii?Q?Yc86X+G7BKTeCj9bYj5OwyvTJ7NvYQOvP8ZMYpnYgmBKhhsipuRFjo9MTeEK?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91195951-4d5f-4ed5-c952-08db3dd7de48
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:35:56.1889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PY8vvwjc5Ay8T4P4VazjgFW6vIgoNhTAaydciB8cQsP9/am3daoWEu07ocGBDjdIAsc947tj4Lm+K1EGb2yWmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8322
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the ethtool --set-mm API permits the existence of 2
configurations which don't make sense:

- pmac-enabled false tx-enabled true
- tx-enabled false verify-enabled true

By rejecting these, we can give driver-level code more guarantees.
I re-ran the MM selftest posted here (which I need to repost):
https://lore.kernel.org/netdev/20230210221243.228932-1-vladimir.oltean@nxp.com/

and it didn't cause functional problems.

Vladimir Oltean (2):
  net: enetc: fix MAC Merge layer remaining enabled until a link down
    event
  net: ethtool: mm: sanitize some UAPI configurations

 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 11 +++++++----
 net/ethtool/mm.c                                     |  5 +++++
 2 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.34.1

