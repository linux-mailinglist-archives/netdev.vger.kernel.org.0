Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F86542C2B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 11:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbiFHJ5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 05:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiFHJ5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 05:57:24 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2096.outbound.protection.outlook.com [40.107.223.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDBE14AC81
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 02:29:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIrHDuzIw8fe8lNASZTBZymaehrdpi1A222mxdrm4tq7GlD3m0Q0LVYbHG9XUdRZTrstpzVx2bIGBM+be4BFZF9hJwzIZ+iOUm44OlHwW6x7mdYsLyZzOAlmlGFdSKxUPl68Cg0NPgYsKjtjiiIrr1EBEkdfeP1xYrCSkU0oZ+HbvljlYm3rakQSS2XESZdWR++v6W+DK/sWXMi5LPIl5mXtlXexbwiAdMKJqBhGqMcu+K75yYU9nFeqbZIvVv2VMfiEpBNh6votlOQHUszqMZx/erKglrBUi3XzYP1riP2Poc8yTSbp4xgO90cFfpy6lODST98UAnpu4wxywBQETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4FeN4TnANnBKogKQFxjNNeSBMiiluax9+A/X8Pc418=;
 b=VT83fvP+/yY7DwNMa+7QsmMRFhw3iAenBZsrsUVZrD9J225AUSu9BZyf3BovxW+vUEk3t+hFXfeOYt5stcgT8rrEZUT28ZGx3Cczrt7mOnR+rBd+s1gEs+DBU5lXywdKibeQJ9rJe4ki9cq8amA6EN0cblGK7//aWmN61ByP8CPDyLXSpxKs+93SkQZJTddDIsENp0s5hHvKnp0WbpqavRYiGScOcFjmQrX+uKK2u/ITeiVH19hIqhWoDnWZ+bCSgcx1DOzKC7+dKDet2zxC5DLtbhAuLSmO1YLjU3Sf67+i+DmLsEkwvT2OZcXHS8Su4bjGjdlJPa5L6447FtF+9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4FeN4TnANnBKogKQFxjNNeSBMiiluax9+A/X8Pc418=;
 b=jN5gvifIQkfsSaMXs26mCUE1PQAXwXoXJ2t6sn5rQ1uPEV1c/DHhbMizmMjxN+w86SYfhsXjig+bigA9G6UR54qJMB/IqK4Qo5N+ODEfiOslhsA9jXTaEJIKb60F4WYJWolI/NcOb2v+NR3THrIfo6as5FfNLMUl2CUagsjATO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5575.namprd13.prod.outlook.com (2603:10b6:510:139::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.4; Wed, 8 Jun
 2022 09:29:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.011; Wed, 8 Jun 2022
 09:29:52 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>,
        Etienne van der Linde <etienne.vanderlinde@corigine.com>
Subject: [PATCH net 0/2] nfp: fixes for v5.19
Date:   Wed,  8 Jun 2022 11:28:59 +0200
Message-Id: <20220608092901.124780-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0071.eurprd07.prod.outlook.com
 (2603:10a6:207:4::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b80bcf86-5956-41b7-56b6-08da493170d6
X-MS-TrafficTypeDiagnostic: PH7PR13MB5575:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB55750CF01841EE86AD18F3FCE8A49@PH7PR13MB5575.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oFYW6593Ag59vxJYtlKDzZLpuAmpHuVlwXR/kol+PtBVOwRBXoVOEkyElzMir5Y8BI+udFlhC71eAvoK50WcE4daqaDTqPwEP7D6DUL8iwwmnL36Gja8nMipxNgDs0xWJZuDJsskujzyq4YmyFk33i8bM2qVkYwT9hgavF8YvbbHuT0LA818yO8rqfuQwNVm/rPQd0x5Iz6lyUTK+KwBW4isCda+Osv6Ri1fabelBG0W8imc5FvzUZmRc/kxnnxhdsr/S3WQLb8fzoNh3iEpoE5fF8mk6Pb/e687U1kPbfPXqDDvbuiP4hlBXgGNFPVwhIfWZYt3zokZXe9MkjKl1lo8MPl6wBb5mHqGIjFIAqOfytJJkdZuFhoZy1yJL2Vcxug0SqTAyt8pgo8n16+MyA8sji7j5YvONUI5gcG6xI+PEsQ9R3hr4eX3MeJ7Z8j+YVwrUPUr4yM9QEMcnXOgRcpVsWVeZ4tY71F95akwPhVGip0zn8pKMD0HL5NbdyHOKaZQN9MicDBFVRWNT9l59pSV6EB5YoMz7yQFsxBsxPPunJBXTZtDt+Zf7q0zTZGFKfHZ4gOvZPvASIhVlNVQxXIn1IQsPMdBOfRt3E7d4aKacyoqAjz/++cZejPc1VABZ8c0HChskJaLZhct7DTLqpGt7rscMvdnE4XRVJ7rbrIxjFylJ1JNvX1Z7l3O0JQ6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(396003)(136003)(366004)(39840400004)(41300700001)(1076003)(186003)(508600001)(8936002)(2906002)(54906003)(83380400001)(4744005)(36756003)(6486002)(38100700002)(44832011)(86362001)(2616005)(316002)(110136005)(107886003)(5660300002)(6506007)(4326008)(52116002)(8676002)(66556008)(66476007)(66946007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SnvONDewsMKAvd2kp68JiVT0R43ZyywVNCx6CGk33BzNv1riHfP21jpGeh7+?=
 =?us-ascii?Q?RC9GrHiEiiWEzqSXcS0aVy2YK3vtxiStQNKvuNbjTH1tEgOfEBVtPI27+Tz+?=
 =?us-ascii?Q?MSMFbqypM5UxbmUjG1CbgMMGObRfJhYTwhReMlgMdfra/5sjAgHhdZLltf+v?=
 =?us-ascii?Q?0uKGfFyO5X2yMNz7uOA4GfsX1g37wEoHA+F64nSkT5B8lnmi5M/obKlcyZ6c?=
 =?us-ascii?Q?S57c4xQlcQzctLY7FfKozz2YNPTFR0jGzJQTIR9vb7N/WXGx9dOtethX9zUW?=
 =?us-ascii?Q?fGzk6as5KmGpQYHKFS4ZB8eDhmNB7uaZ1XO0cAQ5mvFvyPSLYSSADppH9Ubj?=
 =?us-ascii?Q?V7obxzZy4kqmYk+HVs+yh3ordkIZETXErbk5UMbuJjzTm86kwfSG6R7B7fc8?=
 =?us-ascii?Q?2oWVFXDGpwug/4YgBtx1JKcn7/OEJDPiYsTsiD7M81GSsW/RZLHphasIm7YV?=
 =?us-ascii?Q?n2R9Ovx1Z64NtdS0nJ0cj104D5aOJ9shyduL8f/pmOgZplwdMsCFCD6OUeIM?=
 =?us-ascii?Q?pC7fFaZ4vLoM5pdqvGkIgfDOR0OBVReiFx3z+E4UbaJp8rfHQHr2nM0GPZYz?=
 =?us-ascii?Q?WXeeAuY62tmynWWQpEpugN+YQ1zDF7TSFJ8XYikWVoTKiRHZin5spsfnZvTg?=
 =?us-ascii?Q?3jzKk6YDaY6y2FJf1+x2UmYEIsn3zKaQa7wopvMi7m7S1sCgzo6SHgrKIy/n?=
 =?us-ascii?Q?L8+ogciVYisFXrgRId+HFWbMWI76kvLMxlQc7MvqoKcWfClw2mkubaoRppdj?=
 =?us-ascii?Q?wjqQNMsUEC884DObfO4ZFggGiQyVrQCGoesKqv9lrhvfwsRHx5SriGuVoNpS?=
 =?us-ascii?Q?9aSzDzV7QPP9PuQMb8pakxxdZua8TTTeKz/NKUCSz590ECMG7k2TF2X2aCd5?=
 =?us-ascii?Q?Qb3mSBPNZ4tUJuAbHvIFKyLRYa+dmQkqToArNLaFrgQprZO1Yy85ylGaX6St?=
 =?us-ascii?Q?tMrqoA6dwBlx8z8wG+PuY76iNxosKBH2nFHXzzxaFEVN+0HafWq5gHRtC179?=
 =?us-ascii?Q?eYBKfQ3F/Q4Ff0V9AcvI71KsLPCXqz/FP29oWF+G2De/2Vn0a+QOCTFOakC5?=
 =?us-ascii?Q?c/xO/acyd1KRCMVPTfQvt29UvfC3WGQOsxB3mNqbQt7s2rQ4dGEv1pM+LTDD?=
 =?us-ascii?Q?kdgnK61/yoHPUId6qJiykfxUlUISj+g479q9j7JM2ssktNy0OeRNrDyfA5T+?=
 =?us-ascii?Q?XLjzqx3sdj+FdGO9Ji7xWPH79YalNCg7PPsyjj+QIdZjFB381uzBtEkKfKF4?=
 =?us-ascii?Q?zRJN5n4N9oI1gGOMIMXArFOIA2pShhTRGmBUpPW9GXBsIowLKBTnff4Ee0EV?=
 =?us-ascii?Q?KwGN6xtTihcpH2/C+t7SHYptwZt7bpc5IsNkR15QgiXoZy5CYe3aAluXoBvN?=
 =?us-ascii?Q?65NYAPbZjSTAUFrH/r/IuIAL6/ak93UfyUwfrBKt0O7uzRDFTbxJOTwNt7yp?=
 =?us-ascii?Q?VIbmrxTjsBQ+YfBtgS7KtMODC+yRYj8G5TmvC9aDZiazehrwWM+uMWvouVF/?=
 =?us-ascii?Q?tbcoTPXuhBUuTfffm1NoQipQ/KHNHYXAzG62Jv5U2KMkTeJY5jKBtq+hSVxP?=
 =?us-ascii?Q?q3MfYbB+0mq4WjgNkyejciVqN5ikjjPi+o1Gio52eRxUUAIGE9yN+ZdPcCT5?=
 =?us-ascii?Q?GbTcQj+TlrOdJOzKI5w63Uo6SaPmdUsl6Z3kemJ/DelzfsiC4p9mLUSl7d3c?=
 =?us-ascii?Q?efyMCD32fgF4uIE+PTOUEzuM0V6RzlVo2wbjDtN3tnfJEiMk/I/61735NLJ3?=
 =?us-ascii?Q?InM2IJUcvxJzhHfBZR/oFc/evzklk+tm1s2a/+EoP39bI02aGwKqQqluiH4E?=
X-MS-Exchange-AntiSpam-MessageData-1: nhO+vbTTGBAZNdgt89UBcfM+PQfmLrpcqn4=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b80bcf86-5956-41b7-56b6-08da493170d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 09:29:52.4322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e43JvwjT/ARcPs33yqY+nBlFq69VQ1Mycm42fCRNTSRZ6Ca6rC9qhKBHFDnoAXILNCEB+NhIdl5snUdgp5t6QNiV0M3+t1htxbgi1N/gTJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5575
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series includes two fixes for the NFP driver.

1. Restructure GRE+VLAN flower offload to address a miss match
   between the NIC firmware and driver implementation which
   prevented these features from working in combination.

2. Prevent unnecessary warnings regarding rate limiting support.-
   It is expected that this feature to not _always_ be present
   but this was not taken into account when the code to check
   for this feature was added.

Etienne van der Linde (1):
  nfp: flower: restructure flow-key for gre+vlan combination

Fei Qin (1):
  nfp: avoid unnecessary check warnings in nfp_app_get_vf_config

 .../ethernet/netronome/nfp/flower/conntrack.c | 32 +++++++++----------
 .../net/ethernet/netronome/nfp/flower/match.c | 16 +++++-----
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 28 ++++++++--------
 3 files changed, 39 insertions(+), 37 deletions(-)

-- 
2.30.2

