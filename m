Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADBE54C437
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 11:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiFOJFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 05:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiFOJFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 05:05:23 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0FB3980F;
        Wed, 15 Jun 2022 02:05:22 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1655283921; bh=mZJkc3EtpYZjHnwrFglpnwJJ1Hj8zbOLiuV4Bh+jD24=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rTztdNLj2oECJXYk09U7wcYFzV90dyQIpL+L/VaZhamY54SGd3n4uQL2C/WlNctWU
         6ZXx0QFdfMO1/NTh4MN/MnQKB+Ijwx83f6Zqx9dXS7FMxjgJ+6AzP1bcNmn4gNmyOz
         AK7rP5M/PhBdHWEsNZdk69NrWn741jrwF+2RnSx53RBlZg4CYsnoHWu11V78zOARY5
         uPMKw4cxbDj5LOiB+BJ0aTFwOPpNFN1p2uOKQFKCdbZ994eIdIXWG2qqjVVey2JnYS
         JYH2N9qa8D0uC4748Rfzkq74mox10F2ONbrWza91LMwlJfprFJw90ljJmdU1toN2jp
         pQZRQ4eCMDhwA==
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v6 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <87k09ipfl9.fsf@kernel.org>
References: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
 <87o7yvzf33.fsf@toke.dk> <87k09ipfl9.fsf@kernel.org>
Date:   Wed, 15 Jun 2022 11:05:20 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87tu8mxpnz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>
>> Pavel Skripkin <paskripkin@gmail.com> writes:
>>
>>> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
>>> problem was in incorrect htc_handle->drv_priv initialization.
>>>
>>> Probable call trace which can trigger use-after-free:
>>>
>>> ath9k_htc_probe_device()
>>>   /* htc_handle->drv_priv =3D priv; */
>>>   ath9k_htc_wait_for_target()      <--- Failed
>>>   ieee80211_free_hw()		   <--- priv pointer is freed
>>>
>>> <IRQ>
>>> ...
>>> ath9k_hif_usb_rx_cb()
>>>   ath9k_hif_usb_rx_stream()
>>>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>>>
>>> In order to not add fancy protection for drv_priv we can move
>>> htc_handle->drv_priv initialization at the end of the
>>> ath9k_htc_probe_device() and add helper macro to make
>>> all *_STAT_* macros NULL safe, since syzbot has reported related NULL
>>> deref in that macros [1]
>>>
>>> Link: https://syzkaller.appspot.com/bug?id=3D6ead44e37afb6866ac0c7dd121=
b4ce07cb665f60 [0]
>>> Link: https://syzkaller.appspot.com/bug?id=3Db8101ffcec107c0567a0cd8acb=
bacec91e9ee8de [1]
>>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>>> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotma=
il.com
>>> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotma=
il.com
>>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>>
>> Alright, since we've heard no more objections and the status quo is
>> definitely broken, let's get this merged and we can follow up with any
>> other fixes as necessary...
>>
>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> I'm wondering should these go to -rc or -next? Has anyone actually
> tested these with real hardware? (syzbot testing does not count) With
> the past bad experience with syzbot fixes I'm leaning towards -next to
> have more time to fix any regressions.

Hmm, good question. From Takashi's comment on v5, it seems like distros
are going to backport it anyway, so in that sense it probably doesn't
matter that much?

In any case I think it has a fairly low probability of breaking real
users' setup (how often is that error path on setup even hit?), but I'm
OK with it going to -next to be doubleplus-sure :)

-Toke
