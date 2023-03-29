Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DF46CDAA6
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjC2NXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjC2NXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:23:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2108.outbound.protection.outlook.com [40.107.243.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1698749C3;
        Wed, 29 Mar 2023 06:23:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kzn9zMRy/j/4FmyQINVwyyiOd1qnyu1MZZnH59x6jiYKxrdHPzbTifQ4LxnMPn96PZonyKnZnO7b7A4WpaC8EZ9AC/3aF7W3cGMwLwb/6sftGgTvUzuGQcF2fwxdItm1Dke/GDJBMmwISeSi27i6jZocarrgFKJGU+n/IHeAy1/vkMBLqUzasZ4YjFaSV5A61PH4dqslb5HM+QN4p6XF/0go6DELVijpcz7xnzWYgSa17NKaBxBw4hLZbSJinoy/gqySE3M+1jinYe7BasFYaSyVeXRcf7gM/EnX8/P4xf5bfYVEZX+R32qx1q/gZ4I/r+Iz5wX0BNx7J7zOkummLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6VTIB+A04Sdz1FWBTxIcWIjO51fdwqVXH5nZ7DZMDw=;
 b=BaadVxRwWezcKiAYt1DA1g0nqyHQMok2z/MW9aaaBbybFyK+/yqei6M3unGdaRh8XwWG16vMJrE6IJdCTaL/rGvDEfpwNiYI5lBrjdSQRyKaxqC4ohk/HkUDGSqHen9EZGZwULy5igxpjz424DME6UY1MY/MSswIFmmVNIe4341xY6aN80Dat1D0WCe/wOrLipOIyVkbHdpVgz5e9Ca4aQ1dQmnZcqTvrgbuGd45bus1QBP1As2gl2A8sSeBqhfv8C7GJTbuzrEzG1eKQF2oQbZon+GWxS94kbzR73Dq6RV0sG21S2uB0EsuVepscZ0ovaByWGC7AzXkmtIe8GYedg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6VTIB+A04Sdz1FWBTxIcWIjO51fdwqVXH5nZ7DZMDw=;
 b=JcXK8AylX+8ObT3KkYchXaWnqbk5/31xrssSYHgQoRGsLbGG6QqkxdTVhgqOrqetn1WHwD5H6ubhiT7CSN6vB05Rdxbo+6X9lPiL2jWWOICduToDt+GGxOix/5Y7jsOEkXHxBqLXhYrWvYWgtSzHY478/vLrc+EzLN3Zazf1muQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5777.namprd13.prod.outlook.com (2603:10b6:510:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 13:23:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 13:23:38 +0000
Date:   Wed, 29 Mar 2023 15:23:29 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        petrm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        wsa+renesas@sang-engineering.com, yangyingliang@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] net: ksz884x: remove unused change variable
Message-ID: <ZCQ70Rb311WzqPIJ@corigine.com>
References: <20230329125929.1808420-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329125929.1808420-1-trix@redhat.com>
X-ClientProxiedBy: AM0PR04CA0118.eurprd04.prod.outlook.com
 (2603:10a6:208:55::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5777:EE_
X-MS-Office365-Filtering-Correlation-Id: f583a2f6-37e6-4c24-2ec4-08db3058ce4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DUSV3J2zWt7v8RCLsVupKb96LZnsaAtkjeYv3WEquBkDJMe8YPoudWNUH2zFg/xiEXEy6yTE6U4XXiup/fLSxC0th+0zHR9Sl3Gt7sOLCsk8K+82aliU+rpBj561XQMIYejc6TX++3qQRgnPU+vkgsjIdeYe0S4A/cL354OxYoOHibGLt6IKaz5svaXjUeqOKwPDmC93tSL8yxj06zEBsGykmShZd9ZXo1lyQ8nLUdo8/1tXB8TeAVM5hnPHJIoT7sEL6MJTGdESIY2ZxQ0o/GV5mxMQyqH0OvQTsLZLfcDjGWLwr3+7rjo60CK0BoHP0OWTCb5sbfUhUAmakwf7oL8kJ+a3xKZcP+t7RfgNax8pLvGzKqPwHloHlC/5YTPabMp/6yUOML8nfeOnUFiU+L/WEDgWHiIbb6uWuweSabGBNM0z1/4zDGFWjMWug3kDXrydYxlgrM/LtkPxC6okmFqyiFYVyM6O5vpZgmtIqo+a4Z7D5GA0H+O0ogxNmM4BZsFXB19ZqmMRq/67n/+eC+e0+YR5XLmTYBPDwBOghs56rAntMZeJRVTNP5rMwzEzopX+MdBlIp27gDV2DNX+pvmREG3u82P2tvSU62WFYvE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(366004)(136003)(376002)(396003)(451199021)(4744005)(2906002)(44832011)(38100700002)(4326008)(41300700001)(8936002)(7416002)(5660300002)(86362001)(36756003)(6916009)(316002)(478600001)(6666004)(6486002)(6512007)(6506007)(66556008)(8676002)(66476007)(66946007)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bXhhr5T8hnRyXVj7vurWstaFxudXtMYre4EDVYzz4Dcw7upyc+qqWQi071wd?=
 =?us-ascii?Q?pgiGY2uWAiIoDDzgH8fV+Yc1CjBjjuqX+yxYVBmA/UXx46r0jam3B79hVHGx?=
 =?us-ascii?Q?oNcqvTLCK0+vPa7WSnPYCMUhFIhE3JgaKRkOAZWs8/QNrw9c5WSMg+h2qSP9?=
 =?us-ascii?Q?eFAOvBldy/vkydQI3fgtoCoDpc7M+wG1QyPUe6MJlutWUCXp3BqUnwc2e2m6?=
 =?us-ascii?Q?t2VFDoiMemH0ITBLIsT8mRcpLUVZaoQ12izQUZsUgTtHhUNBF5co1gfothXm?=
 =?us-ascii?Q?/HjGavjxi0PuVYuQzHf3sSXvNue5xH4tuvnzgbxJ1a6AqiEWRjhyMPre8C90?=
 =?us-ascii?Q?OychksWDXz9KK/fQQPXcUzCAeC1NmalMx0n6v5KjRhRaqWD2892DTIDj7AgZ?=
 =?us-ascii?Q?S1xnz4YuBXVTC7JDL6HbABpUDW8C7dzspobsqjhRKfny8V0NzHui99NsYSdz?=
 =?us-ascii?Q?+9Pu2hGY16GcJaLCncxlX7+E+ZWxH/T2CwduAy0ry93LSrxnXJGIx8pxuW38?=
 =?us-ascii?Q?f3kB+HeRhNjq9hq0ZiOgQ8G5yMhnMswxLKp+l7jn/anHklrKrSPRD53O/bJF?=
 =?us-ascii?Q?6xcgd9V1ULcF23qEglAgXNerMYzR1GB99S2OII/iaaAqCRhGVO/K0vMlZKqU?=
 =?us-ascii?Q?NM+MRT0pmCUBVLRHodIJIc+2Djb/OVJWWX0ZVHkwTxbtLl2wFD9hBVEDZHpq?=
 =?us-ascii?Q?JgZP1jiHWhd5cRCzlB8Br55JaOblqLf3JLdN6M0ok3S7UPuDmxQbdOX6t82S?=
 =?us-ascii?Q?rs3MBGApmGahqTNc6+kewzSudrCyrOHgHfWHq+PnY6m6/ISKRUx22bJABnwX?=
 =?us-ascii?Q?6nM2rnnp4aivh/UTXOTmWVBs5BHeQfbDOlE1FLrOsb8YvEhfw3xSaqTa1UR/?=
 =?us-ascii?Q?yMFL7jERQGivhExbNhEQ/ysMrZhph/N+Louc6CYhXknw2aA7D7q+FQXKlr8p?=
 =?us-ascii?Q?lcZKj/rTT0DFxPDD43TCSXYXhjOUtuDLknZrTF2HxjOb3BhDf19MjVfxN0sx?=
 =?us-ascii?Q?3a6QeborQRZr1vKTQtDtKVhntqJvtxWv2easyr9qdesCFhQO/GMdCrLgJUDH?=
 =?us-ascii?Q?lu9Z9LEPBiEk08sYzKWNj1D/RXF61/wF6TqEP6jssc2FGtDu8MQHSIe4+c3A?=
 =?us-ascii?Q?VWK/TgTQtXEBQBYfNPk7AAcHLq/VkvPI8x7WlLVrRSXDB25bxBuC5gif0Ysr?=
 =?us-ascii?Q?n/fmJ+jo9Jwwiac7WcHNhAB8pvRD25OHJiJaP1OjHlJ6aJZc/xN/7f+DW6lF?=
 =?us-ascii?Q?I1e/xmrl09EXylQPZZfPJ0wtbXXeOp6TyTX1m+dTwoTSx9EB1D3vcPWj2pzH?=
 =?us-ascii?Q?k/jDXUNAkev5if5EYz3SbgGMQLT8K562c8ubCxYtE0Qa6BHugMZYjzmkt6jj?=
 =?us-ascii?Q?FJWaVqujRr+69xnC0eJHcU0y2THcrF70K6PYBhxMM0DPpzVVFbA+xiLXDjat?=
 =?us-ascii?Q?2AyzQ01Au8gDjGH7ba3VMV8leUrTnMYdTIKxnVvQ5JqZB60rA26jIat2crgU?=
 =?us-ascii?Q?k5eQoldt4K1m2gEtkItDy8UsuOedZvxm1AQBnBWuOeB6EL8eeidczTMoi3Km?=
 =?us-ascii?Q?L6VxdrH0pKUIaY6QOAKDm8wHp4MrPuU6Ymb5iJZTx6/PDwgNbKpLrhNU6XyM?=
 =?us-ascii?Q?+SbZ8JkP1b+iqheB2wCzufpscS7AzQXJGBmhEGotvl9J4FzuNUz6rO56zg7v?=
 =?us-ascii?Q?8W24aw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f583a2f6-37e6-4c24-2ec4-08db3058ce4f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 13:23:38.2819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urjkq/diLyr6riLPIwupm2Udne6XFVUmIDN/pclw7xoJbNlW+RYnKKSc/VlqbKKyvjpsJLgoup4mgsFxmBc6HafxqUQih7IthJG9oGhmli8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5777
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 08:59:29AM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/ethernet/micrel/ksz884x.c:3216:6: error: variable
>   'change' set but not used [-Werror,-Wunused-but-set-variable]
>         int change = 0;
>             ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

