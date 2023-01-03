Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FF765C890
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 22:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbjACVDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 16:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjACVDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 16:03:09 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5252FD;
        Tue,  3 Jan 2023 13:03:07 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1672779785; bh=8XlWB7q8ieR1Skm6kedaC7CKs/VrhNaK24zO4/mpaWc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=WQD6xWiFOItdmSw8E4C6MmPRZGzaa27UqsPNuxYzUfDtmk5Zv8Wpzfau4VHJptE4q
         tiLlYS3QEIezMbi4fRG4BcUe4j2SKMDkhF4Mc+rrS9APvCVHKPhTMt5wbFNjbXkixw
         CbQvAy6iXJdoIQAJXziSwBQEE5BuMnifNzlERhw0MMkRvvI2xD1E//2yhaI4cUdV1B
         VxfiDEYI1nIeV51lVrPcWaV8qiEoazJysGfA537AEKf3SahNDDmT9usDm/HQTWK+dd
         TU+OOOyMmeq+iJYPsDLo+RC52OuzHDoKKDtMgd9pltZFStTlgwrfbiU3HgO7djIOAt
         AqdyHNu9GPSPA==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] wifi: ath9k: hif_usb: clean up skbs if
 ath9k_hif_usb_rx_stream() fails
In-Reply-To: <20230103143029.273695-1-pchelkin@ispras.ru>
References: <20230103143029.273695-1-pchelkin@ispras.ru>
Date:   Tue, 03 Jan 2023 22:03:05 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <875ydn49h2.fsf@toke.dk>
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

> Syzkaller detected a memory leak of skbs in ath9k_hif_usb_rx_stream().
> While processing skbs in ath9k_hif_usb_rx_stream(), the already allocated
> skbs in skb_pool are not freed if ath9k_hif_usb_rx_stream() fails. If we
> have an incorrect pkt_len or pkt_tag, the skb is dropped and all the
> associated skb_pool buffers should be cleaned, too.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: 6ce708f54cc8 ("ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream")
> Fixes: 44b23b488d44 ("ath9k: hif_usb: Reduce indent 1 column")
> Reported-by: syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
> v1->v2: added Reported-by tag
>
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 1a2e0c7eeb02..d02cec114280 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -586,14 +586,14 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>  
>  		if (pkt_tag != ATH_USB_RX_STREAM_MODE_TAG) {
>  			RX_STAT_INC(hif_dev, skb_dropped);
> -			return;
> +			goto invalid_pkt;
>  		}
>  
>  		if (pkt_len > 2 * MAX_RX_BUF_SIZE) {
>  			dev_err(&hif_dev->udev->dev,
>  				"ath9k_htc: invalid pkt_len (%x)\n", pkt_len);
>  			RX_STAT_INC(hif_dev, skb_dropped);
> -			return;
> +			goto invalid_pkt;
>  		}
>  
>  		pad_len = 4 - (pkt_len & 0x3);
> @@ -654,6 +654,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>  				 skb_pool[i]->len, USB_WLAN_RX_PIPE);
>  		RX_STAT_INC(hif_dev, skb_completed);
>  	}
> +	return;
> +invalid_pkt:
> +	for (i = 0; i < pool_index; i++)
> +		kfree_skb(skb_pool[i]);
> +	return;

Hmm, so in the other error cases (if SKB allocation fails), we just
'goto err' and call the receive handler for the packets already in
skb_pool. Why can't we do the same here?

Also, I think there's another bug in that function, which this change
will make worse? Specifically, in the start of that function,
hif_dev->remain_skb is moved to skb_pool[0], but not cleared from
hif_dev itself. So if we then hit the invalid check and free it, the
next time the function is called, we'll get the same remain_skb pointer,
which has now been freed.

So I think we'll need to clear out hif_dev->remain_skb after moving it
to skb_pool. Care to add that as well?

-Toke
