Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EDD688FA4
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 07:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjBCGZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 01:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjBCGZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 01:25:56 -0500
Received: from smtp.smtpout.orange.fr (smtp-11.smtpout.orange.fr [80.12.242.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3664ED33
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 22:25:54 -0800 (PST)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id NpW9pzOCvftdHNpW9puWnL; Fri, 03 Feb 2023 07:25:52 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 03 Feb 2023 07:25:52 +0100
X-ME-IP: 86.243.2.178
Message-ID: <dd1c45ad-7af2-8df1-a3ab-0db99dd25934@wanadoo.fr>
Date:   Fri, 3 Feb 2023 07:25:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] wifi: plfxlc: fix potential NULL pointer dereference in
 plfxlc_usb_wreq_async()
To:     Zheng Wang <zyytlz.wz@163.com>, srini.raju@purelifi.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230203041644.581649-1-zyytlz.wz@163.com>
Content-Language: fr
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20230203041644.581649-1-zyytlz.wz@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/02/2023 à 05:16, Zheng Wang a écrit :
> Although the usb_alloc_urb uses GFP_ATOMIC, tring to make sure the memory
>   allocated not to be NULL. But in some low-memory situation, it's still
>   possible to return NULL. It'll pass urb as argument in
>   usb_fill_bulk_urb, which will finally lead to a NULL pointer dereference.
> 
> Fix it by adding additional check.
> 
> Note that, as a bug found by static analysis, it can be a false
> positive or hard to trigger.
> 
> Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
> 
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
>   drivers/net/wireless/purelifi/plfxlc/usb.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
> index 76d0a778636a..ac149aa64908 100644
> --- a/drivers/net/wireless/purelifi/plfxlc/usb.c
> +++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
> @@ -496,10 +496,17 @@ int plfxlc_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
>   	struct urb *urb = usb_alloc_urb(0, GFP_ATOMIC);
>   	int r;
>   
> +	if (!urb) {
> +		r = -ENOMEM;
> +		kfree(urb);

Hi,
why kfree() in such a case?

CJ

> +		goto out;
> +	}
>   	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
>   			  (void *)buffer, buffer_len, complete_fn, context);
>   
>   	r = usb_submit_urb(urb, GFP_ATOMIC);
> +
> +out:
>   	if (r)
>   		dev_err(&udev->dev, "Async write submit failed (%d)\n", r);
>   

