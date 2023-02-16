Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E752699BD8
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBPSGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjBPSGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:06:07 -0500
X-Greylist: delayed 5630 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Feb 2023 10:06:01 PST
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7972B4D632;
        Thu, 16 Feb 2023 10:06:01 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1676570759; bh=h/RD0fpEx2CpDUljHxUoo7rG/kbdPtYbs9Wh4An/URk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=fXKa8EEdneUshdOIHIUvGSnB0wJhszNzXkS6L/A1S3Eg04chpoTpnp34UdfTZR/Vq
         QoYSTH32cTGCNpT583i3nQ96GlvufAx+oRmJjW1wo25OgVXbnyXSZC74tIKHoxV/Yh
         /g0lmj2w0LuuKYjyg3FF/Z01BNIarEjxmHIWDGKOiZhAcNiW5RgGZt48tJqiGWxzvo
         jWZ9usp576tzE8zbQjyMQny9jHpzNx1vEoL+LRjpeaxSV1X4aOTxYQlzPVny2YAjHT
         w07884k7CDBfiE8xr9cQjvNZNkSxkppN7k0bnVkIYt5GAjlErNDq0wQseOic2rNi1C
         COTC/0EWabzqA==
To:     Fedor Pchelkin <pchelkin@ispras.ru>
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
Subject: Re: [PATCH 1/1] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
In-Reply-To: <5d67552f-88dd-7bbe-ebeb-888d1efad985@ispras.ru>
References: <20230212145238.123055-1-pchelkin@ispras.ru>
 <20230212145238.123055-2-pchelkin@ispras.ru> <87a61dsi1n.fsf@toke.dk>
 <5d67552f-88dd-7bbe-ebeb-888d1efad985@ispras.ru>
Date:   Thu, 16 Feb 2023 19:05:59 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ttzlqyd4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> On 16.02.2023 19:15, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>  > Erm, does this actually fix the leak? AFAICT, ath9k_hif_usb_dev_deinit=
()
>  > is only called on the error path of ath9k_hif_usb_firmware_cb(), not
>  > when the device is subsequently torn down in
>  > ath9k_htc_disconnect_device()?
>
> ath9k_hif_usb_dev_deinit() is also called inside
> ath9k_hif_usb_disconnect().

No it's not, as of:

f099c5c9e2ba ("wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect(=
)")

I guess you're looking at an older tree? Please base your patches on an
up-to-date ath-next tree.

> I see it to be the only place wherehif_dev is freed (apart from an
> early error path), so the current patchimplementation actually fixes
> the leak. However, as you have noticed, itis not probably the best
> place to put the deallocation: we need to clearthe cached skb not only
> when freeing the device but in urbs deallocationcase, too - in order
> to avoid its irrelevant processing later.
>
>  > I think the right place to put this is probably inside
>  > ath9k_hif_usb_dealloc_urbs()? That gets called on USB suspend as well,
>  > but it seems to me that if we're suspending the device to an extent th=
at
>  > we're deallocating the urbs, we should be clearing out the cached skb =
in
>  > remain_skb anyway?
>  >
>  > -Toke
>
> Thank you for the advice! As I can see, remain_skb makes sense when
> receiving two consecutive urbs which are logically linked together, i.e.
> a specific data field from the first skb indicates a cached skb to be
> allocated, memcpy'd with some data and subsequently processed in the
> next call to rx callback (see 6ce708f54cc8 ("ath9k: Fix out-of-bound
> memcpy in ath9k_hif_usb_rx_stream")). Urbs deallocation, I suppose,
> makes that link irrelevant.
>
> So I agree with you that remain_skb freeing should be done when
> deallocating the urbs. I would just place that specifically into
> ath9k_hif_usb_dealloc_rx_urbs() as remain_skb is associated with rx
> urbs.

SGTM.

> RX_STAT_INC(hif_dev, skb_dropped), I think, should be also called when
> freeing afilled remain_skb?

Well, if this is mostly something that happens if the device is going
away I'm not sure that anyone will actually see that; but I suppose if
it happens on suspend, the stat increase may be useful, and it shouldn't
hurt otherwise, so sure, let's add that :)

-Toke
