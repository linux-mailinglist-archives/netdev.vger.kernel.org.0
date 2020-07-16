Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EEE222E17
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgGPVgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:36:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:53333 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgGPVgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:36:47 -0400
IronPort-SDR: vm/0hiT0IZt+Z6L/wj+0vPre3j8jpce5ZOG9lRHIh+2phEnY6log/CaL5u/M3hA98Sjmq7XcQo
 bE0bdxgQfnRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="137618959"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="137618959"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 14:36:46 -0700
IronPort-SDR: mBIojumO4OBaygQ6Txww/rEtmBuukkPEdfIizfAo3M5UvfDj6aVQUVI+d8w70n91n5eKi6hFWa
 7is/3HPAZS9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="361164444"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.123.234]) ([10.209.123.234])
  by orsmga001.jf.intel.com with ESMTP; 16 Jul 2020 14:36:45 -0700
Subject: Re: [PATCH net-next 1/3] ptp: add ability to configure duty cycle for
 periodic output
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
References: <20200716212032.1024188-1-olteanv@gmail.com>
 <20200716212032.1024188-2-olteanv@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <56860b5e-95ff-ae59-a20d-9873af44de67@intel.com>
Date:   Thu, 16 Jul 2020 14:36:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716212032.1024188-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2020 2:20 PM, Vladimir Oltean wrote:
> There are external event timestampers (PHCs with support for
> PTP_EXTTS_REQUEST) that timestamp both event edges.
> 
> When those edges are very close (such as in the case of a short pulse),
> there is a chance that the collected timestamp might be of the rising,
> or of the falling edge, we never know.
> 
> There are also PHCs capable of generating periodic output with a
> configurable duty cycle. This is good news, because we can space the
> rising and falling edge out enough in time, that the risks to overrun
> the 1-entry timestamp FIFO of the extts PHC are lower (example: the
> perout PHC can be configured for a period of 1 second, and an "on" time
> of 0.5 seconds, resulting in a duty cycle of 50%).
> 
> A flag is introduced for signaling that an on time is present in the
> perout request structure, for preserving compatibility. Logically
> speaking, the duty cycle cannot exceed 100% and the PTP core checks for
> this.

I was thinking whether it made sense to support over 50% since in theory
you could change start time and the duty cycle to specify the shifted
wave over? but I guess it doesn't really make much of a difference to
support all the way up to 100%.

