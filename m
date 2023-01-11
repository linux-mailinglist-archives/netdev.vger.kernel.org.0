Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADF16655E8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjAKIWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjAKIWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:22:18 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2123.outbound.protection.outlook.com [40.107.101.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251AC5FB6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:22:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/cY3ZY/zZxx5+GMSlfkpqANs/BASMRueumURgIjST1kjjJfykmUcTNLG7E3Pio2Cv6FzHt9N7x83JuCOhQ/xGtG+rZy+t2KAqlcdRnbSuokMn6EcMCEqVQZDb8Ij3bPiQgT5DC0Bdt6jOKJyL5G9FoyjvXUuYkYRVunf7C9MQcOzj2sE72PWPoE9P70lmTH0/uZwuXsDO656vpPZzM1HG66HzTR6XeDdJ4GjaJFrZ792pu9yIx6xVpOI2m0dM9rKLjFBrBXV20fFpZX4LodXQ1DEk8rM1Ubx0ab6skUrvGUuT5TxvDuJC8bfx29KxkVES33KKKPIPSFgJ9k/INlIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJo4ZxoerhJlPaApS+jrdxJJkvwOpkGsVw+2JGn4A8g=;
 b=A+cQYd2kWCmHQ44dEBMOxsP+ZaETfbxFrZmdXasIHIflz7h0Z7FtUtwdiJhxdjUEpe655WOxll5XqXYXXtRm3IKEYkL3ao5KPNre0vQltx+7mLSwph30zYkPpThtUGSUdd9cgTgTNPC9GZHRYKN9qkpRg4T887OttiiNI5aUwfJIgzBbUlB74BbEQza9NvSZRnAhLvku+rOCjFcmL5lwTAdVNDUPpkM51uJbJOZRzPyI805EXbyrPhBDA8os/Kesm1O5ziih9gPC3uP0zTsMrT2sma53e6YOElIfO+a8mtTvPMobpaDbbbPi80emQtDnQCty5hHKRi/5cM9r6THzEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJo4ZxoerhJlPaApS+jrdxJJkvwOpkGsVw+2JGn4A8g=;
 b=jeAUb64ju5PhbghMSF7wswmsKZ1KsrCEl0vqrz7IOUx3ao5DuauDNNi+FKw4fqSrvwXD92rhuBseJIxZ35x7hDJZw9qBpyaQfnuC5fpvNcwAEwoVOxo6d0sfiJTg+sB3xm2LXNzkXhJ24WaVcVOfd1FOnkEp8Ml0bwriUde92W4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5299.namprd13.prod.outlook.com (2603:10b6:510:f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 08:22:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 08:22:15 +0000
Date:   Wed, 11 Jan 2023 09:22:08 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Bin Chen <bin.chen@corigine.com>,
        Xingfeng Hu <xingfeng.hu@corigine.com>
Subject: Re: [PATCH net-next 2/2] nfp: add DCB IEEE configuration process
Message-ID: <Y75xsI18uWeWivJ7@corigine.com>
References: <20230110123542.46924-1-simon.horman@corigine.com>
 <20230110123542.46924-3-simon.horman@corigine.com>
 <20230110203808.2952931d@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110203808.2952931d@kernel.org>
X-ClientProxiedBy: AM0PR03CA0049.eurprd03.prod.outlook.com (2603:10a6:208::26)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5299:EE_
X-MS-Office365-Filtering-Correlation-Id: 73dbbb7b-87ff-4f18-48ae-08daf3acf21f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w7Ick1022r8iZIrUpBQSUy3kJTLNhYry0D1vkw3vavDJ8SgedxhJuz6k17pAF0Qyhjx2dB0kNY4/s18jGrnfX4ufjKGwsFlgiX2Gwj2e0J3XgW35K3xXYWtdC7dhosNjDB/zIG1rG4UbgeRUbZOmo/V7xoT/o3VuR/MxnIdqN516qCKTvcwFZu6pShC0RvUp8AY+MnJGuBjHw+Ae+74aRFT9YlNJxfn792hWSFvmuSDV/8zOgVEi1i0a/LEKyZMRvT4LP5jPVhuc8SwvxymQYL3KSTX1WedCRqHNj6UcbFDE6j3lNfXuwf1UCXt55ifg8DXsmdZRhqL6xCA8MOS4AC1JmaUc5EATid9kyS1yZDi0BuBPgnGAyHzWE25wruhB3rwtEE8rEflmkDAKUOnyrRNTC4kjWamwjN+rMkkrwJEfJtw4QnNaJdhe8veYsfgCv2YlCJRS3Xxz/EWt8uJYr78X2mNYq/dBqTMwzXrvBmHWpEtt3Wa+Rrh1vhrPmtaKl7U6VPHUBw6BTc/nmCnMLqSEKXErSvSTrVTrMyOSjCSwBDSv9D2/tO2N6rlfEo9gsId8k6I8iA83pg0mwP7rN7CgLePjZ+VTIXnMuDQHPv9wDcM+RUDgiE4lhFYnDKRh9imLzR9VfYLQS3XdzeYsGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39830400003)(396003)(346002)(136003)(451199015)(478600001)(6486002)(41300700001)(38100700002)(6512007)(86362001)(54906003)(316002)(2616005)(186003)(66556008)(66476007)(66946007)(8676002)(4326008)(6916009)(36756003)(5660300002)(6666004)(107886003)(6506007)(2906002)(4744005)(44832011)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VRrWCcIa+7yzj4p8ToFgGC+FG8PBcHMA7NpaDXa/xPa40TcpNjnLvizmxzkS?=
 =?us-ascii?Q?MmdxGevGFFdORZV2UrRwGrUbl7KjO5sGRRxxMqTViS5kH38Pm9nz4L2B+BN5?=
 =?us-ascii?Q?pz+Tq1vvVjm3xJ0FCL8T/XwbwQhhshD1PoRpsXp4aXDs620wg5tQfTN52+b8?=
 =?us-ascii?Q?P6fHWbjvpApxuSDVNfCnX8Af77H/FhguErIfBt6gAauUsiJtiJFWJNefvB+v?=
 =?us-ascii?Q?YR6aoSZ5rY2UsjiSNRt1eBPYuyQv4R54SbT0kfkIqMtwTZo7Iz5OUYsjiVFr?=
 =?us-ascii?Q?Q+NpVgzCW22gnVIEbaJ2moDNcKIMhw0swD6Y3Sc+M/PMSOz7J59xjLmOu/7E?=
 =?us-ascii?Q?3BITiMoflTNP/5gUoWOrmxx5Mg5db927lY6iteXcdeH3Ml7iQCPAjou2fY1R?=
 =?us-ascii?Q?Av6dOtPSblwCXReYNBue9Mhe3H+BjGYK17gt+vqta8N4bjsoDu0M4T/Zz5mH?=
 =?us-ascii?Q?Skq1ah7QK4++d243DvY6keT5G4h+YDtIky3V+Z7g0Hyg+zQBfn4t18X+JPPO?=
 =?us-ascii?Q?qlWlTAPQnHEwPn4PUpGSn7JqzLiF4GtVwSExqApn2znCiwLHKE/Z7VYVVf5z?=
 =?us-ascii?Q?9OKTsHHpBn+rhJ8iIsgwF91DW4NYU67XOVunL5F6sZxkOZBDG8z0mVRiRVlI?=
 =?us-ascii?Q?sCLGifPd4lMP4jZuOB9iF2NM2DsUac8qTL/va3upeuaCYdbyiNKJEYrWjtlm?=
 =?us-ascii?Q?VuREeI39SMdIDy3qRGqgc2efYQJaw+T2KHR/5a6kwBgPIKUSrfPWX30kLgmw?=
 =?us-ascii?Q?BM8R8wB9k8KW6qr+P5leE5d5bcyI5AA7G6eQKo7uHO4mvh7mE8fVuMxa/Xdl?=
 =?us-ascii?Q?OvL0I4aroj24mnrPg4fBTqj14fB0auiRs6KYfGCYnTjnBvI+tNli3tRT6Wqj?=
 =?us-ascii?Q?gKzzDSEadGmlwETSpP4LGJfZuWLB8re/NR4tU34i/DlxtaR0vf7zM1X8iM6q?=
 =?us-ascii?Q?1j0GDyL1ytQd+309R7vfJyO5YZqiPmm2W+U1xWkeovMA2uR8ZKrKHJ7X9wXi?=
 =?us-ascii?Q?xvrgbZhlRaWH1SptUTLdTwXRayF2bIfnGyUgRrN6IvfVpzpNM6j4VlrOXehA?=
 =?us-ascii?Q?BuU0PgSDLN6gJET37iAJFzUucop42suiPWIMPsGjQK1imbQJnRNNdBU4eHxb?=
 =?us-ascii?Q?kwBr08az35alAuqPHxUR/wfvXRWvTNsiOFKa7Ng8eGXWHbMcE15NA4vFmG6l?=
 =?us-ascii?Q?R1IYaHd7zk1BKOr7OqiFhcBLD/Xk8P2GQU+vQsA1HNGT4WFsZ62nYU1zPt7Z?=
 =?us-ascii?Q?awH9feHmOLDudjBEGxWFL2WC7c8b5K8VsmRa557bEwBf/d1D78CmS9a7qoY1?=
 =?us-ascii?Q?W2z9k0VYev6AhWKwqWlZ7ZLqLDF2PSCUM+uJE7a4c102rkwq56pTXrUjfvZ7?=
 =?us-ascii?Q?haLxZ1Y3rNHLPSnBS8MdAvL/Lfo9TBqxDEU+UoE6Zi4rjgvI+GJiRJDmUgou?=
 =?us-ascii?Q?57qffWX4GVhG1p+PK8Hgg3qZrVy8PnZapA64+jPLdv2kWg+i87GPhRol4KjL?=
 =?us-ascii?Q?wNqO2OOjC7WN5LsTkRVbreZexW8FMFYoDw/vrL6KWVqRuJ0FLgzWCCQi5caJ?=
 =?us-ascii?Q?Xasj8nuxbV3ub+QPncaxFY0H/t7zLnOaeodHCa4aN7HhqGM1NagyW36e4HP5?=
 =?us-ascii?Q?yTiyJcMeLgseZ423gneSmFPCXtvngYStiu9kBj4w7/3QmKTcsiXJt5c9t2wp?=
 =?us-ascii?Q?xFfbEw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73dbbb7b-87ff-4f18-48ae-08daf3acf21f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 08:22:15.0125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eD286PTplm2xaBCIelkR/8gqH+1XLN4QrfXccqp1yc27PSoMXmZw6FZS3IW4dYg8P25pG4+Hf4WoE0RvQIJtY5ZDD+YceKZVAE/iiwtwQvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5299
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 08:38:08PM -0800, Jakub Kicinski wrote:
> On Tue, 10 Jan 2023 13:35:42 +0100 Simon Horman wrote:
> > Basic completion of DCB support, including ETS and other functions.
> > Implemented DCB IEEE callbacks in order to add or remove DSCP to
> > user priority mapping and added DCB IEEE bandwidth percentage checks.
> 
> Can you say something about the use case? Some example configurations?
> 
> > /* Copyright (C) 2020 Netronome Systems, Inc. */
> > /* Copyright (C) 2021 Corigine, Inc. */
> 
> Please sanitize the copyright.
> 
> Please squash the two patches. The first one is just noise.

Thanks Jakub,

these patches have a bit of a history which has lead to the problems
you've highlighted. We'll work on cleaning this up in v2.
