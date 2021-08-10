Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8CD3E8612
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 00:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhHJWb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 18:31:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43720 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231380AbhHJWbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 18:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9+a5E8jFO0xQosv8x3bnudGDmJIh8WavmIWpQN/tAII=; b=aEGpK/e//a7R8BjafH4CkkUkUb
        XJWxK5YnRe+zlVSXpBREsb4hy3eY9QL9e7f4Zq89ECDYWeGyISnWMoLS6RZeVUmOZF0XKUn4QcGdx
        onXJKYtnIeR9HYt8sCb5MYPeHIMkyg6E0RtuXPJdMDXRRQ1hIoeD/uU9WUhgUKtgyyhE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDaHK-00GzNe-AS; Wed, 11 Aug 2021 00:31:22 +0200
Date:   Wed, 11 Aug 2021 00:31:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRL+On9xAt6C+H5v@lunn.ch>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org>
 <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder>
 <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder>
 <71a5bd72-2154-a796-37b7-f39afdf2e34d@intel.com>
 <20210810150636.26c17a8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810150636.26c17a8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 03:06:36PM -0700, Jakub Kicinski wrote:
> On Tue, 10 Aug 2021 22:00:51 +0000 Keller, Jacob E wrote:
> > >> Jake do you know what the use cases for Intel are? Are they SFP, MAC,
> > >> or NC-SI related?  
> > > 
> > > I went through all the Intel drivers that implement these operations and
> > > I believe you are talking about these commits:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c3880bd159d431d06b687b0b5ab22e24e6ef0070
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d5ec9e2ce41ac198de2ee18e0e529b7ebbc67408
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ab4ab73fc1ec6dec548fa36c5e383ef5faa7b4c1
> > > 
> > > There isn't too much information about the motivation, but maybe it has
> > > something to do with multi-host controllers where you want to prevent
> > > one host from taking the physical link down for all the other hosts
> > > sharing it? I remember such issues with mlx5.
> > >   
> > 
> > Ok, I found some more information here. The primary motivation of the
> > changes in the i40e and ice drivers is from customer requests asking to
> > have the link go down when the port is administratively disabled. This
> > is because if the link is down then the switch on the other side will
> > see the port not having link and will stop trying to send traffic to it.
> > 
> > As far as I can tell, the reason its a flag is because some users wanted
> > the behavior the other way.
> > 
> > I'm not sure it's really related to the behavior here.
> 
> I think the question was the inverse - why not always shut down the
> port if the interface is brought down?

Humm. Something does not seem right here. I would assume that when you
administratively configure the link down, the SERDES in the MAC would
stop sending anything. So the module has nothing to send. The link
peer SERDES then looses sync, and reports that upwards as carrier
lost.

Does the i40e and ice leave its SERDES running when the link is
configured down? Or is the switch FUBAR and does not consider SERDES
loss of sync as carrier down?

Ido's use case does seem to be different. The link is down. Do we want
to leave the module active, probably sending a bit stream of all 0,
maybe noise, or do we want to power the module down, so it does not
send anything at all.

     Andrew
