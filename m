Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A3A699E50
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 21:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjBPUyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 15:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBPUyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 15:54:19 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3849A2942C;
        Thu, 16 Feb 2023 12:54:18 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1676580856; bh=DxJ3PwID8VMXcAz7B6zsYbIWiA/Y3GfqOFQVN1W7o3I=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kh1VuL2CMuLgJKBTfBKzebi63agIngoKWZ+EMyiLPQqFEoYgiK2K9A8qAeeLuqrIz
         wtn3dSSPB1ajMBLEXeIya9OGSw/ne2mG1mHV3YHt3frjT7IvrOQ/OBBZpoRODG1H+M
         ahQywO6c13W91gKoU9tOMFQ4Zl2j56zi7Lhk5Lt7d66QFLYBPVlwcqSlTyDDW5HHsj
         8g4kXj8Vzwj0cDbZoPAY5T0vNMsnf4H4lYUZvwIzZSmJ9RCYZaAaN+uzn1Ps/NIlqH
         KFXqwwgCVbl7RoqOw0n9M6DTPcYs8VGCH4VxZppmIOnGK5u7vW3mbLMYbl5lFhTP4m
         l/13kJpJL/lJQ==
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
Subject: Re: [PATCH v2] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
In-Reply-To: <20230216192301.171225-1-pchelkin@ispras.ru>
References: <20230216192301.171225-1-pchelkin@ispras.ru>
Date:   Thu, 16 Feb 2023 21:54:15 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o7ptqqko.fsf@toke.dk>
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

> hif_dev->remain_skb is allocated and used exclusively in
> ath9k_hif_usb_rx_stream(). It is implied that an allocated remain_skb is
> processed and subsequently freed (in error paths) only during the next
> call of ath9k_hif_usb_rx_stream().
>
> So, if the urbs are deallocated between those two calls due to the device
> deinitialization or suspend, it is possible that ath9k_hif_usb_rx_stream()
> is not called next time and the allocated remain_skb is leaked. Our local
> Syzkaller instance was able to trigger that.
>
> remain_skb makes sense when receiving two consecutive urbs which are
> logically linked together, i.e. a specific data field from the first skb
> indicates a cached skb to be allocated, memcpy'd with some data and
> subsequently processed in the next call to ath9k_hif_usb_rx_stream(). Urbs
> deallocation supposedly makes that link irrelevant so we need to free the
> cached skb in those cases.
>
> Fix the leak by introducing a function to explicitly free remain_skb (if
> it is not NULL) when the rx urbs have been deallocated. remain_skb is NULL
> when it has not been allocated at all (hif_dev struct is kzalloced) or
> when it has been processed in next call to ath9k_hif_usb_rx_stream().
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thank you for the fix!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
