Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61BE2C6DD4
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgK0X6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732323AbgK0X52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 18:57:28 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD888206F7;
        Fri, 27 Nov 2020 23:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606521411;
        bh=htc9SiVNZvgczcZrCZmO0UEdRumUqH3mZSvgIHXzF7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eYCDQvwPXRKWK9Q/umi6b6RRvrs4A3Tgu3BE4FU+bwDcXLMyHmrjp4Hax4JFvXr91
         vMTgYW/MOP3OeB3x2ckT1jH4y6Ip/ASivx6tigu830ISVudgj7dsIIUJ1mz+lbgi0r
         x7kNrEsgp4Khjis1rua1/2ZMqumyEdErtnNZcaiY=
Date:   Fri, 27 Nov 2020 15:56:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127155649.5ce7ed82@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127233916.bmhvcep6sjs5so2e@skbuf>
References: <20201126132418.zigx6c2iuc4kmlvy@skbuf>
        <20201126175607.bqmpwbdqbsahtjn2@skbuf>
        <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
        <20201126220500.av3clcxbbvogvde5@skbuf>
        <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
        <20201127195057.ac56bimc6z3kpygs@skbuf>
        <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
        <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201127233048.GB2073444@lunn.ch>
        <20201127233916.bmhvcep6sjs5so2e@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What is it with my email today, didn't get this one again.

On Sat, 28 Nov 2020 01:39:16 +0200 Vladimir Oltean wrote:
> On Sat, Nov 28, 2020 at 12:30:48AM +0100, Andrew Lunn wrote:
> > > If there is a better alternative I'm all ears but having /proc and
> > > ifconfig return zeros for error counts while ip link doesn't will lead
> > > to too much confusion IMO. While delayed update of stats is a fact of
> > > life for _years_ now (hence it was backed into the ethtool -C API).  
> > 
> > How about dev_seq_start() issues a netdev notifier chain event, asking
> > devices which care to update their cached rtnl_link_stats64 counters.
> > They can decide if their cache is too old, and do a blocking read for
> > new values.

Just to avoid breaking the suggestion that seqfiles don't sleep after
.start? Hm. I thought BPF slept (or did cond_reshed()) in the middle of
seq iteration. We should double check that seqfiles really can't sleep.

> > Once the notifier has completed, dev_seq_start() can then
> > rcu_read_lock() and do the actual collection of stats from the drivers
> > non-blocking.  
