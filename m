Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB58F6E54DE
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 00:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjDQW5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDQW5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 18:57:06 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63CB2D63;
        Mon, 17 Apr 2023 15:57:02 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1681772220; bh=dq/Gw+2pk82vYsulgXR9w+XUW5AAutqhd3f452sOHM8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=bM3y9kGGTcbMdS0Y/QE6HcS4fIgBfK23Ef1137nVI6EWF6MdIZGFdt0ZKual8OGka
         KAmAsldkhilSy97uTU3g2wo5adWT/YrUfi3mV1tiGyfkRZYFiwV9g0n1h7adtoawou
         tN1qBboZdIXV8MZaDfyLMfquuUmEJ1S2hKsJ6jO6R98gdJAxPdiB7Fsv75rTrre9m1
         qGiek1+7FoXNrpVQBZgkdMhQ8B/x3JhfHdPK26sIVVBB22grXrvlea/e7tLHyz4N2o
         Epy7wGv64k2//5XNCCpdH333gm3IL4ZmRTS7O5GMgNX7zmRynQVmd0gZXUam1mgVsm
         nk0tZGXquOHFQ==
To:     =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, chunkeey@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath9k: of_init: add endian check
In-Reply-To: <CAKR-sGftiGWf86uE2QwbpjJ+H7oyM6=AsFpHaxFBviJBrdueBg@mail.gmail.com>
References: <20230417053509.4808-1-noltari@gmail.com>
 <20230417053509.4808-3-noltari@gmail.com> <87wn2ax3sq.fsf@toke.dk>
 <CAKR-sGftiGWf86uE2QwbpjJ+H7oyM6=AsFpHaxFBviJBrdueBg@mail.gmail.com>
Date:   Tue, 18 Apr 2023 00:56:59 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87jzyaw210.fsf@toke.dk>
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

=C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com> writes:

> El lun, 17 abr 2023 a las 11:21, Toke H=C3=B8iland-J=C3=B8rgensen
> (<toke@toke.dk>) escribi=C3=B3:
>>
>> =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com> writes:
>>
>> > BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
>> > partitions but it needs to be swapped in order to work, otherwise it f=
ails:
>> > ath9k 0000:00:01.0: enabling device (0000 -> 0002)
>> > ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
>> > ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
>> > ath: phy0: Unable to initialize hardware; initialization status: -22
>> > ath9k 0000:00:01.0: Failed to initialize device
>> > ath9k: probe of 0000:00:01.0 failed with error -22
>> >
>> > For compatibility with current devices the AH_NO_EEP_SWAP flag will be
>> > activated only when qca,endian-check isn't present in the device tree.
>> > This is because some devices have the magic values swapped but not the=
 actual
>> > EEPROM data, so activating the flag for those devices will break them.
>> >
>> > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
>> > ---
>> >  drivers/net/wireless/ath/ath9k/init.c | 5 +++--
>> >  1 file changed, 3 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wirel=
ess/ath/ath9k/init.c
>> > index 4f00400c7ffb..abde953aec61 100644
>> > --- a/drivers/net/wireless/ath/ath9k/init.c
>> > +++ b/drivers/net/wireless/ath/ath9k/init.c
>> > @@ -615,7 +615,6 @@ static int ath9k_nvmem_request_eeprom(struct ath_s=
oftc *sc)
>> >
>> >       ah->nvmem_blob_len =3D len;
>> >       ah->ah_flags &=3D ~AH_USE_EEPROM;
>> > -     ah->ah_flags |=3D AH_NO_EEP_SWAP;
>> >
>> >       return 0;
>> >  }
>> > @@ -688,9 +687,11 @@ static int ath9k_of_init(struct ath_softc *sc)
>> >                       return ret;
>> >
>> >               ah->ah_flags &=3D ~AH_USE_EEPROM;
>> > -             ah->ah_flags |=3D AH_NO_EEP_SWAP;
>> >       }
>> >
>> > +     if (!of_property_read_bool(np, "qca,endian-check"))
>> > +             ah->ah_flags |=3D AH_NO_EEP_SWAP;
>> > +
>>
>> So I'm not sure just setting (or not) this flag actually leads to
>> consistent behaviour. The code in ath9k_hw_nvram_swap_data() that reacts
>> to this flag does an endianness check before swapping, and the behaviour
>> of this check depends on the CPU endianness. However, the byte swapping
>> you're after here also swaps u8 members of the eeprom, so it's not
>> really a data endianness swap, and I don't think it should depend on the
>> endianness of the CPU?
>>
>> So at least conceptually, the magic byte check in
>> ath9k_hw_nvram_swap_data() is wrong; instead the byteswap check should
>> just be checking against the little-endian version of the firmware
>> (i.e., 0xa55a; I think that's what your device has, right?). However,
>> since we're setting an explicit per-device property anyway (in the
>> device tree), maybe it's better to just have that be an "eeprom needs
>> swapping" flag and do the swap unconditionally if it's set? I think that
>> would address Krzysztof's comment as well ("needs swapping" is a
>> hardware property, "do the check" is not).
>
> Yes, you're right, it's probably better to introduce a new and more
> clear flag that swaps the content inconditionally.
>
>>
>> Now, the question becomes whether the "check" code path is actually used
>> for anything today? The old mail thread I quoted in the other thread
>> seems to indicate it's not, but it's not quite clear from the code
>> whether there's currently any way to call into
>> ath9k_hw_nvram_swap_data() without the NO_EEP_SWAP flag being set?
>
> It's only used when endian_check is enabled in ath9k_platform_data:
> https://github.com/torvalds/linux/blob/6a8f57ae2eb07ab39a6f0ccad60c760743=
051026/drivers/net/wireless/ath/ath9k/init.c#L645

Right, I found that, but was looking for anywhere that sets it, and
couldn't find that anywhere. So this exists solely for the use of out of
tree code?

> We're currently using it on OpenWrt for bmips:
> https://github.com/Noltari/openwrt/blob/457549665fcb93667453ef48c50bf43ed=
dd776ef/target/linux/bmips/files/arch/mips/bmips/ath9k-fixup.c#L198-L199

Hmm, but that is arguably wrong in the same way, in that it triggers the
code in ath9k_hw_nvram_swap_data() which swaps or not depending on the
CPU endianness.

Is the magic byte check actually useful for that user? I.e., are there
some devices that have 0xa55a as magic bytes, and some that have 0x5aa5?
Or could the device tree flag in that fixup driver above be replaced
with the one you're proposing here?

-Toke
