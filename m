Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2896D831E
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjDEQKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbjDEQKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:10:42 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2108.outbound.protection.outlook.com [40.107.223.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B966A4F
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:10:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDhjC71GlULieAzDQ6T8zTh1xPSwpMzC+2ohEFiEG13/zVj2si1ZGpe1cMBA3Eeq9Z6VMxs4gNoXbuWueJWL6TB0ldsOlOZ2SiXG5KfD1DxcC4VhGhJ8q8nQL2elL9MtnpQ7H6ncmLuSPuxpR8lk4lVa48Uv0ySzGUr2g0yUQlKi0dYxPrYeq0Mqs0GlYfOMgcffGNF9eGDXmIBOV+rSKDB0n4+D7BsV5SlsAJY9WES63qiIjG2BdFZuIAI+L6JMBIw6ahQKqz+MtVwaENmjiHLew67mQ9cKrrm8AHMTSoduCw44fXyDqZa6KvmN+lHvF5D3TELqxdqekDxlKekA3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W2JhhW2x9py3FIzc1ob6oVgScJPh+RS+MzYByVwECmM=;
 b=GxVLDKV+PFRhRpILNHM6qn4urhYSkf89BBzlRRK39ON+LE9ZJnwKCicqZXKQZWKhQ8JECzkRWgeIaNuO1KvPqoLkbpcO+DBcHI0fwPTtf5YBekeAQn5miscGfssnyARLH3mSSIjRHsBXOIJvxR/S+wG+mpU6FISdUWYPenTSY2Ad7TkxNl6H9mNO7MPvB8hVCLrGX6Aok5z2DIaruBe4yF8uc2Q3BaE3oZM/dDcpp9Ikl+jnD3+d17WNRf5Tq7b1JsqJUFW5quB5+/5AS6+al7vc38D6uzwHXtYnW/FATs1xrnL5jiH0H3xCth6Tne95/6rBJlMgMo7SRLc3st4Aqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2JhhW2x9py3FIzc1ob6oVgScJPh+RS+MzYByVwECmM=;
 b=J9VaN/90+Dy4OcxqN+Z1hqQ0siBNEBddudJBQD066rsSXXLdGeBtw8aK4Add1OmLRuzJJWxUjY8rDlvXQkd9NQx5LmoXFpebr2UAVSo3Rg9hS9rf1wSu3+WH6xebDqRBitQx9hlAVN6nAve+KB/TrpQ6BB8a5yYNhmH80Ijv9Cw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5741.namprd13.prod.outlook.com (2603:10b6:806:211::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 16:10:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 16:10:31 +0000
Date:   Wed, 5 Apr 2023 18:10:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 2/2] net: ethernet: mtk_eth_soc: mtk_ppe:
 prefer newly added l2 flows
Message-ID: <ZC2dcgA2Pe2C1UEG@corigine.com>
References: <20230405151026.23583-1-nbd@nbd.name>
 <20230405151026.23583-2-nbd@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405151026.23583-2-nbd@nbd.name>
X-ClientProxiedBy: AS4P195CA0003.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5741:EE_
X-MS-Office365-Filtering-Correlation-Id: 8790ff44-974d-446f-4e6f-08db35f0478f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1N1v2whFEGXP1VBYUJlluA5Z9BVw1v8bcZ2bM8EcE1TVzg2EGAynwSzsSHOOZ8RTsvk7JaZvBLhQAbeCchUomlN9OZmwWlBpBJP31cWd1rdKBsMZEEJWvSpAP5v/J0JgQyj/6M9FRIpTEP9hgnAnB3IrpTLvUDfQUnxNYuRwacMDAWxck0CPs3ggh6k728MAKyE3v4mVXljxyAWkD+iStOieW2dJVu5UGJwnzGf2yHuJt2ROWBsoHM0BDm6Q3ZkT7C4MlisL1D694+7EgRAmCFPKvEd6c1+n5EjO7wLykj7ZhlDdi/kPMoUx9pdox8Pvnuf0Hq+47H9HH/gSnjbqgV6PsZEuU3GgfFFqb07o8uZ5txMc7GQ3bV8vo6S+PcumFDxj+487N8XEObnalnWnvhzrWaN2rolFRI8Od5AkXHHMSPfZIGqlCPG/SVgUOljeVXHt0WOr1E9hxq+VSFEX8fvh7RJK0OYIySXDuXBMuZVpj2Ku1TfG1G7CSNHQQKzJEr+UY1AMQdEHQ71cwP8e4d5pdmqkBu+ZY8aLxV1pLONsbNpNlZueL+IFAG3kujcE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199021)(86362001)(36756003)(2906002)(2616005)(6486002)(6506007)(6666004)(6512007)(186003)(66946007)(66476007)(66556008)(8676002)(4326008)(478600001)(38100700002)(41300700001)(316002)(44832011)(6916009)(5660300002)(4744005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vpl/5RI9cOJyxV/AV43u5V9bpJfeeRgw8PLVnrF//KHDv5w48pk8TSJZpRZS?=
 =?us-ascii?Q?JadnYP2i2J2+a0M6MK3/hVWKnBfWtlveA1++wUdOsFIr/d902YmqnRpwdRtc?=
 =?us-ascii?Q?E2lqQxk1ZC2dekHgcxI0veKhq5daoSdDYZZWv+r4Mx4zuG/ZIbUU+P3u1Wq1?=
 =?us-ascii?Q?rCejsRlUGdU4ZI3q+MDKmA4ZdlVfVMUeaNEmvjPx2bQPczjOeghWQ9R4CQLw?=
 =?us-ascii?Q?UIZomRitBIYQxUQS9bvzVOSv0kUuSBBwXOAShkHGr6HPIWSrwl28KPyNvx+K?=
 =?us-ascii?Q?Tj6fuoRYAAJYzL2MudqKOmzxU18wsMjzCk7oG+nJAqLzjdjjihK9mwux08Jg?=
 =?us-ascii?Q?4WE1a3SWIhRyOfX0ouOtvkQH4tHpt0CKKf2pXAIugj0BJhT/+rT62+hvxZz6?=
 =?us-ascii?Q?uv35kLuszaFCS1J2zLWOJw/OAQvU29kcEZdu+XJjJuu+cmcv2U5N4dgGPBHf?=
 =?us-ascii?Q?MwjTIgryqk3AEhTfEbBUPY8KArOnn32f9EpWsaJOGd6pfgRcVLqaYgV5F/gz?=
 =?us-ascii?Q?3sYwfDAa+DYg1YCzM/acDGTCMeKuHpOkC636qcYxfatphD9PJSMjAzUztQpP?=
 =?us-ascii?Q?P1lXAXZdva4KkTVoHvFO2GLrMl70AmR0E+ygZKRz53TdIf5RiMofrhU94uWX?=
 =?us-ascii?Q?Bd6F4Zc5VOAhQY9u0odlupohJfmR00vxbVYetoWMLNWvA273nbicYcup+Laf?=
 =?us-ascii?Q?BFJ9u7kHkG1IF1ukGn0gVaeB0xKfJrfm/4BXbED+SNJGnSoXSqCqMnoN90hH?=
 =?us-ascii?Q?yyCtR7ezZDaCXejty8hkqsTYHGPIxBD+34CoX8BuzoBOv8JQTFvGMNDdVOOn?=
 =?us-ascii?Q?F5bqHfH3KD/dL6C5Dvy92MTKi7mG49WvNGwBhKRgB7eWV5xLTJEwXNXYtSkg?=
 =?us-ascii?Q?Pus7Yv4k6NjhFgvJ84vB4f4QI4xhO/aO79rq2PqUjFwp/cSyKRrQIX3UZr7k?=
 =?us-ascii?Q?2dypNYl00lyDqWvyavdXX6BFGJRFJAQ3OF/4xOAsAIxV27UhQCu3JV29Nuyk?=
 =?us-ascii?Q?r7loZadZAuPc+BlSRcQLWDAPv1qLwLg/y01PEQavbntHlTVqHHgwPJ2giRwz?=
 =?us-ascii?Q?4E00VFpwEeJhUoiOdGhfD/PIdwKmFeLMz5XVd0AXz8XL50sduzChewZG94Xp?=
 =?us-ascii?Q?WxOBP0dA5oa/qTwBxyl3saqHdxz2jou7xQztap/sA9c99IbXo0EgJW8EUrN5?=
 =?us-ascii?Q?PRe6qSLS3kOLY4k2qQdhddvSXxEOBXWi2g/pB3VbDN8wCG5z1UXuFFkmSnCy?=
 =?us-ascii?Q?nHRqEUc1lM2SVbWJGX+kpea8pgW6PkjLgeQbRzIrmzNIu720arrY4zJwYyKk?=
 =?us-ascii?Q?x4ChprHlEFA4dRCo8MCyBb1UG6OsTCHQeymebfzGmUqSLsT2biMnDMbT7B1h?=
 =?us-ascii?Q?Zo4FaRJL+iFmbTKghGDzVoovGNZioTrhYncmrMkzAigYfNtvFycEyzq5d994?=
 =?us-ascii?Q?qFStVP3o49DxRdPnLmVzL/Y0VwoxAfGcf/aVyBlTnZApb8ogG3Lxbl0OisBc?=
 =?us-ascii?Q?z1J5fwuzNU2sIuR+bHN3xD06cQRGwNbsKW3JcuaDOLEkwwjIZWnLWbro+xTJ?=
 =?us-ascii?Q?8TfoI5BFhS2Q9TE4QB89+guDRxZuKiJU5lx1Ic9Gc6GeD7V08hXXgQLVZ/0S?=
 =?us-ascii?Q?J/CcHoZeWSJ/JsYoqgYawzCrI26lVZbpoxfJGN6EvGnz4h4IIYOjqEiP/4sQ?=
 =?us-ascii?Q?iFRxJQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8790ff44-974d-446f-4e6f-08db35f0478f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 16:10:31.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZkFOjG16MvBRo7stnPne4MSzpQgcBawFrq2KyFAkC1oqz4GE4MUeXD6CutIWMKzncYrcOY2VA6PDGY2ELsqV1eU8f77vYdAO7LhCq8L4c0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5741
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 05:10:26PM +0200, Felix Fietkau wrote:
> When a device is roaming between interfaces and a new flow entry is
> created, we should assume that its output device is more up to date than
> whatever entry existed already.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

