Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFF6690E9B
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjBIQrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjBIQrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:47:23 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2108.outbound.protection.outlook.com [40.107.92.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929215B76C
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:47:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JL78sZnG4Mlb4YVqnXfL+o6yEl/ipAoXyLyYTkL2Ox5eG3YxRIo7inrEP6KJGhHh2miob/pgmE0EjkVHbvXMSdlrwZRH3U6Sqqy4jK/aThEt+MlT4TJodZyWoq/5KuW+nFtkkPYSA/JpA0EmxebIZ993YApYolwGBOuwt1FbJntxI8I1ScNqca8nJxEU9bpodxiOIwjkOceJchfMuICEfu0Xw+wRRfItQWpPTg3Yp4pMQL896Oxtk41Og3mD/WuDzNqiHRzDxkVMZWnhZptUXCm1q89GtGb3XoSUc+JXXSdb1RKJ/XYIRe1809e7zdJGbP8e/J30ZacuG0GggtZlRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vNaqcYTolfkzoW2j4O5FK/lPoEiXNvaQG6i60ZTZeI=;
 b=M2tX4qzaHlYDCOuB+mK4BAq+nnLd82b3i/Wj9f1ZaE+b1An3ixKdKoKmwCEHqms0t3IPvLzr5Pj591xVah6ouopKkCbgsnfkSwIlQLXfC0zjJGPL8dd9JUNZR8dGPxT2YSHx96mY3LHnojQklD6wZKjpcUxTu7qIGyr/F9hH5QXruwywoMUn7xFSNjNR56P2ohyFAP6fFcO8tqukfEEvRnhB+EN1MT5VjXqoOn36/Oks9zNzfGKZohRFPaSihVncH+fjVh2/D5gutJL3WxsR5U7cnByNgBQUljEDFUAJId5ZZylv1Onyhc4qTJ3U9FK2knbwSxd87VsMHwIMa6koJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vNaqcYTolfkzoW2j4O5FK/lPoEiXNvaQG6i60ZTZeI=;
 b=Pe9Xs3c0VazTUzZZ4tWrO600yZtRzFC6KqGF23zaf6tjeA9Sr82CaTeTYl3Xl/H5ImZzAwVyh5kO9KteFGAGLYFHP3Nv2Kdf56WExaMxKnRM5h+r4WmyYpIvfZrQjm5ySa/b22IAfv/5/oUJuYyXRN9HV/d0GnMpYf6WOdFbWlw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3948.namprd13.prod.outlook.com (2603:10b6:303:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 16:47:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 16:47:17 +0000
Date:   Thu, 9 Feb 2023 17:47:10 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com
Subject: Re: [patch net-next 7/7] devlink: add forgotten devlink instance
 lock assertion to devl_param_driverinit_value_set()
Message-ID: <Y+UjjiPvD8Mwp6Pz@corigine.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209154308.2984602-8-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209154308.2984602-8-jiri@resnulli.us>
X-ClientProxiedBy: AM8P191CA0004.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3948:EE_
X-MS-Office365-Filtering-Correlation-Id: c4211283-3e1b-48b6-c245-08db0abd4dc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C7+IsIfgHR8Fk0gzVgQ3eHtbHduTOgc4EFE6aaQMKnXQKiqrIol3mdU6swbspxD6HV591z+oDtYCYHQH+yTidYpy2kMZ5qYsU6314v/WeX2VeeegLmXyzvZV0aSU1ASWP++v3MqldiQmdWCPsjtF+UhmgFy30DFxZwdeG2HXdLdeIX933K6FhiEUgghZBglJ0wwAwmXanJoc6Q+UNH5Hkgu+RXeOM0OcwNwaaDgYcgOInOVAnkfpA9cNFXu3X4GcRt3S/l72EvXONthbfKcoMy4w8YBv1tZ/bT/eJuZnad+DJ1+juWRWcQBqQCVYWLsWJH8hwKVc4MTNdFMr4KBkesJOzMlnUyyoGkN2RkmXxEIiyjOQ5DhcduyOAj9ZEBmnAoy/SEZOOCe7UCuJLjcB7WYCbYnddEBvEBH2rWjohcgRIi/motaGCdug+iWAxKbBnHPytYDIWou1iA0E1Upc2UNZtsINEeaMksniRbi7mI76hkTgpsqo6kFp1ibNWWm/EeGQalYMkxMDD9YLB/lWnsVcSwnvf7Ay7sIB60ADUh3dfzb7x85ggw1+ydWFPZUpkKYtvkXde/HvNzay/E4f+/AV3i+ewl2+pseFlnQpbfqIopHsBl6769YVWgKG36BDhKdPHJQpku85N2OJgAIsyPm2ApUqIxWhRh9zN4XmarQGq7RvUXx/iCXRPgmziHm3SC8a/gPh16un3iU5OW9pxvZ15azXwudWbH8fITxkk8zQUSMNQPfw0avGdAnd+I2x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39840400004)(451199018)(316002)(5660300002)(8936002)(44832011)(4744005)(7416002)(83380400001)(8676002)(2616005)(41300700001)(36756003)(2906002)(66946007)(66556008)(4326008)(6916009)(66476007)(6512007)(186003)(86362001)(6486002)(6666004)(478600001)(6506007)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nD2gG4+X+i7qPlz4Fcn4S5La7K25IFSwlZGGgoXTWEssey/L/kMGcehJCpiO?=
 =?us-ascii?Q?Ff/lT/f5br2y2KDJplPQhTYlzV17P0pxxxq5r7fb0gHuicPrMYmF3XoeRe0U?=
 =?us-ascii?Q?/EVW7lYl3lfp7G2+0TZfs9fdY6iqkVT6gG394+tAYrRnR+TTAFhmWzJRXuMZ?=
 =?us-ascii?Q?QDesyVEkpZqFL3mXoCjtGwA4rzFoV6Lek8aAkckbdPNlFkj1/NhqSUPf7f5u?=
 =?us-ascii?Q?Ra9aV/HfNzv+g7xAlvyVpG+jnuxEUsbazWnmE2PK4e08gcxWnd1Ld25AEkVm?=
 =?us-ascii?Q?1q1pE6/tl7tOiG2NBJeBGAsEctCTswVvxaJNEt/Ga8cO/9sOy7Bd7mYqFJto?=
 =?us-ascii?Q?3Tu03ckCez0My6U5AnXIAt+v9wNeMfJDTFI4r3jr5KxUkKyxVS9J58CqBGpF?=
 =?us-ascii?Q?1AnqHZT6snMqU2LiLtCO4bC3NgC27JtBw8PJaUIlZGpgEMvOgl7WWAjNZIs3?=
 =?us-ascii?Q?AYenuoX2j5guP2f+qX6SlSYBcShJ4tr9EqhHwDCi0a8bLr1e/rM4owbfvhC3?=
 =?us-ascii?Q?5NHLCF8MQ0eehdpimgOXOuQlqIhfmf/LjlstEKECHNpAci4p1DHPPyoyJsgI?=
 =?us-ascii?Q?dc6ZHTEzUMk5SFP6wE9eFDoiBUMa39kdKhCINUiN70Vt0ojrBYUjAtE9Hnx3?=
 =?us-ascii?Q?SQoFb80hDp8OEVndtooBYBHBolyCscxQhs52BDZ0qsM24q6fFiGkkPs9dZfi?=
 =?us-ascii?Q?oC/3koogSXCuf8RRp0jbL2MlcnjJnfrIYKMMhGtbMJAkilCrMV6KdHVvyKMe?=
 =?us-ascii?Q?hQ/inKvbya7a78XBxHZFdZNX+wZQA4/W5kgX8Qa/pb0tGOc38Y761zkjxJtW?=
 =?us-ascii?Q?qKHFECK8FSMvaJ9VNGcEuH43Q9pyWOnOswZ+zZUVMB8ekYr52Ym7I9q4IzPH?=
 =?us-ascii?Q?le3pRY6GyQNca2Fa92oac3BOXK+c2Gx6wCrBYjvBw8EgnMglU/KiPRcIjygs?=
 =?us-ascii?Q?1iC1Jn4bwN8lO2rVfjEURbvnrGFnxdaI0J+UXTzGUj6+eqIGhyu1zqVGW19m?=
 =?us-ascii?Q?q9JpDP04scYHDO1xV+ru9YB737OvZupv+X7XIlhmct9NlgFbrIrT7pAlBe4v?=
 =?us-ascii?Q?N/dWHXQD4Swx+aBYA/Cf0/I5Bv/COz9Y/+RLMJnsfgYFR0Gyf/nZF2ld6oMt?=
 =?us-ascii?Q?mW4yCdoxxM0UJfsWNjgW/o+LeG7w9F0j2z63hB8sGNYlcf+X0RkQZlulKNjj?=
 =?us-ascii?Q?Ub8RbrsUki1rOX1gWT2HRcG5zwIWUiTtBeeOauntUc9ktsdr3Hst2clXyTEs?=
 =?us-ascii?Q?4OSYMk8l4mRiqUqsGftpXHeIlQPthyRrhn2o+JyXl3gzhEdWRQBtSfW+lo7c?=
 =?us-ascii?Q?bHX9SRG/MS88mKgmbl//JAL5w3PhS6CIaYvYDTAfo2Fv/1qriupqe6pk/uJZ?=
 =?us-ascii?Q?+qpJYWF+vkk+SBUiDKKAijJQOmQB31z9RoG1GnKzl5fqzLJqO8gXaOw4CQcH?=
 =?us-ascii?Q?E/TlTQK5qUJ8xaD92saxmEHCS5NMexLAxoR+8hb3G9pAlZm66g7+1Q72ty0g?=
 =?us-ascii?Q?aKdhBrCKLWv8NciZhapK5F+qbvuTgYPwCz2XKIzucjDS8JDAgLscD5cuyRAE?=
 =?us-ascii?Q?r4D1h79wBNAS96LoODVYmyR8VAEtuMn1AphW461wnx3sXhku2vhWV6230fLm?=
 =?us-ascii?Q?pLZ9mAcY/EOgwefAt1gYQUw5wGZE4wdWnQi0BXqUZfpCuRNahX0MPRAjc2v+?=
 =?us-ascii?Q?2Ca8vA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4211283-3e1b-48b6-c245-08db0abd4dc0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 16:47:17.4819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CJTSQmt0Z/mg8V5Tqgu+EY5TWEEeij+o0eom2/SUUUknoFM7AoMU1oobxZeS3g7KwWZHaN3MiuBvmWL77N4ngqpzr+kxW7iYPTLU23xMRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3948
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 04:43:08PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Driver calling devl_param_driverinit_value_set() has to hold devlink
> instance lock while doing that. Put an assertion there.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

