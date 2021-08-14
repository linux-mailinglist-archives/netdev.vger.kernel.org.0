Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4243EBF13
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 02:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbhHNAof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 20:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235330AbhHNAoe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 20:44:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25BF760FBF;
        Sat, 14 Aug 2021 00:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628901847;
        bh=G+5OzDZx9dP3JaM+1Iut/Gwy5KjuYkh5MvoFa/6DAiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S3WAg5bG7oKZVEqbXdEc89pXe9i185EftwfLL9JslUgsAvRMMvbXM/XPlTK9fehrV
         sO5VTUc5AhwVvVRjj+gz8jMSyOiLDsFPzjz0CUv3OqulU3HS+3RXng76JBZzspLXoH
         6swN2jMNl3nUyz2u8TWeTuApILBd3MObVL2bOUZMTouIEp+HurWyJb22aDrfxcdUPo
         yEp39ji8PHn7m+hsWRuy3WMDhUlqvW/GVbKumCkWZtWqK4b+tJ5+DsA6cB/gL+rmqt
         J7y8DgCfmbH2GmqRrU3FUe2046l9zZl9FTgL2aTIKgW0snTwFvxUTDYMByvgE08OPp
         WMts+b3NUo8qA==
Date:   Fri, 13 Aug 2021 17:44:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] net: ipa: re-enable transmit in PM WQ
 context
Message-ID: <20210813174406.5e7fc350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812195035.2816276-4-elder@linaro.org>
References: <20210812195035.2816276-1-elder@linaro.org>
        <20210812195035.2816276-4-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 14:50:32 -0500 Alex Elder wrote:
> +/**
> + * ipa_modem_wake_queue_work() - enable modem netdev queue
> + * @work:	Work structure
> + *
> + * Re-enable transmit on the modem network device.  This is called
> + * in (power management) work queue context, scheduled when resuming
> + * the modem.
> + */
> +static void ipa_modem_wake_queue_work(struct work_struct *work)
> +{
> +	struct ipa_priv *priv = container_of(work, struct ipa_priv, work);
> +
> +	netif_wake_queue(priv->ipa->modem_netdev);
> +}
> +
>  /** ipa_modem_resume() - resume callback for runtime_pm
>   * @dev: pointer to device
>   *
> @@ -205,7 +226,8 @@ void ipa_modem_resume(struct net_device *netdev)
>  	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
>  	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
>  
> -	netif_wake_queue(netdev);
> +	/* Arrange for the TX queue to be restarted */
> +	(void)queue_pm_work(&priv->work);
>  }

Why move the wake call to a work queue, tho? It's okay to call it 
from any context.
