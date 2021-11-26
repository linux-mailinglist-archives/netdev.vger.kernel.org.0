Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A275B45F5B0
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239544AbhKZUTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhKZURA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:17:00 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA94C0619E0
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 12:02:05 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z6so9850004pfe.7
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 12:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ljd4RyE14EcF6Yi/sh6f/YTEKxWqIwTb+DMhqvNbkLk=;
        b=UJUNKSZP0DN5eG4eM1ni1gewxODSmLR4mRTzjmIDLJx8Blj/yn/w3OO6yUoIiqmPWs
         Fz8hnHeXKHeOxWj7+mQtQABo4qVpWnc0TcHIozUIkGnOU7p0iKtXfDo1BV2+5YOem2l9
         BW5j4oAExY4pPidM6prjk6h1jlOEUTYv7oERu1wiS7OC6UIfHirs+QIlXMwZZM6xFiEY
         iHzrpyfyypW9zrGzma+suj8hg32qc/lf1K3o5nRWHDP2vGTdCHbHXFztEgC2li9/YfYZ
         lAL6UDj/B8IyxowOZ+4WBldsnL9AXtdMu2io8ssYLzRTB9vHTJa2Vt/31SqTJVIS3Jt/
         jPlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ljd4RyE14EcF6Yi/sh6f/YTEKxWqIwTb+DMhqvNbkLk=;
        b=AJAi9WHMnclR1pKKSsC6CWeYtUmTSksiJp1YL+wTyGBFV/eStzbfYyHrvkzDazOB95
         L+DVyCZLc/KdOoMQWl9aTQxIXgXiahQyfcEF0Dau+09IgDsAdZrIOEEJIsLCwlBEnG4n
         pQOJLMY2NOhUinhoZKGoGlpaxIzCzePrip8INr3LXQwGmyfJof5ivAmjwJ0gOx14ZEmL
         wDYuO0YazhzbKU9dcaoGmKQ9NYi2Gm/aEm4VWE4ANWg/n3wUJ99GTuBHfZPVMG7YkVfv
         6OBc9yRNKoTY5qOaQ+RABXmKdyv1FDKqZ39Sjr+Hvuc/85Aquet37XY55tP+TJELdRWC
         pN/w==
X-Gm-Message-State: AOAM532HlhGAOEFnYY7MLYATUWjFSUgK1vkj2EPTA34ak+cppYP385YI
        ICw21n4s6xY0V4VD+OfDUT6jtwCTCTUfAPBE6zD+16BQ65A=
X-Google-Smtp-Source: ABdhPJyUETfPhe+uCNhpXYpqvs3om54ktVDshJQJKLWGGbSTvkjFDAiDAIWbACCV/d3C6BR4cFd3Fvni+OE4GicrMhM=
X-Received: by 2002:a62:e406:0:b0:49f:dc1c:f3e1 with SMTP id
 r6-20020a62e406000000b0049fdc1cf3e1mr23008546pfh.21.1637956924728; Fri, 26
 Nov 2021 12:02:04 -0800 (PST)
MIME-Version: 1.0
References: <20211126063645.19094-1-luizluca@gmail.com> <20211126081252.32254-1-luizluca@gmail.com>
 <b2ba44bc-57fb-b756-d693-7d896de90f3d@bang-olufsen.dk>
In-Reply-To: <b2ba44bc-57fb-b756-d693-7d896de90f3d@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 26 Nov 2021 17:01:53 -0300
Message-ID: <CAJq09z7BrXCZ4CC3Rit8v=x+rNfZ=ecrVZoJ-Ts+L+2Y7EYohw@mail.gmail.com>
Subject: Re: [PATCH v2] net: dsa: realtek-smi: fix indirect reg access for ports>3
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Luiz,
>
> Thanks for your patch.
>
> You needn't cc the stable list, since rtl8365mb doesn't exist in any
> stable release just yet. If you send a v3, just target net:
>
> [PATCH net v3] net: dsa: ...
>
> Then the fix will land in 5.16. :-)
>

OK. Thanks. Newbie mistakes...

> On 11/26/21 09:12, luizluca@gmail.com wrote:
> > From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> >
> > This switch family can have up to 8 ports {0..7}. However,
> > INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK was using 2 bits instead of 3,
> > dropping the most significant bit during indirect register reads and
> > writes. Reading or writing ports 4, 5, 6, and 7 registers was actually
> > manipulating, respectively, ports 0, 1, 2, and 3 registers.
>
> Nice catch. Out of curiosity can you share what switch you are testing?
> So far the driver only advertises support for RTL8365MB-VC. Since that
> switch only uses PHY addresses 0~3, it shouldn't be affected by a
> narrower (2-bit) PHYNUM_MASK, right? Are you able to add words to the
> effect of "... now this fixes the driver to work with RTL83xxxx"?

