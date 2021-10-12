Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D2942AF5D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 23:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhJLVz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 17:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232260AbhJLVzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 17:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60DB960E78;
        Tue, 12 Oct 2021 21:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634075632;
        bh=LrNHboHLemg3Rlg0S0CD7kQ8PJu801dfF9Wvua/Eoq8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gSfYOkv8s/WhAYHjEtvFgmDYkAvn3RsKoftZj8SW8k2hslzcLo9SABhZwTP0m1Ycs
         srre7ft7vb4neORrnuFFjs4iowz7Ek5B5+hsXbOU77nCK9cKOho9cN1twiOVhZPXck
         YtucPHnCEaB1Nr6ZYAxGns6F/zfqaRDnNkL6M+8U+f3YQvX5Ir/1EVvM2N0hC39DbM
         2XjvClFTlJ9MkAsx6GLyNm+yWjcD32Wjci4kfHpvLAq42OQq5RfXsqp58kSGxEmB3P
         A1Rgkz6bJ5orGKVlRXNxfPVN5NfriiDUAwvEaLBnCQ7iBY+6lbEgLgmIQgqMzmtLml
         KZFRSxp44l0tg==
Date:   Tue, 12 Oct 2021 14:53:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yuiko.oshino@microchip.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: microchip: lan743x: add support for PTP
 pulse width (duty cycle)
Message-ID: <20211012145350.0d7d96bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1634046593-64312-1-git-send-email-yuiko.oshino@microchip.com>
References: <1634046593-64312-1-git-send-email-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 09:49:53 -0400 yuiko.oshino@microchip.com wrote:
> From: Yuiko Oshino <yuiko.oshino@microchip.com>
> 
> If the PTP_PEROUT_DUTY_CYCLE flag is set, then check if the
> request_on value in ptp_perout_request matches the pre-defined
> values or a toggle option.
> Return a failure if the value is not supported.
> 
> Preserve the old behaviors if the PTP_PEROUT_DUTY_CYCLE flag is not
> set.
> 
> Tested with an oscilloscope on EVB-LAN7430:
> e.g., to output PPS 1sec period 500mS on (high) to GPIO 2.
>  ./testptp -L 2,2
>  ./testptp -p 1000000000 -w 500000000
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>

Please make sure to CC Richard on PTP-related changes.

> diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
> index 6080028c1df2..34c22eea0124 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.h
> +++ b/drivers/net/ethernet/microchip/lan743x_main.h
> @@ -279,6 +279,7 @@
>  #define PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS_	(3)
>  #define PTP_GENERAL_CONFIG_CLOCK_EVENT_10MS_	(4)
>  #define PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_	(5)
> +#define PTP_GENERAL_CONFIG_CLOCK_EVENT_TOGGLE_	(6)
>  #define PTP_GENERAL_CONFIG_CLOCK_EVENT_X_SET_(channel, value) \
>  	(((value) & 0x7) << (1 + ((channel) << 2)))
>  #define PTP_GENERAL_CONFIG_RELOAD_ADD_X_(channel)	(BIT((channel) << 2))
> diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
> index ab6d719d40f0..9380e396f648 100644
> --- a/drivers/net/ethernet/microchip/lan743x_ptp.c
> +++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
> @@ -491,9 +491,10 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
>  	int perout_pin = 0;
>  	unsigned int index = perout_request->index;
>  	struct lan743x_ptp_perout *perout = &ptp->perout[index];
> +	int ret = 0;
>  
>  	/* Reject requests with unsupported flags */
> -	if (perout_request->flags)
> +	if (perout_request->flags & ~PTP_PEROUT_DUTY_CYCLE)
>  		return -EOPNOTSUPP;
>  
>  	if (on) {
> @@ -518,6 +519,7 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
>  		netif_warn(adapter, drv, adapter->netdev,
>  			   "Failed to reserve event channel %d for PEROUT\n",
>  			   index);
> +		ret = -EBUSY;
>  		goto failed;
>  	}
>  
> @@ -529,6 +531,7 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
>  		netif_warn(adapter, drv, adapter->netdev,
>  			   "Failed to reserve gpio %d for PEROUT\n",
>  			   perout_pin);
> +		ret = -EBUSY;
>  		goto failed;
>  	}
>  
> @@ -540,27 +543,93 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
>  	period_sec += perout_request->period.nsec / 1000000000;
>  	period_nsec = perout_request->period.nsec % 1000000000;
>  
> -	if (period_sec == 0) {
> -		if (period_nsec >= 400000000) {
> +	if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE) {
> +		struct timespec64 ts_on, ts_period;
> +		s64 wf_high, period64, half;
> +		s32 reminder;
> +
> +		ts_on.tv_sec = perout_request->on.sec;
> +		ts_on.tv_nsec = perout_request->on.nsec;
> +		wf_high = timespec64_to_ns(&ts_on);
> +		ts_period.tv_sec = perout_request->period.sec;
> +		ts_period.tv_nsec = perout_request->period.nsec;
> +		period64 = timespec64_to_ns(&ts_period);
> +
> +		if (period64 < 200) {
> +			netif_warn(adapter, drv, adapter->netdev,
> +				   "perout period too small, minimum is 200nS\n");
> +			ret = -EOPNOTSUPP;
> +			goto failed;
> +		}
> +		if (wf_high >= period64) {
> +			netif_warn(adapter, drv, adapter->netdev,
> +				   "pulse width must be smaller than period\n");
> +			ret = -EINVAL;
> +			goto failed;
> +		}
> +
> +		/* Check if we can do 50% toggle on an even value of period.
> +		 * If the period number is odd, then check if the requested
> +		 * pulse width is the same as one of pre-defined width values.
> +		 * Otherwise, return failure.
> +		 */
> +		half = div_s64_rem(period64, 2, &reminder);
> +		if (!reminder) {
> +			if (half == wf_high) {
> +				/* It's 50% match. Use the toggle option */
> +				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_TOGGLE_;
> +				/* In this case, devide period value by 2 */
> +				ts_period = ns_to_timespec64(div_s64(period64, 2));
> +				period_sec = ts_period.tv_sec;
> +				period_nsec = ts_period.tv_nsec;
> +
> +				goto program;
> +			}
> +		}
> +		/* if we can't do toggle, then the width option needs to be the exact match */
> +		if (wf_high == 200000000) {
>  			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
> -		} else if (period_nsec >= 20000000) {
> +		} else if (wf_high == 10000000) {
>  			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_10MS_;
> -		} else if (period_nsec >= 2000000) {
> +		} else if (wf_high == 1000000) {
>  			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS_;
> -		} else if (period_nsec >= 200000) {
> +		} else if (wf_high == 100000) {
>  			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_100US_;
> -		} else if (period_nsec >= 20000) {
> +		} else if (wf_high == 10000) {
>  			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_10US_;
> -		} else if (period_nsec >= 200) {
> +		} else if (wf_high == 100) {
>  			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_100NS_;
>  		} else {
>  			netif_warn(adapter, drv, adapter->netdev,
> -				   "perout period too small, minimum is 200nS\n");
> +				   "duty cycle specified is not supported\n");
> +			ret = -EOPNOTSUPP;
>  			goto failed;
>  		}
>  	} else {
> -		pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
> +		if (period_sec == 0) {
> +			if (period_nsec >= 400000000) {
> +				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
> +			} else if (period_nsec >= 20000000) {
> +				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_10MS_;
> +			} else if (period_nsec >= 2000000) {
> +				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS_;
> +			} else if (period_nsec >= 200000) {
> +				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_100US_;
> +			} else if (period_nsec >= 20000) {
> +				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_10US_;
> +			} else if (period_nsec >= 200) {
> +				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_100NS_;
> +			} else {
> +				netif_warn(adapter, drv, adapter->netdev,
> +					   "perout period too small, minimum is 200nS\n");
> +				ret = -EOPNOTSUPP;
> +				goto failed;
> +			}
> +		} else {
> +			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
> +		}
>  	}
> +program:
>  
>  	/* turn off by setting target far in future */
>  	lan743x_csr_write(adapter,
> @@ -599,7 +668,7 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
>  
>  failed:
>  	lan743x_ptp_perout_off(adapter, index);
> -	return -ENODEV;
> +	return ret;
>  }
>  
>  static int lan743x_ptpci_enable(struct ptp_clock_info *ptpci,

