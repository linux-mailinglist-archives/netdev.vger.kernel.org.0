Return-Path: <netdev+bounces-5596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59977712370
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 111971C21164
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34F01097F;
	Fri, 26 May 2023 09:24:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D9FAD48
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:24:34 +0000 (UTC)
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947A2B3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:24:30 -0700 (PDT)
X-QQ-mid:Yeas48t1685092950t385t15547
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [125.120.148.168])
X-QQ-SSF:00400000000000F0FOF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 13830273829998832965
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
References: <20230524091722.522118-1-jiawenwu@trustnetic.com> <20230524091722.522118-9-jiawenwu@trustnetic.com> <20230525211403.44b5f766@kernel.org> <022201d98f9a$4b4ccc00$e1e66400$@trustnetic.com> <ZHBxJP4DXevPNpab@shell.armlinux.org.uk> <026901d98fb0$b5001d80$1f005880$@trustnetic.com> <ZHB2vXBP1B2iHXBl@shell.armlinux.org.uk>
In-Reply-To: <ZHB2vXBP1B2iHXBl@shell.armlinux.org.uk>
Subject: RE: [PATCH net-next v9 8/9] net: txgbe: Implement phylink pcs
Date: Fri, 26 May 2023 17:22:29 +0800
Message-ID: <026a01d98fb3$97e3d8b0$c7ab8a10$@trustnetic.com>
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
Thread-Index: AQIrQcdiCo7tNEhbaUMwQ6r5o07FvQI4H2aIApOsZCcBuMNaNAG5zvSTAdySFWcA4jXyEq5w+Lmw
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Friday, May 26, 2023 5:07 PM, Russell King (Oracle) wrote:
> On Fri, May 26, 2023 at 05:01:49PM +0800, Jiawen Wu wrote:
> > On Friday, May 26, 2023 4:43 PM, Russell King (Oracle) wrote:
> > > On Fri, May 26, 2023 at 02:21:23PM +0800, Jiawen Wu wrote:
> > > > On Friday, May 26, 2023 12:14 PM, Jakub Kicinski wrote:
> > > > > On Wed, 24 May 2023 17:17:21 +0800 Jiawen Wu wrote:
> > > > > > +	ret = devm_mdiobus_register(&pdev->dev, mii_bus);
> > > > > > +	if (ret)
> > > > > > +		return ret;
> > > > > > +
> > > > > > +	mdiodev = mdio_device_create(mii_bus, 0);
> > > > > > +	if (IS_ERR(mdiodev))
> > > > > > +		return PTR_ERR(mdiodev);
> > > > > > +
> > > > > > +	xpcs = xpcs_create(mdiodev, PHY_INTERFACE_MODE_10GBASER);
> > > > > > +	if (IS_ERR(xpcs)) {
> > > > > > +		mdio_device_free(mdiodev);
> > > > > > +		return PTR_ERR(xpcs);
> > > > > > +	}
> > > > >
> > > > > How does the mdiodev get destroyed in case of success?
> > > > > Seems like either freeing it in case of xpcs error is unnecessary
> > > > > or it needs to also be freed when xpcs is destroyed?
> > > >
> > > > When xpcs is destroyed, that means mdiodev is no longer needed.
> > > > I think there is no need to free mdiodev in case of xpcs error,
> > > > since devm_* function leads to free it.
> > >
> > > If you are relying on the devm-ness of devm_mdiobus_register() then
> > > it won't. Although mdiobus_unregister() walks bus->mdio_map[], I
> > > think you are assuming that the mdio device you've created in
> > > mdio_device_create() will be in that array. MDIO devices only get
> > > added to that array when mdiobus_register_device() has been called,
> > > which must only be called from mdio_device_register().
> > >
> > > Please arrange to call mdio_device_free() prior to destroying the
> > > XPCS in every case.
> >
> > Get it.
> 
> It seems this is becoming a pattern, so I think we need to solve it
> differently. How about something like this, which means you only have
> to care about calling xpcs_create_mdiodev() and xpcs_destroy() ?
> 
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index b87c69c4cdd7..802222581feb 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -1240,6 +1240,7 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
>  	if (!xpcs)
>  		return ERR_PTR(-ENOMEM);
> 
> +	mdio_device_get(mdiodev);
>  	xpcs->mdiodev = mdiodev;
> 
>  	xpcs_id = xpcs_get_id(xpcs);
> @@ -1272,6 +1273,7 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
>  	ret = -ENODEV;
> 
>  out:
> +	mdio_device_put(mdiodev);
>  	kfree(xpcs);
> 
>  	return ERR_PTR(ret);
> @@ -1280,8 +1282,33 @@ EXPORT_SYMBOL_GPL(xpcs_create);
> 
>  void xpcs_destroy(struct dw_xpcs *xpcs)
>  {
> +	mdio_device_put(mdiodev);
>  	kfree(xpcs);
>  }
>  EXPORT_SYMBOL_GPL(xpcs_destroy);
> 
> +struct dw_xpcs *xpcs_create_mdiodev(struct mii_bus *bus, int addr,
> +				    phy_interface_t interface)
> +{
> +	struct mdio_device *mdiodev;
> +	struct dw_xpcs *xpcs;
> +
> +	mdiodev = mdio_device_create(bus, addr);
> +	if (IS_ERR(mdiodev))
> +		return ERR_CAST(mdiodev);
> +
> +	xpcs = xpcs_create(mdiodev, interface);
> +
> +	/* xpcs_create() has taken a refcount on the mdiodev if it was
> +	 * successful. If xpcs_create() fails, this will free the mdio
> +	 * device here. In any case, we don't need to hold our reference
> +	 * anymore, and putting it here will allow mdio_device_put() in
> +	 * xpcs_destroy() to automatically free the mdio device.
> +	 */
> +	mdio_device_put(mdiodev);
> +
> +	return xpcs;
> +}
> +EXPORT_SYMBOL_GPL(xpcs_create_mdiodev);
> +
>  MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> index 1d7d550bbf1a..537b62330c90 100644
> --- a/include/linux/mdio.h
> +++ b/include/linux/mdio.h
> @@ -108,6 +108,16 @@ int mdio_driver_register(struct mdio_driver *drv);
>  void mdio_driver_unregister(struct mdio_driver *drv);
>  int mdio_device_bus_match(struct device *dev, struct device_driver *drv);
> 
> +static inline void mdio_device_get(struct mdio_device *mdiodev)
> +{
> +	get_device(&mdiodev->dev);
> +}
> +
> +static inline void mdio_device_put(struct mdio_device *mdiodev)
> +{
> +	mdio_device_free(mdiodev);
> +}
> +
>  static inline bool mdio_phy_id_is_c45(int phy_id)
>  {
>  	return (phy_id & MDIO_PHY_ID_C45) && !(phy_id & ~MDIO_PHY_ID_C45_MASK);

Looks great, it can eliminate to create mdiodev in the ethernet driver, this device
only be used in xpcs.


