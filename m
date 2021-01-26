Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0493048CD
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388146AbhAZFja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732099AbhAZD2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 22:28:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76B8A2256F;
        Tue, 26 Jan 2021 03:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611631654;
        bh=h90NenU3bBs6nTKkn9ChQTzjwguZxyJs58vaCJSQLNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nhGDtX46VXV2foWEDNgtLYmlLT/xAvPnv6y+NuXkYh8VjwCZMv4mPwCCqUMDCZg/z
         gLdW5lr7Djbb04Y+Sdvo9O4udfCmMEujxxgvx8u14lexfBq/htW0rHYJfrBtvXE5FB
         9t5LQbAQGerlD9pPXmbUphG8g+UKX2I41dgsxydRsuQHQEwfKkFk7tNOa911aYSuof
         TA+jNhWSDn7Hr1MdaKGX6E1DA768akqe+3yHEJLRKiMt3mP4pB7TpX+KabKF6m0sD+
         PAuzQNJanWbwSVyG3/IZFiLv9224en9dPxUPs8HYlvFfMB9PMNhtWHPClvZtv81qtA
         BU281FaAs3HWg==
Date:   Mon, 25 Jan 2021 19:27:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, elder@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] net: ipa: drop packet if status has valid
 tag
Message-ID: <20210125192733.38ff2ac5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125212947.17097-4-elder@linaro.org>
References: <20210125212947.17097-1-elder@linaro.org>
        <20210125212947.17097-4-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 15:29:44 -0600 Alex Elder wrote:
> Introduce ipa_endpoint_status_tag(), which returns true if received
> status indicates its tag field is valid.  The endpoint parameter is
> not yet used.
> 
> Call this from ipa_status_drop_packet(), and drop the packet if the
> status indicates the tag was valid.  Pass the endpoint pointer to
> ipa_status_drop_packet(), and rename it ipa_endpoint_status_drop().
> The endpoint will be used in the next patch.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

> @@ -1172,11 +1175,22 @@ static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
>  	return false;	/* Don't skip this packet, process it */
>  }
>  
> +static bool ipa_endpoint_status_tag(struct ipa_endpoint *endpoint,
> +				    const struct ipa_status *status)
> +{
> +	return !!(status->mask & IPA_STATUS_MASK_TAG_VALID_FMASK);

drivers/net/ipa/ipa_endpoint.c:1181:25: warning: restricted __le16 degrades to integer

> +}
> +
