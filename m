Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D633A6E4391
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjDQJWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDQJW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:22:27 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9759240C6;
        Mon, 17 Apr 2023 02:21:46 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1681723271; bh=zxAtmVjE1QkeQ/zLqggs+pv59RGEGM9/BqmB27YqErA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=k4opQFXwX6NFBtUnZvJeOlasOPCBS1ZVU0UF4tDkBdh8MrESmp/+3HYwZhQPcFYlp
         3K0jeLOWA/l4WqZ/bx6v1ELdeZurFySqP00tFCB/UCTRGDgl3pgNL9GLEiObG0BQol
         8PX8ajnCVtbHjgDLiTywjFF/G74yOSQxlNwnHbvqGAll5HKsD/kZzQ6dE4XNhT1bh0
         8RMOqChAkrWY7O+lZurhBjTqm9thnUKw49P/1tY4h8yrbapq6mwypQXeDvjL//Us2g
         WqsCBuZbwv3Dq20Oc3UazMPL3Y5eX9ablQHo4bJmUsAwNojh773tBv44HgR+ITtRFq
         /8NGHx17CpCYA==
To:     =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez?= Rojas <noltari@gmail.com>,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, chunkeey@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez?= Rojas <noltari@gmail.com>
Subject: Re: [PATCH v2 2/2] ath9k: of_init: add endian check
In-Reply-To: <20230417053509.4808-3-noltari@gmail.com>
References: <20230417053509.4808-1-noltari@gmail.com>
 <20230417053509.4808-3-noltari@gmail.com>
Date:   Mon, 17 Apr 2023 11:21:09 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87wn2ax3sq.fsf@toke.dk>
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

> BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
> partitions but it needs to be swapped in order to work, otherwise it fail=
s:
> ath9k 0000:00:01.0: enabling device (0000 -> 0002)
> ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
> ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
> ath: phy0: Unable to initialize hardware; initialization status: -22
> ath9k 0000:00:01.0: Failed to initialize device
> ath9k: probe of 0000:00:01.0 failed with error -22
>
> For compatibility with current devices the AH_NO_EEP_SWAP flag will be
> activated only when qca,endian-check isn't present in the device tree.
> This is because some devices have the magic values swapped but not the ac=
tual
> EEPROM data, so activating the flag for those devices will break them.
>
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/init.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless=
/ath/ath9k/init.c
> index 4f00400c7ffb..abde953aec61 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -615,7 +615,6 @@ static int ath9k_nvmem_request_eeprom(struct ath_soft=
c *sc)
>=20=20
>  	ah->nvmem_blob_len =3D len;
>  	ah->ah_flags &=3D ~AH_USE_EEPROM;
> -	ah->ah_flags |=3D AH_NO_EEP_SWAP;
>=20=20
>  	return 0;
>  }
> @@ -688,9 +687,11 @@ static int ath9k_of_init(struct ath_softc *sc)
>  			return ret;
>=20=20
>  		ah->ah_flags &=3D ~AH_USE_EEPROM;
> -		ah->ah_flags |=3D AH_NO_EEP_SWAP;
>  	}
>=20=20
> +	if (!of_property_read_bool(np, "qca,endian-check"))
> +		ah->ah_flags |=3D AH_NO_EEP_SWAP;
> +

So I'm not sure just setting (or not) this flag actually leads to
consistent behaviour. The code in ath9k_hw_nvram_swap_data() that reacts
to this flag does an endianness check before swapping, and the behaviour
of this check depends on the CPU endianness. However, the byte swapping
you're after here also swaps u8 members of the eeprom, so it's not
really a data endianness swap, and I don't think it should depend on the
endianness of the CPU?

So at least conceptually, the magic byte check in
ath9k_hw_nvram_swap_data() is wrong; instead the byteswap check should
just be checking against the little-endian version of the firmware
(i.e., 0xa55a; I think that's what your device has, right?). However,
since we're setting an explicit per-device property anyway (in the
device tree), maybe it's better to just have that be an "eeprom needs
swapping" flag and do the swap unconditionally if it's set? I think that
would address Krzysztof's comment as well ("needs swapping" is a
hardware property, "do the check" is not).

Now, the question becomes whether the "check" code path is actually used
for anything today? The old mail thread I quoted in the other thread
seems to indicate it's not, but it's not quite clear from the code
whether there's currently any way to call into
ath9k_hw_nvram_swap_data() without the NO_EEP_SWAP flag being set?

WDYT?

-Toke
