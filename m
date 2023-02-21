Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF4569E4AE
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjBUQbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbjBUQbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:31:12 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A382D56;
        Tue, 21 Feb 2023 08:31:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htxognJszwlKckjr5s7I0FhtdSNkq33U2woLPr4S0O1wvrg/3MlAq5yF2DJgWS48aOnCna+PTaCkxf2DthFiETdOgpib686ygAs9XRYRtVusaahCqB/hUdkn5hHTFpKbTINzlq9f/tm0/DR6L3pIJaHDL+7va6F+uhhWIPBAAAjHtbnV+e3/cWn1iV8jzaCJZMam8GOxo/UHdWy+nM3uLxN374Jsy8jyfQycb8XSz968ZZgbGLFyMHUeXVK/RISIE1plFNkaKtRbnXYF15pfNsFtMPLdKDjQnDtM0bjrnPqu93n0nrasmG4h2JLgHfRUgskXJexBakCRsAxZiEzK8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHfcDVsBNAB/vvVkHf6mVchtYa4Ar9lQFZef5qbvSjo=;
 b=KKQheccips3j97I9qmLpRkhfX3n5Vn9VwJtsuQFg/kX3UKh+/d7552X6u7jGw9r1C3GdHBUAtgfK844sg6xWGl2XYeMTG/bMjT2qN7EeZYU0qtXds8BP7tf82z/AKSN/ciAVBiYucFy1pohO90Qbgo3rBSs+/b7MK+w8IVe7CzsadaYmYxAA1Gp2GufEmh9vPrF9BmlufXclI2blcZNa/pmtoCYNBDLh2QQYs3gtYlU65/28p/xSiWei3n1P9GSdZZrNdK7gwA2XnzCiFL+i5JigbYSzSAva32pN+lJDOg3qsPv1st0qL7ePXzsk/UiLeYOAOFdPMzfv1weu4sW+8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHfcDVsBNAB/vvVkHf6mVchtYa4Ar9lQFZef5qbvSjo=;
 b=GUMu/17jDpKWyP2VYKTLpQks9lOfq8L/epv+K/+Wfpl+VmduT1IJhwkIqnxutBzETD1EENd4EG2drEh4ov7D6E6cq1CU1A4tMnlM+W1QawXksSc4SL/uQIvNi6kyfQUfyfm9EVRp3dvDi0UpDDC17htfkxaxtJ7p+fyS0kZhQVs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5668.namprd13.prod.outlook.com (2603:10b6:510:113::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 16:31:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:31:06 +0000
Date:   Tue, 21 Feb 2023 17:31:00 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rempel-privat.de, bagasdotme@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: pse-pd: Fix double word in comments
Message-ID: <Y/TxxBYvHrv1mZfJ@corigine.com>
References: <20230221083036.2414-1-liubo03@inspur.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221083036.2414-1-liubo03@inspur.com>
X-ClientProxiedBy: AM3PR07CA0066.eurprd07.prod.outlook.com
 (2603:10a6:207:4::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f476955-2a3d-42ac-e7cc-08db142907ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1YYlYfUjgzSF1e8liryQnmgaP1TFzu5h+ZBHY709F0+shVD5JI4F+UnIiLsA9xhgGVNKErmBG+XVP94UUKLHKAggOMyPCOZghws8cqwy7hOmo+M84ef9zcdbgGS88NNMqsuaY8RiRJ+Y6u8cwQi3zgv42xvRfnt1hEwpjJAIFrsNeDaHploQh285jeM2+XJ2prSJJwyxjNiBfThhI2Bb+SAuG6TDWwTdRzzrwGYqUJlQypvBJ54jvVOk2k5k/+yCfaxkIQ0Qw7Ae2ERqztq6oBX42GIAFwz4zMf7te+vfzAXlGqEyjzFIoFiKUaDzHbe6BcYKLLZqM3X12MIaW53rl+Pl1XtCL2EyCXrmi1/vx/iMQImmUt/h0d6s6bgxvSQrsZ7CCUU+5SAhYJw50OHGaGCwgEAaeyTCAfqfugj+2pAFJOzBXZl0LDuLHgZOw/D1NrR0DUt0r5l4UIcLDMixqZXHVqzU9xhk/2qctXMgP0fBvbbgPbhcXsBITFMv3bKwJehXKPWW12Thi0fTB6GKOsTeW1pW3eaeRqsutzsZPFFSz7Z+KNguqo/DcbitNbS59db2sHOxZ+atoR5OqXMjD/GP+YVmJ7hQY2nIxudjlqu7l14MEiqXCIU6vXJggVmf97P/HvCHGqBfRpwkkoEC7eU67Qy0rp6FpPi1bGhv/AGQPA5KphOU/K9R/lunTS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(346002)(396003)(376002)(136003)(451199018)(36756003)(83380400001)(2906002)(38100700002)(4744005)(86362001)(2616005)(41300700001)(8936002)(44832011)(7416002)(5660300002)(8676002)(6916009)(4326008)(316002)(66476007)(66946007)(478600001)(66556008)(966005)(6486002)(6666004)(6506007)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kC5ze8+cFLhDaxIjlRjwrqASydTwgxzSpfAz3348+4EAOPXevtFwp2PzR8mx?=
 =?us-ascii?Q?Arxy7lQF/igpllVz1sbaMxp3w+XV9QfnNxWgBZes28BnFHbNxsneVhawf+5E?=
 =?us-ascii?Q?6fJUCrMqs++q9d/g06zLJq0BgD/LgUgd1n3ulYx3FJ1zbau5GytBvlikzsQp?=
 =?us-ascii?Q?xntuFymtSx25hLjSueKLRR0ZtM6dqVjxSFOcxK5KeAKl5Q36MfQ/IqZr2/O1?=
 =?us-ascii?Q?n+PYAznviSKR8xI97PhKcingPohiqyvkeT0Va39GVKjx48p7FXS2NUfhvVbw?=
 =?us-ascii?Q?INGFHcpeCAh402Mc+ieGSo1KXJE/kL8yCBtA4u5KdGKbTii5xq+FIxMa3DMY?=
 =?us-ascii?Q?v/Cs4MfpW76ABWDjMSC48bVMgGtDP74eUJ46u5mvvNXVXG1JE/bpK1uAUf1C?=
 =?us-ascii?Q?8BOgnkFFpNBkefkjBo9y8qfSyzZt+b4y6i/8hl51piWDGnyJI8BVhGcSs4ls?=
 =?us-ascii?Q?4J9EVbdnqpeA3OrW4cRtw+xUiV9takGgb+4nGKgBEBEVEd2HkgKJdvYMOqqs?=
 =?us-ascii?Q?bMJDAu3o9pAieY3UQ295xFfbiCIghOPqpbdqyI3nSgmF0/dDW+U7bA99jSkP?=
 =?us-ascii?Q?wfFJfjYfmufdlctDWsiNWTrpMH/gsQoGhmsNJqFn55NKcK6f49m0Lohnn+Jm?=
 =?us-ascii?Q?+9Xb13vBmB6ppZrjf6GmCbbkzx2wZUdarttrqnM9lcZfyFYgMx6H/kr7jz9w?=
 =?us-ascii?Q?kK4EsXSHWm0zhVmS9J6O9PmU+7gbyrz03+pNueKKjwU5/uN6AUTMnfy/b2N1?=
 =?us-ascii?Q?cKsU96Psak3I7c6K6Hd9pcOvXPfNpUdu+GpVmODilZFQIhiTBID7kNKUyhBj?=
 =?us-ascii?Q?mH0d+n7GSLh0CcIGaPXdMbySu/I2rISAoaYnB2lJgYDeuf2MvXqKjWFyMVHV?=
 =?us-ascii?Q?JEEDTKZvFvBTTM154nhZ4le1hhTT5dAB0jqG9xjAt3AH8Avzh5A52InTCPVO?=
 =?us-ascii?Q?m12TrFUTxulxS3K1FYEaF3Nol6aoqhKV9GO+0zioSgh4ttzyaRs9zVsGbGSe?=
 =?us-ascii?Q?F7CIrejzU29DqXjkbdLtNzpDx2CJoSvG9XT/LVhKATXIa6cyw6UgljaU6WsQ?=
 =?us-ascii?Q?KUfvhDhxC0wJTarTX4P3A+NNjcz5Iz+eauAFNzskvNld/UjcQ8AWZTmXMnpP?=
 =?us-ascii?Q?pq/pEmu+WIABrHf4nPiRllSF6qg1y1xPkrOCyptLyBg9GLwipz4IZmnMQzBj?=
 =?us-ascii?Q?T8J/3XRYhSkfS89mKuKORcWN0lKYHYWgOjgAhUIIufWEjPXnpl/xAn54WcSz?=
 =?us-ascii?Q?UltkTfl4u9BY1uEuwvAsvjU80zOETLGHbctF8EIDJtvHCXvO/Vkbtuvubl/6?=
 =?us-ascii?Q?yfUr2rIwTnhoOsNj7kbiybE4fySNJC3ifGic3w7deBkQ4kpJTX9pYJfT7ALm?=
 =?us-ascii?Q?ei4uCwNGOK4Swnh3e5OWzRToSv3Hm6hg/7aQzdBrf6H4tcv4OffdyzJ1pthQ?=
 =?us-ascii?Q?+k4f+7mQi/gm1hlhMedNtuMz1tZz343nCVqznASy/bFwmY1SByzULtOWLrVz?=
 =?us-ascii?Q?FtZEFHsgoEsxDTrI6qgTMnijBISASkgO9Fd2bPD+clCZpkEu+S+0Kd+xxOjw?=
 =?us-ascii?Q?EVh8ZwL2FCLFSx+q9gsspUVbU9B2nUQurQcSSMm0QcNsyi6Rv7ho2fI6busc?=
 =?us-ascii?Q?NWQch1E6HDCnBd4OvFkHgbkeTHQZUBQL2rje4LNvZwrrFp977ozdhOYSgBci?=
 =?us-ascii?Q?2D7Hmg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f476955-2a3d-42ac-e7cc-08db142907ff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 16:31:06.5982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqynvPWkDMMgKkhp7UkYbD3LGFqtFm9Gu3H5WUDLu5DqWv7G4SHtWbHSSABCJIoLrv95onJlR9BwLIU0Rm4pxdZoH/3525M7V1YbC30EfjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5668
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 03:30:36AM -0500, Bo Liu wrote:
> Remove the repeated word "for" in comments.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>

net-next is closed.

You'll need to repost this patch after v6.3-rc1 has been tagged.

Also, when reposting please indicate that it is targeted
at net-next by including [PATCH net-next] in the subject.

Ref: https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