> 
> PHC drivers that don't support this flag emit a periodic output of an
> unspecified duty cycle, same as before.
> 
> The duty cycle is encoded as an "on" time, similar to the "start" and
> "period" times, and reuses the reserved space while preserving overall
> binary layout.
> 
> Pahole reported before:
> 
> struct ptp_perout_request {
>         struct ptp_clock_time start;                     /*     0    16 */
>         struct ptp_clock_time period;                    /*    16    16 */
>         unsigned int               index;                /*    32     4 */
>         unsigned int               flags;                /*    36     4 */
>         unsigned int               rsv[4];               /*    40    16 */
> 
>         /* size: 56, cachelines: 1, members: 5 */
>         /* last cacheline: 56 bytes */
> };
> 
> And now:
> 
> struct ptp_perout_request {
>         struct ptp_clock_time start;                     /*     0    16 */
>         struct ptp_clock_time period;                    /*    16    16 */
>         unsigned int               index;                /*    32     4 */
>         unsigned int               flags;                /*    36     4 */
>         union {
>                 struct ptp_clock_time on;                /*    40    16 */
>                 unsigned int       rsv[4];               /*    40    16 */
>         };                                               /*    40    16 */
> 
>         /* size: 56, cachelines: 1, members: 5 */
>         /* last cacheline: 56 bytes */
> };
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  drivers/ptp/ptp_chardev.c      | 33 +++++++++++++++++++++++++++------
>  include/uapi/linux/ptp_clock.h | 17 ++++++++++++++---
>  2 files changed, 41 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 375cd6e4aade..e0e6f85966e1 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -191,12 +191,33 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			err = -EFAULT;
>  			break;
>  		}
> -		if (((req.perout.flags & ~PTP_PEROUT_VALID_FLAGS) ||
> -			req.perout.rsv[0] || req.perout.rsv[1] ||
> -			req.perout.rsv[2] || req.perout.rsv[3]) &&
> -			cmd == PTP_PEROUT_REQUEST2) {
> -			err = -EINVAL;
> -			break;
> +		if (cmd == PTP_PEROUT_REQUEST2) {
> +			struct ptp_perout_request *perout = &req.perout;
> +
> +			if (perout->flags & ~PTP_PEROUT_VALID_FLAGS) {
> +				err = -EINVAL;
> +				break;
> +			}
> +			/*
> +			 * The "on" field has undefined meaning if
> +			 * PTP_PEROUT_DUTY_CYCLE isn't set, we must still treat
> +			 * it as reserved, which must be set to zero.
> +			 */
> +			if (!(perout->flags & PTP_PEROUT_DUTY_CYCLE) &&
> +			    (perout->rsv[0] || perout->rsv[1] ||
> +			     perout->rsv[2] || perout->rsv[3])) {
> +				err = -EINVAL;
> +				break;
> +			}
> +			if (perout->flags & PTP_PEROUT_DUTY_CYCLE) {
> +				/* The duty cycle must be subunitary. */

I'm sure this means "smaller than the period" but I can't help thinking
just spelling that out would be clearer.

> +				if (perout->on.sec > perout->period.sec ||
> +				    (perout->on.sec == perout->period.sec &&
> +				     perout->on.nsec > perout->period.nsec)) {
> +					err = -ERANGE;
> +					break;
> +				}
> +			}
>  		} else if (cmd == PTP_PEROUT_REQUEST) {
>  			req.perout.flags &= PTP_PEROUT_V1_VALID_FLAGS;
>  			req.perout.rsv[0] = 0;
> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> index ff070aa64278..1d2841155f7d 100644
> --- a/include/uapi/linux/ptp_clock.h
> +++ b/include/uapi/linux/ptp_clock.h
> @@ -53,12 +53,14 @@
>  /*
>   * Bits of the ptp_perout_request.flags field:
>   */
> -#define PTP_PEROUT_ONE_SHOT (1<<0)
> +#define PTP_PEROUT_ONE_SHOT		(1<<0)
> +#define PTP_PEROUT_DUTY_CYCLE		(1<<1)
>  
>  /*
>   * flag fields valid for the new PTP_PEROUT_REQUEST2 ioctl.
>   */
> -#define PTP_PEROUT_VALID_FLAGS	(PTP_PEROUT_ONE_SHOT)
> +#define PTP_PEROUT_VALID_FLAGS		(PTP_PEROUT_ONE_SHOT | \
> +					 PTP_PEROUT_DUTY_CYCLE)
>  
>  /*
>   * No flags are valid for the original PTP_PEROUT_REQUEST ioctl
> @@ -105,7 +107,16 @@ struct ptp_perout_request {
>  	struct ptp_clock_time period; /* Desired period, zero means disable. */
>  	unsigned int index;           /* Which channel to configure. */
>  	unsigned int flags;
> -	unsigned int rsv[4];          /* Reserved for future use. */
> +	union {
> +		/*
> +		 * The "on" time of the signal.
> +		 * Must be lower than the period.
> +		 * Valid only if (flags & PTP_PEROUT_DUTY_CYCLE) is set.
> +		 */
> +		struct ptp_clock_time on;
> +		/* Reserved for future use. */
> +		unsigned int rsv[4];
> +	};

Hmmm. So the idea is that if PTP_PEROUT_DUTY_CYCLE is not set, then we
keep this as reserved and then if it *is* set we allow it to be the "on"
time?

Is it possible for us to still use the reserved bits for another
purpose? Or should we just remove it entirely and leave only the "on"
timestamp. Any future extension would by definition *have* to be
exclusive with PTP_PEROUT_DUTY_CYCLE if it wants to use these reserved
fields anyways...

>  };
>  
>  #define PTP_MAX_SAMPLES 25 /* Maximum allowed offset measurement samples. */
> 
