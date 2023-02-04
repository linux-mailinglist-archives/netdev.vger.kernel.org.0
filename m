Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAE868AA00
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbjBDN04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjBDN0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:26:55 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2111.outbound.protection.outlook.com [40.107.92.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A315F30B0D;
        Sat,  4 Feb 2023 05:26:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dF8V831MleqYp8y/raiMSdtl0zcFIQRU50ZbRjMd4W4yzajgD/tWkNm1lgmDhfHkRZJoSS7ycQFOPp3hqJvbbSmyHpbeBdqbY9eG6jK/o4hJulRDmJpP9rysUTQEZgV2+8HR7/ig85Qz2X49/beW+udwTJArjdPqzB4+SNw8dUgsmKJvzXmKtLDqpwnWrBJaxwgggkbfCK1PBWmRrb0n5I+m0x34URr2m6uy7Qhue/IwDMnX//jZF82RDFHWQRB1oRHp8NKwltUrEb+XHqz17DTt/NuCRyLEJ8wTD/agtrTkxh17X6jDBfyWIC2WoVRQ04C4X1tZ4OkZgpEnBByUNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVRhs9QalJUdQFQE4Swj682V7HFzAAf5DnBdwFxIqyA=;
 b=b7j6wCZ1VhRu/OrPNyPvx5MKq9hoFUPor18fZ8pc/bu/x5lj4917Vbhqm5i2WLjqOw+AmnmpZ+D0enfUpsmMd61aL24B9T98bAz2JyRPgY7R3VcX9iDwqwj0uK6uD1New7mUdtatpI7rpiHTmrNvqDClcVY9yykm4RwRtveQjvSMwTRb4ha6+u579k8FIhNmhH66WNLkEFWijutk+Y0GNZViAC27uPq4JkNpBhT2PtkbrNY1J7lZ4MWL8APVkYFd/tpkKlirverIFZzujRRBQojeJvhO1pCi8gTpNbOAfJfLrPPNrZODYHpAYLuNPF8DtLyfPgc39412UGuQF7MAPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVRhs9QalJUdQFQE4Swj682V7HFzAAf5DnBdwFxIqyA=;
 b=Hx1H3fw6UzeuA/imS5+7Egwg7v3bXPPepsbes3JQhy+NYO1GNTC1yAbqdbtllzkkVL4opxXdm+0KBinKCwCFxByEJpTATT9WV1KFpYA2eTwc7UkKwFKUIcStr0HybEvr3G//7GCiajFhHoPfzLyegdaelkn1liiwRMmzsdyCuLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3675.namprd13.prod.outlook.com (2603:10b6:5:1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.24; Sat, 4 Feb 2023 13:26:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:26:52 +0000
Date:   Sat, 4 Feb 2023 14:26:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, tipc-discussion@lists.sourceforge.net,
        Andy Shevchenko <andy@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Ying Xue <ying.xue@windriver.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [PATCH v1 3/3] openvswitch: Use string_is_valid()
 helper
Message-ID: <Y95dFGwEDyFx7m2R@corigine.com>
References: <20230203140501.67659-1-andriy.shevchenko@linux.intel.com>
 <20230203140501.67659-3-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203140501.67659-3-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: AS4P190CA0043.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3675:EE_
X-MS-Office365-Filtering-Correlation-Id: a81b7068-413d-4f51-f435-08db06b379e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4ntW5EQAkbtrnC320qoMneAENvlZjWhtT9zJ4G9rZpnKLrMxmbrKhiVGJ3NilRb40W1++6qk8Q2v1MTqlCTpcgGKENaMt2x/Nx2LbAqeAiScnHwVC6Ohvpg2ZGI7Lrv+jF2xAKUlIlTrbhaIuNuaE2rYr3shflNOJosJV9l0/r3TVxpImTTBPsX3ChuIkVPdfwW0npPfaZIOFk2Ev9CJ18VZ2+ABf8p7sl9J82d7E0W8c35EqKmWPAVceEDpwTUoH5juCjMMRML0i+8UCFjibXvRNLs1ZQ0Ibu6CDCP2d2cCZKVNwLXsuX7d4k239xMgzN9oFZIJiBY1TfwEqjTHA8WsdUT3dikB4KB0NU2kKP4F64uAlF4HSJJW2ofFyM088BZ+NGuLgbHXvloN2qjTqR8rjlaOqmOKKgNiW7SMRtfqxDIHD28DMkhD9h3cBs0BmsD74KwrDRAEhil2BWOXQvyW1XU1FbcdfGlfEOaN/svHfLTQKusGJ8Pq23Eb1lCRvtt4xwc/lT9YIchjCn1XjxH0oENdNJwxXT+xYGPWVY46f+X0DAWgSEkEhCwBhxWjUFHKu7jzJeT/MPCCvaeeH0lPPu005aFuN3D5dxWHMqK4EKIdJXWZx/xj4AqcM9jVjP0CPzMb6deS2CmGzxxkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(39840400004)(396003)(376002)(451199018)(86362001)(36756003)(6512007)(6486002)(2616005)(38100700002)(478600001)(186003)(41300700001)(6506007)(54906003)(4744005)(316002)(6666004)(44832011)(4326008)(66946007)(2906002)(8936002)(66556008)(5660300002)(7416002)(8676002)(6916009)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?108jxR9UUlyzWxcPNPUv6LUhbgbN7FqzRUuG6i7CRqJzrWvvKXG6ffXVsEdb?=
 =?us-ascii?Q?zWQJonC5iJbPgnn+KqaCpla9pjtopuabk+lVNGAQ4wawm7hlNsvhiT7PdOC8?=
 =?us-ascii?Q?QFdJ0L747vWcHsQr5igwn4YyQ1HYWAO3Jgr7jXCF7nhJgklzL2KskUuDISob?=
 =?us-ascii?Q?qm5xv96QLQlXok5l2DV9U98FID+k20cruj12cBz/NnRQhyZeJXukMC5a9AYS?=
 =?us-ascii?Q?aanpLQNk/pnIofrM5iE9pKresoQHh6Z84Pgj3CmiWFX7ZLiIZ3DxItfVGctI?=
 =?us-ascii?Q?wzBpgXiaasKMOVgLQCzGLmVO9E2opEiHKqPJ6XsDkSu3FodRqr0KU+FEpVD4?=
 =?us-ascii?Q?Uef13bBh1/LT0rbNEV5WIOZLAFDYvK1d1nfk9uKIKME5FyTm1J8DGNrLeFQB?=
 =?us-ascii?Q?EhATi5I3kaISoe33cNvePqL9I+eh71ZPxVr/g5LuFBmFQk3Be8jvU7eOlGrv?=
 =?us-ascii?Q?4OwwNwUbx8CtMaRaK6tUlFWcTuwzs44tMGn2UISzmqjvKJzWuF7AXwU4SYV3?=
 =?us-ascii?Q?BqDPN75c7pXl48e6hc1b1DNDZfpB0b6B3GKvEo4U3LktgqEbjuuOrMV+4HMQ?=
 =?us-ascii?Q?QvZw6zAy8aj+oMSJ+5A1sskUOd9v/hE7+BACK1fzcrIeJPEtX8d9lDk4U4O0?=
 =?us-ascii?Q?5pQvvlgmdLUjp2DKrVQitFpIvHVv/TrVMDZghPz4nedXIKoLh+OXgoCUYCil?=
 =?us-ascii?Q?25321zp4UCqNs6wILqnVdbcULPBPypwyRmD1qb0rvmnwYf7qAEniTBqZhnTM?=
 =?us-ascii?Q?8xqFAQhzfFdOBUL9geZm2rtJi3YqpgA1emDrKaJPU2cD5wHMkRqxFUl1OydV?=
 =?us-ascii?Q?E4hO6S34JEYcovp1yqCKz6Hel7JuixbyYw4cF4AKp6iD/lVqIn6Y8ssTV/a1?=
 =?us-ascii?Q?vhnJiKIJsvhzmVzqzqrqCEtlfl+iMnE3jtI6xQP6NXthAa6KWSBwIvzqKhfI?=
 =?us-ascii?Q?9/ncWW5/Ys8ne4pLnxBPk/nutNAwbqVk5G4MhsRycrMbo42U7A2t0GGzkTpo?=
 =?us-ascii?Q?zdKStYAOCP/dymqEPR+FO8j4JraqYiHm4thjyfRiiZcNMxCUHm/HxNEojYI2?=
 =?us-ascii?Q?W1i0DvEzIJXS889tgVStMNB2kivy3xXnE4k8696xKxfR+pY8gDWasPK3XECX?=
 =?us-ascii?Q?ciiSX+JvqDMlKHYCOw1nBR7QXpVteIh4R5ktgYfctdHL0z4YgJ3gLOh3r+V0?=
 =?us-ascii?Q?PMgkiDX1l4JtpsGgxRzUeTyDHpmRaQGWULQxVOGNZJiLNMB1qNEuVxUnIllA?=
 =?us-ascii?Q?G1tUF+veBlrQcxNMmQANxJEWpbyNv3XVxUBHNgG8GxvKTDIRwlYeDVUCJgLb?=
 =?us-ascii?Q?94bfvx6nOsd33SDIZCvPcAT/J9n1fjSLf4JNQGru2W9hmDWLNjh+jV4Ayb8U?=
 =?us-ascii?Q?J0CTV9aBrbWGVRqI/qVYUYR/MgJV664rMD1TOUCn2CzjV5G/UQdKF6YrE3F+?=
 =?us-ascii?Q?0XnDJPySHY8B/yFBSh6glltF4nYqL8WocGoW8nTO+AwCk9ucS9pI5aTPvsXe?=
 =?us-ascii?Q?pdGBJIrh4fm8Uwij5myJGjTKTtHvJZTEHetB0wCLMJHHMzeQ3JfRrIzAR04+?=
 =?us-ascii?Q?k67FAM/whHgSQ9UPIw3C18q23ReiooGFE2ZTkUDON84n8uv+dKieaLE8Ottq?=
 =?us-ascii?Q?ssrDGRf4SPuudspPa+LNypYFjTaqRrg4voYEg7cUJruRSlLrlNtuIbZNmgoP?=
 =?us-ascii?Q?0mD4NA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a81b7068-413d-4f51-f435-08db06b379e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:26:51.8646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHsi3py3danz2SQvbycDFeKjRozNIPeFGyR2IwOweMVkz7awsS+FFvIaVMwqkBa2vgDbWKhu77QfpPz2LdnrqZI27A0wEPElPty2SkLHTgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 04:05:01PM +0200, Andy Shevchenko wrote:
> Use string_is_valid() helper instead of cpecific memchr() call.
> This shows better the intention of the call.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

For networking patches, the target tree, in this case net-next, should
appear in the patch subject:

[PATCH v1 net-next 3/3] openvswitch: Use string_is_valid()

That notwithstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>
