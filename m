Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6944223C271
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 02:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgHEAEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 20:04:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:49295 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgHEAEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 20:04:48 -0400
IronPort-SDR: m4lzrXCF/iuyP81XWn1930dDx0wdGP9NaLbcM93lkjWxmtLBo9guQo6DLNTHXGRJDY5ZDDCsEG
 5TAG+DgXqYpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="150211002"
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="150211002"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 17:04:48 -0700
IronPort-SDR: wtNxdHuQpocM2Jurr4UZ40vULmqTWeklfYamg2bCHzQ2jbBS06o3ybSp1E1nj8nNQo0ACpU+Fb
 /pcGm9OAXJFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="436987608"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.37.231]) ([10.212.37.231])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2020 17:04:48 -0700
Subject: Re: [PATCH v2 net-next] ptp: only allow phase values lower than 1
 period
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com
References: <20200804234308.1303022-1-olteanv@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <cc1465fd-2696-f73b-85c2-7f6132f6623d@intel.com>
Date:   Tue, 4 Aug 2020 17:04:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.0
MIME-Version: 1.0
In-Reply-To: <20200804234308.1303022-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2020 4:43 PM, Vladimir Oltean wrote:
> The way we define the phase (the difference between the time of the
> signal's rising edge, and the closest integer multiple of the period),
> it doesn't make sense to have a phase value larger than 1 period.
> 
> So deny these settings coming from the user.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> Changes in v2:
> Be sure to also deny the case where the period is equal to the phase.
> This represents a 360 degree offset, which is equivalent to a phase of
> zero, so it should be rejected on the grounds of having a modulo
> equivalent as well.
> 
>  drivers/ptp/ptp_chardev.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index e0e6f85966e1..ee48eb61b49c 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -218,6 +218,19 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  					break;
>  				}
>  			}
> +			if (perout->flags & PTP_PEROUT_PHASE) {
> +				/*
> +				 * The phase should be specified modulo the
> +				 * period, therefore anything larger than 1
> +				 * period is invalid.
> +				 */

A nit: this could read "therefore anything equal or larger than 1 period
is invalid"? a number modulo itself is 0, right? and we use ">=" below
as well now.

I do think it's relatively clear from context so it probably isn't worth
a re-roll.


> +				if (perout->phase.sec > perout->period.sec ||
> +				    (perout->phase.sec == perout->period.sec &&
> +				     perout->phase.nsec >= perout->period.nsec)) {
> +					err = -ERANGE;
> +					break;
> +				}
> +			}
>  		} else if (cmd == PTP_PEROUT_REQUEST) {
>  			req.perout.flags &= PTP_PEROUT_V1_VALID_FLAGS;
>  			req.perout.rsv[0] = 0;
> 
