Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA869250C80
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 01:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHXXpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 19:45:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:25938 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgHXXpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 19:45:51 -0400
IronPort-SDR: MnPFUZ9zphnoD5OzHv77TpwYAtjedI2cJeSjSBv7xwSjnePdIzvdI2BAREveA6WMcUcGEie10P
 uXCTVTAC3w1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="174049287"
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="174049287"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 16:45:51 -0700
IronPort-SDR: NmAvFCg1vOBHJONklwmSRgHRYXt9YkPchvshhxW0Xm1pvwF9TH6gUmOnOIjLHwf9OWm/gzK1Qw
 +NyMvvY2c/PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="499099888"
Received: from unknown (HELO ellie) ([10.254.31.141])
  by fmsmga006.fm.intel.com with ESMTP; 24 Aug 2020 16:45:50 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
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
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <87imd8zi8z.fsf@kurt>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200822143922.frjtog4mcyaegtyg@skbuf> <87imd8zi8z.fsf@kurt>
Date:   Mon, 24 Aug 2020 16:45:50 -0700
Message-ID: <87y2m3txox.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

Kurt Kanzenbach <kurt@linutronix.de> writes:

>>> +static void hellcreek_setup_tc_mapping(struct hellcreek *hellcreek,
>>> +				       struct net_device *netdev)
>>> +{
>>> +	int i, j;
>>> +
>>> +	/* Setup mapping between traffic classes and port queues. */
>>> +	for (i = 0; i < netdev_get_num_tc(netdev); ++i) {
>>> +		for (j = 0; j < netdev->tc_to_txq[i].count; ++j) {
>>> +			const int queue = j + netdev->tc_to_txq[i].offset;
>>> +
>>> +			hellcreek_select_prio(hellcreek, i);
>>> +			hellcreek_write(hellcreek,
>>> +					queue << HR_PRTCCFG_PCP_TC_MAP_SHIFT,
>>> +					HR_PRTCCFG);
>>> +		}
>>> +	}
>>> +}
>>
>> What other driver have you seen that does this?
>>
>
> Probably none.
>
> With TAPRIO traffic classes and the mapping to queues can be
> configured. The switch can also map traffic classes. That sounded like a
> good match to me.

The only reason I could think that you would need this that *right now*
taprio has pretty glaring oversight: that in the offload parameters each entry
'gate_mask' reference the "Traffic Class" (i.e. bit 0 is Traffic Class
0), and it really should be the HW queue.

I have a patch that does the conversion on taprio before talking to the
driver. Do you think it would help you avoid doing this on the driver
side?

>
> Thanks,
> Kurt


Cheers,
-- 
Vinicius
