Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914065A96F0
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiIAMc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbiIAMc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:32:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8711038;
        Thu,  1 Sep 2022 05:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XNmXI7jU75WuQDzAsKPd7wNSubefotJcywkg3XO9tRg=; b=psQxlo7I+LMz3L1Dk3jCh3tvID
        YebsirZC/1jAhKTcjSCu6hXUU2FocuLkt42y//sul/TSaqfv669R4UOOQ6V8RJAtg4if3mISuC8CE
        A4vTQ7G+0TtO/z4K03+sm+EoqQADlTCdVR7lAkmZGw73N5riJ7mv1od2fHJlCkwm24XI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTjNG-00FIpt-Mt; Thu, 01 Sep 2022 14:32:46 +0200
Date:   Thu, 1 Sep 2022 14:32:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [RFC Patch net-next v3 3/3] net: dsa: microchip: lan937x: add
 interrupt support for port phy link
Message-ID: <YxCmbrKFyjtWIHha@lunn.ch>
References: <20220830105303.22067-1-arun.ramadoss@microchip.com>
 <20220830105303.22067-4-arun.ramadoss@microchip.com>
 <Yw4P3OJgtTtmgBHN@lunn.ch>
 <bd7fcde507f47b22f9a4140bb26b91d9bb7e1662.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd7fcde507f47b22f9a4140bb26b91d9bb7e1662.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static irqreturn_t lan937x_girq_thread_fn(int irq, void *dev_id)
> > > +{
> > > +     struct ksz_device *dev = dev_id;
> > > +     unsigned int nhandled = 0;
> > > +     unsigned int sub_irq;
> > > +     unsigned int n;
> > > +     u32 data;
> > > +     int ret;
> > > +
> > > +     ret = ksz_read32(dev, REG_SW_INT_STATUS__4, &data);
> > > +     if (ret)
> > > +             goto out;
> > > +
> > > +     if (data & POR_READY_INT) {
> > > +             ret = ksz_write32(dev, REG_SW_INT_STATUS__4,
> > > POR_READY_INT);
> > > +             if (ret)
> > > +                     goto out;
> > > +     }
> > 
> > What do these two read/writes do? It seems like you are discarding an
> > interrupt?
> 
> This interrupt in Power on reset interrupt. It is enabled by default in
> the chip. I am not performing any operation based on POR. So I just
> cleared the interrupt. Do I need to disable the POR interrupt in the
> setup function, since no operation is performed based on it?

It is pretty normal during interrupt controller creation to first
disable all interrupt sources, then clear the interrupt status
register if that can be done with a single operation, and then
register the interrupt controller with the IRQ core. That way, any
outstanding interrupts don't fire.

	    Andrew
