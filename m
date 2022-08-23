Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC3E59CCE6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbiHWALc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiHWALb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:11:31 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80134.outbound.protection.outlook.com [40.107.8.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E4D5721D;
        Mon, 22 Aug 2022 17:11:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1UzmjFPyOP2YPLkNKWMdxkXv0YxR/tq+LFfaiU/4KMfg0Qeyucak4NrRujaoA2NMepaieM2zhaX4ddnP9GObc6E32vzu9WYxFp4Xu/8sS+oVbGfUa9YJLSj52PKFAyoK4k2eboF+KBgq04kbGwtuby202NYs4mrYw/ZNDanrNvHuHC/z8QuYpHnAA/AYpCwOHJxTlQ40xq0YiMJ3OKzyOrMsbkAwN5Z7kjQ+bitFAxjAchpbkpFBetcfC4flVzmczJSMcDojMi1aGlv26adK4qRP7/zCO+loqMPIRlaKK+1TRBi9IMt578ONb0j6jDvmPRSBlFXv+lFKleTmYysrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSGKDe+BUrPOFXkEPdnUSziaFuTSczEhNQerOv/ryA8=;
 b=BB+w65q0j9i7lr/t4fs0zp+wN47CcY9nDOlmPuXedFVqNDjN3SNoyWUuzxNUGGU8oojyyQRt3BdxImqHOLht36gWR3PjyUzzVMAwpK/nClo32QfyCcPeGBhwInBvDViQjkGQs+g3Bxc4OooRBOKeyfiXtZTwuJMA38ndDgf1jNKjI1EZR47BBFNfA3oIsoTxll8NQWdt2oGPgQlGC7ZNUiC3rVHw1v124WZ7/r+3BflsH54IhT4eODqkfnONCnIoBWexgOZgPuOUNHpOK+K7JP7e/onCrgcBXHaYKN2HHdM3uBdyZYmKT87Ys/hJo+Li6DpCmWBHSXt9sUhzNkaz7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSGKDe+BUrPOFXkEPdnUSziaFuTSczEhNQerOv/ryA8=;
 b=VwsiWkKtUMIiz9qb38lWX/cp5vBtkoe+WwP7cAeieSHB9M0KYat8HRHpG4Fuk7IRBrKlNNkrhDGS8p4mTWpYPgRxDfk2hPfGaiMk/j9EpjJFmfN8nqC4qkigdyYkowmScOscs6IFoKZdrXeJuWMy3d0LQfw9gCBBwb2p77ptkPI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by PA4P190MB1072.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 00:11:26 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 00:11:26 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v3 0/9] net: marvell: prestera: add nexthop routes offloading
