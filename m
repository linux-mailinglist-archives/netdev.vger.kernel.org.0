Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851BA5FE7FD
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 06:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJNEaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 00:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiJNEaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 00:30:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC8F360BE;
        Thu, 13 Oct 2022 21:30:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2xCEBcggdoPJJZFrlvuCXw1/hJxXiChjPrBETKy1NXlteW8F+RNhgRe3UVNb9G2E1SjnAbKxgR9EXxsE/oHXzIiA7Qd7S8gTB42Q0xHwcBn2iJkXunSatnw7W7JZDqT3rZPxnlH3yMToCoEN2oFzAskHEbW7WQ/37MJpV7+u/SN7zKyYa1gwNofhHcHTgufMmPEd+0kn+vsMVCiYvxsL72HTqq8Hj1XDrOKJrOeX30azWQo53+fI5A75DpCFInWbZacWBMGjeOD3kEHYhOk1Rnb/SN9pfLwaiPDWK5dBCVB5WhCJLSQoXPAMTpRnrcFZ8J5dH1v7dTM/W3OkiDCwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4O8qQ3O9aJwCqPF7wmzluBCAkheLmT+418ShroVJ6KE=;
 b=CKuwP6kFOMIAR/btP+XCbKfTcTFI+9l/5IFFZVmq/PnW+yVnQ48PAxRp8Tp7plMNc413yR+GXz8/wAe6QZ4xyUYPwRWlKLXhTpGnCj124TS2g0ZHo+LH0YUOGdDOiZbbKrxEwoqa6kP0X+v9DrFZYPrcI6OlRrJYCcQiuvGurs2+5sn4zoBthQTJ3kDRTnn+XFAa3+NaSxGHLzF1CZP7ZgBt7AOHcHFhdtp1yS4uNv3FRv7p1NYMm6hqcTsxKiLvzgN+j/sh3LqvZR3dsWMmpI3Ja7Txp0/PqlMQS3Cm+RCn/eQeS63sm4Qg5E3Oq34YPqwZLt0zqFLgyTIU1iCZDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4O8qQ3O9aJwCqPF7wmzluBCAkheLmT+418ShroVJ6KE=;
 b=w2yf5a1qY0siUIlAE8xyMHUePZQpdfi0ncwqdseeW74jqnmitNKnbWdBwGwey4M/2crgs91htgzjy22zC78plMttT1hD0ifN5aX1fjqjIq3fkj1kSVdIRXqVGBkInl/uPjczGyxKlMBCuie1mWE5nP+WrZ4Wqx3/UOjX2mSpoBI=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by SN7PR12MB7108.namprd12.prod.outlook.com (2603:10b6:806:2a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Fri, 14 Oct
 2022 04:30:07 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::cab4:3484:aff3:6b5]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::cab4:3484:aff3:6b5%5]) with mapi id 15.20.5709.022; Fri, 14 Oct 2022
 04:30:06 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Subject: RE: [PATCH] net: phy: dp83867: Extend RX strap quirk for SGMII mode
Thread-Topic: [PATCH] net: phy: dp83867: Extend RX strap quirk for SGMII mode
Thread-Index: AQHY3tVrTI0eMyNrMUuydPTJ4sl7XK4MUJQAgAD8nDA=
Date:   Fri, 14 Oct 2022 04:30:06 +0000
Message-ID: <BYAPR12MB4773374B74AF0162A930003A9E249@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20221013072833.28558-1-harini.katakam@amd.com>
 <Y0gRjoOOJQmGQ6Ao@lunn.ch>
