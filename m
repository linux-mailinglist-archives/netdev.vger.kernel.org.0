Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93595A0EA3
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiHYLCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241306AbiHYLCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:02:23 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCC9ADCC5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:02:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661425293; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=PTNA1UHlvOVwnV5XyDcc1CCQcHbtGJfqbf0nV9+LOum8uolxI1RFds4YpBNDpxFtAApeYkta5+AJAYm1UxLiWckdDiWPoGX13iFuNg7DuA+V/OdFCVm39g5gJNbJuT8Ju4DB0sjqopi8cbpuew9C5Ow/zeAokubjIkHTiEO8IYo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1661425293; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9JxgGzgLM2PUoGaAxTFaglhLU1RtXeL8IA+pkc6Il8E=; 
        b=eEmht/DR2NhwfUTwXF+kq7/6Qr4NdZiIsxz/0YHVeJKLcf466GlmVjHujDu/cImqfXOzhduPhh5CqDxI1LOcQPRv9d7GrB3tEpKAzHzDxP/xKwFEePFBGg3qu2SEV/OXcgwvYTabL0KWpsex4SyY36y1NJCtr7/N8y0pSQTIzok=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661425293;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=9JxgGzgLM2PUoGaAxTFaglhLU1RtXeL8IA+pkc6Il8E=;
        b=XPuaZ1y84SdZwdDBQicREDiv6mas0ZZ4GZ2u8H7vsSMKNOhusJNTYGjG+9OC1YDe
        fD8jE6xjsbptLiggaUuR9XtFequYTTytbx7HvrYU9uuw8wCbYKtiXPAGaigYmbWoHoU
        BmjJDHntf5ssssWlrBMWcwwY/Sc2hglOD1Jhbxmk=
Received: from localhost.localdomain (103.249.233.18 [103.249.233.18]) by mx.zoho.in
        with SMTPS id 1661425291526471.8840215182329; Thu, 25 Aug 2022 16:31:31 +0530 (IST)
From:   Siddh Raman Pant <code@siddh.me>
To:     palmer@rivosinc.com
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rivosinc.com,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Message-ID: <20220825110108.157350-1-code@siddh.me>
Subject: Re: [PATCH] Bluetooth: L2CAP: Elide a string overflow warning
Date:   Thu, 25 Aug 2022 16:31:08 +0530
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220812055249.8037-1-palmer@rivosinc.com>
References: <20220812055249.8037-1-palmer@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 11:22:49 +0530  Palmer Dabbelt  wrote:
> From: Palmer Dabbelt <palmer@rivosinc.com>
>=20
> Without this I get a string op warning related to copying from a
> possibly NULL pointer.  I think the warning is spurious, but it's
> tripping up allmodconfig.

I think it is not spurious, and is due to the following commit:
d0be8347c623 ("Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_pu=
t")

The following commit fixes a similar problem (added the NULL check on line =
1996):
332f1795ca20 ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression")

> In file included from /scratch/merges/ko-linux-next/linux/include/linux/s=
tring.h:253,
>                  from /scratch/merges/ko-linux-next/linux/include/linux/b=
itmap.h:11,
>                  from /scratch/merges/ko-linux-next/linux/include/linux/c=
pumask.h:12,
>                  from /scratch/merges/ko-linux-next/linux/include/linux/m=
m_types_task.h:14,
>                  from /scratch/merges/ko-linux-next/linux/include/linux/m=
m_types.h:5,
>                  from /scratch/merges/ko-linux-next/linux/include/linux/b=
uildid.h:5,
>                  from /scratch/merges/ko-linux-next/linux/include/linux/m=
odule.h:14,
>                  from /scratch/merges/ko-linux-next/linux/net/bluetooth/l=
2cap_core.c:31:
> In function 'memcmp',
>     inlined from 'bacmp' at /scratch/merges/ko-linux-next/linux/include/n=
et/bluetooth/bluetooth.h:347:9,
>     inlined from 'l2cap_global_chan_by_psm' at /scratch/merges/ko-linux-n=
ext/linux/net/bluetooth/l2cap_core.c:2003:15:
> /scratch/merges/ko-linux-next/linux/include/linux/fortify-string.h:44:33:=
 error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=
=3Dstringop-overread]
>    44 | #define __underlying_memcmp     __builtin_memcmp
>       |                                 ^
> /scratch/merges/ko-linux-next/linux/include/linux/fortify-string.h:420:16=
: note: in expansion of macro '__underlying_memcmp'
>   420 |         return __underlying_memcmp(p, q, size);
>       |                ^~~~~~~~~~~~~~~~~~~
> In function 'memcmp',
>     inlined from 'bacmp' at /scratch/merges/ko-linux-next/linux/include/n=
et/bluetooth/bluetooth.h:347:9,
>     inlined from 'l2cap_global_chan_by_psm' at /scratch/merges/ko-linux-n=
ext/linux/net/bluetooth/l2cap_core.c:2004:15:
> /scratch/merges/ko-linux-next/linux/include/linux/fortify-string.h:44:33:=
 error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=
=3Dstringop-overread]
>    44 | #define __underlying_memcmp     __builtin_memcmp
>       |                                 ^
> /scratch/merges/ko-linux-next/linux/include/linux/fortify-string.h:420:16=
: note: in expansion of macro '__underlying_memcmp'
>   420 |         return __underlying_memcmp(p, q, size);
>       |                ^~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
>=20
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

Tested-by: Siddh Raman Pant <code@siddh.me>

> ---
>  net/bluetooth/l2cap_core.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index cbe0cae73434..be7f47e52119 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -2000,11 +2000,13 @@ static struct l2cap_chan *l2cap_global_chan_by_ps=
m(int state, __le16 psm,
>  =09=09=09}
> =20
>  =09=09=09/* Closest match */
> -=09=09=09src_any =3D !bacmp(&c->src, BDADDR_ANY);
> -=09=09=09dst_any =3D !bacmp(&c->dst, BDADDR_ANY);
> -=09=09=09if ((src_match && dst_any) || (src_any && dst_match) ||
> -=09=09=09    (src_any && dst_any))
> -=09=09=09=09c1 =3D c;
> +=09=09=09if (c) {
> +=09=09=09=09src_any =3D !bacmp(&c->src, BDADDR_ANY);
> +=09=09=09=09dst_any =3D !bacmp(&c->dst, BDADDR_ANY);
> +=09=09=09=09if ((src_match && dst_any) || (src_any && dst_match) ||
> +=09=09=09=09    (src_any && dst_any))
> +=09=09=09=09=09c1 =3D c;
> +=09=09=09}
>  =09=09}
>  =09}
> =20


