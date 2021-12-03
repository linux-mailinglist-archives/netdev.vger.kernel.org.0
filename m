Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747A54677BA
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357508AbhLCNAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 08:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239742AbhLCNAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 08:00:54 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DCEC06173E;
        Fri,  3 Dec 2021 04:57:30 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8608:6e64:956a:daea:cf2f])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1B3CvIb2021165
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 3 Dec 2021 13:57:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1638536239; bh=gI7M7yPnJx/oBhAt4SBRGRDw8I96J5PZcHTVDS0LQsg=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=BAsTFALgaSBRgoSJ0MIH4yunIjYB5cZCqpotcxvGBP7TFsAAshQY7JHDrtKil90J8
         5DoaPmZByVBxtEGfFDbp6RkrvbBM8hR6k0Mr5kIssXGR6RLXjwnh2+YSo7y+ZshL/4
         lz8VAebIYeiVEJiPRdJkJF6HeWfuB7xY+9XgXjAE=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mt87p-001jVy-N0; Fri, 03 Dec 2021 13:57:17 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset
 or zero
Organization: m
References: <20211202143437.1411410-1-lee.jones@linaro.org>
        <20211202175134.5b463e18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87o85yj81l.fsf@miraculix.mork.no> <Yan+nvfyS21z7ZUw@google.com>
Date:   Fri, 03 Dec 2021 13:57:17 +0100
In-Reply-To: <Yan+nvfyS21z7ZUw@google.com> (Lee Jones's message of "Fri, 3 Dec
        2021 11:25:18 +0000")
Message-ID: <87ilw5kfrm.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:
> On Fri, 03 Dec 2021, Bj=C3=B8rn Mork wrote:
>
>> Just out of curiouslity: Is this a real device, or was this the result
>> of fuzzing around?
>
> This is the result of "fuzzing around" on qemu. :)
>
> https://syzkaller.appspot.com/bug?extid=3D2c9b6751e87ab8706cb3

OK.  Makes sense.  I'd be surprised of such a device worked on that
other OS.

>> Not that it matters - it's obviously a bug to fix in any case.  Good cat=
ch!
>>=20
>> (We probably have many more of the same, assuming the device presents
>> semi-sane values in the NCM parameter struct)
>>=20
>> >> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
>> >> index 24753a4da7e60..e303b522efb50 100644
>> >> --- a/drivers/net/usb/cdc_ncm.c
>> >> +++ b/drivers/net/usb/cdc_ncm.c
>> >> @@ -181,6 +181,8 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *de=
v, u32 new_tx)
>> >>  		min =3D ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct=
 usb_cdc_ncm_nth32);
>> >>=20=20
>> >>  	max =3D min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_pa=
rm.dwNtbOutMaxSize));
>> >> +	if (max =3D=3D 0)
>> >> +		max =3D CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
>> >>=20=20
>> >>  	/* some devices set dwNtbOutMaxSize too low for the above default */
>> >>  	min =3D min(min, max);
>>=20
>> It's been a while since I looked at this, so excuse me if I read it
>> wrongly.  But I think we need to catch more illegal/impossible values
>> than just zero here?  Any buffer size which cannot hold a single
>> datagram is pointless.
>>=20
>> Trying to figure out what I possible meant to do with that
>>=20
>>  	min =3D min(min, max);
>>=20
>> I don't think it makes any sense?  Does it?  The "min" value we've
>> carefully calculated allow one max sized datagram and headers. I don't
>> think we should ever continue with a smaller buffer than that
>
> I was more confused with the comment you added to that code:
>
>    /* some devices set dwNtbOutMaxSize too low for the above default */
>    min =3D min(min, max);
>
> ... which looks as though it should solve the issue of an inadequate
> dwNtbOutMaxSize, but it almost does the opposite.

That's what I read too.  I must admit that I cannot remember writing any
of this stuff.  But I trust git...

> I initially
> changed this segment to use the max() macro instead, but the
> subsequent clamp_t() macro simply chooses 'max' (0) value over the now
> sane 'min' one.

Yes, but what if we adjust max here instead of min?

> Which is why I chose=20
>> Or are there cases where this is valid?
>
> I'm not an expert on the SKB code, but in my simple view of the world,
> if you wish to use a buffer for any amount of data, you should
> allocate space for it.
>
>> So that really should haven been catching this bug with a
>>=20
>>   max =3D max(min, max)
>
> I tried this.  It didn't work either.
>
> See the subsequent clamp_t() call a few lines down.

This I don't understand.  If we have for example

 new_tx =3D 0
 max =3D 0
 min =3D 1514(=3Ddatagram) + 8(=3Dndp) + 2(=3D1+1) * 4(=3Ddpe) + 12(=3Dnth)=
 =3D 1542

then

 max =3D max(min, max) =3D 1542
 val =3D clamp_t(u32, new_tx, min, max) =3D 1542

so we return 1542 and everything is fine.

>> or maybe more readable
>>=20
>>   if (max < min)
>>      max =3D min
>>=20
>> What do you think?
>
> So the data that is added to the SKB is ctx->max_ndp_size, which is
> allocated in cdc_ncm_init().  The code that does it looks like:
>
>    if (ctx->is_ndp16)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
>         ctx->max_ndp_size =3D sizeof(struct usb_cdc_ncm_ndp16) +
> 	                    (ctx->tx_max_datagrams + 1) *
> 			    sizeof(struct usb_cdc_ncm_dpe16);=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
>     else=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>         ctx->max_ndp_size =3D sizeof(struct usb_cdc_ncm_ndp32) +
> 	                    (ctx->tx_max_datagrams + 1) *
> 			    sizeof(struct usb_cdc_ncm_dpe32);=20=20
>
> So this should be the size of the allocation too, right?

This driver doesn't add data to the skb.  It allocates a new buffer and
copies one or more skbs into it.  I'm sure that could be improved too..

Without a complete rewrite we need to allocate new skbs large enough to hold

NTH          - frame header
NDP x 1      - index table, with minimum two entries (1 datagram + terminat=
or)
datagram x 1 - ethernet frame

This gives the minimum "tx_max" value.

The device is supposed to tell us the maximum "tx_max" value in
dwNtbOutMaxSize.  In theory.  In practice we cannot trust the device, as
you point out.  We know aleady deal with too large values (which are
commonly seen in real products), but we also need to deal with too low
values.

I believe the "too low" is defined by the calculated minimum value, and
the comment indicates that this what I tried to express but failed.


> Why would the platform ever need to over-ride this?  The platform
> can't make the data area smaller since there won't be enough room.  It
> could perhaps make it bigger, but the min_t() and clamp_t() macros
> will end up choosing the above allocation anyway.
>
> This leaves me feeling a little perplexed.
>
> If there isn't a good reason for over-riding then I could simplify
> cdc_ncm_check_tx_max() greatly.
>
> What do *you* think? :)

I also have the feeling that this could and should be simplified. This
discussion shows that refactoring is required.  git blame makes this all
too embarrassing ;-)



Bj=C3=B8rn
