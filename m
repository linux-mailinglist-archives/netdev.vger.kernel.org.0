Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8016CC293
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjC1OqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjC1OqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:46:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2130.outbound.protection.outlook.com [40.107.223.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EDFC67B;
        Tue, 28 Mar 2023 07:45:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENpgPC/KFZEm5OJo5px2ITAM7fLcxaB3okkV/vDJQ7sLZ6vaO3FZUzREqyJZNOmbYRj9+iXEKKP7Dhm0HMDLJ5Ua1iriCmENQKnjoAPQtyyzr/mHi9QZK8ap8aIKGVHQEdl3SZ1NkMl8nUa8hEg7WHzTMbOSgz8sQ88NfZ92F44HEedjD3HFx6hVFm7pUJNh8U1mfvv4TO0V3Ml6Faf6dy9+vFhNwWhmPauTYbbYM/eMsk6T6UVDxuuyr9uchEglddNVVgFzAjOtqjsn2bkRXm7l0TdgKAHd7wuOeBoox+I5ex3eyfLDaeYVOExYSIl71h3TPpkEJtoR27uPi0ahVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaPdfWtm+h2/bo6GQuvucUo6p+G7fNt0laX9A6KRryU=;
 b=F15kNwsULUgsmmEJuMCxJBeZ00qK89tMtyDxi1D21dm23Ws0lV2khmXWRAnQJGhMx9RwI0PUA6uRBs8zT+osmwj6aZT6i21SQL4XoyKUVFd+0OfiSvsyn2R7wTv5nWJx/7abudRvVssgV6nw8wyBmlrPaETeYxwrzqfwjP3SeopQXpJNgSQKNMphmJbfT6GySNKlNMhB8yeeL4yMVVwLA0j5LT6ewQ7pSyEoFMKa/TTqv7caD4gGQcPEOuBDmd90iAGH6WrgaOetl/lvoYAskpG6sKOIxH7T/EkdU9aI2BwA3nsoHUH151VKI2WhIHUK5ywWYequ5siJt+c9KU8rfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaPdfWtm+h2/bo6GQuvucUo6p+G7fNt0laX9A6KRryU=;
 b=j1/BcHnYbA4lr/J79/wiWBDE33+JyDyyafN4Wqaiin9+x2mdhD0UXhTLkdhmLgbCdl5KACfo9tNsVCzaniljPz4YHkql4pZlNIIb85NefHtJx7ecsAmnaZWw5vP2fLQhAE2TDEwof8bGYIpC8Fl3XjzPHiAc9HC64Wu3yLnWyVU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4635.namprd13.prod.outlook.com (2603:10b6:610:c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 14:45:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 14:45:52 +0000
Date:   Tue, 28 Mar 2023 16:45:44 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvel.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com
Subject: Re: [net-next Patch v5 6/6] docs: octeontx2: Add Documentation for
 QOS
Message-ID: <ZCL9mLrWoTndLrvP@corigine.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
 <20230326181245.29149-7-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326181245.29149-7-hkelam@marvell.com>
X-ClientProxiedBy: AM0PR03CA0004.eurprd03.prod.outlook.com
 (2603:10a6:208:14::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: 1901fee2-c168-47dc-c113-08db2f9b210b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cqFG/FQBHTUDPezTGNmczRXe1VtsjEAW/eb59KQdCuoxIMkMf3+CJWLz9IEV9Vn5ydwPQVpycxXtysovKG1A+/nul7t77uPmJKeFzfaW/muKO8U9laIl/teNpoDHNkg5a6+5b20baopYuGbSxPuKpH+CSnzJghLha+K7iNIW/HfkMh+eR3VeWq+OEg+gZQRDUBDFAWBjnOQfvSga0msWqK6Q8ZRtjW+8Z2fWtVT6JLW/RZWHcJWq7BWD++l+fX3JTGlNPonUP6DBkhp0lk4ai7bs+GgC01arsdozZWSGRJ3RmjN9fZxE/4W6hq5IlmNG/TwCXcSXLCNk+ZtQty+UZV4BLfPerIISwZ4bch4NAAdTFFLHibaSoPJe4DbSzM0imFzriLZGN9VcbkKLQbnYj5bpWN334wGPh8ixH2zMBacJUMYwKfGjp9ojvWV58Czr7GsjyBbD8o9N6lhWSzODBbq+6XenMTQdTeCqsW1uhbimamX2AqJLx0LBMjBVaoE7KIys+TuvVY8lX5cnz/axd9ZljMZI76cICEdhUm8uPzkwbc6LnCgTE0knUqGtPSW3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(366004)(136003)(396003)(346002)(451199021)(186003)(6666004)(316002)(6512007)(6506007)(2616005)(6486002)(558084003)(44832011)(478600001)(38100700002)(8936002)(7416002)(86362001)(5660300002)(41300700001)(36756003)(66476007)(4326008)(66946007)(66556008)(6916009)(8676002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Z64Ex4XfZXE1Ys1IPiZquFJhkzWj4st/pIaHEYyf/qj1U/r2ieYK7I2V+l8?=
 =?us-ascii?Q?cwYhsqhDIqvuFwsuO9y8RwsU1H5kqLW768iIKCpLNZ63kiuM8fAo6PhSivaQ?=
 =?us-ascii?Q?NOnfuv1jSGrp3SbqhbUCjy3a+/wR4C67lh70GJubYy9E+T/YepajISwTM5ZA?=
 =?us-ascii?Q?087s1PifmGHs2oIxuZ2ZlZ0b8xckwD8YVYLmV4gMH+WZH+hN/DmQS3pLKZpf?=
 =?us-ascii?Q?CxRhOOD5q7tDInH8EVY4bFTyGZ8gu5iV+Di1QajwVdVJPak7ly99Cy89FJNO?=
 =?us-ascii?Q?vLhHtldB0Mi+Mzk4vvx7KwXPuKKuAult4E2caaW1rST+z4DYITIUCmIF+XKa?=
 =?us-ascii?Q?tLN5ST+B/OP6fjMLTs0ooGJE2Lc9LQNGnWSeEB/EYjWRt4Z0vPc3F6wZmmu1?=
 =?us-ascii?Q?O3SQ9UcoemKZzU2Uaj4hQZhwoOPhU8QKZQkzpIGJkSH0CZipuRiULWSqFmHe?=
 =?us-ascii?Q?V3ax3KE7GXKP5FR7o6/M7VGDDKm/lXM0lkg3DZxpi92TziuUHRhFxgbBd36+?=
 =?us-ascii?Q?mbVREEmbVFNyNXVIvPdAr28rq8pPaUtw5GcgATXy94Mwb8dpnt8HONRlUxRi?=
 =?us-ascii?Q?u5C61LWQVexh1VUkQU8NKSYutPmZ5HtmQDNO4kT7dwAhjXc8/bNBjbECLOnU?=
 =?us-ascii?Q?Zc4/xskvP1unP95qy1CXbcukzt2gpWj7j5oYuqn04dOkaoBgiI+qaExrdWO8?=
 =?us-ascii?Q?4bbtaM5a5zHu4K5spNl+P23MiWXF3VnRTGi56EseAe5J+x+cHwOSav6ZlEnF?=
 =?us-ascii?Q?38SOZniW6PKCTUzEdkfyEYl1nVDZ7CU4SIXKpusYbwBx+0ZMwDg4onbFyV4l?=
 =?us-ascii?Q?5Yd0KPaup7ZHcESi7fo8jQJEDjIYjoBeVJKPjS2EvNJiCYmOcHYB/MPYjLrf?=
 =?us-ascii?Q?mNkU0TopKQgLec/XShYjLXKZSqScGBXZhr8kqdV1J8xxuMHJ4utM0Yw+HojV?=
 =?us-ascii?Q?nwiOfPdby7vZA9UMwh7zSkmfj42MiGxbjWVVctiEeI9CA9ZK6KLNscnsbr9c?=
 =?us-ascii?Q?VA2Ls+S6q/wnTo4weI2p3IWu2myKlJxHlxKb4gra2Cy7VCc+ku4AqckrPYBC?=
 =?us-ascii?Q?iddC5fNeQsp7cj4k6D9+Wwckm2/CVDz/44SuWwOPRB56X2jiZBQcpSKK873s?=
 =?us-ascii?Q?qERXUkPlpAJpJdjWJHBF/UGGZ2thaCsVXkSz0OkdLDgkdODzNeeh0fG+uVsu?=
 =?us-ascii?Q?IYdPt2yD9v1Y/jq65HGlTR5WVl5ONIWwFqdH1h2vTpSMuTumXjroR3dNmFId?=
 =?us-ascii?Q?FU1M5fARJiWmTW4nFzIb3wI5msp7exYgQjGPtRKf72bM2gRFvEbGbzoUmkKV?=
 =?us-ascii?Q?yyvx0kZmm09NSu1J1sB50FcxnNf+sN24k516Z8yHlo6xuylEa51hPgd8JAO2?=
 =?us-ascii?Q?4iPOWf+C8BQj4WfTnMCZIAiiJS4s9AmnzBvgt2+0bOfZT5JZu2fSH+WTWK0G?=
 =?us-ascii?Q?MIvkJxOncYpHeqbyTP1H4jttaFLTo2VTuue0dN02/lmvlMcsIm1fO1RC22S+?=
 =?us-ascii?Q?AK6Pf7UN/N2BdqyI5v7+eqb6J9fbZ+u/69pDlcQMiffL2veYizI/nrBBlhff?=
 =?us-ascii?Q?ioFsBeO3XgipvswiAVVtKhD2JaZGwnXkAqYinUKJO/4DsCun5gaFlgHDOZHj?=
 =?us-ascii?Q?fETydRmWD9BdJ98ocQrEBVlfo/z4KkrluETwRbGHsm1Mne3h8jQgyU1Cpr0C?=
 =?us-ascii?Q?q8bcng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1901fee2-c168-47dc-c113-08db2f9b210b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 14:45:52.5728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ot3esUn4tU5HEdtcxnC/FFCp8Em+tv5f9XO3cz9LLNQphGwpfJtsF3q9Phu1tUlr1Bi5AL+y0Z0n/Tvq7MH1CnX+Taiqdl2yInyrW8tJKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4635
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 11:42:45PM +0530, Hariprasad Kelam wrote:
> Add QOS example configuration along with tc-htb commands
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

