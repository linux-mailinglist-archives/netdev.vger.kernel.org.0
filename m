Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A2A4674E5
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351621AbhLCKdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379993AbhLCKdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:33:17 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0586C061761
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 02:29:53 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8608:6e64:956a:daea:cf2f])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1B3ATQik004949
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 3 Dec 2021 11:29:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1638527368; bh=7uIxMTluRMvr3/z2O0SnlcTpQBZG2IIH26NnHiMzPDM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=IBpRl5/hbDS84/K4yZpnyIqn/mJvBohOc92m9QvM3FCqlgSZRQJGqLQfIcFhBKWlr
         J6dVJ4YUm1b0Uzdy910tlu11TSg4Uv3LaCoHCwDpe2GjUzHkzKzrzU11sj/D8J3gYk
         Isq4Nbsh6akpnz6a1aJ4INm8l6uzX7a+3VptHnyg=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mt5ok-001jKr-9W; Fri, 03 Dec 2021 11:29:26 +0100
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
Date:   Fri, 03 Dec 2021 11:29:26 +0100
In-Reply-To: <20211202175134.5b463e18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Thu, 2 Dec 2021 17:51:34 -0800")
Message-ID: <87o85yj81l.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Lee!

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu,  2 Dec 2021 14:34:37 +0000 Lee Jones wrote:
>> Currently, due to the sequential use of min_t() and clamp_t() macros,
>> in cdc_ncm_check_tx_max(), if dwNtbOutMaxSize is not set, the logic
>> sets tx_max to 0.  This is then used to allocate the data area of the
>> SKB requested later in cdc_ncm_fill_tx_frame().
>>=20
>> This does not cause an issue presently because when memory is
>> allocated during initialisation phase of SKB creation, more memory
>> (512b) is allocated than is required for the SKB headers alone (320b),
>> leaving some space (512b - 320b =3D 192b) for CDC data (172b).
>>=20
>> However, if more elements (for example 3 x u64 =3D [24b]) were added to
>> one of the SKB header structs, say 'struct skb_shared_info',
>> increasing its original size (320b [320b aligned]) to something larger
>> (344b [384b aligned]), then suddenly the CDC data (172b) no longer
>> fits in the spare SKB data area (512b - 384b =3D 128b).
>>=20
>> Consequently the SKB bounds checking semantics fails and panics:
>>=20
>>   skbuff: skb_over_panic: text:ffffffff830a5b5f len:184 put:172   \
>>      head:ffff888119227c00 data:ffff888119227c00 tail:0xb8 end:0x80 dev:=
<NULL>
>>=20
>>   ------------[ cut here ]------------
>>   kernel BUG at net/core/skbuff.c:110!
>>   RIP: 0010:skb_panic+0x14f/0x160 net/core/skbuff.c:106
>>   <snip>
>>   Call Trace:
>>    <IRQ>
>>    skb_over_panic+0x2c/0x30 net/core/skbuff.c:115
>>    skb_put+0x205/0x210 net/core/skbuff.c:1877
>>    skb_put_zero include/linux/skbuff.h:2270 [inline]
>>    cdc_ncm_ndp16 drivers/net/usb/cdc_ncm.c:1116 [inline]
>>    cdc_ncm_fill_tx_frame+0x127f/0x3d50 drivers/net/usb/cdc_ncm.c:1293
>>    cdc_ncm_tx_fixup+0x98/0xf0 drivers/net/usb/cdc_ncm.c:1514
>>=20
>> By overriding the max value with the default CDC_NCM_NTB_MAX_SIZE_TX
>> when not offered through the system provided params, we ensure enough
>> data space is allocated to handle the CDC data, meaning no crash will
>> occur.

Just out of curiouslity: Is this a real device, or was this the result
of fuzzing around?

Not that it matters - it's obviously a bug to fix in any case.  Good catch!

(We probably have many more of the same, assuming the device presents
semi-sane values in the NCM parameter struct)

>> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
>> index 24753a4da7e60..e303b522efb50 100644
>> --- a/drivers/net/usb/cdc_ncm.c
>> +++ b/drivers/net/usb/cdc_ncm.c
>> @@ -181,6 +181,8 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *dev, =
u32 new_tx)
>>  		min =3D ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct us=
b_cdc_ncm_nth32);
>>=20=20
>>  	max =3D min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_parm.=
dwNtbOutMaxSize));
>> +	if (max =3D=3D 0)
>> +		max =3D CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
>>=20=20
>>  	/* some devices set dwNtbOutMaxSize too low for the above default */
>>  	min =3D min(min, max);

It's been a while since I looked at this, so excuse me if I read it
wrongly.  But I think we need to catch more illegal/impossible values
than just zero here?  Any buffer size which cannot hold a single
datagram is pointless.

Trying to figure out what I possible meant to do with that

 	min =3D min(min, max);

I don't think it makes any sense?  Does it?  The "min" value we've
carefully calculated allow one max sized datagram and headers. I don't
think we should ever continue with a smaller buffer than that. Or are
there cases where this is valid?

So that really should haven been catching this bug with a

  max =3D max(min, max)

or maybe more readable

  if (max < min)
     max =3D min

What do you think?


Bj=C3=B8rn
