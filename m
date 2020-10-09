Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943C52891B0
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388620AbgJITZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731624AbgJITZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:25:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F30F2227E;
        Fri,  9 Oct 2020 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602271520;
        bh=IPurk/y+BcseTsMG4/Z+rmmiS0eDb8be0oLiqIgNpwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BkR60xsnrpj3S7TY+22JeC5HLVQkeNK2MgG1ItxhU6EQsygAMAP6BrXgpQnqTA8ba
         KBoLq6HIJUE/bjPAgxtFntHHU9TGIBXUeger105TZMbV/eV7luyzRlM/pBfgUUM9sc
         287vZExfHff6Hi5sd08rxH/lVqaVP4l16ZnPzlfM=
Date:   Fri, 9 Oct 2020 12:25:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        mka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: ipa: only clear hardware state if setup
 has completed
Message-ID: <20201009122517.02a53088@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006213047.31308-2-elder@linaro.org>
References: <20201006213047.31308-1-elder@linaro.org>
        <20201006213047.31308-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 16:30:46 -0500 Alex Elder wrote:
> In the setup phase of initialization, GSI firmware gets loaded
> and initialized, and the AP command TX and default RX endpoints
> get set up.  Until that happens, IPA commands must not be issued
> to the hardware.
> 
> If the modem crashes, we stop endpoint channels and perform a
> number of other activities to clear modem-related IPA state,
> including zeroing filter and routing tables (using IPA commands).
> This is a bug if setup is not complete.  We should also not be
> performing the other cleanup activity in that case either.
> 
> Fix this by returning immediately when handling a modem crash if we
> haven't completed setup.
> 
> Fixes: a646d6ec9098 ("soc: qcom: ipa: modem and microcontroller")
> Tested-by: Matthias Kaehlcke <mka@chromium.org>
> Signed-off-by: Alex Elder <elder@linaro.org>

> diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
> index e34fe2d77324e..dd5b89c5cb2d4 100644
> --- a/drivers/net/ipa/ipa_modem.c
> +++ b/drivers/net/ipa/ipa_modem.c
> @@ -285,6 +285,9 @@ static void ipa_modem_crashed(struct ipa *ipa)
>  	struct device *dev = &ipa->pdev->dev;
>  	int ret;
>  
> +	if (!ipa->setup_complete)
> +		return;
> +
>  	ipa_endpoint_modem_pause_all(ipa, true);
>  
>  	ipa_endpoint_modem_hol_block_clear_all(ipa);

The only call site already checks setup_complete, so this is not needed,
no?

$ git grep -C2 ipa_modem_crashed\(
drivers/net/ipa/ipa_modem.c-
drivers/net/ipa/ipa_modem.c-/* Treat a "clean" modem stop the same as a crash */
drivers/net/ipa/ipa_modem.c:static void ipa_modem_crashed(struct ipa *ipa)
drivers/net/ipa/ipa_modem.c-{
drivers/net/ipa/ipa_modem.c-    struct device *dev = &ipa->pdev->dev;
--
drivers/net/ipa/ipa_modem.c-                     notify_data->crashed ? "crashed" : "stopping");
drivers/net/ipa/ipa_modem.c-            if (ipa->setup_complete)
drivers/net/ipa/ipa_modem.c:                    ipa_modem_crashed(ipa);
drivers/net/ipa/ipa_modem.c-            break;
drivers/net/ipa/ipa_modem.c-
