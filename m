Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6962F4B3D4D
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 21:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbiBMUNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 15:13:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbiBMUNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 15:13:50 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60071.outbound.protection.outlook.com [40.107.6.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18FB532DE
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 12:13:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNBRQDphnQJ8mUKInxuN/THZHI2LutELsJduY9LHHjPa498MKr+wRDoP6m8zGXhjCdZv8fzKOUti/RpiiEIUjXd//g7bdOq87/69EyNzbwaGnKySghSrcmuiR3gkCTAjzkBafYwV5nnNUNsZMGk9iLwrGbuvQJSjOA1OClp/bv6KPi0tfN5puonI+0HkDcUxGGuL/WUCsGec5+HnhDS+E4acaGhc9nAShsYa+eTfEiHehioM3E2Am+LA+siT/gdLhcNVB3KTrmA6JHFHyDgO17BvyCphcFVLzGRHk1SAr6uE5gqW0h2qeZ8uIAbEX8PybAyHNxwqJDqpQBoE2h+7wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HQZ0QvEMNgjDTCBcRH269nw8YzInE127XUUQ9kp9AA=;
 b=QjyLkIzSiCfXr2eNI99NBOveeytZtUagcwgQW87Yup1ChB5KLsGpcgSCufi2gnDY89KSXzUr67CJdp+lfWzZQABwH6Pv4kLquci5rExJ1/FDN0zg0NqCeoDAcxIvhkC5zlY76A2jUFob8+hJyVvBrXuOKJzGRaKlPFXYlv6DZ9X7ElFyxaCBAtvg74yKIBNwILGwBdbj/IFgqvXNxuPAsjjFyAdZ+q/q3LkFBTf8iQ1E7c4lDC/kEVIB7B5c52RuRdaaAFEC9rbhRVmwmbMxNf8WeRaTUL5wVE4d95FLkJbW98BoU86S/Nzros+xDJrVRZQNybxYrAobBwPP6wenbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HQZ0QvEMNgjDTCBcRH269nw8YzInE127XUUQ9kp9AA=;
 b=HCB++DX+SSgdl6SkFc2NuYI52jHf1bo/GsncG1mRFK/Y3/oQliq8e7HZOHuCt0SBKwKTo7he9VzgqQBWiif+Yb7JwF640SsHqcSIH6pelumXcl0hWPfZqpcW5vYRBHRhLWZemBWDbA0xrP98eTel311jkcKsih9bRYzSDp6Ri88=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6192.eurprd04.prod.outlook.com (2603:10a6:803:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Sun, 13 Feb
 2022 20:13:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Sun, 13 Feb 2022
 20:13:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Topic: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Index: AQHYHfxXQePXs1M3lEOTgYyrlnmZbayR2mIAgAATBoCAAAMBAA==
Date:   Sun, 13 Feb 2022 20:13:40 +0000
Message-ID: <20220213201340.nf7n7qmuitnysmuc@skbuf>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
 <20220213200255.3iplletgf4daey54@skbuf>
In-Reply-To: <20220213200255.3iplletgf4daey54@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c86bb498-5409-4d17-530a-08d9ef2d538e
x-ms-traffictypediagnostic: VI1PR04MB6192:EE_
x-microsoft-antispam-prvs: <VI1PR04MB6192AC29C0258A962E2178C7E0329@VI1PR04MB6192.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ElOAoXr3n+h7YAh6BBmWa76GistJt3EmmyYtBhpFcQ691zyQF4FPaqWTAAg/Dm+2nhaTdqbMz6Jlo37iNygWvRAr8xfG4KElZ0eXVqgnuWmTlxEo7Wg+uryFjr4LS2t0K+9qUXXYlwTHFRGNAoOtmGlJtxEHlDRgnkOr/fswDbegU5FhFH+675WTl98yAGxFAkMz/FUjO3j257M48oPVcMoCiAOiXv3WkEhLotHVUAuFx77d8soRFx8NLPTUlSYjLj1kksFvbWDGJIkX19aVsOiN6qS4O/8a5hvUFrOSZLFJf1faAceKbdVWCFNhOJzR8L5vloU8ZdWUv+taSgLdaDKBvoA0lQqH+ugXs2OdhVTOmZDtwA0zwIbTmRqMmOzTi04NQDKkB5oYXbLJ6vlUmnDmONuzu61g2W40RBw6oDsSsu28S5CuqKZSfunFditAK0lM/bt6kITzb0ZYQ6MnaRS0neYtl1aDbFOqHqfHIoci5njNtXxg93GNiFVEQ3pH7fn+wqq6ztCVnca92tsWySgo5O4Vx7QOrrMGHX2NTS1Fxg/xgwej37Ai+yPVdOMPN4BotRJ2HSZRhd1H83qNeLVPP1gPrISGn5JmjyRgKLA30t32QQPkv8gfbsbzSRl1XEps/Hse1mCpNljbx4KR33bMrn8RXY5KuKjbGyRj9Qurfy4KtfrtHwnoyQW4ZDLzfgEyIVWk7+qXX36Q0QKfsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(9686003)(6512007)(26005)(7416002)(186003)(1076003)(38100700002)(8936002)(5660300002)(66946007)(66476007)(66446008)(64756008)(8676002)(76116006)(86362001)(4326008)(54906003)(6916009)(38070700005)(33716001)(71200400001)(6506007)(66556008)(6486002)(2906002)(316002)(508600001)(83380400001)(122000001)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fqSHOg/vhYlbDmN5RzN6045iim3AmqktUCUXBSqHU0GIwmubGFj2ID1ci+oo?=
 =?us-ascii?Q?P0r3/MvIKRcFt2OPoS7hvBcOmxNzbBxqj11EL5Ym2AlAGdv6QbJkM+l1sNcM?=
 =?us-ascii?Q?Vc7tcnPaJ9kz1BwbU6CBVxmgBO6clNqjm6kDACFRwR06rTCdyn5hxnJWK4xI?=
 =?us-ascii?Q?rjzCMs0pgAuRyAMV9hGYMpUteD18l7Tt9fEdZ7E3rsdhkDd+PKhfV9c3F6ac?=
 =?us-ascii?Q?JlXKAFfdE0FTxHPiiSMPySZmIKTBRtQ7YfoTyUkT11RrJeWY9VFfjbI9oKrc?=
 =?us-ascii?Q?UEPhNrzPUADvBVFdWBDILe0Y0H6CBhPWOitC24h1gz5C96E3RF0UhY3J1wOY?=
 =?us-ascii?Q?UBYkvEQt+DhjAQxtVq4ymPnszdGCNGiILn2Q5uWjnfIOqH8NP3IcotEWP5Tj?=
 =?us-ascii?Q?/aX7kGnvXL42G4K9b0xcj28PC4J/7HsFChQlk+ftVzpteqDhzcLDkUA7Qve4?=
 =?us-ascii?Q?e89eqGc54CI7FPSxZ/m00HL6xQ7Hrnm29l1CgzblnA9yswdD+82yfeJfm213?=
 =?us-ascii?Q?SU55g5ZC6XqQ6vxdHYoLAWxbVEENGTc+UIaA0d2dQDZ9BFG3VJR4hehIftlI?=
 =?us-ascii?Q?xRH9V9kLYvPc8gRqsquvD3Jmyc5HN9QEUjOaa9GxCyycGN66btTWKU0uC8DO?=
 =?us-ascii?Q?sY/6KsnkQAlwPm0Bx/OmdQfHh/o1VUVha3z/sZxajgIbnNQbaI2a2oH2+qbd?=
 =?us-ascii?Q?6D0MJLABlWixmaThPh8U4OIKNeiI4vd2CyzO7Aqr4CUoYs/1/jps3HL0UwSO?=
 =?us-ascii?Q?1z/pee4l8RXG5MCxaJ/Jbn+LklYOpg6JPWX2zoSq4Mu1S/7BM6kBAGOfW6KK?=
 =?us-ascii?Q?We9OaEOZMTMsdHYzdTp4M6ffbpKEy9fYU7s26pZEHQC6X9YiNVfjnnHaNR/A?=
 =?us-ascii?Q?1DPQY6OhzG3MCfA+QPL/K3g19XJ92yQA70yUkySHos7tSE3UXNEisERsrC0J?=
 =?us-ascii?Q?W8BK4RGaFBoWhdzRvVNpc2Mz2bpdXvghk+TzlKjIjgogaLGBXe5y0FIAZmnb?=
 =?us-ascii?Q?jtURnPtd1Fx32ACBndZ4Ia3yTAJIneGxheiR4Bji4LR+mPfZQVH+ltqOFCcJ?=
 =?us-ascii?Q?TCFgHNXWaGkwnTbkGFu/1OSjBnJnpZVAOMd3NegtkXS5QpSgzGMXeeV4sMCC?=
 =?us-ascii?Q?X8i+1eHe3zXC0G3fBf9Pexe7MN1jlxeI3tQuyWUNVQfwdsgsfwrm4hxFzPWA?=
 =?us-ascii?Q?AlUN3Sqnco57Z1jR9vokJcKMAVmTxLb+9MgYMqEZVhseyoi9IWXAdP/yI/AR?=
 =?us-ascii?Q?welz1KxHSPiwMSwanRAnQ1G1Ed9xLyDrML14y5do4p1p6GQC9nl+8mAKEp7A?=
 =?us-ascii?Q?wgKboFmDKGkHwwq92SH1/6UGT1SV6++GNqkP9p5Ok3EahqA3/XFsoWL+AkH5?=
 =?us-ascii?Q?43QRaFDiVRHn/XGEBEkRVLpnVL85eQIKXOGIsgTtqgIIjSZqikDM0gWyLNKB?=
 =?us-ascii?Q?+1q1TUJoEm/sT79JSgxp7xaOcb/l1zLdnqqDKAS8UGZYMpmEOcmBc+2xplQk?=
 =?us-ascii?Q?PosRlsrdVdE/tU98LYFg7mwSvAq41lefLYJ4YovpDaBslMIEQTIApzmkCGNE?=
 =?us-ascii?Q?P+B2fsE4MNX8gCuv2zQ6K1iExpjYILTULvWeFRI0+5h1vwTK1Qd5TVNcf3Dj?=
 =?us-ascii?Q?EMkxWLjRVlPJZ05uPqK61iI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <79FDE101393C3F4895280926F715645E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c86bb498-5409-4d17-530a-08d9ef2d538e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2022 20:13:40.3570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tLTmvEmLvvYXzuTozj2yxA+aWvMxFa6RPI83Zw8zAh+8ivsQLgR95Yf86Yw8Vv0FrRhKWro9YYMfMJPT7KdazA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6192
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 10:02:55PM +0200, Vladimir Oltean wrote:
> (a) call br_vlan_get_info() from the DSA switchdev notification handler
>     to figure out whether the VLAN is new or not. As far as I can see in
>     __vlan_add(), br_switchdev_port_vlan_add() is called before the
>     insertion of the VLAN into &vg->vlan_hash, so the absence from there
>     could be used as an indicator that the VLAN is new, and that the
>     refcount needs to be bumped, regardless of knowing exactly which
>     bridge or bridge port the VLAN came from. The important part is that
>     it isn't just a flag change, for which we don't want to bump the
>     refcount, and that we can rely on the bridge database and not keep a
>     separate one. The disadvantage seems to be that the solution is a
>     bit fragile and puts a bit too much pressure on the bridge code
>     structure, if it even works (need to try).

Ah, this is too fragile, I thought of a case where it's broken already:
for VLAN replays, it's technically a 'new VLAN' not a changed one, yet
br_vlan_get_info() will still find it so it will get detected as changed.
So the bridge has to pass the information that the switchdev notifier is
just for a change of flags somehow.=