Date:   Tue, 23 Aug 2022 03:10:38 +0300
Message-Id: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1603dfe1-a28b-4ddf-c348-08da849c0526
X-MS-TrafficTypeDiagnostic: PA4P190MB1072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ub8nb2dkTeOcsRNiPsLpyB4bGGjZIGoOcHfV25l2Od533LzuTDu3YgOU0Fhl7fwOUzXPr15Ixzi2GawHCw9hdLtJJdsFJGFijHIVw4AtKhEekb7OPOJLcENK7JMlaPJEwrUNPNh29XqQKKXedD3cS3uRzM/EMQrbz8GR7IHTq4tvqPqzyDHdYOX16pMDiS5WhEb77pSmBac0Q/gOL1rPZjAy5KXyVW/F7aA1nl6Aw7DubN+/vAz2i5hdPuzdh+jjY7KcNtwMyiN99/fB2ghRVQVcl7N+Jny+M9Cak8fdUE7L57VBHlWgwOQlBJsMEWWujN0KDozyYWngd86Fu/wE1dYBSxQ7Qv5IEu1O5WEhFyTrbmBJ4UMYgV8XCzF990sxoVsTV8SR7yQKP8IKg1aJEGSEpt8POFyPqd/8982xiA1zVTQs4pA/XZR3r2qwxHViQykLBMPzMiHSUBdKerjXF97zsWRKtpD1OhvbMiUYAE90Ow5W+eKAMx5e4/qoaRo4yUCHumdEIIqiNhqZhsSsNmUHDtTtb5lMZM/9/gksByuW8ZGz6lGdylXCrUBDhZiCYRA0qTl4tO7j4axs/AAs3pGp7doNxmHw2pzXzGLDPAxAf2yyoUi1cGKHLurGpT5vFdtl7/Fy7GxvPbMFh/+8NtdPw1fiWGTWyW6PHN+5oCVorMVSFl1/jVey1mdYG2dCKTJ9gmdVJoqlqmlGu43WKCQWo/k+6RsXKxYF3/1TpFRUvL22p3JS6IsanuZ0vyZoAAhZXA50jX4KKGOKyh5Jkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(34036004)(39830400003)(346002)(376002)(83380400001)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(2906002)(8936002)(7416002)(44832011)(5660300002)(107886003)(6506007)(26005)(6512007)(52116002)(66574015)(1076003)(186003)(2616005)(6666004)(41300700001)(41320700001)(6486002)(508600001)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PNzQaH28AuS5deTCFDPEuzlc2FyfzFD2iX63TWj6CtboZ7IPcXH5rj6R6SVU?=
 =?us-ascii?Q?5P4dWKo34m4t+XSZXbCalwlvY8B/Bjsdwzb8ikdeuE84qFtPaJoY0KogeSKU?=
 =?us-ascii?Q?pekrCB8SJ9EYk4US/XRLjfpMeBMGVvdybE9ICyOZNnqKXR4ETjIbQnBrgbmP?=
 =?us-ascii?Q?Ru8vaReWqcWESLLdi6HtGCPkmBxucXKqGTy0HY3wHnrQIFx5HQM25MRAnIHp?=
 =?us-ascii?Q?lhERjNATLp35rqgj0pFfdzDf2USoXFWmIqPyINpDAj66a1XDOUmHygZR4zsp?=
 =?us-ascii?Q?7SqDc06pHizo05xaLvRAxNcf3A0FmSl5LmXxg6tVIZbLV145yaYXkjcoaUrZ?=
 =?us-ascii?Q?0X+LHSd/SJe/vUuDvJUoEFrAgaVJHbCLAKTMoZ4JBuSEtT3qf0lj+JK7PTuD?=
 =?us-ascii?Q?XlNUdvDEnaOsn+QaGwk6uzRT2nB5AajT3QpPVxt4QCAz707/GXZi+8orl0WL?=
 =?us-ascii?Q?HUVnSX7hMyyh1bEW2Yyb/ieQBmnAyYzIeNPJE2/gqoko9DklfHiROIPjJ/ci?=
 =?us-ascii?Q?ZlWm14dsbSOono4uZMaFnZpWl16wh2ieqslBTlnN4BbUpL40gtiyakXIoBrG?=
 =?us-ascii?Q?RDljR/y39MQXFUqg+1YxQR+faraUq+wYyRFTvGSR51QGjtAQ04+Z+JvAe5Ng?=
 =?us-ascii?Q?GFjB+lmv2evGv+M1DPTQsMPNr2JgkuHuZRhLyXrjV8r6cTMqw/Lrz8/Fuli8?=
 =?us-ascii?Q?3nzdgfSZuLBHPURWm/MMRb0JeiazOuMowQlSBh/GZWEitTNnrBpuIFuiwOoK?=
 =?us-ascii?Q?pIf2KoT9aAhpDvWwyIi1EmJv9RR1jtDPPrlSf9Za0pSrL4YcEAW06It9pfeA?=
 =?us-ascii?Q?/hgeAy4/0aL9mnPtCRXL0aVubLD8NQdigA3nxe0vQjNJ5xkzkWSjviY78poZ?=
 =?us-ascii?Q?QLNgEi8tWe3OKLbIgKRf+FtmcSAxjxI10kxCmjpx2FrzKR/++ZRfCjRb6luB?=
 =?us-ascii?Q?HNeKfRLdzK97xGdwLefM+fQUJiceVOYdnhPkeSxe2BB2AP1pWs3ucYWHT8oP?=
 =?us-ascii?Q?bXp61/mYqq9lfeb5Kl7CG+bQq6GQ2llz5qUqvqZaOYoJlVBsZizuG25TsXBU?=
 =?us-ascii?Q?vTFLBS+FHykhJpna3843YMVFt7SJOD7glkVuPe0UonSexv7XOkXJirymx5xo?=
 =?us-ascii?Q?/vAhydEW3QptjMGryw/6k0Sq/UDWXNDPIzFvABTPZ8ipBMVW/jbuU62DcXKI?=
 =?us-ascii?Q?oR8am7NBJsHUglUhG2kg238IOVwaizXH2KKpl3/fwz1JEq2+CSVjsnv3mW8h?=
 =?us-ascii?Q?SEbIPVHMrm58d8wdCdgD7I6itp5uvil+9v4x0Nt1zL55ad8ljzIXuZKZFEfl?=
 =?us-ascii?Q?XLSKq+xeBacIb8dNkr9abCp9frt+1z2ctur+uBZ7aL0gx3Mbk79wmhhacg62?=
 =?us-ascii?Q?forSeotl6O1eoxXGtfaRBpbKr/4Q3FS+dTFGiSfhIJEHYysamZs+kHXew1Oi?=
 =?us-ascii?Q?lvfPAjEvMuk/3swHs5cXBLI1T65m7snBkO7KqRq7fFOZt60RFRqHCdMx4DVa?=
 =?us-ascii?Q?PBhK/EmLIZfhTDxPkUqQYtW1QFwhtbN9J/dYZilrnUoq+m7ODp4e46IM839Z?=
 =?us-ascii?Q?LWXtnDMizCgd/dcd5bPaYseavwj+qcd+OmKJ/60eeyg/bSBaE3K20f0r1BFy?=
 =?us-ascii?Q?MQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1603dfe1-a28b-4ddf-c348-08da849c0526
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 00:11:26.3995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzI41U12cocPiJOhlIYcOpMAx46/H65EeAUW94HGBy1dqnFXxChYubxpOlOtY+Oi02UUOWfHUS7e2DZ4aHLTOJ+0JYBG2ZzBhtWkWpFEnNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for nexthop routes for Marvell Prestera driver.
Subscribe on NEIGH_UPDATE events.

