Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC616222F72
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgGPX4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:56:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:19280 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgGPX4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:56:36 -0400
IronPort-SDR: 87/GvNlLhrR3g2mRLaZ8A2vRXUGYqQl5BiOHKd3zwhXL3ktIdrffnrGp1CJ3j+/lSuHzjrwEi7
 tV85IDn2pxKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="149497940"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="149497940"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 16:56:36 -0700
IronPort-SDR: 2zxdlrTe9QLS1RWgrmeEO6gcSfSQw92ZS9rPfJbAtfMt+VvnL3sP1BRijQiQqtJE0SeTXjMiVD
 oL779SOGsBRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="361191554"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.123.234]) ([10.209.123.234])
  by orsmga001.jf.intel.com with ESMTP; 16 Jul 2020 16:56:35 -0700
Subject: Re: [PATCH net-next 1/3] ptp: add ability to configure duty cycle for
 periodic output
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
References: <20200716212032.1024188-1-olteanv@gmail.com>
 <20200716212032.1024188-2-olteanv@gmail.com>
 <56860b5e-95ff-ae59-a20d-9873af44de67@intel.com>
 <20200716214927.s4uu36twwegarznm@skbuf>
 <20200716220923.k6vwsjdk2os4rlrp@skbuf>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <3f8f4f4b-b5f3-11b6-2dfe-3bce5e1b79f3@intel.com>
Date:   Thu, 16 Jul 2020 16:56:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716220923.k6vwsjdk2os4rlrp@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2020 3:09 PM, Vladimir Oltean wrote:
> On Fri, Jul 17, 2020 at 12:49:27AM +0300, Vladimir Oltean wrote:
>> On Thu, Jul 16, 2020 at 02:36:45PM -0700, Jacob Keller wrote:
>>>
>>>
>>> On 7/16/2020 2:20 PM, Vladimir Oltean wrote:
>>>> There are external event timestampers (PHCs with support for
>>>> PTP_EXTTS_REQUEST) that timestamp both event edges.
>>>>
>>>> When those edges are very close (such as in the case of a short pulse),
>>>> there is a chance that the collected timestamp might be of the rising,
>>>> or of the falling edge, we never know.
>>>>
>>>> There are also PHCs capable of generating periodic output with a
>>>> configurable duty cycle. This is good news, because we can space the
>>>> rising and falling edge out enough in time, that the risks to overrun
>>>> the 1-entry timestamp FIFO of the extts PHC are lower (example: the
>>>> perout PHC can be configured for a period of 1 second, and an "on" time
>>>> of 0.5 seconds, resulting in a duty cycle of 50%).
>>>>
>>>> A flag is introduced for signaling that an on time is present in the
>>>> perout request structure, for preserving compatibility. Logically
>>>> speaking, the duty cycle cannot exceed 100% and the PTP core checks for
>>>> this.
>>>
>>> I was thinking whether it made sense to support over 50% since in theory
>>> you could change start time and the duty cycle to specify the shifted
>>> wave over? but I guess it doesn't really make much of a difference to
>>> support all the way up to 100%.
>>>
>>
>> Only if you also support polarity, and we don't support polarity. It's
>> always high first, then low.
>>
> 
> Sorry for the imprecise statement.
> If you look at things from the perspective of the signal itself, the
> statement is correct.
> If you look at them from the perspective of the imaginary grid drawn by
> the integer multiples of the period, in the PHC's time (a digital
> counter), the correct statement would be that "it's always rising edge
> first, then falling edge".  And then the phase is just the delta between
> these 2 points of reference.
> 
> Let me annotate this:
> 
>      t_on
>      <------>
>      t_period
>      <--------->
> phase
>    <->
>>    +------+  +------+  +------+  +------+  +------+  +------+  +------+
>>    |      |  |      |  |      |  |      |  |      |  |      |  |      |
>>  --+      +--+      +--+      +--+      +--+      +--+      +--+      +
>>
>>  +---------+---------+---------+---------+---------+---------+--------->
>    t=1000    t=1010    t=1020    t=1030    t=1040    t=1050    t=1060
>>  period=10                                                          time
>>  phase=2
>>  on = 7
>>
>> There's no other way to obtain this signal which has a duty cycle > 50%
>> by specifying a duty cycle < 50%.
>>
> 
> Thanks,
> -Vladimir
> 

Right this makes sense now, thanks for the detailed explanation!

Regards,
Jake
