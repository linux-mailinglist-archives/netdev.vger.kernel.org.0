Return-Path: <netdev+bounces-5583-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFA37122FC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96AD328175F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A45107B1;
	Fri, 26 May 2023 09:04:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B75523D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:04:14 +0000 (UTC)
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5CE194
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:04:04 -0700 (PDT)
X-QQ-mid:Yeas43t1685091710t715t18142
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [125.120.148.168])
X-QQ-SSF:00400000000000F0FOF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 2709956065173614677
To: "'Russell King \(Oracle\)'" <linux@armlinux.org.uk>
Cc: "'Jakub Kicinski'" <kuba@kernel.org>,
	<netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230524091722.522118-1-jiawenwu@trustnetic.com> <20230524091722.522118-9-jiawenwu@trustnetic.com> <20230525211403.44b5f766@kernel.org> <022201d98f9a$4b4ccc00$e1e66400$@trustnetic.com> <ZHBxJP4DXevPNpab@shell.armlinux.org.uk>
In-Reply-To: <ZHBxJP4DXevPNpab@shell.armlinux.org.uk>
Subject: RE: [PATCH net-next v9 8/9] net: txgbe: Implement phylink pcs
Date: Fri, 26 May 2023 17:01:49 +0800
Message-ID: <026901d98fb0$b5001d80$1f005880$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIrQcdiCo7tNEhbaUMwQ6r5o07FvQI4H2aIApOsZCcBuMNaNAG5zvSTrobqp4A=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Friday, May 26, 2023 4:43 PM, Russell King (Oracle) wrote:
> On Fri, May 26, 2023 at 02:21:23PM +0800, Jiawen Wu wrote:
> > On Friday, May 26, 2023 12:14 PM, Jakub Kicinski wrote:
> > > On Wed, 24 May 2023 17:17:21 +0800 Jiawen Wu wrote:
> > > > +	ret = devm_mdiobus_register(&pdev->dev, mii_bus);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	mdiodev = mdio_device_create(mii_bus, 0);
> > > > +	if (IS_ERR(mdiodev))
> > > > +		return PTR_ERR(mdiodev);
> > > > +
> > > > +	xpcs = xpcs_create(mdiodev, PHY_INTERFACE_MODE_10GBASER);
> > > > +	if (IS_ERR(xpcs)) {
> > > > +		mdio_device_free(mdiodev);
> > > > +		return PTR_ERR(xpcs);
> > > > +	}
> > >
> > > How does the mdiodev get destroyed in case of success?
> > > Seems like either freeing it in case of xpcs error is unnecessary
> > > or it needs to also be freed when xpcs is destroyed?
> >
> > When xpcs is destroyed, that means mdiodev is no longer needed.
> > I think there is no need to free mdiodev in case of xpcs error,
> > since devm_* function leads to free it.
> 
> If you are relying on the devm-ness of devm_mdiobus_register() then
> it won't. Although mdiobus_unregister() walks bus->mdio_map[], I
> think you are assuming that the mdio device you've created in
> mdio_device_create() will be in that array. MDIO devices only get
> added to that array when mdiobus_register_device() has been called,
> which must only be called from mdio_device_register().
> 
> Please arrange to call mdio_device_free() prior to destroying the
> XPCS in every case.

Get it.