Add features:
 - Support connected route adding
   e.g.: "ip address add 1.1.1.1/24 dev sw1p1"
   e.g.: "ip route add 6.6.6/24 dev sw1p1"
 - Support nexthop route adding
   e.g.: "ip route add 5.5.5/24 via 1.1.1.2"
 - Support ECMP route adding
   e.g.: "ip route add 5.5.5/24 nexthop via 1.1.1.2 nexthop via 1.1.1.3"
 - Support "offload" and "trap" flags per each nexthop
 - Support "offload" flag for neighbours

Limitations:
 - Only "local" and "main" tables supported
 - Only generic interfaces supported for router (no bridges or vlans)

Flags meaning:
  ip route add 5.5.5/24 nexthop via 2.2.2.2 nexthop via 2.2.2.3
  ip route show
  ...
  5.5.5.0/24 rt_offload
        nexthop via 2.2.2.2 dev sw1p31 weight 1 trap
        nexthop via 2.2.2.3 dev sw1p31 weight 1 trap
  ...
  # When you just add route - lpm entry became occupied
  # in HW ("rt_offload" flag), but related to nexthops neighbours
  # still not resolved ("trap" flag).
  #
  # After some time...
  ip route show
  ...
  5.5.5.0/24 rt_offload
        nexthop via 2.2.2.2 dev sw1p31 weight 1 offload
        nexthop via 2.2.2.3 dev sw1p31 weight 1 offload
  ...
  # You will see, that appropriate neighbours was resolved and nexthop
  # entries occupied in HW too ("offload" flag)

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Changes for v2:
* Add more reviewers in CC
* Check if route nexthop or direct with fib_nh_gw_family instead of fib_nh_scope
  This is needed after,
  747c14307214 ("ip: fix dflt addr selection for connected nexthop"),
  because direct route is now with the same scope as nexthop (RT_SCOPE_LINK)

Changes for v3:
* Resolve "unused functions" warnings, after
  patch ("net: marvell: prestera: Add heplers to interact ... "), and before
  patch ("net: marvell: prestera: Add neighbour cache accounting")

Yevhen Orlov (9):
  net: marvell: prestera: Add router nexthops ABI
  net: marvell: prestera: Add cleanup of allocated fib_nodes
  net: marvell: prestera: Add strict cleanup of fib arbiter
  net: marvell: prestera: add delayed wq and flush wq on deinit
  net: marvell: prestera: Add length macros for prestera_ip_addr
  net: marvell: prestera: Add heplers to interact with fib_notifier_info
  net: marvell: prestera: add stub handler neighbour events
  net: marvell: prestera: Add neighbour cache accounting
  net: marvell: prestera: Propogate nh state from hw to kernel

 .../net/ethernet/marvell/prestera/prestera.h  |   12 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  130 ++
 .../ethernet/marvell/prestera/prestera_hw.h   |   11 +
 .../ethernet/marvell/prestera/prestera_main.c |   11 +
 .../marvell/prestera/prestera_router.c        | 1140 ++++++++++++++++-
 .../marvell/prestera/prestera_router_hw.c     |  379 +++++-
 .../marvell/prestera/prestera_router_hw.h     |   76 +-
 7 files changed, 1717 insertions(+), 42 deletions(-)

-- 
2.17.1

