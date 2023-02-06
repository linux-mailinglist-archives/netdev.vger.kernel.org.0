Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5E568BA93
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjBFKm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjBFKmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:42:22 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2091.outbound.protection.outlook.com [40.107.244.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A7059DA;
        Mon,  6 Feb 2023 02:42:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahty8qmK9+czMgXLf/U0et1DxARs401Nrpncs6IWAQ3dQSdTH96TSn5tBmmraH633AvNDwx7oz/yJBKcVKgEvwCZo4JtQINATKOojCm95UJVxXxdi3owyp/81RUuKmBEoHyCpkNaAAfC93wjE7loe+nEZwrSBYDMZsSMgrD3oZ/qhiKDCgfiTp5JTzrVh44SukoGbUJi2f91yp2p87PRaJ4cHe16TzKtMQrnU2MieIlmURnGpmcQWrtRZ/imjL/zWXpo1bJfi3Xcilihej3EvzgYL82gQ7uBhBeXZM0SgWMu3cGjwcFAn888clMmP6DP0RvGIlkCLqd1zaFZK07nsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyU8P0qX2XQUJziay3WjP6YnGuG6JKV77wzLiCbZI6c=;
 b=WwRy7WMdell4d8ez/YrvrWjlFo1I1JZNxNxHEqY4Q9rS+T2KzBFlL8MJ6sUX/6gq/8PRSbIT3xaW5bpdq4cJBHHNDhPeEJVezRy454oTYIkYc1M2bfFQEja5q2pAe2u1CefEgNbyMKrj95+S9wsIrVIl02BFmJAAqRXRnF118AWTwVhG3Jg/X0c16OPwaWlxSAXyNAbCKdsLgJfw6uBess+iIM+8awkNncU/0vi2Mi6/YvlyZG/YCH80QkCFV9AYa7tt0n4yHQiESv714AeF7pANqesjVp0XCBcQsPohZADcYE/lho6QHdwuPcmpJhgWfpynyPv1wZe0pvc5bB4qFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyU8P0qX2XQUJziay3WjP6YnGuG6JKV77wzLiCbZI6c=;
 b=fAieHhItK75ZTnTtmAYaQqxBXtlvraos0jU+zH6xBR7LuW7Ya0gKwsLLw4U1jgrotTOXFOdpkZa/gV3DUPECPBUJdaBT65zYFdmMW8jzE9Jiz+d7JQBZztYG/SLXJXMsIlcUYeOvdD8NMtWvhyTccoylADZnU+DXF+O5r7bsfdo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4830.namprd13.prod.outlook.com (2603:10b6:806:1a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 10:42:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:42:10 +0000
Date:   Mon, 6 Feb 2023 11:42:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: lan966x: Add support for TC flower filter
 statistics
Message-ID: <Y+DZe7uglZqNWu+b@corigine.com>
References: <20230203135349.547933-1-horatiu.vultur@microchip.com>
 <Y96R+oEaZijtdaFH@corigine.com>
 <20230206095227.25jh3cpix5k55qv3@soft-dev3-1>
 <Y+DPbbqPyskMBsSJ@corigine.com>
 <20230206103252.xxqd5zvhvfdium4a@soft-dev3-1>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206103252.xxqd5zvhvfdium4a@soft-dev3-1>
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4830:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d5e276e-33af-4279-5fa9-08db082ecca8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FnDms7gzoVvY9zmfE7qXfpOwfPCSbgtiFt6CiGZVpPo6PT804QyP5Y/l9Xi9Sb3/K/ey6JydRkmj8uGHkLOrUayYqgUIM9LsbDNfwsC/z5Ly8HUGpsi6Wqy9uy69nfwnPkqtKALHv3NVDFfU+wy6EWL1fPtZXEiRzeE5DiD6xSjNT6GsHw7zXdsFhgGlCiwO+Z4icBfD3I9qsagQNuRpGF4eI6ZHu0vXHVWeyHQisUSYJzA1MHXwW9/mSusTfJCWtGD4vyQ3rP44LT+28QqHcpFog6TbCYPUeXmIMWiKmt8KVbdyWUAtBJ1oc/uqAmcEGlLTwGe85Ntp8vboVpPCXdzBrlpOrHHGlHZhGbM63xK25ZQluEOd9XGoPHLT0Znv8Datewsv6bgmSorOIAJaN3Ks/PWdhqc/naqBWCi+dkile/L2lupqjXh2NiuAAXQTtZ8vwWaP6la2LTzjr6KYF/xsxvJIrO5uBmEqbg8PbMFyj76/d1NhSSkUZDAJJRCkms1tnGRTj8lkZpEzyVALdzo/yNFK2fnlTLtEkdBkw8W+/Dx82XVr6B36SQgOAiFKSGacV2siCQu34YIXnih0OyDjLQhX9IvDiHB3mdR2a4yQqv9eUNLaqcvxp6YIsIBZlgMtMrfoKgsRgp1NcGR5N+Knm89WtNLlliHbiLTtxJ3XKWlbyK6BJpyBJkhIWeeL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(451199018)(86362001)(36756003)(38100700002)(8936002)(6916009)(4326008)(66476007)(8676002)(5660300002)(66556008)(66946007)(41300700001)(316002)(2906002)(478600001)(6486002)(44832011)(2616005)(6512007)(6666004)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8aZ9ASGph/uydqarK0csXtDmg3ArutylR7Z+z1P0lC9wp2DQCPT2Wi2iRvG4?=
 =?us-ascii?Q?yogQNatmrc+VqjxrIPeAqPG1udyHm2g6zgjP+C7phffh1GP3khn05M52ubIQ?=
 =?us-ascii?Q?FdILy4AEzBerUHg9DZmOHiTpEnaJQ9cwpmZxHeWpHZm8nsWuLZ2vaQsytlen?=
 =?us-ascii?Q?e9c+CIZkCgvCfeWEdqJT1G78/agYW7wqPRZ6sQLZo4eYzQZPJrcVdgUX+9aS?=
 =?us-ascii?Q?PXbvOpbleObVvHekw+HL6AniByKvTpi+TUXXyqUEoGCu0vigOAiAA/gfWiQY?=
 =?us-ascii?Q?Q5lLx/bn/oiNKxEHk9fKs3P2FEs4Aa0+jRBNRgHJO44Qpw68IXWqA0VQe7F8?=
 =?us-ascii?Q?Ev7KIfiVD0QRfVY0uQac4Flr5DfrYkygUNn85f7Mu1vpxirvTwm2yBm7rKnE?=
 =?us-ascii?Q?/eyatyx00o4Ee+CG/7XPM8eiXJavy3bKMaMvPYYZnmx351CFKCj81wyWo2Pt?=
 =?us-ascii?Q?/VmzBvghDdYUaverWV60Om0yS5m3uBDCjd/sKziyKu7tbfHgoM4blbEmJpOm?=
 =?us-ascii?Q?wpM2WYjm322Asn14X6mTx4pYRKXRXcV5IujwLG3wzJPDLNHodhbgAssrOaAF?=
 =?us-ascii?Q?l1Mwq+dKBAD7Y6mUv2Cw16iyv/pGNXiq2p+QJKz93mHStsdoO8ntNGfOTUbj?=
 =?us-ascii?Q?4VekVvtGrNNEdKLcZJkRFCO1IVFoZRiPsVqDT7bj9ZiymzEjzlZlbadYV7Rt?=
 =?us-ascii?Q?fNHn6A+Rx5l4Y0cRUqoD/puCtzifRL6tsyB6K6PPl5bLYnjl5KxycNypsin9?=
 =?us-ascii?Q?lC+CI8jIsFiGxVUYrAO76sheQbjNgXnOPYASz5MGEmzIZ3+Gx3zPp0Ag1dn9?=
 =?us-ascii?Q?ScBOS6SFQsBU9IBan/lEbd5XebgbxcM88/TzjPi2fOYkUmJRC2nTiCeywKKO?=
 =?us-ascii?Q?HAiZ42iNHAtwqcuPgSSivKNC6RLbF1pHjxIL711Rp3W8ILWNKlJpscJJWtwi?=
 =?us-ascii?Q?E2rFh4ioGL1bqFHzy6EwTAba51zpEu3j2VtbnurXp9CLcse9KZDhSCrfeGIJ?=
 =?us-ascii?Q?Hv1axB74FdV1ss9DMrY9aTX9UzaMN8DjwyTKNKW+aqjIfdbmOHh6Wbzt/qZ9?=
 =?us-ascii?Q?rNvmPuRiwtkAql29S2r2st33EX3yKvZIZnXGCxc45Ssc6rITyBykzNKR/WrZ?=
 =?us-ascii?Q?PEMzEguqrKW+JZD2pRq+s06gq8hk2OcCEukEMgNI7rXpS7wDWGwLw6TcWASX?=
 =?us-ascii?Q?3d156ZVQZc1h0u8rOAMBCE4K/ebmPlLY/O3/yTBzh/aOscf1cz3irOWJ8NpW?=
 =?us-ascii?Q?bS876Ai6k7e3Tff3as+6OaRrR5TXz42T6pHf3I7P7DrD8/hY6rFKslrGwdHj?=
 =?us-ascii?Q?8JX1MIv9mbtSwL//+TVaqyPf9k6AGbZWtZAMFUguPUhXvAsEpJsBuHDy801Q?=
 =?us-ascii?Q?G9EpcTu5stnRyW9V4WL/wOOR44/IFR0oYdLii7wYx3OH1n4jhOkukxVsIr3d?=
 =?us-ascii?Q?MaIB1qwpJRFwXqdTd3aTub7V4Ie846aLP+kPPxEBjiBCo2wGq7MtgWizuyMs?=
 =?us-ascii?Q?a9OZ9KUouz5nEHcXdxnenOIISaIo2LcrhmDnHd450VJ3bMgoGF3+Sw+9ClXb?=
 =?us-ascii?Q?9mP8K34QQTTEwb8kZ2GithVXsSxJUGk7ihSpGKCePNwd4A9i5qmz9XodRMZM?=
 =?us-ascii?Q?uOKu8yw0RZG7D2LRRdWCrEgtrA/Rbcwqxh9wdkW+0QFPk80mCSUzH5EhfE+D?=
 =?us-ascii?Q?HZGQTQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5e276e-33af-4279-5fa9-08db082ecca8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:42:09.9879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iI5U7Lo1FQSAV6Fo2p5ljpW1ZIj/q+ePBfw8XGOGn415D735Lvrt61KxSRXnVisWoJqLJtz/CfCzHftq88JA0xCk1lomPznkBJbHMJiXUew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4830
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 11:32:52AM +0100, Horatiu Vultur wrote:
> The 02/06/2023 10:59, Simon Horman wrote:
> > 
> > > > Also, not strictly related, but could you consider, as a favour to
> > > > reviewers, fixing the driver so that the following doesn't fail:
> > > >
> > > > $ make drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
> > > >   DESCEND objtool
> > > >   CALL    scripts/checksyscalls.sh
> > > >   CC      drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
> > > > In file included from drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c:3:
> > > > drivers/net/ethernet/microchip/lan966x/lan966x_main.h:18:10: fatal error: vcap_api.h: No such file or directory
> > > >    18 | #include <vcap_api.h>
> > > >       |          ^~~~~~~~~~~~
> > > > compilation terminated.
> > >
> > > I will try to have a look at this.
> > 
> > Thanks, much appreciated.
> 
> Sorry for coming back to this, but it seems that I can't reproduce the
> issue:
> 
> $ make drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
>   CALL    scripts/checksyscalls.sh
>   DESCEND objtool
>   CC      drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
> 
> I have tried different configurations without any luck. Any suggestion
> on how to reproduce the issue?

Sorry, perhaps it is something on my side.

I tried running through the steps below, which is what I assume
I had done last time, but I don't see the problem any more.

I'll let you know if it shows up again.
But in the meantime sorry for the false reporting.

$ git checkout net-next/main
$ make allmodconfig
$ make prepare
$ make drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
