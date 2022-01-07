Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D63487875
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347658AbiAGNqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:46:45 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:52756 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiAGNqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 08:46:45 -0500
Received: from [IPV6:2003:e9:d724:9af0:641c:922:9a06:5c2c] (p200300e9d7249af0641c09229a065c2c.dip0.t-ipconnect.de [IPv6:2003:e9:d724:9af0:641c:922:9a06:5c2c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 5A894C005A;
        Fri,  7 Jan 2022 14:46:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1641563203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ta7MOcivJtNYj5c/HQIfAoE0zlPdJosOBmR89DAXB8=;
        b=jP5tLhBwcj7/nUdpKppFv9+9bSM986kOXpBVgu0qRTYHr99NNpNQScwVwOHOPvbnWdR53x
        SMWeniQS9VoqhH7l7NRu6wGnwDbLaz+wxg/wz456Gk+TRO9kfUt+geOoOm4oH/3ZeQRZlr
        cI0Xaywxu4aWBdcx9OYxJ0v8niAj/m8myM66/xy8bZG/QWgZQdRJlOT1a3LQMQEd7rysv1
        kM8rfnm6k9KFbnzqd+ssl59BD9tyTgFuRMhuOoPvlto4hz61MdKTRoX52/jSkjOkwbiVtk
        aKRJa0i2x66L8x4UQOSPX9b1GSdybR6kS8ncMOfvvsPgcri4yf2PZaTJrTfeEA==
Message-ID: <2439d9ab-133f-0338-24f9-a9a5cd2065a3@datenfreihafen.org>
Date:   Fri, 7 Jan 2022 14:46:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH -next] ieee802154: atusb: move to new USB API
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220105144947.12540-1-paskripkin@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220105144947.12540-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 05.01.22 15:49, Pavel Skripkin wrote:
> @@ -176,9 +105,13 @@ static int atusb_read_subreg(struct atusb *lp,
>   			     unsigned int addr, unsigned int mask,
>   			     unsigned int shift)
>   {
> -	int rc;
> +	int rc, ret;
> +
> +	ret = usb_control_msg_recv(lp->usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,

You are changing the meaning of the rc variable away from a return code. 
Its the register value now. I would prefer if we change the name to 
something like reg to reflect this new meaning.

> +				   0, addr, &rc, 1, 1000, GFP_KERNEL);
> +	if (ret < 0)
> +		return ret;
>   
> -	rc = atusb_read_reg(lp, addr);
>   	rc = (rc & mask) >> shift;
>   
>   	return rc;

The change above and the bug fix I reported the other day is all that is 
missing for this to be applied. You want to send a v2 with this changes 
or do you prefer me doing them here locally and apply?

regards
Stefan Schmidt
