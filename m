Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291F52EBD85
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 13:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbhAFMMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 07:12:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbhAFMMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 07:12:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C7C32311B;
        Wed,  6 Jan 2021 12:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609935129;
        bh=ZKRMmOIBPLPwNcuMXbiRv00jcX+NJzKvaW8Sgc4RkME=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RTf+NWtOSFCsis3I9GoxCAkYXCPXwOoEhaol2JxX7iO3kmIxn828cEOwD6Lbrsmh8
         rhjjRp6rFk6amBdCrf3ICUcinYLZZnaqM3mnEvWoa/CH9PUYik/1Q12jJXK1kcFT9q
         OKlkpj6qxWmHYmL0sov0SkFktpvFATuGdRXJ5UBOD0/DqYgXeEfcucGbStMk7zPr4e
         emHgVb1VwJqdalgV/hNIKMsYxVVFE3yD+ZtvUsLHzHYLRp3aSW87dt8nNMsGv5ixZQ
         XH11/HlJMq3z/OAfqsjDosFBnoFH+WTVszNB+thPnl5FxMpPWTktSUD33Jns8Foue6
         H/cC38izEAUaA==
Date:   Wed, 6 Jan 2021 13:11:40 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP
 enabled
Message-ID: <20210106131140.44768b25@kernel.org>
In-Reply-To: <X/TKsHr+8U82kwAz@lunn.ch>
References: <20210105171921.8022-1-kabel@kernel.org>
        <X/TKsHr+8U82kwAz@lunn.ch>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jan 2021 21:23:12 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > @@ -4913,8 +4914,8 @@ static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
> >  	bool running = netif_running(port->dev);
> >  	bool reset = !prog != !port->xdp_prog;
> >  
> > -	if (port->dev->mtu > ETH_DATA_LEN) {
> > -		NL_SET_ERR_MSG_MOD(bpf->extack, "XDP is not supported with jumbo frames enabled");
> > +	if (port->dev->mtu > MVPP2_MAX_RX_BUF_SIZE) {
> > +		NL_SET_ERR_MSG_MOD(bpf->extack, "MTU too large for XDP");  
> 
> Hi Marek
> 
> Since MVPP2_MAX_RX_BUF_SIZE is a constant, you can probably do some
> CPP magic and have it part of the extack message, to give the user a
> clue what the maximum is.
> 
>      Andrew

It is a constant that is computed using sizeof of some structs. I don't
know if that can be converted at compile-time to string (it should be,
theoretically, but I don't know if compiler allows it).


