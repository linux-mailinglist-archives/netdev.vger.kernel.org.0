Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60093292E6B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbgJST0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:26:43 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:29416 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbgJST0n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 15:26:43 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8de8700000>; Tue, 20 Oct 2020 03:26:40 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 19 Oct
 2020 19:26:40 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.51) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 19 Oct 2020 19:26:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwQvCa9k+8No+tLCvhRB08IxFk43rhpWEzB3dg+4DddrKbuWwzpLxcyndO4CFcBruF+BhNlG+wl8SrhDgzLw81f7EechVDYDtF5jZDfD72sCknBNE7z6E9SZ5CdmmgJvvlSeCOdymP7IiWYfdOYnkSByuXi+GKTiwQyhHskN2NL68coXSE2O/Tqud8OQWiZ9DDxoj1YTthedQdOgbeTQkLRh01fmHVO34Te1DYcHkxb1pdCFXwKVC6MmkiH4BQvXKTlnKU4yFNYYpuP9+tBi40W14/a3Sci0uBmgp1FVaUzrlmQOmkZ+Fn0PI1FFLJsLrU0lxWUQ7PSVmCkoRUDAFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl6JhD0FwSc8rD6k6M7tqKFk/v0p9uFVyhhoUZ4irg4=;
 b=EePVN7wzb8c6eZoz6JVuKx4CvWrIwPA/sVDTy2P2c88zSfPT2fPKJx2oQxoKilijqYDcCldm6pxSDqSTCv5762nIY9+RrY65GVgSaFdJ7k8sW7FcaMxlTNo9FFPT0hl+KkGpXI/EV2Rs2+vCc7ajpRaUHedLQV9MamF1cO3XxaZ0aQh2fBFEc2QtKWqTVQhRKJ2fXZHIeBjCIkcCrPlKr5xnpwB3xWqsfAFy62tAUZJTIpdGz686hS2NIpW0/U1HWDD1T3bSzP+7VqEEANuCqfX45PaEUxuRAD3UtwY3jkZZzSwXMHjVGpe0lNLvFo05znRBfyJMjQ+JHCpAgTv0Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2872.namprd12.prod.outlook.com (2603:10b6:a03:12e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Mon, 19 Oct
 2020 19:26:36 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 19:26:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Thread-Topic: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Thread-Index: AQHWpdiUyESckSXaE0yVQeBJxm0NBame5gGAgAABELCAAGGbAIAABjLQ
Date:   Mon, 19 Oct 2020 19:26:36 +0000
Message-ID: <BY5PR12MB43223A907782D48862D82246DC1E0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201019052736.628909-1-leon@kernel.org>
 <20201019130751.GE6219@nvidia.com>
 <BY5PR12MB4322102A3DD0EC976FF317E7DC1E0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201019190100.GA6219@nvidia.com>
In-Reply-To: <20201019190100.GA6219@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.223]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91f46ee8-7c4c-4d55-2dfe-08d87464e574
x-ms-traffictypediagnostic: BYAPR12MB2872:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2872D6AEA0941E11566AD959DC1E0@BYAPR12MB2872.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o4yfEeeFVk+d3U6W/PVGdfvGYdyWersM7YSQhdPFJ1mwKMhnYqpjqbw6Y9b01ny8V0AGep/onASz8DqiePyIlNHTNlbbghvdedRXoiOgINJbARsqZsVtYFmYwr0SRJ0H54QzMml8i0KeEHz+d0UYdauFxwXX3lODxB+Pq1l6rGO6D7YjGQ4fl5MilLpbSJkjx9TisYkw0Z5T+AB7JGR/ygDWBEayu3x0WPH4bFEN8r0gsKGauB4ZMlmBUlQUlnx5fRAZH7nI25UvGjy60B/WqU1PzapDzW+hr8j5FZJpTVyyFoOsNrbpGpSBP1gL0NIb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(107886003)(66476007)(76116006)(66446008)(4326008)(7696005)(26005)(6862004)(186003)(66556008)(55236004)(8676002)(6506007)(64756008)(83380400001)(9686003)(55016002)(66946007)(5660300002)(54906003)(2906002)(86362001)(478600001)(33656002)(6636002)(71200400001)(8936002)(52536014)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Q89nBGjplerGZsK9K/UJPzQlnNvCL5jK1QNX0PEcQUFm6kSjoZXRaficeg5hqLrfbDo5KBoX0gTb5seqetgAhmFPOSzuHXOVNFt8CD157w05S36aw4+Y/Fzle1bDKct/iU8KVT3cFoaGjQC+2sTfQyr2clUIg8zLoMqr1+Cw6FB9Qr1j8W00RkZJNuM++P0J4MCpjv/jESLkrSRKoG4LkqdSGD4+siG7uY2eiZspt/PYvHSt+OWFKcQYnNJrrKrH647PG3eTB/hbzCZge7tN0Mg/nzJIxS3PrlhCU/vAFxHrpfLKuYJHuWWwgjM+dLNobvPY1+b0ybGdYEauCtslzT1ZZgqcHuHxeyb2nSHzs2Kf3he9OW5v6+Gt7k4q++RwZCMjYPR1Jd8+uHF62AMKz4OZ06Z5D0hxMIZUlGuMSDwjhF9mjew3+XXcHefd9hPA13O4eueJafsBU43x540x/sEr5iEBroULuF4EQEE5bZeA+rELTzz5WRLLpnl+F4V8SAR57paU8FfdVZENZr6bwzb2gAsCJHGio7nngFOlS/Tde0H2pqlyhI7DVhP61dOINZU5EQNQiA3DAc2txf7chkaFAVGMFmvXkm+X3+zwEntMGo2MI0a4XZTPjAfXB7VcE5mKjfoLBdaZi1slV3lcPQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f46ee8-7c4c-4d55-2dfe-08d87464e574
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 19:26:36.7635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JHa7FrUU3051qrKWS3f+twQuSQI1cGVuUWIkjDi4Tg4GK6UCRfwEXz3i7cVrzC+WbZ8fNYCQiFiNUxKuSrzmZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2872
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603135600; bh=cl6JhD0FwSc8rD6k6M7tqKFk/v0p9uFVyhhoUZ4irg4=;
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
        b=Ae1tKksiZpmNOTNn8WwvkFAkt268h+RH+LTRlo8RwHFX5JkrtzRIWrXjjpXB77cRI
         iEuwx4BbatwZ5it3PpL4KPNmTBx4k3tTZUdJxQ/ZlznCpSFTtwfLNirHtBVaJH7vPE
         5P9PVimDpVhnOn/x3ZJqk3wSAm8tBKfaK0GMuwHsPHLZCNnC+dzO6MbTzWRH/9+2hS
         FWTS0fft3cSnUgOOJ3GnvujEGw+i8U+nNKjLUGggVODHZwRtFRGn+Nkkvyw+Dckjp2
         rHgopYLiq4+yKnYfkj3FIBbLUMpHvNm6gH52EBWVbatwzpul/VCJGH5Aqf2JvwzceS
         cVPMzXrKiLeUw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, October 20, 2020 12:31 AM
