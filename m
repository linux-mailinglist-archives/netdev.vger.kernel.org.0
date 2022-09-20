Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980D85BEEEC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 23:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiITVEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiITVEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:04:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EEA45F7E
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 14:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yZNsHyd23YOVTRv4+F3vPweqlmFZxulrRZDczGRFNCU=; b=zor3U45rNmkFkPtNNPH7Al1Jpz
        rk+ZjOTOpstOVSKT83/FNCstG61+V9jtISl02DD5giMjMRiyjVM8btFrIJP+ZAkPUv2SJwFe2Hksc
        antO9l/ICeIrpcOXzSMnjvZabayXehlCBBacmFp4HMQMiCslEaCO0HZ0Z1l87G9m9J2c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oakPX-00HIwm-5u; Tue, 20 Sep 2022 23:04:07 +0200
Date:   Tue, 20 Sep 2022 23:04:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Message-ID: <Yyoqx1+AqMlAqRMx@lunn.ch>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
 <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
 <20220920131053.24kwiy4hxdovlkxo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920131053.24kwiy4hxdovlkxo@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 04:10:53PM +0300, Vladimir Oltean wrote:
> On Tue, Sep 20, 2022 at 02:26:22PM +0200, Mattias Forsblad wrote:
> > This whole shebang was a suggestion from Andrew. I had a solution with
> > mv88e6xxx_rmu_available in mv88e6xxx_get_ethtool_stats which he wasn't fond of.
> > The mv88e6xxx_bus_ops is declared const and how am I to change the get_rmon
> > member? I'm not really sure on how to solve this in a better way?
> > Suggestions any? Maybe I've misunderstood his suggestion.
> 
> Can you point me to the beginning of that exact suggestion? I've removed
> everything older than v10 from my inbox, since the flow of patches was
> preventing me from seeing other emails.

What i want to do is avoid code like:

     if (have_rmu())
     	foo()
     else
	bar()

There is nothing common in the MDIO MIB code and the RMU MIB code,
just the table of statistics. When we get to dumping the ATU, i also
expect there will be little in common between the MDIO and the RMU
functions.

Doing MIB via RMU is a big gain, but i would also like normal register
read and write to go via RMU, probably with some level of
combining. Multiple writes can be combined into one RMU operation
ending with a read. That should give us an mv88e6xxx_bus_ops which
does RMU, and we can swap the bootstrap MDIO bus_ops for the RMU
bus_ops.

But how do we mix RMU MIB and ATU dumps into this? My idea was to make
them additional members of mv88e6xxx_bus_ops. The MDIO bus_ops
structures would end up call the mv88e6xxx_ops method for MIB or
ATU. The rmu bus_ops and directly call an RMU function to do it.

What is messy at the moment is that we don't have register read/write
via RMU, so we have some horrible hybrid. We should probably just
implement simple read and write, without combining, so we can skip
this hybrid.

I am assuming here that RMU is reliable. The QCA8K driver currently
falls back to MDIO if its inband function is attempted but fails.  I
want to stress this part, lots of data packets and see if the RMU
frames get dropped, or delayed too much causing failures. If we do see
failures, is a couple of retires enough? Or do we need to fallback to
MDIO which should always work? If we do need to fallback, this
structure is not going to work too well.

	  Andrew
