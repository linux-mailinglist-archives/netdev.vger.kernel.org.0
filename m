Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFEC1248D9
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfLROAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:00:54 -0500
Received: from first.geanix.com ([116.203.34.67]:41288 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfLROAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:00:54 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 9468D443;
        Wed, 18 Dec 2019 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576677592; bh=kuycr8hED4rp8SK3gJ4VVTSvYPoy8oaGmuBCQhjvU6Q=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=bXOAxeIgZU8LtULSqTnAgDi6lSV2j3BLQfUGQKKh854IiJXgQVLJvPelDoqZ80U6v
         KanoQzRgKsKvr0Hr93fIKS/wt6icixT/97W+a3JFdGaImrOeluSd5kDdU+GxFq2BS7
         jFftA9C2gMwcYS11k8dpvtBJ+ZI6f5MtFMOmk0rlN0w8GpASJQHlDgT9yGH4CkHHed
         B8jvxdE4YlC0vUkd3IOq6aH3ujJ5u1rc/21tZFsZeyrL4E9aICq/JCRHbJZfBpi+Qg
         MCN6nXTB88HyeCC/5hRG3Wm301zj/DkLrp2RZKBj+40KEusrjONKm0VF3PJ+6Nblox
         DdCFLoTP+PuTg==
Subject: Re: [PATCH V2 2/2] can: flexcan: disable clocks during stop mode
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
 <20191210085721.9853-2-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <e9afd8dd-1953-307e-6b5d-a8236381690b@geanix.com>
Date:   Wed, 18 Dec 2019 15:00:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210085721.9853-2-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/2019 10.00, Joakim Zhang wrote:
> Disable clocks during CAN in stop mode.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
> ------
> ChangeLog:
> 	V1->V2: * moving the pm_runtime_force_suspend() call for both
> 	cases "device_may_wakeup()" and "!device_may_wakeup()" into the
> 	flexcan_noirq_suspend() handler
> ---
>   drivers/net/can/flexcan.c | 32 +++++++++++++++++++-------------
>   1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 6c1ccf9f6c08..63b2f47635cf 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -1718,10 +1718,6 @@ static int __maybe_unused flexcan_suspend(struct device *device)
>   			if (err)
>   				return err;
>   
> -			err = pm_runtime_force_suspend(device);
> -			if (err)
> -				return err;
> -
>   			err = pinctrl_pm_select_sleep_state(device);
>   			if (err)
>   				return err;
> @@ -1751,10 +1747,6 @@ static int __maybe_unused flexcan_resume(struct device *device)
>   			if (err)
>   				return err;
>   
> -			err = pm_runtime_force_resume(device);
> -			if (err)
> -				return err;
> -
>   			err = flexcan_chip_start(dev);
>   			if (err)
>   				return err;
> @@ -1786,9 +1778,16 @@ static int __maybe_unused flexcan_noirq_suspend(struct device *device)
>   {
>   	struct net_device *dev = dev_get_drvdata(device);
>   	struct flexcan_priv *priv = netdev_priv(dev);
> +	int err;
>   
> -	if (netif_running(dev) && device_may_wakeup(device))
> -		flexcan_enable_wakeup_irq(priv, true);
> +	if (netif_running(dev)) {
> +		if (device_may_wakeup(device))
> +			flexcan_enable_wakeup_irq(priv, true);
> +
> +		err = pm_runtime_force_suspend(device);
> +		if (err)
> +			return err;
> +	}
>   
>   	return 0;
>   }
> @@ -1799,11 +1798,18 @@ static int __maybe_unused flexcan_noirq_resume(struct device *device)
>   	struct flexcan_priv *priv = netdev_priv(dev);
>   	int err;
>   
> -	if (netif_running(dev) && device_may_wakeup(device)) {
> -		flexcan_enable_wakeup_irq(priv, false);
> -		err = flexcan_exit_stop_mode(priv);
> +	if (netif_running(dev)) {
> +		err = pm_runtime_force_resume(device);
>   		if (err)
>   			return err;
> +
> +		if (device_may_wakeup(device)) {
> +			flexcan_enable_wakeup_irq(priv, false);
> +
> +			err = flexcan_exit_stop_mode(priv);
> +			if (err)
> +				return err;
> +		}
>   	}
>   
>   	return 0;
> 
