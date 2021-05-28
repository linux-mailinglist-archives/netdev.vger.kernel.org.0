Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EAC394457
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhE1Ooj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:44:39 -0400
Received: from mail-bn7nam10on2112.outbound.protection.outlook.com ([40.107.92.112]:16320
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231993AbhE1Ooi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:44:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvHCeZl70OxiF1J6h7szJzsalqPDFYsBfq1bJZP7YshWQOK1t6DnzIO5ZkJQ+ONliy57jMV4/urnwZ67UzdBuBvoyX5N1k2vFEcy1yb/EnXw0iepIcqKCdRXSMOg3zblNf1ThzuvIl8kXaehrqJuAjAOQ1JWL0OcElATU4BRupHfooUJdI2e1BoRG35IimYP72QqN1+qyEncMhb5HV6Ycp7peMMDa7AReIieI6w4XuD+I6+R2r7Uf5pXbYR+G18UrS85vOA+9z7DlLnqB3255upru7Q3FDYRN/q2hn4mPG29T3pwCJ8QUezYzIJes0DmNNGH/MjIRJoKExFC+2WgKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6MTNpAgecgSub2XNCKlfCNejIKiKnTUvQ2dUlbeGgw=;
 b=QWjKJdUiZphweBoQLUH8/ChKTTE5noB2iPFzPLYUOJVZPM6ci9ATDmFb6t+zV2I+oyoRHPzkWxtLg84dYXg1MFcQ+ycsmCIgoXW7EGDzzNjNR8JMbemCUTm0PKRfcPGmnc163XA3FsUSr8BucOPmK5ygAU59TSdQzAHdEoPI/dP7kE4Sis8RrAkYoOnDRBX6Rmktv0odxB6clSlIlSfVU2OxcjZ3JrjNxAsPgDROVpvRs7fLyr/rmaRxYKFyzLlm1NsiO1baW+MRzdk5NOxl0ouc1HOlom7iq/+PMQmZlFSghYqFgPHvb3Dt7TiJMdKG/UkEN9IwXJLx+P2aULi3UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6MTNpAgecgSub2XNCKlfCNejIKiKnTUvQ2dUlbeGgw=;
 b=YJXAeI4m+JdrvZRIQpQrwENxGmxr/kqOA14NvYOieOvqVKZHvdp0+j49KUcYyUIy28AalBjaioTzYr9/4mvgNfQlSNe9AB9+q0UcP7g7iRvUXe49xWMvKCG/8e4M4Oh1FOaHnRL4RdcbNJ7+3PU6ea+9V9+kVR8T8gdgIPjgNwc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4889.namprd13.prod.outlook.com (2603:10b6:510:98::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.12; Fri, 28 May
 2021 14:43:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 14:43:00 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/8] Introduce conntrack offloading to the nfp driver
Date:   Fri, 28 May 2021 16:42:38 +0200
Message-Id: <20210528144246.11669-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM0PR01CA0164.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM0PR01CA0164.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:42:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81422ec4-0fac-49ed-f92d-08d921e6e43a
X-MS-TrafficTypeDiagnostic: PH0PR13MB4889:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4889346BFC2603E9ADBF17C4E8229@PH0PR13MB4889.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nAixoV/Ht/UhxZT8O33y+2xbvHL9sf5/BwsSWOGPzikFKYfQA8IsxxSMWlMKR3+9DgUuV2/qmYa2/6yvglfSKwZ+7mPSwQswtoPNz83QPL2mxiMROIhS96D3KFMzONGOTVcgcw5UH+L717bcWHv1MBr9KQVGr2Rn1lOvQf478gn2DhJvBjka2tye0RovfX+aP93TkladvXDve//AzMUBktgD+AvixNrhA0uuh/b5jaBwW9YYXbZuwBCuYJ9iI+UH9h7Hk2RGn79bEFkvojqlZHWynYhHdC6XKkUCEP9e2PRFI6Bcez3WPXeu0H43B/zsbn5fdH7Vv7vsQfkt24DBoNNtASo6Z+SyGwfTGDdb85s0HthGcagH3TzlCnzgPQaDRvB3WCGlVOByWEMJJop8gPIPj90yluCeuQIc0nhDBPQl8a57GuKHL+zX3/TtgvI80qGP8WIcfjKr5Bly30/pFl4j8dGi25+7JIiWTFxsYKaLCWQaG4ZJznL17FKZ/6fZES39rwfDwHQ4GQz1wr6lphqz+NGr+gPfIuGafanJlHQlXTaNgKLwKOBU1d8vz0fJ6drJ1Zx3anXU39TLv+ic9awm07eczusHMbqz0rNfzvk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39830400003)(136003)(396003)(366004)(107886003)(2616005)(8676002)(1076003)(52116002)(5660300002)(36756003)(44832011)(83380400001)(6506007)(186003)(16526019)(38100700002)(6666004)(2906002)(478600001)(86362001)(8936002)(66476007)(316002)(66556008)(54906003)(110136005)(6486002)(6512007)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bNOTLyagx4pPUSvG5HH39gs8yj0RzlxbQEyYugNEUSA79hetfQ4ZzyE7x0Ja?=
 =?us-ascii?Q?uKh+ojhKP3/ReC6ePNDEZHdscKkaeROAqXXUckiNyyctfB4aS0BnOIR0+5yH?=
 =?us-ascii?Q?lnyjMtRlJmoLD7riytJQWo6/GMrGhHebSYURwdG/V5hNHW7mC+eNRS7zoXYL?=
 =?us-ascii?Q?zTjCcNptzEHqjRiCBng5AL0Eh3eUAqK2LtZuhO49pLww6nsl5yhmnTEGpke4?=
 =?us-ascii?Q?xw5wD3G+3ykBqnx33Xxxm8RY+SBtbBxWevLy/4OhIjKgWKHhEC+Iva5l8PmK?=
 =?us-ascii?Q?O89RuqbA9Sldp5hdhC7uHsdXLIppslLQVPjzyHug7CY1S8X9tDK2nENfEqCq?=
 =?us-ascii?Q?akfkLt1XKRLzEhKFCbo3tSGy4yM261GniWd23gnJzZUo+24AD0nsZl/K9igS?=
 =?us-ascii?Q?j/H5sfabzDooBPF2k0E8rm3EX1CWVJcn1KyGgnHfrAvVSsPav8kNu8TTN+Jp?=
 =?us-ascii?Q?dsfPa9rch5PURUPzwRX21qliKFUJjTe6TnfY02phol1IyP0VFkgD3G08zi6q?=
 =?us-ascii?Q?YnvLaxRRVMNdu6HKTLKFqfh0G8TDK6cXSPab59SWwGe8Z19wCLaUg0iOoim1?=
 =?us-ascii?Q?/schTjU4i+SeE9VDg0G2fSeW5FUxy0o3Kr0NhTZvx7w/Hg+PMllRmdclw5j+?=
 =?us-ascii?Q?sq/OCzZma9nai5gbBbdmDow9jegO9hIZ2Qd3O+Q5ZJpGmJ56QaGX8wahCwvZ?=
 =?us-ascii?Q?0yEHUPFcucyadq4kS7eJZx8teXe1C1eM3ouByY1jDgMWEUCt0LHD2C6D1RHe?=
 =?us-ascii?Q?p9pWTiWN3WiteR1ki2/0nZ6iw8vz0i660TySD2JgFjr1Knkz7aId04Mj11rt?=
 =?us-ascii?Q?vQPdiucff69QPnmvfpVo/AtGpVH1pDPB9WEllBq7APyPB0zJUFqru6SE1RwZ?=
 =?us-ascii?Q?Yapf7ZhtYX0qCMTF3rJlm+YMAv2N4dLQLhzLkwwwVFcA4RrgVYssXuqB7RED?=
 =?us-ascii?Q?9sDHv/e4fTEjDCZZaoPZPHDiIovsu12K2DRJ3w9V+rDeUmtCSHJgLJcIjaz5?=
 =?us-ascii?Q?MtWun1kKfzw6vrYLbC9vvNeRcvdhqyjoynoMVhbADRPnIs8zaPIojHt26Wos?=
 =?us-ascii?Q?JL97dZcGWI9IS3aSjGXqmTQrh+qKjXOAwtQ60R0LUUoc9Ct9jESH/3QEFt/e?=
 =?us-ascii?Q?bQlbaan0doMnky9+9dKQEnoHEqwm5buCqqWnPCzxokPiZzeMV6gHPKDDHfPc?=
 =?us-ascii?Q?Eo6L56bw/FBuQ6gFn5ZkVzeEmpm31v1dkF9GtGa2wu0pEYImmpSzawDSlIkL?=
 =?us-ascii?Q?1fCpDQuGrriA8FXlX8lqww7IHjOJNjAa1Sb8orbZuDe7NXZQEzLxapYZMcMZ?=
 =?us-ascii?Q?gq/J+f2fqAQfeulS+6JTE3pDJAlBCTyYqcdxeoioAFQcdVnGejZEgERwnjSn?=
 =?us-ascii?Q?8Ua7tHgwAOmBtNdIQWRSg5PiE4Zt?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81422ec4-0fac-49ed-f92d-08d921e6e43a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:43:00.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mTa/JVQQv0/WbjNJmnw5OSrOv5a9ObIEaOUN9M5wDKxrrRyJ1KwaK2AUyrZvwhK4RiOHMFxM7cSFlNmKBgZjID5DCdKs9hbglTmGBJTEXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4889
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Louis Peens says:

This is the first in a series of patches to offload conntrack
to the nfp. The approach followed is to flatten out three
different flow rules into a single offloaded flow. The three
different flows are:

1. The rule sending the packet to conntrack (pre_ct)
2. The rule matching on +trk+est after a packet has been through
   conntrack. (post_ct)
3. The rule received via callback from the netfilter (nft)

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
 .../ethernet/netronome/nfp/flower/conntrack.h | 154 ++++++
 .../net/ethernet/netronome/nfp/flower/main.h  |   6 +
 .../ethernet/netronome/nfp/flower/metadata.c  | 101 +++-
 .../ethernet/netronome/nfp/flower/offload.c   |  31 +-
 6 files changed, 774 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.h

-- 
2.20.1

