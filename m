Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F78A5BE9DA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiITPPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiITPPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:15:30 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90485A835
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:15:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAl0HZYbOTfj0jF079Y7tmXnBqpDko7owaSIJZqLDM+fmJWRwSx9/nJ6n502vpqK/l1mIBl0DVXI53ekR830ZDttcxw7QNnD3WWkhWpD7nrpNF9k1qVShvXdq9TCvJn12Zne54c+CXI3Z0W0nvlb+VFwTL9JggcOQL+mD25/oLvkeKuVZYdfafMBlHTJuS/+51oj94xzjBvzhAKto7fLkJePNwFziC5uMaTSWyskj6uniILPNgeZl9y35ZDsL5C6HRecD+qcO/CQ9UgHNuLXzUkyVxtrlJC1oxYkf1pSXW48YvTcyDVh97hjQKIB2ScSYIZFAXAqyBgoc7B6Jy4KyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4ICoY4aauXSeeYS/sm2CgMpnWiWYnSlTR3rQlxk7Tk=;
 b=kXAGlB3XRcHxHbxo00l8iW0WQoGhZlcFW3hjZPrsI2zsrEpRbYoWkfnOk/eWioPlgtCUqRg6IMNHC9TEt08Y381P+j94TfUaqIbYClGjQpv09Q+QsI5B5Y7b0epRwQ9voFhpLn0wBJvzIzTyVBHg9kiNduJAWveFWzO9voeJ1RErHbLPLRbNjYbnWu2OxYPLYtHef9+O0oH8wVHMiS44navGHk7rAUj9nmbggqy5QVj9IrZY76qL2JNBoztoRBCTNGKnf3A+Lobj7nNT4zCEW+BjRK3ib0EOGHLES8iEILmFW9+YIzuXqTweGUJCeSICdZVEDujG6tSD0ODvvvUcSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q4ICoY4aauXSeeYS/sm2CgMpnWiWYnSlTR3rQlxk7Tk=;
 b=bGNWk5R/VpO5BK+KYJdXJAR7C4OyYhpTwE/99UHgdfe2wfrxWiEQuJE1fzaeTQdHSL/Ehp0BeQOYMypxdFMzTM0OvrwtxBTVRreHzm1T7Mkj7XDwQCMfMxUOlo6fycxejXrK1pe0kg6CVWkCiKL54U/aov7EvUybymQJm1E+l+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5301.namprd13.prod.outlook.com (2603:10b6:a03:3d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Tue, 20 Sep
 2022 15:15:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 15:15:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>
Subject: [PATCH/RFC net-next 0/3] nfp: support VF multi-queues configuration
Date:   Tue, 20 Sep 2022 16:14:16 +0100
Message-Id: <20220920151419.76050-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0064.eurprd07.prod.outlook.com
 (2603:10a6:207:4::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5301:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c74b0fc-e254-46b1-3901-08da9b1aef35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yYXuQp5mlJV7xyzAW+dBIr7vXQVSvJuzxnVM2r3WlvTPEWfSVogGansn9rUP6ZMrjNw3XQEHmfimgZ3GEJgPUQ3GLtI3VSIQ9V5W/sIfoEn+XPRKyDo7zEr4cPPXBatZ1McHhrfjscd8HGD3eENKxtozKzoqsCHMp0jHGNWceHSgTjepi1gVIGbkJoU9gK7PI3Koz40K8s7i1/jngDRUypE5hs037EJ3wqebtDU0TdF2dvl1ddlPSfavgVc5u37iNIFbf3EV6PNqDBLJ5o3vFHylTlNNHctk4fPKhYhxP7yeDMOkWrbXYIreIGQ0OJZsYE8nli+aWtTR5d7HArLkJnas2QSF1apgjgC8e602mHiGrFocKVE1PubBQhFsf609z1Wy0ZrHRAH5wnAdzFCRg57EHnj3+n6FloAUxTFYHSsOyqtfOuLDd8O/RqNDKTGQSb3hSaqQLaIBMcavebrDg10JMp2vbIk765d66h2IPfAEI1GbwxV+il+dgcbBMB5X4xj6IKTTdfsD9khozlMgtNY9AxHGxZVlvwsvu2Bv3YmUg+cHklbctGtFkD1Ynfxq+RP0Kxl5WJBqdhG8MWcv35HNG4wI8jY9GWCsOF4BF70Nuih7bP/CaXVyn4B3GAijdkj5juGPLLFwTcqc4Lies9Xox0X+lTZFyXFZyQmBZp+eLmEyMZrx1JJUbDgN4vv7yOmIxIPn/nB9sAxHTivTJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39840400004)(346002)(136003)(376002)(451199015)(6486002)(478600001)(186003)(1076003)(2616005)(6506007)(6512007)(6666004)(107886003)(52116002)(2906002)(44832011)(8936002)(36756003)(5660300002)(110136005)(54906003)(316002)(4326008)(8676002)(41300700001)(86362001)(66476007)(66556008)(66946007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q6K0ZgvhBYKQnyWnI2EZN58ZRGB4qnHwnU7wr+nudxCR08l6EWGwnUS7aJK7?=
 =?us-ascii?Q?a5E1XNGThs5FHADmlUbU/UgjVcyshRC00+GetCZ9b/S0JGpUWKk6BmE3YkTl?=
 =?us-ascii?Q?ujGTOrV7bBSfdwVp//60TLf2saUJhyM31s0jtgXiqf6kNrcY6DwtnTjPZfu4?=
 =?us-ascii?Q?GrcvMw8btohX96BXNYV2d6fwZduOiB8/a0ULpuighx88emFhJZ1HNylr0ZVE?=
 =?us-ascii?Q?zSlR7aDJIaWOAvAUZaIA9AQy+HTGcnu3f4DcJ7Y6kA80nB+6R53HxcNU83Us?=
 =?us-ascii?Q?8s2gmukhrJSbuNb9Ub/k/mQy3WMaYfNXIO91XmzzzVAnQj/DB5fLW3N5COtY?=
 =?us-ascii?Q?230t9HOFPMW9xvk7FNU+n7f7ezERZKVQ8dhTX+T/l6QchufAnLuegZ/v4rPp?=
 =?us-ascii?Q?4Snjpp1o232BStELjYkDF7YTWwZEEaFBOfA/0o4GPnsYRHFw29klA9Hb7vBL?=
 =?us-ascii?Q?ZIBXMbGNQHUocRJ43jeDZW7VyuSE0u+fy/wsR9Z1ep7CKaaWAqvARHDSgnAA?=
 =?us-ascii?Q?WVro8gFE/Ni08+UxEWW/ikUh1Mv0jGCQE0QhGfkiwKN9YNaSmsVsYeQyll/M?=
 =?us-ascii?Q?++tyfQS3RPKMI9vxvYE6iLPSsDvmrKzxxjltL08Fxs78lowXQW4gIyDes3QH?=
 =?us-ascii?Q?5Ucff5sqMB9MoZGPug7H9cFa4WZ/0hm8JbI7Thl6DgzzktdIjeXCUOeIQiXk?=
 =?us-ascii?Q?Rwm8DvfqeZbcWG94hORg7N1xvfhsK2q+07f3s1J3A4sbAFmngc9TBXb8EbX5?=
 =?us-ascii?Q?U/5nAU7WFSdsttfm3Wn31FgRPjt/fmW2A0yHpb55ATbfrszg91ThRhq8sPEm?=
 =?us-ascii?Q?QGPCM1YHHEOtzeQUJ6kNLYigsM53+78hYDReWKSywiqOj7EBUdZ4OQNSQoli?=
 =?us-ascii?Q?lrviW4/kKoCIgEJAFTfwZHD5fGbPu7l+Vtn+TNeBoyJGBS8X7bAIC31WSprm?=
 =?us-ascii?Q?uyvAcVtGg/glL9j5v4L/qyevFxZPrKt7dfMz6DOxy8E6OC/LuDAdFVP9Iwt/?=
 =?us-ascii?Q?DWUNQwSVxmzzAexCAx8CoZpgzeZ/ihEjiOrICsECz2nCPeB1el2FUO7V1Tub?=
 =?us-ascii?Q?vFsOTofzQOfow5N2GIo+lcmE392lttYgVPRa5ZCBUdxjMMvniJACeRHSOF+y?=
 =?us-ascii?Q?GPb3zBn7OKUMbecpnRi63yIYrG81M/CiaGAaxvdDdXZ8WveoXGT/s++SmmEg?=
 =?us-ascii?Q?ffTsHrYWhfpVV9rNeNuXbgkqKDTbVWdnifji1diFE1PYt0QyrSCvgOy8A5IL?=
 =?us-ascii?Q?WICKZ24oe4iaFqV/mxUmlv+BIGNlYOCeu4UMWOFIle6EYP2RlSJikj0MrYdp?=
 =?us-ascii?Q?VyQXQstolUto/2nXDIwtpPAprk0sRg1RT1Kr4gpe3Jh4o66cY5zqSW7zSk/3?=
 =?us-ascii?Q?xM9kDsozoMOX0j91Vf12vtNHIPWXpS6e0IXfW5yswUusaKsv+OCy1NmJbzwd?=
 =?us-ascii?Q?XJjpYlGrN7PS7xB8MKFMI92G2ynlaqBoM4D/1kkI3nj6IRjL4+80ZOfbCgQQ?=
 =?us-ascii?Q?ahgcpEF0wpDIyM9+0UYQNHi3UMvrpiH6irLNtUGy+sA+f0O/kbx5YKKvFixH?=
 =?us-ascii?Q?0Xdpp3kirxthBLGSA23NQKHvMR2z4PQT+n62x27oD4s+EmRTpSFOgi0k1vJa?=
 =?us-ascii?Q?6WaHdtijV2QCdBwpphn88vDeHmdKxodTxp0uAxuX4Sz2ADsNM4ez+ZrHzzof?=
 =?us-ascii?Q?8zu95g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c74b0fc-e254-46b1-3901-08da9b1aef35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 15:15:21.4949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Po9kf3eXlQIL+nqepsrzUZJBh/kI0VlDMuoSq8Qjh6zZm77KQfW0xr+94K7fDwokDpk7xDtuVbhLB3w4BdKQM4FPWC6tBWijvray7Ox3qnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5301
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series adds the max_vf_queue generic devlink device parameter,
the intention of this is to allow configuration of the number of queues
associated with VFs, and facilitates having VFs with different queue
counts.

The series also adds support for multi-queue VFs to the nfp driver
and support for the max_vf_queue feature described above.

Diana Wang (1):
  nfp: support VF multi-queues configuration

Peng Zhang (2):
  devlink: Add new "max_vf_queue" generic device param
  nfp: devlink: add the devlink parameter "max_vf_queue" support

 .../networking/devlink/devlink-params.rst     |   5 +
 Documentation/networking/devlink/nfp.rst      |   2 +
 .../ethernet/netronome/nfp/devlink_param.c    | 114 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_main.c |   6 +
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  13 ++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   1 +
 .../net/ethernet/netronome/nfp/nfp_net_main.c |   3 +
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 101 ++++++++++++++++
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |   3 +
 include/net/devlink.h                         |   4 +
 net/core/devlink.c                            |   5 +
 11 files changed, 257 insertions(+)

-- 
2.30.2

