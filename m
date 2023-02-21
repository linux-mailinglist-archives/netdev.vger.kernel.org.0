Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F969E467
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbjBUQUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbjBUQUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:20:43 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2134.outbound.protection.outlook.com [40.107.243.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141C51EBCE;
        Tue, 21 Feb 2023 08:20:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtFKuijaQ84xXOe5JPA+UhPlvfpLvHKf7JHP9m0YAGm/dFDOaD1TOjpdX/RYP21b+zqITcRD3O1n3YeffpJSqn0OU0an6iq8Q1E+eEDXZG+v5u6+WGN6Ppk0ZdUUvOJ2lTCCjyinmj8te3qKN8qWUhPBTggQrNs6Yhwsa3z5WVZGm6HV4fU92T7QPS1DpwJ7+mJLfoICzs0XKpFaprr2Y5F9pNtbrXVTHq3AdaiFox0UkPLM2kmPZGcZnc0JXuSEvactvVxRkc+haFZmODzPPogEotJRrmutVgh3rx/pPe/UtHro95HkbKz9At587xm3l7gUEf6VLd2Yn5AeB2xPuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+BGW2NlTKm1MPXSIXVj6mwcjJPNmZqe5bE7fG0KZfs=;
 b=MagAdh+yJ0uVnDiZzTwTLSp31BleX90A3pPAzY7ep23hxxstWn33b1okIK8ih46Oow7qFBbBmRgJB5yO0d7BTcM9nHmhYL/VP9TEmjTY7m6PxgrvMeWoi5XMzCWWV2f+o65mJtSH0uLGghS3sjLfJA8IG98e0NsQPHyT1q6km1T0oYoDHMVXoEOjHzkq6gGUdWv6rJYpYJ+wds8ueR3rvIzgPhHHL5V8t2de/3X5qC5LYJKC7U5CsbuE4zwOTj03gWNV0tuD3Ocmp0jiXw5PNpNGoVNWzy1dU3dI3T8CODb1KXNsRktjF0vl0swG595RzyISbFo3wqT7/2aF3kFYJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+BGW2NlTKm1MPXSIXVj6mwcjJPNmZqe5bE7fG0KZfs=;
 b=sf9gUbDdUikfO7AlXEASw2yQyen/y1lwvSKH9xP9oc3oJsIiCxfhq/0+KesSpDdV8SVBpOKrFNkhwr/GB0jxMx2X/1/EyJUD/byqNqt341GkBL2PAtmntswtx1Ow4CV6rQ5vyUoB5HEInikCtvuYioYsrhW8OfFeAMsVUX5Qkxk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5565.namprd13.prod.outlook.com (2603:10b6:510:142::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Tue, 21 Feb
 2023 16:20:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:20:35 +0000
Date:   Tue, 21 Feb 2023 17:20:27 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tom Rix <trix@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steen.hegelund@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] net: lan743x: LAN743X selects FIXED_PHY to resolve a
 link error
Message-ID: <Y/TvS+D76/N0WyWc@corigine.com>
References: <20230219150321.2683358-1-trix@redhat.com>
 <Y/JnZwUEXycgp8QJ@corigine.com>
 <Y/LKpsjteUAXVIb0@lunn.ch>
 <Y/MXNWKrrI3aRju+@corigine.com>
 <Y/QskwGx+A1jACB2@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/QskwGx+A1jACB2@lunn.ch>
X-ClientProxiedBy: AM0PR01CA0163.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5565:EE_
X-MS-Office365-Filtering-Correlation-Id: c51c6355-330d-489f-4e65-08db14278fb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0qUxCHnfx0Qg/xVJA4XfafjMJFVTbyvoKPhUVMbHa0Ox9zIBDrr45icVti4Lsq2rphnN6a3HhZTfvJD4H/lsP/NRR/gs4i4X+gH4lyNGJ3NQSDLL6ZWcoBXo7+cmc00Uy45imabo/7DNd4lDZkzeW7ALE2ms2zIbXibRWYP7uOMj6nxXOOpUEtMbsxIiTaXgQt8wCr/zFpgJcSNfx4pvfcMYSpvZb2sJ8uLzv7C2WC4vF6ptuNeYv3uw1/hl6YfmQzQFkTZ4BHptnMSAiQugbyED5evhSwxXDGisqQcL9+vHJxt2HlSa087YJRGnZ5ozE7wh7oV/I3TkUNUlXkXPUfFN3H96fWH48ACJ8rq4PeDUKLBjIp1GhelgYca/uiY3EsKFrhPjJNtQpHzuqI0WEvzzLHHXWE0XotGSdzbmQaRvObMArgl8veSRWyHb1SFb5IJ84efn2Kd02Y1KM4P0Msk2Mwc+OhLmEPn5QmYXz9i2fsZxorKBhracsZbRTlanrRoBlQfAFQoAAYNhna4/k/WSTuFXbfewj5wgrtonhfZwJh37Lz+yoz7f8sq7qhX6MjjQ6iI9KWvUD+ho9oNy18hcVjj3K5bdIvIRPeqam1zc8DHDRjLBunZl56Au5wv9f5nNBpt+ww416WwKzAAMgUOyshKGwoBBpwtUpEPQt9CrN/1aE06ID7C1jNjfvdu8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39840400004)(376002)(346002)(366004)(451199018)(41300700001)(186003)(6506007)(6512007)(4326008)(8676002)(8936002)(6916009)(66476007)(7416002)(966005)(83380400001)(5660300002)(6486002)(66556008)(66946007)(36756003)(6666004)(2616005)(478600001)(54906003)(316002)(44832011)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?70aIkH7c8DXyYWGiUqhFlV1i4H2FHw0IBTZm87JxDYU5DWFMUvuuO2Tm8mFT?=
 =?us-ascii?Q?6d4kRqzdhOAcd7tkv35Pek/rJXPKYb7HUlLgDPXynbCWdDCAEeSQYhICS4ci?=
 =?us-ascii?Q?D/rbs/zWxMI5Ic9w7+YrL5twreCZDq+KzU+H76cjF/Kx0WkqaKG+N4ncgYn7?=
 =?us-ascii?Q?P2QxasWenneNsU1HX0957zBXorGr0rFaD8iQ3npwVS+f6U3lAdGwJ2q1vjRY?=
 =?us-ascii?Q?Q+u51RfIuHL1L1NNQHNWY+KdroTkwbfXfay9TS0vLg722MAJ/L3HIfACOvLA?=
 =?us-ascii?Q?XGJYpnzmNQCqFOBsaajmzzTEVioRPixUKuwrj3+vt1xD4ogn8eJDwJa3v/TZ?=
 =?us-ascii?Q?8vBjKJgY4dzBOoqq2M0VR60PcoD3iEccGhaAvf+fvJjN9760LtBFbRUNJQlt?=
 =?us-ascii?Q?R+REViJcr7kk3U07TdZP4dNFm9SuPvlW7OMktdNjzwM0+gKgAOpT0Np4ed1r?=
 =?us-ascii?Q?7d8T0YaIzHPyxaWSimUTkUNdnQWeyCZ+HwEzs7lRjkLfWyGPiEw2Ljkv8TjC?=
 =?us-ascii?Q?hbQv7cmZxwNj4NabfbqTuHKK+fLy/1jPgw7fEfM0u/SRhrT1CAL1rMyMijTb?=
 =?us-ascii?Q?hNpRlE68fgsilS78yhQRO3V4VM1T/yZJaOcB7ibVPx8N2b9z48d7Sv0k1Xy7?=
 =?us-ascii?Q?JvGEDQBOI/vbC+iR1nMPMPY/a68fE/zVqwoQvXnWgbbNPDAaeyqyu0LuWl97?=
 =?us-ascii?Q?QbToPlZ+GGLKZL3/zqGmkIZHfb8phsHWiBWWUamkXNh24s8uf07vQouXLwzC?=
 =?us-ascii?Q?bz+LlPACvcV9JK+r5/oiCS2PetNvbs8nJ5v4ewx6sxAmXhm4DPo3PLpPX+tx?=
 =?us-ascii?Q?x+Lx2/6a2EI8/pkdtL8YY+wCmE/5iswKl/fz2Ps0os/JJNEiCNYMO7U8IsAu?=
 =?us-ascii?Q?qN7CB7JoghJ3uKCSbIr+FkYWrgkIuAt8jmjbmDNsjw8dP+S7s02N9q9axJLc?=
 =?us-ascii?Q?r/BFN8BaqM9WM7+FlXZ1lJmo/fEuiFAD+rBKItH0V8twp2B93sXzEAVRKnnQ?=
 =?us-ascii?Q?wMV0pVlenA5kIfZ/QiEBaQ42xNwE4dPBZxo+0PgtvanjfKZo2ItWzpHJ/4yC?=
 =?us-ascii?Q?S4FeDqwDanqpUMEW1Mtp9Sd/1shuj64YauktrAI+ns0+FEQ/+cU7oI3vBCjr?=
 =?us-ascii?Q?95th7xsOwJvsGBdFZ9Gp8b3SWmtiII5HiZ1VAxQqflW7axTXVd75OG+tkvAn?=
 =?us-ascii?Q?iTOgC/nEIly27jYAWn84QDMNf+yQe08HI0qmIdvLTKc1uPXWqWFxMUCNZUMU?=
 =?us-ascii?Q?Cb+VN86+HkUdbgyjqmMNhyNPGC0J9LyC3e495k40+fMACUtWhv8yQR8u3tzm?=
 =?us-ascii?Q?1bbQIZv7HOWIwDCvjiylCdzlDFNfCUCWS2UouXOftCnh/O+CvDdTMVEZ3mfv?=
 =?us-ascii?Q?gjwTenwbtyfKLi2LX8PdTqrhB94Nu8hhyh62V5ZfXd/pt2ztpfUTSBChg+9q?=
 =?us-ascii?Q?aPDHQtbKnpR4Dn5yN5bfwVJc5b3NBt1LdrKguRCWpzXvMaanJpVd1WycpASO?=
 =?us-ascii?Q?r7koKtZW2IZaWKDVTOHq8EdshIdv5+pdIQFdMyd1Ni2o5ZkbtsCjgfZKDeKP?=
 =?us-ascii?Q?P/sdCT/kqHEoEcBXCuG/K4bySMZ4NUdt36TndKkQEmMUO2uIyDhpwPasWSJb?=
 =?us-ascii?Q?ZvLfD3/Doo2gbt2a2xDAgb7jwADSby04kzi+kEQqP3EP2QpVjMwS2iJDvbI5?=
 =?us-ascii?Q?ykwDdw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c51c6355-330d-489f-4e65-08db14278fb3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 16:20:35.3979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Srh7TlB8qYYoXCkf7ug+MYvvG64bxcbGx7OQht1z+5abCIIYMhJRVTZNDXoz1HtTz1auNYO/EAnKh7HvPAu9sWcFYQK/lczfroIONhEjiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5565
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Arnd

