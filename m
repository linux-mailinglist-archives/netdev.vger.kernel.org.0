Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BEF6EAA3D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjDUMXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDUMXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:23:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273EC8A53;
        Fri, 21 Apr 2023 05:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Q/rczfRxuTP3u6SatLEYbwKfRvL2f/wGV5+n5uui1Xo=; b=HtLYqcg+apC8kMiOHnaCyyU0bJ
        nxvzJYrHgZV5cN3xmwT0SZ4q8nKgGWytmjog0P7sRUD2Hx7f7sv7hCbwJkxLjwdhZ3bfS/kJTImfG
        MVD9Dp//BEQB4Ozq0FgWk4AsOoTBKrrPzwui+hIlqQtch+0gCqKidRyPv2kgGnT1bSkY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pppmv-00Aska-VO; Fri, 21 Apr 2023 14:22:53 +0200
Date:   Fri, 21 Apr 2023 14:22:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, olteanv@gmail.com,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v3 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <da4a9993-1445-43a9-a0ef-b3414f492962@lunn.ch>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-3-jiawenwu@trustnetic.com>
 <ec095b8a-00af-4fb7-be11-f643ea75e924@lunn.ch>
 <03ef01d97372$f2ee26a0$d8ca73e0$@trustnetic.com>
 <9626e30c-9e0c-b182-4c2e-1ec6c0c98c9e@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9626e30c-9e0c-b182-4c2e-1ec6c0c98c9e@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 09:52:02AM +0300, Jarkko Nikula wrote:
> On 4/20/23 13:29, Jiawen Wu wrote:
> > On Thursday, April 20, 2023 4:58 AM, Andrew Lunn wrote:
> > > On Wed, Apr 19, 2023 at 04:27:33PM +0800, Jiawen Wu wrote:
> > > > Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> > > > with SFP.
> > > > 
> > > > Add platform data to pass IOMEM base address, board flag and other
> > > > parameters, since resource address was mapped on ethernet driver.
> > > > 
> > > > The exists IP limitations are dealt as workarounds:
> > > > - IP does not support interrupt mode, it works on polling mode.
> > > > - I2C cannot read continuously, only one byte can at a time.
> > > 
> > > Are you really sure about that?
> > > 
> > > It is a major limitation for SFP devices. It means you cannot access
> > > the diagnostics, since you need to perform an atomic 2 byte read.
> > > 
> > > Or maybe i'm understanding you wrong.
> > > 
> > >     Andrew
> > > 
> > 
> > Maybe I'm a little confused about this. Every time I read a byte info, I have to
> > write a 'read command'. It can normally get the information for SFP devices.
> > But I'm not sure if this is regular I2C behavior.
> > 
> I agree, IC_DATA_CMD operation is obscure. In order to read from the bus,
> writes with BIT(8) set is required into IC_DATA_CMD, wait (irq/poll)
> DW_IC_INTR_RX_FULL is set in DW_IC_RAW_INTR_STAT and then read back received
> data from IC_DATA_CMD while taking into count FIFO sizes.

Just for my understanding, this read command just allows access to the
data in the FIFO. It has nothing to do with I2C bus transactions.

You also mention FIFO depth. So you should not need to do this per
byte, you can read upto the full depth of the FIFO before having to do
the read command, poll/irq cycle again?

	Andrew
