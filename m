Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FE331043D
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBEEyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231200AbhBEEyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:54:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5457D64E0A;
        Fri,  5 Feb 2021 04:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612500803;
        bh=CRWJwuYsBRtN9D+23oejdsNM1PGQqUyPtpQvzj+c6oI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AlsjU/UIELLEyyQhrwxb+0O9qF28stgGhXNpIQRh4e0ARIdRfX9sSe8xcLT0tYA1e
         zq3Kp1kjl4HLNqy0W5KY6fBlOglNMVIYTDi8Y/X4mDL3mtg0F23aFIMk4XEiuTHb6J
         5MKf1jxPDid6raicxo5MdA2u5cGOUz9P17VhQt5Lv1EKseNV5sueoySK6PUZdzFi1a
         Ris/C8BhRB5q2pAODz7jlAN/eqzW/BfIoRRyKQqxBKDOMez1vpKTrsEp2WWOlOYZpX
         SmWTpaOTPdEt5LFAkw9+3PhJ8OWeRvIeMrovPgfNXn4UqRIu6EMlnuc+7ZMO36VlT9
         cKT8I643vJOBw==
Date:   Thu, 4 Feb 2021 20:53:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, elder@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] net: ipa: synchronize NAPI only for
 suspend
Message-ID: <20210204205322.792e079c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203152855.11866-3-elder@linaro.org>
References: <20210203152855.11866-1-elder@linaro.org>
        <20210203152855.11866-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 09:28:50 -0600 Alex Elder wrote:
>  int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop)
>  {
>  	struct gsi_channel *channel = &gsi->channel[channel_id];
> +	int ret;
>  
> -	return __gsi_channel_stop(channel, stop);
> +	/* Synchronize NAPI if successful, to ensure polling has finished. */
> +	ret = __gsi_channel_stop(channel, stop);
> +	if (!ret)
> +		napi_synchronize(&channel->napi);
> +
> +	return ret;

nit:

	ret = function();
	if (ret)
		return ret;

	/* success path: do something else */

	return 0;
