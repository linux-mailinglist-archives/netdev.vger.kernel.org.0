Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370DE54C273
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 09:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244781AbiFOHKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 03:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiFOHKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 03:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B6C2A423;
        Wed, 15 Jun 2022 00:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D8EEB81BD5;
        Wed, 15 Jun 2022 07:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8D5C34115;
        Wed, 15 Jun 2022 07:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655277017;
        bh=mtGHET4UWHTA/01BWBiFQyeYgHdFSuen2FbpnN+C85Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ex8ca7+RD4bQgHhoZ4JMqXDpSkQlSvG9uAgUb4pnyBznybFan9r1TWYy5KGNVHyE5
         C5v1NyZuBq4Ecrl65S9fkJ+QCXuQQ1WQZ4G0kTF4l8VzyUR/cOD8ZuEsqBxsz1ry8m
         7Rr0Bhi6NN3M0niPcNasBfN657Bca5JHMDvRqBuYsc6Gg1h5L0Cm5GPQGi4tpVJPa4
         mQvjgQNZvgmCsR2K0uklsPT6uq2yIxSAuEsuy3FwPelfaarhm3PngU6H0hDyfDej34
         adbrpa6wbH+48fCIQGcNPKWNo0YhwsZBoNFNtOW2vZp5eME9K5mLp2XVMmASR5zedu
         7TWu4Q6w2wnyg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v6 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <87o7yvzf33.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Tue, 14 Jun 2022 12:58:40 +0200")
References: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
        <87o7yvzf33.fsf@toke.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Wed, 15 Jun 2022 10:10:10 +0300
Message-ID: <87k09ipfl9.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Pavel Skripkin <paskripkin@gmail.com> writes:
>
>> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
>> problem was in incorrect htc_handle->drv_priv initialization.
>>
>> Probable call trace which can trigger use-after-free:
>>
>> ath9k_htc_probe_device()
>>   /* htc_handle->drv_priv =3D priv; */
>>   ath9k_htc_wait_for_target()      <--- Failed
>>   ieee80211_free_hw()		   <--- priv pointer is freed
>>
>> <IRQ>
>> ...
>> ath9k_hif_usb_rx_cb()
>>   ath9k_hif_usb_rx_stream()
>>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>>
>> In order to not add fancy protection for drv_priv we can move
>> htc_handle->drv_priv initialization at the end of the
>> ath9k_htc_probe_device() and add helper macro to make
>> all *_STAT_* macros NULL safe, since syzbot has reported related NULL
>> deref in that macros [1]
>>
>> Link: https://syzkaller.appspot.com/bug?id=3D6ead44e37afb6866ac0c7dd121b=
4ce07cb665f60 [0]
>> Link: https://syzkaller.appspot.com/bug?id=3Db8101ffcec107c0567a0cd8acbb=
acec91e9ee8de [1]
>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmai=
l.com
>> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmai=
l.com
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>
> Alright, since we've heard no more objections and the status quo is
> definitely broken, let's get this merged and we can follow up with any
> other fixes as necessary...
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

I'm wondering should these go to -rc or -next? Has anyone actually
tested these with real hardware? (syzbot testing does not count) With
the past bad experience with syzbot fixes I'm leaning towards -next to
have more time to fix any regressions.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
