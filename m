Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFCB395AD6
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhEaMsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:48:14 -0400
Received: from mail-bn7nam10on2126.outbound.protection.outlook.com ([40.107.92.126]:16736
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231490AbhEaMsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:48:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m475D+h4ziC62cA8D6hN9xEgugPTJAgDOWNZfwhHboZJ9f8amdi7Ire5Wn1VlkiTzfbC1j0mhaQRZTceXpIHxTdAo1n5tMlBvhrh5Sm5NmT4apArN1LOdY2+GawYZvRyTkVjTHE6cAJQM4X2R6LzNHsmi5Wc6mcKH72D/ZiNcbe3mhn/2qSqN4h58LIaw8ZLgFooltilXOLWT5sX3wtgTVP7nNJi2Y/qSC6FdZPJVmhczMwewvi/TDfuBc+1AWNWTfk+FgM81dtXNr9Tr+d0jnH96d0Qo5F677GTuxonHLbItln356La/yOAUS2b0QKAh+0qhQ2rsJaZdPIw5d3UfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8vaVapW4m1D/2aXeqlgKBmlTrv52m2BqJ1O00RqQLs=;
 b=WxIrPgkowAjQRBm2K/G2kRaLda7FQIf5/F/ST/JGoLuWOh+s4hX2eYXIjZvg+Z5HFRU/Q/XB41G2zAcO14WZLU9yUNTTsZhmOyqXwsvFyaDIdwCFYe6/5Rtoo++FU8Zj0Jr8wg5qK+Ktjx5TjYqkW3kTWuTff8cvpKSpjI7ssdeCjGQrWy8yANy1Z1XOQEaFKQOWTKrTSILg9ZlXm6VugCCl/rRZVKPXXbBAN7eT+q/Jrj6yLyGkh42LK/5vnaXuU8aJtUTpBPOnOuA7AesaHWJEQ9T3I5u3fULzayt/DRQMItvPqnmHE+DHurVmrOWUn9sloagl8HJc4h/XP9mbiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8vaVapW4m1D/2aXeqlgKBmlTrv52m2BqJ1O00RqQLs=;
 b=t3cMAvhoJSMLM/K+nRd+p81u+SAGIejvcgU6n97NuB65FUeYCILT5gb5PUz4F3QV4OFxxZsy+wehTi6yHEAt458I0LZSvjlFzehRl9p30dLKJ+m9NGtHCKW1eE4sv4oOX+QHet582ABpOl1TFXfcTHCq/KdZJA9gZtv98xFk2Xo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4876.namprd13.prod.outlook.com (2603:10b6:510:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.17; Mon, 31 May
 2021 12:46:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.016; Mon, 31 May 2021
 12:46:26 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 0/8] Introduce conntrack offloading to the nfp driver
Date:   Mon, 31 May 2021 14:45:59 +0200
Message-Id: <20210531124607.29602-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:46:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 496d49b9-631a-407e-51b4-08d924321a6f
X-MS-TrafficTypeDiagnostic: PH0PR13MB4876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4876B9AE412E8027BF7E55C8E83F9@PH0PR13MB4876.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40n1c3XRRhy78yR92Ta26KDESYRHSa5Ijaf2iDYENsiBARHskvAdnYGZPsRaM3aw1vM0KbKy/UNTIYYMphntCjJjpHCfxFJf5ddX5I8/Q8gljxEf6IVhhox4VEXK/4MaXtW48ZBy31ewKF0aOr60RbGREHzlUx7eHyFX8CTSRGt6UX6UipvFcJWQ280KgU0NJxvQ8exFk0r8OtD2QHb65Y8pJekZAfszzsQ0Hb99nIlmOPpmzJ2FCZhb8dt745od/BSjaKlHcbe3M8zgtIZvcCl9rq7YyJ6gHJjLanUfK/CP6Jt65CS7Ih+T7ehfyPvinME6Fs3TmiJZnE4l0OaVOzraMWBXRgvWWkJHkydG7AUwLVxrhMlgetJA28bhYds+d2ySICp5cPZZCKCcUF4GBeBrbMdxFAGeEd2b5P48qXNr4yZSjOshkq7Ypv5vwXP58glyAonR+bzXAnGamETiaMBpdntf0WvqkIrQZSihm330S6oYjSBBBc0gp+/Lnov1IFo/KGrXPyaxh1pztGCi+mbIGEguYO/ibPcQfIfA7kIIYk2mlevg0K5ewdtqpThQu6KdvS8KdTUWk18NBsq8lVrqTziBtjF6yibd1Vg0ZN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39830400003)(136003)(396003)(366004)(2616005)(6512007)(5660300002)(6486002)(1076003)(186003)(86362001)(36756003)(8936002)(4326008)(478600001)(6666004)(16526019)(8676002)(2906002)(66476007)(66556008)(44832011)(107886003)(54906003)(83380400001)(316002)(110136005)(52116002)(38100700002)(66946007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8I/hXLp6oODMhfeNhZ4Q6PbVXGDEuS0d+GyBn2r/JufAALeXO7tsvO+rj4kO?=
 =?us-ascii?Q?i9POtNOU5+XQeyKfolgUxF5EsnmBTG1D7y4I1AxtzR4g3ph5XLc5RoHb5VsW?=
 =?us-ascii?Q?+ajZ4/KoR2Dh4eTSNxf/NSOKdnpFSPtlvg9SnbMBKQ2vHIcg+SnpM14yHROL?=
 =?us-ascii?Q?8XSHYLoTjAdLxJKhKcGGxLQlceFJ5TMEyEU32DnqcDrub2bjwhcvT54sFPhb?=
 =?us-ascii?Q?/Kfc/waS4SWe97DAksLF99Qk1UoLK9yL+Uk1in2+TJ3ydAA1vCh3E3SjsM2Z?=
 =?us-ascii?Q?5sWQoiOZTwwJRkB9JGFUtM3BAnVc/GnpT6m8gxcafafkJMUARHogng4Vgs9c?=
 =?us-ascii?Q?OutJffEUjWRQgKUBKDFNGF0RuaoNrZ5KLm1EVJYHcixhL1Oq0hq2gb02ZuH4?=
 =?us-ascii?Q?XxQDc7nrtqca2JvkCFrPZXIkRAzsTZN/Zr8FbzUrRKqKopG4PsjQDyOu41B7?=
 =?us-ascii?Q?G4fIiN3oFKzgcMYGzFlZrR6TpHw/dWyrPcg7sCzvtKMuOhhr/iD6M2V02SVN?=
 =?us-ascii?Q?YqBlJqsdsW5uBqSzXdDPTDad8YhAA8FTYVQr5Lh7b1TFu0TPZcuDyQ0tElUY?=
 =?us-ascii?Q?kIv/UDVE1aus4r7uqpyRgX+UNfFnoNpDK8zgTwQQgLZQo79MiS0cLtsGx8yi?=
 =?us-ascii?Q?UyvDEO+4H0UQvAfXHiTtQEZtJXOhqx3RwD7oxxxsUt6kVB1ODJ5cP7IPHNwM?=
 =?us-ascii?Q?vKNTCZ2UacBd517JytDrhA6u1y7BQ/ncIar+Nz9pRhArJv1jsBNSvEB7V8BL?=
 =?us-ascii?Q?9hy5BUojPBpF5XJti6QhHCu8CCH8C7f9LfR4/Gtp1CxLQgQ/CUbERnGTjW2E?=
 =?us-ascii?Q?Uuf5vWtyFZHGG+pPV6MWUCAHtKPN7XX0v7s7uL5wbg0Qrf/6J7z+K2vCVd66?=
 =?us-ascii?Q?VfXwJV1+Tk8Cmx+93ugCFsdrluzmM9+vz38KJwDwkDp8psYi6BGC37rXmJf4?=
 =?us-ascii?Q?GPEsaYx7/GPHWt4ZtPTVu5o7lcZsT6PITIKS2wauwCqiLz/rPeTzfoli7yXs?=
 =?us-ascii?Q?hKq8xJ/vpKMLi3B/8rvbbW7QiNbZPX++Pc9J/cSOLjM3HqCaXXSf22vuFTFQ?=
 =?us-ascii?Q?baLG0CPXS0lJP8erCr0BSzSUW80tpfq1W/2t4ErGrB4TCama5odyTVr4OGQJ?=
 =?us-ascii?Q?V1rxHytae7/N4UU6upjH54nNsUYUOW1ldfkLrCzBALVn5rUuXXppdiauhyyX?=
 =?us-ascii?Q?+QH5xiahDfUNYXtLCzJ646acLmb+oGSQ3E0Ml1tmsUTrkcKZOcHyBNHXKmwr?=
 =?us-ascii?Q?y365rw+gjCLqCzjvIJM0yCqqcUR6nUb0HO9/Otqq4uQJZ40llaytlxVkNDCJ?=
 =?us-ascii?Q?lNQgMhLjab1vGdLHlbNDv8j3Y8HEdnXEY57uI4iqTqT8/9p9QZ2CTbSN95GD?=
 =?us-ascii?Q?ndFWgB70zgRYrbgJ34kwGue6FA4Q?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496d49b9-631a-407e-51b4-08d924321a6f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:46:26.1905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HNZVnWDGPpGouZMMCc787LrHpMb7EXRnUz5Ewb/OLyZrf0mWd2B13rrSOa6UeXe05tjumgLIPPqtMNZcAiPpzz/LS4fiqrueGgGJX5t/AXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4876
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
 .../ethernet/netronome/nfp/flower/conntrack.c | 486 ++++++++++++++++++
 .../ethernet/netronome/nfp/flower/conntrack.h | 155 ++++++
 .../net/ethernet/netronome/nfp/flower/main.h  |   6 +
 .../ethernet/netronome/nfp/flower/metadata.c  | 101 +++-
 .../ethernet/netronome/nfp/flower/offload.c   |  31 +-
 6 files changed, 775 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.h

-- 
2.20.1

