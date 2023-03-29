Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1972C6CDA1E
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjC2NIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjC2NI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:08:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2113.outbound.protection.outlook.com [40.107.92.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ABDD8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 06:08:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gF4DVxfNz1xfwdruH5opgB9xKpbQcJkgD6rE61O4RK2tgOR7DH02b8KmfuCfcF9gtlHfQFulVjjiBZ61RIiLvyDxpYaQBiqfnMre8SdJE0DzdFQvAMOD3i/sAQhOLXVi6GTgcLzR04EuafnLYO4PQKh4Z0GTxsZpXiSz7nQKw5dlkN5PxQLuCJiLPlLfZJusXWLb7jx3RV9pqcra45jHN40iOP0yr81UQKHIcKJM3l+JLD6xREriEunrnqMjJ0rnfPZx5lUTFuoo9yttws2dq/UZ2kPQYJK4bhDiZN1PgVBf+C0hT1JYO0FLZZJFlWX8JRuEopsnOSz44bWiK1u0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNLcXkBEkM7lq5G2r6u1tHwCphPts/mQMQvoUP+AYws=;
 b=TQ+d2UQbe8RYEG2oAGMwy1KPkUMd7jxkYfOwcJlPanH+FOXd1LKKB+KZMOxtqZ8nv91lut1QEKAv13ATkI6VYkyXObgosI3/x3A0YH5SGhP79PyFM5zVAk9iXCMxQXGZAr7Ro9/ysV5uEonb/MRCDA6OoveBJymXBTLixLtGSwHjJAhK1VarI8NHR+x0MfCMZqrMYVJYW2yJhdJqa7izss7ho6Q2KJTT2Ium+88NgGTtvdxUH4MjlY/iR/akMPtgiSkEmu4ZlC6OiyrST3/malmuBUM2Iu0reTBBmVm0HQCgJhJviGYn7GWVJjMAdTSyesQ0C/lLO+7b1lKjHu5jeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNLcXkBEkM7lq5G2r6u1tHwCphPts/mQMQvoUP+AYws=;
 b=U0rNz+v803j5w02EA3vBwGbDhQ4EHOLoUs9jHMdgKcIC5TtYNOUpbalBbrZI5TtzBRpBrQ5uj4L2mjDVQik3uM4lTOIFJYrQhvC6JP3kJfwT6dFNpbRV6hPyRcF6ogg5DifxESArxXamrxzMad3AK/IqIt1XHKUgcfnqq+wEy4M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4132.namprd13.prod.outlook.com (2603:10b6:5:2ad::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 13:08:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 13:08:09 +0000
Date:   Wed, 29 Mar 2023 15:08:01 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gospo@broadcom.com,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>
Subject: Re: [PATCH net 1/3] bnxt_en: Fix reporting of test result in ethtool
 selftest
Message-ID: <ZCQ4MYXuAKiqDuae@corigine.com>
References: <20230329013021.5205-1-michael.chan@broadcom.com>
 <20230329013021.5205-2-michael.chan@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329013021.5205-2-michael.chan@broadcom.com>
X-ClientProxiedBy: AM0PR07CA0022.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: 107ddcd7-2c92-4991-46fd-08db3056a4cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +JqxrOUXgweCSk1tAAZ2Zn1sk2eFjcPyzRQHiOSEdHNxe+omopukLnz/8vrBHvTWEmF7DljOxxg+bqTQD+recVm7Tefe7K7F7tjMicSKedVsChpfy/fyqnOBmodDMLGLdJ47SYXJaz3v/Pv2SEDzpLPd2n4r+2sB3EvmlPrn9omzQ63tVGEzFZz9kZSjweQLBdN7rp5XvLaAqwPZ/ZmKOeW/zzmh084lGTLJBN6DtXe4oFrwAAiXIFf+xTjDiPqFlX1LZ7wWCvwE794vlYIve8JSIKBLAf96lcRcGYRaMVN7M1jvVLhHpTFPo54g6M93iAvcC9LPlmeQ5Bw4oX7VB9kJOhHuT7aReSbdGWYHVOxDHcDp/k2P/tO0S71XPBl6GBBXlNpsxSr0KMGKT28uWa3kpTH+MhTYMpu2BDjzMAFdlMrwU2nBBEwZcfeXKF8YU/1qcNp9zw6jPJk5CbpwGe34RsdzG77LFk/BKcIYHycHReJHSGut7KRvvkBvQLDa5KHMC486Dup42ykZHyfVwZ2K0b40p88XBlfk7hkHkwzfpIErnkaX6SLrEtiktfN6QqRPH9kUp5jUJ7Pm8zkvvaR1vUsgMkpwG585Lok7JQE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(346002)(376002)(39840400004)(396003)(451199021)(6666004)(6506007)(6512007)(86362001)(8936002)(83380400001)(186003)(2616005)(6486002)(2906002)(38100700002)(44832011)(5660300002)(478600001)(7416002)(4326008)(6916009)(41300700001)(66476007)(8676002)(316002)(66556008)(66946007)(36756003)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lRaEgmjazn07RPXsE2N5U3APZXa+sSp7/hCF+igE86doJmvPcEJd4bd6fljc?=
 =?us-ascii?Q?erOiWZrdPme3SLWHfSbM+upYVJnWHCVdOqLpcuC+kq+xqrymvvnq6YqzfaRj?=
 =?us-ascii?Q?GTYEKL0TVf9uf6P8vnLF750X3xZ+5y5EaLnhC2V7E32mblZSZd1H257B1mL+?=
 =?us-ascii?Q?yaoBLWI3F2ivxe7mf9WMtKsSfVVAkeFGTARMc++t/2BpyGqjQzueSiZYi2gc?=
 =?us-ascii?Q?sHwedZo+Nhkj8XJtvvcx6Cuela2jDYtBvTl/EqKy2DRVsO/L5PTSjl6VIpqv?=
 =?us-ascii?Q?dMmcZiCijsMXVmu2rsvNu257L1z2deP+bSTg0+bGsJl6f86/SEKVu/S86lOx?=
 =?us-ascii?Q?GED7jF01vRL9jj11aCaUSlX72lgLrUPsCekKlNR4UOrLmqq4onj45rjXnLij?=
 =?us-ascii?Q?+lDKyX64pcIHP0rqF6aCkntcuxGhvaw09BtboUJWjJp4IRU8xZgNuCHhDVTO?=
 =?us-ascii?Q?9oxkngvYiIB/BothAQBWttW0evGFrEk1uogbDrjV/ZhS6eOZxvFA/vtHOEsX?=
 =?us-ascii?Q?h5na1U4uYjRBW0F+OqG2tlwtQ80mVR/4nox2SkoGSJK7B++GtKqKeRo586Tr?=
 =?us-ascii?Q?YEZlIMT9TfD6uJzts5ZoK3E/SGv+CIReOj2hlDtgLVr1zWeQNgNAytzp6r0l?=
 =?us-ascii?Q?ycmHJ/W1LVJ4YYGS4jr23963TThS8tsmnAadOUcjYZSDctXcSnoz1ffgnVtH?=
 =?us-ascii?Q?mMZZyJU0pnaxyIhw5C7ld0iYBMAVk+BzXe0XjTtOrgQfUcjdam5+vJpvdr4s?=
 =?us-ascii?Q?KEBACLgvfgtvRhOZI7evsb8hjtGjyaRrGdNsrxd9ko4eh2Tet/OIYakrfixQ?=
 =?us-ascii?Q?BTTPqx1dySlA33hv7AnbFW2Bn4SmEFZq4ZDAJWPzGe/jPVF+IwEqS9XsqtIL?=
 =?us-ascii?Q?3xf6CTpmV+rdQ9hn8Du3sds2aU3zx3GxjZmiFSrpA4w40fXfRI1mRcvlkm4F?=
 =?us-ascii?Q?lNpEu1UBhXw1f26xJdCox/0mvLcqd1u0ZQzszqv6p9JXgCCUv8mhzSGnHyUw?=
 =?us-ascii?Q?g9v1wXqD1nfvR0GpMZZaw0WrZ92YhF4Gqkskd108zmfUNo0frKThqQNTekCE?=
 =?us-ascii?Q?Lpl+KRGwG5bwFX96orlq8Xfcb9bMYztSdRNnjlga5hfYmoiH2uyx/YiijMs5?=
 =?us-ascii?Q?cyDQRPCoXYAYM44vym+ebhRXt6QsCbWtBfXycWxLSo1+/FzQM7PrU/BJAyMu?=
 =?us-ascii?Q?qhpu4rmo08R0TReOTlfShQc7Hg+9KzKVLGO21P3erUoykMqIsSYp5g98x/4d?=
 =?us-ascii?Q?q9xrf/99XDOdC4tRXM+AUZlNtKPgNwb3Yw5aE6OjsZy8nokhzVAftXA7F5Ei?=
 =?us-ascii?Q?AuhR8kWNiZUX3CipfE0TopFXY25JZAlioPuw4kjeTgtRNuPzi/deFbg4TLUQ?=
 =?us-ascii?Q?83pcYFVtJ4G+pSgQ0FW0SC6w1Az2Tb91PEsFduibQhaKfCwRlaojEsknKP8B?=
 =?us-ascii?Q?C3Y5AAshX5EeP7oG1clazUkYx3QgoP4996TlkFMtlXFjiPOaaNCV5/YAzuOQ?=
 =?us-ascii?Q?wYbP77jQXCU8IqlhrbzH/NdTr9WdHalCd2qPxdCUKhDNFzGqv69rCZgPOgN/?=
 =?us-ascii?Q?KE7UiOeGIObbkO5MzYP0dxArhYxSjNdOQD/rxlPGdcMbZY3euQbYp/nThuw8?=
 =?us-ascii?Q?6mln8V30T4cPATdShoZ9ZDJPyXAV2yRmP9cmEbtLf1ky9qAT7wWUraTgCkj1?=
 =?us-ascii?Q?kkxSWg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107ddcd7-2c92-4991-46fd-08db3056a4cb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 13:08:09.6095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ex6UIkmGWZGkfdhTHXew55/cQCD5rsWWc/K7nHMkEAODv8TCaTHob5QPCJ6kq+jnD2oP4SrLwExvksAJz7LHvFQD+Z96z95ajMcYspKxkB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4132
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 06:30:19PM -0700, Michael Chan wrote:
> From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> 
> When the selftest command fails, driver is not reporting the failure
> by updating the "test->flags" when bnxt_close_nic() fails.
> 
> Fixes: eb51365846bc ("bnxt_en: Add basic ethtool -t selftest support.")
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
> Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

Note: I think this will require a manual backport to get
      all the way back to the above referenced commit (v4.12).
      I'm unsure if that will need to be addressed in practice.

> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index ec573127b707..7658a06b8d05 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -3738,6 +3738,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
>  		bnxt_ulp_stop(bp);
>  		rc = bnxt_close_nic(bp, true, false);
>  		if (rc) {
> +			etest->flags |= ETH_TEST_FL_FAILED;
>  			bnxt_ulp_start(bp, rc);
>  			return;
>  		}
> -- 
> 2.18.1
> 


