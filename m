Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD3C1B9826
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 09:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgD0HN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 03:13:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:45768 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgD0HN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 03:13:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26EC3ABB2;
        Mon, 27 Apr 2020 07:13:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 15DD4602B9; Mon, 27 Apr 2020 09:13:24 +0200 (CEST)
Date:   Mon, 27 Apr 2020 09:13:24 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next v1 4/9] net: ethtool: Add attributes for cable
 test reports
Message-ID: <20200427071324.GA9038@lion.mk-sys.cz>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-5-andrew@lunn.ch>
 <20200426202543.GD23225@lion.mk-sys.cz>
 <20200426211242.GC1183480@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426211242.GC1183480@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 11:12:42PM +0200, Andrew Lunn wrote:
> > > +
> > > + +-------------------------------------------+--------+-----------------------+
> > > + | ``ETHTOOL_A_CABLE_TEST_HEADER``           | nested | reply header          |
> > > + +-------------------------------------------+--------+-----------------------+
> > > + | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test result     |
> > > + +-+-----------------------------------------+--------+-----------------------+
> > > + | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number           |
> > > + +-+-----------------------------------------+--------+-----------------------+
> > > + | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code           |
> > > + +-+-----------------------------------------+--------+-----------------------+
> > > + | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test results    |
> > > + +-+-----------------------------------------+--------+-----------------------+
> > > + | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number           |
> > > + +-+-----------------------------------------+--------+-----------------------+
> > > + | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code           |
> > > + +-+-----------------------------------------+--------+-----------------------+
> > > + | ``ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH`` | nested | cable length          |
> > > + +-+-----------------------------------------+--------+-----------------------+
> > > + | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR``   | u8     | pair number           |
> > > + +-+-----------------------------------------+--------+-----------------------+
> > > + | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_CM``     | u8     | length in cm          |
> > > + +-+-----------------------------------------+--------+-----------------------+
> > 
> > Would it be complicated to gather all information for each pair
> > together? I.e. to have one nest for each pair with pair number, result
> > code and possibly other information (if available). I believe it would
> > make the message easier to process.
> 
> It is something i considered, but decided against. Attributes give us
> flexibility to report whatever the PHY gives us. There is no
> standardisation here. Some PHYs will report the first fault on a
> pair. Others will report multiple faults on a pair. Some PHYs can tell
> you pair X is shorted to pair Y, etc, while some PHYs just tell you it
> is shorted. It also keeps the driver code simple. Report whatever you
> have in any order and it does not matter. And it means i don't need
> complex helper code trying to coordinating information from the
> driver.
> 
> So far, a plain dump of the netlink message in user space also seems
> readable. But when we have more PHYs supported and more variability
> between PHYs we might need to consider if user space should do some
> sorting before printing the test results.

OK, if it would make driver code more complicated, let's keep it like
this. But it's still a bit unclear what exactly does the structure look
like as the example does not seem to match the enums below; I'll have to
take a look at the code composing the messages.

> > > +enum {
> > > +	ETHTOOL_A_CABLE_PAIR_0,
> > > +	ETHTOOL_A_CABLE_PAIR_1,
> > > +	ETHTOOL_A_CABLE_PAIR_2,
> > > +	ETHTOOL_A_CABLE_PAIR_3,
> > > +};
> > 
> > Do we really need this enum, couldn't we simply use a number (possibly
> > with a sanity check of maximum value)?
> 
> They are not strictly required. But it helps with consistence. Are the
> pairs numbered 0, 1, 2, 3, or 1, 2, 3, 4?

OK, I'm not strictly opposed to it, it just felt a bit weird.

> > > +enum {
> > > +	ETHTOOL_A_CABLE_RESULT_UNSPEC,
> > > +	ETHTOOL_A_CABLE_RESULT_PAIR,		/* u8 ETHTOOL_A_CABLE_PAIR_ */
> > > +	ETHTOOL_A_CABLE_RESULT_CODE,		/* u8 ETHTOOL_A_CABLE_RESULT_CODE_ */
> > > +
> > > +	__ETHTOOL_A_CABLE_RESULT_CNT,
> > > +	ETHTOOL_A_CABLE_RESULT_MAX = (__ETHTOOL_A_CABLE_RESULT_CNT - 1)
> > > +};
> > > +
> > > +enum {
> > > +	ETHTOOL_A_CABLE_FAULT_LENGTH_UNSPEC,
> > > +	ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR,	/* u8 ETHTOOL_A_CABLE_PAIR_ */
> > > +	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u16 */
> > 
> > The example above says "u8" (which is obviously wrong).
> 
> Yep, will fix that.
> 
> > I would rather suggest u32 here to be as future proof as possible.
> 
> Yes, i've been going backwards and forwards on that. I did not realize
> netlink messages were space inefficient. A u8 takes as much space as a
> u32. I picked u16 because that allows up 65535cm, or 655.35m. All the
> IEEE 802.3 Base-T standards have a maximum cable length of 100m, or
> shorter. They might work with longer cables, but i doubt a cable 6
> times longer than the specified max will work. So a u16 is ample.
> 
> The only argument i can see for a u32 is if somebody can implement
> cable testing for fibre optical cables. Then a u16 is not big enough.
> But so far, i've never seen an SFP module offering this.

The problem is that this is UAPI which is "cast in stone". Thus we
should ask "Can I imagine someone implementing this in next 10-20
years?" rather than "Is there a real life hardware implementing this?".
Switching from u16 to u32 in internal kernel API may be a headache if
there are many drivers using it but switching from u16 to u32 in UAPI is
out of question so that we would have to resort to a workaround like
adding another attribute for "long fault length".

Michal

> 
> > One more idea: it would be IMHO useful to also send a notification when
> > the test is started. It could be distinguished by a status attribute
> > which would describe status of the test as a whole (not a specific
> > pair), e.g. started, finished, aborted.
>  
> Yes, give how long these tests take, i could be useful. There is also
> already some hints about this, in that the last patch in the series
> changes the RFC 2863 status of the interface, which i hope sends a
> message to user space about the interface change of status.
> 
> 	Andrew
