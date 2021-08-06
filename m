Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32C83E20F2
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 03:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhHFB0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 21:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhHFB0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 21:26:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78B2F611C5;
        Fri,  6 Aug 2021 01:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628213189;
        bh=QvIgHk9TGLUizh9HoaiT/w3IVfdthAAaKnipBI+IXqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aJyfd6vf4uGNUZ/z9XjXxkobtvILX3aPKo4R42Ju9t4tJ30ximrZFRSnOkAE85M4V
         y4om5owCrwWGzyldynuTAeLFkbipXJKypkUFFt/Szom14eMqSwbzmXMoQnORAH0gjA
         IgsPCjnX8K5EtbV8FfgDRnPYoODPWZ1tavyPS5ek5T343R52JcED2myQIlsiHwOikL
         07hWjYj5K0MpaarYRttjohJynzeK4UNZp1rXUMDCiZtECI1CD0JMK6oIZ9tBR3jEU9
         aBDKXMkbjDfserKT3Z0ftZkkdqnQTdWmw+kBKaEcwqOaB6XJmhIFA58kaXSUyA9h68
         tp5Tp7y3nfRhw==
Date:   Thu, 5 Aug 2021 18:26:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: ipa: don't suspend/resume modem if
 not up
Message-ID: <20210805182628.02ebf355@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210804153626.1549001-2-elder@linaro.org>
References: <20210804153626.1549001-1-elder@linaro.org>
        <20210804153626.1549001-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Aug 2021 10:36:21 -0500 Alex Elder wrote:
> The modem network device is set up by ipa_modem_start().  But its
> TX queue is not actually started and endpoints enabled until it is
> opened.
> 
> So avoid stopping the modem network device TX queue and disabling
> endpoints on suspend or stop unless the netdev is marked UP.  And
> skip attempting to resume unless it is UP.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

You said in the cover letter that in practice this fix doesn't matter.
It seems trivial to test so perhaps it doesn't and we should leave the
code be? Looking at dev->flags without holding rtnl_lock() seems
suspicious, drivers commonly put the relevant portion of suspend/resume
routines under rtnl_lock()/rtnl_unlock() (although to be completely
frank IDK if it's actually possible for concurrent suspend +
open/close to happen).

Are there any callers of ipa_modem_stop() which don't hold rtnl_lock()? 

> diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
> index 4ea8287e9d237..663a610979e70 100644
> --- a/drivers/net/ipa/ipa_modem.c
> +++ b/drivers/net/ipa/ipa_modem.c
> @@ -178,6 +178,9 @@ void ipa_modem_suspend(struct net_device *netdev)
>  	struct ipa_priv *priv = netdev_priv(netdev);
>  	struct ipa *ipa = priv->ipa;
>  
> +	if (!(netdev->flags & IFF_UP))
> +		return;
> +
>  	netif_stop_queue(netdev);
>  
>  	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
> @@ -194,6 +197,9 @@ void ipa_modem_resume(struct net_device *netdev)
>  	struct ipa_priv *priv = netdev_priv(netdev);
>  	struct ipa *ipa = priv->ipa;
>  
> +	if (!(netdev->flags & IFF_UP))
> +		return;
> +
>  	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
>  	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
>  
> @@ -265,9 +271,11 @@ int ipa_modem_stop(struct ipa *ipa)
>  	/* Prevent the modem from triggering a call to ipa_setup() */
>  	ipa_smp2p_disable(ipa);
>  
> -	/* Stop the queue and disable the endpoints if it's open */
> +	/* Clean up the netdev and endpoints if it was started */
>  	if (netdev) {
> -		(void)ipa_stop(netdev);
> +		/* If it was opened, stop it first */
> +		if (netdev->flags & IFF_UP)
> +			(void)ipa_stop(netdev);
>  		ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]->netdev = NULL;
>  		ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]->netdev = NULL;
>  		ipa->modem_netdev = NULL;

