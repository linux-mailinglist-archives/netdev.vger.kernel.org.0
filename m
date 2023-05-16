Return-Path: <netdev+bounces-2824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA3DE704383
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A192C1C20CFC
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B9F1C3E;
	Tue, 16 May 2023 02:40:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BB3621
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:40:39 +0000 (UTC)
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C3D102
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:40:36 -0700 (PDT)
X-QQ-mid:Yeas43t1684204734t839t48313
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [115.200.228.151])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 6361813060171089198
To: <andy.shevchenko@gmail.com>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com> <20230515063200.301026-7-jiawenwu@trustnetic.com> <ZGH-fRzbGd_eCASk@surfacebook>
In-Reply-To: <ZGH-fRzbGd_eCASk@surfacebook>
Subject: RE: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Date: Tue, 16 May 2023 10:38:53 +0800
Message-ID: <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQHvj8QD3pC+6Aq9H9h6P1+q5LrHRgMH5FTyAkITzACvBcuB4A==
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > +static int txgbe_gpio_init(struct txgbe *txgbe)
> > +{
> > +	struct gpio_irq_chip *girq;
> > +	struct wx *wx =3D txgbe->wx;
> > +	struct gpio_chip *gc;
> > +	struct device *dev;
> > +	int ret;
>=20
> > +	dev =3D &wx->pdev->dev;
>=20
> This can be united with the defintion above.
>=20
> 	struct device *dev =3D &wx->pdev->dev;
>=20

This is a question that I often run into, when I want to keep this =
order,
i.e. lines longest to shortest, but the line of the pointer which get =
later
is longer. For this example:

	struct wx *wx =3D txgbe->wx;
	struct device *dev =3D &wx->pdev->dev;

should I split the line, or put the long line abruptly there?

> > +	gc =3D devm_kzalloc(dev, sizeof(*gc), GFP_KERNEL);
> > +	if (!gc)
> > +		return -ENOMEM;
> > +
> > +	gc->label =3D devm_kasprintf(dev, GFP_KERNEL, "txgbe_gpio-%x",
> > +				   (wx->pdev->bus->number << 8) | wx->pdev->devfn);
> > +	gc->base =3D -1;
> > +	gc->ngpio =3D 6;
> > +	gc->owner =3D THIS_MODULE;
> > +	gc->parent =3D dev;
> > +	gc->fwnode =3D =
software_node_fwnode(txgbe->nodes.group[SWNODE_GPIO]);
>=20
> Looking at the I=B2C case, I'm wondering if gpio-regmap can be used =
for this piece.

I can access this GPIO region directly, do I really need to use regmap?
=20