>=20
> On Mon, Oct 19, 2020 at 01:23:23PM +0000, Parav Pandit wrote:
> > > > -	err =3D register_netdevice_notifier(&dev->port[port_num].roce.nb)=
;
> > > > +	err =3D register_netdevice_notifier_net(mlx5_core_net(dev->mdev),
> > > > +					      &dev->port[port_num].roce.nb);
> > >
> > > This looks racy, what lock needs to be held to keep *mlx5_core_net()
> stable?
> >
> > mlx5_core_net() cannot be accessed outside of mlx5 driver's load, unloa=
d,
> reload path.
> >
> > When this is getting executed, devlink cannot be executing reload.
> > This is guarded by devlink_reload_enable/disable calls done by mlx5 cor=
e.
>=20
> A comment that devlink_reload_enable/disable() must be held would be
> helpful
>=20
Yes. will add.

> > >
> > > >  	if (err) {
> > > >  		dev->port[port_num].roce.nb.notifier_call =3D NULL;
> > > >  		return err;
> > > > @@ -3335,7 +3336,8 @@ static int mlx5_add_netdev_notifier(struct
> > > >mlx5_ib_dev *dev, u8 port_num)  static void
> > > >mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
> {
> > > >  	if (dev->port[port_num].roce.nb.notifier_call) {
> > > > -		unregister_netdevice_notifier(&dev-
> > > >port[port_num].roce.nb);
> > > > +		unregister_netdevice_notifier_net(mlx5_core_net(dev-
> > > >mdev),
> > > > +						  &dev-
> > > >port[port_num].roce.nb);
> > >
> > > This seems dangerous too, what if the mlx5_core_net changed before
> > > we get here?
> >
> > When I inspected driver, code, I am not aware of any code flow where
> > this can change before reaching here, because registration and
> > unregistration is done only in driver load, unload and reload path.
> > Reload can happen only after devlink_reload_enable() is done.
>=20
> But we enable reload right after init_one
>=20
> > > What are the rules for when devlink_net() changes?
> > >
> > devlink_net() changes only after unload() callback is completed in driv=
er.
>=20
> You mean mlx5_devlink_reload_down ?
>=20
Right.
> That seems OK then
Ok. will work with Leon to add the comment.
>=20
> Jason
