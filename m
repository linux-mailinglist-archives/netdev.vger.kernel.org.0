Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2706CA8DE
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 17:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjC0P0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 11:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjC0P0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 11:26:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89DB2D4C
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=7w3oFciDozr/m0gBbu4/EVE2g5t8g5mXol3WnIcQXOU=; b=z8
        JmgY0ZTBkaR/VuZxwwjpbtxZRpV2/BnGp5Z7o4qY3oo0dKD0U3Wi4VnaXggETd9HQQfwiUlQpxGeA
        qZ4o5PyKBT0zZ2KySS5J0NRCiIRO3boj3tLJlrU1XeYkHWHBOx8j4s2FxS5MB3JVpJPdTeJUABDQ3
        qL6O3U1hUf6ThYY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgoja-008XLd-1V; Mon, 27 Mar 2023 17:26:10 +0200
Date:   Mon, 27 Mar 2023 17:26:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steffen =?iso-8859-1?Q?B=E4tz?= - Innosonix GmbH 
        <steffen@innosonix.de>
Cc:     Fabio Estevam <festevam@gmail.com>, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Subject: Re: [RFC] net: dsa: mv88e6xxx disable IGMP snooping on cpu port
Message-ID: <aba08f9a-899c-4608-b441-27789bcd7ebd@lunn.ch>
References: <20230327134832.216867-1-festevam@gmail.com>
 <8bba8376-95f8-42d0-a6c2-6ea88f684113@lunn.ch>
 <CAK5sFAXDY0RP5NEwHoUBTam73cjU8yEMaZYO1d5yEBLD_TEoEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK5sFAXDY0RP5NEwHoUBTam73cjU8yEMaZYO1d5yEBLD_TEoEA@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 04:51:20PM +0200, Steffen Bätz - Innosonix GmbH wrote:
> Hi Andrew,
> Yes, strangely, this piece of code has stayed the same for years.
> But we only face this behaviour if you add a bridge interface on top of the DSA
> ports.
> The setup looks like: eth0 (physical port of the imx8mn) <-> lan3/lan4 (DSA
> ports of the mv88e6320)
> 
> ip link add br0 type bridge
> ip link set br0 up
> ip link set lan3 master br0
> ip link set lan4 master br0
> ip link set lan3 up
> ip link set lan4 up
> dhcpcd -b br0
> 
> If now you try to receive an audio multicast stream, like from 239.255.84.1,
> the neighbour bridge will not forward this stream to our board. And there is no
> entry in the MDB of the external switch.

Ah, O.K. That is not actually IGMP snooping. It is normal usage of
IGMP. I probably did not test that. I think all my multicast source
and sinks where on switch ports, and i tested that the switch did not
flood multicast to all ports, just ports with listeners.

So your change looks O.K, but as i said, it probably should apply to
DSA ports as well as CPU ports. And i suggest you reword the commit
message to differentiate between IGMP snooping and an IGMP listener on
the bridge.

    Andrew
