Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8395664C7B8
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 12:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238187AbiLNLIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 06:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237788AbiLNLH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 06:07:59 -0500
Received: from out29-174.mail.aliyun.com (out29-174.mail.aliyun.com [115.124.29.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F4B15739;
        Wed, 14 Dec 2022 03:07:54 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436277|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00335086-7.3198e-05-0.996576;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047208;MF=frank.sae@motor-comm.com;NM=0;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.QVcDstI_1671016054;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QVcDstI_1671016054)
          by smtp.aliyun-inc.com;
          Wed, 14 Dec 2022 19:07:41 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     andrew@lunn.ch
Cc:     Frank.Sae@motor-comm.com, davem@davemloft.net, edumazet@google.com,
        fei.zhang@motor-comm.com, hkallweit1@gmail.com,
        hua.sun@motor-comm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com, pgwipeout@gmail.com,
        yinghong.zhang@motor-comm.com
Subject: Re: [PATCH net-next v2] net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy
Date:   Wed, 14 Dec 2022 19:07:34 +0800
Message-Id: <20221214110734.17103-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


on Dec. 3, 2022, 8:47 p.m. UTC , Andrew Lunn wrote:
> On Fri, Dec 02, 2022 at 01:34:16PM +0000, Russell King (Oracle) wrote:
> > On Fri, Dec 02, 2022 at 02:27:43PM +0100, Andrew Lunn wrote:
> > > > +static bool mdio_is_locked(struct phy_device *phydev)
> > > > +{
> > > > +	return mutex_is_locked(&phydev->mdio.bus->mdio_lock);
> > > > +}
> > > > +
> > > > +#define ASSERT_MDIO(phydev) \
> > > > +	WARN_ONCE(!mdio_is_locked(phydev), \
> > > > +		  "MDIO: assertion failed at %s (%d)\n", __FILE__,  __LINE__)
> > > > +
> > > 
> > > Hi Frank
> > > 
> > > You are not the only one who gets locking wrong. This could be used in
> > > other drivers. Please add it to include/linux/phy.h,
> > 
> > That placement doesn't make much sense.
> > 
> > As I already said, we have lockdep checks in drivers/net/phy/mdio_bus.c,
> > and if we want to increase their effectiveness, then that's the place
> > that it should be done.
> 
> I was following the ASSERT_RTNL model, but that is used in quite deep
> and complex call stacks, and it is useful to scatter the macro in lots
> of places. PHY drivers are however very shallow, so yes, putting them
> in mdio_bus.c makes a lot of sense.
> 
> > I don't see any point in using __FILE__ and __LINE__ in the above
> > macro either. Firstly, WARN_ONCE() already includes the file and line,
> > and secondly, the backtrace is more useful than the file and line where
> > the assertion occurs especially if it's placed in mdio_bus.c
> 
> And PHY driver functions are simpler, there is a lot less inlining
> going on, so the function name is probably all you need to know to
> find where you messed up the locking. So i agree, they can be removed.
> 
>      Andrew

 Hi Andrew and Russell, Thanks!
 
 change the mdio_bus.c like follow ok?
 
 -add "ASSERT_MDIO"
 -add "ASSERT_MDIO(bus);" in __mdiobus_read and __mdiobus_write function 
 
 
 static inline bool mdiobus_is_locked(struct mii_bus *bus)
{
	return mutex_is_locked(&bus->mdio_lock);
}

#define ASSERT_MDIO(bus) \
	WARN_ONCE(!mdiobus_is_locked(bus), \
		  "MDIO: assertion failed\n")
		  
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
{
	int retval;

	ASSERT_MDIO(bus);
	lockdep_assert_held_once(&bus->mdio_lock);

	retval = bus->read(bus, addr, regnum);
...
}

 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
{
	int err;

	ASSERT_MDIO(bus);
	lockdep_assert_held_once(&bus->mdio_lock);

	err = bus->write(bus, addr, regnum, val);
...
}


on Dec. 2, 2022, 1:27 p.m. UTC , Andrew Lunn wrote:
> >  /**
> >   * ytphy_read_ext() - read a PHY's extended register
> >   * @phydev: a pointer to a &struct phy_device
> > @@ -258,6 +271,8 @@ static int ytphy_read_ext(struct phy_device *phydev, u16 regnum)
> >  {
> >  	int ret;
> >  
> > +	ASSERT_MDIO(phydev);
> > +
> >  	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
> >  	if (ret < 0)
> >  		return ret;
> > @@ -297,6 +312,8 @@ static int ytphy_write_ext(struct phy_device *phydev, u16 regnum, u16 val)
> >  {
> >  	int ret;
> >  
> > +	ASSERT_MDIO(phydev);
> > +
> >  	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
> >  	if (ret < 0)
> >  		return ret;
> > @@ -342,6 +359,8 @@ static int ytphy_modify_ext(struct phy_device *phydev, u16 regnum, u16 mask,
> >  {
> >  	int ret;
> >  
> > +	ASSERT_MDIO(phydev);
> > +
> >  	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
> >  	if (ret < 0)
> >  		return ret;
> > @@ -479,6 +498,76 @@ static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
> >  	return phy_restore_page(phydev, old_page, ret);
> >  }
> 
> Please make the above one patch, which adds the macro and its
> users. There are a couple more below as well.
> 
> Did it find any problems in the current code? Any fixes mixed
> in here?
> 
> Then add yt8531 is another patch.
> 

 Thanks! 
 It not find any problems in the current code. 
 ASSERT_MDIO in motorcomm.c will be removed. 
 
> > +/**
> > + * yt8531_set_wol() - turn wake-on-lan on or off
> > + * @phydev: a pointer to a &struct phy_device
> > + * @wol: a pointer to a &struct ethtool_wolinfo
> > + *
> > + * returns 0 or negative errno code
> > + */
> > +static int yt8531_set_wol(struct phy_device *phydev,
> > +			  struct ethtool_wolinfo *wol)
> > +{
> > +	struct net_device *p_attached_dev;
> > +	const u16 mac_addr_reg[] = {
> > +		YTPHY_WOL_MACADDR2_REG,
> > +		YTPHY_WOL_MACADDR1_REG,
> > +		YTPHY_WOL_MACADDR0_REG,
> > +	};
> > +	const u8 *mac_addr;
> > +	u16 mask;
> > +	u16 val;
> > +	int ret;
> > +	u8 i;
> > +
> > +	if (wol->wolopts & WAKE_MAGIC) {
> > +		p_attached_dev = phydev->attached_dev;
> > +		if (!p_attached_dev)
> > +			return -ENODEV;
> > +
> > +		mac_addr = (const u8 *)p_attached_dev->dev_addr;
> 
> Why the cast?

 I'm sorry. What does "Why the cast?" mean?
 
> 
> > +		if (!is_valid_ether_addr(mac_addr))
> > +			return -EINVAL;
> 
>   Andrew
> 

