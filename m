Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99153988BB
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhFBMB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:01:59 -0400
Received: from mail-bn8nam12on2114.outbound.protection.outlook.com ([40.107.237.114]:31649
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229533AbhFBMB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:01:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l65KoLcaQ5J1w0tr+NNkP+xVFQGRi+2rX+646dJASgJqtm6enbUy0BuiYdx/ktbltLz4YCr3dCbWaOqQwFzBVfZ8cdYuKWJgf+3UZ8IfeJAmV1nV862L8mnOJW/f+KmeHZ3Zu3GL/arQG2l8myNEfD0yIH4x0bRlDftXcYX6VtS2NQXZ24GRRbWyLgUn3gEMppsoCIPMX0NumxDImo7pbiLWGldavsJjJmlyPqGucP1zN455oiHXzdzjtm89FjSWajthbwsKzqhkNL+6sIGYKjN2W2xyX3vdwixOe969x6JDvedXggObNHjYIv3kWXT1RHjxR04rQeE/2azjh2jF3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxnO2mRe3Rx0Cxox4uZIyS2SMFg22I/rLRNqMebFIsw=;
 b=LkKT37qPsdrvJ/NquWUPNtHRsMcb0PfbrCjtzTYKaj1g0zni5D/8PpLUX4w1r0QGCtLQaHDe0XLJ6J6nzKmxSt1pldNr/7mNLzd02tzbLwGTWh043ftX0/8A/lu5fB4suPD23RJ22E1OAw5XCjv9fc+1X00D76yatZdxSKiEqm2KVNRvanMzvpNkZCWep/7IqBvWdoireSwiE1d9tB0UyVwQwC1UQpIXXoMUreDtD1G9YWb5t2LBDoESAXpt+UVuQaG7H4M86ID8vVBNs3iGzNocYmPajsInkAAeTctGwSNLyrWnUmeMY9UL7sT47B1xe7g0lwkq3NotmKmz1ytrHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxnO2mRe3Rx0Cxox4uZIyS2SMFg22I/rLRNqMebFIsw=;
 b=YgODvliQKNQEpmI2Cb1/qy0KV6ghsk5+EIeP69dvYndmkBnaNXFZUo3UK33mcDa0UY3TEX5MseY7PYviC7JbAiPGbknWA47XITEesbXkbslJ2p70oDLaAP6HDhdHuBn2aUmNz0H+MCS99xPcKRKCrM7QUsbKQNt35hVTYJ5jExs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4892.namprd13.prod.outlook.com (2603:10b6:510:74::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9; Wed, 2 Jun
 2021 12:00:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.018; Wed, 2 Jun 2021
 12:00:12 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 0/8] Introduce conntrack offloading to the nfp driver
Date:   Wed,  2 Jun 2021 13:59:44 +0200
Message-Id: <20210602115952.17591-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM9P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:00:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2bf2d08-ac25-4444-b120-08d925bdfa09
X-MS-TrafficTypeDiagnostic: PH0PR13MB4892:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB489212CC5B7D0F4B6A50AB55E83D9@PH0PR13MB4892.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XXNGBzmrD9aCV2W5veWFKiHkz6NucNoBBrIdH7KGZy5FbFdnw4/ootMANeIoK4He9ZG65FvGth+QbCNZW1IGZOtWkqmUPtM8rbIwlKxb+SGf4wVHEAJQaqFvC/8CzY2LIBPx+uiBRoWLYsrFfxNQLdw7CQTvO2vU7ndtrq/d7qGY6ysGpmbiWwZycuAAVYFdWPWz1amlbLDMitxcEqWp9o5Jps09yRtZfT5hebNqor0+7sBPSuZMbdhKxn2Al8nr3wnLXV6EUbbsE3Icgpsj7HuNr41TCItMmz0fjw6NFv/FKA+htAnSTvpaFewpGHf3W6m3PdWFlxLwkQA0ji/6JKmaBINOo+2kfeuhw/RciT2knOPwiv0xXjzFt0ytvKHV+6I1YquajmcBRh8yQ1mPoola7C3acSOynHHFDzXMzvWR5maRXhy+RBgI8oTzUZh3ON6AXr/fhPMKqkM+m2McZMqUZnFrR7QgzugNowqhrcqZg7JFvC4fp2/7wt+w7QAw2TU8OvXxed3ouImd3HM3UYTy/VmeKP8e5r2Kml2eIBvGguBkPBwq7q6vHw8xgMSnNw/FnxGV8U8xzhvKrloRht8ZwJVR1bf6a0dE6W+4eTw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(346002)(39830400003)(366004)(38100700002)(2906002)(66556008)(66476007)(6512007)(6486002)(186003)(86362001)(36756003)(110136005)(16526019)(6666004)(54906003)(4326008)(8676002)(5660300002)(107886003)(8936002)(52116002)(44832011)(2616005)(66946007)(83380400001)(478600001)(316002)(1076003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vpwc2oqPGQQKcZre53oFtMa3sfxDpx3mDntmqMFWfOS1ZcWtgOlgrWCBPSjp?=
 =?us-ascii?Q?wNvP4KhB2WIs4t6utcY+aoEithSbmW652/qvaBurS4STcyv6p90zWS1n/98d?=
 =?us-ascii?Q?TV76b3vC6RgjVceU2QRNiv93rcEC5alq1kC7NtZ5E72NX27DNQLZ5DGO+u22?=
 =?us-ascii?Q?z9D3wRX7axzjfJMUaIPenbis0NGXNGzkNmS0cN6nvAogabK+YHQqzfLFRDSg?=
 =?us-ascii?Q?/C+8ykaDjE/RFCjDNiJofXXBbtnP6s+7SuGSNXsyaR5+TtVm9LHIDrHWUA4A?=
 =?us-ascii?Q?Mn8AwWwjklSo5bi9Eddo7SdaHUxvIrcIer47mtmA54hfs36t+HPhksayMe7p?=
 =?us-ascii?Q?380v40nShQyGAd9CPaJ39eQ2bRvrGt4p8plrpgxDk7cldEBIbA22mPSPDyqx?=
 =?us-ascii?Q?qVsT9XSVxlQxk5ShaGWP6F/FbYnlxqa6TcIEAArkRwfhmKB7KCGzMN6CMaZc?=
 =?us-ascii?Q?DxD44LifSFwrs5pPBc1rOjAYaZRggvdpanR/xUZ2SKgB1dccLYCa2i//Ahlr?=
 =?us-ascii?Q?QoOXUW9QIYfYtjlQQMieqkCf7PLQEEJCZERuuBJ/F/eEoHtqQQ9JGpwgYPNz?=
 =?us-ascii?Q?sDIK99lyfhzR+Ds0WgDY3ntzo8RjmuZBD3VDszD3LeLSgszQWDkkyvDsRquX?=
 =?us-ascii?Q?vUvukFF++A5y1VRlUfqsut24RMiBa/K6dn2p/gxY5ToeZRXyd39gKdlX1S6I?=
 =?us-ascii?Q?trXEmKp1GH513QLyFdlaVajHAXnoB+AJiWzZUhqMeskFVGVKdL0NYlGXYz1G?=
 =?us-ascii?Q?lajyFMDgXLhTZDbHyUfy3UbjxMO7nJmpEp2iPhYSCyWuIVlLq7ZVPmk1KWOi?=
 =?us-ascii?Q?uAQJIbcLpRRi1GUSFtmOuErB9yFg1ECrjIuw90+BEaislyiJq+h2zxgg6jEV?=
 =?us-ascii?Q?k4uaLeuY2Hrj1u9IPhjaGGV+eLcEqe3L5qTLkz/2l4kRysHzKOti0YuepLuq?=
 =?us-ascii?Q?sEZr5YC+wbAUvq0wHwdxkOgUvqh9r19Thb0UIto0WJb7LI6QuzNoei9bLYV/?=
 =?us-ascii?Q?Txf/Kv9yrkSJZZ6AkUZftFOAjyIytJ9FUSmU+/tX1RJmV2cl7hMNRjdKDXx+?=
 =?us-ascii?Q?tKYpQw0MZjkaz9+rRRsgMrXXLvKCWvy0VnVl+g2Ji3sX4OIE8G7sjBmNzr9B?=
 =?us-ascii?Q?cEGmfFH4LRkA3Of4IipGTYsgEMJYDGaHqO+BIWYL3U9wzxcy7ijM+PhCcWZ9?=
 =?us-ascii?Q?nKqzOtumAbNkbOBP3GQxONHNZKF3H96MWDOm9gIRE7SdtJNbTK5/LvMxBnft?=
 =?us-ascii?Q?1Siwv5QO6yzIU5sZ30KYI/YpoL1b7eWaV1OZq/QXlmgKTOs+jKF02bmKPyDC?=
 =?us-ascii?Q?jgHYwmo9F2DTYhiaMkJKlBd5p42u1VuuW07kbzntgUcE3GOWMlImuSaOblCm?=
 =?us-ascii?Q?NpCfkuUpe0hgte2fVWIUNW5tH9os?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2bf2d08-ac25-4444-b120-08d925bdfa09
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:00:12.6299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /b/qRnbErdtn0js2MhiGpY/qeH9FmRdmGSJa3dVGLINMoKTRn2g1pb4B0F1/Fs2yzEzgClwzZpM2G8nCjUV/zzIyMOtJy1A+D/0KV78yYek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4892
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Louis Peens says:

This is the first in a series of patches to offload conntrack
to the nfp. The approach followed is to flatten out three
different flow rules into a single offloaded flow. The three
different flows are:

1) The rule sending the packet to conntrack (pre_ct)
2) The rule matching on +trk+est after a packet has been through
   conntrack. (post_ct)
