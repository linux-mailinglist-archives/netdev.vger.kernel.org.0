Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D416221505D
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgGEX07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:26:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:56308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgGEX06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 19:26:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 66D76AE47;
        Sun,  5 Jul 2020 23:26:57 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id DD9F2602E3; Mon,  6 Jul 2020 01:26:56 +0200 (CEST)
Date:   Mon, 6 Jul 2020 01:26:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v4 0/6] ethtool(1) cable test support
Message-ID: <20200705232656.ztf465cffu3hn7g4@lion.mk-sys.cz>
References: <20200701010743.730606-1-andrew@lunn.ch>
 <20200705004447.ook7vkzffa5ejb2v@lion.mk-sys.cz>
 <20200705162421.GA884423@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705162421.GA884423@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 06:24:21PM +0200, Andrew Lunn wrote:
> On Sun, Jul 05, 2020 at 02:44:47AM +0200, Michal Kubecek wrote:
> > On Wed, Jul 01, 2020 at 03:07:37AM +0200, Andrew Lunn wrote:
> > > Add the user space side of the ethtool cable test.
> > > 
> > > The TDR output is most useful when fed to some other tool which can
> > > visualize the data. So add JSON support, by borrowing code from
> > > iproute2.
> > > 
> > > v2:
> > > man page fixes.
> > > 
> > > v3:
> > > More man page fixes.
> > > Use json_print from iproute2.
> > > 
> > > v4:
> > > checkpatch cleanup
> > > ethtool --cable-test dev
> > > Place breakout into cable_test_context
> > > Remove Pair: Pair output
> > 
> > Hello Andrew,
> > 
> > could you please test this update of netlink/desc-ethtool.c on top of
> > your series? The userspace messages look as expected but I'm not sure if
> > I have a device with cable test support available to test pretty
> > printing of kernel messages. (And even if I do, I almost certainly won't
> > have physical access to it.)
> 
> Hi Michal
> 
> Currently there are three PHY drivers with support: Marvell, Atheros
> at803x, and bcm54140. And you can do some amount of testing without
> physical access, you can expect the test results to indicate the cable
> is O.K.
> 
> However, i will give these a go.
> 
> Some sort of capture and reply would be interesting for this, and for
> regression testing. The ability to do something like
> 
> ethtool --monitor -w test.cap
> 
> To dump the netlink socket data to a file,  and
> 
> ethtool --monitor -r test.cap
> 
> to read from the file and decode its contents. Maybe this is already
> possible via nlmon?

Such feature would definitely be useful. It should be possible to
capture the data using nlmon and tcpdump but whenever I tried to use
nlmon to capture netlink data, I found it rather difficult to capture
only the traffic I was interested in. For the second part (feeding the
captured data to ethtool), we would probably need some tool which would
work like tcpreplay. Having support in ethtool makes very good sense and
it shouldn't require too much extra code, perhaps a dependency on
libpcap.

In the long term, I would like to write a packetdrill-like framework for
selftests where testcases would be scripts consisting of statements
saying e.g. "run with this command line", "expect this netlink message",
"reply with this netlink message", "expect this output" etc. But that
would be more complex and ability to capture into a file and replay it
would b useful independently of that.

Michal
