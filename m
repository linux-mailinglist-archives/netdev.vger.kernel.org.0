Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C463A6D2711
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjCaRwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjCaRwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:52:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2128.outbound.protection.outlook.com [40.107.93.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3E386B5;
        Fri, 31 Mar 2023 10:52:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYtXWaoiZTC39vUhI76QOo5PQ06R1XIwvgY+gYKM+8HDCspUpU5f9rovTO5rriwD+awJ0IwIkYyjyzstcT2Ldm8fDRm7I//wSEWlN7/jIqs754PSMI7yrRCRBcOFggi8fkUZK5qoyq+JOB+PP60QF4tSol/avQ/cfzeM/+M75w5bXtSna4UcXsY8ekzZYJQXyzbKosLZHzWtHPxhmFP4zLJgkJAgftzft7xAxLJjn9GHQPq29iQyGSMYXekEbecdKYPSqEHdbP1y4p7wBSURpPZrLy5nE5eaygvoajGhLXKnEyMPr+hS97ac+K0pMSb5bspaETSdRgJODsuVby+rfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5Rni8ZEjwI+CQ8UnkGZeNRM64jzviHwICkCfc1+TQk=;
 b=nxrjO9PruPEkomyDt8w7VYwU42wd0bfCiJEbE2iXR2oe1ZX+rGk+wBGxQsZx3Q7mQ21x6Rx3368T6s733RTUCvOhU2H/gJllZZjZ0X9fTq2Bias7k8yxS4pTC6Te8Of27GVF0lPh0q1EoDDNg9IyCzM4tgs/Vwe7FOyD7H8WoWUk9o6zwBekkGYdtuGXxxvkJ1z0vYon530BUtenamGVXkaoQ4YCQ2vmT4kR9tVIT7WIEK3ggxqT8s5OLCZWEQ4Dlf6wznFUHh/M5oSWZ+g+4I7OVQjVyJlUAIJRHbjA/RtxjWkl+uqOvWtIkXHm8ql+BOyDpDHutNyc0vvXo6lPzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5Rni8ZEjwI+CQ8UnkGZeNRM64jzviHwICkCfc1+TQk=;
 b=Iz/6rWJWpEd5tX/Zh0VzVDPGpzM8+Vf3U8ckOkEykiBWZGrSX1F6Gce9HzLJL1H9U5hE3tlJEnHmC3XRTllpSIOpZx+nNx35rfQJf0gpqF3DEB998rlwlxRoQ697MgcfQgHtGCL3WZsUv4ClxIb196LeNCWk6hYbnwSMbUvzgAw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4465.namprd13.prod.outlook.com (2603:10b6:208:1ca::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 17:52:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 17:52:28 +0000
Date:   Fri, 31 Mar 2023 19:52:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH] qlcnic: check pci_reset_function result
Message-ID: <ZCcd1c0jhKxk+FD+@corigine.com>
References: <20230331080605.42961-1-den-plotnikov@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331080605.42961-1-den-plotnikov@yandex-team.ru>
X-ClientProxiedBy: AM0PR03CA0025.eurprd03.prod.outlook.com
 (2603:10a6:208:14::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4465:EE_
X-MS-Office365-Filtering-Correlation-Id: 7889c36b-5329-403f-450e-08db3210b134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ywi2m/ntkMZZagSJwvSNtrmOkH03To99KkYrYygyWdqbZuaVjpbtUIwx5KTdztuOowFO9qVDbCZgxv1H7bVFvR2uuMzcTcqm7BmGfM/dnPvKabqiLY7Og9D8W4GYoCIgdMlaJmb9pth4hTlxkTnPV0ZrZ+s3tg98yjtZ97k8DL9fcKS6YozJVgmj4/IyuepRrTQirZx1XbX3yhgKfojZEUzK6sxvFRSIrN/nRBnKzmkTYZgGHfO2B2u+mbtT0aDxsnUZ4xN/yohlk5cuF+oALRtOD2aMXvTsVOdEUR4Az1Kz3bqWPVp04IB/4CCAXiQ1i5zP9PJBdrYXTpvyKlFCo17qElxrqYXns2u/qG1lZxOyn55L/8KSSiWoElmA4Hyfis8j748FNU3XT53RgrHl6CWTxqWew5ji1BPuiVnrztuNBP1R1y8B8f8f7SRgKcNX8+UdAy7qrbmv8jF3fgLFpqLmN25Xglbib4XtDKyuAh8FTKR+klLba4NuzFqrKKTUyL99LEVG9ouUd4n97ITs0XHfkfzhMmVAtxckr1bE10J0VRyh7B614Mqg2NKcneQl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(366004)(376002)(39830400003)(451199021)(66556008)(66476007)(66946007)(186003)(6916009)(478600001)(8676002)(4326008)(316002)(6666004)(6512007)(6506007)(44832011)(38100700002)(8936002)(7416002)(5660300002)(6486002)(83380400001)(86362001)(2906002)(36756003)(41300700001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IaRagKMobdvO/4yCsAr8DzLKbr2AgIvCmOJYH4rYmsRhre6daObyX07TEdjt?=
 =?us-ascii?Q?WmtwtrZCUFWdb437U59zdxySNfqx7rtA2RmkFdgoMOcInb/nkD1vnq2BwDFg?=
 =?us-ascii?Q?2q/D78BAiK5b2QWk1fp3lB6DvOVkGU1GBVWgkDrUgrB0H19W2K/ULNLcj3iU?=
 =?us-ascii?Q?zouOibipX4EvAwc/NzB9sjGjw10204mh8v+4ri1OwOiiALRWevHTMnyYvOTG?=
 =?us-ascii?Q?5PqKD9N6fSDoU04EgpYbdnpZ8UflqMktXZ8GsAFwTTid8EhZ7wJb320lwLKp?=
 =?us-ascii?Q?CXltXs4fqcoxvm67mAgfFfOMVlh17HQNDb3GKpUKjaB079PXgfuStH0duaR7?=
 =?us-ascii?Q?V4xjnmR+7fyZHII1iaXSpmH1vlqNUqiOVGlEscQ50D5ez0wUu+2tbWSRwsHy?=
 =?us-ascii?Q?9Z4jkTkmJvAKPErkoriy63YB5Z83mrBbBKy3TZskVh0VqpWVaH+qoNPoE+JM?=
 =?us-ascii?Q?fZTF8WC8f8JsIXnjtem5HhxqhXO1WLpDRkv+CGczkQEDH6y/U82En8d8sWoY?=
 =?us-ascii?Q?5eoGpDifniQxnBH5ETCY6TwHOV4ZhbBWssn5bWtWdoF6qE4OiYJ4d5MjYVwg?=
 =?us-ascii?Q?GBLN9GxSXrVh+ZyjlHwdplO2d7enhinvtOlfRBGlREZgxAOO7OSl1X8a3Od6?=
 =?us-ascii?Q?KvXUrHR2WeXSgMfL5rWr+Gq9FkzIVzztO8lb9T7IdusTWtlu+nlEeY5WOJb4?=
 =?us-ascii?Q?4ae8mUFk+4q3piCX0IQvxMocHrP2gdQ5y6rZifwQra9IKlPXVbLp55MWUmSr?=
 =?us-ascii?Q?LVfzn/7XolqiwLnZRSuQe5AZCetNmdgVJ3Gvrq6+2oh3VrxGNDWj3mrffDvu?=
 =?us-ascii?Q?iRwJvYjMYjxHNOFqUH/PDgPTdYiI/UeHo3vxMv++qMqT6QDA1VTFQIVtwNUX?=
 =?us-ascii?Q?yQ77M9fL9iAZqpyqZ9Ko84QKW6j6YiKU2VnUF2otlQr8DsDo64wtEg8/jLLi?=
 =?us-ascii?Q?bEIjIDCchTsawloW7NUi7hbPg9aKwI1emmfoG/t2ymKGjNq6YGuzUCgXfFa3?=
 =?us-ascii?Q?kqkmTw3wRHOTZcg42Zr3nfn+7u/2DHsgcAAVqN1fqmdPRkGcog79PC+Uk+tW?=
 =?us-ascii?Q?uqNInZze9sWEDAROHfTDCWFxnc+1Ft+xW/KtPBEOYt2z6bq9ciOSIEBWy5OT?=
 =?us-ascii?Q?baUd6HBuUPBgnkUumVHl4OG5gdEt5+4bGIQImdWoEOHz6n/ab9mIlCmnk2WI?=
 =?us-ascii?Q?6GLVcBYsHmMy90zrxHSpS1Ts9i3J+D5SiLFkdqRadITqMRffTyRqbyBLLv9q?=
 =?us-ascii?Q?MFkjgDQ7WaX1DO08T2tzxgcRuxropX1TJosl/rRB3TBjugySEM4DouU8c1Ye?=
 =?us-ascii?Q?WHQ2aAi9HO7XpXnX0jkdsdom781Wc+nYF1gCL+Kl22TUzUyWfB9/j3RBok46?=
 =?us-ascii?Q?mCv7Yo5i2GctLzCd9Fkgg/D5MmDsXbS62yqqILyr2ON//FoKAvnBRFmTNbV6?=
 =?us-ascii?Q?/oLbCCe8Zm8iAfs/cfeBZB0cNp5+g4kcO8p7E08ZTELED9jbxwtISR3dTSHt?=
 =?us-ascii?Q?/Et2DAKr26MJNIpfvcHs09lEfSWf8k7iE1GhX4z4Czf1KZChHwMNh2lr8Ena?=
 =?us-ascii?Q?pg6K3SVy/Y9oFJQ6l55ieNEMVQBSFYhBWj9zahPudHXqW9fefxfA8ftBn4Lq?=
 =?us-ascii?Q?OInQQLiQ+U+5L8XrxVqpA+IddcOHARv7nmVgdiW+zqv31YSHCgp506dLzfrw?=
 =?us-ascii?Q?Bt5iYw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7889c36b-5329-403f-450e-08db3210b134
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 17:52:27.9124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWCA9Sai/1k6bJ+vIdkDqxIl7aSJf8pVmjYQKgDTyFm5yODVrRBVnUKNyjvp/rpAAI3bb4vx+rnmbCriu+R/FJd+jNgMMoy8izVvF+nnl+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4465
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 11:06:05AM +0300, Denis Plotnikov wrote:
> Static code analyzer complains to unchecked return value.
> It seems that pci_reset_function return something meaningful
> only if "reset_methods" is set.
> Even if reset_methods isn't used check the return value to avoid
> possible bugs leading to undefined behavior in the future.
> 
> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>

nit: The tree this patch is targeted at should be designated, probably
     net-next, so the '[PATCH net-next]' in the subject.

> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> index 87f76bac2e463..39ecfc1a1dbd0 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> @@ -628,7 +628,9 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
>  	int i, err, ring;
>  
>  	if (dev->flags & QLCNIC_NEED_FLR) {
> -		pci_reset_function(dev->pdev);
> +		err = pci_reset_function(dev->pdev);
> +		if (err && err != -ENOTTY)

Are you sure about the -ENOTTY part?

It seems odd to me that an FLR would be required but reset is not supported.

> +			return err;
>  		dev->flags &= ~QLCNIC_NEED_FLR;
>  	}
>  
> -- 
> 2.25.1
> 
