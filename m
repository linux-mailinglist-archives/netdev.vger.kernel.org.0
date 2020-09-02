Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DEA25B166
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgIBQTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:19:01 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:5280 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728937AbgIBQS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 12:18:57 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4fc5ec0000>; Thu, 03 Sep 2020 00:18:52 +0800
Received: from HKMAIL102.nvidia.com ([10.18.16.11])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Wed, 02 Sep 2020 09:18:52 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Wed, 02 Sep 2020 09:18:52 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Sep
 2020 16:18:51 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 2 Sep 2020 16:18:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHiqoAkyiGnbetrK2MYCKR2DUl10v7SPK35A8VXFUN3d0Ecpn0knRsqcUK+oszTdyw+Zm6+giJKaiZXa++NfQo5mcA4DfqMqweT2Lx/83FqcgUeafz3RsVmyfSR6yQiWvgaIN18ZzcedzANBAmi6019B1y7j2iDczCqN7FTXexJe/CHvdyKR8qNl21DkkUuEBeH5r+B/DCv48JsacCd+uQ08dNYK2zpZaK67UihinGaD4qmqJASxAl0c1jwB1au4FFZFTVwN48DgigV2TXsF4QLQhr4moMS2WWCWudUAlfSScCeokJdNYo+wRuHYVwTt6muq4mkK0A8BmWKJ5xRa6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scH6UvwDykLhRx+5/hWn87BFFkAdfk12X+yPhqZ2BB8=;
 b=X/z1lHAFVWvplrq8teMjSmyoVGB7uAhqmfo6F6Xr1C3eVR63m5YqsSLeU7mnK/FMqExm3DFS8HVxdHt7TGWr22LVeVDY4FtCXgQwmThFjRztMPNPIaBshBJF6LADuR+crT+c12xZvYP1KU4uNfGq9MOBMXfr56CQR/CnqRcQ2B+HDC8nVvST0aQdX1mGz3u4j66j6uD1EpHQLbNV7YS196uNm8rxN9BsxGByfLHPRI+5kOUvopuSvE90m91k+vIceBfrbl9rOx4axKRpfRi5ybcIcLVjPspSKgf9i3xrbI+R1QzDvafswJNYAM67S8ywU8DQRfBUdkHGdzha2tBF7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3988.namprd12.prod.outlook.com (2603:10b6:a03:1a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 2 Sep
 2020 16:18:49 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3348.015; Wed, 2 Sep 2020
 16:18:49 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykIAAHVgAgABmzECAANgrgIAAsB0AgAUMOQCAAAZkMIAACfwAgADMOwCAAHEaAIAAP1eAgAB7/gCAAA5/gA==
Date:   Wed, 2 Sep 2020 16:18:48 +0000
Message-ID: <BY5PR12MB432234108C8D89170E267BB1DC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901081906.GE3794@nanopsycho.orion>
        <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901091742.GF3794@nanopsycho.orion>
        <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200902080011.GI3794@nanopsycho.orion>
 <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bb40609-4c26-4c57-f3cd-08d84f5bdffc
x-ms-traffictypediagnostic: BY5PR12MB3988:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB398810AF98913ADDA6682D31DC2F0@BY5PR12MB3988.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: izZ8Ei+QQ/7a/f+naGXwb1AcA5isVMXPYV6UgmcFfw3v4Uw5Nle9MTkfdvCAKyBGbMoPqTMyp5RW7sKmCrM/w6D8TylMO/3PISnEk1xFGNLqUbMB42we8cd/sHXSG6HVqGefa1UrX5bCSyCyW0eqzJtgR++cHk7mYz+/KWlsnJwUb2FoHOiGpoH2/oKrrg78zWjdqnuprPkUV9qdTFD0LCsMPwRqkFOJRm3HfvC13kV/T2Pl0K4D5ttZnfKB5PrNV0AsZ3SYtPOa1UqHnxWojc7jwg4m7TD1My3iaK1hXMyd6GW0ROG0MOII7ZOEQ+LApgb57gg3nkH1uG1U02LgFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(66556008)(86362001)(55016002)(66476007)(8676002)(66446008)(316002)(4326008)(66946007)(186003)(64756008)(478600001)(71200400001)(5660300002)(26005)(52536014)(33656002)(9686003)(110136005)(7696005)(8936002)(2906002)(107886003)(76116006)(6506007)(54906003)(83380400001)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9ZKXGiVaahm6Hw0SgMZtzZQadFZbVMdQJI/+7fZ9XmJsaQZJmjzjCLFtt4p1Q8t+SZ0p7IO9voKIOtLW8dtxIC/nl5uMDz3qJfZlhJC1DL7Ts5IkaSTNr5tdq705QPUeZx/fNPsME/WbPh4hrSyqBGXh/ZwciC6i+wmNFYcVdQyXIoAVehGhElYycIiHriUuGR758YA/uPdRhCOQwxwYH+2m7VvzhY+6dq84MQ1D124h0YSQJzca86NKHonHVGKU2BmwSStG1Jqc8D3beY2f7Hc/wKmf2IVece1PF2vx8VAe3JAOC/GIaL2TF7S4r6Is3Z+W5bykfiz0qiwTStO2k0KC+FMbjEtypmmsh2xnG5GiPWiKFwFnksjEmaPEGLyMS8AvyaOG+Vq7izrgpckUceuRH6PCiPava7CNGM1TWodhadAq/8j+uGqKcsiJ9nFWHr9YkdNWOhQzx41u+4Gw9n97vbR41gZXPpYWxYTTmO/uSDPZEtIO1q5aCkOdBXRES7Tsq0Tkg58UwQU4U6639GqQ1lCylY8hetlHEQhV/pP3+gwQcfbjJM6h5E+xhW98a1DL7GQ/pe5bm9KiJeT37QRmJZr0uqlTwrbxtC7iXnwsvIwoqotIoRTco79L9SNfJm4P9CgkisbePmehzB1Byw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb40609-4c26-4c57-f3cd-08d84f5bdffc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 16:18:48.9797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V7/9jsZIOKyh0NFjJoXz0/uI63nwX/jhMHf3zH6nT5x1jwrDwIg8nkgbzFKgW+6AJk/KrQoUkkSa8kkCbzyJyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3988
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599063532; bh=scH6UvwDykLhRx+5/hWn87BFFkAdfk12X+yPhqZ2BB8=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
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
        b=CXrNYYDEKiMmme5/D2nPHN65XI2fi/FmRN1OV9afje2m816PnohZT9iw/z4ayP3TI
         64SN7P6PvH40JLYD2D6q9NltFXhCjEVtZxRSWL5dGJfjijJ4sL+jFOcl89JZdjkfuB
         T8E2y0WzUC6dZ54UgrUe7e3aoGQm/LZqM+aynRZ0PEGHR7ciuQpzGqYCb3x3q4LWb0
         q4RB28FyNuQDa5uAUy5WUGmCUg34pgTD1dSE/Cqq/jmyqjQR8fOHUg6wL9gR4CurlC
         NbZoitES+fofOgfSnJn/mlDFIiXPhaNYADAHc5SM0utjxAlYecavH1Uml3mPm4VccQ
         UMFtRdMYQZgRg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, September 2, 2020 8:54 PM
>=20
> On Wed, 2 Sep 2020 10:00:11 +0200 Jiri Pirko wrote:
> >>> I didn't quite get the fact that you want to not show controller ID
> >>> on the local port, initially.
> >> Mainly to not_break current users.
> >
> > You don't have to take it to the name, unless "external" flag is set.
> >
> > But I don't really see the point of showing !external, cause such
> > controller number would be always 0. Jakub, why do you think it is
> > needed?
>=20
> It may seem reasonable for a smartNIC where there are only two controller=
s,
> and all you really need is that external flag.
>=20
> In a general case when users are trying to figure out the topology not
> knowing which controller they are sitting at looks like a serious limitat=
ion.
>=20
> Example - multi-host system and you want to know which controller you are
> to run power cycle from the BMC side.
>=20
> We won't be able to change that because it'd change the names for you.

Is BMC controller running devlink instance?
How the power outlet and devlink instance are connected?
Can you please provide the example to understand the relation?

