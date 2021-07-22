Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D467C3D1F7E
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhGVHR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:17:58 -0400
Received: from mail-bn8nam11on2102.outbound.protection.outlook.com ([40.107.236.102]:43163
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230200AbhGVHRz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:17:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RB3MgsdKe6AU3fYsKSDLzUsmlZtITHqU41wk397omCWORtoOVzwTKE6MJbl2FWpt0QmbilFTLZqhtv+mzVUNIHtq9sz8HTtBSuWXwTYcEfX2sCT1ueEeAENSUSLyjvwoEAM0oVtxcPXMLXVtM3KOwADh6KOZGd79ynIVQIGWuGFIxCmgf19fdY2mPQ1t6hLhS4sYZHqTCWkFdiYe5rJIvZtXGBf6V/7oCQLyH8qWikupW367hpju1a6PYF1L3zqg1F2cucdakzdl1OFj4K8a0SlfBvXWKJhplG1V5neB144ns2nyVs3k5UczcM2iaFQKFNaO3SVcFL4wpdx8XJqp7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18OkfpQGojUDy7oHOAZyPZy/UcDTwIpcNfvt4O/5oaY=;
 b=UAYxhCyMOerDXZIyp/M5o+tFa6H1dKwf486OSP2PCFO2F+W1GUpx6HFPX0rDgA3XglIYpO3CaMbZOSSrrePfSAiZeO0aa4W8nCX2wy6m7GeYsgG+jj0nnSq/hqU3QrM3QYo6DQREtkxvLOl+dYG9oMruQWoNYAFCsMWxALX4QB4qKLiGk+SeGQ5SaewjNR5N/BL3Hlz0OICl3MRmuACzPCZDy/VmFmCLcQZl+3ODQhFhdjpByfAfhXSTaFE5WFb6KvWjjsmXPrJjrOZmnP7q5cHy+uNoEAG5e4q7onWwsfKx/DP9VKHoBHsCjPD8Bvdrp3Nz7ribhTnUQp6dxcz1hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18OkfpQGojUDy7oHOAZyPZy/UcDTwIpcNfvt4O/5oaY=;
 b=f2aO6MXQYbb4Gx5bqPGrhXOP1GGXKnEODoLd5Cwtlkjks3bOA9ps2+pAUqnzf86RFSjumg+kLeI6IZWrBwNJLzvrcn6ymZ/T0fvj16dvXXXa4jrCVfQXlb/EgJ/Ti8aCbX128uCSdQxFT6A7xw/uhHknN5IhVFPwbXHN50gzcnE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4892.namprd13.prod.outlook.com (2603:10b6:510:74::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11; Thu, 22 Jul
 2021 07:58:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:28 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/9] nfp: flower: conntrack offload
Date:   Thu, 22 Jul 2021 09:57:59 +0200
Message-Id: <20210722075808.10095-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0136.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b043c81b-f5da-4073-1aac-08d94ce67d4c
X-MS-TrafficTypeDiagnostic: PH0PR13MB4892:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4892088238066AA349457995E8E49@PH0PR13MB4892.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MlaQLMy6n5GDJIBA2UNaw045jQ0N5Z/ieuIPQt/wHdV/xluCekpXAyq50vsvKmM2dMJGQwUv9fixWcb8he+28bPlkmckt9ZzbK9hsMIan6x5txuvL/9161OpLqtCRE55nlkQBRV6l2zdL3gsFfJJhplnvDF38M/6RuSqwE0gV2Bp4PCoLfMN0uciUcgtcPJS3VfX9+bvhzO1Gwl5w1bC6qMu1DzwO3zFaZoYg/Cl1hwZnkeaMPsBNOlEPnVqmV2crE8LQrPtrZZfx7ifAe1IK8AmOGhKTeHK80Fm5uPLX7S5IacOqfDXaPlKk6lVvokbH0HwLTRZ6IEg3KOPMa1XAWKEupWB0uZbzIcuGsWcBnKLYmNSM+0uQloQIS1VD8NT08DlUy+u7fWlhARaQJ2eL4kfQkIKGCosMjKNba0S+MOvbwrpS/M1hVq3cBsii2R1aWpSdllR9yRK0QIDF/VcbgrQZwkoYhrQewkJI4b2KMAo1OWWQ7oBZruVNam+zMJszccCJvtx2tiL7wMtXVZfvBTH6q1BxorR9DlDR8yA5qrP826NjZaNmhAbhInqUMDIYRL/J9hMAyH9zsm+dFOchLIXWVI8lXmjc09VnaLaKaIN+rNz2jJuOFeSFnXGN859hsEPDTG/S7vntrj8z7L3Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39830400003)(396003)(136003)(346002)(52116002)(4326008)(6666004)(316002)(6506007)(1076003)(8936002)(5660300002)(8676002)(6486002)(186003)(107886003)(6512007)(110136005)(478600001)(2906002)(54906003)(36756003)(86362001)(44832011)(83380400001)(38100700002)(2616005)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TlpV/B1/IfRaE7vfFD2J8dp1Q0CWNcFAM1JiU1rSGRwqAloeeUk5FcCO4y4p?=
 =?us-ascii?Q?/hmA79Q/7SUJ0haCZmn1OtYuuDKaojhJ0xh5/jubhHHO4zEEPsUaQjiQeVev?=
 =?us-ascii?Q?6+Dz5FM4LrRT2BvrEweE+3YcjNRpX6BycQBAmfmCniArdKoik3sohsM4UpcG?=
 =?us-ascii?Q?4Om1ZfKAjW2hbhw9V+tsB060ZEYF1zXoqLZ25uWygNolUdBVTCCyCawQPucw?=
 =?us-ascii?Q?uRP/Vr8YUA8Baj97wkESQrzMkx5GJ2ud22FpKxblXJDwmwCgdSAFwZJBoTpZ?=
 =?us-ascii?Q?jMdmbf8NgcJp65lVtsVIy+wMKJ34wx8mr/5gs4e6rKnFHM6gulLB7EmtS1uY?=
 =?us-ascii?Q?A5yxXg1za26C3Z7MsBjBRcIJK6aGzxzhEd9+2qrl+cEyXvYlZgtScrIQfY2n?=
 =?us-ascii?Q?EIBeXH5vTKzYynyKJoRayacLJ+tjmC1KQ+MGmObs9bfCcv/20MVRCNVOw1RK?=
 =?us-ascii?Q?X0sRucxyyo9E5mjIjFPaLPQ9aRkhl86LSetVQgAaTzz+Nwjj/naW3+KwlBAS?=
 =?us-ascii?Q?Ec1cYDTHZ1brWoF87+jn+MXRw0WxLATEbXPUPLslKfomh7IBNogL2v7LJppc?=
 =?us-ascii?Q?9QClovH9VqOzAAw6yEAcwUzaIj0tV6nHSn8OBDrCKodI4ddoSKgmo7YOsesN?=
 =?us-ascii?Q?Oryj0C9UuG3v/GGNOOoH2iI7vTyQYV51yoC9tzQWGTqOd0wqG/l11QoST3bN?=
 =?us-ascii?Q?exOCfMDkI5jekIMkHY4V6jX1qv/2FfOATPNL3n3xsvQQEkuIi3J2zyUoq/oa?=
 =?us-ascii?Q?bwoEGB5f8Z6bKcOxM7AEdNFEGIi4KOcXD30d53LFWxKmvqxxSU/EGJ09fUE2?=
 =?us-ascii?Q?TzaF+jOM7X4cY0kXx5o4boyizkMLVUqKJoeEnCMER4t0Y5/dcsXlbydb28a3?=
 =?us-ascii?Q?zJimvsyXOCA5Z88sinkcHDV8O/5GwnO2i4TxKVbTPZjBanyvYN8n1/uPSvG8?=
 =?us-ascii?Q?PULtCTcRZVB76kX/kuM+f7RVMVrFlDXgcYQjMnZjvAbyrEBy+jOo468MrrNk?=
 =?us-ascii?Q?VwQo7UCmWR5Ge812Jm7VHxi4w46dSpEDzEeX0xA7xs43a8ax91RFWXnw2XXR?=
 =?us-ascii?Q?ny4Cyt/uv/UfJxIcMUj7lsl3bvhxCp8KAGA5HnTA3auKzZRCuTwIHTPJIhQ3?=
 =?us-ascii?Q?eGUCX/nHeDgPxoZzEfpQsyOXHXrOT8sSNf4h0hD9dkoGjMPoJjGlBgOFpNUD?=
 =?us-ascii?Q?DPc0rX9LKMQvXqEf0wQ5vNk2mERnHzc/deJo4gTSemHazJpF1B64FdyF2Dh2?=
 =?us-ascii?Q?OWEpkWCZ8gwU2nm/wzeLo1735qSnii3udl4k4LIYIU1Pe1+zwSsj/pdPrjB4?=
 =?us-ascii?Q?kMCW0fjsqSTIAvV3+Owv3YWhv8KJlxalvRzVZK8mDr/C/Q88DvN1HX7K98CT?=
 =?us-ascii?Q?C9lyyHQFpDiZvPmQAxGDuSXN7/L/?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b043c81b-f5da-4073-1aac-08d94ce67d4c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:27.9179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qhjfVN9MSBChbwfDUl6KDndmGIOTKpAdkXzKnkCFwLZAJMoYlbE5GXACbjYl3JiFwRDmyD5nnclKf3KqKpi/wrN81344GNRpgaUFhmVzoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4892
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Louis Peens says:

