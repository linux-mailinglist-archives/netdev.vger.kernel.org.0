Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3364A6A08B8
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbjBWMjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbjBWMjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:39:23 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2117.outbound.protection.outlook.com [40.107.243.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBF7BDD8;
        Thu, 23 Feb 2023 04:39:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQX59DMBhk3pM0dMnczsWTQD+oHkwGNzyW06f1qPn6V8GlXLHPV5mtZjAU/aR8MmK5J29BZbiZdHCk3I5EyaR4xWRFANJmm+jl4tUQdaPTbNflciprMukCNj7Q7JD0cWCx8iijNxXUlxc1qgYkPXFvrvOBbtgXzmSlJzO5Bev5tANUmTgsYV5vYqvSPA6RCjfdPRhCHDHnPA4r+D7syzlfaFPuPtGQ150AM6Jnyxaxa17c0/qEhLXbI9VpT7sutNNtKK+CaTaAC1AqD/unYJ2I1jiPklBa9vwWrEXkaqA+ArkbKxgzCZem/F0B3+onyoK+GZ9185UG3X1Ux4QCxr9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nag/qL74DBNd0chPq08DcR8rgZyO+0I4xj79deORoQ0=;
 b=ii6yA7C5/JTPuHo7iFz41TeOiDC+lt0GDHry0o4E1zGm+ocgOJc3IAu2Oc7h0Sbr4QEtERK997vxC6wPyMc8oySu5T27Va6klogg04G4Ew+jdInG/6hZzYuult0hO0jfeSWH9sKpD+ZUBZPpSC2o0jCfd6gbEZGJXSIGZ1M10QxOMdHNNYq/ITGjJIvcISS1kF7gH2WFRn6c7+poUoeIGTmgnF9uxtf0Kzy0qSAN5LvieABd1cVPLHDOAKdig4IWWibmYPnBRk1k3BVcu/ObELZ3idqBuD8FFw3/IUIdxaREzgQoJSh65sULbyGZeZY/WFgwymzXSZrD5JGU5xRQ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nag/qL74DBNd0chPq08DcR8rgZyO+0I4xj79deORoQ0=;
 b=ZYnVtbOW2aNhHznnPMp70qkPLHeF/v6S9Ug2GZK17ow1itUSdpfzcpiJIpTXu2m+y8jn44nHvYmNOl1D9S4x5K9fe2LMeV5GZcI/AzgVJh7Fd9IxtBX7SbyTI5dXVduIR9WBFo4ECZ9tmg7JsCvxBn49ol3ZTuafS72MG6hstJo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4055.namprd13.prod.outlook.com (2603:10b6:208:261::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 12:39:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 12:39:19 +0000
Date:   Thu, 23 Feb 2023 13:39:12 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: openvswitch: Use on stack
 sw_flow_key in ovs_packet_cmd_execute
Message-ID: <Y/decDeptTieXwpd@corigine.com>
References: <OS3P286MB229572718C0B4E7229710062F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <OS3P286MB22957CD400DAAAB7786FEF96F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB22957CD400DAAAB7786FEF96F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-ClientProxiedBy: AM0PR10CA0102.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4055:EE_
X-MS-Office365-Filtering-Correlation-Id: e4f02e5c-7861-44cc-0d3d-08db159afbb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gYpBkfrG/FbnKUcfBp1DJPs9jRTnec1ikRbfwB0rvO3DzyMdHipYtTem2t/bdxnSErnhCc2cDP+kw/aaTTxm4TSDUUfhI3UX3cDG85hORxVNTBCrPMnTbW0VPWklk/ROAjDT/jwOXMC2aQiuKpzYBwJDiIt/mWtZUd0kqlv3cL3E2CjbPYnLXXT5boaiPYqlLDrL4k3HJodeQ/IhXWsdhTg9COuxKtVfuQ9J05rEIQLBY0j9nAOXYoBIFHqtw2/MfI73HseSMW3LFrF8Jmmu8eQ2J2PGISlflRKni/u2T46Pkulkh4TRteedIRu7nouvT/e9GSn2SnLqrzddjfpGVffbm4LfNeL4ZHgjnY6QKgoVl+yxXYgHR6PsHK58Kqd6sPoQFgdI4MjwNSiWc1TKkt5pZkUMiI/PYwasl1GfnE7047niUl1ZiFv2CIoTEtp/Dy5UJBMnZI6jGBJHe7V02iu5rkXLzj8QHvD5seKc/OvGo8SmIu3ZlKn+c5ik4FRxBOC8yC7gsdfEEZ7TLkHPXHsIL7eWyZUxtl/5FQTRapQsxgSnO2UNsUeJB7wXFrQQtdN/gCysD6NXfTKX8qoOkv+tOVqUOTtJcrHqEsuXOSvy7FcEsYPyDilpZzj3lQ8P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(396003)(376002)(346002)(39830400003)(451199018)(44832011)(5660300002)(4744005)(8936002)(41300700001)(86362001)(36756003)(2906002)(38100700002)(2616005)(6486002)(966005)(66476007)(478600001)(6512007)(186003)(6666004)(66556008)(66946007)(6506007)(316002)(83380400001)(54906003)(4326008)(6916009)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X7xMPD+tU6uTNFza6mK0VIhydE5gqCXt+m03RUEy28/pmhADw8zS5ZI3GVXL?=
 =?us-ascii?Q?XFfBnU8WvCQhLELuQTbbVTAuvqFUPV/eEPsIxuwXvQssAGjdXzx3Zm0TmqQh?=
 =?us-ascii?Q?Le04voclnKg6mA/xvZEDu1npyOUXvQw/Wmxzm2UGohNkuhLOdQpHLykOOaje?=
 =?us-ascii?Q?fny5pX2XPYZ9BdHUQmFkZ9JHiirsvOPAEfPw72ei+60xK3Xom6MPSCIiFEtC?=
 =?us-ascii?Q?Sj1qCxIsHyR+4i6jJhVV6PYwkDUlSf/Yqf2HyqBGqiWxCCueDE4PgzlVBxKC?=
 =?us-ascii?Q?5CNqZRA4dAXuK6Wzv+n2hxCwm3kr0/BH/6tTa5w+OIbAZYUwSw8ZbIM1uqPz?=
 =?us-ascii?Q?K/np12GiZeUNezrl1hHLiun4balxOFtQ7tbNWKM1QATfK+pXOhygM5XYfL4J?=
 =?us-ascii?Q?27RJwDSzf065ejm/0Tl4VBc8pOKel6QM+lXSWuxjWvLCIboolK8lvkSdOOl3?=
 =?us-ascii?Q?Avbf1dV4P1wnq0251ovnxPX3XXui1lKSHmPKxa1f7LKCzpY7crKuK9BcFkTh?=
 =?us-ascii?Q?hRu23XLzINF1D/Z3T2BiLCmP6ubuSkCMyqOu3drN5yWpQIzZIsNtGZc4zkey?=
 =?us-ascii?Q?0MBXMwoSD0O1n3hM/vBVPVah00H36EX40TyKsUMrzpFeEItA2b/PQb4q9QHc?=
 =?us-ascii?Q?UYV4esTSqcUGxdC5IKCKj76jzxuvafMRJfXg+AMtDRgzOOyjf6QpW6fne4RO?=
 =?us-ascii?Q?/k1KsyFjgOu9612Pc/YNYCJovj9g/qa7oIGIVIZIym8WnthxlmhYQX6OeM/b?=
 =?us-ascii?Q?IZGK8MomZv69xD/7u8UuRUEfNl/uTLjAOvhH5FPcjtxC7ePMV0i07N8mrxzM?=
 =?us-ascii?Q?ZgJe8UmB3Ku6SqISBJKX0eeU0/Xk2SLhM2JC3aovUJM12REOSwIAQ8KioNoh?=
 =?us-ascii?Q?Hz1D8LTlJ3oxrqhlpgWljFfBboDY2ZKsTJHfavs190Fm0/RAZViv4zeibPNz?=
 =?us-ascii?Q?ZQnEetsgRdVmjVtsjrSLGj0wurVspSRn/rX35T3HXCXpgqic6MPS99hNWfXs?=
 =?us-ascii?Q?T3t0iD3i7Lo0WXzFLIAFZg2SeHLN2UFayKN8AaY4P2K1ObbQxv1P/sjXUTzC?=
 =?us-ascii?Q?pE4mhaU3rvyVg5AuLVWsPEiK4UCYOJTKy0uWP5QrIAzOhnfwacCpIsijADRN?=
 =?us-ascii?Q?KSdHZSseKRqLMbV+PWQLnVs4Rq+oDcYuMmyc5t6HxJ1vIEOtYBdX9o3lOdOW?=
 =?us-ascii?Q?5P2ZDq344iMfBXsItnHfC5fXnyg1xlYW1/H+f+bWTGZEiyAv5tL4jN/CrDo8?=
 =?us-ascii?Q?UPBe06YiIVWuo08FXiIZLlnep3tYh+nXNMYSj7WIdBoLk5ngBlKBe+HAbI3h?=
 =?us-ascii?Q?QVceJvo3B2y4hDGW2oM2nNk5UNbn5aBLuwyFAHG6EMeaq3EQTniex1fHI0MZ?=
 =?us-ascii?Q?TFxu2VYJchFfOuufFQ39uDUTrwktxbPRDUj+mFPOb0sUCjXVAdb7QTDV5H27?=
 =?us-ascii?Q?4PRvi0KDgXbcfJwYF1M+LndV3Nymhj+IIrda30SWMiV9Vb1blbACcGyksDg3?=
 =?us-ascii?Q?etFJr3sg8k4SrFuVvNAQV70ruSqb7x1XAi6WutAlH4abH52w7rVNqDMXTN9G?=
 =?us-ascii?Q?QRUaKvVF+umen8FMUhhf5di4teZRKfzzb8z7wWUH+powTB0Fdlotp+SwW/aS?=
 =?us-ascii?Q?ZZ9wbJouvECpv9TRbwpVN6mTbsM4OHDOnUI58DRQf/0BvZZuxEVtnEzrHUMY?=
 =?us-ascii?Q?LDTUkQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f02e5c-7861-44cc-0d3d-08db159afbb2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 12:39:19.8234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4jPlO/VXf0emD/tlcstheOoV3YEfczmvs1pEfomJieJS4xK9W0YmEimobK4SScfPhC9cx8vEMweDZevz7Qxna98UNTCmg5iTZjz4+3Feew0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4055
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 08:24:50PM +0800, Eddy Tao wrote:
> Sorry, there is a typo in the mail, i will resend shortly, please ignore it
> for now


net-next is now closed.

You'll need to repost this patch after v6.3-rc1 has been tagged.
Or post it as an RFC.

Ref: https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
