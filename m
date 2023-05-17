Return-Path: <netdev+bounces-3163-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BEC705D91
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 125921C20DA9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 02:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215AF29113;
	Wed, 17 May 2023 02:57:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1243629105
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:57:36 +0000 (UTC)
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015E2124
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:57:18 -0700 (PDT)
X-QQ-mid:Yeas44t1684292102t901t35219
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [115.200.228.151])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 13198834293515255723
To: "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
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
References: <20230515063200.301026-1-jiawenwu@trustnetic.com> <20230515063200.301026-7-jiawenwu@trustnetic.com> <ZGH-fRzbGd_eCASk@surfacebook> <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com> <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
In-Reply-To: <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
Subject: RE: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Date: Wed, 17 May 2023 10:55:01 +0800
Message-ID: <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQHvj8QD3pC+6Aq9H9h6P1+q5LrHRgMH5FTyAkITzAABJU2Y7wJ7xjhgrupZZcA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > > > +   gc =3D devm_kzalloc(dev, sizeof(*gc), GFP_KERNEL);
> > > > +   if (!gc)
> > > > +           return -ENOMEM;
> > > > +
> > > > +   gc->label =3D devm_kasprintf(dev, GFP_KERNEL, =
"txgbe_gpio-%x",
> > > > +                              (wx->pdev->bus->number << 8) | =
wx->pdev->devfn);
> > > > +   gc->base =3D -1;
> > > > +   gc->ngpio =3D 6;
> > > > +   gc->owner =3D THIS_MODULE;
> > > > +   gc->parent =3D dev;
> > > > +   gc->fwnode =3D =
software_node_fwnode(txgbe->nodes.group[SWNODE_GPIO]);
> > >
> > > Looking at the I=C2=B2C case, I'm wondering if gpio-regmap can be =
used for this piece.
> >
> > I can access this GPIO region directly, do I really need to use =
regmap?
>=20
> It's not a matter of access, it's a matter of using an existing
> wrapper that will give you already a lot of code done there, i.o.w.
> you don't need to reinvent a wheel.

I took a look at the gpio-regmap code, when I call =
devm_gpio_regmap_register(),
I should provide gpio_regmap_config.irq_domain if I want to add the =
gpio_irq_chip.
But in this use, GPIO IRQs are requested by SFP driver. How can I get =
irq_domain
before SFP probe? And where do I add IRQ parent handler?



