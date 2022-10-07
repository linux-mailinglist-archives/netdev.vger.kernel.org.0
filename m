Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5A5F7C6A
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 19:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiJGRq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 13:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJGRqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 13:46:23 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535799E2D2;
        Fri,  7 Oct 2022 10:46:18 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665164776; bh=mRLk8Wk+DDiVinm8rQolXV20DOAXdU/fxJk+haqSNg0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Z+uOfdxlAZNS5YyD9TIMUcFoN6qrYTZnk3Jk2J/IaGfOAgh2OmTmcB9xZC+c2Lpy1
         J9y0x/Ei3rASNCTVvc3abmH9HnZI/6v55IV9Jg0ppN3VX5IzfFxnRyI1Cyqob+Oab+
         QtdtGhQx3EV65QLmbdvheXPC2Uum2SLx/+cI75N4pI1lTS+su+sAiB0opSX9KSn0Jm
         b2iKtHZpdT9QhBW6NwskIjp37yGcpOcAZxy9RbHDRqzbAfWFdesl6yeP+o62Vx4unq
         fRiRXMiTYyYlxhoYQy0lJB1haq8lTj79rjGZwm3DKR8rwI9CtffWVBaBht/Ppu5neb
         6gq6oyaOblmzA==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Sujith Manoharan <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] ath9k: hif_usb: Fix use-after-free in
 ath9k_hif_usb_reg_in_cb()
In-Reply-To: <20220728162149.212306-1-pchelkin@ispras.ru>
References: <20220728162149.212306-1-pchelkin@ispras.ru>
Date:   Fri, 07 Oct 2022 19:46:16 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ilkvcys7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> It is possible that skb is freed in ath9k_htc_rx_msg(), then
> usb_submit_urb() fails and we try to free skb again. It causes
> use-after-free bug. Moreover, if alloc_skb() fails, urb->context becomes
> NULL but rx_buf is not freed and there can be a memory leak.
>
> The patch removes unnecessary nskb and makes skb processing more clear: it
> is supposed that ath9k_htc_rx_msg() either frees old skb or passes its
> managing to another callback function.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: 3deff76095c4 ("ath9k_htc: Increase URB count for REG_IN pipe")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 518deb5098a2..b70128d1594d 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -708,14 +708,13 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
>  	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
>  	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
>  	struct sk_buff *skb = rx_buf->skb;
> -	struct sk_buff *nskb;
>  	int ret;
>  
>  	if (!skb)
>  		return;
>  
>  	if (!hif_dev)
> -		goto free;
> +		goto free_skb;
>  
>  	switch (urb->status) {
>  	case 0:
> @@ -724,7 +723,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
>  	case -ECONNRESET:
>  	case -ENODEV:
>  	case -ESHUTDOWN:
> -		goto free;
> +		goto free_skb;
>  	default:
>  		skb_reset_tail_pointer(skb);
>  		skb_trim(skb, 0);
> @@ -740,20 +739,19 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
>  				 skb->len, USB_REG_IN_PIPE);
>  
>  
> -		nskb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
> -		if (!nskb) {
> +		skb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
> +		if (!skb) {

The fix LGTM, but could you please add a comment here stating that the
ath9k_htc_rx_msg() call above frees the skb (either here, or as part of
the comment above the call to that function)? Also, please get rid of
the double blank line while you're fixing things up...

-Toke
