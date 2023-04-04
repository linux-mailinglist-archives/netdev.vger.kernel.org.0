Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5406D6508
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 16:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbjDDOTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 10:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbjDDOTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:19:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C2A118
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 07:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=D/iIIVE//9NitTjQ41fsnohHi5z4By+bUlqEP/O18uU=; b=nCCw0gp3vjlhSwKxw7PQIkgPa5
        Z+PzhoPIh13dsCu3qs9FB4fD8K9QxcO+uBlSJEW2qz7ZENf6aLSFP7VUJP3nRwaw0JTXIajiWiqOr
        eTFJPFhU6cT+pr2+tYjJx5Hx/xUKoSbON4xmosPUta9zUiJn3rj+cAJFEpgD8yM7imoU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pjhUx-009Pa3-RT; Tue, 04 Apr 2023 16:18:59 +0200
Date:   Tue, 4 Apr 2023 16:18:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 2/6] net: txgbe: Implement I2C bus master driver
Message-ID: <3086ecbc-2884-4743-9953-96f2a225ddbb@lunn.ch>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-3-jiawenwu@trustnetic.com>
 <5071701f-bf69-4fa7-ad43-b780afd057a1@lunn.ch>
 <03fc01d9669f$cb8cb610$62a62230$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03fc01d9669f$cb8cb610$62a62230$@trustnetic.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 10:47:28AM +0800, Jiawen Wu wrote:
> On Monday, April 3, 2023 8:53 PM, Andrew Lunn wrote:
> > On Mon, Apr 03, 2023 at 02:45:24PM +0800, Jiawen Wu wrote:
> > > I2C bus is integrated in Wangxun 10Gb ethernet chip. Implement I2C bus
> > > driver to receive I2C messages.
> > 
> > Please Cc: the i2c mailing list for comments. They know more about I2C than
> the
> > netdev people.
> > 
> > Is the I2C bus master your own IP, or have you licensed a core? Or using the
> open
> > cores i2C bus master? I just want to make sure there is not already a linux
> driver for
> > this.
> > 
> 
> I use the I2C core driver, and implement my own i2c_algorithm. I think it needs
> to configure my registers to realize the function.

I had a quick look, and it appears the hardware is not an open-cores
derived I2C bus master.

As i tried to say, sometimes you just license an I2C bus master,
rather than develop one from scratch. And if it was a licensed IP
core, there is likely to be an existing driver.

> > > +	if (!read) {
> > > +		wx_err(wx, "I2C write not supported\n");
> > > +		return num_msgs;
> > > +	}
> > 
> > Write is not supported at all? Is this a hardware limitation?  I think
> -EOPNOTSUPP
> > is required here, and you need to ensure the code using the I2C bus master has
> > quirks to not try to write.
> 
> It is supported. False testing leads to false perceptions, I'll fix it.

Great. It would be odd not having write support.

	Andrew
