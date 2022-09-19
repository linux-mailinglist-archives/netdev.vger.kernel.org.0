Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B722B5BD82A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 01:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiISXVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 19:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiISXVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 19:21:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D7E65A8
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 16:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=29TVA0MJVbhhoPx+mD8WeQoGQlpziwpDsCSlNvpR8pY=; b=uXCflug5MqQiyhqCAV0FZb0i11
        7u4aaIzql8JpZDOzMrg78i8/sUONHsGzvHJyvHYPNofD+yhnAF03Dbbp8EXy8Koo41zA5C98dmq2i
        vS5/ufsitoWUHGNUjDrGHqm/wkbCWeiJKawmTL+vcVvD+2mUsS8wMqjDY4WVDMoSnlOg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaQ4w-00HBnI-78; Tue, 20 Sep 2022 01:21:30 +0200
Date:   Tue, 20 Sep 2022 01:21:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 4/9] net: dsa: qca8k: dsa_inband_request: More
 normal return values
Message-ID: <Yyj5emcw/VIrfaan@lunn.ch>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-5-andrew@lunn.ch>
 <20220919230213.yize724zrpiaipgu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919230213.yize724zrpiaipgu@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 11:02:14PM +0000, Vladimir Oltean wrote:
> On Tue, Sep 20, 2022 at 12:18:48AM +0200, Andrew Lunn wrote:
> > wait_for_completion_timeout() has unusual return values.  It can
> > return negative error conditions. If it times out, it returns 0, and
> > on success it returns the number of remaining jiffies for the timeout.
> 
> The one that also returns negative errors is wait_for_completion_interruptible()
> (and its variants).  In my experience the interruptible version is also
> a huge foot gun, since user space can kill the process waiting for the
> RMU response, and the RMU response can still come afterwards, while no
> one is waiting for it.  The noninterruptible wait that we use here
> really returns an unsigned long, so no negatives.

The driver needs to handle the reply coming later independent of ^C
handling, etc. The qca8k has a timeout of 5ms. I don't know if that is
actually enough, if 1G of traffic is being passed over the interface,
and the TX queue is full, and the request frame does not get put at
the head of the queue.  And if there is 1G of traffic also being
received from the switch, how long are the queues for the reply? Does
the switch put the reply at the head of the queue?

This is one thing i want to play with sometime soon, heavily load the
CPU link and see how well the RMU interface to mv88e6xxx works, are
the timeouts big enough? Do frames get dropped and are retires needed?
Do we need to play with the QoS bits of the skb to make Linux put the
RMU packets at the head of the queue etc.

I would also like to have another look at the code and make sure it is
sane for exactly this case.

     Andrew
