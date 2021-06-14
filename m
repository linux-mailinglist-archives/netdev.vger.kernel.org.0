Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1DB3A70C3
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbhFNUyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:54:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:41310 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235398AbhFNUyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:54:11 -0400
IronPort-SDR: jgh4QnCOngczI93Khn/P3KxzlLMYEAlRvCTapS4j1AJIoVIye/SLACzi6JEVBS7mAyWcexxmr0
 EgswHNoiHeMg==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="267026320"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="267026320"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 13:52:00 -0700
IronPort-SDR: Vp/EfvIuMxOi6JmHxdGjrQ3IpMDGHvy+EpVRrkoq4qGR7OrNkXL86lsFxQ4YybG8sO4anafUI+
 woC6b5R7MiHg==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="451713894"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.172.19]) ([10.212.172.19])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 13:52:00 -0700
Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
 <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
 <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
 <20210614110831.65d21c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <427ddb2579f14d77b537aae9c2fa9759@intel.com>
 <20210614134802.633be4c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ce2898d4-7cb9-c668-58e1-a3d759cb6b13@intel.com>
Date:   Mon, 14 Jun 2021 13:51:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614134802.633be4c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/2021 1:48 PM, Jakub Kicinski wrote:
> On Mon, 14 Jun 2021 19:50:23 +0000 Keller, Jacob E wrote:
>>>> Hmmm.. I thought ppb was a s64, not an s32.
>>>>
>>>> In general, I believe max_adj is usually capped at 1 billion anyways,
>>>> since it doesn't make sense to slow a clock by more than 1billioln ppb,
>>>> and increasing it more than that isn't really useful either.  
>>>
>>> Do you mean it's capped somewhere in the code to 1B?
>>>
>>> I'm no time expert but this is not probability where 1 is a magic
>>> value, adjusting clock by 1 - 1ppb vs 1 + 1ppb makes little difference,
>>> no? Both mean something is super fishy with the nominal or expected
>>> frequency, but the hardware can do that and more.
>>>
>>> Flipping the question, if adjusting by large ppb values is not correct,
>>> why not cap the adjustment at the value which would prevent the u64
>>> overflow?  
>>
>> Large ppb values are sometimes used when you want to slew a clock to
>> bring it in sync when its a few milliseconds to seconds off, without
>> performing a time jump (so that you maintain monotonic increasing
>> time).
> 
> Ah, you're right, ptp4l will explicitly cap the freq adjustments
> based on max_adj from sysfs, so setting max_adj too low could impact
> the convergence time in strange scenarios.
> 

Your patch to fix it so that the conversion from scaled_ppm to ppb can't
overflow is the correct approach, here. The scaled_ppm function didn't
account for the fact that the provided adjustment could overflow the s32.

Increasing that to s64 ensures it won't overflow and prevents invalid
bogus frequencies from passing that check.
