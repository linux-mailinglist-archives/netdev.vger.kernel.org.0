Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5196E95BC
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 15:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjDTNXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 09:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjDTNXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 09:23:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945F444A5;
        Thu, 20 Apr 2023 06:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gkhEaE/aNZgpUhGPC4PT/KQVDtc4Y5mYe1VfRfC4FeY=; b=rUpH3kHcTP39AdAOGkVcof9uN9
        evAfZtKYl3k00DZRI96sx7ibhBf+Dsegq//qaodKdEqyOHb86ngDnyHwGw6uHnTNsxUPT8Xbdrcl7
        svKhNw57zYPRIYv0tZlqQhCWcLvb435zIFF8HQsgghAb3tqD+dFusg9Kc6wBihOH72Lo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppUFP-00AnIq-Qd; Thu, 20 Apr 2023 15:22:51 +0200
Date:   Thu, 20 Apr 2023 15:22:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        olteanv@gmail.com, mengyuanlou@net-swift.com,
        'Jarkko Nikula' <jarkko.nikula@linux.intel.com>
Subject: Re: [PATCH net-next v3 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <72703dc2-0ee1-41b2-9618-2a3185869cbf@lunn.ch>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-3-jiawenwu@trustnetic.com>
 <ec095b8a-00af-4fb7-be11-f643ea75e924@lunn.ch>
 <03ef01d97372$f2ee26a0$d8ca73e0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ef01d97372$f2ee26a0$d8ca73e0$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 06:29:11PM +0800, Jiawen Wu wrote:
> On Thursday, April 20, 2023 4:58 AM, Andrew Lunn wrote:
> > On Wed, Apr 19, 2023 at 04:27:33PM +0800, Jiawen Wu wrote:
> > > Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> > > with SFP.
> > >
> > > Add platform data to pass IOMEM base address, board flag and other
> > > parameters, since resource address was mapped on ethernet driver.
> > >
> > > The exists IP limitations are dealt as workarounds:
> > > - IP does not support interrupt mode, it works on polling mode.
> > > - I2C cannot read continuously, only one byte can at a time.
> > 
> > Are you really sure about that?
> > 
> > It is a major limitation for SFP devices. It means you cannot access
> > the diagnostics, since you need to perform an atomic 2 byte read.
> > 
> > Or maybe i'm understanding you wrong.
> > 
> >    Andrew
> > 
> 
> Maybe I'm a little confused about this. Every time I read a byte info, I have to
> write a 'read command'. It can normally get the information for SFP devices.
> But I'm not sure if this is regular I2C behavior.
 
I don't know this hardware, so i cannot say what a 'read command'
actually does. Can you put a bus pirate or similar sort of device on
the bus and look at the actual I2C signals. Is it performing one I2C
transaction per byte? If so, that is not good.

The diagnostic values, things like temperature sensor, voltage sensor,
received signal power are all 16 bits. You cannot read them using two
time one byte reads. Say the first read sees a 16bit value of 0x00FF,
but only reads the first byte. The second read sees a 16bit value of
0x0100 but only reads the second byte. You end up with 0x0000. When
you do a multi byte read, the SFP should do an atomic read of the
sensor, so you would see either 0x00FF, or 0x0100.

If your hardware can only do single byte reads, please make sure the
I2C framework knows this. The SFP driver should then refuse to access
the diagnostic parts of the SFP, because your I2C bus master hardware
is too broken. The rest of the SFP should still work.

	Andrew.
