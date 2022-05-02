Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3A25171EE
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385601AbiEBOvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350573AbiEBOvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:51:37 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C067767D;
        Mon,  2 May 2022 07:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1651502847;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=gbCKt3vPpEPi1+UqrESQDFS2PsBWY0AgZ4n3u84ceTg=;
    b=R3FhLGwbtFMeqs8ilz93/4MwPMXrKXAlBe+xL7aEQyQiOerbUVxo435mE8nhcCEnex
    z/c3kb4KjhQ15yJRK734bHvZP8aG4+MhQghSXBBFr5SEatYrn44CaYQkTcAIEJrf1nLh
    8pykVLtx9WeghdhqoVdLE1TWG2V0FRfjkLIaW6PkSPS4xKpx1CwCFDNXruaoXnBBqGad
    JdC+CTugi4xNW+2go+2p8QLjizaog/qLEuKNi7KmYg0ed5TF/HwrxgAhxDNS2ySmznFy
    Tj4RMCf5MrklzaZsveNYOWbkVL/LIoYlX08+gEf+iEzn4tn+n3X9JpNX6N2VU2M46yVE
    /BCg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7gpw91N5y2S3i8V+"
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.42.2 DYNA|AUTH)
    with ESMTPSA id k708cfy42ElNWek
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Mon, 2 May 2022 16:47:23 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.21\))
Subject: Re: [PATCH] wl1251: dynamically allocate memory used for DMA
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <CAK8P3a3OiFJiR40FXmCZTc1fMZBteGjXqipDcvZqoO85QBxYow@mail.gmail.com>
Date:   Mon, 2 May 2022 16:47:22 +0200
Cc:     Tony Lindgren <tony@atomide.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com,
        linux-omap <linux-omap@vger.kernel.org>,
        Luca Coelho <luca@coelho.fi>
Content-Transfer-Encoding: quoted-printable
Message-Id: <123640FA-6AF2-4C0E-A7CC-31DCC4CEA15B@goldelico.com>
References: <1676021ae8b6d7aada0b1806fed99b1b8359bdc4.1651495112.git.hns@goldelico.com>
 <CAK8P3a3OiFJiR40FXmCZTc1fMZBteGjXqipDcvZqoO85QBxYow@mail.gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.3445.104.21)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

> Am 02.05.2022 um 16:06 schrieb Arnd Bergmann <arnd@arndb.de>:
>=20
> On Mon, May 2, 2022 at 2:38 PM H. Nikolaus Schaller =
<hns@goldelico.com> wrote:
>> With introduction of vmap'ed stacks, stack parameters can no
>> longer be used for DMA and now leads to kernel panic.
>>=20
>> It happens at several places for the wl1251 (e.g. when
>> accessed through SDIO) making it unuseable on e.g. the
>> OpenPandora.
>>=20
>> We solve this by allocating temporary buffers or use wl1251_read32().
>=20
> This looks all correct to me. I had another look at the related wlcore
> driver now,
> and see that the same problem existed there but was fixed back in 2012
> in a different way, see 690142e98826 ("wl12xx: fix DMA-API-related =
warnings").

Interesting!

>=20
> The approach in the wlcore driver appears to be simpler because it
> avoids dynamic memory allocation and the associated error handling.

It looks as if it just avoids kmalloc/free sequences in event handling
by allocating a big enough buffer once.

wl1271_cmd_wait_for_event_or_timeout() allocates it like we do now.

> However, it probably makes another problem worse that also exists
> here:
>=20
> static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
> {
>       u32 response;
>       wl->if_ops->read(wl, addr, &wl->buffer_32, =
sizeof(wl->buffer_32));
>       return le32_to_cpu(wl->buffer_32);
> }
>=20
> I think the 'buffer_32' member of 'struct wl1251' needs an explicit
> '__cacheline_aligned' attribute to avoid potentially clobbering
> some of the structure during a DMA write.
>=20
> I don't know if anyone cares enough about the two drivers to
> have an opinion. I've added Luca to Cc, but he hasn't maintained
> the driver since 2013 and probably doesn't.

Well, there seems to be quite some common code but indeed devices
using these older chips are getting rare so it is probably not worth
combining code. And testing needs someone who owns boards
with both chips...

>=20
> It's probably ok to just apply your patch for the moment to fix
> the regression we saw on the machines that we know use this.
>=20
> One more detail:
>=20
>> diff --git a/drivers/net/wireless/ti/wl1251/event.c =
b/drivers/net/wireless/ti/wl1251/event.c
>> index e6d426edab56b..e945aafd88ee5 100644
>> --- a/drivers/net/wireless/ti/wl1251/event.c
>> +++ b/drivers/net/wireless/ti/wl1251/event.c
>> @@ -169,11 +169,9 @@ int wl1251_event_wait(struct wl1251 *wl, u32 =
mask, int timeout_ms)
>>                msleep(1);
>>=20
>>                /* read from both event fields */
>> -               wl1251_mem_read(wl, wl->mbox_ptr[0], &events_vector,
>> -                               sizeof(events_vector));
>> +               events_vector =3D wl1251_mem_read32(wl, =
wl->mbox_ptr[0]);
>>                event =3D events_vector & mask;
>> -               wl1251_mem_read(wl, wl->mbox_ptr[1], &events_vector,
>> -                               sizeof(events_vector));
>> +               events_vector =3D wl1251_mem_read32(wl, =
wl->mbox_ptr[1]);
>>                event |=3D events_vector & mask;
>=20
> This appears to change endianness of the data, on big-endian kernels.
> Is that intentional?

Hm. I didn't think about it. I just noticed that wl1251_mem_read32 uses =
the
internal buffer so we don't have to allocate its own buffer any more.

>=20
> My first guess would be that the driver never worked correctly on =
big-endian
> machines, and that the change is indeed correct, but on the other hand
> the conversion was added in commit ac9e2d9afa90 ("wl1251: convert
> 32-bit values to le32 before writing to the chip") in a way that =
suggests it
> was meant to work on both.

wl1251_event_wait() seems to work with the masks provided by code.
So I guess the conversion to le32 is harmless on the OpenPandora.
Most likely it should be done on big endian devices. I.e. we might have
done the right thing.

Let's see if someone compains or knows more. Otherwise we should
fix it just for the Pandora and N900 (both omap3 based) as the only
upstream users of this chip.

BR and thanks,
Nikolaus


