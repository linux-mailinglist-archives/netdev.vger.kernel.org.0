Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9C4443F6D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhKCJe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:34:28 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:42930 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231557AbhKCJeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:34:25 -0400
Received: from vla1-a78d115f8d22.qloud-c.yandex.net (vla1-a78d115f8d22.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:2906:0:640:a78d:115f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 9EAB52E12BA;
        Wed,  3 Nov 2021 12:31:47 +0300 (MSK)
Received: from myt6-10e59078d438.qloud-c.yandex.net (myt6-10e59078d438.qloud-c.yandex.net [2a02:6b8:c12:5209:0:640:10e5:9078])
        by vla1-a78d115f8d22.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id Lxni3nO4jR-VlsK9jgH;
        Wed, 03 Nov 2021 12:31:47 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635931907; bh=Wy62eNarQSPSDhZUi1wiHxRoPKoktl0nYMELkrVh7T8=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=BGXbMVtOPw+ZEkCLfo8V/1WyrTjEi4zVycugDEpmx3n1RB82sW+3HaxcPsJ+czH4z
         Nuyz1aEgw9d8we+dqyx+N4H5cBzhO7J+hVAMIOmlBRCps4Ko4TMsudwtS4cShennMc
         6q661ffZIcmTeFrKOjJX/Zu7BEZ2TaV6C52O24Ck=
Authentication-Results: vla1-a78d115f8d22.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:a405::1:3c])
        by myt6-10e59078d438.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id ZV8EAAaoCv-VkxuQmh1;
        Wed, 03 Nov 2021 12:31:47 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v2] tcp: Use BPF timeout setting for SYN ACK RTO
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <20211102231737.nt6o7jehcm7qzjbx@kafai-mbp.dhcp.thefacebook.com>
Date:   Wed, 3 Nov 2021 12:31:46 +0300
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        ncardwell@google.com, netdev@vger.kernel.org, ycheng@google.com,
        zeil@yandex-team.ru
Content-Transfer-Encoding: quoted-printable
Message-Id: <81A927CB-03C7-409C-BE3F-B37D24DA4FE0@yandex-team.ru>
References: <863fdf13-b1f4-f429-d8ac-269f9ceaa747@gmail.com>
 <20211102183235.14679-1-hmukos@yandex-team.ru>
 <eb593fea-b5a5-c871-a762-a48127e91f75@gmail.com>
 <20211102231737.nt6o7jehcm7qzjbx@kafai-mbp.dhcp.thefacebook.com>
To:     Martin KaFai Lau <kafai@fb.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Nov 3, 2021, at 02:17, Martin KaFai Lau <kafai@fb.com> wrote:
>=20
> On Tue, Nov 02, 2021 at 03:06:31PM -0700, Eric Dumazet wrote:
>>=20
>>=20
>> On 11/2/21 11:32 AM, Akhmat Karakotov wrote:
>>> When setting RTO through BPF program, some SYN ACK packets were =
unaffected
>>> and continued to use TCP_TIMEOUT_INIT constant. This patch adds =
timeout
>>> option to struct request_sock. Option is initialized with =
TCP_TIMEOUT_INIT
>>> and is reassigned through BPF using tcp_timeout_init call. SYN ACK
>>> retransmits now use newly added timeout option.
>>>=20
>>> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
>>> ---
>>> include/net/request_sock.h      | 2 ++
>>> net/ipv4/inet_connection_sock.c | 2 +-
>>> net/ipv4/tcp_input.c            | 8 +++++---
>>> net/ipv4/tcp_minisocks.c        | 4 ++--
>>> 4 files changed, 10 insertions(+), 6 deletions(-)
>>>=20
>>> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
>>> index 29e41ff3ec93..144c39db9898 100644
>>> --- a/include/net/request_sock.h
>>> +++ b/include/net/request_sock.h
>>> @@ -70,6 +70,7 @@ struct request_sock {
>>> 	struct saved_syn		*saved_syn;
>>> 	u32				secid;
>>> 	u32				peer_secid;
>>> +	u32				timeout;
>>> };
>>>=20
>>> static inline struct request_sock *inet_reqsk(const struct sock *sk)
>>> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, =
struct sock *sk_listener,
>>> 	sk_node_init(&req_to_sk(req)->sk_node);
>>> 	sk_tx_queue_clear(req_to_sk(req));
>>> 	req->saved_syn =3D NULL;
>>> +	req->timeout =3D 0;
>>> 	req->num_timeout =3D 0;
>>> 	req->num_retrans =3D 0;
>>> 	req->sk =3D NULL;
>>> diff --git a/net/ipv4/inet_connection_sock.c =
b/net/ipv4/inet_connection_sock.c
>>> index 0d477c816309..c43cc1f22092 100644
>>> --- a/net/ipv4/inet_connection_sock.c
>>> +++ b/net/ipv4/inet_connection_sock.c
>>> @@ -870,7 +870,7 @@ static void reqsk_timer_handler(struct =
timer_list *t)
>>>=20
>>> 		if (req->num_timeout++ =3D=3D 0)
>>> 			atomic_dec(&queue->young);
>>> -		timeo =3D min(TCP_TIMEOUT_INIT << req->num_timeout, =
TCP_RTO_MAX);
>>> +		timeo =3D min(req->timeout << req->num_timeout, =
TCP_RTO_MAX);
>>=20
>> I wonder how much time it will take to syzbot to trigger an overflow =
here and
>> other parts.
>>=20
>> (Not sure BPF_SOCK_OPS_TIMEOUT_INIT has any sanity checks)
> Not now.  It probably makes sense to take this chance to bound
> it by TCP_RTO_MAX.
Where do you suggest to bound to TCP_RTO_MAX? In tcp_timeout_init?=
