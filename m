Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37375699B90
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBPRvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjBPRvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:51:01 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424F34FAA1;
        Thu, 16 Feb 2023 09:50:59 -0800 (PST)
Received: from [192.168.0.114] (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id D772141C6128;
        Thu, 16 Feb 2023 17:50:51 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru D772141C6128
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1676569852;
        bh=e3tCXX/R9TdDBPRqJLAKxiWfhMEinCRHGUJtUQ5W1rE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nphF2uLzQsTIh+KQ0Rtc45fcBj6YlouP+YrT/ilWfMbodcqjcPQyleRI3KXfjYyEm
         toiSG3Ik9y9Lb1C3xvka2IbKnlF2/YG9lkj7CegPDvYxh08u/x3t2LhaYDZRsPHdT3
         cP8OJYyo4uMP0nMiRfkmxyYkrLVK4nPVeuXiVB+w=
Message-ID: <5d67552f-88dd-7bbe-ebeb-888d1efad985@ispras.ru>
Date:   Thu, 16 Feb 2023 20:50:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/1] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@kernel.org>,
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
References: <20230212145238.123055-1-pchelkin@ispras.ru>
 <20230212145238.123055-2-pchelkin@ispras.ru> <87a61dsi1n.fsf@toke.dk>
From:   Fedor Pchelkin <pchelkin@ispras.ru>
In-Reply-To: <87a61dsi1n.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.02.2023 19:15, Toke Høiland-Jørgensen wrote:
 > Erm, does this actually fix the leak? AFAICT, ath9k_hif_usb_dev_deinit()
 > is only called on the error path of ath9k_hif_usb_firmware_cb(), not
 > when the device is subsequently torn down in
 > ath9k_htc_disconnect_device()?

ath9k_hif_usb_dev_deinit() is also called inside
ath9k_hif_usb_disconnect(). I see it to be the only place wherehif_dev is
freed (apart from an early error path), so the current patchimplementation
actually fixes the leak. However, as you have noticed, itis not probably
the best place to put the deallocation: we need to clearthe cached skb
not only when freeing the device but in urbs deallocationcase, too - in
order to avoid its irrelevant processing later.

 > I think the right place to put this is probably inside
 > ath9k_hif_usb_dealloc_urbs()? That gets called on USB suspend as well,
 > but it seems to me that if we're suspending the device to an extent that
 > we're deallocating the urbs, we should be clearing out the cached skb in
 > remain_skb anyway?
 >
 > -Toke

Thank you for the advice! As I can see, remain_skb makes sense when
receiving two consecutive urbs which are logically linked together, i.e.
a specific data field from the first skb indicates a cached skb to be
allocated, memcpy'd with some data and subsequently processed in the
next call to rx callback (see 6ce708f54cc8 ("ath9k: Fix out-of-bound
memcpy in ath9k_hif_usb_rx_stream")). Urbs deallocation, I suppose,
makes that link irrelevant.

So I agree with you that remain_skb freeing should be done when
deallocating the urbs. I would just place that specifically into
ath9k_hif_usb_dealloc_rx_urbs() as remain_skb is associated with rx
urbs.

RX_STAT_INC(hif_dev, skb_dropped), I think, should be also called when
freeing afilled remain_skb?

---
Regards,

Fedor
