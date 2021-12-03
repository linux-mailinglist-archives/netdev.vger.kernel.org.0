Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737F9467986
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381509AbhLCOke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381439AbhLCOke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:40:34 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C056FC061751;
        Fri,  3 Dec 2021 06:37:09 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8608:6e64:956a:daea:cf2f])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1B3EauaF032016
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 3 Dec 2021 15:36:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1638542218; bh=PEPNEv0Kw/wnByNDIDdaU8KIbUcqTaS3nEk6m9pZYqg=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=J6I9sXgxiOWfZuTmgyxGDN7VscmaGLAHncZe4JcP+f1n+CpHSfzVGVAudCY7JvDNc
         ebO9MXi/TYzFpbqEPNNVu/ZGywXJE/XbLoU7QJwU9c3To6qN7nDJIfgqfwPGMrx/BL
         hm+rVIP+dLfUvyld9g9vDIdHjrTk0WXiDXq47iGQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mt9gF-001jeT-LR; Fri, 03 Dec 2021 15:36:55 +0100
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
        <87ilw5kfrm.fsf@miraculix.mork.no> <YaoeKfmJrDPhMXWp@google.com>
Date:   Fri, 03 Dec 2021 15:36:55 +0100
In-Reply-To: <YaoeKfmJrDPhMXWp@google.com> (Lee Jones's message of "Fri, 3 Dec
        2021 13:39:53 +0000")
Message-ID: <871r2tkb5k.fsf@miraculix.mork.no>
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

>> This I don't understand.  If we have for example
>>=20
>>  new_tx =3D 0
>>  max =3D 0
>>  min =3D 1514(=3Ddatagram) + 8(=3Dndp) + 2(=3D1+1) * 4(=3Ddpe) + 12(=3Dn=
th) =3D 1542
>>=20
>> then
>>=20
>>  max =3D max(min, max) =3D 1542
>>  val =3D clamp_t(u32, new_tx, min, max) =3D 1542
>>=20
>> so we return 1542 and everything is fine.
>
> I don't believe so.
>
> #define clamp_t(type, val, lo, hi) \
>               min_t(type, max_t(type, val, lo), hi)
>
> So:
>               min_t(u32, max_t(u32, 0, 1542), 0)


I don't think so.  If we have:

 new_tx =3D 0
 max =3D 0
 min =3D 1514(=3Ddatagram) + 8(=3Dndp) + 2(=3D1+1) * 4(=3Ddpe) + 12(=3Dnth)=
 =3D 1542
 max =3D max(min, max) =3D 1542

Then we have

  min_t(u32, max_t(u32, 0, 1542), 1542)


If it wasn't clear - My proposal was to change this:

  - min =3D min(min, max);
  + max =3D max(min, max);

in the original code.


But looking further I don't think that's a good idea either.  I searched
through old email and found this commit:

commit a6fe67087d7cb916e41b4ad1b3a57c91150edb88
Author: Bj=C3=B8rn Mork <bjorn@mork.no>
Date:   Fri Nov 1 11:17:01 2013 +0100

    net: cdc_ncm: no not set tx_max higher than the device supports
=20=20=20=20
    There are MBIM devices out there reporting
=20=20=20=20
      dwNtbInMaxSize=3D2048 dwNtbOutMaxSize=3D2048
=20=20=20=20
    and since the spec require a datagram max size of at least
    2048, this means that a full sized datagram will never fit.
=20=20=20=20
    Still, sending larger NTBs than the device supports is not
    going to help.  We do not have any other options than either
     a) refusing to bindi, or
     b) respect the insanely low value.
=20=20=20=20
    Alternative b will at least make these devices work, so go
    for it.
=20=20=20=20
    Cc: Alexey Orishko <alexey.orishko@gmail.com>
    Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 4531f38fc0e5..11c703337577 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -159,8 +159,7 @@ static u8 cdc_ncm_setup(struct usbnet *dev)
        }
=20
        /* verify maximum size of transmitted NTB in bytes */
-       if ((ctx->tx_max < (CDC_NCM_MIN_HDR_SIZE + ctx->max_datagram_size))=
 ||
-           (ctx->tx_max > CDC_NCM_NTB_MAX_SIZE_TX)) {
+       if (ctx->tx_max > CDC_NCM_NTB_MAX_SIZE_TX) {
                dev_dbg(&dev->intf->dev, "Using default maximum transmit le=
ngth=3D%d\n",
                        CDC_NCM_NTB_MAX_SIZE_TX);
                ctx->tx_max =3D CDC_NCM_NTB_MAX_SIZE_TX;





So there are real devices depending on a dwNtbOutMaxSize which is too
low.  Our calculated minimum for MBIM will not fit.

So let's go back your original test for zero.  It's better than
nothing.  I'll just ack that.


> Perhaps we should use max_t() here instead of clamp?

No.  That would allow userspace to set an unlimited buffer size.



Bj=C3=B8rn
