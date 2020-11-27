Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8A22C6CF7
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 22:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgK0VkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 16:40:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730724AbgK0Viw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 16:38:52 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CD7D20B80;
        Fri, 27 Nov 2020 21:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606513074;
        bh=ojJHa5lDUC3cTeSBkT0n3tQW/Ji0O8s/f5ves8gdgfA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z3jUOIk92H4vKaVu/FiREM6uBFvhVV6KhrUNwQnm6dDqHIPk7l/Oi5ltikqOLHY9j
         E2IRqoJAPBZZja1X88fBqd0T4OB92z8BUmqghjNTXdWf5Ajpm5yU7iFJ9TU0wfP9dd
         Rn6OYrNNQo+D5UGXQmnvxoABAMswXQPMP8De102s=
Date:   Fri, 27 Nov 2020 13:37:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
        <20201125193740.36825-3-george.mccollister@gmail.com>
        <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
        <20201126132418.zigx6c2iuc4kmlvy@skbuf>
        <20201126175607.bqmpwbdqbsahtjn2@skbuf>
        <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
        <20201126220500.av3clcxbbvogvde5@skbuf>
        <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
        <20201127195057.ac56bimc6z3kpygs@skbuf>
        <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replying to George's email 'cause I didn't get Vladimir's email from
the ML.

On Fri, 27 Nov 2020 14:58:29 -0600 George McCollister wrote:
> > 100 Kbps = 12.5KB/s.
> > sja1105 has 93 64-bit counters, and during every counter refresh cycle I  

Are these 93 for one port? That sounds like a lot.. There're usually 
~10 stats (per port) that are relevant to the standard netdev stats.

> Yeah, that's quite big. The xrs700x counters are only 16 bit. They
> need to be polled on an interval anyway or they will roll.

Yup! That's pretty common.

> > would need to get some counters from the beginning of that range, some
> > from the middle and some from the end. With all the back-and-forth
> > between the sja1105 driver and the SPI controller driver, and the
> > protocol overhead associated with creating a "SPI read" message, it is
> > all in all more efficient to just issue a burst read operation for all
> > the counters, even ones that I'm not going to use. So let's go with
> > that, 93x8 bytes (and ignore protocol overhead) = 744 bytes of SPI I/O
> > per second. At a throughput of 12.5KB/s, that takes 59 ms to complete,
> > and that's just for the raw I/O, that thing which keeps the SPI mutex
> > locked. You know what else I could do during that time? Anything else!
> > Like for example perform PTP timestamp reconstruction, which has a hard
> > deadline at 135 ms after the packet was received, and would appreciate
> > if the SPI mutex was not locked for 59 ms every second.  
> 
> Indeed, however if you need to acquire this data at all it's going to
> burden the system at that time so unless you're able to stretch out
> the reads over a length of time whether or not you're polling every
> second or once a day may not matter if you're never able to miss a
> deadline.

Exactly, either way you gotta prepare for users polling those stats.
A design where stats are read synchronously and user (an unprivileged
user, BTW) has the ability to disturb the operation of the system
sounds really flaky.

> > And all of that, for what benefit? Honestly any periodic I/O over the
> > management interface is too much I/O, unless there is any strong reason
> > to have it.  
> 
> True enough.
> 
> > Also, even the simple idea of providing out-of-date counters to user
> > space running in syscall context has me scratching my head. I can only
> > think of all the drivers in selftests that are checking statistics
> > counters before, then they send a packet, then they check the counters
> > after. What do those need to do, put a sleep to make sure the counters
> > were updated?  

Frankly life sounds simpler on the embedded networking planet than it is
on the one I'm living on ;) High speed systems are often eventually
consistent. Either because stats are gathered from HW periodically by
the FW, or RCU grace period has to expire, or workqueue has to run,
etc. etc. I know it's annoying for writing tests but it's manageable. 

If there is a better alternative I'm all ears but having /proc and
ifconfig return zeros for error counts while ip link doesn't will lead
to too much confusion IMO. While delayed update of stats is a fact of
life for _years_ now (hence it was backed into the ethtool -C API).
