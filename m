Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A5F485686
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241860AbiAEQMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:12:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241846AbiAEQMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 11:12:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=misp2UmwUKgsnx5QUJFDkIH1Gcniuw/9ReB03j48h/o=; b=U/Si8+apek4baHr4JkPt3khPPH
        Zz5VABezisY8FYsFb3HMTyZOiCzWxvVcbOv325u512W2Dcant5YYCq7F2gGEUAGI0h1ywZeFZca1z
        oPlBtpyJwFG9nrFzhW/bCTIDpgG3M9m5qL/fZXCPI+eBuu/qZYlPJIRjRVUgt0jnfkaI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n58tR-000ZmN-7R; Wed, 05 Jan 2022 17:12:05 +0100
Date:   Wed, 5 Jan 2022 17:12:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/8] net/funeth: probing and netdev ops
Message-ID: <YdXDVakWSkQyvlqe@lunn.ch>
References: <20220104064657.2095041-1-dmichail@fungible.com>
 <20220104064657.2095041-4-dmichail@fungible.com>
 <20220104180739.572a80ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOkoqZmxHZ6KTZQPe+w23E_UPYWLNRiU8gVX32EFsNXgyzkucg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOkoqZmxHZ6KTZQPe+w23E_UPYWLNRiU8gVX32EFsNXgyzkucg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +     if ((notif->link_state | notif->missed_events) & FUN_PORT_FLAG_MAC_DOWN)
> > > +             netif_carrier_off(netdev);
> > > +     if (notif->link_state & FUN_PORT_FLAG_NH_DOWN)
> > > +             netif_dormant_on(netdev);
> > > +     if (notif->link_state & FUN_PORT_FLAG_NH_UP)
> > > +             netif_dormant_off(netdev);
> >
> > What does this do?
> 
> FW may get exclusive access to the ports in some cases and during those times
> host traffic isn't serviced. Changing a port to dormant is its way of
> telling the host
> the port is unavailable though it has link up.

Quoting RFC2863

3.1.12.  New states for IfOperStatus

   Three new states have been added to ifOperStatus: 'dormant',
   'notPresent', and 'lowerLayerDown'.

   The dormant state indicates that the relevant interface is not
   actually in a condition to pass packets (i.e., it is not 'up') but is
   in a "pending" state, waiting for some external event.  For "on-
   demand" interfaces, this new state identifies the situation where the
   interface is waiting for events to place it in the up state.
   Examples of such events might be:

   (1)   having packets to transmit before establishing a connection to
         a remote system;

   (2)   having a remote system establish a connection to the interface
         (e.g. dialing up to a slip-server).

I can see this being valid if your FW is doing 802.1X. But i'm not
sure it is valid for other use cases. What exactly is your firmware
doing which stops it from handling frames?

	Andrew
