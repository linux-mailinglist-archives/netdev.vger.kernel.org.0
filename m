Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D98F66CEA6
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjAPSVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbjAPSUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:20:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AD242DD8;
        Mon, 16 Jan 2023 10:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673892412; x=1705428412;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0LI5PemXB6D5XGEF//IxS+kZvstyl16JyEFuiogcIJA=;
  b=eHfi0n91CfhRo8sKznaciz4TWL9/q/K2ReGTiNQtFBe4ngCOUzcQvDlq
   hOJfOKJ5eZ5oy3umQ8F5X5wLUiT4W+oyEtAlrW6a5vDrbfhxkWKo+nghl
   0sUS7wPsvfPxtyzci7/wjG3Ni2UYCMuz8b8HEncUxyqlL3//rt8vTuxTn
   y30J/ozzi+vnFOZ9b/lZ+/Kxn/hhdSDugKgajw5byhuqZJPqltPYFzzS0
   iBiMIqEN7oNFZipDfWzROER9MOpfTf3CBAfdWEhMXolcdk8E1makrrhb5
   +uFVFX7QxaYQL9w0vjjxU7ZLPBOIIUK7FucRgLa5TAoeWa4hRFkloae8s
   g==;
X-IronPort-AV: E=Sophos;i="5.97,221,1669100400"; 
   d="scan'208";a="196877816"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 11:06:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 11:06:32 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 11:06:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnZKfMxgNo2cG5VMVFoRKCXEl1TJw1d2wZ8+Q+2LQUPZhh8n2hC7nfw/+D25UNcdiieXeci6KTyztNv5GucfedXUzgPdUFBdgreSRUtu7iKvrhl5zH/Lp1ast55gdlzvr4hUDU9Pv1AHrSiuFWEbkGWhI6vdo3yRnLlyDRw2n2udVTzr47QQ1E4xiID5kohefQwyxel/6d4g3T79FohIRE6hkLuE+JaLFrfwbEs7wgpY577on0pYboDBVw3IoowAti+gfdKDZSKgavJJGRNrtE0M0KHX4p9ZvcW6uaiNQ/GPwAe9NJOtVrhD1/FjzhrfBmsoUBYSia4ucVLLQriu7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x53S+ftZYCX5/ZectRQ+vdP5L+rBIRWwfu69ly5z7l4=;
 b=e1QxSbfD3Iir7kUFohNTEQfIgJuQR1Jx0gF2e11LWve4Ulz8kO/YwHqK1PCGFUXf+k11lPOdhiawHmyCOdbvaCmzn6pOs7T3DGKXJQO46Q6vNci1yV50G3WQEdxsCpJmcQ7vjF/u4AU2mwKQNai9MYrM+jKAlydPWGPfnj0pb2LyI+1XY3I4lSyB7BOHd9V6S6w6g7T+j/vzFg9ulmUxjA7YQ/DGBPPjv6yWwHKhOnYQofrrYwIWtXpTQ9vjrFVbte4va7txU6CqNFjFL62kgBJ8j1dIrA6jukDJNiQVcSAXqp8xDdoNymEv+bG2keKqymDgeUzQqfrjW6CZUH3KrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x53S+ftZYCX5/ZectRQ+vdP5L+rBIRWwfu69ly5z7l4=;
 b=fiizHW66Bedw93zw1RUFOFaRymiRQ916C6CHdswbIN69+pjAX4nOXbpkGTjexC2WPvmYRIO4YgAZJCYbWbIYiRYoEIgvJeTlim4CIWYgUdcQsqKO0WqwG8ToemoYjBTgG8Usvqu2ff/q8I2D28XxmFQsxK2psrhNBMMRfYkURSY=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by IA1PR11MB7679.namprd11.prod.outlook.com (2603:10b6:208:3f1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 18:06:30 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 18:06:30 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v6 2/6] dsa: lan9303: move Turbo Mode bit init
Thread-Topic: [PATCH net-next v6 2/6] dsa: lan9303: move Turbo Mode bit init
Thread-Index: AQHZJHABkK7DClBc80KHKpZcwORjQq6eaqUNgAL25eA=
Date:   Mon, 16 Jan 2023 18:06:30 +0000
Message-ID: <MWHPR11MB1693C77544D2AF002A58DD68EFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-3-jerry.ray@microchip.com>
 <20230109211849.32530-3-jerry.ray@microchip.com>
 <20230114204943.jncpislrqjqvinie@skbuf>
