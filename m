Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2302C6DEA
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 01:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbgK1AU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 19:20:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731627AbgK0XcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 18:32:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kinCS-009BxG-UE; Sat, 28 Nov 2020 00:30:48 +0100
Date:   Sat, 28 Nov 2020 00:30:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127233048.GB2073444@lunn.ch>
References: <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
 <20201127195057.ac56bimc6z3kpygs@skbuf>
 <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If there is a better alternative I'm all ears but having /proc and
> ifconfig return zeros for error counts while ip link doesn't will lead
> to too much confusion IMO. While delayed update of stats is a fact of
> life for _years_ now (hence it was backed into the ethtool -C API).

How about dev_seq_start() issues a netdev notifier chain event, asking
devices which care to update their cached rtnl_link_stats64 counters.
They can decide if their cache is too old, and do a blocking read for
new values.

Once the notifier has completed, dev_seq_start() can then
rcu_read_lock() and do the actual collection of stats from the drivers
non-blocking.

	Andrew