RTL8365MB-VC is one of the smallest one. It was not affected by this
issue as all 4 UTP ports are below 4. I have a RTL8367S with 5
ports+CPU. It took me some days to figure out why wan port (4) was not
working and why indirect register access was mirroring the status from
port 0.

I'm finishing two improvements to the realtek switch driver:
1) realtek mdio interface
2) RTL8367S support (modifying RTL8365MB-VC driver)

Here is my current status:
https://github.com/luizluca/linux/tree/realtek_mdio_refactor (it is a
moving target as I occasionally do forced pushes)

I still don't know how to relate cpu_port to ext_port. I have port 7
and ext_int 2 but that same port 7 would be an UTP port in another
variant. Is there a fixed relation between ext interfaces and port
numbers for each variant? Or is this something defined by the board
configuration? For now, I'm using DSA to determine the CPU port and I
added a new DT property to define the external interface.

rtl8367c_phy_mode_supported also needs to be fixed. For now, it simply
returns true as the default mode is what I needed.

There are also dozens of initializations that the original realtek
device uses like disabling EEE and Gigabit lite that I'm not sure if
we need. I was thinking about adding an DT array property to allow
extra initializations without a kernel rebuild. With a little more
effort, this driver could be able to support other switch variants
only providing extra DT properties.

While looking for the cause of wan port not working, I was mapping
each init table value to a readable defined value but I'm not sure if
it is desired to expand the code with that much information. This
commit is outside my tree for now.

> The change is OK except for some comments below:
>
> >
> > rtl8365mb_phy_{read,write} will now returns -EINVAL if phy is greater
> > than 7.
>
> I don't think this is really necessary: a valid (device tree)
> configuration should never specify a PHY with address greater than 7. Or
> am I missing something?

No, you are correct. A correct DT will never access those register out
of range. However, DT is written by humans. This family supports up to
10 ports (8 UTP + 2 EXT). If someone define a port 8 or 9 in device
tree as an UTP port, the function will silently return port 0 data for
port 8. The error returned here could save some hours. I'll keep that
as it is a cheap test for a low traffic function.

Maybe we should also check if the port is not, according to device
tree, an ext port (fixed-link?) and fail right if it is port 8 or 9.

>
> >
> > v2:
> > - fix affected ports in commit message
>
> The changelog shouldn't end up in the final commit message - please move
> it out in v3.

OK

>
> >
> > Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > ---
> >   drivers/net/dsa/rtl8365mb.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/rtl8365mb.c
> > index baaae97283c5..f4414ac74b61 100644
> > --- a/drivers/net/dsa/rtl8365mb.c
> > +++ b/drivers/net/dsa/rtl8365mb.c
> > @@ -107,6 +107,7 @@
> >   #define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC 2112
> >
> >   /* Family-specific data and limits */
> > +#define RTL8365MB_PHYADDRMAX 7
> >   #define RTL8365MB_NUM_PHYREGS       32
> >   #define RTL8365MB_PHYREGMAX (RTL8365MB_NUM_PHYREGS - 1)
> >   #define RTL8365MB_MAX_NUM_PORTS     (RTL8365MB_CPU_PORT_NUM_8365MB_VC + 1)
> > @@ -176,7 +177,7 @@
> >   #define RTL8365MB_INDIRECT_ACCESS_STATUS_REG                        0x1F01
> >   #define RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG                       0x1F02
> >   #define   RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_5_1_MASK GENMASK(4, 0)
> > -#define   RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK              GENMASK(6, 5)
> > +#define   RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK              GENMASK(7, 5)
> >   #define   RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_MASK GENMASK(11, 8)
> >   #define   RTL8365MB_PHY_BASE                                        0x2000
> >   #define RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG            0x1F03
> > @@ -679,6 +680,8 @@ static int rtl8365mb_phy_read(struct realtek_smi *smi, int phy, int regnum)
> >       u16 val;
> >       int ret;
> >
> > +     if (phy > RTL8365MB_PHYADDRMAX)
> > +             return -EINVAL;
> >       if (regnum > RTL8365MB_PHYREGMAX)
>
> If you decide to keep these check, please add a newline after your returns.
>
> >               return -EINVAL;
> >
> > @@ -704,6 +707,8 @@ static int rtl8365mb_phy_write(struct realtek_smi *smi, int phy, int regnum,
> >       u32 ocp_addr;
> >       int ret;
> >
> > +     if (phy > RTL8365MB_PHYADDRMAX)
> > +             return -EINVAL;
> >       if (regnum > RTL8365MB_PHYREGMAX)
> >               return -EINVAL;
> >
> >
>