In-Reply-To: <20230114204943.jncpislrqjqvinie@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|IA1PR11MB7679:EE_
x-ms-office365-filtering-correlation-id: 052206e2-9d69-4018-552d-08daf7ec6500
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wXEVyJuQmGMYejJMBAkKtvdgRsjKbAcODyBZzQaC1sopLL2YGgqagZp4jrzcP6+q1sV56dmAEyBl1pPH729jtz0am1Y0wEwe1LtYoZ411lq3eahGLVL26/8p4pIZQxCAWliPAOTJ7j39729cwXKzmH5NUhBBLgxH1G7eU3c44nVrkUfVcq293iBA/Th6/wV/QOKtZmn0cmJiidBgmSaW19SWqlzDgogtwTkTMv09MgJfLcdzM955olLQ5dUBjijvBq1Ih0IicY4ApaHD9AIu+aCqQL5x/wxPLYqzoXg0aH1+EeB++Dvb3q/AAlaI0l6K8NN5AQjj69pz8EjVsvAywQqzmxY7/att3pJUYPu9dKTFJhsBASPmfeIAIaspY0TcBq/95AWXKcgUdfpTPg2KMYnzOBFnDuZlfcuBo7H9M6umLjbK9Z5/QyonPOE+606Ig9fe0SdqaXtjqzuZcWHL5RSSi9p314hNEXGdYoFSy1P+21K7RvgjSeyss1Qv1/UMI6pSFmelN7WRqR2G7DqA1GaUWZvnSpFhMMfhH/iIupx5Pm56gUhtD/OxhaacdXvj8nTvkL4QrnvxFwwRK9R+3DTvxKyKLGEj1Ju9m6BOFY/Ft6eN6qqAF4zs8nfQ2I8akMJ8vn8DLM6bUIm3wqgR450PfIHdAj1JgAe2NeRN9yjhC0VblfVh1rkx6iBd6y63Jc+D9MohYtf0WMMLtvOhPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(86362001)(6916009)(38070700005)(76116006)(66946007)(64756008)(66476007)(8936002)(55016003)(66556008)(52536014)(66446008)(8676002)(4326008)(2906002)(7416002)(122000001)(38100700002)(83380400001)(33656002)(5660300002)(478600001)(71200400001)(7696005)(54906003)(316002)(41300700001)(9686003)(26005)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LZUclFjZuxTIYLCL9gKiGFBZdpf/4oHU5kKfSaMlAvB89TnHwL4z2/Xpr42G?=
 =?us-ascii?Q?Pa1hybZTQfSiyI8LrbxppFZM79jHZlG6kYWKNIqdQLkUu80HkwkYEYOzd7rR?=
 =?us-ascii?Q?gOpKEkZXj4SD+N3PFHulwG39RUY31GlPSO/MQHMoy74G9+yHjwmsvXVfA2bu?=
 =?us-ascii?Q?zsNAxFgTszuR0TsqySwQZh2MvcLnByfmzWEZzYqzPv+uI/74GNHsIZNzoJ2S?=
 =?us-ascii?Q?8neHYo4DhfqRpE0cA5O1iENh0zsMwo7aCqxbjvonhW1/RqFENqRWX/iWdbUx?=
 =?us-ascii?Q?n1YSe5BJM6WeauqaEkphbfkDtVyj+7iJ+EyD5G7URYOnL4Ev8f7egwUqGdTe?=
 =?us-ascii?Q?r817NtEg7fFRUstjwYED19/YejMvf08lCwYNYSkWbqPSmRkeRiz9TeKpevd/?=
 =?us-ascii?Q?XR1Q4SaNGldJWCMxshF2KirfdulTJuFwfa9yLjsltPZj1KmEedkbtcPGHirM?=
 =?us-ascii?Q?D8iELcmv7fcuaeAxY1Z5j60NRp3h5P0pt5Gxaz1bY6SmpRSwyuUB99vJKX+Y?=
 =?us-ascii?Q?Xoi+nJ1s92vkyQ68pxGGOG79hUzHS5e14lucI+CxPIXqLG/xOqXcVeJsdbag?=
 =?us-ascii?Q?0n3rBDa0aoHGMGUug4M5a+8ZYN/KQPuqY25UsiJA/Rf8Er/Cyp+OXNawQSKP?=
 =?us-ascii?Q?ru9HJXWIUejRG1PdjPS+Qj0UE5oYqUKZ6gEvJj4b5r8PmN1GjLS6rBH5eYhP?=
 =?us-ascii?Q?mWge51d3qfE08jIXFxY1TtqwlscbIQj0xUIjmviiXXGPPygBpkoLSEDeIVdK?=
 =?us-ascii?Q?jmQ6YJvdxFf/M5L3sxeluKXT+y+nKaVTKcqX+LqBb9o1+IzfA/yxZJ9abAFt?=
 =?us-ascii?Q?8N4FZOFpEizU9IFMM1bf106DdXjpq55xUxsdhbJJEFBEGhltrl+Eaq2JWrXr?=
 =?us-ascii?Q?iz8Z3TH5IfHIe5JA/N5sJ8NTwQmVIR6WGDFFizFXMORNWsOo7eFT4KUaIzKb?=
 =?us-ascii?Q?1uLE4xY9snwDKjP72avrRjf6oD8SdinRJpEfAZilWl3nF2F3WHQ2V/wHLpNW?=
 =?us-ascii?Q?CJIYeghud3aigdLDXpDGV8kSt93TBWgWd7azykxhAmMWFp2aB5yT/umSjZqs?=
 =?us-ascii?Q?2o9/pEjjWcTzDZWOeouZ6t1C1QN4xWO4Hv/0mYIKa6JJTDZ6xAcjbZtd8pfs?=
 =?us-ascii?Q?MKJcTL3oEf8u62EfKi9hU+nOPH+93jE5VjZiK6CsRtu0fxBqwAsxYi6cb8KX?=
 =?us-ascii?Q?6T4dZty2KjnDVREaBKex8Hhxm/eKyhXH2kEmvU33CIz9ApfQKGIlaQagHQm4?=
 =?us-ascii?Q?ZnhKFkUg/NOPgpy2NDL3s3xeKGZ7O6B88TXTvoFZEOzKSrx7ucw4BAVOqOVV?=
 =?us-ascii?Q?8oWzoxhT2A8bkOLREXiCoRsyg+6NhSHTxdfa5KW9oPyhyRFyW3HxOOK4gkvJ?=
 =?us-ascii?Q?ITREeGaYJmLxw3e8+fQIwq7Hs+o91jhIorViaIO77l4DZWfn9jzc9L35fpFX?=
 =?us-ascii?Q?PBnofQAjvkqu0uhmysEPxOIm4/v7RdNuCnHT3o/E1XhNgHzlvfalihULYc6a?=
 =?us-ascii?Q?OINkDrARTSYIRAgbcw+QUUFsgkmMzoXN7DqtR5OsIEHaUmpfHDWsO0fRwALu?=
 =?us-ascii?Q?DnGrU5Hhzh22Zzk4gcIeWey7rJk4M5opxqRVK/QK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 052206e2-9d69-4018-552d-08daf7ec6500
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 18:06:30.4584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K2cZN0JSaUqv0HpETskz8X9i0h10a8GVWSVIjFFx8kYXWyGFWrAyl1Z22VdDMZS/PzkLDypBan+eOrjm9ldBIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7679
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > In preparing to remove the .adjust_link api, I am moving the one-time
> > initialization of the device's Turbo Mode bit into a different executio=
n
> > path. This code clears (disables) the Turbo Mode bit which is never use=
d
> > by this driver. Turbo Mode is a non-standard mode that would allow the
> > 100Mbps RMII interface to run at 200Mbps.
> >
> > Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> > ---
> >  drivers/net/dsa/lan9303-core.c | 15 ++++++---------
> >  1 file changed, 6 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-c=
ore.c
> > index 5a21fc96d479..50470fb09cb4 100644
> > --- a/drivers/net/dsa/lan9303-core.c
> > +++ b/drivers/net/dsa/lan9303-core.c
> > @@ -886,6 +886,12 @@ static int lan9303_check_device(struct lan9303 *ch=
ip)
> >               return ret;
> >       }
> >
> > +     /* Virtual Phy: Remove Turbo 200Mbit mode */
> > +     lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
> > +
> > +     reg &=3D ~LAN9303_VIRT_SPECIAL_TURBO;
> > +     regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
> > +
>=20
> Isn't a function whose name is lan9303_check_device() being abused for
> this purpose (device initialization)?
>=20
I will move this into lan9303_setup.

Regards,
Jerry.

> >       return 0;
> >  }
> >
> > @@ -1050,7 +1056,6 @@ static int lan9303_phy_write(struct dsa_switch *d=
s, int phy, int regnum,
> >  static void lan9303_adjust_link(struct dsa_switch *ds, int port,
> >                               struct phy_device *phydev)
> >  {
> > -     struct lan9303 *chip =3D ds->priv;
> >       int ctl;
> >
> >       if (!phy_is_pseudo_fixed_link(phydev))
> > @@ -1073,14 +1078,6 @@ static void lan9303_adjust_link(struct dsa_switc=
h *ds, int port,
> >               ctl &=3D ~BMCR_FULLDPLX;
> >
> >       lan9303_phy_write(ds, port, MII_BMCR, ctl);
> > -
> > -     if (port =3D=3D chip->phy_addr_base) {
> > -             /* Virtual Phy: Remove Turbo 200Mbit mode */
> > -             lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ct=
l);
> > -
> > -             ctl &=3D ~LAN9303_VIRT_SPECIAL_TURBO;
> > -             regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl=
);
> > -     }
> >  }
> >
> >  static int lan9303_port_enable(struct dsa_switch *ds, int port,
> > --
> > 2.17.1
