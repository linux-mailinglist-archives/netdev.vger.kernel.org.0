Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA1E3A6C49
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 18:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhFNQqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 12:46:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:52539 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234808AbhFNQqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 12:46:01 -0400
IronPort-SDR: 8o2zmXpvA2n6SDnXnOYQMtoo6gYTIQX4uei7uxaSITrzSRwrzOOfOz6cjUQU7Es7uOdUWjIFSx
 YCDq/caRbbaw==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="204011351"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="204011351"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 09:43:21 -0700
IronPort-SDR: PXadM4/+WCkK78WQ+dJxiVtioC7xdKR2ndNlfcfQdZIbymZbQYyRwcrzmM79jJd0LLSzOExanu
 /uqyYfT9vM+A==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="403703944"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.172.19]) ([10.212.172.19])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 09:43:20 -0700
Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
 <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
 <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
Date:   Mon, 14 Jun 2021 09:43:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/11/2021 2:18 PM, Jakub Kicinski wrote:
> On Fri, 11 Jun 2021 09:19:57 -0700 Tony Nguyen wrote:
>> +static u64
>> +ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
>> +{
>> +	struct ice_hw *hw = &pf->hw;
>> +	u32 hi, lo, lo2;
>> +	u8 tmr_idx;
>> +
>> +	tmr_idx = ice_get_ptp_src_clock_index(hw);
>> +	/* Read the system timestamp pre PHC read */
>> +	if (sts)
>> +		ptp_read_system_prets(sts);
>> +
>> +	lo = rd32(hw, GLTSYN_TIME_L(tmr_idx));
>> +
>> +	/* Read the system timestamp post PHC read */
>> +	if (sts)
>> +		ptp_read_system_postts(sts);
>> +
>> +	hi = rd32(hw, GLTSYN_TIME_H(tmr_idx));
>> +	lo2 = rd32(hw, GLTSYN_TIME_L(tmr_idx));
>> +
>> +	if (lo2 < lo) {
>> +		/* if TIME_L rolled over read TIME_L again and update
>> +		 * system timestamps
>> +		 */
>> +		if (sts)
>> +			ptp_read_system_prets(sts);
>> +		lo = rd32(hw, GLTSYN_TIME_L(tmr_idx));
>> +		if (sts)
>> +			ptp_read_system_postts(sts);
> 
> ptp_read_system* helpers already check for NULL sts.
>

Hah. Yep, I knew that... and of course I forgot about it.

> 
>> +static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
>> +{
>> +	struct ice_pf *pf = ptp_info_to_pf(info);
>> +	u64 freq, divisor = 1000000ULL;
>> +	struct ice_hw *hw = &pf->hw;
>> +	s64 incval, diff;
>> +	int neg_adj = 0;
>> +	int err;
>> +
>> +	incval = ICE_PTP_NOMINAL_INCVAL_E810;
>> +
>> +	if (scaled_ppm < 0) {
>> +		neg_adj = 1;
>> +		scaled_ppm = -scaled_ppm;
>> +	}
>> +
>> +	while ((u64)scaled_ppm > div_u64(U64_MAX, incval)) {
>> +		/* handle overflow by scaling down the scaled_ppm and
>> +		 * the divisor, losing some precision
>> +		 */
>> +		scaled_ppm >>= 2;
>> +		divisor >>= 2;
>> +	}
> 
> I have a question regarding ppm overflows.
> 
> We have the max_adj field in struct ptp_clock_info which is checked
> against ppb, but ppb is a signed 32 bit and scaled_ppm is a long,
> meaning values larger than S32_MAX << 16 / 1000 will overflow 
> the ppb calculation, and therefore the check.
> 

Hmmm.. I thought ppb was a s64, not an s32.

In general, I believe max_adj is usually capped at 1 billion anyways,
since it doesn't make sense to slow a clock by more than 1billioln ppb,
and increasing it more than that isn't really useful either.

> Are we okay with that? Is my math off? Did I miss some part 
> of the kernel which filters crazy high scaled_ppm/freq?
> 
> Since dialed_freq is updated regardless of return value of .adjfine 
> the driver has no clear way to reject bad scaled_ppm>

I'm not sure. +Richard?

>> +	freq = (incval * (u64)scaled_ppm) >> 16;
>> +	diff = div_u64(freq, divisor);
