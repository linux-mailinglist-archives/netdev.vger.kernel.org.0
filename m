Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED7A69C567
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBTGqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjBTGqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:46:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2099.outbound.protection.outlook.com [40.107.94.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16731B77A;
        Sun, 19 Feb 2023 22:46:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6N9ygt6ALcEZ5Oue5TgYp5xEw+VoSBZMK03tFo5U+RYqZkdGurZl0lQpWoENrzgaEX3ql/brwWkbUOy9gD8utNh/n7iu2W7NwyNsxKoDbJFfOdGTN1fKeOEmZGwc2N40jlm/GbNS3wHjOInc3PzcFQ3n+Ssc9artiTNKW253RY519psiqeUnixVVyMGOs9ogN9vNEwmtvFOopOHltSkzl31tVsB0iIR9YgLrW6g3S36x6oslwOUnAG/Yw37+HtLnLyipSgmPH9ru1J+2SXoK9tpotj9D3oGbsINVWJ5gWIExMwt3mvT4C/aULg3xT1Wz9Z3bEpd5JmKvGlbNG90QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NllNpNpDam9Fqda77daAWWLrcLeNG0Kh+Drfeb2jKiQ=;
 b=K4jTP/Uy8cnZc8LAj0fS+pRcqcQqKXnh9b3CmRklKP1QMFzBdLyXcTWBRPGETNjpvMZZrzjCbTX9CgXavEH66C7ajkLTrrOVh1BFb/eq4NxDkhHt2TesiNvo5AG+XOXw4AIo+OvMyiU3SiPmhVUiX5EPLYX8JynTxKKVYbv635eRgLN+1QlqCu+NoKo4MUNcR96xIxoUbjJ+RQkhjwmtxTl2/vPvO1g0TLYGNUhsOK48lVghQkriBivTEFUeZZ+PcCHo8qBR6R5kdjtJewxpdBQ+lqOqUDkLlEW4FVqmaPFJ8HX3MEUMvQCofyqAgzWKL1V2S60khssKjYfMpNAEHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NllNpNpDam9Fqda77daAWWLrcLeNG0Kh+Drfeb2jKiQ=;
 b=Rwc9Rux+0MYrFWT/EMO2xmlR2wtp5mgwLuF4GmUEzrXbyomvpOUswZtpwY5sPdi/bqgsvq/7da5jUMUG3GjLYRb11u4DqvV4BKaMKn7ktAifXAEI0hd4+k/6drN8WYzdheWtAONBXY4QxcNayd1YkEDElqHpf+l7bR5B5ZwTdZg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5903.namprd13.prod.outlook.com (2603:10b6:303:1ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 06:46:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 06:46:20 +0000
Date:   Mon, 20 Feb 2023 07:46:13 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tom Rix <trix@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steen.hegelund@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lan743x: LAN743X selects FIXED_PHY to resolve a
 link error
Message-ID: <Y/MXNWKrrI3aRju+@corigine.com>
References: <20230219150321.2683358-1-trix@redhat.com>
 <Y/JnZwUEXycgp8QJ@corigine.com>
 <Y/LKpsjteUAXVIb0@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/LKpsjteUAXVIb0@lunn.ch>
X-ClientProxiedBy: AM0PR01CA0164.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5903:EE_
X-MS-Office365-Filtering-Correlation-Id: 72b0e569-8889-4514-9825-08db130e2ca1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fncbHwqvbxs7yN5Q7jUExzYPZBrTAyxoNAlIOjBId2P9KEdK/C6caxd67MKDDoJhMWMxWJZ8j9ilQal+glzUsme+Yajkh9kDaalmjZaIVt934z8Q5RWAtJxm3t6apPvD4LwEQIDGh2p8C9CfY9UBjGynl64wjxg5dFmXX5JRxSkkfvofTW5cbLOBwCoyP26xjrWgMtyvNJvmPasYDwaNEtHPs9tMc2uDLY3OrkVTwBu1fwmjs+q0wB5TklmF0dlxcfOylCGvTU13c8aVUj1MTZj3f2MX3vQ349ISyOfwx5qojrYutX06dcchUIsGfbZj74mor9LJxUXXb2wpQGw2RooVf3EiOBpbTJNuCUlvsCQHs0v/isqGmltSHdf0ijGM4U2ySs/LOTwQSgJg4nd2lkeOt4v+ewcB3LeKUoINzpDdqlluH9CV2ZPkD1uJYkjAAhVsuk/FA+7SElBFGwGVinCuCZCfN4F4s4Dve3t2dgPxZkei1XIkUkWtZ7IBQCG4zs9i1ZdKHE3H1Da4uPrJR2aUGd2arLKMM1WzA3AvR0tubjXhfUL599LpJjQCeG5GIYa4IsZl1LECsqWmFKFh1ZZ99CkDuOUB6HdFHnwGKBIMBPYhbQtDEnLz1Z+jbzkO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(136003)(346002)(366004)(376002)(451199018)(8936002)(83380400001)(5660300002)(41300700001)(86362001)(44832011)(2906002)(6486002)(966005)(6666004)(186003)(6506007)(6512007)(316002)(66556008)(66476007)(8676002)(6916009)(4326008)(66946007)(2616005)(478600001)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?neSS4cwPOqZoz2GNT4FrPjAeKsDv/aIloNabp23Nypyi8+kgHgSaVJEVJgZz?=
 =?us-ascii?Q?fXvhOidr/7dDbPAVfp4r7lCykyFt5uQO5AUSmljyc4szjoSFlBV+f16c0pEm?=
 =?us-ascii?Q?PXHbwcVdwMapWjAEMU1QdzZYFbRp+d2rVJgKcoWtSgT6Ejhdvs3jTK+EkX+9?=
 =?us-ascii?Q?pgKcmblYjw1lMDDiYUAUhFD3GG5ttjJGVZ7KmTt/tyNoZEbKFNzItY3KLkHe?=
 =?us-ascii?Q?dnHTgnpnBT107+s+PEB2WqI+5mG87fOSkQd5VtV0dWQgvPn7dfKu+SXDwEqP?=
 =?us-ascii?Q?hbgKQsJxlAS/hj4I7ZvNba+yXBHKF+WYYBffDQzGst7rX2GIZ3+sySlOpVZ7?=
 =?us-ascii?Q?1pq3KKpuWxLwRTIScCfaEz/r87RWGOrAASo5wMymnOnLoVxF+mCUU5A5WsFe?=
 =?us-ascii?Q?rcy4fgonjgOo5sFOyqSeA+INzXAimOK4xiqGjJo4HRGU2lpDaJcYZftsiEhm?=
 =?us-ascii?Q?hr0u/DcimYsfEmPWj3SlSHS/ukodJkDYoeVF+hFg1+toSEIltz9l0KxXv8lX?=
 =?us-ascii?Q?SYfYJyQinifeFYuX1AfPns+8qlWVjz19r/2FtpzFanUL24J5LWVm09kqO5jB?=
 =?us-ascii?Q?lUSxsuoqKYSYxkFLmcs66vlkpu4a+pzPO0ajRJCW8+URKJFhY+jESYnZkCeJ?=
 =?us-ascii?Q?pxKRkzrL5+G+J5AWPz+3JzA6O38WNcKO7SDydceGFJOp+kJ4ZHbASpjNABHA?=
 =?us-ascii?Q?yaQ8avFSdEZRo97LKo+9JQSD8KkTFwZbIPVUwywA0sYYXLkRDNrV/zFUGo/Z?=
 =?us-ascii?Q?w/HpyF0WoNlGKAaVuMheSyNdz6Hnb2eSMMKxVnyKbiTJoFd7YHH6T9RPj7qc?=
 =?us-ascii?Q?N1GXX0Z4QgG2BhHo2JqzxHQib7NkC1M9f2V68nbd5iV4K7GwJ9/qB9cSV7TO?=
 =?us-ascii?Q?UAp2LgetYAjFgtI7Xvz0P2MDkzxPluWVumprkt1b+inyUju9XQ/SuS9zpufg?=
 =?us-ascii?Q?r7wkoPiu3NEmrPyio0R59vsTgr72EKPoarA4pT1uuZsVHuDhKl4LUXOtM7u4?=
 =?us-ascii?Q?ffqG7YKRdOLQrFelDNnJqJFeym8BefniWNjaXn4i82cA/6poNdIBDQXUQfJn?=
 =?us-ascii?Q?+UeDU6bF2PMYYdqpfDTV5I4Q/9ZchIUtnFEIisLo3Azm3df0iPZ2YGU0s0GV?=
 =?us-ascii?Q?08NXV4CunzJCRB7zbfxN/2zNB9OIZZ6QDKRxYiAJfVgivUqQtZHfeKqxSrlF?=
 =?us-ascii?Q?QRH71SHwOMExorXJ9Szqh+0Ac4dOnahgUIqxBXyVKZ6KgYbJick0HiGEegd9?=
 =?us-ascii?Q?67hLAQRZwNlDwfcPMGhvZgw8kWgw5dSasCAL5DYzPSpUZxsXe0uboX7mwaTv?=
 =?us-ascii?Q?76aI0XiHllLCvdSt8OCTpKmGeTeTppXGmYf6vUVlo5bLizgNVrzjm8o9cI0O?=
 =?us-ascii?Q?9T5Oc8xoNCRv1BwOm0RvqcTWI0fu/8vvXc+ttn2FTV8iL0wj/WTzg/nWlvZH?=
 =?us-ascii?Q?N1Dtx3NtaZtHd/Ktx9vSBCfcCrVD74MVBkdkBkoLHqDzIMZUg9QL50C7r/Ra?=
 =?us-ascii?Q?EXdHuJsPSM14n6RUPaknFekiTXBJM9t7UonZoMrhY8X947gx+1btz/D072iC?=
 =?us-ascii?Q?Z6AtAVS1418aJRw0AmKd8uyBOApRV7BDeDhQBLlNVnDJzZfDtUeUksa9l7HX?=
 =?us-ascii?Q?JP+Zy5+Z4X0aNhZ573fshDwtvR5F94Y2f4U6EjCQwpMyKwJcLP1S+ND1wldg?=
 =?us-ascii?Q?v4VUow=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b0e569-8889-4514-9825-08db130e2ca1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 06:46:20.4045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGd9qhFll/SItU2TCwGXacBkWOfCXkNeybVR34ztRhYQz+L0kfVJRhdG4gKmA5EmHaSp6F8rRmR27teXBQE4OyVSlIUiv/GYczQWaaG1djg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5903
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 02:19:34AM +0100, Andrew Lunn wrote:
> On Sun, Feb 19, 2023 at 07:16:07PM +0100, Simon Horman wrote:
> > On Sun, Feb 19, 2023 at 10:03:21AM -0500, Tom Rix wrote:
> > > A rand config causes this link error
> > > drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netdev_open':
> > > drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference to `fixed_phy_register'
> > > 
> > > lan743x_netdev_open is controlled by LAN743X
> > > fixed_phy_register is controlled by FIXED_PHY
> > > 
> > > So LAN743X should also select FIXED_PHY
> > > 
> > > Signed-off-by: Tom Rix <trix@redhat.com>
> > 
> > Hi Tom,
> > 
> > I am a little confused by this.
> > 
> > I did manage to cook up a config with LAN743X=m and FIXED_PHY not set.
> > But I do not see a build failure, and I believe that is because
> > when FIXED_PHY is not set then a stub version of fixed_phy_register(),
> > defined as static inline in include/linux/phy_fixed.h, is used.
> > 
> > Ref: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/phy_fixed.h?h=main&id=675f176b4dcc2b75adbcea7ba0e9a649527f53bd#n42
> 
> I'n guessing, but it could be that LAN743X is built in, and FIXED_PHY
> is a module? What might be needed is
> 
> depends on FIXED_PHY || FIXED_PHY=n

Thanks Andrew,

LAN743X=y and FIXED_PHY=m does indeed produce the problem that Tom
describes. And his patch does appear to resolve the problem.

Unfortunately your proposed solution seems to run foul of a complex
dependency situation.

$ make
...
drivers/net/ethernet/microchip/Kconfig:45:error: recursive dependency detected!
drivers/net/ethernet/microchip/Kconfig:45:	symbol LAN743X depends on FIXED_PHY
drivers/net/phy/Kconfig:48:	symbol FIXED_PHY depends on PHYLIB
drivers/net/phy/Kconfig:16:	symbol PHYLIB is selected by LAN743X
For a resolution refer to Documentation/kbuild/kconfig-language.rst
subsection "Kconfig recursive dependency limitations"