On Tue, Feb 21, 2023 at 03:29:39AM +0100, Andrew Lunn wrote:
> On Mon, Feb 20, 2023 at 07:46:13AM +0100, Simon Horman wrote:
> > On Mon, Feb 20, 2023 at 02:19:34AM +0100, Andrew Lunn wrote:
> > > On Sun, Feb 19, 2023 at 07:16:07PM +0100, Simon Horman wrote:
> > > > On Sun, Feb 19, 2023 at 10:03:21AM -0500, Tom Rix wrote:
> > > > > A rand config causes this link error
> > > > > drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netdev_open':
> > > > > drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference to `fixed_phy_register'
> > > > > 
> > > > > lan743x_netdev_open is controlled by LAN743X
> > > > > fixed_phy_register is controlled by FIXED_PHY
> > > > > 
> > > > > So LAN743X should also select FIXED_PHY
> > > > > 
> > > > > Signed-off-by: Tom Rix <trix@redhat.com>
> > > > 
> > > > Hi Tom,
> > > > 
> > > > I am a little confused by this.
> > > > 
> > > > I did manage to cook up a config with LAN743X=m and FIXED_PHY not set.
> > > > But I do not see a build failure, and I believe that is because
> > > > when FIXED_PHY is not set then a stub version of fixed_phy_register(),
> > > > defined as static inline in include/linux/phy_fixed.h, is used.
> > > > 
> > > > Ref: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/phy_fixed.h?h=main&id=675f176b4dcc2b75adbcea7ba0e9a649527f53bd#n42
> > > 
> > > I'n guessing, but it could be that LAN743X is built in, and FIXED_PHY
> > > is a module? What might be needed is
> > > 
> > > depends on FIXED_PHY || FIXED_PHY=n
> > 
> > Thanks Andrew,
> > 
> > LAN743X=y and FIXED_PHY=m does indeed produce the problem that Tom
> > describes. And his patch does appear to resolve the problem.
> 
> O.K. So the commit message needs updating to describe the actual
> problem.

Yes, that would be a good improvement.

Perhaps a fixes tag too?

> > Unfortunately your proposed solution seems to run foul of a complex
> > dependency situation.
> 
> I was never any good at Kconfig. Arnd is the expert at solving
> problems like this.
> 
> You want either everything built in, or FIXED_PHY built in and LAN743X
> modular, or both modular.

I _think_ the patch, which uses select FIXED_PHY for LAN743X,
achieves that.

I CCed Arnd in case he has any input. Though I think I read
in an recent email from him that he is out most of this week.
