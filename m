Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EB495FF8
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbfHTN0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:26:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44942 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729677AbfHTN0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 09:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h++X8Sth9mQxKjJr4msQfFTkzZqJoYeqgKDOLKi4PHQ=; b=TD9KGIuS77AHk/ebjtCYZkfDN6
        VwK6EwrsocReUeCUIjsffu1Rwq+fc2MF9WCgR3ya/prSYzjmpyoOfnh6WjDMEWchPbx6cTXGHHwrW
        eOrL0OmgzLq/BcQaas7NXS3uxhnDStLkRjULYdUzTJH6EpbCaCZpZ9VhTGDvXHN3eUPI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i049C-0005SE-1D; Tue, 20 Aug 2019 15:26:02 +0200
Date:   Tue, 20 Aug 2019 15:26:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation
 to mdiobus_write_sts
Message-ID: <20190820132602.GI29991@lunn.ch>
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
 <20190820084833.6019-3-hubert.feurstein@vahle.at>
 <20190820094903.GI891@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820094903.GI891@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 11:49:03AM +0200, Miroslav Lichvar wrote:
> On Tue, Aug 20, 2019 at 10:48:31AM +0200, Hubert Feurstein wrote:
> 
> > +	/* PTP offset compensation:
> > +	 * After the MDIO access is completed (from the chip perspective), the
> > +	 * switch chip will snapshot the PHC timestamp. To make sure our system
> > +	 * timestamp corresponds to the PHC timestamp, we have to add the
> > +	 * duration of this MDIO access to sts->post_ts. Linuxptp's phc2sys
> > +	 * takes the average of pre_ts and post_ts to calculate the final
> > +	 * system timestamp. With this in mind, we have to add ptp_sts_offset
> > +	 * twice to post_ts, in order to not introduce an constant time offset.
> > +	 */
> > +	if (sts)
> > +		timespec64_add_ns(&sts->post_ts, 2 * bus->ptp_sts_offset);
> 
> This correction looks good to me.
> 
> Is the MDIO write delay constant in reality, or does it at least have
> an upper bound? That is, is it always true that the post_ts timestamp
> does not point to a time before the PHC timestamp was actually taken?

The post_ts could be before the target hardware does anything. The
write triggers an MDIO bus transaction, sending about 64 bits of data
down a wire at around 2.5Mbps. So there is a minimum delay of 25uS
just sending the bits down the wire. It is unclear to me exactly when
the post_ts is taken, has the hardware actually sent the bits, or has
it just initiated sending the bits? In this case, there is an
interrupt sometime later indicating the transaction has completed, so
my guess would be, post_ts indicates the transaction has been
initiated.

Also, how long does the device on the end of the bus actually take to
decode the bits on the wire and do what it needs to do?

> This is important to not break the estimation of maximum error in the
> measured offset. Applications using the ioctl may assume that the
> maximum error is (post_ts-pre_ts)/2 (i.e. half of the delay printed by
> phc2sys). That would not work if the delay could be occasionally 50
> microseconds for instance, i.e. the post_ts timestamp would be earlier
> than the PHC timestamp.

Given my understanding of the hardware, post_ts-pre_ts should be
constant. But what it exactly measures is not clearly defined :-(

And different hardware will have different definitions.

But the real point is, by doing these timestamps here, we are as close
as possible to where the action really happens, and we are minimising
the number of undefined things we are measuring, so in general, the
error is minimised.

    Andrew
