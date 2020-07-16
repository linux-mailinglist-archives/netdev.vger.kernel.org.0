Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C8A222E19
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgGPVkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:40:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:5957 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgGPVkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:40:23 -0400
IronPort-SDR: GaiQBUIirQ0SJOqhEWAM+UCDiKHBFvnZkuDpaxZgAUDJLxNe3ul5PMwnat0l/Z6PBMNO9nCNNn
 vwGMzEM2bgSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="234349687"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="234349687"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 14:40:22 -0700
IronPort-SDR: YOcnpLsEce4HoiCqBcGLHH3CpnM2wsji0kCJGI3UyDfzMA1ytrEsbQ8UQ/9d6rGAZAN8KSY6Z6
 TdWzD5G1CewA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="361164988"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.123.234]) ([10.209.123.234])
  by orsmga001.jf.intel.com with ESMTP; 16 Jul 2020 14:40:22 -0700
Subject: Re: [PATCH net-next 2/3] ptp: introduce a phase offset in the
 periodic output request
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
References: <20200716212032.1024188-1-olteanv@gmail.com>
 <20200716212032.1024188-3-olteanv@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <8e487020-7879-e08b-f1fc-a0ebd368a300@intel.com>
Date:   Thu, 16 Jul 2020 14:40:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716212032.1024188-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2020 2:20 PM, Vladimir Oltean wrote:
> Some PHCs like the ocelot/felix switch cannot emit generic periodic
> output, but just PPS (pulse per second) signals, which:
> - don't start from arbitrary absolute times, but are rather
>   phase-aligned to the beginning of [the closest next] second.
> - have an optional phase offset relative to that beginning of the
>   second.
> 
> For those, it was initially established that they should reject any
> other absolute time for the PTP_PEROUT_REQUEST than 0.000000000 [1].
> 
> But when it actually came to writing an application [2] that makes use
> of this functionality, we realized that we can't really deal generically
> with PHCs that support absolute start time, and with PHCs that don't,
> without an explicit interface. Namely, in an ideal world, PHC drivers
> would ensure that the "perout.start" value written to hardware will
> result in a functional output. This means that if the PTP time has
> become in the past of this PHC's current time, it should be
> automatically fast-forwarded by the driver into a close enough future
> time that is known to work (note: this is necessary only if the hardware
> doesn't do this fast-forward by itself). But we don't really know what
> is the status for PHC drivers in use today, so in the general sense,
> user space would be risking to have a non-functional periodic output if
> it simply asked for a start time of 0.000000000.
> 
> So let's introduce a flag for this type of reduced-functionality
> hardware, named PTP_PEROUT_PHASE. The start time is just "soon", the
> only thing we know for sure about this signal is that its rising edge
> events, Rn, occur at:
> 
> Rn = period.phase + n * perout.period
> 
> The "phase" in the periodic output structure is simply an alias to the
> "start" time, since both cannot logically be specified at the same time.
> Therefore, the binary layout of the structure is not affected.
> 
> [1]: https://patchwork.ozlabs.org/project/netdev/patch/20200320103726.32559-7-yangbo.lu@nxp.com/
> [2]: https://www.mail-archive.com/linuxptp-devel@lists.sourceforge.net/msg04142.html
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  include/uapi/linux/ptp_clock.h | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> index 1d2841155f7d..1d108d597f66 100644
> --- a/include/uapi/linux/ptp_clock.h
> +++ b/include/uapi/linux/ptp_clock.h
> @@ -55,12 +55,14 @@
>   */
>  #define PTP_PEROUT_ONE_SHOT		(1<<0)
>  #define PTP_PEROUT_DUTY_CYCLE		(1<<1)
> +#define PTP_PEROUT_PHASE		(1<<2)
>  
>  /*
>   * flag fields valid for the new PTP_PEROUT_REQUEST2 ioctl.
>   */
>  #define PTP_PEROUT_VALID_FLAGS		(PTP_PEROUT_ONE_SHOT | \
> -					 PTP_PEROUT_DUTY_CYCLE)
> +					 PTP_PEROUT_DUTY_CYCLE | \
> +					 PTP_PEROUT_PHASE)
>  
>  /*
>   * No flags are valid for the original PTP_PEROUT_REQUEST ioctl
> @@ -103,7 +105,20 @@ struct ptp_extts_request {
>  };
>  
>  struct ptp_perout_request {
> -	struct ptp_clock_time start;  /* Absolute start time. */
> +	union {
> +		/*
> +		 * Absolute start time.
> +		 * Valid only if (flags & PTP_PEROUT_PHASE) is unset.
> +		 */
> +		struct ptp_clock_time start;
> +		/*
> +		 * Phase offset. The signal should start toggling at an
> +		 * unspecified integer multiple of the period, plus this value.
> +		 * The start time should be "as soon as possible".
> +		 * Valid only if (flags & PTP_PEROUT_PHASE) is set.
> +		 */
> +		struct ptp_clock_time phase;
> +	};

Ok. Since when using the PHASE mode the start time is "meaningless" we
can re-use it for this purpose without breaking the binary structure.
Makes sense.

>  	struct ptp_clock_time period; /* Desired period, zero means disable. */
>  	unsigned int index;           /* Which channel to configure. */
>  	unsigned int flags;
> 
