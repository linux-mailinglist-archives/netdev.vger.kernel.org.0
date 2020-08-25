Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9285D251E5F
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgHYRe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:34:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:49312 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgHYReA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 13:34:00 -0400
IronPort-SDR: 1fmJJFI3gChAGeXM7oR1g3xerluUbwVJeMOlvpekjdTsUzVisILzw6WdnH6jAZ8BtcEZUqreDa
 ZMAKLGdAGMZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="156155497"
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="156155497"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 10:34:00 -0700
IronPort-SDR: bbhThQBVUTHS16GMnWBZ9d3uWN/3SIPWLwulL9qf0upl5vO0uPwHLL2FL3MCliZIqgr155snjS
 RKRh8a/sQ7hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="499395843"
Received: from adent-mobl.amr.corp.intel.com (HELO ellie) ([10.209.77.195])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2020 10:33:59 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <20200825094612.ffdt6xkl552ppc3i@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200822143922.frjtog4mcyaegtyg@skbuf> <87imd8zi8z.fsf@kurt> <87y2m3txox.fsf@intel.com> <20200825094612.ffdt6xkl552ppc3i@skbuf>
Date:   Tue, 25 Aug 2020 10:33:58 -0700
Message-ID: <87imd6tyt5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> Hi Vinicius,
>
> On Mon, Aug 24, 2020 at 04:45:50PM -0700, Vinicius Costa Gomes wrote:
>> Kurt Kanzenbach <kurt@linutronix.de> writes:
>> >
>> > With TAPRIO traffic classes and the mapping to queues can be
>> > configured. The switch can also map traffic classes. That sounded like a
>> > good match to me.
>>
>> The only reason I could think that you would need this that *right now*
>> taprio has pretty glaring oversight: that in the offload parameters each entry
>> 'gate_mask' reference the "Traffic Class" (i.e. bit 0 is Traffic Class
>> 0), and it really should be the HW queue.
>>
>
> Sorry, but could you please explain why having the gate_mask reference
> the traffic classes is a glaring oversight, and how changing it would
> help here?

The glaring oversight is that it when it references the traffic classes,
instead of queues, it basically ignores the 'queues *' mapping that the
user provided. (it was ignored for so long because for many cases the
mapping is 1:1)

On my reading of this part of the hellcreek code, all this was doing was
assigning priorities (based on the traffic classes) to queues, and
taprio is able to "hide" this from the driver, so all the driver needs
to care about are queues.

>
> Also, Kurt, could you please explain what the
> HR_PRTCCFG_PCP_TC_MAP_SHIFT field in HR_PRTCCFG is doing?
> To me, it appears that it's configuring ingress QoS classification on
> the port (and the reason why this is strange to me is because you're
> applying this configuration through an egress qdisc), but I want to make
> sure I'm not misunderstanding.
>
> Thanks,
> -Vladimir

-- 
Vinicius
