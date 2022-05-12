Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FFD524EAC
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354636AbiELNsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354631AbiELNsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:48:36 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE310644D3;
        Thu, 12 May 2022 06:48:31 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1652363309; bh=blX63fNBGtPLVWob9X9ETslO5YPtKIw3mZLNDG9ks5o=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hiHqRnVtYx6ket6hb/L9fydLguY2ye051mhuoiXDA5jDZFBfKkkJ1KeAoonLIjgCH
         WTj4ARFuwPxQhjuHT/+6cwgbtQK0/oLt0Pav9QO4DzESWOOLir93VPSQKQm2wkrrcX
         hMPCtLTOfWNeRe4F+wUoE6NEPGJdHIAvgzyh/ldeUivozBfMmt1rjATTBWWvMpiqC3
         BGPwUWvOjKW4r9f9+Yq3xDpJDTN+r/KAttVWMAaT4EIL+6IL/KP0/GMqvSWPYUgJia
         jIl3k+snTsfi4XPG7jMj6GyADw0GFACFO51PoeJK8A07kykVrMdzhYLqx06udRGz4R
         Xu1ZUqg8PbXiw==
To:     Pavel Skripkin <paskripkin@gmail.com>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <246ba9d2-2afd-c6c0-9cc2-9e5598407c70@gmail.com>
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87r14yhq4q.fsf@toke.dk> <246ba9d2-2afd-c6c0-9cc2-9e5598407c70@gmail.com>
Date:   Thu, 12 May 2022 15:48:29 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ilqahnf6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> Hi Toke,
>
> On 5/12/22 15:49, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Pavel Skripkin <paskripkin@gmail.com> writes:
>>=20
>>> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
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
>>> all *_STAT_* macros NULL save.
>>>
>>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>>> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotma=
il.com
>>> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotma=
il.com
>>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>>=20
>> Could you link the original syzbot report in the commit message as well,
>
> Sure! See links below
>
> use-after-free bug:
> https://syzkaller.appspot.com/bug?id=3D6ead44e37afb6866ac0c7dd121b4ce07cb=
665f60
>
> NULL deref bug:
> https://syzkaller.appspot.com/bug?id=3Db8101ffcec107c0567a0cd8acbbacec91e=
9ee8de
>
> I can add them in commit message if you want :)

Yes, please do!

>> please? Also that 'tested-by' implies that syzbot run-tested this? How
>> does it do that; does it have ath9k_htc hardware?
>>=20
>
> No, it uses CONFIG_USB_RAW_GADGET and CONFIG_USB_DUMMY_HCD for gadgets=20
> for emulating usb devices.
>
> Basically these things "connect" fake USB device with random usb ids=20
> from hardcoded table and try to do various things with usb driver

Ah, right, hence the failures I suppose? Makes sense.

> [snip]
>
>>> -#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.=
c++)
>>> -#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_sta=
ts.c +=3D a)
>>> -#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_sta=
ts.c++)
>>> -#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_=
stats.c +=3D a)
>>> +#define __STAT_SAVE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
>>> +#define TX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debu=
g.tx_stats.c++)
>>> +#define TX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->d=
ebug.tx_stats.c +=3D a)
>>> +#define RX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debu=
g.skbrx_stats.c++)
>>> +#define RX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->d=
ebug.skbrx_stats.c +=3D a)
>>>  #define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
>>=20
>> s/SAVE/SAFE/ here and in the next patch (and the commit message).
>>=20
>
> Oh, sorry about that! Will update in next version

Thanks! Other than that, I think the patch looks reasonable...

-Toke
