Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADF26E9265
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbjDTLZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbjDTLZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:25:34 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2105.outbound.protection.outlook.com [40.107.100.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C603A89
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:24:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8m5kLCFAkl1ta4lJkzXQVOfgs/DEtvPhZBmOTXdmrgcHtvDjZjKb6L9KQqnsPkF5thbB4/w8B8KJethH7kNsgZJy18BO+qiV22hXro7ytHNg5NeV8q2l6QhiOvu/j+6FwU0fndSEXQa9fJpbaHsph/oBo6HedaIu98B9/Ancc5/cbBME3YX8oV0ht4yPfDnteq/hYvdaThOfO8Ce+cHFPZgns30HuxFY2PMc4pNPgpmx1VQMIBRAp1CapneinZyj1qEGsHYU/k1ipV9qvZ+RnvUhfbr3J3Khk1Y2kWqWKr84W/I1i7ZW4gUzamOwpNbmZdsoGFMsWYnfe+pIAyTxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AH5QTl89bDU/ytSSQ6n4HxD1uMdOSeDasCEGKsMRQw=;
 b=TCtRv7U4WicNUkQyNlm3HvbR9GGXw+mp2iru7Ftsn6kp5SZ3YqFNTPRXvG8CBQT/B9eKOjcSAMl4Exu6spCeH6XrC5UblQY2jjKg0WCdKPecwpKfbyAv2Wm2ROJHbJxuK/LWWOwYEM+mob5B2wJ7l0edSJHDo3Ptmkieq0YUUS29LvbprJFV8IloHWoFlMQHGuBLkZJ1J7s/4ANUtlQNXbX4EY0zTQ+3ZCIOylQdbl7pTBhT6kdDVvoY/k4VEL4qG5d+5AfXmCP4ZMwktaCCaskVkuMlnjddq+efQ1BpNODS5vaXJz9Evt/0kkfi5+8oMGKqCII4rioM2W3FwyZKjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AH5QTl89bDU/ytSSQ6n4HxD1uMdOSeDasCEGKsMRQw=;
 b=uYwyLsFqlO3ouY6LgBgmArkd8Bivnnbxaw6ApNmOxikBC54lPh0U218tDYiQ0GV+kgUj+9SuVsgb0NbMvHC8DaWumyFZa9W+AkWrPXTRRrZziZG/9aYHZd+LsaI1h+yQMv9lj7LhNSwDARRdda78kT7+xAEE8xHaJDS+8oVkdx0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3634.namprd13.prod.outlook.com (2603:10b6:a03:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 11:24:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 11:24:20 +0000
Date:   Thu, 20 Apr 2023 13:24:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 2/5] net/mlx5e: Don't overwrite extack message
 returned from IPsec SA validator
Message-ID: <ZEEg3e99MdsftQ+R@corigine.com>
References: <cover.1681976818.git.leon@kernel.org>
 <c245ca90872db741429cc2a7e9862558f561c848.1681976818.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c245ca90872db741429cc2a7e9862558f561c848.1681976818.git.leon@kernel.org>
X-ClientProxiedBy: AM0PR01CA0158.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3634:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d9d4aa7-a0ef-4722-3c00-08db4191c91d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kq5Lj8hDiw5LupZi2KiiZS1LqOyaALfzeI4VPCwLFf9kIrkgWQ6c9gWrWPNGc6MKAKT4TbywZkeHDdK9bGjEO9+lNOmA3yxUMz9EcJJ6Dt0Djuud0KLJ70+Six3R5r1uRpgM3Uulp6cWK76jCcG+JRwEluveYXIC4Tv3DubzYiYgMa5gvJQ0cQ1SPUHIdevphdZSwQk3/9t4KqaTgjMJD/vZCpYnXmwT78NRXChkfv2f03H4m8Ea0WhnY6pTFK9rVF5c0gyLvjASXu/bpJd6eOi5rRxH1vgyUSTzqTgZ+eVBGPSOEwrvoiqqhEjQA8qYQ2bF4unjKP3fGoDAPr12REyvs4swwnxahTIRWLUcJrcfoRJ/UnJqpktKSOlMyoM4lMFQwYq8a4HoEL7YB1WeAxle54Xog6NITgA/sj7jrnGq71T9RF64mMSnUUho7UtfnBh3caPndEU5hlLr1pxADwJ+UThPA/fbM4sdPEbA5XODtSdFCtANB0Cxir2HGs4IpKs59EP+IipatT6fkKiJE9R88EPE0/cFq/jo76f52trLyrSqxjpHxK4tmt6hcPIhxnmGoBYqQI7JFKuTVGtCo1MKqFfR4naOi7XpJtS9Svk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(376002)(136003)(346002)(396003)(451199021)(54906003)(83380400001)(478600001)(2616005)(6506007)(6486002)(6512007)(6666004)(66476007)(66556008)(6916009)(41300700001)(66946007)(4326008)(316002)(186003)(7416002)(5660300002)(44832011)(15650500001)(38100700002)(8676002)(2906002)(8936002)(4744005)(86362001)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cG625IBULaGsnrNkZSTsi43jYdTp2ny+86mybMzwp3gxtVoqhdT7nczgcPzu?=
 =?us-ascii?Q?Y5A5anwSGV+ojaL4vXmIySKLPQvKFH/FvY1DyHFejGRpQ+rmfz01gTbWOOcK?=
 =?us-ascii?Q?Smq+rZiVVIxjLLRjJL0oMGPo4mPXBVKSrveoptXGVSulnwwq6k0/nHtDXK3U?=
 =?us-ascii?Q?M8QDPX8DuOrqaIm0lAuYRW3OwhDZiYES2FUQ1NOEOSbwn3fKGl0aHjVlrn0L?=
 =?us-ascii?Q?o8CyC5XLIIssYnXqq2YTccsRO+QzDAmRgCbfZjpqrDBG9UUIm2DB1H7c3tpH?=
 =?us-ascii?Q?Gc3EK7rCFbXczyTRWvD4DVzm1ts3n2/04AMTr1aJX5uLZfGsdk7lhWrI/ZrL?=
 =?us-ascii?Q?8rscK5KaNaOA1S/IONvSWwrR9HppoCTL9m2OUHDcxHHEMmdObZRmPSVUb/0e?=
 =?us-ascii?Q?wTMOyYW8pAEJDtZdUso60/KGZZQ6CdumHjuTd7rdc8HHDfWH8BBdfpIYMcLt?=
 =?us-ascii?Q?1b6RI5P7pmJ947mND10jkd+Pq3xa9ew4dcolDOS35+2M0ZLXGf606JHu96gg?=
 =?us-ascii?Q?9SlfTHQFcPSKeCJWd6HPOYcOZpD4wZtZGfXMEFtYPIzd5o04OaBiuQMTVdgO?=
 =?us-ascii?Q?Gre4yW+5i0DEA2IJngZvbyaHXTmHBGdQhbkv3gjKMWPHBj6J+0QlFN85ZkyU?=
 =?us-ascii?Q?WezYeKevUHfjSfCkfjCKN7NrUbJGfL+PGsPjJsG5hbHbdRtPDfus5XhjTJV/?=
 =?us-ascii?Q?1VyLEKoCUUllkvr/gkd1p/BfstPAdkdIpenrDYC50Hy9WLw0tzot7sleKnWu?=
 =?us-ascii?Q?jijM2NWOx8l6juDzufpVJNJNs1Eo3X/+WyLx1aXJMggsYk2IfIhuMmdv/ca+?=
 =?us-ascii?Q?QnJbXFEJ69OK47FZv0E9dQPQVHGJpUnr6n3apEo49288EqUmcWCiWk9xUFj4?=
 =?us-ascii?Q?4td4i8meshroO/esqNaodYpR8u13q9leMVAbf6bDZllL2HhRFsPdbcQNVHmf?=
 =?us-ascii?Q?RHespBiy+Th335iUyAyHYdQAdfDfiSkJaO4QE415w0frv7JhXZYr8+RcqUUC?=
 =?us-ascii?Q?8DJWeqIvBdiTQLB/Q2HI5nz3sBU6sC46Yk6Y4MDZ4YMz3KZN/ZQ1eaFpCAKe?=
 =?us-ascii?Q?x280kPOjLjOzpphUyzhu1OsaTdRmc9c/9iDRAoDIjpjlnoqZ2KAQXGNOFVPr?=
 =?us-ascii?Q?sYpOcBPlM96qKJU+jE5VN3XtIv1tysu5a7Qr6QLs2v598RRwJHaZC0hCO1F8?=
 =?us-ascii?Q?BVJYDtRsajBHu3rLQFBpfYkYQjCOIs3kPgYalFWbr5oT9TsUJX9LRO8mG/A5?=
 =?us-ascii?Q?JDyoiKH+SWzuaYH/uoyn3nztmh+gCXx+RkO+clKmSV8hCOEQoknkga3Sk7mA?=
 =?us-ascii?Q?0/K5lRwxMiEcgKKFFpybk22jsoAKcd5NlVrVENu9PGRJ/yeBiTXrk+sG7Ymi?=
 =?us-ascii?Q?32MryviocIk0R9Jfaw6eqRBtta3sIlXBqCLTICEINGIJ6/mQOW3SWg3S2jIv?=
 =?us-ascii?Q?6WXEB8ajyJCyxnGIqMhq6RPZ2qDAJHq+SykFr6x6vLmMbY+du7knmlgkk8Zm?=
 =?us-ascii?Q?VB4o2S+6V+JfH9Li+SaON/M7lyb0QB+i5JNDiu4BhYZ9ku+TDNPWPWNJJy7R?=
 =?us-ascii?Q?bpKc3kPVga57yvBs86vX4Nq6lcb8sRplenyTR+dL/YLaC7fdz4vNk9IKhuk4?=
 =?us-ascii?Q?42xWi1WBUwpZ0HvJxKXrgT+1pimkB/n79CHEm0cMqdeExmKYo386/AFoRD8y?=
 =?us-ascii?Q?4I7l2A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9d4aa7-a0ef-4722-3c00-08db4191c91d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 11:24:20.4741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8Dch7K4WGEHPMndeD56Up53vsM3XXq8tnxYZiMBYBJRtlp+fqqQGbPHFaxBKMHJaJMP3eWdLcrS7ANUZgnNtHgPCBr96K/eOnT//PxvBpY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3634
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:02:48AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Addition of new err_xfrm label caused to error messages be overwritten.
> Fix it by using proper NL_SET_ERR_MSG_WEAK_MOD macro together with change
> in a default message.
> 
> Fixes: aa8bd0c9518c ("net/mlx5e: Support IPsec acquire default SA")
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

