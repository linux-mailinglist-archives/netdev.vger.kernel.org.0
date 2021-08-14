Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025013EBF16
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 02:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhHNArY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 20:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235870AbhHNArX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 20:47:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC27A60FC3;
        Sat, 14 Aug 2021 00:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628902016;
        bh=9UkrQu4UERxCxlPh6JNL/rrhNPf5QAK/8kvdoQ9pYlE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jG6eZpNhqrJNfmqQiiMT3LHqqvP6kL1hYxidkbhSoY3Jk07mNl2osjbyR8Ki0RcZB
         /ug0nR+uTouXqqxYyV/oBwsMbxCeWj8Ym9jTExK/3c88inrQjbrS4bdn6gwJamD5vz
         7v47owpqLzDKfYFH4TbTkV3Rkz3coYfWH0CRVOkhJuSJv/hrYEZMH8/GduPw1c/9it
         bI7dJ9NCSx8EBPy1hHoLgXdmH+Bp/n9E3EE43uvKRrFpyCJQQOvnoayjjNgq2+Wl30
         aAQSdW5//XwImtY4PhoBiHJblNyyZLFdBfKHV7eBY/DD12/2BY5yUVMjKmDvAs+Mxr
         GjPxxzzvXqsWQ==
Date:   Fri, 13 Aug 2021 17:46:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] net: ipa: ensure hardware has power in
 ipa_start_xmit()
Message-ID: <20210813174655.1d13b524@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812195035.2816276-5-elder@linaro.org>
References: <20210812195035.2816276-1-elder@linaro.org>
        <20210812195035.2816276-5-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 14:50:33 -0500 Alex Elder wrote:
> +	/* The hardware must be powered for us to transmit */
> +	dev = &ipa->pdev->dev;
> +	ret = pm_runtime_get(dev);
> +	if (ret < 1) {
> +		/* If a resume won't happen, just drop the packet */
> +		if (ret < 0 && ret != -EINPROGRESS) {
> +			pm_runtime_put_noidle(dev);
> +			goto err_drop_skb;
> +		}

This is racy, what if the pm work gets scheduled on another CPU and
calls wake right here (i.e. before you call netif_stop_queue())?
The queue may never get woken up?

> +		/* No power (yet).  Stop the network stack from transmitting
> +		 * until we're resumed; ipa_modem_resume() arranges for the
> +		 * TX queue to be started again.
> +		 */
> +		netif_stop_queue(netdev);
> +
> +		(void)pm_runtime_put(dev);
> +
> +		return NETDEV_TX_BUSY;
