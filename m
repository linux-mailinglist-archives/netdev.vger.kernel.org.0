Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3B327898E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgIYN3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:29:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55158 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgIYN3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 09:29:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLnmZ-00G9vu-4n; Fri, 25 Sep 2020 15:29:03 +0200
Date:   Fri, 25 Sep 2020 15:29:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Kai-Heng Feng' <kai.heng.feng@canonical.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] e1000e: Increase iteration on polling MDIC ready bit
Message-ID: <20200925132903.GB3850848@lunn.ch>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <20200924150958.18016-1-kai.heng.feng@canonical.com>
 <20200924155355.GC3821492@lunn.ch>
 <8A08B3A7-8368-48EC-A2DD-B5D5F3EA94C5@canonical.com>
 <2f48175dce974ea689bfd26b9fc2245a@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f48175dce974ea689bfd26b9fc2245a@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 08:50:30AM +0000, David Laight wrote:
> From: Kai-Heng Feng
> > Sent: 24 September 2020 17:04
> ...
> > > I also don't fully understand the fix. You are now looping up to 6400
> > > times, each with a delay of 50uS. So that is around 12800 times more
> > > than it actually needs to transfer the 64 bits! I've no idea how this
> > > hardware works, but my guess would be, something is wrong with the
> > > clock setup?
> > 
> > It's probably caused by Intel ME. This is not something new, you can find many polling codes in e1000e
> > driver are for ME, especially after S3 resume.
> > 
> > Unless Intel is willing to open up ME, being patient and wait for a longer while is the best approach
> > we got.
> 
> There is some really broken code in the e1000e driver that affect my
> Ivy bridge platform were it is trying to avoid hardware bugs in
> the ME interface.
> 
> It seems that before EVERY write to a MAC register it must check
> that the ME isn't using the interface - and spin until it isn't.
> This causes massive delays in the TX path because it includes
> the write that tells the MAC engine about a new packet.

Hi David

Thanks for the information. This however does not really explain the
issue.

The code busy loops waiting for the MDIO transaction to complete. If
read/writes to the MAC are getting blocked, that just means less
iterations of the loop are needed, not more, since the time to
complete the transaction should be fixed.

If ME really is to blame, it means ME is completely hijacking the
hardware? Stopping the clocks? Maybe doing its own MDIO transactions?
How can you write a PHY driver if something else is also programming
the PHY.

We don't understand what is going on here. We are just papering over
the cracks. The commit message should say this, that the change fixes
the symptoms but probably not the cause.

    Andrew
