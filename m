Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15916463060
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 10:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbhK3KB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:01:28 -0500
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:49064 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234861AbhK3KB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 05:01:28 -0500
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 71A2A2E25E7;
        Tue, 30 Nov 2021 12:58:06 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id acbpGIOGEr-w3sSG0Qf;
        Tue, 30 Nov 2021 12:58:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1638266286; bh=CZhY6sHQ2QJvTrY1RAOZMUe1ZkFlaQ0J3Gl/ju5gxx4=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=Gt+U/vgkAkLCSLkwNkwUdOsJ5zml5KvpW5aqEvF/Va8Vr8avWd6poaMCnKaNDNs4D
         rwQX588pfxrT4gnnjEj80InwxOAAAbsTN549oglhdsL6NHY5joa06zDda0QhqoBxoo
         o18V3J7DTaxD1/iZp609GZ3yYfgEnUMKWDfsuUww=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:8005::1:8])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id edoiyCOxut-w3w8YNbZ;
        Tue, 30 Nov 2021 12:58:03 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [RFC PATCH v2 net-next 0/4] txhash: Make hash rethink
 configurable
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <69C55C6B-02FC-429D-BD25-AA0D78EADCFF@yandex-team.ru>
Date:   Tue, 30 Nov 2021 12:58:03 +0300
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru,
        hmukos@yandex-team.ru
Content-Transfer-Encoding: quoted-printable
Message-Id: <82E7E49A-5EB9-4719-87FC-836718A031A9@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211112181939.11329-1-hmukos@yandex-team.ru>
 <69C55C6B-02FC-429D-BD25-AA0D78EADCFF@yandex-team.ru>
To:     hmukos@yandex-team.ru
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I wonder if you have time to provide review regarding my last update to =
the patch.

> On Nov 23, 2021, at 16:20, Akhmat Karakotov <hmukos@yandex-team.ru> =
wrote:
>=20
> Hi Eric,
>=20
> I've sent v2 of the patch. I've removed confusing part with sysctl =
default values
> and made other changes according to your comments. I look forward for =
your
> review.
>=20
>> On Nov 12, 2021, at 21:19, Akhmat Karakotov <hmukos@yandex-team.ru> =
wrote:
>>=20
>> As it was shown in the report by Alexander Azimov, hash rethink at =
the
>> client-side may lead to connection timeout toward stateful anycast
>> services. Tom Herbert created a patchset to address this issue by =
applying
>> hash rethink only after a negative routing event (3RTOs) [1]. This =
change
>> also affects server-side behavior, which we found undesirable. This
>> patchset changes defaults in a way to make them safe: hash rethink at =
the
>> client-side is disabled and enabled at the server-side upon each RTO
>> event or in case of duplicate acknowledgments.
>>=20
>> This patchset provides two options to change default behaviour. The =
hash
>> rethink may be disabled at the server-side by the new sysctl option.
>> Changes in the sysctl option don't affect default behavior at the
>> client-side.
>>=20
>> Hash rethink can also be enabled/disabled with socket option or bpf
>> syscalls which ovewrite both default and sysctl settings. This socket
>> option is available on both client and server-side. This should =
provide
>> mechanics to enable hash rethink inside administrative domain, such =
as DC,
>> where hash rethink at the client-side can be desirable.
>>=20
>> [1] =
https://lore.kernel.org/netdev/20210809185314.38187-1-tom@herbertland.com/=

>>=20
>> v2:
>> 	- Changed sysctl default to ENABLED in all patches. Reduced =
sysctl
>> 	  and socket option size to u8. Fixed netns bug reported by =
kernel
>> 	  test robot.
>>=20
>> Akhmat Karakotov (4):
>> txhash: Make rethinking txhash behavior configurable via sysctl
>> txhash: Add socket option to control TX hash rethink behavior
>> bpf: Add SO_TXREHASH setsockopt
>> tcp: change SYN ACK retransmit behaviour to account for rehash
>>=20
>> arch/alpha/include/uapi/asm/socket.h  |  2 ++
>> arch/mips/include/uapi/asm/socket.h   |  2 ++
>> arch/parisc/include/uapi/asm/socket.h |  2 ++
>> arch/sparc/include/uapi/asm/socket.h  |  2 ++
>> include/net/netns/core.h              |  1 +
>> include/net/sock.h                    | 28 =
++++++++++++++-------------
>> include/uapi/asm-generic/socket.h     |  2 ++
>> include/uapi/linux/socket.h           |  4 ++++
>> net/core/filter.c                     | 10 ++++++++++
>> net/core/net_namespace.c              |  2 ++
>> net/core/sock.c                       | 13 +++++++++++++
>> net/core/sysctl_net_core.c            | 15 ++++++++++++--
>> net/ipv4/inet_connection_sock.c       |  3 +++
>> net/ipv4/tcp_output.c                 |  3 ++-
>> 14 files changed, 73 insertions(+), 16 deletions(-)
>>=20
>> --=20
>> 2.17.1
>>=20
>=20

