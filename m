Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4870B447FC8
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 13:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbhKHMva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 07:51:30 -0500
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:56208 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238465AbhKHMv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 07:51:29 -0500
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 474382E179B
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 15:48:43 +0300 (MSK)
Received: from sas2-d40aa8807eff.qloud-c.yandex.net (sas2-d40aa8807eff.qloud-c.yandex.net [2a02:6b8:c08:b921:0:640:d40a:a880])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id JjQHIDOHNW-mhsCUbqv;
        Mon, 08 Nov 2021 15:48:43 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1636375723; bh=JHzhIoBlsdlpQVU68RrckTmqvK4E3C5HzehfmkAHfwA=;
        h=Message-Id:In-Reply-To:References:Date:Subject:From:To;
        b=C70gDCuGmqMeKIRNxjh8t/Vr5mPn587HXE8SvvKjtqZQvL0Oon6m3ygnlC4e1VQ46
         n0Hy5WJ0LmHAlIdw1B/eB8kbnFwlkxHeXCjGR6D3gsmyCUFA6tc1tDoYbFdse4oDZo
         fFooMxZDnR8x5tFTZ5asuxJJtT6MxrrjrCPz9W1s=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:216::1:2f])
        by sas2-d40aa8807eff.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id tjB4nqJDYK-mhxOw7aE;
        Mon, 08 Nov 2021 15:48:43 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [RFC PATCH net-next 2/4] txhash: Add socket option to control TX
 hash rethink behavior
Date:   Mon, 8 Nov 2021 15:48:42 +0300
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211025203521.13507-3-hmukos@yandex-team.ru>
 <f21dfe61-58e6-ba03-cc0a-b5d2fd0a88c6@gmail.com>
 <3EA39ACA-9935-4FB7-B89A-5F57D33BC069@yandex-team.ru>
 <D7FFC160-1DC3-42A5-BE0E-15FD81BEB1F3@yandex-team.ru>
To:     netdev@vger.kernel.org
In-Reply-To: <D7FFC160-1DC3-42A5-BE0E-15FD81BEB1F3@yandex-team.ru>
Message-Id: <A1CCE8E1-72B0-429C-BBD9-ABA31DE2EBE0@yandex-team.ru>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Oct 29, 2021, at 13:01, Akhmat Karakotov <hmukos@yandex-team.ru> =
wrote:
>=20
>>=20
>> On Oct 26, 2021, at 00:05, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>>=20
>>=20
>>=20
>> On 10/25/21 1:35 PM, Akhmat Karakotov wrote:
>>> Add the SO_TXREHASH socket option to control hash rethink behavior =
per socket.
>>> When default mode is set, sockets disable rehash at initialization =
and use
>>> sysctl option when entering listen state. setsockopt() overrides =
default
>>> behavior.
>>=20
>> What values are accepted, and what are their meaning ?
>>=20
>> It seems weird to do anything in inet_csk_listen_start()
>>=20
>>=20
>> For sockets that have not used SO_TXREHASH
>> (this includes passive sockets where their parent did not use =
SO_TXREHASH),
>> the sysctl _current_ value should be used every time we consider a =
rehash.
> SO_TXREHASH_DEFAULT value means default behavior: for listening =
sockets
> the sysctl value is taken, while for others rehash is disabled. The =
motivation
> was to disallow hash rethink at the client-side to avoid connection =
timeout to
> anycast services (as was stated in cover letter).
> ENABLED and DISABLED values are for enforcing rehash option values.
>=20
> To be honest I didn't quite understand how you propose to change patch =
behaviour.
>=20
>>=20
>>> #define SOCK_TXREHASH_DISABLED	0
>>> #define SOCK_TXREHASH_ENABLED	1
>>>=20
>>> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
>>> index 0d833b861f00..537a8532ff8a 100644
>>> --- a/net/core/net_namespace.c
>>> +++ b/net/core/net_namespace.c
>>> @@ -360,7 +360,7 @@ static int __net_init =
net_defaults_init_net(struct net *net)
>>> {
>>> 	net->core.sysctl_somaxconn =3D SOMAXCONN;
>>>=20
>>> -	net->core.sysctl_txrehash =3D SOCK_TXREHASH_DISABLED;
>>> +	net->core.sysctl_txrehash =3D SOCK_TXREHASH_ENABLED;
>>=20
>> This is very confusing.
>>=20
>=20
> Could you, please, elaborate what exactly is confusing?

Hi Eric,

I wonder if you have time to take a closer look at my last comments.

P. S.: resending this message without CC, because delivery system =
rejected it first time

