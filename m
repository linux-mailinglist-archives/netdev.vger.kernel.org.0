Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE992C39CF
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 08:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgKYHNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 02:13:43 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2617 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgKYHNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 02:13:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbe04290000>; Tue, 24 Nov 2020 23:13:45 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 07:13:41 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 25 Nov 2020 07:13:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoAKnr/6Db+YiNkNiV368F2ELWlbnIMagx5iNamvqVupSIPYAAgXUp2HYt1FR0/EAUBAQtQtLbplgxda18rFIP52RHSk7ANkV7HhtNbKB4Z4UpTpxhFqFlv81o/IKSDnTaH63t8KT7AsYJ9dQbXziWvwMdRmIwDiuNBoI4l2a2D+rWadoJvju3eiHsO/GSiGF3DZuXvbwhr16M+Dz/L7qabgESVAQEiIlmKVpnRrZWjUnA0TVnWnAu88JBsm9kGZ15FRlCKJ7hXdgRbqhoSWxHxbKvgmKU58oNgayGgKlT7/hgw2ouxXun8fRc+EkJNe01tfCUHTEXtTtLb0DQu8sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vh2plEGQ1MleHEGB1363xjbcIuRP8FZquVhzk5mwafw=;
 b=cIPGBi30bJjt7f6ohsNxRn3wRs1b4MmotX7d05Z8lDc/HxR8CnCSBuFA756IT7O8Wkc335L9S1O4GlH5+pLAqK+9Am2luiMlKouS1hqm44pwrORPjEy8/0dJYNqSVg8GNz3Ys9IGmhbIHadKEuOUl+LMvoduIaH95gLfNqi5C45i0sX5HqGNXLCJ4CooG6ajAyRmWF9YiikTO9YxvCNFXCAmCw/zWZiVRSU2a+XdauChtpL5FtULyGjNtpqtf8qllLcnx2fiPBXAUtgyMz6ozhfsS1N8dfwwkQxsJyzYgf31fuTSw8LboJtvGLVzxcagG/Dx14x4/qF2Xw0aBP+ZLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2616.namprd12.prod.outlook.com (2603:10b6:a03:66::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Wed, 25 Nov
 2020 07:13:40 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%5]) with mapi id 15.20.3589.030; Wed, 25 Nov 2020
 07:13:40 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev
 attributes
Thread-Topic: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev
 attributes
Thread-Index: AQHWwJaWgnmE6THF8EOAVnewN97U66nX4UcAgACKclA=
Date:   Wed, 25 Nov 2020 07:13:40 +0000
Message-ID: <BY5PR12MB43224995BFBAE791FE75552ADCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201122061257.60425-1-parav@nvidia.com>
        <20201122061257.60425-2-parav@nvidia.com>
 <20201124142910.14cadc35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124142910.14cadc35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b49d398c-41ff-4023-79df-08d89111a2f6
