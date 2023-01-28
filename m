Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07F967F83F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbjA1NpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbjA1NpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:45:04 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2126.outbound.protection.outlook.com [40.107.100.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFCF234C2;
        Sat, 28 Jan 2023 05:45:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aH05U2TmJXjli0tAYFhjxb8Bx4C8EM/7Nda5FCQejIqi7yYEWXuOxv47YbtwNlpmAKSPqeUFvsopf5jG4U4hg0OrF8XY0dMDkqscees7Ivyi/+c9GW84Or8FK8LLamU9EDk/mIaoCBky6mqgNQC0hMBN5+5JViPvyDAXj1n9kI9DBffjkX82wXDCGxJt+IdEPESAg4zuwF8j5Zd59HO0A47ITCfav/7FaHzrHxdIgZAOSf8+s2wZMSI8XVHYCY9tY3iBSdBOF9g/ghRHC+ggWEGolPOWde7MNhCJ6zzmoOTKF5mJg2R1Fj1V+0VxgJQowIdtSuIHcC68XeLyEmRzLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZowlLrxjQ8qeJZqwDBY8sJGeuBkkSbFWxJBEwjTJQ0=;
 b=Yh/FQZ8y/o1qtWCuAqxp/ORfw1d16G0Zwkoa6ft8Z7Q4+K/OyNUBExdJ/wSn7w844KctNiGofiFrjUeYfkgmpIjE3RETpHTxrFoM2Vr2OuEq2Jwt5WoApJkyRodsXiwgKVXW5cvq1ppz9/a81dgojfhcsyA5HT0r1rsnB9WgyVVQ1doIeaTdcwdwtGOOdJpSfPFN3qlYJV4y5QrB5wG5lEoqsPAxJ8EVpsK18zcN21IRxfqj/hN0fyeQZ+Vzq2uGf21M336qAhdjL6lKMpZDvH0F9VCDyjbC7/TEMGzEMVkp/sXlTN4QfadJsVrDe7qWu8+s9x6kRnq3FD3HTqTm8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZowlLrxjQ8qeJZqwDBY8sJGeuBkkSbFWxJBEwjTJQ0=;
 b=wQJmRoW6UnEYdNqqEX3QhAEhEe+S8121vMwHF27jKgOqblUOlM4cpLJHrKmgMJWJTc6Kiw0LU1RdEgJ1tkpLb5gck2jet8b8SMftXTSoW+EOxQv1g/kDrGS8CdOuMPOG4M6QQ0Ok+MNjt4glHfm+CVOjurLlppz51YIsqxdlvCo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5444.namprd13.prod.outlook.com (2603:10b6:806:233::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Sat, 28 Jan
 2023 13:45:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 13:45:01 +0000
Date:   Sat, 28 Jan 2023 14:44:54 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: hci_conn: Refactor hci_bind_bis() since it
 always succeeds
Message-ID: <Y9Um1h/2V9mxDrIC@corigine.com>
References: <20230128005150.never.909-kees@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128005150.never.909-kees@kernel.org>
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5444:EE_
X-MS-Office365-Filtering-Correlation-Id: 399e902e-7d74-4a74-280f-08db0135da7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XksWpPVuelSseZAR9iY/qSXybq6oVtefmuMleOWfBZT9EZBLcECsktWV7qh9WU/FrmXYQ0nM6CfTc7WSFU2Xt+y891urIiTF6LTIS9L1CixOrTOspBoWwcPd7zqbBLhNd5OT1QbLO9ftKgx6+lSUycgkNvDZZ5e9FB/+ibrfjxpeuOF9PqB9TRtXiP21ffT0Mw10gOlQ66BoeIRRE0C5Gm8ZgFOFqx2VticONP01z8koVKszTqG8Y2uZq4iXkGV3CPSa+49L+hkQv3shjkH28LnJF6gex/8Kr44WS76aZKPBbz4gfdoT0FwlQ9vnh4lI0DIRLbuKKK+2KxDzxGqM1P6SWE5QITmhP7tvgTZ4RY8pFhpNHCbQ2PbuBQu2L74jk+s4V8RKLGO9a6FuVVIKOG+J/h1ysHo4Gv1cly5Xfw9sTvDG7QygA2wUsDKQKgoghQDV1tXCWg6vujQEb7+3aGyaSzMEf+RcGqz6dV57cQngMXRq4aDR5LssqwRS3KkHnf8/YYEJlXtpVdQ1O+sVV2mDn4G+qUxb3/kPA2qFyOxsqHUF94pVE8GPMbo+ULoKsHNN8/5GbVYcPiGhttRqEZCXegSWPikWhnpVT+M4LszcFN9umHh7Y57UXEQVmxNzPzAl9GS2RNtfpaVpjYFYUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(39830400003)(376002)(396003)(451199018)(86362001)(38100700002)(2616005)(54906003)(316002)(2906002)(4326008)(6916009)(8936002)(66946007)(5660300002)(8676002)(83380400001)(66556008)(41300700001)(6512007)(186003)(66476007)(36756003)(6486002)(478600001)(7416002)(44832011)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6KLc2LFhD7HIJA+tSqatk0bck4OZxL12/00RO88V4VBP13s/Of3zi5BMfR4y?=
 =?us-ascii?Q?fWSfOYAk9xcYh3wmon19dq6DiDe7yd5JOWcM3TH6saxueuMHmI0qwrVjsxsG?=
 =?us-ascii?Q?YGwuerTWPNci77wOd+eXMyykhYQA/Rkf32gn1xUzTDYbiWGXfsbkU7o2T/1c?=
 =?us-ascii?Q?lT/+juaX6vYmr8KWP9/esl8UoPbxKLbgVq6kCxQ2lLDcgNvmmveBW80qjJfn?=
 =?us-ascii?Q?/vLaThH/l2dS6jgLVTpPp4mifnpf9gfKDsiAGeqb6r2ly2YVgLZKyjSRqyNm?=
 =?us-ascii?Q?fFN/3OafwhZMgPxYmHNmQ4clLwEm6uj2Og49gFIzHlE26W080nFzeRbfxGJH?=
 =?us-ascii?Q?2G/ODnwLewrzNYKuAnYjZwgW30SHQcF5vOvyhCjXLseohzxaidNYsBkSP0BX?=
 =?us-ascii?Q?hUWjVWE1TG2kUXq14y68ugjIZsazXdkGi30xYz73I/14tg0bMvLpQw1tbIV/?=
 =?us-ascii?Q?+LcKl3vGUt5Tl6SU2zUDDYUbnX67SmdXuRR1nImlCFws0YHJONv9TAd88Qdt?=
 =?us-ascii?Q?+f12T6ZO/QLKBO88dnG3k8zPDg4PvledUJ8JGiZn7KbtSahKl1CYFPxKAxWj?=
 =?us-ascii?Q?Bp4p81kzUfNVIiVNcb9t5LMW+xWvetMK4CsBiWyGtsFcrweGdH1bICD4yv4c?=
 =?us-ascii?Q?2GCat5M24YxeOklkZkTLfdH/rdl0+KX1XDhFpEIgciAsBDe0vC7CiFBRJ3+W?=
 =?us-ascii?Q?KCiejY44UgBaZjTsx+skfezdBWYczUrYV/K6yL3asKpABuChjpkVDk7fUOg2?=
 =?us-ascii?Q?HBekX/6un7C38NUM9G0NGn+dlOEq+PVohKhimO0UuAEpFwFbgdr4waJvl+Lq?=
 =?us-ascii?Q?sT2niEfAiSbtevg6XITw3Bq/UloLVz7vyUsEgpRo8FEZdVHxaBTbEiz+EEK5?=
 =?us-ascii?Q?8QU9qC2HSFNZF/9DOPOsZUsu7FYx7Bv6oANZ6ofkqTD2uxZ0Jcich0QdpOL7?=
 =?us-ascii?Q?f4ruDZB0ZOkyKqSf9NaV+AK8lE4L3p3uFnf5r8U6/ab/2P+CHBjFRvooQPZb?=
 =?us-ascii?Q?4moXVAZvROHJoIQ1ITLgTT/3jp4vbqdM4k+BBvUsTjSVKr9XGX4BKF3Ae++h?=
 =?us-ascii?Q?/pCdiEBBzS73E/35adevMrh/t9c2FGtxIJwxuNogClt/XcXYDZPSbWGcr/Pa?=
 =?us-ascii?Q?aOuJkmc1WxSdI9CQplgOXwJAXxlvmecMNuLC7R1ayym/gtW0oNVtGhH/spO+?=
 =?us-ascii?Q?Y2VGyknCH1FT427k/ukeyph3l5kgqg2YGJu8uNWkCs7qGwU5upjTf0j/JWmq?=
 =?us-ascii?Q?BfFa0yayhJdVXBAcymhm44EdwowS4xlO5rAPrgWsd0Tg7bhBM8CUyh9jGpxD?=
 =?us-ascii?Q?AuFU6f+svwqIZnUT8lrAWmiVdqzTy7QjaWihCo8Nf+ns8X6+yIkpTs30ODiM?=
 =?us-ascii?Q?oDFDiWfcivV0leOnkfMDLKBDz2C2lz/qIyKxo5MXckKP3Rfb/SzZbYvee+jy?=
 =?us-ascii?Q?UR/tAllLrC6h7L5kEBb2kWMEZR0AciNdcI9Jn4jncfaKfyi04PkYlv+OPxF0?=
 =?us-ascii?Q?Dbm0WvPCbABvHGmJno27zxy7GxORwjGYQSM1mRYXaRlA/xWuI7jjk4Q7gVru?=
 =?us-ascii?Q?9m5AF1EGXFH1MvBwZw/7FONHDdEA30nH1EEV0D7iPTVjWSbj72scKZI48VL+?=
 =?us-ascii?Q?pLlnqX1sM1SZpeVAZscCMnen9eDK79oBNcoe14YwOnifWN0/uSudsNpk1gS8?=
 =?us-ascii?Q?DBgEQA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399e902e-7d74-4a74-280f-08db0135da7d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 13:45:01.5305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EseaYuyN9Mk4ZymVwhmVAEbGHixmc6H4KzqORkdL3rq/VOZt680N9Xx6/R7aHSIjlKYjTQLa9gMFf2Klm5IJ+vaQ0SUm4AZGOose4atUXUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5444
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 04:51:54PM -0800, Kees Cook wrote:
> The compiler thinks "conn" might be NULL after a call to hci_bind_bis(),
> which cannot happen. Avoid any confusion by just making it not return a
> value since it cannot fail. Fixes the warnings seen with GCC 13:
> 
> In function 'arch_atomic_dec_and_test',
>     inlined from 'atomic_dec_and_test' at ../include/linux/atomic/atomic-instrumented.h:576:9,
>     inlined from 'hci_conn_drop' at ../include/net/bluetooth/hci_core.h:1391:6,
>     inlined from 'hci_connect_bis' at ../net/bluetooth/hci_conn.c:2124:3:
> ../arch/x86/include/asm/rmwcc.h:37:9: warning: array subscript 0 is outside array bounds of 'atomic_t[0]' [-Warray-bounds=]
>    37 |         asm volatile (fullop CC_SET(cc) \
>       |         ^~~
> ...
> In function 'hci_connect_bis':
> cc1: note: source object is likely at address zero
> 
> Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
...
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/bluetooth/hci_conn.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)

Is this really a 'fix' ?

In any case, the change looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

