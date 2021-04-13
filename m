Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BBE35E25D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhDMPMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhDMPMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 11:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70CE86117A;
        Tue, 13 Apr 2021 15:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618326701;
        bh=eBLoqi4G7Z5q2p4GelgsrgM0mJGPJVhKeqAzqynISWc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EgFVnAQn8PDyxiXunmDf8WiljZl13kNM6Aiu0Q0X849xQZMwWDjFnTotthvQtXZGY
         q6kaOCWdSj+NH8Vqhy15BYjQm1hYgc41BvULvO2441zcRDdT+PSZ7iXOqGq4W7LCTK
         XzOsJfxDbTZIOsnelK3yjkFboGa6HankBb/fpx/6OlxoYVMlhFQqNxXpD40dqblfZD
         VFs/6zXJ3nJpoEXoBZWvGeFHKQlkfpR2GiDQxvJlLOgvXdJvyLc7mS5OC3Hw2nAw6o
         2eeCMuF3OJwQt60MXPQJNPoNPnN2CrHELdlKEebQbD9nPdo+dwuE033Ndb7yLNjSIy
         eLyWBCB4u0Riw==
Date:   Tue, 13 Apr 2021 17:11:37 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Subject: Re: [PATCH net-next 1/5] net: phy: marvell: refactor HWMON OOP
 style
Message-ID: <20210413171137.0dd9814a@thinkpad>
In-Reply-To: <YHWsc3H8RzmdfvuR@lunn.ch>
References: <20210413075538.30175-1-kabel@kernel.org>
        <20210413075538.30175-2-kabel@kernel.org>
        <YHWsc3H8RzmdfvuR@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 16:36:35 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > +static int marvell_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
> > +			      u32 attr, int channel, long *temp)
> >  {
> >  	struct phy_device *phydev = dev_get_drvdata(dev);
> > -	int err;
> > +	const struct marvell_hwmon_ops *ops = to_marvell_hwmon_ops(phydev);
> > +	int err = -EOPNOTSUPP;
> >  
> >  	switch (attr) {
> >  	case hwmon_temp_input:
> > -		err = m88e6390_get_temp(phydev, temp);
> > +		if (ops->get_temp)
> > +			err = ops->get_temp(phydev, temp);
> > +		break;
> > +	case hwmon_temp_crit:
> > +		if (ops->get_temp_critical)
> > +			err = ops->get_temp_critical(phydev, temp);
> > +		break;
> > +	case hwmon_temp_max_alarm:
> > +		if (ops->get_temp_alarm)
> > +			err = ops->get_temp_alarm(phydev, temp);
> >  		break;
> >  	default:
> > -		return -EOPNOTSUPP;
> > +		fallthrough;
> > +	}  
> 
> Does the default clause actually service any purpose?
> 
> And it is not falling through, it is falling out :-)
> 
>     Andrew

Seem like I forgot to remove a line :)