x-ms-traffictypediagnostic: BYAPR12MB2616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2616E2261A6EE50503E50D9FDCFA0@BYAPR12MB2616.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fRFyKwGzTJb2b6hcQOBp2fkh215PDJFFl1arAU6qLX/XVyasjhGUN0Ro4fraIAcmnTveOdtUFmKjgekRBWbaVSpl51PFhfjyM4OaqvvPWys/F/Ig6v2Dzy4MulTM4VAnAL7nZrhMN4SDR1aCXQSIxS1XJiTxS02fcF3OhzNBjmGeseAOTUhabY1j1u1SZ8NxIR7d/EncJ9JFUWE9p3+V1d0kcCWKYv16qy8/XcMqAtnVWylgKUtfMQ+TCf02fQqY6TlCIjbrwViRk8vylJ+efot3ir7rbuWsiDtIVXBi+fNdvAk2qE2j2KCWcRKg/k9W4QE10+dWA4Oq4JSzy/Kkcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(55236004)(7696005)(6916009)(6506007)(71200400001)(86362001)(54906003)(4326008)(2906002)(478600001)(107886003)(52536014)(316002)(5660300002)(64756008)(66446008)(66946007)(76116006)(66556008)(8936002)(26005)(33656002)(186003)(8676002)(83380400001)(9686003)(55016002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rQpeJ54toLEs/sRs7c8mfXoi4Zto3JRBinI9SZKdlMTBXS6KXJoqT/in2sBB?=
 =?us-ascii?Q?IJ8DLgYPHLYSsZaXplx8QdnX9oVvECOPlcmZRcte/VKz0CTv1U3EAy0rAWMv?=
 =?us-ascii?Q?VvgBq8eJlug6xJKZ9Glz2HkEDClTjYgRiTFF0D/p1GN30zUAWc/Kkn9dxljl?=
 =?us-ascii?Q?mndQ7WDo9Ez0MZPYFK9QtuA3MXtCVve0b0Jl5cgUSdG+DTNHJrIheLjryfd+?=
 =?us-ascii?Q?zMQlzxexIt/L9e2uYjtfp8s5Yxp0ljHSxYVaMSn9HL1pLWYqEFJ6efFl3GgI?=
 =?us-ascii?Q?K2VNM6JXBijPRKT6wltDxNCqzXaUpimIcWScwb2c995Djcvt8YWnnbN5pFOn?=
 =?us-ascii?Q?xuzjNQRSg6KyJ74HAtk4h9P8tMpulrksdL1z8SQKfmTSCuP8KeVmDPQJQjXg?=
 =?us-ascii?Q?16CPuonE0pJamZ+pxOVnnJr8Pa3S21w6oYFNEBlaI9+rg6dK1DXmowEwF7oG?=
 =?us-ascii?Q?d+LJE29ZGhAcEcoduDqltB4WUkEr+ffbrMTLUOgFABYOhX0bAUCrTT9+QOkn?=
 =?us-ascii?Q?WJ1ML0AtxoGFepeQHc8pNBMlsxmxGzFneePp8c13M1y5Kx9VJ7j+/CwMvC5O?=
 =?us-ascii?Q?m2nA/ArpfzjhgFSffZ5mkX64hrB/b8Ph5y/c+q0vc0pUiKF/9SGvt8bVvGHt?=
 =?us-ascii?Q?ZzgNE3D/1cj/WTW6CXON6YUMVB4+qVEQfUdKx3b6fVyKlk6zsE6hmFUTiusN?=
 =?us-ascii?Q?96keEqk8bPfeWcEIQ733TD5G95uZ3HniAVa8NuumOOdPlpL8fBuNEnKrLBwz?=
 =?us-ascii?Q?o+rl2H4MmQ/xwaJim7aQ0oDWqsCRqUnNOFuRY/I4afx7aVet4NesdYpZpPPg?=
 =?us-ascii?Q?CO1lWu9TILrRdIQuaAZhZlOB6GzRqSOxOcb0SHqdY+IQ3fk4YZSr+VzjUqOZ?=
 =?us-ascii?Q?Jp1bFiwwOOTtajyzamoX/q1BuiR2Lm/xpx+/QgmA1x3ihVrHn+gBXeq35+t1?=
 =?us-ascii?Q?yczBTWuqTmTEiIgUhnBV0jlzaO0LOKu6LVZ7JOTDt9k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49d398c-41ff-4023-79df-08d89111a2f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 07:13:40.6423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0EGKqnDEI5QKJQ9haL2Pz0zeLG2+IHqB8mo/oOueAumlD/zXgc87G9oF6gmjG6jIOZ//dRWs5pXUx0fT5sXU0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2616
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606288425; bh=vh2plEGQ1MleHEGB1363xjbcIuRP8FZquVhzk5mwafw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=IuJQdcmE7OszVZ2Qb3rfO2N1OOlVwsQmsYnIkVeiAGCTV2K9xUsv3oqqSIIq9u4Ct
         CVtXIVoTxwCb2AxLTnlp6FtirWUqnLPN2FqdmZcmnFnrMm1e8WuQfzRvN2JVqz8CRD
         fmfpj2IdObytZiNFaEbso5xxChIxMO1YE6iebzoB1Mh8/J8KU+oWAatd31GvzYnW9M
         hkwxdeilmRRzLhqOf/fwFeXJsw3XnqamOdGvLm5zVeqM5kOvuaPMqsIIJ32QWZmtgZ
         WPWft64cRX1iDjDH9GwkuqeYyp4dQUTib78XN0Ynxzv3P3K/RxCQcuVYcb+QhjD9QQ
         WecDVmHwDAumA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, November 25, 2020 3:59 AM
>=20
> On Sun, 22 Nov 2020 08:12:56 +0200 Parav Pandit wrote:
> > A netdevice of a devlink port can be moved to different net namespace
> > than its parent devlink instance.
> > This scenario occurs when devlink reload is not used for maintaining
> > backward compatibility.
> >
> > When netdevice is undergoing migration to net namespace, its ifindex
> > and name may change.
> >
> > In such use case, devlink port query may read stale netdev attributes.
> >
> > Fix it by reading them under rtnl lock.
> >
> > Fixes: bfcd3a466172 ("Introduce devlink infrastructure")
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > ---
> >  net/core/devlink.c | 30 ++++++++++++++++++++++++------
> >  1 file changed, 24 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/core/devlink.c b/net/core/devlink.c index
> > acc29d5157f4..6135ef5972ce 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -775,6 +775,23 @@ devlink_nl_port_function_attrs_put(struct sk_buff
> *msg, struct devlink_port *por
> >  	return err;
> >  }
> >
> > +static int devlink_nl_port_netdev_fill(struct sk_buff *msg, struct
> > +devlink_port *devlink_port) {
> > +	struct net_device *netdev =3D devlink_port->type_dev;
> > +	int err;
> > +
> > +	ASSERT_RTNL();
> > +	if (!netdev)
> > +		return 0;
> > +
> > +	err =3D nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
> > +netdev->ifindex);
>=20
> The line wrapping was correct, please keep in under 80. Please tell your =
colleges
> at Mellanox.
>=20
> > +	if (err)
> > +		goto done;
>=20
> 	return err;
>=20
> > +	err =3D nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
> > +netdev->name);
>=20
> 	return nla_put_...
>=20
> > +done:
> > +	return err;
> > +}
> > +
> >  static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *d=
evlink,
> >  				struct devlink_port *devlink_port,
> >  				enum devlink_command cmd, u32 portid, @@ -
> 792,6 +809,8 @@ static
> > int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
> >  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port-
> >index))
> >  		goto nla_put_failure;
> >
> > +	/* Hold rtnl lock while accessing port's netdev attributes. */
> > +	rtnl_lock();
> >  	spin_lock_bh(&devlink_port->type_lock);
> >  	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
> >  		goto nla_put_failure_type_locked;
> > @@ -800,13 +819,10 @@ static int devlink_nl_port_fill(struct sk_buff *m=
sg,
> struct devlink *devlink,
> >  			devlink_port->desired_type))
> >  		goto nla_put_failure_type_locked;
> >  	if (devlink_port->type =3D=3D DEVLINK_PORT_TYPE_ETH) {
> > -		struct net_device *netdev =3D devlink_port->type_dev;
> > +		int err;
>=20
> What's the point of this local variable?
>=20
I will avoid refactor for now, so above comment doesn't need to be addresse=
d.
> > -		if (netdev &&
> > -		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
> > -				 netdev->ifindex) ||
> > -		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
> > -				    netdev->name)))
> > +		err =3D devlink_nl_port_netdev_fill(msg, devlink_port);
> > +		if (err)
>=20
> just put the call in the if ()
Ok.
>=20
> >  			goto nla_put_failure_type_locked;
> >  	}
> >  	if (devlink_port->type =3D=3D DEVLINK_PORT_TYPE_IB) {
>=20
>=20
> Honestly this patch is doing too much for a fix.
>=20
> All you need is the RTNL lock and then add:
>=20
Ok. I will differ the refactor to later point.

> +               struct net *net =3D devlink_net(devlink_port->devlink);
>                 struct net_device *netdev =3D devlink_port->type_dev;
>=20
>                 if (netdev &&
> +                   net_eq(net, dev_net(netdev)) &&
>                     (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
>                                  netdev->ifindex) ||
>                      nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
>=20
>=20
> You can do refactoring later in net-next. Maybe even add a check that dri=
vers
> which support reload set namespace local on their netdevs.
This will break the backward compatibility as orchestration for VFs are not=
 using devlink reload, which is supported very recently.
But yes, for SF who doesn't have backward compatibility issue, as soon as i=
nitial series is merged, I will mark it as local, so that orchestration doe=
sn't start on wrong foot.
