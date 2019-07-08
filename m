Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5257C62CA3
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfGHX2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:28:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:17417 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfGHX2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 19:28:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 16:28:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,468,1557212400"; 
   d="scan'208";a="364400669"
Received: from ellie.jf.intel.com (HELO ellie) ([10.54.70.74])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jul 2019 16:28:07 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] tc-taprio offload for SJA1105 DSA
In-Reply-To: <20190707172921.17731-1-olteanv@gmail.com>
References: <20190707172921.17731-1-olteanv@gmail.com>
Date:   Mon, 08 Jul 2019 16:28:07 -0700
Message-ID: <87ftng3y48.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <olteanv@gmail.com> writes:

> Using Vinicius Costa Gomes' configuration interface for 802.1Qbv (later
> resent by Voon Weifeng for the stmmac driver), I am submitting for
> review a draft implementation of this offload for a DSA switch.
>
> I don't want to insist too much on the hardware specifics of SJA1105
> which isn't otherwise very compliant to the IEEE spec.
>
> In order to be able to test with Vedang Patel's iproute2 patch for
> taprio offload (https://www.spinics.net/lists/netdev/msg573072.html)
> I had to actually revert the txtime-assist branch as it had changed the
> iproute2 interface.

Now, that Vedang's work was merged, I will send a rebased version of
the taprio offload series (also taking your feedback into account, see
below).

>
> In terms of impact for DSA drivers, I would like to point out that:
>
> - Maybe somebody should pre-populate qopt->cycle_time in case the user
>   does not provide one. Otherwise each driver needs to iterate over the
>   GCL once, just to set the cycle time (right now stmmac does as
> well).

Very fair, this should be very easy to do from taprio side.

>
> - Configuring the switch over SPI cannot apparently be done from this
>   ndo_setup_tc callback because it runs in atomic context. I also have
>   some downstream patches to offload tc clsact matchall with mirred
>   action, but in that case it looks like the atomic context restriction
>   does not apply.
>
> - I had to copy the struct tc_taprio_qopt_offload to driver private
>   memory because a static config needs to be constructed every time a
>   change takes place, and there are up to 4 switch ports that may take a
>   TAS configuration. I have created a private
>   tc_taprio_qopt_offload_copy() helper for this - I don't know whether
>   it's of any help in the general case.

If everyone needs to do this, perhaps we can think of something else,
one first idea is that taprio builds this configuration and gives
ownership of it to the driver, but we would need to add _ref()/_unref()
(or similar) helpers to the qdisc/driver API.

>
> There is more to be done however. The TAS needs to be integrated with
> the PTP driver. This is because with a PTP clock source, the base time
> is written dynamically to the PTPSCHTM (PTP schedule time) register and
> must be a time in the future. Then the "real" base time of each port's
> TAS config can be offset by at most ~50 ms (the DELTA field from the
> Schedule Entry Points Table) relative to PTPSCHTM.
> Because base times in the past are completely ignored by this hardware,
> we need to decide if it's ok behaviorally for a driver to "roll" a past
> base time into the immediate future by incrementally adding the cycle
> time (so the phase doesn't change).

That's another good piece of information. My understanding from reading
section 8.6.9.1.1 from the IEEE 802.1Q-2018 spec, is that it's ok:

	"""
	CycleStartTime = (OperBaseTime + N*OperCycleTime)
	where N is the smallest integer for which the relation:
	CycleStartTime >= CurrentTime
	would be TRUE.
	"""

> If it is, then decide by how long in
> the future it is ok to do so. Or alternatively, is it preferable if the
> driver errors out if the user-supplied base time is in the past and the
> hardware doesn't like it? But even then, there might be fringe cases
> when the base time becomes a past PTP time right as the driver tries to
> apply the config.

This fringe case is interesting. I don't know how to handle it well. The
first idea that comes to mind is for the driver to add a integer number
of cycles so there's enough time to apply the config. But this I think
will be different for every driver, no?

> Also applying a tc-taprio offload to a second SJA1105 switch port will
> inevitably need to roll the first port's (now past) base time into an
> equivalent future time.
> All of this is going to be complicated even further by the fact that
> resetting the switch (to apply the tc-taprio offload) makes it reset its
> PTP time.

This is going to be complicated indeed.


Thanks a lot,
--
Vinicius
