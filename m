Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8126EFB6D
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjDZT7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbjDZT7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:59:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2104.outbound.protection.outlook.com [40.107.93.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E86D2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:59:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOpRGeRAuvWJgXgMQRgjV3Ag7cxTVr1fiXHQA3aI6abIUv9b+t0APV0a2L+V67Mk/GeSDMos8KW+Fkhcca/TL/EXGtGycqEqhZeg4SdTx1LlG2iCfJn56niD5MM9b14vfMs1BhsS7r8j+oWqw4oSLbZhdbfrE/wxddO1D+79fecBpC/APcS03B4raCxvCbQMz0TcXsI+OlyDVR2J7pHsUH/90kjOypRT5uCisxkLNU113bOhT/xFIN65/e7loemEoo3OOFLOJxKWYc4XPqzPw7Sm+HdeB7QVH0YJjo7NhynKNFfJ2z5mr/yzYVcYM+rK37u1li0Tg20KcrAL+nU69w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zV6nmEbeNn0nRsKo00rkpFGuJt8zKhAjQspOgCAVsTk=;
 b=hKrGfjqJTfFQTYJbxhQVfzuSH/UcNSjK1IU+FTjaNvyv9LIy2ptziDi2vOP76/LdfXmfm5APTOepHI4JDwCnw/0UVTtVoOBpALB3ygOeXjiW+KCRzqtB4kkvF+AM3keoIuAb6rB2UORzt9djefosVJqh7RIhLMp5ygQH539JQX0m6INUR+vnYaoi9X21he7HrkCzIV5ECj173MJwVxiWNwQkBMHmxP909XPuqeC5tj7YTmBMzRppBUYVWlZpdvYJDg8Qt2ECJht+l6tKVwewym4ywe242ZUsBfhzLXt1i8klkvEWGrRqj+cW76/5RxG3h5LEpPxqXg4a4RihC1vQlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zV6nmEbeNn0nRsKo00rkpFGuJt8zKhAjQspOgCAVsTk=;
 b=HB7lmyDN4HqcRuPGZ31hSkn480n6tr9qAw/8DZ7EwA2V1j6JAfNf2zbcwoiYQYLBDR6vniUoZYxfBWQVVeqfweFMh184HTETfa61o+6fpoqZn+FTRKr4SyOvn2HzbjgKYV0/S2GTWKMbIqaf0ZUfyQWUEI+VHkJtDvzX/K0hB5s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4887.namprd13.prod.outlook.com (2603:10b6:303:f6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 19:59:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 19:59:30 +0000
Date:   Wed, 26 Apr 2023 21:59:22 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v4 2/5] Add ifreq pointer field to
 kernel_hwtstamp_config structure
Message-ID: <ZEmCmirgOnAIByYH@corigine.com>
References: <20230423032817.285371-1-glipus@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423032817.285371-1-glipus@gmail.com>
X-ClientProxiedBy: AM4PR0202CA0020.eurprd02.prod.outlook.com
 (2603:10a6:200:89::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4887:EE_
X-MS-Office365-Filtering-Correlation-Id: 039d34de-e1ab-4115-a1e4-08db4690bf60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hZ6NKaI3W3i3pnSQWgtt7yEYNeFvVXfG5jg9hqGsz4dx5ia/kNIdF1tVC9FgMIgGTmZQxco9Q+z0ACLlz0HZsTqDuM2JTbmtMy07Dj2VIPvh4j8YeciAvuiNBFp1bwxDDN6P2HbqYP+V0rRuTc4lNYduhzKMhyG3+n71ftd+roUF2ppe650yRVk/ZQ5WbRnIHa9XWTCbCT6S7J3qjNR4MmUupGzeGyIvFt648ucnzOifRGQl5OxhTMwjhyU3oy87GsVHXfrGaJq7jmf4wgp5xcJYUy3jz5+wZCScdLmiHxzCvk+kbIC5b6CvtqiB/wW5vZttYNadmLjKAuty9pNI5zx6La9bYk0lUPCiRb7l92YjuAGWbgvgJlIpbRPa62q0/w3AnRma8fOpLdIU9cPld4LXAhv/qztAzltKzBVY4qvkOUT3zDqH2NkwMfUAO0c/ZoFGM25/lXBTmsN7kyRk/JXH30EPfYxENSmyV0fsd4qqraBuUpA4h+kJX+jY3Eu3SPoWgqwWCNAjWSEmsF++5BQNTnVFvkmPT5X704LvyQHYVCdskOZOnF9Dk9DWsgjLW7B+wLtMCc+Mt/b1yfL0+UbTbbmTmhhoNZtdrmTNx8A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(39840400004)(396003)(346002)(451199021)(44832011)(2906002)(4326008)(66556008)(66946007)(66476007)(6916009)(316002)(41300700001)(5660300002)(8936002)(8676002)(478600001)(83380400001)(6666004)(6486002)(6506007)(186003)(6512007)(36756003)(2616005)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hPMJslb1y5RaDtghWcq1PulQgW5IxKsLyWw+jL60TOH89UBfSMh4NDioyXm5?=
 =?us-ascii?Q?r45pphOks6EMM+PLsEn+X9SHpYYQDn0+TDA4p/xz580MKUwzdj2F0vYWF2Yb?=
 =?us-ascii?Q?2yuimRPwMZlqjC4bfnx0I3Pj3EIprgOoEBe4c9JRtIfV7UJIayelYytliwzw?=
 =?us-ascii?Q?o+9i6fSbmW8FaKi/x9co93ClPcV1ObTi9n0RMs3w9pojBnTn36nH2/0Oq4IJ?=
 =?us-ascii?Q?I7Ft50z711Ealp7cldd4n00WjADFInu2+9dejcauNVKqzDVW7gWLY1jY/Xob?=
 =?us-ascii?Q?/rBBt1aJDjzSE20E3Ae7N/PCIhygEiuYB+cqcxccQn6IQYMqdZHBKfKdzGTO?=
 =?us-ascii?Q?3otaHtXGrSB0RrvdeXW0L4fp7a3XlZ75TVXu0hNXGeMTGpbMWpEfBxTMJWvo?=
 =?us-ascii?Q?BYyXx8SQRElNI5AA6BbhijvJczO32Ls3gFIOiL2BxwurMOmMLauTYWdpYkdX?=
 =?us-ascii?Q?JoJYQsyEtEbbiZ8xI1YpEBKFVWuSvNBe+A5bX5REyoP8I7Q75GeKiyotwHeK?=
 =?us-ascii?Q?tRT4vcASfofZiXYNlc/9DXpEgPsuD0Ux1ZRyY3r1+rbFuC4iZOyUcSdNEFxr?=
 =?us-ascii?Q?YD2Q39sgEmC8NsuFQUt8pTOfvfCZgxnNkfhwRu/+pLeUEmuVHAzQqIM37nsD?=
 =?us-ascii?Q?s15fqlpEDleDgFaodX/ZsUa6IO6zZ4Wv2WKoaF2vZL7vm01GDa/pKD3lAL9c?=
 =?us-ascii?Q?LYqxG+ru/JlGdYzhxVAB+tbpYfVMWQ6YZbUXSmQNzmoSQwtZnzB0tRemaQua?=
 =?us-ascii?Q?mxqiTYduIWakvbyUEPvAwuQuAWJqQT2Q0lVPr1ORKo1SSgln07OcdUDnw1+w?=
 =?us-ascii?Q?Wxiud6nI5OsXQeTuk0zNz0aGklH8jjKLQyKRHCP9xAfJgHtFA+CCiB2i68iE?=
 =?us-ascii?Q?qKOt1ej9KEdoEz7OuJPO57qk3DaWU0NL5UaoDvswLkbIHUHsF948FYc1W4IN?=
 =?us-ascii?Q?Lr3BvTEUfG1JlcvFr8m3XUJMk91aCmFAgGZdnq+fVqG8DwrgxaamdlHh9e0D?=
 =?us-ascii?Q?6iqkrrjpLK22eKGFzaObPUrqxlFxLCgR1HMNNmb1XG4u5C2qfzg6kAOnxgxd?=
 =?us-ascii?Q?s6xIAHvAqnR3mjJKmpHektTiYgOkJ+zSLL0ez1ok4IK91YFq/5wRRqVKpR6O?=
 =?us-ascii?Q?dig0v3miEe5GzZ18Rw75FaXZOx7gJQZiJVk3qQMyJiSZRdf6FWFjAblpUKwf?=
 =?us-ascii?Q?T5O54+jrv2cTRMaX/czdlVT3t8DRokAixPGKjI5O8l5hyyd1MFYYaXjGBOYr?=
 =?us-ascii?Q?C1SCipNqyOyTRlvxKmMMv8nKNpZzPvlkyYmywNPSjB4T4+dP7Zf4X2bql+ay?=
 =?us-ascii?Q?dAeaX05Hwl0DpZfJCGxFsq5efKK/6J9TMJjTJMW2Q/lI7ZaiSVnfeJLxO9QP?=
 =?us-ascii?Q?6NHplSXsKL0BrVrxNf6BFBLiGGF4lrecs51RivXZtg0VUdxv9IuRTz29XZYb?=
 =?us-ascii?Q?nddvv0/2o4aWJ8L0xvdlCHMkvZYj1hq2zWLBTGSi5zOff9HmrQzFq58fLWli?=
 =?us-ascii?Q?CSq1z4uom3UNsRupwPso0/0QNXOTMUDiwfCMaRm9qfx96IYl5Sy+EWzu7iiy?=
 =?us-ascii?Q?UzJdrAnuqK3elv+HlUjPPxMZdE0d/a1JqTpLTgialpl6/yyemgkK1ublGQzG?=
 =?us-ascii?Q?K9LfBuk32JXutCcMtnmqUsWTCrxXfQzLzV/BWACaeExbtBKGutcwNgbBZqs0?=
 =?us-ascii?Q?Av6z5w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039d34de-e1ab-4115-a1e4-08db4690bf60
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 19:59:30.6635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAB9lWxWLjyQXkkqTTFQlLhR9zIiwfGPMnffvYA4PYAvTNw6zo3t+CbZoyfEMPyaC1492oXQ+G/6xtvXy7kuCbT6ByIhlvvarD+NbGTwtiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4887
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 09:28:17PM -0600, Maxim Georgiev wrote:
> Considering the stackable nature of drivers there will be situations
> where a driver implementing ndo_hwtstamp_get/set functions will have
> to translate requests back to SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs
> to pass them to lower level drivers that do not provide
> ndo_hwtstamp_get/set callbacks. To simplify request translation in
> such scenarios let's include a pointer to the original struct ifreq
> to kernel_hwtstamp_config structure.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> 
> Notes:
> 
>   Changes in V4:
>   - Introducing KERNEL_HWTSTAMP_FLAG_IFR_RESULT flag indicating that
>     the operation results are returned in the ifr referred by
>     struct kernel_hwtstamp_config instead of kernel_hwtstamp_config
>     glags/tx_type/rx_filter fields.
>   - Implementing generic_hwtstamp_set/set_lower() functions
>     which will be used by vlan, maxvlan, bond and potentially
>     other drivers translating ndo_hwtstamp_set/set calls to
>     lower level drivers.
> ---
>  include/linux/net_tstamp.h |  7 ++++
>  include/linux/netdevice.h  |  6 +++
>  net/core/dev_ioctl.c       | 80 +++++++++++++++++++++++++++++++++++---
>  3 files changed, 87 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
> index 7c59824f43f5..5164dce3f9a0 100644
> --- a/include/linux/net_tstamp.h
> +++ b/include/linux/net_tstamp.h
> @@ -20,6 +20,13 @@ struct kernel_hwtstamp_config {
>  	int flags;
>  	int tx_type;
>  	int rx_filter;
> +	struct ifreq *ifr;
> +	int kernel_flags;

nit: ifr and kernel_flags should be added to the kdoc for this struct
     that appears immediately above it.

> +};
> +
> +/* possible values for kernel_hwtstamp_config->kernel_flags */
> +enum kernel_hwtstamp_flags {
> +	KERNEL_HWTSTAMP_FLAG_IFR_RESULT = (1 << 0),

nit: maybe BIT(0)

>  };
>  
>  static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_config *kernel_cfg,

...
