Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F0245BE2F
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344411AbhKXMpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:45:14 -0500
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:17024
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243799AbhKXMm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 07:42:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CizdhVFfcOy2LGl6uFWPAVx8ae/84ypai8iJ6rSiscdMNwZkOrqMTdz/2dFIdkMoMHYkjfd/x7Xafr5E6kbtj9wXnuShwKTGCDr8y5EFmZ7EgtazfrMVHR1c04PyMl2+Kk6G3Cv3w4vL20d9WHJQagBY/K3Q+9GCYH+Rabcpg4W2Lh8gYIFyzYWiQay7MQnSY2kYEpsWVsnThk1VYG3V75TPBW96etCGYkuYQ/Q4SyvYe7fdsuz8Ok3Mjt7uFIEcQrBnvoIE4Jgove+dCbCMUhbiHnskuPqb68j0/wrRmqHPtwJ7EWcXLM0w0ycmq5SgDSxtORNEpUAzeC7S8HwdgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2eWY6eGsJL0/KLQUGsehaoDsAF6ZgyRMXTb/VdxgpI=;
 b=Qh7G1H3W2lUc5zsFbOGGDKG/h9X1E5f6bYXPU9Bf6HIj1A/wU+Z+6RUG6lBjNoqWghNS9xvbbd6dsD/fQMHe+C6UGtAEEB2Rz7OFanmNLImOW+eqPdq3rFefJVtCseR98RWrleYp5oqZcOU4C13lUXLuyqczJXwuPWnCGdde9ovcAN5LxUABJb8UVp1Di7weJ8rpqhwJ3rv+cr19rcpH53ku56MSgCBq0y01RhSlUPZ4pUBpHW3+uhegGhM8IJloIY/tkRSFMOmfE0cyDmWN0Ceh87cpUfB+YAm5t2uX1lFCEEnK9LC6J2Vnr0DmRbJPHMre44DxV5RPNOcoqE8Llw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2eWY6eGsJL0/KLQUGsehaoDsAF6ZgyRMXTb/VdxgpI=;
 b=aeU19ybASELHtCn9royLIiKtiaFmVsh2p+yt+ehZwmW2yP0heJBLaSiBczBVDmRhWFnEuXLXwxBGaJx7ZEB1hjb+DkBCz5RnuJQ3aRwFZdcz8PrKPrAdd4T3pgajrivo1NvxJNf2o5EKj6f9ekdUaojJ6+0SN8MAHNMDksu3qmo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3072.eurprd04.prod.outlook.com (2603:10a6:802:b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 12:39:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 12:39:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Yannick Vignon (OSS)" <yannick.vignon@oss.nxp.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "Sebastien Laveze (OSS)" <sebastien.laveze@oss.nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net] net: stmmac: Disable Tx queues when reconfiguring the
 interface
Thread-Topic: [PATCH net] net: stmmac: Disable Tx queues when reconfiguring
 the interface
Thread-Index: AQHX4JuzJ3vDgWnwEEiIccw05RVf5KwSEHqAgABkMACAACLIgIAAB86A
Date:   Wed, 24 Nov 2021 12:39:15 +0000
Message-ID: <20211124123851.afwftqmblutoa3zj@skbuf>
References: <20211123185448.335924-1-yannick.vignon@oss.nxp.com>
 <20211123200751.3de326e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211124100626.oxsd6lulukwkzw2v@skbuf>
 <fccedd94-d2a8-ed23-852a-2432637adb12@oss.nxp.com>
In-Reply-To: <fccedd94-d2a8-ed23-852a-2432637adb12@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e62caff8-0192-45f6-f61f-08d9af476cd6
x-ms-traffictypediagnostic: VI1PR04MB3072:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR04MB307250BEEF04A399B1A11EEBE0619@VI1PR04MB3072.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: chgId1PwFHczL/e9l+4PKxfZOj97A4rus2Y5thsdhBADeahJYLfIXXL+itEghtf9KqY4+7rGzrfX6J5pNE3m7NzGr3qKZXaqUYvon9ewzbKQOXng3qpg5Fy+I4kFEt53g9ll6wLSlP4eNKT+nZS75GPqGil0Tqsmo/GyFodbMVKxGJ+FV8ZLm541CV5xmy5RgOtcqclJGqbR+bxC437xfYqxCkcXP9QkVYA8AtgAM2vf2JvB5XNeX/nivpEJV38csakmbFwXQzUuU1hF/D93xfWLMqSNdUCn7qQ4uML1w9kPi1khqClnelwnKHtQcGOWV1FV89ZdWemuDMA/gp/sL31mOHIIlC/2hDNUpoUJP6Awd/YtYfMHRaWNztJ1CY3Z0oGWIFqzHTxEgToRdcVxgj/K5QIDhWR0VG4ZMFa7ihVP8+a/S1nCUkVrbHQr+ezLfwQK/JDfUAIkyRLWWi3TXieMWNBmljhVYB9C+/vQ2vPWRL+m9Dc/9RyyYTauVmFpLoTmom/C3Ci8GkmPhCBexxgfDVGzjj4d787tlOVp2GdwzA3fD9yzf+XMICyw5O6GcSkrHP1NVs/LP+Pn2qQZXBkI2PBG59RXRpXjcQSFBm4ja7XxlLdNAYdgjpjd+Ol4DzvfxMLVXc4wIsV66Do3Vlfol6J7vT+5osrpHiit/p3V91EDJ3IL1uv/SAfKSnsSHEUukYJOBp3M/cDJsv57lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(8936002)(38100700002)(33716001)(186003)(66446008)(6506007)(122000001)(66476007)(66556008)(9686003)(64756008)(2906002)(66946007)(76116006)(53546011)(44832011)(6486002)(38070700005)(71200400001)(508600001)(4326008)(54906003)(86362001)(83380400001)(5660300002)(316002)(8676002)(26005)(1076003)(6862004)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J+7RwReIh/0E71XumP8Nsilpbz4NiFQMrcuQ/OTEF1zpO137MwTjZZRLYN5M?=
 =?us-ascii?Q?XpcAUffumQeCTWbD20GXJyDdV7md+QHR2NcNcIMiZgUWpEBQVEajCYHSI/Rq?=
 =?us-ascii?Q?FlMatd48kh2KSVR0wc/Xx63n1tZDcKdSAbbjVNaPB7fBWXrwLgw0Y3/dur8V?=
 =?us-ascii?Q?vbSqaMuCKV354HM9arnrQ5/IK7K+wDt0N7hjp6Ys1Q/8a+bDAHqfxCi44wKy?=
 =?us-ascii?Q?Xcst+2YMT9/qD58MBrzJ+BXGkcyWSMTeWoldtzHanLhBxhZbnvLX94nekmNq?=
 =?us-ascii?Q?KNUr9b9uaKd36tbINIQxpJTnWDdGFRunlVsAz6WN+Fw1tIs0cT/lIidF0u8b?=
 =?us-ascii?Q?bRcQ1qIjA7UYTC2BIIS8wVGi2vkFg/e8s4J35kn08Z6tZyldcuCqmM8AbleZ?=
 =?us-ascii?Q?joqawdK2NZ9lBA2mHENEV+BrLEo87TFPt9nPoOCTYMrwuIBKo+X0LCBsy7U8?=
 =?us-ascii?Q?nZdxfO80h5G6SGVH1oFpnRZxD4lKQncI2IKtpGatl1VEyuV4tJwdHyHMRIp/?=
 =?us-ascii?Q?eB4m+6GBPX9t4EcAQHgV1IC/H+11nWvFc8YtTL8vBw8yjKsYtNO6w93SOF/5?=
 =?us-ascii?Q?D3lkmTKeFSxDXdC6ZGMLpMRmQDDtLhoL8kYnWyC0URWCD7Q/RXeo/9mwmpeV?=
 =?us-ascii?Q?7ysUer/XzPgpssO7ixdfyfWXiqOv4Kt+riVe48UURueQaY5BX8/5OKS4o1Us?=
 =?us-ascii?Q?pchRMRADjVtIj8lrLUHpE4KPkEZSMbU15CjVQCBYsnmV4/SnWIGEIuI6Y0Rr?=
 =?us-ascii?Q?+A4MOpysoY3rZpvJvwt4iCFFCfCnZMiAW3vE4hK4y9/ers6yZzUX7wsD9vP+?=
 =?us-ascii?Q?44FasfBSBYANhkHtf7yD4N1B1og8b6yA2XKZNOUr4qsFAxREjsm6n5Fp90a1?=
 =?us-ascii?Q?Hai0fSKSMJt/nGPr5yDW5L3+UEh5JYNYsgawE5B255mFVCFswqAaJKuNj+Py?=
 =?us-ascii?Q?tazN93rxot0NP3kZE5z0yoNzKd19kaTHL5jgqNpSUL38O0+wUAd9xWVAXuKn?=
 =?us-ascii?Q?TBg2siTB56GrmM9cuPjbQpmCML+UPB2jxJBTuooSa+/02biGiPdeTe+gHdHS?=
 =?us-ascii?Q?z4pn0RAzjSKn9v+4s2hnpXehcDIY3wxsJvtm996kEiGbDXwCDZg4W2/rVkNn?=
 =?us-ascii?Q?YCtDd/znoIy0IKY0InxarEH/sWLBlLmJdJWB3v8TwHcPuKBE/nRlnS0sb0IY?=
 =?us-ascii?Q?YgYzST2BjPLITMbS0MdrwekOBqBZTofqq53EflPvarS4JzBPvf9IjaLnfeIv?=
 =?us-ascii?Q?MwneEN1aaeE+1+48+NEhvI7W0NG49AVH5X7R090IhsMdz0moxBBL7na5doE9?=
 =?us-ascii?Q?p3fLyTR/sI8rmgsSF8dvOrX7i4OT30xvQSvaf6F+OzBFEOr+IqWwYKr1feOD?=
 =?us-ascii?Q?66yrtqOePILXPo2cKyZu1GOdIM/mRWRoC9rkPoGM3DH88DLfE80TWZSqtiXK?=
 =?us-ascii?Q?t0xBmr+DLg0OehYOYvdV6bE2CT2JSzzibMv0Zh2BB83B6S8/I6HwBTPoMSoJ?=
 =?us-ascii?Q?3S5TpGBzCz5ejUHOG6X9F+hA28JA4uVPbcjYcxA54Irg++lhkJedW3klseeM?=
 =?us-ascii?Q?USAfF7PBnge6cS4imTG6eTxX0dXxbUWpKMyZTtQEqe2/iKlS7lZiEDzB8T7n?=
 =?us-ascii?Q?SbutphY+GPewxJoa9BsIQfA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9CBFC99B7B3DA4469E001B0F8D7B2D46@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e62caff8-0192-45f6-f61f-08d9af476cd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 12:39:15.1662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q+Bid/aV67mudis72qUptilB3dFw+7oYl3iE1+PI8FD+xI83jWA5yGg7x1uFkPVlLFhGGFlIZZ9xNh0HLqBfiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 01:10:55PM +0100, Yannick Vignon wrote:
> On 11/24/2021 11:06 AM, Vladimir Oltean wrote:
> > On Tue, Nov 23, 2021 at 08:07:51PM -0800, Jakub Kicinski wrote:
> > > On Tue, 23 Nov 2021 19:54:48 +0100 Yannick Vignon wrote:
> > > > From: Yannick Vignon <yannick.vignon@nxp.com>
> > > >=20
> > > > The Tx queues were not disabled in cases where the driver needed to=
 stop
> > > > the interface to apply a new configuration. This could result in a =
kernel
> > > > panic when doing any of the 3 following actions:
> > > > * reconfiguring the number of queues (ethtool -L)
> > > > * reconfiguring the size of the ring buffers (ethtool -G)
> > > > * installing/removing an XDP program (ip l set dev ethX xdp)
> > > >=20
> > > > Prevent the panic by making sure netif_tx_disable is called when st=
opping
> > > > an interface.
> > > >=20
> > > > Without this patch, the following kernel panic can be observed when=
 loading
> > > > an XDP program:
> > > >=20
> > > > Unable to handle kernel paging request at virtual address ffff80001=
238d040
> > > > [....]
> > > >   Call trace:
> > > >    dwmac4_set_addr+0x8/0x10
> > > >    dev_hard_start_xmit+0xe4/0x1ac
> > > >    sch_direct_xmit+0xe8/0x39c
> > > >    __dev_queue_xmit+0x3ec/0xaf0
> > > >    dev_queue_xmit+0x14/0x20
> > > > [...]
> > > > [ end trace 0000000000000002 ]---
> > > >=20
> > > > Fixes: 78cb988d36b6 ("net: stmmac: Add initial XDP support")
> > > > Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
> > >=20
> > > Fixes tag: Fixes: 78cb988d36b6 ("net: stmmac: Add initial XDP support=
")
> > > Has these problem(s):
> > > 	- Target SHA1 does not exist
> >=20
> > You caught him backporting! Although I agree, things sent to the "net"
> > tree should also be tested against the "net" tree.
> >=20
>=20
> That would be more like forward-porting in this case, since I first fixed
> the issue on an older 5.10 kernel :)

XDP for stmmac isn't in v5.10, so backporting is what it is.=
