Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB376BF303
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCQUrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjCQUrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:47:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1830D2F7BD
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:47:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QM1jTmEASL2bWje7/plmHHx9dsFgQueW70VsrAiOooucfNKCDfCCeRGfFzBu/TF8D3vMJqyJIb9jRwQUArEFhS5QarM23fDtsstH7fc8b6SSoVU7QIwm1mP3/09pJNO4TThsPASpS17kkeYN70RSYBFNDSFqaC0sggCGOQ7AL4J291FX3cTRXGo+rJE6lj8DCIqNdykwk6jbankBRJlOhGwUqTIxNnwCmpejps0z2evazLxoA9L81DlTb9JE+kNMZUAoiGU38BKu+leeMRJT2GnaUhJpnaeHHVv/V9FyX+FzRAvtBygbgZh9br9kBJ1ldQcG2WItnVrDrSvEe1FVog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnuMjn3MPycGTKX55Lim11JyCLqq5ZUiNRu0vw3NnVU=;
 b=Ad6T2q52UO5nVAhU6kYZiGt3WiW9ypsB3VqeSjie4VWxO/0XChPRDpLVXK3EO+1ydha1fZWfaJIZ4dvhrJNNkwSJvYxA97nwcAjZ/lN5265ueIOieZMWK3EADjTSad4QKNA8ksci0aH3Y/gU1JUJqszsfEBnTOgpZmew4ZwjzM5KXfNIAEiLmWuAjJmBcv+tPY2L9ThjnNA/IY3AfjFJ2codLQftjf7vr3F9FWvoFqrQLXZot/vzKJ5iTWdSe+rdMk28Ia2nKDbo5PK5UM3gIzLZuSMaJ/JjWeKVo246pPv0GCQiiUVy+RXS/tV1VtjczWB0nTSgbhT9x8EGaoZxHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnuMjn3MPycGTKX55Lim11JyCLqq5ZUiNRu0vw3NnVU=;
 b=GLVCwU0+o66fP3JYX/gv8vL8sFkmqcGcpUeSZLXl3cf+yQ2ir9fqCbEuy2wv4lWrIR2oTUytJbvx7NtC3XvJXc4o0de25RU2U6xmNMPOpvRcgFNmFF7NAvODSN56bwRaspoX8aQltV8zKv/Pnn/w8j1pDOx78Lu/JOFEFwkoKh0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3961.namprd13.prod.outlook.com (2603:10b6:303:2c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 20:47:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 20:47:38 +0000
Date:   Fri, 17 Mar 2023 21:47:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Hangbin Liu <haliu@redhat.com>
Subject: Re: [PATCH net-next v2] net/sched: act_api: use the correct TCA_ACT
 attributes in dump
Message-ID: <ZBTR4LONsxdn9l/5@corigine.com>
References: <20230317193519.1140649-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317193519.1140649-1-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR01CA0119.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3961:EE_
X-MS-Office365-Filtering-Correlation-Id: a9bb7d35-dd33-4f45-0db2-08db2728d7d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NnGEwVazY6+GU550E/X8u4kzBGZZfCvwGHsIbzVbMn52pYAOasaztEmqexAiYiSbqWHSXN90/NgxJHhMa1oUz3izxoSkwb5/wvICQPInxTcCA94Ua4Rt4Yr2oTiA/bwvOhRX/QHtAFejh5yRye5jyYRoCZ5N4WVDRcR+dyCJ5W3/OaSqs22s2i7rXjduSTRhLg+K9hOZil3lvLad2BNubDlrY8EmR+k6jnUSv/Plc9rENHetQOCL/j0DeKwcKRboiklrvmMNkhTyzrJhtpuuLWm/434Z1+LbSrD/eMhXefmjt+D1fMXmLiLDk+noh58TzNjc8D3O0u9O1rjy60CdACuz1AyVCA8v/4czckEA+KOBmChERxaWiHBb1l1L9gHA0aTZL4K9eMDef513sP/RdKzJPH9WZ8xIrZwADfE2AtN8TLrNs+pN0djizdawUS+sTaaMmqNc20LqxnBr9A5J6hjCJScuTAkyVYf06uZnvRVxO4LAEGt3yCqK9zyeChaGh2JSsjhZZ4ri1UGjdnrSShbQX/+goZ/XV8Dlxy3x0/tEWUp8h3aUoMcGMltY5kuho+kLRMmkPxBu7IWYcWRrLo18R66F42C5F3Iq3zloxxfwbnZUXaUgQvgrBOVB4jycx6JjkoYO4QpRUReoKMAla40kUj2qnQbiJB/+/Qn3NeLZjXYJ6LKN5qWgzdtwfxIU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(376002)(39840400004)(396003)(451199018)(8676002)(7416002)(66556008)(316002)(66476007)(478600001)(66946007)(41300700001)(8936002)(44832011)(4744005)(6916009)(4326008)(5660300002)(86362001)(36756003)(6486002)(6506007)(6512007)(6666004)(186003)(2616005)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J0lxk3cdkxFpUvWKvNnJOGr74KryqjPppecXWKWZAXLERk8t41qx84cTd+/m?=
 =?us-ascii?Q?7bh3VUxdXyFcMjkF/q0P1KH7O2GD0iO7u+r+jGhFB6gxx5yC4KwH/IbmlVjs?=
 =?us-ascii?Q?KMFj6K9n0xVEYDqXjwPrshxpd/tyvFz9VZzOkS1kICEVIFI+afDoCrKJhzT7?=
 =?us-ascii?Q?cDnE5/7k1ir1mq85B2fgcLF6cIUKAt6wNSmcbvt87JTAmNOe/upiQLCu7t+E?=
 =?us-ascii?Q?etVTfxHtqVlimP4qVeY33zHEFinahmbb81xe523E/bN3I59YvxlnUK+RFRne?=
 =?us-ascii?Q?9B7VP/JWx1+uts8dCqjgt2kKD9LA7/X3Rlf8Y2Y15wMM4TGDKprk6A/ryWHN?=
 =?us-ascii?Q?qJVPvMWmysffr2MFARqdJbBUHOQYx3HWcKFLqYNOcaiZakoIFUgGqlQbqTbj?=
 =?us-ascii?Q?AQji2CwDR9nUibJd8ikDmMAjmN2SkHE3+l3lYx1zwk7Rvp7m1B8/h/GDkCS1?=
 =?us-ascii?Q?yaY+zAhZgeZj+Iy5HVBIzUI1/VZp5ZaQI6amzCpkiX1gqvWHG/xm/AYWssvV?=
 =?us-ascii?Q?POXBqD+caA4rsoHh/xEy8qDouPIxMzu/CkWneUIEBrnMdZNoD97zNg3/RcQ6?=
 =?us-ascii?Q?uNW6NVtacZsa1jEhaUUjLvYiFGE9rvK9Dm9Auy3LZmD/X72+PpDEL/me1w1I?=
 =?us-ascii?Q?6+2X13nC6FOF+K/q82HIkJ6tEZCw/IFToxB4Omw4UzS9nUniPGfRRSS6MALv?=
 =?us-ascii?Q?G35lJxKFn6ZpTSHy5/zttT5HT5C34XVa/7IuK0iecn6e3/k9ooktF7J1oVQM?=
 =?us-ascii?Q?zbHOoaZ1p1BkPnSDKJ4y7Tj4J9NlVMSzJJnFIEZ/NfnsRCCYzM/4DKBxicZ1?=
 =?us-ascii?Q?uyW3uliTwcjtV8LPt7tiWYctgytqJPots4M2noVBgfrqoZLEEFEx3REUCn6T?=
 =?us-ascii?Q?xfja0xtdWhymxLLSbhMK1jm/RqMIJaSvf6vKzpYf9eowTXZl5mvSNlUBqtmc?=
 =?us-ascii?Q?pOrw9qH7jJpMT/H0ivBSqFTPPOQUbIYr04K/kHP79tniCKb7yGJohPkdnnwV?=
 =?us-ascii?Q?gZcyUNveQLcNFfqHVVudB1mg+QhIOfqInbPgEmbnULbYPox5dQwE9vWoymp9?=
 =?us-ascii?Q?9ijHTSO/so5HaJCEcdsnILKtXFYf/oBaCrZ5ALs845rzvhUF61nU7vl6IRBp?=
 =?us-ascii?Q?LCLpA5Rq7rc7vldgbdrpuK+GgRikNKbB/ER9jrAEnprkGCwLbvQJGx0Ysy8u?=
 =?us-ascii?Q?1hP+B9MXBiUiEe2jbff5bEfu/QHRfrWZveVnWOp56aXgJ3HIwG9zX+IxV8ZX?=
 =?us-ascii?Q?xCANWIY+1XrwEV4PTKg9nABm/rvpVEASlqjwZHSaU23JIvSsdeavNRywJXpw?=
 =?us-ascii?Q?27b48a498NbX4HzBJNDqXkXyhhHfEyPZSLP6aweNNBOtt+fA/ybMDOekT+Yk?=
 =?us-ascii?Q?gCXXp7GALtmyJwNwTTNKvgnr21r25HyPLIhZmVIPBDqaG3Xk2t+A8l06zvYi?=
 =?us-ascii?Q?OE6NEqJgqGCuWRxtothwZ4zqs/Y7aYhCfpWjhtXdhZ5V80rCDWd2E5XIck3q?=
 =?us-ascii?Q?jm+gL1Ju886s66qEs1DYHMCgWTLVd0T7kc1xUpMWex8hGeVaFCORn8NHLz8/?=
 =?us-ascii?Q?0S5XJwg2AC+hq8rnmAxc25UPjsZeLT2oDb/i3qsrFRBRiw3+z2/LYVk9glhl?=
 =?us-ascii?Q?20YF6ayNTCyywzXd8kSMJCyaADk1WWcLLGfa3aVT3waXBEnjcdQox+INyCvz?=
 =?us-ascii?Q?YbrflA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9bb7d35-dd33-4f45-0db2-08db2728d7d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 20:47:38.0057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFbD61fQfsaKmoOp4UsycHcfH/ZZ7sIZxvtrbVwwdGGwiXgB5dGAtp+APRINysqWpMqBO8vpfaHf7l1Xrwxs+YuFl6EwunlL8HunE5eVRUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3961
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 04:35:19PM -0300, Pedro Tammela wrote:
> 3 places in the act api code are using 'TCA_' definitions where they should be using
> 'TCA_ACT_', which is confusing for the reader, although functionaly wise they are equivalent.

nit1: 'functionaly wise' -> 'functionally'
nit2: text is more than 75 columns wide

> Cc: Hangbin Liu <haliu@redhat.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Code changes look good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