In-Reply-To: <Y0gRjoOOJQmGQ6Ao@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|SN7PR12MB7108:EE_
x-ms-office365-filtering-correlation-id: a79998fb-6f8b-4460-e9ea-08daad9cc559
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: drssMuXOH2k5X6FGzk3hBHfanV3hpAmfjweRW05jOEUlqGI/nmldM7wNhpy1mowrXtip+9TshPJUTyvXi0iJZMffXSbRUoAYY4zUFvF6Mbxv5A7HYBoST4Fd+9TzYFIjW3aufmuH2c4AKsaQsRK2lusAG1dUk/gfCHaHf0odeheVnpUHzOMDAh5vZxsFjCiuSyjWR16vBcJFE7FTCejYetGfFWBRnQBIuAewrl/h7plOwSduz316/RUSzGHOK6wZMUs+4piygHrLQ+RKvPQZzPuO8nQ7rfv53CcuUhOduEVxBUuaWXtdGsvlt4W+XhCDN2FcjPH9Lj8fKbYyZWUXvoMv6I0Rx91yKmi0AdnH5DWi3DgnHWAm0HvU+uBT1tg9yCAKnELszjwy2SsKRkwWIrlK7J8x91/Vg53W5Dc0Jy1djgCLRoAhfBJke+TImCC4/JugYbAman5KykcJ0IB7ORcSqKrjtdb2Q5ymwiSO97uMaGkQm8R5VzdiLFIPegpSoxRQTE2GbmKBm37AWU33hNuuKOOfF/+K9pIm2YVC/HNVfxsr34UAuFvVQX25vvUIAYm3NdTx/FUAh3PloaUyHb9iyvC5DfIkYSsCnskhOVkTPORWDSajii0xOciDCJ3B0kGFYftjHJUf577gkXumXXns2HZLRvV0acsO1auwha6x4TtFVOot0nMqu6KuuahhvZMN0gjgy0tdPxxb/pLeRhe+bSplqVGeuh4kGVaTTzGNV75DIsdK2akcty+hkKAMPkwIhhJMHEk/OKMa0UVMag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199015)(9686003)(53546011)(55016003)(316002)(122000001)(38070700005)(6916009)(71200400001)(38100700002)(8676002)(54906003)(7416002)(33656002)(478600001)(6506007)(83380400001)(52536014)(86362001)(186003)(4326008)(7696005)(64756008)(76116006)(8936002)(2906002)(66446008)(66476007)(5660300002)(66556008)(41300700001)(26005)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gvm8OzL0F103O2SKucZ/G4pu5hWAMUyGq1ZWOW1s6lRxGIxB8NC3NGerTPR3?=
 =?us-ascii?Q?x1ODCw4TsOUBgBHJR+MiU3CqCjY545h+odnt2gps+SBtelHfictqdvySl01n?=
 =?us-ascii?Q?/00J+KO5RA6ACaa7MDCrUrrFGTOZRH9ZbNfvz062/4PF/a6C894gL8q2febW?=
 =?us-ascii?Q?MNTzAJcmfCtYKKJmbalZv4kD+cRhn8rhmrfz+cAbj7TDQlsEU/7xfU3cdCS+?=
 =?us-ascii?Q?eLsebM/a8otDzC9VX1dYGSa7BrKqB7r15zkkEj8voT/DqlwKnvstLCXdZWpF?=
 =?us-ascii?Q?D+tjHCS3EiO0gD0l5oxscuFmqfH7Gxy2eYhhaFhVXpHLXqHF9+SJ30dI6+bW?=
 =?us-ascii?Q?lYeoaiuaY1zR8Zf8FXl6RMntw4PCQegXb5xaTnQ1j85WG7iM+81loW2Wb2a4?=
 =?us-ascii?Q?C3oOmfMPqBnXSmHuD9XTlbTf9wwHmt20XtVYF49PeEaUvIfiKH0D4vZJXPtO?=
 =?us-ascii?Q?aoLpCktz8m7HYlVWHfKTd1P/HYvcs5aRhmXDF7xCDAMnsXFPk7g5NVzyF9+b?=
 =?us-ascii?Q?ifAob/1AQj4LwBkBfuihJPMB0oAuI3JRmkheFR9LHxyumIeJHX7Tv4vtmtvy?=
 =?us-ascii?Q?mLmvYPgNAkp+x7R3SXvdfc2SWXd4/jL/fneJe0mH2m0NNbMGCt2Zy/0Gg8t5?=
 =?us-ascii?Q?MhrGO25EOVA+uZG+ACOj/C1hEnJvzjhV6eoniyatyP+3zV8Nek94HuoHzv6Y?=
 =?us-ascii?Q?mXrBWHqmah2Qnf8ho+0I2vcH/Eb1ebu9gpFMl+qf2pq39S8CC5arjVAscvik?=
 =?us-ascii?Q?qVE/fmlUEvNJE2G3GCIiGkgE+B3vu3suq4+CK1b3OfcmosjdMUQveW1mpULL?=
 =?us-ascii?Q?ujd6YlKRJAiAl6scCWlD6MSBYBqBPmCKqmy7COvBqJW9UAkB6svwObrLVU50?=
 =?us-ascii?Q?zJJfulHqvDsEdlwPcMJexPSRX01VMdFTaWQox3HVnURiygj0+sp9mfxW8fde?=
 =?us-ascii?Q?xLf3P4CkfwgkBH7Qb8F5o8VFNMoQqlnILQ/ZnNwIV5vmUPOzX6zgz/2e+WmL?=
 =?us-ascii?Q?ep44GO1KK94UTgN4OxhuIGpAp+ITD2YEjA8DjbRwyxahwhm+oRzxEs87qPvc?=
 =?us-ascii?Q?mqjVrTNYjAAmNqEc8IC+nWx0Qoy6VGDHrJjcsR2U3+ZAM/6r0+p72AiWGAaW?=
 =?us-ascii?Q?dMy9Jk0HJP2SF5/IGABVvVJfXKp2srRJjFfLrSZjXThQy6l4opiT1qWvRgzl?=
 =?us-ascii?Q?Ar9C5bF0BHRQVGXrrSPK1lqD+GzObmoiFDGjxNeTvKQ+Pfa2iXkUdPdmeltx?=
 =?us-ascii?Q?fdA+Rxn9wQnJtcLxO8ynp0DYgpmZ8ps/OvqwKvv8YVEdYvVReoopVpaDBnIt?=
 =?us-ascii?Q?pmgRIcrsi+FWn7VG4wXkWFESx2eRqy7y3J0WnVhr/vxegwCq+H5UcfGM7UjH?=
 =?us-ascii?Q?MrCe8dtazDp0PL404/7RRpWIQBDFHUjsnmPzEfv77AMGrx73hmhqtlUQyq8d?=
 =?us-ascii?Q?Pr8mtQE4E7TZmexKsPcZDNftnR8GWWc40pULsfHUd4ZmhqpcFTu0E9aze4Id?=
 =?us-ascii?Q?joS1UucraqS54lu8Ge41X4tYAosygJGPl0n0eml26w2UMpYx1zLpuAUzrMBi?=
 =?us-ascii?Q?34K4Xlp9InmA+UQ6arw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79998fb-6f8b-4460-e9ea-08daad9cc559
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 04:30:06.3229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mr2kZlGg8jAuVGBA8muMsCj3YossiMY0Sl7ZZAVt1r+xfP+ekBjoHLQu6ZcT97wL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7108
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, October 13, 2022 6:55 PM
> To: Katakam, Harini <harini.katakam@amd.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> harinikatakamlinux@gmail.com; Simek, Michal <michal.simek@amd.com>;
> Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Subject: Re: [PATCH] net: phy: dp83867: Extend RX strap quirk for SGMII
> mode
>=20
> On Thu, Oct 13, 2022 at 12:58:33PM +0530, Harini Katakam wrote:
> > When RX strap in HW is not set to MODE 3 or 4, bit 7 and 8 in CF4
> > register should be set. The former is already handled in
> > dp83867_config_init; add the latter in SGMII specific initialization.
> >
> > Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> > ---
> >  drivers/net/phy/dp83867.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> > index 6939563d3b7c..a2aac9032af6 100644
> > --- a/drivers/net/phy/dp83867.c
> > +++ b/drivers/net/phy/dp83867.c
> > @@ -853,6 +853,13 @@ static int dp83867_config_init(struct phy_device
> *phydev)
> >  		else
> >  			val &=3D ~DP83867_SGMII_TYPE;
> >  		phy_write_mmd(phydev, DP83867_DEVADDR,
> DP83867_SGMIICTL, val);
> > +		/* This is a SW workaround for link instability if RX_CTRL is
> > +		 * not strapped to mode 3 or 4 in HW. This is required for
> SGMII
> > +		 * in addition to clearing bit 7, handled above.
> > +		 */
>=20
> Blank line before a comment please.
>=20
> Should this have a fixes tag? Are there deployed boards which are broken
> because of this? Or do you have a new board, using SGMII, which is not
> deployed yet?

Thanks for the review. I will add a fixes tag on the original patch that ad=
ded
SGMII support. I dint consider it first because this is workaround for a HW
strap issue. Yes, we have boards that are deployed.

Regards,
Harini
