Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3FF5EB127
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIZTSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIZTSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:18:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5836D9C216;
        Mon, 26 Sep 2022 12:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hS7TFU/5h99HaCSSIks5N//b6fAZfGSpwFxmPBRrixI=; b=XHz1NCfYK3a/4gi9B7dQ/XFHss
        Co4OCAcVisij3zK+7jMLP7dbnDL8xAZZ/NDCQl+rHpE4/jL98jr8bJ+oP2QzCnlPSbFk5vw9qksC+
        AA/rYQp4nDmFaMajeQ5qG3yoV4HdtCimNbrKquzPYGw4g9V0r4Iq1j4UpLa5fDRKQJ+E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1octc5-000Kq6-C5; Mon, 26 Sep 2022 21:17:57 +0200
Date:   Mon, 26 Sep 2022 21:17:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <YzH65W3r1IV+rHFW@lunn.ch>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <Yy2wivbzUA2zroqy@lunn.ch>
 <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 08:12:14AM +0000, Yoshihiro Shimoda wrote:
> Hi Andrew,
> 
> > From: Andrew Lunn, Sent: Friday, September 23, 2022 10:12 PM
> > 
> > > +/* Forwarding engine block (MFWD) */
> > > +static void rswitch_fwd_init(struct rswitch_private *priv)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; i < RSWITCH_NUM_HW; i++) {
> > > +		iowrite32(FWPC0_DEFAULT, priv->addr + FWPC0(i));
> > > +		iowrite32(0, priv->addr + FWPBFC(i));
> > > +	}
> > 
> > What is RSWITCH_NUM_HW?
> 
> I think the name is unclear...
> Anyway, this hardware has 3 ethernet ports and 2 CPU ports.
> So that the RSWITCH_NUM_HW is 5. Perhaps, RSWITCH_NUM_ALL_PORTS
> is better name.

How do the CPU ports differ to the other ports? When you mention CPU
ports, it makes me wonder if this should be a DSA driver?

Is there a public data sheet for this device?

> Perhaps, since the current driver supports 1 ethernet port and 1 CPU port only,
> I should modify this driver for the current condition strictly.

I would suggest you support all three user ports. For an initial
driver you don't need to support any sort of acceleration. You don't
need any hardware bridging etc. That can be added later. Just three
separated ports.

> > > +
> > > +	for (i = 0; i < RSWITCH_NUM_ETHA; i++) {
> > 
> > RSWITCH_NUM_ETHA appears to be the number of ports?
> 
> Yes, this is number of ethernet ports.

In the DSA world we call these user ports. 

> > > +	kfree(c->skb);
> > > +	c->skb = NULL;
> > 
> > When i see code like this, i wonder why an API call like
> > dev_kfree_skb() is not being used. I would suggest reaming this to
> > something other than skb, which has a very well understood meaning.
> 
> Perhaps, c->skbs is better name than just c->skb.

Yes, that is O.K.

     Andrew
