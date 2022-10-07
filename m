Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082CB5F7D3E
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 20:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJGSWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 14:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJGSWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 14:22:18 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14552C0680;
        Fri,  7 Oct 2022 11:22:13 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665166931; bh=1yO3exAMwv1y1zHEN85+kNkgbL2K5cdBLW0UF5GZsE0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=UOaUNb8l+xPl1i2ImLsV4Awx4Qqd6teobZXrn2Hcn6POxqE8+RwtGaU9xMqwJrBfv
         +DL/Hzo0mwHsd7MP1FH1LPDbR75C1XaUQiELp/eeeSMQBT2j+mtYjuZMkMHeExL9IF
         YYJurUKLPVgwyxsLl2GdZbS4awDOx+EpavhwTbLWbymawoD/0G4+mr4t06Ypj0sPsl
         9OB7N69oqLKSy6hnrJdH4rpzH3QlOQnNbi+DXIqLoSY/sW6/kT5co89+r4vJbb7yH7
         SzosSUrl1jNiVlwEsczXAax4G4Gan3tOkZevY4tnlB29dzZjVX7sjdrR8uN40TXKsH
         8j42Rnlg86uQg==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brooke Basile <brookebasile@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] ath9k: hif_usb: fix memory leak of urbs in
 ath9k_hif_usb_dealloc_tx_urbs()
In-Reply-To: <20220725151359.283704-1-pchelkin@ispras.ru>
References: <20220725151359.283704-1-pchelkin@ispras.ru>
Date:   Fri, 07 Oct 2022 20:22:11 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871qrjtrxo.fsf@toke.dk>
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

> Syzkaller reports a long-known leak of urbs in
> ath9k_hif_usb_dealloc_tx_urbs().
>
> The cause of the leak is that usb_get_urb() is called but usb_free_urb()
> (or usb_put_urb()) is not called inside usb_kill_urb() as urb->dev or
> urb->ep fields have not been initialized and usb_kill_urb() returns
> immediately.
>
> The patch removes trying to kill urbs located in hif_dev->tx.tx_buf
> because hif_dev->tx.tx_buf is not supposed to contain urbs which are in
> pending state (the pending urbs are stored in hif_dev->tx.tx_pending).
> The tx.tx_lock is acquired so there should not be any changes in the list.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_=
urb() and usb_kill_anchored_urbs()")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
