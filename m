Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3881B9425
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 23:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgDZVMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 17:12:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgDZVMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 17:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=c8oyHREiWzXOy+tmrIvhtJK4L/myR/O3aucK4HMS5vY=; b=JrU8q8LEgYB2jZ0yqIvwQx0YTP
        ci4agzYABFRKITXFrxbohdBngiESNLkjBSDA3oImfV8ui2BQY5xp05/cqWl4NGCqehAQr+LMwsU/b
        oY7anMcVFpFLxxySn4Iyh7mPZu9Bcc2PX0rKS4YTK00Rukjk4Ktjy5JSErpAavHxddeU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSoZu-0051Et-PA; Sun, 26 Apr 2020 23:12:42 +0200
Date:   Sun, 26 Apr 2020 23:12:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next v1 4/9] net: ethtool: Add attributes for cable
 test reports
Message-ID: <20200426211242.GC1183480@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-5-andrew@lunn.ch>
 <20200426202543.GD23225@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426202543.GD23225@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +
> > + +-------------------------------------------+--------+-----------------------+
> > + | ``ETHTOOL_A_CABLE_TEST_HEADER``           | nested | reply header          |
> > + +-------------------------------------------+--------+-----------------------+
> > + | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test result     |
> > + +-+-----------------------------------------+--------+-----------------------+
> > + | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number           |
> > + +-+-----------------------------------------+--------+-----------------------+
> > + | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code           |
> > + +-+-----------------------------------------+--------+-----------------------+
> > + | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test results    |
> > + +-+-----------------------------------------+--------+-----------------------+
> > + | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number           |
> > + +-+-----------------------------------------+--------+-----------------------+
> > + | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code           |
> > + +-+-----------------------------------------+--------+-----------------------+
> > + | ``ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH`` | nested | cable length          |
> > + +-+-----------------------------------------+--------+-----------------------+
> > + | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR``   | u8     | pair number           |
> > + +-+-----------------------------------------+--------+-----------------------+
> > + | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_CM``     | u8     | length in cm          |
> > + +-+-----------------------------------------+--------+-----------------------+
> 
> Would it be complicated to gather all information for each pair
> together? I.e. to have one nest for each pair with pair number, result
> code and possibly other information (if available). I believe it would
> make the message easier to process.

It is something i considered, but decided against. Attributes give us
flexibility to report whatever the PHY gives us. There is no
standardisation here. Some PHYs will report the first fault on a
pair. Others will report multiple faults on a pair. Some PHYs can tell
you pair X is shorted to pair Y, etc, while some PHYs just tell you it
is shorted. It also keeps the driver code simple. Report whatever you
have in any order and it does not matter. And it means i don't need
complex helper code trying to coordinating information from the
driver.

So far, a plain dump of the netlink message in user space also seems
readable. But when we have more PHYs supported and more variability
between PHYs we might need to consider if user space should do some
sorting before printing the test results.

> > +enum {
> > +	ETHTOOL_A_CABLE_PAIR_0,
> > +	ETHTOOL_A_CABLE_PAIR_1,
> > +	ETHTOOL_A_CABLE_PAIR_2,
> > +	ETHTOOL_A_CABLE_PAIR_3,
> > +};
> 
> Do we really need this enum, couldn't we simply use a number (possibly
> with a sanity check of maximum value)?

They are not strictly required. But it helps with consistence. Are the
pairs numbered 0, 1, 2, 3, or 1, 2, 3, 4?

> > +enum {
> > +	ETHTOOL_A_CABLE_RESULT_UNSPEC,
> > +	ETHTOOL_A_CABLE_RESULT_PAIR,		/* u8 ETHTOOL_A_CABLE_PAIR_ */
> > +	ETHTOOL_A_CABLE_RESULT_CODE,		/* u8 ETHTOOL_A_CABLE_RESULT_CODE_ */
> > +
> > +	__ETHTOOL_A_CABLE_RESULT_CNT,
> > +	ETHTOOL_A_CABLE_RESULT_MAX = (__ETHTOOL_A_CABLE_RESULT_CNT - 1)
> > +};
> > +
> > +enum {
> > +	ETHTOOL_A_CABLE_FAULT_LENGTH_UNSPEC,
> > +	ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR,	/* u8 ETHTOOL_A_CABLE_PAIR_ */
> > +	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u16 */
> 
> The example above says "u8" (which is obviously wrong).

Yep, will fix that.

> I would rather suggest u32 here to be as future proof as possible.

Yes, i've been going backwards and forwards on that. I did not realize
netlink messages were space inefficient. A u8 takes as much space as a
u32. I picked u16 because that allows up 65535cm, or 655.35m. All the
IEEE 802.3 Base-T standards have a maximum cable length of 100m, or
shorter. They might work with longer cables, but i doubt a cable 6
times longer than the specified max will work. So a u16 is ample.

The only argument i can see for a u32 is if somebody can implement
cable testing for fibre optical cables. Then a u16 is not big enough.
But so far, i've never seen an SFP module offering this.

> One more idea: it would be IMHO useful to also send a notification when
> the test is started. It could be distinguished by a status attribute
> which would describe status of the test as a whole (not a specific
> pair), e.g. started, finished, aborted.
 
Yes, give how long these tests take, i could be useful. There is also
already some hints about this, in that the last patch in the series
changes the RFC 2863 status of the interface, which i hope sends a
message to user space about the interface change of status.

	Andrew
