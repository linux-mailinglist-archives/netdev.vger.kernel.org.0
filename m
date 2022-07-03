Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6A0564694
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiGCKIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiGCKIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:08:46 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2130.outbound.protection.outlook.com [40.107.114.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAC225C4;
        Sun,  3 Jul 2022 03:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFKf80wS35/7gP+Q5OmDh900fhpqdJymX0L0/uZW25b9c9TmaLRpmI4kMq/0Kj/c3dZnXsWEREneX2zrsmviZyYJkUiH778SUTIESF8/NdBPoxZ/W3pJaeoi9uK05dQGlQ9QSjlE7gL0mA+aY3EGrg1JLywSUyA+ng+ac7VdtgdTaQav78Yb0Y8orZtS/sB9qbtRC/qlekGwYoYfSnnw0STJsl9cK2FFZRiC/IxvxhHWjVE0drC3kT0TSOSXJ4j6IY0i8tcZ2bYuozqwkCEmGlO+ajZxl5oMBiRrBCfE9xJhgtLjnqnhp8USspdO1FUQPO38wZu0Pm22DiS0JIYphw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emW5mspLOf6i0g62zdaKEfoVo2QTELAE79zygpWgP0U=;
 b=dFKdeGj7TlldmEetbi/sgcvi64esAHU6YUJKDEd4FCNHKJuteuPWzqDpwOqqzHY8GpRQ5oQqe74jbwHeAoa0dZAIqq+twZikBQB5nzX2lMS3qk3qKqgMtRwG3DcOj9zeimR06Oql2sYK4r4lhkIstyVIO1vDmzBCjsGamQUcXEioMRdhqwnwWN+6JMoFJKI+xBAbQDH/XADj9724dJ+kkw/w0O1PRO9jM7alBIez+TiM64m/1h1P2jWcMTFnKQ3/iC18DNl+ztMHk5g9KiuSmkUbsLAdqxRRBC7OtXL0JTMyhFY5oNqrRPFrDQf406g+FCzPZmz9lOSBdSuGko/chA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emW5mspLOf6i0g62zdaKEfoVo2QTELAE79zygpWgP0U=;
 b=rHHyPy7qBduK+MzJlOZ3jp8SO0mX0VadNJ15g0z7+JReHtfII9HEUsEKIkHBWjO6o3SMvipo4L/sOY3lJ4Ip9igN8FbfYQUtD6fkgIap12fzuMeQkRK1aph/zNn3E78Q1GYx5GO0yh9tNltl/UTvcoOZcBvDhV6yXNWH59lE4iM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB4975.jpnprd01.prod.outlook.com (2603:1096:404:127::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Sun, 3 Jul
 2022 10:08:40 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.019; Sun, 3 Jul 2022
 10:08:40 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Thread-Topic: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Thread-Index: AQHYjhxRAU4FS3w2jke6iP64ezr8Wa1rSJoAgADvqqCAABVEAIAAH22Q
Date:   Sun, 3 Jul 2022 10:08:39 +0000
Message-ID: <OS0PR01MB592289B120F4E92962A0E1C186BF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-7-biju.das.jz@bp.renesas.com>
 <20220702164018.ztizq3ftto4lsabr@pengutronix.de>
 <OS0PR01MB592277E660F0DAC3A614A7C286BF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20220703081412.75t6w5lgt4n3tup2@pengutronix.de>
In-Reply-To: <20220703081412.75t6w5lgt4n3tup2@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04e42a86-4032-4c3e-856e-08da5cdc00ab
x-ms-traffictypediagnostic: TYAPR01MB4975:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BlR3H8WPoJTp35TJWIdfSWRWCAHHjOzzeIzj453ZdCQUGLv+SnHWA1tyoEgt8AMgSJbLxHh/4abFl26qZhfFfLADB2SvJ1shZKJd93MR1jVT+HHcgCMjMLcwD9PWzb3DvKrT1EJh4EzZORK5Sk+oq6SSQNRQgRXm7xdCdjb1FECLzcgR+DMKfZMuZMdWbl3B+MEk3ktKvHA6/U63to0E2jv4BioX9Qp24Awfk1OCgikRdy+KcOO61FAdUStZ7kuAPOhKSmmmDFOTx/4u9SykQuvvICNWTvjVdlgDa9dN58jiNLe2V4P8EB3vgfTxjcB5vdpOzIPrClwFzakIsFT3RA+IWO9zmLhVDJUDdFnWSqAAEkTb1V2M/qk50s/1af+HhQnkoGy4cmy6QhGHZ7a0oitGP2u/78w3x12+HoX/YIyDcopqH3s8R4ForbgrJzrXWsTly08VhtfIY6Lh0wqb3J+tm59GhfJzOSbLo12BEQfYdoRHSnrjnHpj1ETnOcvsGDHgNhULYutoikXWf5OGmHTUqcNTLUVjrjvZX68l4W4XtVBz+kaFQajnzMFJcrJTxQTrxEVMtQEL45Rd7xwYuTVLMCkHKZYemCwiNLeEHuecOo36YSZnL4dtEPU6bXCYgEtlMHZp63kjq0H7gzQSnnfT1/+9Ju0u4ZGhrdIC4GaD6m7yelDIrM3itlDTVEwo2LpjA6r8rm9Mg2tX3AXoqMvaxzNL/6kSyjfFwh34w/lqi+MLnPuOkpsJ/NldLRnWo1a3qW8xl7DUL1Zw5xOoQ5vW1f52uVoSOnO33GqvTAwONRBlqc+cs3Ft4X3LUvkW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(86362001)(66946007)(71200400001)(7416002)(53546011)(38100700002)(316002)(54906003)(6916009)(6506007)(7696005)(55016003)(33656002)(26005)(41300700001)(83380400001)(9686003)(52536014)(186003)(478600001)(64756008)(66476007)(66446008)(4326008)(5660300002)(8676002)(2906002)(76116006)(122000001)(8936002)(66556008)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?0aqWIxKeO86PhyWr3eMjXfxM2m1MQi7r5Yrg0p6ZIlg05Kbn/Whs0fnqQC?=
 =?iso-8859-1?Q?C8ohl2jhU6Rzs1Fb+rJYH/Zu7YmQWZVzRpkV/nqx2h1JQ7MD6mCIitISeI?=
 =?iso-8859-1?Q?MvCjDkaCgSfLX3CZgpDvPynTGtbBVvhSK0uogdjFF2i91KRHVhY/nRmiKo?=
 =?iso-8859-1?Q?ZQ71EWfVF5ZEppOGYy1BDN+tYXBWtpdxAeZnwA5T3OqdPsFAkz3Q+s7Ib8?=
 =?iso-8859-1?Q?caPB6Oui+0qiLWkQDFPMH2aHFTSCEu/uv0llZaLGAo0MqHoawzo40lD9NF?=
 =?iso-8859-1?Q?FfaUVu9bwDawTbQfIZTrfAE7Ja3dgM4timsh13ldPlo86+bCwMQFi/AVpK?=
 =?iso-8859-1?Q?c6enS0IN7U/1oTEBbJrd4ECpaWWZCr3Knu3CnNWlWER/A/r/Gv4dFkZc4V?=
 =?iso-8859-1?Q?a7TMfXuyfnuDDJcbsjWIFXJQfW7DFjB4HS8cGCmeaN6xarUQMOZd4QjI6b?=
 =?iso-8859-1?Q?7erey+KWOttybM0Zrbt4CV3fke4Rc2F/P0bC/lQr85xwe7/pqwpm68akyZ?=
 =?iso-8859-1?Q?i5CSljbDWH7Qabb441dFVpGoHQCl24h5C7uadFse8KluMa1lMZqRGTuLsB?=
 =?iso-8859-1?Q?cL4ZYOm5EfQuCoz7rqiFe8So/f2IjzQ+pZdLw099Cfz9biI8YdjMv35clH?=
 =?iso-8859-1?Q?zFVgHM3q8htYMCEb5bEoIW77mg3szlY4W6i5RdNkq4E4z31MpaGcN3esWc?=
 =?iso-8859-1?Q?RGMoY9t5V2OMTm0hhsSbf92IOcRApWFnbgJKV6yYGxv1q6wFiUooRWhuvJ?=
 =?iso-8859-1?Q?Vv55GtpO4F3vBogEO7q/JCmGpObYGZ1PMGxFbggPZkvbKbOIYHgKd14kOI?=
 =?iso-8859-1?Q?8IWkHnEhrioQslV+TPw2H9CqbXOdQy6C7Z6jwkZObD4c319mb7wZVFWC89?=
 =?iso-8859-1?Q?y0I6tYu4d5jNweR0Cv3Oedb582xTfGITOHDxJLBoIhFKYXl/CMDElKe4Un?=
 =?iso-8859-1?Q?mzqEqgt0eKz7OQW/a5ZSIGRgmRffByNHbFsBVohFByuiPbV0j+7hghHD+t?=
 =?iso-8859-1?Q?Tv0fPtyyrbWFqMl5lDUUp5E0SJ9I3qbqKeo2YF5MQ1ceKkx/ytrydxsxy+?=
 =?iso-8859-1?Q?0XslSbpVc4hFBRfG/HCAOZcy+8ev0S9zMaOFvdMVUFtkCHVgPayikzNGVE?=
 =?iso-8859-1?Q?CeE6eW/vAt95B7NquaJV6buYOjDfND5077aKHlsLJxii8d/BwX05DnxVnU?=
 =?iso-8859-1?Q?HadbZsQuGZxrP+kCQ1g9caTxKjxOEBhvV68ApqjwsSrotjN++UjmUnfUSY?=
 =?iso-8859-1?Q?HWLgCxawqfN256uMixY5FBSL3zLCVFDbOLk0SCuj5kBZ+r9dN2wKYxMkfh?=
 =?iso-8859-1?Q?Et4NzXm2/TU/8sh4fcLEhMsWuVyaaUWxmhC/c5TiKwwhcFitcVIYQCvp5M?=
 =?iso-8859-1?Q?Y/MFHExH465t9KQblDDQ+29IbSKaDuGsZCD5lqYUolicm5icCWqpowZIuA?=
 =?iso-8859-1?Q?eF6R5Fw3fQTAbbJ3jMQ2XaWq2aMpafncStThB+EbJMrjSDcg0oC54g4ApX?=
 =?iso-8859-1?Q?btHY7s+LsiiFJ17lLdVuvS6ytDAcUhKD9YLuVUzmT1N2qqqjdcg/ofpgRg?=
 =?iso-8859-1?Q?3CcwRxCKPWCk9y0TPxFilxOiz74Hls81fRXZ6obDEM05ZRX7xEhbYg4s2u?=
 =?iso-8859-1?Q?3Y7drWHo0uiCc6PRXwwyne4NX9DeUUNTZt58z5+lHC/Wm2ebJZ1mASig?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e42a86-4032-4c3e-856e-08da5cdc00ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2022 10:08:39.9509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: js64F1XY8jND39kK+SyDlFw9kL2VysLuKCOFofPK+n1qoy09djZwIam9eEE/EDaInkWnYK8gROZzk8Gn+Nwg57SIM1jd7M7+jL34f+9DPis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4975
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

Thanks for the feedback.

> Subject: Re: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
> Controller
>=20
> On Sun, Jul 03, 2022 at 07:15:16AM +0000, Biju Das wrote:
> > Hi Marc and Uwe,
> >
> > > Subject: Re: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000
> > > CAN Controller
> > >
> > > On 02.07.2022 15:01:30, Biju Das wrote:
> > > > The SJA1000 CAN controller on RZ/N1 SoC has some differences
> > > > compared to others like it has no clock divider register (CDR)
> > > > support and it has no HW loopback(HW doesn't see tx messages on
> rx).
> > > >
> > > > This patch adds support for RZ/N1 SJA1000 CAN Controller.
> > > >
> > > > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > > ---
> > > >  drivers/net/can/sja1000/sja1000_platform.c | 34
> > > > ++++++++++++++++++----
> > > >  1 file changed, 29 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/drivers/net/can/sja1000/sja1000_platform.c
> > > > b/drivers/net/can/sja1000/sja1000_platform.c
> > > > index 5f3d362e0da5..8e63af76a013 100644
> > > > --- a/drivers/net/can/sja1000/sja1000_platform.c
> > > > +++ b/drivers/net/can/sja1000/sja1000_platform.c
> > > [...]
> > > > @@ -262,6 +276,16 @@ static int sp_probe(struct platform_device
> *pdev)
> > > >  	priv->reg_base =3D addr;
> > > >
> > > >  	if (of) {
> > > > +		clk =3D devm_clk_get_optional(&pdev->dev, "can_clk");
> > > > +		if (IS_ERR(clk))
> > > > +			return dev_err_probe(&pdev->dev, PTR_ERR(clk),
> "no CAN
> > > clk");
> > > > +
> > > > +		if (clk) {
> > > > +			priv->can.clock.freq  =3D clk_get_rate(clk) / 2;
> > > > +			if (!priv->can.clock.freq)
> > > > +				return dev_err_probe(&pdev->dev, -EINVAL,
> "Zero
> > > CAN clk rate");
> > > > +		}
> > >
> > > There's no clk_prepare_enable in the driver. You might go the quick
> > > and dirty way an enable the clock right here. IIRC there's a new
> > > convenience function to get and enable a clock, managed bei devm.
> > > Uwe (Cc'ed) can point you in the right direction.
> >
> >  + clk
> >
> > As per the patch history devm version for clk_prepare_enable is
> rejected[1], so the individual drivers implemented the same using
> devm_add_action_or_reset [2].
> > So shall I implement devm version here as well?
>=20
> You want to make use of 7ef9651e9792b08eb310c6beb202cbc947f43cab (which
> is currently in next). If you cherry-pick this to an older kernel
> version, make sure to also pick
> 8b3d743fc9e2542822826890b482afabf0e7522a.

Ok will use "devm_clk_get_optional_enabled" and send  V2.

Cheers,
Biju