This series takes the preparation from previous two series
and finally creates the structures and control messages
to offload the conntrack flows to the card. First we
do a bit of refactoring in the existing functions
to make them re-usable for the conntrack implementation,
after which the control messages are compiled and
transmitted to the card. Lastly we add stats handling
for the conntrack flows.

Louis Peens (8):
  nfp: flower: refactor match functions to take flow_rule as input
  nfp: flower: refactor action offload code slightly
  nfp: flower-ct: calculate required key_layers
  nfp: flower-ct: compile match sections of flow_payload
  nfp: flower-ct: add actions into flow_pay for offload
  nfp: flower-ct: add flow_pay to the offload table
  nfp: flower-ct: add offload calls to the nfp
  nfp: flower-tc: add flow stats updates for ct

Yinjun Zhang (1):
  nfp: flower: make the match compilation functions reusable

 .../ethernet/netronome/nfp/flower/action.c    |  35 +-
 .../ethernet/netronome/nfp/flower/conntrack.c | 616 +++++++++++++++++-
 .../ethernet/netronome/nfp/flower/conntrack.h |  26 +
 .../net/ethernet/netronome/nfp/flower/main.h  |  79 ++-
 .../net/ethernet/netronome/nfp/flower/match.c | 333 +++++-----
 .../ethernet/netronome/nfp/flower/metadata.c  |   7 +-
 .../ethernet/netronome/nfp/flower/offload.c   |  51 +-
 7 files changed, 946 insertions(+), 201 deletions(-)

-- 
2.20.1

