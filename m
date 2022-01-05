Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000AB485A04
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244042AbiAEU2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:28:02 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:48778 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244044AbiAEU1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 15:27:49 -0500
Received: from [IPV6:2003:e9:d722:f5b8:9ccb:8d7f:17cf:c65d] (p200300e9d722f5b89ccb8d7f17cfc65d.dip0.t-ipconnect.de [IPv6:2003:e9:d722:f5b8:9ccb:8d7f:17cf:c65d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id D7F44C0879;
        Wed,  5 Jan 2022 21:27:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1641414464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dpMLHMR//JIi9iap6ZA0k6rlKpmAkoFNdKjlI8yBUV8=;
        b=j/3cQkOsdp6F3vHHOFYXCmZERpfQYl6N31/6fSnsALAkzOzBrSO8UE5IKpFMZDW0svfl8z
        BlC/2l5i0ZSWlLnPpo+JoBlFhLYBi26FXUMnfypMLtG1RFOl7Och+d7CDTpjMFra4K2eIk
        xVJMMvZ5+/H3yfB6YoEmncA+BFl7IG50lBa7fOWVUijZk4WMvQZVjpwiGMA8XVguzWwv86
        CfYjfSdMiycbCXUrSZOB7Xi6TInzDhRBQ+uOXEEW/VyTbjxPajjTeXOz50lXcRhQOoC7f3
        2yHLm1/1hDh3ztuRFl7gEQ80Z+FHNsyQn+NRD+uNxUZawydZmMjppRGOGGhqDw==
Message-ID: <4186d48a-ea7e-39c1-d1fa-1db3f6627a3a@datenfreihafen.org>
Date:   Wed, 5 Jan 2022 21:27:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
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
> Old USB API is prone to uninit value bugs if error handling is not
> correct. Let's move atusb to use new USB API to
> 
> 	1) Make code more simple, since new API does not require memory
> 	   to be allocates via kmalloc()
> 
> 	2) Defend driver from usb-related uninit value bugs.
> 
> 	3) Make code more modern and simple
> 
> This patch removes atusb usb wrappers as Greg suggested [0], this will make
> code more obvious and easier to understand over time, and replaces old
> API calls with new ones.
> 
> Also this patch adds and updates usb related error handling to prevent
> possible uninit value bugs in future
> 
> Link: https://lore.kernel.org/all/YdL0GPxy4TdGDzOO@kroah.com/ [0]
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Only build tested.

Gave it a first quick run on real hardware here. Besides one small bug 
(see below) it looked good.

Will give it a bit more testing over the next days.



> @@ -881,14 +819,27 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
>   	u8 man_id_0, man_id_1, part_num, version_num;
>   	const char *chip;
>   	struct ieee802154_hw *hw = atusb->hw;
> +	int ret;
>   
> -	man_id_0 = atusb_read_reg(atusb, RG_MAN_ID_0);
> -	man_id_1 = atusb_read_reg(atusb, RG_MAN_ID_1);
> -	part_num = atusb_read_reg(atusb, RG_PART_NUM);
> -	version_num = atusb_read_reg(atusb, RG_VERSION_NUM);
> +	ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
> +				   0, RG_MAN_ID_0, &man_id_0, 1, 1000, GFP_KERNEL);
> +	if (ret < 0)
> +		return ret;
>   
> -	if (atusb->err)
> -		return atusb->err;
> +	ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
> +				   0, RG_MAN_ID_1, &man_id_1, 1, 1000, GFP_KERNEL);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
> +				   0, RG_PART_NUM, &atusb, 1, 1000, GFP_KERNEL);

This needs to be written to &part_num and not &atusb.

Pretty nice for a first blind try without hardware. Thanks.

Will let you know if I find anything else from testing.

regards
Stefan Schmidt
