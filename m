Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B0D6E7C3B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjDSOVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjDSOU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:20:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6D9BC
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:20:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSiyErkg+MRtx8NXvibbBZwt+Qpg+8/hNaN1OMwbGIkhEIKvsD/NiD7ORDcewgFOn0Y+tX+K3nyb2+4bgXYDfQAubGxq/xvQD1wJidkFpv9yp1VpLTtWt7QnKEYLoQcQqA4P5Oev36ycYALwLv6EiR5mhjjNyCqYzTz/RoC/JSh38euVO544YxGvI4OpUSSr7S3h5sFGIFUE9gu11NNfYq5uWD0muKg77JFIUI6KpqRlHyPPJEyG5e39QboaD5I1xfxCt67crbnyN6JgfC1fdxP+FI0gu3mCsNPQlZ/+IoV4hif0rtnEPdN5gqui5zJt1nuOFVALe7cBfvC9Mr7xKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EC13MxGxpULlRh8AtlUI/knCWwXSYr9OAY6e6xAXIqA=;
 b=CE+sjb5Ta7giKYkEwwT/fAaVEjZiQHxirPwWt/StdoDCFZ8+cWz650M0K0AYg9Yzr6o2ZJ/WOtqATQcaVYRnM23CsF/GFOwvsrB4MyppwU2WaEAGnHK7yCygO1pVl1YLYAsPrgKU/Z2v0PWIcYm0tkf5I3KqJR735p61HTgEwelWwZu2r2jg+3NRB0R24ct/yKmWzro35aIC5KHkmmh06tPjeuH8CHO7JWccOeKxqJewhk6VNbAocDNcl9tO78elkX+ncCeGEjMcCfsfFb9hnTHMGZ0mHQC7C2W/AXBDfE1jMClu2HurBA1LxBIZHxXbj8ke12Lz10HoorVSbR2WKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EC13MxGxpULlRh8AtlUI/knCWwXSYr9OAY6e6xAXIqA=;
 b=ktSaoTMYsu+PUBziuwZHHWAZBZwAMZA4m2plotd1TnygPO13Eks5XqlJJBiS856YQNOMT/48oSCIQfMCehwwlvXMpJpM1wKaN+t4Wpu+KgsUYhyl+LhVAQSS3cHdDfqUIXzIcxwudAeuZp6J9YJkgxpDpnK3I8crLjIKQ3tw5pk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4128.namprd13.prod.outlook.com (2603:10b6:806:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 14:20:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 14:20:51 +0000
Date:   Wed, 19 Apr 2023 16:20:45 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        aleksandr.loktionov@intel.com
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2023-04-17 (i40e)
Message-ID: <ZD/4vQopJY6k2hA6@corigine.com>
References: <20230417205245.1030733-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417205245.1030733-1-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AM0PR04CA0006.eurprd04.prod.outlook.com
 (2603:10a6:208:122::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4128:EE_
X-MS-Office365-Filtering-Correlation-Id: 928eeb59-e420-494b-ac89-08db40e14786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eU1XU3EhYKcozysUsNUxaD5mdLd2dXQ7u/iIsy40U4WoI/L651n7w6n1LX064YIG763uE0jTS582H71kuakXdO5DMrl/dzgHbzn1DEme7VaZLk6mp7phKsxLJi7nncsvaBlz14uqyDtHgPlxRuHY5Qa2iF7m8MPN6jbHiyejMoZta+LmE7K2kupVXA0Ecd+4J5CiaAt7pnCji9ZSOPr7xN+yvfg5ytktdFz7EVtffZhbwK0ZyjyMQmDSS6z5gP47gCfFxVRjI9Rv0pZsv679mTwGyC8DpcbNVZpFXtb0AODNQn4tPDxtHOrErhDVNPG1YJtGadxbz5ziws7sL7FL0yFnJiYAQXT8SkYQ80JV2KaS5dhn1gXMPU2AGVPcJGF2BVNNpelo1Wdado/mD8VJQ8iNM5vEO3YurUr7RP3Tij8Gy9WfUJLa7Dztvoaldqm/C1cahyTEEynzV0L4vaMIzUaQ/aRhehTIZAydrCK/kUQzNkrZ7PVlyonyHPKe1oRTnl4+RnqpiN5t5+hBc2fdWT+ZS06y9/d61EUg2pS5MtOZUlK/VTB2ub7N+AdbQkSu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(366004)(346002)(136003)(451199021)(6666004)(6486002)(86362001)(478600001)(2616005)(83380400001)(6506007)(6512007)(186003)(38100700002)(4744005)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(5660300002)(8936002)(36756003)(8676002)(44832011)(15650500001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gw19alpPOEaYebvyhX1k/5KeK5yC0qzllDaoRCaSPlnLhtXdn88KtfQvSg4x?=
 =?us-ascii?Q?IPsfOg4W/U61u0dRKudpYQlmxYwBMaxns/kJAVDza5Nr6JpZaWoiSEQtrxC8?=
 =?us-ascii?Q?jYkF5lyxYWCwDerLwq61A7FX5zcEA6bzAK16xGPDJ4vTtagxaibiqkElrTNB?=
 =?us-ascii?Q?z4/5H9twA7PznCP8MHp3bM1KasOSPMIUzZ/VzezQ8/nEzaWbQ+GlM/XQ3NKv?=
 =?us-ascii?Q?GOYkBaWCWnzHFst2RQv6cfVMI0JaRw8zhzfyUxnynDs7yjTPmtcbXK3whfr5?=
 =?us-ascii?Q?lH6okP++G/1VMjUoEQFbNOzs/d0oNb9e96ZaAaelasWUQgLNG4qZkvTdLCoY?=
 =?us-ascii?Q?3vkjbTpkRnbPWPi7AyzBgmzFTnuF3gEdFLRTVwjaEZizUQ79Okh1MMeHoU9C?=
 =?us-ascii?Q?b7tb6CzKwziD6vYsp6Xw5xtQPXKszmoeaImUdDVbBgaCBrUmfvOClyvX2sYN?=
 =?us-ascii?Q?TGIp4acHDmJrHNcK+NKgjaQM96rG4o9HDZAYTPvHM9VhR6BRflKvrrjLAqKZ?=
 =?us-ascii?Q?5NkGFxnLj9NyMcpI8rLrPBvRdy4oQgxvIKAVz9T6EDH8UOBBSGhRcEdcdpi6?=
 =?us-ascii?Q?l4k/kgEHaQU6nWtsIBghAlkWBOuAd1KVJn7Bh8MhTHgdUc2zelsTGzXJfwT3?=
 =?us-ascii?Q?9/w37y//7DIjg3Jdd4zCXinisFfaWEFnfr5b/jvzs7Uf2mSK/0BVH/dswN2Z?=
 =?us-ascii?Q?3sD6RIvVRGA6NzXU1KskjeS6XHPgWFSuzNuOcl5Z4B+LpomphxfP2m50mz2h?=
 =?us-ascii?Q?s6Wk/OfNHLqD3S6qS2Z2DHSAhv5ItmdMycZhlIQo2b8N/Xi6K1Te7qe1Isig?=
 =?us-ascii?Q?qk7kj/66TZ/BCRgKiyRNiwRdURjtS5cAbabp15khhqFsjoMhPubQYEO93aFu?=
 =?us-ascii?Q?/QbdCvnc/2jEIq5xZRXSaN6lvML4hjd20jnrSXhN+s63cPzAAuRjYnsOmaP5?=
 =?us-ascii?Q?zclyQsU/kiUS0AgcJ7gqigpPRm+Joafvee7N24HXxUS53565N5ADCpwIXCB4?=
 =?us-ascii?Q?/s0OKLa91nk4aJxTJDCQiM9Zjvp6byB9HrzQDr6GctLJdwPJXDSW2vx6PH1C?=
 =?us-ascii?Q?/vRBTKFUOpRdobrC+KYTYIrMeBlBOTcvNzgza4GVKPIxQQ1+h1jNRXj4QiBl?=
 =?us-ascii?Q?ceIf03TSi65yRVemFQBGVmnc2biZgMpwvVLFvao10XccNBu7VtVUl+8HTmH1?=
 =?us-ascii?Q?A1zBvFVVQfxlO20smiHegcUTfr1WDRE8vmxYhiYAGN3449SwOlucpiAvj7Uo?=
 =?us-ascii?Q?tJ/yTYQgf6/kL46SOvXaaLrxO1A689hLl5qpS2hSnWt6OsGPm0RVt6lwvpmB?=
 =?us-ascii?Q?YkSHChCZrJYOtnWwfY+IespAKrsuUxKsGqq9hbFfRuZuWokOfJt1impLUXBg?=
 =?us-ascii?Q?1kHrOW2+NYgV7jqWpaKH2PTkzy+6FM8b4po53dFS01dMxQ6FXRy2OI30cQaA?=
 =?us-ascii?Q?XXSYUbxzrrxHzQ6bKPKtFBHxFJLL2wWEu59L0org1lOKj63jAzPJh6eEAfOm?=
 =?us-ascii?Q?NGjgE2xDCUfVPpoQCWd7lnCng3T0Wb6XUEhYC7Saa/SN1UeDuwHeZ0ykNe5s?=
 =?us-ascii?Q?liq9NrbBuOIRbAOby1J/WHK16vxLlWgZHY0fispslZC5fO298OUp2Wb31jF9?=
 =?us-ascii?Q?6YETX80lbFC/WheeuOZGWTBRXWaVcK657yQz4bVsG43XoYsZLYajtD4IxX/G?=
 =?us-ascii?Q?8DH7Kg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 928eeb59-e420-494b-ac89-08db40e14786
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:20:51.7303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ipgdVIapE27z7pyW4jiaxeci1AozZD4F2L2U8rIpMRrI7srvKEFzomxyBsBjtsg84jP/+SRzR5nzG3JhfpXbYWXpOY4asiFV+CtrWYDmFbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4128
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 01:52:43PM -0700, Tony Nguyen wrote:
> This series contains updates to i40e only.
> 
> Alex moves setting of active filters to occur under lock and checks/takes
> error path in rebuild if re-initializing the misc interrupt vector
> failed.
> 
> The following are changes since commit 338469d677e5d426f5ada88761f16f6d2c7c1981:
>   net/sched: clear actions pointer in miss cookie init fail
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE
> 
> Aleksandr Loktionov (2):
>   i40e: fix accessing vsi->active_filters without holding lock
>   i40e: fix i40e_setup_misc_vector() error handling
> 
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

FWIIW, I reviewed the patches in this pull request and they look good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

