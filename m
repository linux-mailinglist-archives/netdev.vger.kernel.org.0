Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9CD3A4A90
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 23:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFKVUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 17:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhFKVUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 17:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8944761285;
        Fri, 11 Jun 2021 21:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623446281;
        bh=cIwXXrxo+3Sl5XAoI/5z137H/ZoLFCvWmAJ0x7mP7fk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pS2GIAA4AcH4WzmSeIA4h0YQUoKmnONlh4zah258Y4g9jvum6da4HVJE5dsZ/yF+W
         dm0iF7gDToEr8y/m7owqX0RUKQUyE8g716jAcEF4j2gHf2viQmNOEBw/foXP9Zpgp0
         9+3xmcvKGSYHjI94Plf1Kicf3eSphlieF8rOyIyO4ZpWPUBiBZ+ld6NN+/9JCFnl/x
         FnVgNLcnkVTjcdyMgMRBhaTvhGGeR5MJ+ghJgVCYPjIlBxNeEOKjaixN2F08da6CMG
         pkJg2QM0N5Z0YatKoue+MnUP8/p2FD5VEK/+PX5a3P88EOtDeOrd7jmMAz1pZL+pJ8
         bvpqUCr1/3bww==
Date:   Fri, 11 Jun 2021 14:18:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        richardcochran@gmail.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Message-ID: <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
        <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Jun 2021 09:19:57 -0700 Tony Nguyen wrote:
> +static u64
> +ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
> +{
> +	struct ice_hw *hw = &pf->hw;
> +	u32 hi, lo, lo2;
> +	u8 tmr_idx;
> +
> +	tmr_idx = ice_get_ptp_src_clock_index(hw);
> +	/* Read the system timestamp pre PHC read */
> +	if (sts)
> +		ptp_read_system_prets(sts);
> +
> +	lo = rd32(hw, GLTSYN_TIME_L(tmr_idx));
> +
> +	/* Read the system timestamp post PHC read */
> +	if (sts)
> +		ptp_read_system_postts(sts);
> +
> +	hi = rd32(hw, GLTSYN_TIME_H(tmr_idx));
> +	lo2 = rd32(hw, GLTSYN_TIME_L(tmr_idx));
> +
> +	if (lo2 < lo) {
> +		/* if TIME_L rolled over read TIME_L again and update
> +		 * system timestamps
> +		 */
> +		if (sts)
> +			ptp_read_system_prets(sts);
> +		lo = rd32(hw, GLTSYN_TIME_L(tmr_idx));
> +		if (sts)
> +			ptp_read_system_postts(sts);

ptp_read_system* helpers already check for NULL sts.


> +static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
> +{
> +	struct ice_pf *pf = ptp_info_to_pf(info);
> +	u64 freq, divisor = 1000000ULL;
> +	struct ice_hw *hw = &pf->hw;
> +	s64 incval, diff;
> +	int neg_adj = 0;
> +	int err;
> +
> +	incval = ICE_PTP_NOMINAL_INCVAL_E810;
> +
> +	if (scaled_ppm < 0) {
> +		neg_adj = 1;
> +		scaled_ppm = -scaled_ppm;
> +	}
> +
> +	while ((u64)scaled_ppm > div_u64(U64_MAX, incval)) {
> +		/* handle overflow by scaling down the scaled_ppm and
> +		 * the divisor, losing some precision
> +		 */
> +		scaled_ppm >>= 2;
> +		divisor >>= 2;
> +	}

I have a question regarding ppm overflows.

We have the max_adj field in struct ptp_clock_info which is checked
against ppb, but ppb is a signed 32 bit and scaled_ppm is a long,
meaning values larger than S32_MAX << 16 / 1000 will overflow 
the ppb calculation, and therefore the check.

Are we okay with that? Is my math off? Did I miss some part 
of the kernel which filters crazy high scaled_ppm/freq?

Since dialed_freq is updated regardless of return value of .adjfine 
the driver has no clear way to reject bad scaled_ppm.

> +	freq = (incval * (u64)scaled_ppm) >> 16;
> +	diff = div_u64(freq, divisor);
