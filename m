Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995CF6E3789
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 12:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjDPKuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 06:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjDPKuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 06:50:08 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E65B213D;
        Sun, 16 Apr 2023 03:50:05 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1681642201; bh=krAhv5Gdwtdch69DnlxztO7O9LULBCdgNHqdroaY+zY=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=oQSseEAnlJSPJBRBLUq7qHz+19X9VBWLONfuWb+/7Q8caquelMihfqLSosRcsANXS
         JCZUI0KGKoLi3+KPlXKIZaRyxJCcvp08Mwe9C3qjBHTIO0kINrN70dN9HDrGVCv/8f
         AAzu1Zgbql2ZgE3A6P3pYZKZSU+Do9ci+3XCnneuhtJszdq+wyj1Sy6vgKNOJfKHKd
         qe1JjRGBF+e6wJ2L4zMUOK70TTEwLiUbhDl8NJYtv4vajkCV933ratGa/DA/A3DIY1
         HIe0npy+t7/XwIpOEte+qcLEuDUHJ9x1j5hGfeE/FmE/+sGlKh+w39x8lZlPb5RKP0
         ql7X5cAUF4/Kw==
To:     Christian Lamparter <chunkeey@gmail.com>,
        =?utf-8?Q?=C3=81lvaro_Fern?= =?utf-8?Q?=C3=A1ndez?= Rojas 
        <noltari@gmail.com>, f.fainelli@gmail.com, jonas.gorski@gmail.com,
        nbd@nbd.name, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: fix calibration data endianness
In-Reply-To: <03a74fbb-dd77-6283-0b08-6a9145a2f4f6@gmail.com>
References: <20230415150542.2368179-1-noltari@gmail.com>
 <87leitxj4k.fsf@toke.dk> <a7895e73-70a3-450d-64f9-8256c9470d25@gmail.com>
 <03a74fbb-dd77-6283-0b08-6a9145a2f4f6@gmail.com>
Date:   Sun, 16 Apr 2023 12:50:00 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <874jpgxfs7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> writes:

> On 4/15/23 18:02, Christian Lamparter wrote:
>> Hi,
>>=20
>> On 4/15/23 17:25, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com> writes:
>>>
>>>> BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
>>>> partitions but it needs to be swapped in order to work, otherwise it f=
ails:
>>>> ath9k 0000:00:01.0: enabling device (0000 -> 0002)
>>>> ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
>>>> ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
>>>> ath: phy0: Unable to initialize hardware; initialization status: -22
>>>> ath9k 0000:00:01.0: Failed to initialize device
>>>> ath9k: probe of 0000:00:01.0 failed with error -22
>>>
>>> How does this affect other platforms? Why was the NO_EEP_SWAP flag set
>>> in the first place? Christian, care to comment on this?
>>=20
>> I knew this would come up. I've written what I know and remember in the
>> pull-request/buglink.
>>=20
>> Maybe this can be added to the commit?
>> Link: https://github.com/openwrt/openwrt/pull/12365
>>=20
>> | From what I remember, the ah->ah_flags |=3D AH_NO_EEP_SWAP; was copied=
 verbatim from ath9k_of_init's request_eeprom.
>>=20
>> Since the existing request_firmware eeprom fetcher code set the flag,
>> the nvmem code had to do it too.
>>=20
>> In theory, I don't think that not setting the AH_NO_EEP_SWAP flag will c=
ause havoc.
>> I don't know if there are devices out there, which have a swapped magic =
(which is
>> used to detect the endianess), but the caldata is in the correct endiann=
es (or
>> vice versa - Magic is correct, but data needs swapping).
>>=20
>> I can run tests with it on a Netzgear WNDR3700v2 (AR7161+2xAR9220)
>> and FritzBox 7360v2 (Lantiq XWAY+AR9220). (But these worked fine.
>> So I don't expect there to be a new issue there).
>
> Nope! This is a classic self-own!... Well at least, this now gets documen=
ted!
>
> Here are my findings. Please excuse the overlong lines.
>
> ## The good news / AVM FritzBox 7360v2 ##
>
> The good news: The AVM FritzBox 7360v2 worked the same as before.

[...]

> ## The not so good news / Netgear WNDR3700v2 ##
>
> But not the Netgar WNDR3700v2. One WiFi (The 2.4G, reported itself now as=
 the 5G @0000:00:11.0 -
> doesn't really work now), and the real 5G WiFi (@0000:00:12.0) failed wit=
h:
> "phy1: Bad EEPROM VER 0x0001 or REV 0x06e0"

[...]

Alright, so IIUC, we have a situation where some devices only work
*with* the flag, and some devices only work *without* the flag? So we'll
need some kind of platform-specific setting? Could we put this in the
device trees, or is there a better solution?

-Toke
