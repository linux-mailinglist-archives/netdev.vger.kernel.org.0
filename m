Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8342874BF
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgJHNCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:02:42 -0400
Received: from mx.hs-offenburg.de ([141.79.11.25]:53158 "EHLO
        mx.hs-offenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbgJHNCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:02:41 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2020 09:02:39 EDT
Received: from localhost (localhost [127.0.0.1])
        by mx.hs-offenburg.de (Postfix) with ESMTP id 524E6732FA01;
        Thu,  8 Oct 2020 14:56:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hs-offenburg.de;
         h=content-transfer-encoding:mime-version:user-agent
        :content-type:content-type:references:in-reply-to:date:date:from
        :from:subject:subject:message-id:received:received; s=default;
         t=1602161769; x=1603025770; bh=XkqmOKW+XIirgzCXLOBYOliZX8Nwgd/g
        wIDmBWDe3XA=; b=ZrZR7p01oX3psUP4NrE7syIPjfyC+CBJ8gcUKCpLpCnFN4uN
        kNiUU0efGm+1/ARjtltGzkvD1FktcgnsnFzrSvaKcPIKQh5GNUbofxNljZYGd3ya
        MGRHck4z31M0r5O16LPS3wO12zbYcoNsSc+iByFeq8PVW4cATUAdHi6Doac=
X-Virus-Scanned: amavisd-new at hs-offenburg.de
Received: from mx.hs-offenburg.de ([127.0.0.1])
        by localhost (mx.hs-offenburg.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XdD_Bk_1I2uT; Thu,  8 Oct 2020 14:56:09 +0200 (CEST)
Received: from h25-119.emi.hs-offenburg.de (unknown [141.79.25.119])
        by mx.hs-offenburg.de (Postfix) with ESMTPSA id 5FDE0732F9FE;
        Thu,  8 Oct 2020 14:56:09 +0200 (CEST)
Message-ID: <f040ba36070dd1e07b05cc63a392d8267ce4efe2.camel@hs-offenburg.de>
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
From:   Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        ilias.apalodimas@linaro.org
Date:   Thu, 08 Oct 2020 14:55:57 +0200
In-Reply-To: <87lfghhw9u.fsf@kurt>
References: <20201004143000.blb3uxq3kwr6zp3z@skbuf> <87imbn98dd.fsf@kurt>
         <20201006072847.pjygwwtgq72ghsiq@skbuf> <87tuv77a83.fsf@kurt>
         <20201006133222.74w3r2jwwhq5uop5@skbuf> <87r1qb790w.fsf@kurt>
         <20201006140102.6q7ep2w62jnilb22@skbuf> <87lfgiqpze.fsf@kurt>
         <20201007105458.gdbrwyzfjfaygjke@skbuf> <87362pjev0.fsf@kurt>
         <20201008094440.oede2fucgpgcfx6a@skbuf> <87lfghhw9u.fsf@kurt>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello dears,

On Thu, 2020-10-08 at 12:01 +0200, Kurt Kanzenbach wrote:
> On Thu Oct 08 2020, Vladimir Oltean wrote:
> > On Thu, Oct 08, 2020 at 10:34:11AM +0200, Kurt Kanzenbach wrote:
> > > On Wed Oct 07 2020, Vladimir Oltean wrote:
> > > > On Wed, Oct 07, 2020 at 12:39:49PM +0200, Kurt Kanzenbach
> > > > wrote:
> > > > > For instance the hellcreek switch has actually three ptp
> > > > > hardware
> > > > > clocks and the time stamping can be configured to use either
> > > > > one of
> > > > > them.
> > > > 
> > > > The sja1105 also has a corrected and an uncorrected PTP clock
> > > > that can
> > > > take timestamps. Initially I had thought I'd be going to spend
> > > > some time
> > > > figuring out multi-PHC support, but now I don't see any
> > > > practical reason
> > > > to use the uncorrected PHC for anything.
> > > 
> > > Just out of curiosity: How do you implement 802.1AS then? My
> > > understanding is that the free-running clock has to be used for
> > > the
> > 
> > Has to be? I couldn't find that wording in IEEE 802.1AS-2011.
> 
> It doesn't has to be, it *should* be. That's at least the outcome we
> had
> after lots of discussions. Actually Kamil (on Cc) is the expert on
> this
> topic.

According to 802.1AS-2011 (10.1.1): "The LocalClock entity is a free-
running clock (see 3.3) that provides a common time to the time-aware
system, relative to an arbitrary epoch.", "... All timestamps are taken
relative to the LocalClock entity". The same statement holds true for
802.1AS-2020 (10.1.2.1).

> > > calculation of the peer delays and such meaning there should be a
> > > way to
> > > get access to both PHCs or having some form of cross timestamping
> > > available.
> > > 
> > > The hellcreek switch can take cross snapshots of all three ptp
> > > clocks in
> > > hardware for that purpose.
> > 
> > Well, at the end of the day, all the other TSN offloads (tc-taprio,
> > tc-gate) will still have to use the synchronized PTP clock, so what
> > we're doing is we're simply letting that clock be synchronized by
> > ptp4l.
> 
> Yes, the synchronized clock is of course needed for the traffic
> scheduling and so on. This is what we do here in this code as well.
> Only
> the synchronized one is exported to user space and used. However, the
> multi PHCs issue should be addressed as well at some point.
> 
> > > > > > So when you'll poll for TX timestamps, you'll receive a TX
> > > > > > timestamp from the PHY and another one from the switch, and
> > > > > > those will
> > > > > > be in a race with one another, so you won't know which one
> > > > > > is which.
> > > > > 
> > > > > OK. So what happens if the driver will accept to disable
> > > > > hardware
> > > > > timestamping? Is there anything else that needs to be
> > > > > implemented? Are
> > > > > there (good) examples?
> > > > 
> > > > It needs to not call skb_complete_tx_timestamp() and friends.
> > > > 
> > > > For PHY timestamping, it also needs to invoke the correct
> > > > methods for RX
> > > > and for TX, where the PHY timestamping hooks will get called. I
> > > > don't
> > > > think that DSA is compatible yet with PHY timestamping, but it
> > > > is
> > > > probably a trivial modification.
> > > 
> > > Hmm? If DSA doesn't support PHY timestamping how are other DSA
> > > drivers
> > > dealing with it then? I'm getting really confused.
> > 
> > They aren't dealing with it, of course.
> > 
> > > Furthermore, there is no hellcreek hardware available with
> > > timestamping
> > > capable PHYs. How am I supposed to even test this?
> > > 
> > > For now, until there is hardware available, PHY timestamping is
> > > not
> > > supported with the hellcreek switch.
> > 
> > I was just pointing out that this is something you'll certainly
> > have to
> > change if somebody will want PHY timestamping.
> 
> Understood.
> 
> > Even without hardware, you _could_ probably test that DSA is doing
> > the
> > right thing by simply adding the PTP timestamping ops to a PHY
> > driver
> > that you own, and inject dummy timestamps. The expectation becomes
> > that
> > user space gets those dummy timestamps, and not the ones emitted by
> > your
> > switch.
> 
> Of course it can be mocked. Whenever somebody wants to do PHY
> timestamping with a hellcreek switch this issue can be re-visited.
> 
> Thanks,
> Kurt

