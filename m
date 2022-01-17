Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEA0490B5B
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 16:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240447AbiAQP17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 10:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240264AbiAQP15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 10:27:57 -0500
X-Greylist: delayed 67 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 17 Jan 2022 07:27:56 PST
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA64C061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 07:27:56 -0800 (PST)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 663092E1221;
        Mon, 17 Jan 2022 18:26:46 +0300 (MSK)
Received: from sas2-d40aa8807eff.qloud-c.yandex.net (sas2-d40aa8807eff.qloud-c.yandex.net [2a02:6b8:c08:b921:0:640:d40a:a880])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id JOQehUZQDX-QjMO8sH7;
        Mon, 17 Jan 2022 18:26:46 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1642433206; bh=rv98IjzGY2CsRS0jRQWYaPkKvAMBWQMs1M7t7YqvOmQ=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=xVDS7zYAA1ubqlQ77x8Q2FyHf7vPq70MyihrHhcK35g3c3qMpfJ120F6xWin5pzPX
         pfEHQbYDeZKpILEgdYlFyJ1DJ49JMe8LPKDtoh30QHxvrR4vQaiDvqW6zcio5uR1gn
         MjHdCO+zuFxfALRGzECTokDTU2zpOfdYaiBNS+uE=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:39d6:dbc7:816e:cad5])
        by sas2-d40aa8807eff.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id pAMdirLppu-QjQW5VKC;
        Mon, 17 Jan 2022 18:26:45 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <20211104010648.h3bhz6cugnhcyfg6@kafai-mbp>
Date:   Mon, 17 Jan 2022 18:26:45 +0300
Cc:     Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>, zeil@yandex-team.ru,
        davem@davemloft.net
Content-Transfer-Encoding: quoted-printable
Message-Id: <7A1A33E9-663E-42B2-87B5-B09B14D15ED2@yandex-team.ru>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <20211103204607.21491-1-hmukos@yandex-team.ru>
 <20211104010648.h3bhz6cugnhcyfg6@kafai-mbp>
To:     Martin KaFai Lau <kafai@fb.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear David,

We got the patch acked couple of weeks ago, please let us know what =
further steps are required before merge.

Thanks, Akhmat.

> On Nov 4, 2021, at 04:06, Martin KaFai Lau <kafai@fb.com> wrote:
>=20
> On Wed, Nov 03, 2021 at 11:46:07PM +0300, Akhmat Karakotov wrote:
>> When setting RTO through BPF program, some SYN ACK packets were =
unaffected
>> and continued to use TCP_TIMEOUT_INIT constant. This patch adds =
timeout
>> option to struct request_sock. Option is initialized with =
TCP_TIMEOUT_INIT
>> and is reassigned through BPF using tcp_timeout_init call. SYN ACK
>> retransmits now use newly added timeout option.
>>=20
>> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
>> ---
>> include/net/request_sock.h      |  2 ++
>> include/net/tcp.h               |  2 +-
>> net/ipv4/inet_connection_sock.c |  4 +++-
>> net/ipv4/tcp_input.c            |  8 +++++---
>> net/ipv4/tcp_minisocks.c        | 12 +++++++++---
>> 5 files changed, 20 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
>> index 29e41ff3ec93..144c39db9898 100644
>> --- a/include/net/request_sock.h
>> +++ b/include/net/request_sock.h
>> @@ -70,6 +70,7 @@ struct request_sock {
>> 	struct saved_syn		*saved_syn;
>> 	u32				secid;
>> 	u32				peer_secid;
>> +	u32				timeout;
>> };
>>=20
>> static inline struct request_sock *inet_reqsk(const struct sock *sk)
>> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, =
struct sock *sk_listener,
>> 	sk_node_init(&req_to_sk(req)->sk_node);
>> 	sk_tx_queue_clear(req_to_sk(req));
>> 	req->saved_syn =3D NULL;
>> +	req->timeout =3D 0;
>> 	req->num_timeout =3D 0;
>> 	req->num_retrans =3D 0;
>> 	req->sk =3D NULL;
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index 3166dc15d7d6..e328d6735e38 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -2323,7 +2323,7 @@ static inline u32 tcp_timeout_init(struct sock =
*sk)
>>=20
>> 	if (timeout <=3D 0)
>> 		timeout =3D TCP_TIMEOUT_INIT;
>> -	return timeout;
>> +	return min_t(int, timeout, TCP_RTO_MAX);
> Acked-by: Martin KaFai Lau <kafai@fb.com>

