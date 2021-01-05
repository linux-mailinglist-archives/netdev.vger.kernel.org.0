Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88B42EB41B
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbhAEUVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:21:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbhAEUVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 15:21:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwspK-00GEHf-3p; Tue, 05 Jan 2021 21:21:10 +0100
Date:   Tue, 5 Jan 2021 21:21:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP enabled
Message-ID: <X/TKNlir5Cyimjn3@lunn.ch>
References: <20210105171921.8022-1-kabel@kernel.org>
 <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
 <20210105184308.1d2b7253@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210105184308.1d2b7253@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 06:43:08PM +0100, Marek Behún wrote:
> On Tue, 5 Jan 2021 18:24:37 +0100
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> 
> > On Tue, Jan 05, 2021 at 06:19:21PM +0100, Marek Behún wrote:
> > > Currently mvpp2_xdp_setup won't allow attaching XDP program if
> > >   mtu > ETH_DATA_LEN (1500).
> > > 
> > > The mvpp2_change_mtu on the other hand checks whether
> > >   MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.
> > > 
> > > These two checks are semantically different.
> > > 
> > > Moreover this limit can be increased to MVPP2_MAX_RX_BUF_SIZE, since in
> > > mvpp2_rx we have
> > >   xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
> > >   xdp.frame_sz = PAGE_SIZE;
> > > 
> > > Change the checks to check whether
> > >   mtu > MVPP2_MAX_RX_BUF_SIZE  
> > 
> > Hello Marek,
> > 
> > in general, XDP is based on the model, that packets are not bigger than 1500.
> > I am not sure if that has changed, I don't believe Jumbo Frames are upstreamed yet.
> > You are correct that the MVPP2 driver can handle bigger packets without a problem but
> > if you do XDP redirect that won't work with other drivers and your packets will disappear.
> 
> At least 1508 is required when I want to use XDP with a Marvell DSA
> switch: the DSA header is 4 or 8 bytes long there.
> 
> The DSA driver increases MTU on CPU switch interface by this length
> (on my switches to 1504).
> 
> So without this I cannot use XDP with mvpp2 with a Marvell switch with
> default settings, which I think is not OK.

Hi Marek

You are running XDP programs on the master interface? So you still
have the DSA tag? What sort of programs are you running? I guess DOS
protection could work, once the program understands the DSA tag. To
forward the frame out another interface you would have to remove the
tag. Or i suppose you could modify the tag and send it back to the
switch? Does XDP support that sort of hairpin operation?

	Andrew
