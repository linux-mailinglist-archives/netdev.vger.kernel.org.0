Return-Path: <netdev+bounces-6554-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 841DE716E50
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E3D428128E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8091531EEE;
	Tue, 30 May 2023 20:05:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A872D277
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:05:08 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D09F102;
	Tue, 30 May 2023 13:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=df4TGBctqwq7SvhXB8Ixf63L0CvpksALSarocytg7zk=; b=ezdh1nSbrVvLmWdjCqMGaDaWBB
	JwFpliggoNjSMwqqipWAOpjih9h2hbDriTuc6OFzIJMxCUkNT+4qi7fqRrATUNX+K1SKz3HGfJ6b1
	pAlHYCS1s9S5+t4aCJ5L0fnm/U/q8bW+E88Nm3hke/zcjB6XBySyPJYeV4RFPayoaCjQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q45aO-00ENhz-K7; Tue, 30 May 2023 22:04:52 +0200
Date: Tue, 30 May 2023 22:04:52 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <0851bc91-6a7c-4333-ad8a-3a18083411e3@lunn.ch>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
 <20230529215802.70710036@kernel.org>
 <90b1107b-7ea0-4d8f-ad88-ec14fd149582@lunn.ch>
 <20230530121910.05b9f837@kernel.org>
 <ZHZQ+1KNGB7KYZGi@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHZQ+1KNGB7KYZGi@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > This is what I meant FWIW:
> > 
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 7addde5d14c0..829bd57b8794 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -1206,10 +1206,13 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
> >  #define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
> >  				timeout_us, sleep_before_read) \
> >  ({ \
> > -	int __ret = read_poll_timeout(phy_read, val, val < 0 || (cond), \
> > +	int __ret, __val;						\
> > +									\
> > +	__ret = read_poll_timeout(phy_read, __val, __val < 0 || (cond),	\
> >  		sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
> > -	if (val < 0) \
> > -		__ret = val; \
> > +	val = __val;

This results in the sign being discarded if val is unsigned. Yes, the
test is remove, which i assume will stop Smatch complaining, but it is
still broken.

> > +	if (__val < 0) \
> > +		__ret = __val; \
> >  	if (__ret) \
> >  		phydev_err(phydev, "%s failed: %d\n", __func__, __ret); \
> >  	__ret; \

> > I tried enabling -Wtype-limits but it's _very_ noisy :(

This is a no go until GENMASK gets fixed :-(

However, if that is fixed, we might be able to turn it on. But it will
then trigger with this fix.

So i still think a BUILD_BUG_ON is a better fix. Help developers get
the code correct, rather than work around them getting it wrong.

I also wonder if this needs to go down a level. Dan, how often do you
see similar problems with the lower level read_poll_timeout() and
friends?

    Andrew

