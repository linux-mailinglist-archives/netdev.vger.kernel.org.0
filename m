Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CC8403146
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347000AbhIGXAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 19:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhIGXAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 19:00:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C54461102;
        Tue,  7 Sep 2021 22:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631055570;
        bh=nGpqf9eKCPXs9ltBzhrRbhUr7UDlwNfkYD+tDUG5F0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zpzp4hWRuXtk8Wzgz6BfZyLDYgSngqKYhyhTkXBKaRJ9NwNtLfGP9lWBbeD6jx1l7
         2B+TrTjIoReAI9tOVptql2FcciZkLeb388XmG+5KfLZqTxDnjlzIPQaohcbQWrx4uK
         Ci/U/JbUIZUZJKiQ7/DX/+mdGjqRQpHTwARksCoXMLJ4yydkM0OSU7lfBqN6ssHdAo
         OWoMXeTotHdJsA/laffPOHdJOYMxzi3s7xDHkq0jamND3ewDvJ44d3oIQBaBHYBiQA
         hXSjJGgNOhjIZnF6rSja6CbibJp7qwm3hDSt2nhGzUXn/64Hf+ln9AbNysWhTbdmEG
         aH78r9LvJm08g==
Date:   Wed, 8 Sep 2021 01:59:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <YTfuzdA/sd6itkCe@unreal>
References: <YTRswWukNB0zDRIc@unreal>
 <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal>
 <20210905103125.2ulxt2l65frw7bwu@skbuf>
 <YTSgVw7BNK1e4YWY@unreal>
 <20210905110735.asgsyjygsrxti6jk@skbuf>
 <20210907084431.563ee411@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac8e1c9e-5df2-0af7-2ab4-26f78d5839e3@gmail.com>
 <YTeWmq0sfYJyab6d@lunn.ch>
 <a71d0e0c-159e-e82e-36f2-bf3434445343@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a71d0e0c-159e-e82e-36f2-bf3434445343@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 07, 2021 at 09:49:48AM -0700, Florian Fainelli wrote:
> 
> 
> On 9/7/2021 9:43 AM, Andrew Lunn wrote:
> > On Tue, Sep 07, 2021 at 08:47:35AM -0700, Florian Fainelli wrote:
> > > 
> > > 
> > > On 9/7/2021 8:44 AM, Jakub Kicinski wrote:
> > > > On Sun, 5 Sep 2021 14:07:35 +0300 Vladimir Oltean wrote:
> > > > > Again, fallback but not during devlink port register. The devlink port
> > > > > was registered just fine, but our plans changed midway. If you want to
> > > > > create a net device with an associated devlink port, first you need to
> > > > > create the devlink port and then the net device, then you need to link
> > > > > the two using devlink_port_type_eth_set, at least according to my
> > > > > understanding.
> > > > > 
> > > > > So the failure is during the creation of the **net device**, we now have a
> > > > > devlink port which was originally intended to be of the Ethernet type
> > > > > and have a physical flavour, but it will not be backed by any net device,
> > > > > because the creation of that just failed. So the question is simply what
> > > > > to do with that devlink port.
> > > > 
> > > > Is the failure you're referring to discovered inside the
> > > > register_netdevice() call?
> > > 
> > > It is before, at the time we attempt to connect to the PHY device, prior to
> > > registering the netdev, we may fail that PHY connection, tearing down the
> > > entire switch because of that is highly undesirable.
> > > 
> > > Maybe we should re-order things a little bit and try to register devlink
> > > ports only after we successfully registered with the PHY/SFP and prior to
> > > registering the netdev?
> > 
> > Maybe, but it should not really matter. EPROBE_DEFER exists, and can
> > happen. The probe can fail for other reasons. All core code should be
> > cleanly undoable. Maybe we are pushing it a little by only wanting to
> > undo a single port, rather than the whole switch, but still, i would
> > make the core handle this, not rearrange the driver. It is not robust
> > otherwise.
> 
> Well yes, in case my comment was not clear, I was referring to the way that
> DSA register devlink ports, not how the mv88e6xxx driver does it. That is
> assuming that it is possible and there was not a reason for configuring the
> devlink ports ahead of the switch driver coming up.

This is the best arrangement. It is responsibility of the caller (DSA
core) to ensure that calls are valid prior to the devlink core.

Thanks

> -- 
> Florian
