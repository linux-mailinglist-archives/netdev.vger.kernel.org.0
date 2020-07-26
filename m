Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3276622E2BE
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 23:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGZV34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 17:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgGZV34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 17:29:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4260AC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 14:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=98GLoylnnYE0IYHJBT/PDM4S5Dh2PDH0ju8/7RfC8gw=; b=EwyOzluBFHdLXbaxx7ZyUiHpd
        9cgF1MvPzfs59xoTJgXXaqs87SyHW+bv8bvGGVGCyDvEv8KdtyrfdwueWkwm7anhwBhKtokgSN28F
        fS44f4ksvCNft+b5Sib5jfm+dRQIMOCJYIGGi/SmM5b+umIZ+ol5AMh2pm5zu6Rm6JZwhfGyZytWH
        fCYMN9P0o4mUkG8cLgQsN/q0W38hJ8aUu9O5WpbD6fl1/+GMKRAOICVtKCz1cjT2VboKN60aeeinm
        hLFQiwP4CGGEcWtk975bAZs7m/YGZL8bZan5fGfqJbEAzN89ubodyjtYEB3xkJOdbmbNPt41xCr/0
        fd0pWjIxg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44530)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jzoDR-00020W-NI; Sun, 26 Jul 2020 22:29:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jzoDR-0002yr-5R; Sun, 26 Jul 2020 22:29:53 +0100
Date:   Sun, 26 Jul 2020 22:29:53 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: phc2sys - does it work?
Message-ID: <20200726212952.GF1551@shell.armlinux.org.uk>
References: <20200725124927.GE1551@shell.armlinux.org.uk>
 <20200725132916.7ibhnre2be3hfsrt@skbuf>
 <20200726110104.GV1605@shell.armlinux.org.uk>
 <20200726180551.GA31684@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726180551.GA31684@hoboy>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 11:05:51AM -0700, Richard Cochran wrote:
> On Sun, Jul 26, 2020 at 12:01:05PM +0100, Russell King - ARM Linux admin wrote:
> > Another solution would be to avoid running NTP on any machine intending
> > to be the source of PTP time on a network, but that then brings up the
> > problem that you can't synchronise the PTP time source to a reference
> > time, which rather makes PTP pointless unless all that you're after is
> > "all my local machines say the same wrong time."
> 
> It is clear that you can't have two services both adjusting the system
> time.  For example, running ntpd and chrony on the same machine won't
> work, and neither does running ntpd with 'phc2sys -a -r'.

You've misunderstood, that is not what I'm doing.  The system time on
the machine is sync'd using ntpd, and then I'm syncing the PTP clock
to alone to the system time.  Right now, I'm just testing the PTP
clock implementation, nothing else, to make sure that it is implemented
properly.

So, the setup is:

     +----------+       +--------------------------+
     |  host 1  |       |         test host        |           freq
GPS ---> ntpd ---- lan ---> ntpd -> system -> TAI ---> PPS -> counter
     |          |       |            time          |
     +----------+       +--------------------------+

The good news is - the whole thing has mostly settled - I no longer
see large swings in the PPS signal produced by the PTP/TAI clock,
where large is 10s of PPM.  I'm now down to a frequency error of
around 500PPB.

I think what was going on is ntpd on the test host was switching
between different time sources, causing it to almost constantly slew
the system time on the test host.

I have noticed that phc2sys can sometimes get confused and it needs
phc_ctl to reset the frequency back to zero for it to have another go.
The hardware is capable of a max_adj of S32_MAX, and I think that
allows phc2sys to get confused sometimes, so I probably need to clamp
my calculated max_adj to a sane limit.  Is there an upper limit that
phc2sys expects?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
