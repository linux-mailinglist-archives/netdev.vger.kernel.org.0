Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CCD6E3C36
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 23:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjDPVtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 17:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjDPVtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 17:49:42 -0400
X-Greylist: delayed 39576 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 Apr 2023 14:49:39 PDT
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732852113;
        Sun, 16 Apr 2023 14:49:39 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1681681777; bh=/dZxFov0kKMekXQ4mAEBxqM+dB5IiCHd/Tlf9+QLYaI=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=Of0yv5IcxyGnQUqYVFewlixL1iIH0Me9MU71YH/oKH5oxpJuGz3YIvDxhRFZJadp7
         nf2rCh0jL6P8CeJbzSN/TzUikSZ4MYxWXD0eo7PZe3CKMB/cRqCrvRsQ4AfSwGdDbQ
         uLax9/u8Pc8XHX3TGBfByRONtpNCvY5xWm8qjRI4Q87vuYQR0NuWol4qSzdfM1AMJP
         7kKUU+ZVJc0FviaoAIbaXzGYA2UAjNrzq9l12B/xyAKHPEkiXZnwXEEdrn2o/BKDOe
         XIJCXFDhaBHl1CrpuGphsFD/DVYZ2Ux17e4eHGFofR/1wcDBLypip+78UglNG4XLxV
         jwurhXeeK4PrA==
To:     Christian Lamparter <chunkeey@gmail.com>,
        =?utf-8?Q?=C3=81lvaro_Fern?= =?utf-8?Q?=C3=A1ndez?= Rojas 
        <noltari@gmail.com>, f.fainelli@gmail.com, jonas.gorski@gmail.com,
        nbd@nbd.name, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: fix calibration data endianness
In-Reply-To: <8caecebf-bd88-dffe-7749-b79b7ea61cc7@gmail.com>
References: <20230415150542.2368179-1-noltari@gmail.com>
 <87leitxj4k.fsf@toke.dk> <a7895e73-70a3-450d-64f9-8256c9470d25@gmail.com>
 <03a74fbb-dd77-6283-0b08-6a9145a2f4f6@gmail.com> <874jpgxfs7.fsf@toke.dk>
 <8caecebf-bd88-dffe-7749-b79b7ea61cc7@gmail.com>
Date:   Sun, 16 Apr 2023 23:49:35 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871qkjxztc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> writes:

> On 4/16/23 12:50, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Christian Lamparter <chunkeey@gmail.com> writes:
>>=20
>>> On 4/15/23 18:02, Christian Lamparter wrote:
>>>> Hi,
>>>>
>>>> On 4/15/23 17:25, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>> =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com> writes:
>>>>>
>>>>>> BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
>>>>>> partitions but it needs to be swapped in order to work, otherwise it=
 fails:
>>>>>> ath9k 0000:00:01.0: enabling device (0000 -> 0002)
>>>>>> ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
>>>>>> ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
>>>>>> ath: phy0: Unable to initialize hardware; initialization status: -22
>>>>>> ath9k 0000:00:01.0: Failed to initialize device
>>>>>> ath9k: probe of 0000:00:01.0 failed with error -22
>>>>>
>>>>> How does this affect other platforms? Why was the NO_EEP_SWAP flag set
>>>>> in the first place? Christian, care to comment on this?
>>>>
>>>> I knew this would come up. I've written what I know and remember in the
>>>> pull-request/buglink.
>>>>
>>>> Maybe this can be added to the commit?
>>>> Link: https://github.com/openwrt/openwrt/pull/12365
>>>>
>>>> | From what I remember, the ah->ah_flags |=3D AH_NO_EEP_SWAP; was copi=
ed verbatim from ath9k_of_init's request_eeprom.
>>>>
>>>> Since the existing request_firmware eeprom fetcher code set the flag,
>>>> the nvmem code had to do it too.
>>>>
>>>> In theory, I don't think that not setting the AH_NO_EEP_SWAP flag will=
 cause havoc.
