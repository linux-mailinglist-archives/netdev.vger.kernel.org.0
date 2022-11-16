Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2043162B6BA
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiKPJkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238705AbiKPJkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:40:11 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2096.outbound.protection.outlook.com [40.107.223.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D98286E0;
        Wed, 16 Nov 2022 01:40:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBAkF8ZpM4Ys90RgarHbTGMn32gt0OBIxzaJXfmz6ErL/Ku7MSXYtlYQVL7EK1WohDa+TDDplPdUvKMXgb7GybTI2jVhDeraX2sZJx1ab8rWyKWxce6sLuYxHtcmpttvAAQSDS6OVwY42dZAS5m9AaF29ga0iWN4VOIDSaT4ilMHomwUFjEWLiuqlYhOFARXe14jVNxcAUwpfsB6IxX3zP5Ar77Bdew0uztraFafITzXXve/3pHv/aDX5lSSpP5mFpUS3C6z6v2jTBBOOebbdbR/IV4ubdjw4fNvk7s6CdYsf4G4X/cGNOrmIqGdyp3wy1Fd4377TUHG7LoLf6FaEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PhUNmPjFvKxFEIB2mCNuBpS3hxoO/pLJ6y4ZcnZBZiU=;
 b=TA17M3WjwC58eqs+yJvSfdDLAIG4RpSMaOtDUudhgd8fjcORfKALIdujNLWDzoeQ2z+As2RG5l8vwXl04wpcvYPmK4gW0cSX6DaWhQBviQv/Yqx7RzDryCQ3sEPqkqvEVRpSpt1jIhIhPavPDW4ThLzazgTo8lI5PC4m86Cr90/OFJDJez761Ii6TSC47bYDqylVjzG/VB87zoEB8pBA+FiYnKfUoWdK/bHY8nASsEzergUsO3kgwYi7pXuMUblHDpeMndyT6RqVhv0/EU+GI8OCrmVkxFOkkzJisxxE8WIc8KXy5TWySqsMPbneyLnLwHJJfNawEvlVtS5r8mJ1uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhUNmPjFvKxFEIB2mCNuBpS3hxoO/pLJ6y4ZcnZBZiU=;
 b=TNCCKP4n+IpTaBCAX9PaVt5a+/FcPA9/OO0g5KXDF2OV05rZx27lrSTora4KiSd7RjqJgvSH7Cdy+Qy0EWvr9SirvW1jW79PI6Na+6UvNOiDIKQOx7zO4nOry3iN1XEudVlijx5vA2qQupR+ftW9dQrUEmqXmA3vPGuvWP4fYV0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5318.namprd13.prod.outlook.com (2603:10b6:a03:3d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 09:40:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 09:40:00 +0000
Date:   Wed, 16 Nov 2022 10:39:54 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Denis Arefev <arefev@swemel.ru>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-patchest@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH v2] lag_conf: Added pointer check and continue
Message-ID: <Y3Sv6oZgi3k5VaLz@corigine.com>
References: <20221116081336.83373-1-arefev@swemel.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116081336.83373-1-arefev@swemel.ru>
X-ClientProxiedBy: AM8P190CA0001.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5318:EE_
X-MS-Office365-Filtering-Correlation-Id: d4156b5c-9e1a-4d57-a9c3-08dac7b687e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aIh7lQzE7jMnoGpu6ddXTPpe3YpQuIDJ9aoYYk85irvmiWxCz2Mw3CkITFwi3UYKDnfZxpmzblLIIuM4f/2phSykLbustPFCaHYP8oJ0w8V9Vxk2R3g3Moq2FfFQG0r6Lb+qmwGDli5ws1Uxlev55yT0qtCqmXF1jk81xJ9/WcM1ZJoHBRbCq47MwSmOcczZ64vygxcHtf/wkdj7Szuv0v1hb0OgpoK6GWfIpgSMJ/I9Abqw5VmU7ql8bLvuENYXu6ytUrjL4T94AdLrzNwHd5FNWPKBIaAZUEc77nvWgJaHFyK3Xeu/kH0zG1gjtYZr+ns+PABera1aHEhv1vhS3Wzqlr1yoSHNhS3fawgjz32QZTUAVoh7Mg+KIBpx+OClvDVMEhiIVZ90Lf7xaCViV02xnDYR76gT3Vi3jJBILPwfgq+mZ5wu0fhyrTK3gTc7PXzZaWdX+OMwZ712eiEd7yqBISNwk9fjD2zc0eqtFeE0zBgcV/eeR5J+q5Ltt1MtFj1rnfsYeasUF291o+zPQ7VIg718SkgEiZ0TJjnFDwkdSYrX456JI7Ivb+wMJBYbjd3KBo3gnyKgBT1htKcG6fOweuV900169BCjx1wF+FYijAeh2biNAUeS/bI/cP9tTfFPBrVpBGGH4ITd0ymleC6oKdGHZt+DNZjf3LrcwhQ6vkNpHaPhscdmxUABNtUG/ygN5X+FvwZUZNP+WaGsYegbEsqPAhFFMfX2XJM87WhYGMOY8R4kb26qPLXNmkT7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(396003)(136003)(39840400004)(451199015)(86362001)(36756003)(478600001)(2906002)(38100700002)(7416002)(44832011)(8936002)(107886003)(83380400001)(54906003)(2616005)(6916009)(316002)(5660300002)(6486002)(186003)(66476007)(4326008)(6512007)(66946007)(6666004)(8676002)(41300700001)(6506007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e+HzhByKnSt9G0VtTO/K1DyK+wEvJK5oZLhvUtG7muii7HFMDLaYpfNrwQqO?=
 =?us-ascii?Q?dRMSJTuWfdfxDFMYl4ZaZCSSLLfmYd++E+ycFOAIoFpu/FOjXJqJpb82uT8b?=
 =?us-ascii?Q?/giAHuTGsbsOFhpRjKUzIx6LBnpA5462MRARrQ1jE7RGdi+OHvEOUMNg6inq?=
 =?us-ascii?Q?69YMBSmz/gszNjuO+2ae5jVIU4m5QkeAmElgddeIGYhmTgdsoPwZQcm4G7jl?=
 =?us-ascii?Q?1s1GFhH3ucygfTchm/E8Svpjz4pb8IeJ+GIoqUPLsAWSUBOeDMrLdBt3YjrI?=
 =?us-ascii?Q?ZKmd8c+OS8UCGpBBjrlTuigsuGeNw+MQVwr8VDEFhV6647KsEVFUKnmupDIj?=
 =?us-ascii?Q?56jIvvtdhdvh95fFAdpjD7OztOOj61SiqrN3o42/J0EPtfoSBecJ/p06gzpY?=
 =?us-ascii?Q?fjAqLNaGQMAGqqwFrWX1NimzhNDmtgsym9TDwp2XOl9tOapU42h62W2kFr0k?=
 =?us-ascii?Q?dl0+P/fQsDmqgZHL1kJkQ7dJmp14gpIci8OXv4zqWyVxj3bWGwjBgjKR41pJ?=
 =?us-ascii?Q?MsWtNLkiq9uVIqBqvlWFcSfhi4OdphhBWFdcTxBkhlZAyqalKtk2w9vWTE9B?=
 =?us-ascii?Q?61tjWK3aWCpsVNIx2mI98+Jh8S6hdbwcrora2Ty+z8XAkXLFv9HUtMb2ZdKr?=
 =?us-ascii?Q?RPEiwRzNnfKTczS5FkX3v6+X2EH1hjAz5rs67ImYJrU900N9R7ji0e9QG+nT?=
 =?us-ascii?Q?afw88rvJrVcRoTNX36i71p1mg5ELLGqbKoo5QacxXak6hGalu787HIIjqsUQ?=
 =?us-ascii?Q?wMx+eFCVVfZE4MU7YciqbMM7psENtbLUV79cJkinYKsE3icorA7Wy+P1T5GB?=
 =?us-ascii?Q?eVCKcRFdejF4Ys/iVcjaqaHxRm09JTx3r3lol4ColWc6+txBUwKiEV7g81+n?=
 =?us-ascii?Q?u8dyqrUwwuO/jOJGff3csCU0uzWeDxcJTImaivCsE5J8RdIpkMrVzzOP9vVL?=
 =?us-ascii?Q?q8FVn5xP7PphJKSMd2GPndRG/y6YCyAEzruQJxuW65DtT6/4ql53yGzJBLcT?=
 =?us-ascii?Q?qY0e0uga1yYv9CDsmUX+vv+rFlF6/hR6Q/gq8msWzk3L/qODbP6Hv4jkMTuz?=
 =?us-ascii?Q?kpPFqz7Aqo19vTMC5luwvpvpWTauHpHoWbzI80EzAnMvmSqpBGWoYSz2NyEm?=
 =?us-ascii?Q?/YoDnJJnMQs+fA+EWenGaX40L8zA+eLgzFCgNJArMFKXDqcohSEM2Ry+51AS?=
 =?us-ascii?Q?GzG570AzczItQaW5LwktRdMf2RmL/1ehLI+n/jZZpKvqVCD08jAC3z1rwTqa?=
 =?us-ascii?Q?xPbZoHWqmVR3oRIqhcZFAMj9jrH4oJvSC7jLTvEL4s9J/nsQyws+5GGHJADb?=
 =?us-ascii?Q?MpWYLNo1TLmAu/G4babjiWzIgmHOYs+hkp3RRuEXMW0xdeZJZ8ViH8emDfXL?=
 =?us-ascii?Q?oUrHbaAtzStpIMIy9ko+IeKNYpz+zxIYx5kj/TZtvfBgTGgE/+nlpS6ShQ2Z?=
 =?us-ascii?Q?IKZHb/woecA/LYOcW+Za4Gcdng9Pl3uko8zgOPyQH138kh/Sc2binqdV4CaQ?=
 =?us-ascii?Q?7jCvMFPaaZdj52r6vUX6XiSmvCGjDxfxBZpGTIZlra7XmgX5e9SAHqZRI+3K?=
 =?us-ascii?Q?29oS24JomJYTspExb+B3Vk8jp6ZKqpR28B0Ex6/O37H/ixSB9gDWvIvQrqdG?=
 =?us-ascii?Q?LgPdMWs+kZC8Teb6klOJjXSOywIHh8+IXThrl294tEwZBePARWVquOfR6KxJ?=
 =?us-ascii?Q?rZdrog=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4156b5c-9e1a-4d57-a9c3-08dac7b687e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 09:40:00.5431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w+9xIKpyhcmht1a5BS/BSTw/B5XxxQfacmpG6pdiYiksjut7TqLNFbIK/J8E+s+IF2Wr/FTcR14JqxyyZT9CTr/mzdRa2m3ozi8M8kZXsMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 11:13:36AM +0300, Denis Arefev wrote:
> Return value of a function 'kmalloc_array' is dereferenced at
> lag_conf.c:347 without checking for null,
> but it is usually checked for this function.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Denis Arefev <arefev@swemel.ru>

Thanks Denis,

I'll let me colleague Yinjun review the functional change,
although, based on his earlier feedback, it does look good to me.

From my side I have two nits:

1. I think the patch prefix should be 'nfp: flower:'
   i.e., the patch subject should be more like
   [PATCH v2] nfp: flower: handle allocation failure in LAG delayed work

2. Inline, below.

Kind regards,
Simon

> diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> index 63907aeb3884..1aaec4cb9f55 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> @@ -276,7 +276,7 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
> 
>         mutex_lock(&lag->lock);
>         list_for_each_entry_safe(entry, storage, &lag->group_list, list) {
> -               struct net_device *iter_netdev, **acti_netdevs;
> +               struct net_device *iter_netdev, **acti_netdevs = NULL;

2. I don't think it is necessary (or therefore desirable)
   to initialise acti_netdevs to NULL.
   As far as I can tell the variable is already always
   set before being used.

...
