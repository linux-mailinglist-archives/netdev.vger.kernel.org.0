Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965D3669E53
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjAMQjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjAMQil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:38:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7FD7BDC5
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 08:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wOTIjssY7stDSP+ycyD2Zk0jtlbLam3j1Bv7LmzhhjQ=; b=BKgMj/RW2s8gvYMreWECxw5Djk
        1r6i6hRxejs0ZfsK9SMa1Ajn0CoGeXrRwSjyOjAIGwyJAX0gXIBwXYctJdTQLUH01R2mRSz/2Rz9e
        ZJPhfhJuqqJ/lnO/Ipy6/8ISyeUcfNTy5wefUDxD+azz7Q+5pUJOPl3ioCw7xwfqv0TA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pGN2P-00217v-EA; Fri, 13 Jan 2023 17:36:17 +0100
Date:   Fri, 13 Jan 2023 17:36:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hau <hau@realtek.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: Re: [PATCH net] r8169: fix rtl8168h wol fail
Message-ID: <Y8GIgXKCtaYzpFdW@lunn.ch>
References: <714782c5-b955-4511-23c0-9688224bba84@gmail.com>
 <Y7dAbxSPeaMnW/ly@lunn.ch>
 <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
 <6ff876a66e154bb4b357b31465c86741@realtek.com>
 <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
 <add32dc486bb4fc9abc283b2bb39efc3@realtek.com>
 <e201750b-f3be-b62d-4dc6-2a00f4834256@gmail.com>
 <Y78ssmMck/eZTpYz@lunn.ch>
 <d34e9d2f3a0d4ae8988d39b865de987b@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d34e9d2f3a0d4ae8988d39b865de987b@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 04:23:45PM +0000, Hau wrote:
> > > >>> In this application(rtl8168h + rtl8211fs) it also supports 100Mbps
> > > >>> fiber
> > > >> module.
> > > >>
> > > >> Does RTL8211FS advertise 100Mbps and 1Gbps on the UTP/MDI side in
> > > >> case of a 100Mbps fiber module?
> > > > Yes.
> > > >
> > > I think in this case internal PHY and RTL8211FS would negotiate 1Gbps,
> > > not matching the speed of the 100Mbps fiber module.
> > > How does this work?
> 
> My mistake. With 100Mbps fiber module RTL8211FS will only advertise 100Mbps
> on the UTP/MDI side. With 1Gbps fiber module it will advertise both 100Mbps and
> 1Gbps. So issue will only happen with 1Gbps fiber module.
> 
> > Fibre line side has no autoneg. Both ends need to be using the same speed,
> > or the SERDES does not synchronise and does not establish link.
> > 
> > You can ask the SFP module what baud rate it supports, and then use
> > anything up to that baud rate. I've got systems where the SFP is fast enough
> > to support a 2.5Gbps link, so the MAC indicates both 2.5G and 1G, defaults to
> > 2.5G, and fails to connect to a 1G link peer. You need to use ethtool to force
> > it to the lower speed before the link works.
> > 
> > But from what i understand, you cannot use a 1000Base-X SFP, set the MAC
> > to 100Mbps, and expect it to connect to a 100Base-FX SFP. So for me, the
> > RTL8211FS should not be advertise 100Mbps and 1Gbps, it needs to talk to
> > the SFP figure out exactly what it is, and only advertise the one mode which
> > is supported.
> 
> It is the RTL8211FS firmware bug. This patch is for workaround this issue.

So if it is advertising both 100Mbps and 1Gbps, we know the SFP is
actually 1G, and we can remove the 100Mbps advertisement? That should
then solve all the problems?

     Andrew
