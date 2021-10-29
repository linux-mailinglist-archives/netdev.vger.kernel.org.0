Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BEF43FA64
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 12:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhJ2KEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 06:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhJ2KEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 06:04:00 -0400
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8DCC061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 03:01:32 -0700 (PDT)
Received: from vla1-a78d115f8d22.qloud-c.yandex.net (vla1-a78d115f8d22.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:2906:0:640:a78d:115f])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 861362E199B;
        Fri, 29 Oct 2021 13:01:30 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by vla1-a78d115f8d22.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id pk6uq75ipB-1UqCBgTk;
        Fri, 29 Oct 2021 13:01:30 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635501690; bh=YEMwM71zj72L67PAjTYAzot6ajvO6DslzyfgVdsTSzM=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=YfkoftHnw7fk3017LcGH6b033EqvIdwyMng4InNKHejigbQrgPI/oIUe/lOWFPrwq
         lWpHgpRI/IGur9OEsukYjn3av8jZOEooCa53qk7i3dXPU8yFtqnToNTg17qG6jmdsU
         kyW7S02z1iuUb48Pb6EPNfVrmEuLI0iAc1ccJkAk=
Authentication-Results: vla1-a78d115f8d22.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:8125::1:2e])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id FVchf83PhH-1UxehWUM;
        Fri, 29 Oct 2021 13:01:30 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [RFC PATCH net-next 2/4] txhash: Add socket option to control TX
 hash rethink behavior
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <f21dfe61-58e6-ba03-cc0a-b5d2fd0a88c6@gmail.com>
Date:   Fri, 29 Oct 2021 13:01:29 +0300
Cc:     netdev@vger.kernel.org, tom@herbertland.com,
        mitradir@yandex-team.ru, zeil@yandex-team.ru
Content-Transfer-Encoding: quoted-printable
Message-Id: <3EA39ACA-9935-4FB7-B89A-5F57D33BC069@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211025203521.13507-3-hmukos@yandex-team.ru>
 <f21dfe61-58e6-ba03-cc0a-b5d2fd0a88c6@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Oct 26, 2021, at 00:05, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>=20
>=20
>=20
> On 10/25/21 1:35 PM, Akhmat Karakotov wrote:
>> Add the SO_TXREHASH socket option to control hash rethink behavior =
per socket.
>> When default mode is set, sockets disable rehash at initialization =
and use
>> sysctl option when entering listen state. setsockopt() overrides =
default
>> behavior.
>=20
> What values are accepted, and what are their meaning ?
>=20
> It seems weird to do anything in inet_csk_listen_start()
>=20
>=20
> For sockets that have not used SO_TXREHASH
> (this includes passive sockets where their parent did not use =
SO_TXREHASH),
> the sysctl _current_ value should be used every time we consider a =
rehash.
SO_TXREHASH_DEFAULT value means default behavior: for listening sockets
the sysctl value is taken, while for others rehash is disabled. The =
motivation
was to disallow hash rethink at the client-side to avoid connection =
timeout to
anycast services (as was stated in cover letter).
ENABLED and DISABLED values are for enforcing rehash option values.

To be honest I didn't quite understand how you propose to change patch =
behaviour.

>=20
>> #define SOCK_TXREHASH_DISABLED	0
>> #define SOCK_TXREHASH_ENABLED	1
>>=20
>> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
>> index 0d833b861f00..537a8532ff8a 100644
>> --- a/net/core/net_namespace.c
>> +++ b/net/core/net_namespace.c
>> @@ -360,7 +360,7 @@ static int __net_init =
net_defaults_init_net(struct net *net)
>> {
>> 	net->core.sysctl_somaxconn =3D SOMAXCONN;
>>=20
>> -	net->core.sysctl_txrehash =3D SOCK_TXREHASH_DISABLED;
>> +	net->core.sysctl_txrehash =3D SOCK_TXREHASH_ENABLED;
>=20
> This is very confusing.
>=20

Could you, please, elaborate what exactly is confusing?
