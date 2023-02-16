Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9B7699A83
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjBPQwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBPQwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:52:10 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Feb 2023 08:52:09 PST
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F555422F
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:52:09 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1676564133; bh=LtOqw6Liu2Qd487IpRFryDo1qNR5M58ZhCvzkyOx7kY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=qPEdJaoOfTKEpYVFEf0ioaeyxbQbv6jO+H5nKcaBkqLJi6OoNzgTEhhaKfQILGnDi
         SZQ/0We5NmKist916zor1GoYemRbA1Kc4QuAx34cXA7agu9yo6cNr4Wm9UnaXhbx1b
         +Lvhe4StNEfcj4WQNiGPv2xuvnOcgXkagkfCXZGKIOLJp53kzg/ujuQJNp+TZWGHSf
         /eEAKE5B7BRjOlA4X5e3jB0Gz9X99GfYrF+O5tFYxDgt23FikVWh5FhF1qWPSTbdVo
         IijtvvLcquXI+X0Ho/l847EuVoeAyo6X0kUJqDkYn/yg1baqlawR0YwPk4Agvq8VCq
         X/PNk3WdydnTw==
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 1/1] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
In-Reply-To: <20230212145238.123055-2-pchelkin@ispras.ru>
References: <20230212145238.123055-1-pchelkin@ispras.ru>
 <20230212145238.123055-2-pchelkin@ispras.ru>
Date:   Thu, 16 Feb 2023 17:15:32 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a61dsi1n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> hif_dev->remain_skb is allocated and used exclusively in
> ath9k_hif_usb_rx_stream(). It is implied that an allocated remain_skb is
> processed and subsequently freed (in error paths) only during the next
> call of ath9k_hif_usb_rx_stream().
>
> So, if the device is deinitialized between those two calls or if the skb
> contents are incorrect, it is possible that ath9k_hif_usb_rx_stream() is
> not called next time and the allocated remain_skb is leaked. Our local
> Syzkaller instance was able to trigger that.
>
> Fix the leak by introducing a function to explicitly free remain_skb (if
> it is not NULL) when the device is being deinitialized. remain_skb is NULL
> when it has not been allocated at all (hif_dev struct is kzalloced) or
> when it has been proccesed in next call to ath9k_hif_usb_rx_stream().
>
> Proper spinlocks are held to prevent possible concurrent access to
> remain_skb from the interrupt context ath9k_hif_usb_rx_stream(). These
> accesses should not happen as rx_urbs have been deallocated before but
> it prevents a dangerous race condition in these cases.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index f521dfa2f194..e03ab972edf7 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -534,6 +534,23 @@ static struct ath9k_htc_hif hif_usb = {
>  	.send = hif_usb_send,
>  };
>  
> +/* Need to free remain_skb allocated in ath9k_hif_usb_rx_stream
> + * in case ath9k_hif_usb_rx_stream wasn't called next time to
> + * process the buffer and subsequently free it.
> + */
> +static void ath9k_hif_usb_free_rx_remain_skb(struct hif_device_usb *hif_dev)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&hif_dev->rx_lock, flags);
> +	if (hif_dev->remain_skb) {
> +		dev_kfree_skb_any(hif_dev->remain_skb);
> +		hif_dev->remain_skb = NULL;
> +		hif_dev->rx_remain_len = 0;
> +	}
> +	spin_unlock_irqrestore(&hif_dev->rx_lock, flags);
> +}
> +
>  static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>  				    struct sk_buff *skb)
>  {
> @@ -1129,6 +1146,7 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
>  static void ath9k_hif_usb_dev_deinit(struct hif_device_usb *hif_dev)
>  {
>  	ath9k_hif_usb_dealloc_urbs(hif_dev);
> +	ath9k_hif_usb_free_rx_remain_skb(hif_dev);
>  }

Erm, does this actually fix the leak? AFAICT, ath9k_hif_usb_dev_deinit()
is only called on the error path of ath9k_hif_usb_firmware_cb(), not
when the device is subsequently torn down in
ath9k_htc_disconnect_device()?

I think the right place to put this is probably inside
ath9k_hif_usb_dealloc_urbs()? That gets called on USB suspend as well,
but it seems to me that if we're suspending the device to an extent that
we're deallocating the urbs, we should be clearing out the cached skb in
remain_skb anyway?

-Toke
