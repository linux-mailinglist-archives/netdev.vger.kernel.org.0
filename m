Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE46D2271B3
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 23:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgGTVpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 17:45:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:51314 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbgGTVpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 17:45:04 -0400
IronPort-SDR: +0CHfCwxQIfqAxi9F1c7bxF+u8pIe00I+L4VnymHYsdjtN2D/yTsnJwq2UW7N2q9x0mbpmStC2
 TtLgk3dT0nkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="137503406"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="137503406"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 14:45:03 -0700
IronPort-SDR: h/ZYH/Fb38cIrqPhcT2F+f5Ey56kAgbqAz1SwH1qpGtwZ4OiluD0TPxXvt6A9rYRNPVIq/UvcK
 lWMR7WPG9bIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="287694209"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.252.137.6]) ([10.252.137.6])
  by orsmga006.jf.intel.com with ESMTP; 20 Jul 2020 14:45:03 -0700
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set of
 frequently asked questions
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
 <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
 <20200720210518.5uddqqbjuci5wxki@skbuf>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <0fb4754b-6545-f8dc-484f-56aee25796f6@intel.com>
Date:   Mon, 20 Jul 2020 14:45:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720210518.5uddqqbjuci5wxki@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/2020 2:05 PM, Vladimir Oltean wrote:
> On Mon, Jul 20, 2020 at 11:54:30AM -0700, Jacob Keller wrote:
>> On 7/18/2020 4:35 AM, Vladimir Oltean wrote:
>>> On Fri, Jul 17, 2020 at 04:12:07PM -0700, Jacob Keller wrote:
>>>> On 7/17/2020 9:10 AM, Vladimir Oltean wrote:
>>>>> +When the interface they represent offers both ``SOF_TIMESTAMPING_TX_HARDWARE``
>>>>> +and ``SOF_TIMESTAMPING_TX_SOFTWARE``.
>>>>> +Originally, the network stack could deliver either a hardware or a software
>>>>> +time stamp, but not both. This flag prevents software timestamp delivery.
>>>>> +This restriction was eventually lifted via the ``SOF_TIMESTAMPING_OPT_TX_SWHW``
>>>>> +option, but still the original behavior is preserved as the default.
>>>>> +
>>>>
>>>> So, this implies that we set this only if both are supported? I thought
>>>> the intention was to set this flag whenever we start a HW timestamp.
>>>>
>>>
>>> It's only _required_ when SOF_TIMESTAMPING_TX_SOFTWARE is used, it
>>> seems. I had also thought of setting 'SKBTX_IN_PROGRESS' as good
>>> practice, but there are many situations where it can do more harm than
>>> good.
>>>
>>
>> I guess I've only ever implemented a driver with software timestamping
>> enabled as an option. What sort of issues arise when you have this set?
>> I'm guessing that it's some configuration of stacked devices as in the
>> other cases? If the issue can't be fixed I'd at least like more
>> explanation here, since the prevailing convention is that we set this
>> flag, so understanding when and why it's problematic would be useful.
>>
>> Thanks,
>> Jake
> 
> Yes, the problematic cases have to do with stacked PHCs (DSA, PHY). The
> pattern is that:
> - DSA sets SKBTX_IN_PROGRESS
> - calls dev_queue_xmit towards the MAC driver
> - MAC driver sees SKBTX_IN_PROGRESS, thinks it's the one who set it
> - MAC driver delivers TX timestamp
> - DSA ends poll or receives TX interrupt, collects its timestamp, and
>   delivers a second TX timestamp
> In fact this is explained in a bit more detail in the current
> timestamping.rst file.
> Not only are there existing in-tree drivers that do that (and various
> subtle variations of it), but new code also has this tendency to take
> shortcuts and interpret any SKBTX_IN_PROGRESS flag set as being set
> locally. Good thing it's caught during review most of the time these
> days. It's an error-prone design.
> On the DSA front, 1 driver sets this flag (sja1105) and 3 don't (felix,
> mv88e6xxx, hellcreek). The driver who had trouble because of this flag?
> sja1105.
> On the PHY front, 2 drivers set this flag (mscc_phy, dp83640) and 1
> doesn't (ptp_ines). The driver who had trouble? dp83640.
> So it's very far from obvious that setting this flag is 'the prevailing
> convention'. For a MAC driver, that might well be, but for DSA/PHY,
> there seem to be risks associated with doing that, and driver writers
> should know what they're signing up for.
> 

Perhaps the issue is that the MAC driver using SKBTX_IN_PROGRESS as the
mechanism for telling if it should deliver a timestamp. Shouldn't they
be relying on SKBTX_HW_TSTAMP for the "please timestamp" notification,
and then using their own mechanism for forwarding that timestamp once
it's complete?

I see a handful of drivers do rely on checking this, but I think that's
the real bug here.

> -Vladimir
> 
