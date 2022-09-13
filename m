Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD165B6D08
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbiIMMSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiIMMSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:18:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EA811A25;
        Tue, 13 Sep 2022 05:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=syUTFhmlYLXNMEub8AP0jCYjs8fuJAQSeGGBybDD1wk=; b=pHwcPmWVvpxARLiqyjmHPh27Ol
        5Kx0a5lp3qeFonq2bw7EhPMD0lU1Q22eJvlRTod5/u8C/htu+8VSSQCVDLUq8SOvRu6rNQEzAU+1p
        4DoNqVmdZoI6yXS490otr6Ixa+Izq+/HaDW4xnC/iwyXYksqEJQDx52dHT3OysXnwhbM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oY4rm-00GaaW-6n; Tue, 13 Sep 2022 14:18:14 +0200
Date:   Tue, 13 Sep 2022 14:18:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [RFC Patch net-next 0/4] net: dsa: microchip: ksz9477: enable
 interrupt for internal phy link detection
Message-ID: <YyB1BjN+lFcZL1kW@lunn.ch>
References: <20220909160120.9101-1-arun.ramadoss@microchip.com>
 <Yx+lsOg3f3PVbcGZ@lunn.ch>
 <4a14a0226b5cb0067fb63e69b87bc0f8a2b50a45.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a14a0226b5cb0067fb63e69b87bc0f8a2b50a45.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 04:21:47AM +0000, Arun.Ramadoss@microchip.com wrote:
> Hi Andrew, 
> On Mon, 2022-09-12 at 23:33 +0200, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > On Fri, Sep 09, 2022 at 09:31:16PM +0530, Arun Ramadoss wrote:
> > > This patch series implements the common interrupt handling for
> > > ksz9477 based
> > > switches and lan937x. The ksz9477 and lan937x has similar interrupt
> > > registers
> > > except ksz9477 has 4 port based interrupts whereas lan937x has 6
> > > interrupts.
> > > The patch moves the phy interrupt hanler implemented in
> > > lan937x_main.c to
> > > ksz_common.c, along with the mdio_register functionality.
> > 
> > It is a good idea to state why it is an RFC. What sort of comments do
> > you want?
> 
> In the arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts file, they
> haven't specified the phy-handle. If I use that dts file with this
> patch, during the mdio_register I get the error *no mdio bus node* and
> the ksz probe fails. If I update the dts file with phy-handle  and mdio
> node, the mdio_register is successfull and interrupt handling works
> fine. Do I need to add any checks before mdio_register or updating the
> dts file is enough?

Drivers are supposed to remain backwards compatible to older DT blobs.
So you need to support the phy-handle not being present.

You can however still add it to at91-sama5d3_ksz9477_evb.dts, have the
yaml binding indicate it is a required property, and maybe in 2 years
change the driver to make it required.

    Andrew
