Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A4014F0E9
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 17:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgAaQyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 11:54:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:23682 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbgAaQyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 11:54:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 08:54:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="377393441"
Received: from unknown (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2020 08:54:19 -0800
Subject: Re: [Intel PMC TGPIO Driver 1/5] drivers/ptp: Add Enhanced handling
 of reserve fields
To:     christopher.s.hall@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        mingo@redhat.com, x86@kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, sean.v.kelley@intel.com
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-2-christopher.s.hall@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <0f868a7e-5806-4976-80b5-0185a64b42a0@intel.com>
Date:   Fri, 31 Jan 2020 08:54:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20191211214852.26317-2-christopher.s.hall@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/2019 1:48 PM, christopher.s.hall@intel.com wrote:
> From: Christopher Hall <christopher.s.hall@intel.com>
> 
> Add functions that parameterize checking and zeroing of reserve fields in
> ioctl arguments. Eliminates need to change this code when repurposing
> reserve fields.
> 

Nice!

> Signed-off-by: Christopher Hall <christopher.s.hall@intel.com>
> ---
>  drivers/ptp/ptp_chardev.c | 60 +++++++++++++++++++++------------------
>  1 file changed, 33 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 9d72ab593f13..f9ad6df57fa5 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -12,6 +12,7 @@
>  #include <linux/timekeeping.h>
>  
>  #include <linux/nospec.h>
> +#include <linux/string.h>
>  
>  #include "ptp_private.h"
>  
> @@ -106,6 +107,28 @@ int ptp_open(struct posix_clock *pc, fmode_t fmode)
>  	return 0;
>  }
>  
> +/* Returns -1 if any reserved fields are non-zero */
> +static inline int _check_rsv_field(unsigned int *field, size_t size)
> +{
> +	unsigned int *iter;
> +	int ret = 0;
> +
> +	for (iter = field; iter < field+size && ret == 0; ++iter)
> +		ret = *iter == 0 ? 0 : -1;
> +
> +	return ret;
> +}
> +#define check_rsv_field(field) _check_rsv_field(field, ARRAY_SIZE(field))
> +

This assumes that reserved fields will always be arrays. Seems like a
reasonable restriction to me.

Are the reserved fields always integers? Seems so. Ok.

> +static inline void _zero_rsv_field(unsigned int *field, size_t size)
> +{
> +	unsigned int *iter;
> +
> +	for (iter = field; iter < field+size; ++iter)
> +		*iter = 0;
> +}
> +#define zero_rsv_field(field) _zero_rsv_field(field, ARRAY_SIZE(field))
> +
>  long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  {
>  	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
> @@ -154,7 +177,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			req.extts.flags |= PTP_STRICT_FLAGS;
>  			/* Make sure no reserved bit is set. */
>  			if ((req.extts.flags & ~PTP_EXTTS_VALID_FLAGS) ||
> -			    req.extts.rsv[0] || req.extts.rsv[1]) {
> +			    check_rsv_field(req.extts.rsv)) {
>  				err = -EINVAL;
>  				break;
>  			}
> @@ -166,8 +189,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			}
>  		} else if (cmd == PTP_EXTTS_REQUEST) {
>  			req.extts.flags &= PTP_EXTTS_V1_VALID_FLAGS;
> -			req.extts.rsv[0] = 0;
> -			req.extts.rsv[1] = 0;
> +			zero_rsv_field(req.extts.rsv);
>  		}
>  		if (req.extts.index >= ops->n_ext_ts) {
>  			err = -EINVAL;
> @@ -188,17 +210,13 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			break;
>  		}
>  		if (((req.perout.flags & ~PTP_PEROUT_VALID_FLAGS) ||
> -			req.perout.rsv[0] || req.perout.rsv[1] ||
> -			req.perout.rsv[2] || req.perout.rsv[3]) &&
> -			cmd == PTP_PEROUT_REQUEST2) {
> +		     check_rsv_field(req.perout.rsv)) &&
> +		    cmd == PTP_PEROUT_REQUEST2) {
>  			err = -EINVAL;
>  			break;
>  		} else if (cmd == PTP_PEROUT_REQUEST) {
>  			req.perout.flags &= PTP_PEROUT_V1_VALID_FLAGS;
> -			req.perout.rsv[0] = 0;
> -			req.perout.rsv[1] = 0;
> -			req.perout.rsv[2] = 0;
> -			req.perout.rsv[3] = 0;
> +			zero_rsv_field(req.perout.rsv);
>  		}
>  		if (req.perout.index >= ops->n_per_out) {
>  			err = -EINVAL;
> @@ -258,7 +276,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			break;
>  		}
>  		if (extoff->n_samples > PTP_MAX_SAMPLES
> -		    || extoff->rsv[0] || extoff->rsv[1] || extoff->rsv[2]) {
> +		    || check_rsv_field(extoff->rsv)) {
>  			err = -EINVAL;
>  			break;
>  		}
> @@ -318,17 +336,11 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			err = -EFAULT;
>  			break;
>  		}
> -		if ((pd.rsv[0] || pd.rsv[1] || pd.rsv[2]
> -				|| pd.rsv[3] || pd.rsv[4])
> -			&& cmd == PTP_PIN_GETFUNC2) {
> +		if (check_rsv_field(pd.rsv) && cmd == PTP_PIN_GETFUNC2) {

Not that it's a big deal, but I think this might read more clearly if
this was "cmd == PTP_PIN_GETFUNC2 && check_rsv_field(pd.rsv)"

Thanks,
Jake