3) The rule received via callback from the netfilter (nft)

In order to offload a flow we need a combination of all three flows, but
they could be added/deleted at different times and in different order.

To solve this we save potential offloadable CT flows in the driver,
and every time we receive a callback we check against these saved flows
for valid merges. Once we have a valid combination of all three flows
this will be offloaded to the NFP. This is demonstrated in the diagram
below.

	+-------------+                      +----------+
	| pre_ct flow +--------+             | nft flow |
	+-------------+        v             +------+---+
	                  +----------+              |
	                  | tc_merge +--------+     |
	                  +----------+        v     v
	+--------------+       ^           +-------------+
	| post_ct flow +-------+       +---+nft_tc merge |
	+--------------+               |   +-------------+
	                               |
	                               |
	                               |
	                               v
	                        Offload to nfp

This series is only up to the point of the pre_ct and post_ct
merges into the tc_merge. Follow up series will continue
to add the nft flows and merging of these flows with the result
of the pre_ct and post_ct merged flows.

Changes since v2:
- nfp: flower-ct: add zone table entry when handling pre/post_ct flows
    Fixed another docstring. Should finally have the patch check
    environment properly configured now to avoid more of these.
- nfp: flower-ct: add tc merge functionality
    Fixed warning found by "kernel test robot <lkp@intel.com>"
    Added code comment explaining chain_index comparison

Changes since v1:
- nfp: flower-ct: add ct zone table
    Fixed unused variable compile warning
    Fixed missing colon in struct description

Louis Peens (8):
  nfp: flower: move non-zero chain check
  nfp: flower-ct: add pre and post ct checks
  nfp: flower-ct: add ct zone table
  nfp: flower-ct: add zone table entry when handling pre/post_ct flows
  nfp: flower-ct: add nfp_fl_ct_flow_entries
  nfp: flower-ct: add a table to map flow cookies to ct flows
  nfp: flower-ct: add tc_merge_tb
  nfp: flower-ct: add tc merge functionality

 drivers/net/ethernet/netronome/nfp/Makefile   |   3 +-
 .../ethernet/netronome/nfp/flower/conntrack.c | 492 ++++++++++++++++++
 .../ethernet/netronome/nfp/flower/conntrack.h | 155 ++++++
 .../net/ethernet/netronome/nfp/flower/main.h  |   6 +
 .../ethernet/netronome/nfp/flower/metadata.c  | 101 +++-
 .../ethernet/netronome/nfp/flower/offload.c   |  31 +-
 6 files changed, 781 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.h

-- 
2.20.1