>>>> I don't know if there are devices out there, which have a swapped magi=
c (which is
>>>> used to detect the endianess), but the caldata is in the correct endia=
nnes (or
>>>> vice versa - Magic is correct, but data needs swapping).
>>>>
>>>> I can run tests with it on a Netzgear WNDR3700v2 (AR7161+2xAR9220)
>>>> and FritzBox 7360v2 (Lantiq XWAY+AR9220). (But these worked fine.
>>>> So I don't expect there to be a new issue there).
>>>
>>> Nope! This is a classic self-own!... Well at least, this now gets docum=
ented!
>>>
>>> Here are my findings. Please excuse the overlong lines.
>>>
>>> ## The good news / AVM FritzBox 7360v2 ##
>>>
>>> The good news: The AVM FritzBox 7360v2 worked the same as before.
>>=20
>> [...]
>>=20
>>> ## The not so good news / Netgear WNDR3700v2 ##
>>>
>>> But not the Netgar WNDR3700v2. One WiFi (The 2.4G, reported itself now =
as the 5G @0000:00:11.0 -
>>> doesn't really work now), and the real 5G WiFi (@0000:00:12.0) failed w=
ith:
>>> "phy1: Bad EEPROM VER 0x0001 or REV 0x06e0"
>>=20
>> [...]
>>=20
>> Alright, so IIUC, we have a situation where some devices only work
>> *with* the flag, and some devices only work *without* the flag? So we'll
>> need some kind of platform-specific setting? Could we put this in the
>> device trees, or is there a better solution?
>
> Depends. From what I gather, ath9k calls this "need_swap". Thing is,
> the flag in the EEPROM is called "AR5416_EEPMISC_BIG_ENDIAN". In the
> official documentation about the AR9170 Base EEPROM (has the same base
> structure as AR5008 up to AR92xx) this is specified as:
>
> "Only bit 0 is defined as Big Endian. This bit should be written as 1
> when the structure is interpreted in big Endian byte ordering. This bit
> must be reviewed before any larger than byte parameters can be interprete=
d."
>
> It makes sense that on a Big-Endian MIPS device (like the Netgear WNDR370=
0v2),
> the  caldata should be in "Big-Endian" too... so no swapping is necessary.
>
> Looking in ath9k's eeprom.c function ath9k_hw_nvram_swap_data() that deals
> with this eepmisc flag:
>
> |       if (ah->eep_ops->get_eepmisc(ah) & AR5416_EEPMISC_BIG_ENDIAN) {
> |               *swap_needed =3D true;
> |               ath_dbg(common, EEPROM,
> |                       "Big Endian EEPROM detected according to EEPMISC =
register.\n");
> |       } else {
> |               *swap_needed =3D false;
> |       }
>
> This doesn't take into consideration that swapping is not needed if
> the data is in big endian format on a big endian device. So, this
> could be changed so that the *swap_needed is only true if the flag and
> device endiannes disagrees?
>
> That said, Martin and Felix have written their reasons in the cover letter
> and patches for why the code is what it is:
> <https://ath9k-devel.ath9k.narkive.com/2q5A6nu0/patch-0-5-ath9k-eeprom-sw=
apping-improvements>
>
> Toke, What's your take on this? Having something similar like the
> check_endian bool... but for OF? Or more logic that can somehow
> figure out if it's big or little endian.

Digging into that old thread, it seems we are re-hashing a lot of the
old discussion when those patches went in. Basically, the code you
quoted above is correct because the commit that introduced it sets all
fields to be __le16 and __le32 types and reads them using the
leXX_to_cpu() macros.

The code *further up* in that function is what is enabled by Alvaro's
patch. Which is a different type of swapping (where the whole eeprom is
swab16()'ed, not just the actual multi-byte data fields in them).
However, in OpenWrt the in-driver code to do this is not used; instead,
a hotplug script applies the swapping before the device is seen by the
driver, as described in this commit[0]. Martin indeed mentions that this
is a device-specific thing, so the driver can't actually do the right
thing without some outside feature flag[1]. The commit[0] also indicates
that there used used to exist a device-tree binding in the out-of-tree
device trees used in OpenWrt to do the unconditional swab16().

The code in [0] still exists in OpenWrt today, albeit in a somewhat
modified form[2]. I guess the question then boils down to, =C3=81lvaro, can
your issue be resolved by a pre-processing step similar to that which is
done in [2]? Or do we need the device tree flag after all?

-Toke

[0] https://git.openwrt.org/?p=3Dopenwrt/openwrt.git;a=3Dcommitdiff;h=3Dafa=
37092663d00aa0abf8c61943d9a1b5558b144
[1] https://narkive.com/2q5A6nu0.34
[2] https://git.openwrt.org/?p=3Dopenwrt/openwrt.git;a=3Dblob;f=3Dtarget/li=
nux/lantiq/xway/base-files/etc/hotplug.d/firmware/12-ath9k-eeprom;h=3D98bb9=
af6947a298775ff7fa26ac6501c57df8378;hb=3DHEAD
