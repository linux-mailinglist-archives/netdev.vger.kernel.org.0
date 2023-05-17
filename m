Return-Path: <netdev+bounces-3461-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0F5707446
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C58842814EB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC62107AA;
	Wed, 17 May 2023 21:30:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B0FAD28
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:30:02 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E8F1996;
	Wed, 17 May 2023 14:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=YQ/waTn/4esVCDDekDi58999aSnIc14UPn0SAKuaX7w=; b=q1
	efnrPypgQgZifUGOYhCQwD+zdhVxpxea/r1xchsI4x2tNoz0GnprxVXQsB/B/KXqxESB2pcCPB6+S
	8HDxN6YqSjnQwko5sJ1mSzqucM8uzO3UkkzRD9eP2utfSDO+tLydGpg0azlis/V0waHV1dHUi7Jwy
	LPF0WsA3wQa1LYM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzOiV-00DAtx-Ak; Wed, 17 May 2023 23:29:51 +0200
Date: Wed, 17 May 2023 23:29:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Add support for
 WAKE_FILTER
Message-ID: <7e3b5d21-946b-49e9-b0a9-805af8cca9ae@lunn.ch>
References: <20230516231713.2882879-1-florian.fainelli@broadcom.com>
 <20230516231713.2882879-3-florian.fainelli@broadcom.com>
 <a47d27e0-a8ef-4df0-aa45-623dda9e6412@lunn.ch>
 <011706c2-f0fb-42d2-81a9-7e5e4fbd784d@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <011706c2-f0fb-42d2-81a9-7e5e4fbd784d@broadcom.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > > ethtool -N eth0 flow-type ether dst 01:00:5e:00:00:fb loc 0 action -2
> > > ethtool -n eth0
> > > Total 1 rules
> > > 
> > > Filter: 0
> > >          Flow Type: Raw Ethernet
> > >          Src MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
> > >          Dest MAC addr: 01:00:5E:00:00:FB mask: 00:00:00:00:00:00
> > >          Ethertype: 0x0 mask: 0xFFFF
> > >          Action: Wake-on-LAN
> > > ethtool -s eth0 wol f
> > 
> > What i don't particularly like about this is its not vary
> > discoverable, since it is not part of:
> > 
> >            wol p|u|m|b|a|g|s|f|d...
> >                    Sets Wake-on-LAN options.  Not all devices support
> >                    this.  The argument to this option is a string of
> >                    characters specifying which options to enable.
> > 
> >                    p   Wake on PHY activity
> >                    u   Wake on unicast messages
> >                    m   Wake on multicast messages
> >                    b   Wake on broadcast messages
> >                    a   Wake on ARP
> >                    g   Wake on MagicPacket™
> >                    s   Enable SecureOn™ password for MagicPacket™
> >                    f   Wake on filter(s)
> >                    d   Disable (wake on  nothing).   This  option
> >                        clears all previous options.
> > 
> > If the PHY hardware is not generic, it only has one action, WoL, it
> > might be better to have this use the standard wol commands. Can it be
> > made to work under the 'f' option?
> 
> You actually need both, if you only configure the filter with
> RX_CLS_FLOW_WAKE but forget to set the 'f' bit in wolopts, then the wake-up
> will not occur because the PHY will not have been configured with the
> correct matching mode.

Ah. Please could you extend the man page for ethtool. Maybe make flow
type action -2 reference wol, and wol f reference flow-type?

> I was initially considering that the 'sopass' field could become an union
> since it is exactly the size of a MAC address (6 bytes) and you could do
> something like:
> 
> ethtool -s eth0 wol f mac 01:00:5E:00:00:FB

Yes, i was thinking something like that.

> but then we have some intersection with the 'u', 'm' and 'b' options too,
> which are just short hand for specific MAC DAs.

The man page for ethtool say:

           sopass xx:yy:zz:aa:bb:cc
                  Sets the SecureOn™ password.  The argument  to  this  option
                  must    be    6   bytes   in   Ethernet   MAC   hex   format
                  (xx:yy:zz:aa:bb:cc).

So i don't think it is too much of an API bendage to pass a MAC
address in a union.

I had a quick look at some Marvell switches. They allow an arbitrary
Unicast MAC address to be used to wake a port. So such an extension
could be used for it as well.

And it looks like the Marcell Alaska PHY could implement it as
well. So it would not be limited to just the Broadcom PHYs.

      Andrew

