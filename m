Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3558828B50E
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 14:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgJLMyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 08:54:06 -0400
Received: from mx.hs-offenburg.de ([141.79.11.25]:55354 "EHLO
        mx.hs-offenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729944AbgJLMyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 08:54:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.hs-offenburg.de (Postfix) with ESMTP id B85E5738A76C;
        Mon, 12 Oct 2020 14:53:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hs-offenburg.de;
         h=content-transfer-encoding:mime-version:user-agent
        :content-type:content-type:references:in-reply-to:date:date:from
        :from:subject:subject:message-id:received:received; s=default;
         t=1602507239; x=1603371240; bh=+6xZrct3+4JklvRrqYipfRYXbWVljLAh
        37emHJZd5HI=; b=WNYSWiqOobb0/AfbdBIGLcjMebl8XkYjET/kT1tsLj/c+Uhj
        cPkdjJTCipXJJjpTaKWFTKaNo3t6Ob34lHBQ68oBzHohAFIDbRMJ20Af9CyccOIC
        R/YIxDMeAZvqE2fZ6oy0OVsTIiNEEo4ppP9jeJ0L/oZitCI9fGYPiYYO+rw=
X-Virus-Scanned: amavisd-new at hs-offenburg.de
Received: from mx.hs-offenburg.de ([127.0.0.1])
        by localhost (mx.hs-offenburg.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id S0D1H2hs5a8l; Mon, 12 Oct 2020 14:53:59 +0200 (CEST)
Received: from h25-119.emi.hs-offenburg.de (unknown [141.79.25.119])
        by mx.hs-offenburg.de (Postfix) with ESMTPSA id DDAFB738A769;
        Mon, 12 Oct 2020 14:53:58 +0200 (CEST)
Message-ID: <65ecb62de9940991971b965cbd5b902ae5daa09b.camel@hs-offenburg.de>
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
From:   Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        ilias.apalodimas@linaro.org
Date:   Mon, 12 Oct 2020 14:53:58 +0200
In-Reply-To: <20201008150951.elxob2yaw2tirkig@skbuf>
References: <87tuv77a83.fsf@kurt> <20201006133222.74w3r2jwwhq5uop5@skbuf>
         <87r1qb790w.fsf@kurt> <20201006140102.6q7ep2w62jnilb22@skbuf>
         <87lfgiqpze.fsf@kurt> <20201007105458.gdbrwyzfjfaygjke@skbuf>
         <87362pjev0.fsf@kurt> <20201008094440.oede2fucgpgcfx6a@skbuf>
         <87lfghhw9u.fsf@kurt>
         <f040ba36070dd1e07b05cc63a392d8267ce4efe2.camel@hs-offenburg.de>
         <20201008150951.elxob2yaw2tirkig@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, 2020-10-08 at 18:09 +0300, Vladimir Oltean wrote:
> Hi Kamil,
> 
> On Thu, Oct 08, 2020 at 02:55:57PM +0200, Kamil Alkhouri wrote:
> > Hello dears,
> > 
> > On Thu, 2020-10-08 at 12:01 +0200, Kurt Kanzenbach wrote:
> > > On Thu Oct 08 2020, Vladimir Oltean wrote:
> > > > On Thu, Oct 08, 2020 at 10:34:11AM +0200, Kurt Kanzenbach
> > > > wrote:
> > > > > On Wed Oct 07 2020, Vladimir Oltean wrote:
> > > > > > On Wed, Oct 07, 2020 at 12:39:49PM +0200, Kurt Kanzenbach
> > > > > > wrote:
> > > > > > > For instance the hellcreek switch has actually three ptp
> > > > > > > hardware
> > > > > > > clocks and the time stamping can be configured to use
> > > > > > > either
> > > > > > > one of
> > > > > > > them.
> > > > > > 
> > > > > > The sja1105 also has a corrected and an uncorrected PTP
> > > > > > clock
> > > > > > that can
> > > > > > take timestamps. Initially I had thought I'd be going to
> > > > > > spend
> > > > > > some time
> > > > > > figuring out multi-PHC support, but now I don't see any
> > > > > > practical reason
> > > > > > to use the uncorrected PHC for anything.
> > > > > 
> > > > > Just out of curiosity: How do you implement 802.1AS then? My
> > > > > understanding is that the free-running clock has to be used
> > > > > for
> > > > > the
> > > > 
> > > > Has to be? I couldn't find that wording in IEEE 802.1AS-2011.
> > > 
> > > It doesn't has to be, it *should* be. That's at least the outcome
> > > we
> > > had
> > > after lots of discussions. Actually Kamil (on Cc) is the expert
> > > on
> > > this
> > > topic.
> > 
> > According to 802.1AS-2011 (10.1.1): "The LocalClock entity is a
> > free-
> > running clock (see 3.3) that provides a common time to the time-
> > aware
> > system, relative to an arbitrary epoch.", "... All timestamps are
> > taken
> > relative to the LocalClock entity". The same statement holds true
> > for
> > 802.1AS-2020 (10.1.2.1).
> 
> Nice having you part of the discussion.
> 
> IEEE 802.1AS-rev draft 8.0, clause F.3 PTP options:
> 
> 	The physical adjustment of the frequency of the LocalClock
> 	entity (i.e., physical syntonization) is allowed but not
> 	required.

what about phase adjustment?
I believe logical syntonization is a main part of 802.1AS-Rev and it is
actually mandatory (7.5.g). Even though physical syntonization is
allowed, the standard clearly states that it is slow and prone to gain
peaking effects (7.3.3). Therefore, it makes sense to use a free-
running clock to get the most benefit of AS-Rev when it comes to the
transport of synchronization information. 

> 
> In fact, even if that wasn't explicitly written, I am having a hard
> time
> understanding how the "B.1.1 Frequency accuracy" requirement for the
> LocalClock could be satisfied as long as it is kept free-running.
> Otherwise said, what should I do as a system designer if the
> LocalClock's frequency is not within +/- 100 ppm offset to the TAI
> frequency, and I'm not allowed to correct it.

B.1.1 defines the frequency accuracy of the local clock relative to TAI
and not to grandmaster. In my opinion, this is a physical requirement
of the quartz oscillator used to drive the time and it should be
fulfilled for all local clocks even for the ones in non-slave devices.

> 
> By the way, how would you see the split between an unsynchronized and
> a
> synchronized PHC be implemented in the Linux kernel?

I'm not an expert in kernel implementation but we have plans to discuss
possible approaches in the near future.

> 
> Thanks,
> -Vladimir

Thanks,
Kamil

