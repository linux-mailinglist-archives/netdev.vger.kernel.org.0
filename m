Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4823DB8BC
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 14:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238723AbhG3Mih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 08:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbhG3Mif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 08:38:35 -0400
X-Greylist: delayed 83 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 30 Jul 2021 05:38:31 PDT
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A80BC06175F;
        Fri, 30 Jul 2021 05:38:31 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id BE03D2E1655;
        Fri, 30 Jul 2021 15:37:04 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id QbxGsJvd91-b3xGXMci;
        Fri, 30 Jul 2021 15:37:04 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1627648624; bh=8OxDtLWDACtxhUoRa/qI4QoNR247rdd0XQja6cQc6LI=;
        h=To:Message-Id:References:Date:Subject:Cc:In-Reply-To:From;
        b=ULROYcaFAnq9LUGttm98E0K0oKB/brjiIM8lM+mTR2Wiaem9M2mIvTDUTBtckflDl
         hjBFr6tbY+ZWnIx9ivBaZYzhYm9APjne97nMPStp348xhTxyYCUREXcADp/ND5TT8r
         WR05OLVfk3fWaz4hsdrsvXTrKE9liOG820QSPo7Y=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:1223::1:16])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id DFWt3dCxsd-b33mR81X;
        Fri, 30 Jul 2021 15:37:03 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] tcp: use rto_min value from socket in retransmits timeout
From:   Dmitry Yakunin <zeil@yandex-team.ru>
In-Reply-To: <CADVnQykVQhT_4f2CV6cAqx_oFvQ-vvq-S0Pnw0a6cnXFuJnPpg@mail.gmail.com>
Date:   Fri, 30 Jul 2021 15:37:03 +0300
Cc:     kafai@fb.com, edumazet@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dmtrmonakhov@yandex-team.ru,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        mitradir@yandex-team.ru
Content-Transfer-Encoding: quoted-printable
Message-Id: <E09A2DA0-A741-4566-B8C6-09C563546538@yandex-team.ru>
References: <20210723093938.49354-1-zeil@yandex-team.ru>
 <CADVnQykVQhT_4f2CV6cAqx_oFvQ-vvq-S0Pnw0a6cnXFuJnPpg@mail.gmail.com>
To:     Neal Cardwell <ncardwell@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Neal!

Thanks for your reply and explanations.

I agree with all your points, about safe defaults for both timeouts and =
the number of retries. But what the patch does is not changing the =
defaults, it only provides a way to work with these values through bpf, =
which is important in an environment that is way different from cellular =
networks. For example in the modern DC the rto_min value should =
correspond with real RTT, that definitely not 200ms.

Also I add Alexander Azimov for further discussions.

--
Dmitry

> On 23 Jul 2021, at 17:41, Neal Cardwell <ncardwell@google.com> wrote:
>=20
> .(On Fri, Jul 23, 2021 at 5:41 AM Dmitry Yakunin <zeil@yandex-team.ru> =
wrote:
>>=20
>> Commit ca584ba07086 ("tcp: bpf: Add TCP_BPF_RTO_MIN for =
bpf_setsockopt")
>> adds ability to set rto_min value on socket less then default =
TCP_RTO_MIN.
>> But retransmits_timed_out() function still uses TCP_RTO_MIN and
>> tcp_retries{1,2} sysctls don't work properly for tuned socket values.
>>=20
>> Fixes: ca584ba07086 ("tcp: bpf: Add TCP_BPF_RTO_MIN for =
bpf_setsockopt")
>> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
>> Acked-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
>> ---
>> net/ipv4/tcp_timer.c | 7 ++++---
>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
>> index 20cf4a9..66c4b97 100644
>> --- a/net/ipv4/tcp_timer.c
>> +++ b/net/ipv4/tcp_timer.c
>> @@ -199,12 +199,13 @@ static unsigned int tcp_model_timeout(struct =
sock *sk,
>>  *  @boundary: max number of retransmissions
>>  *  @timeout:  A custom timeout value.
>>  *             If set to 0 the default timeout is calculated and =
used.
>> - *             Using TCP_RTO_MIN and the number of unsuccessful =
retransmits.
>> + *             Using icsk_rto_min value from socket or RTAX_RTO_MIN =
from route
>> + *             and the number of unsuccessful retransmits.
>>  *
>>  * The default "timeout" value this function can calculate and use
>>  * is equivalent to the timeout of a TCP Connection
>>  * after "boundary" unsuccessful, exponentially backed-off
>> - * retransmissions with an initial RTO of TCP_RTO_MIN.
>> + * retransmissions with an initial RTO of icsk_rto_min or =
RTAX_RTO_MIN.
>>  */
>> static bool retransmits_timed_out(struct sock *sk,
>>                                  unsigned int boundary,
>> @@ -217,7 +218,7 @@ static bool retransmits_timed_out(struct sock =
*sk,
>>=20
>>        start_ts =3D tcp_sk(sk)->retrans_stamp;
>>        if (likely(timeout =3D=3D 0)) {
>> -               unsigned int rto_base =3D TCP_RTO_MIN;
>> +               unsigned int rto_base =3D tcp_rto_min(sk);
>>=20
>>                if ((1 << sk->sk_state) & (TCPF_SYN_SENT | =
TCPF_SYN_RECV))
>>                        rto_base =3D tcp_timeout_init(sk);
>> --
>=20
> I would argue strenuously against this. We tried the approach in this
> patch at Google years ago, but we had to revert that approach and go
> back to using TCP_RTO_MIN as the baseline for the computation, because
> using the custom tcp_rto_min(sk) caused serious reliability problems.
>=20
> The behavior in this patch causes various serious reliability problems
> because the retransmits_timed_out() computation is used for various
> timeout decisions that determine how long a connection tries to
> retransmit something before deciding the path is bad and/or giving up
> and closing the connection. Here are a few of the problems this
> causes:
>=20
> (1) The biggest one is probably orphan retries. By default
> tcp_orphan_retries() uses a retry count of 8. But if your min_rto is
> 5ms (used at Google for many years), then the 8 retries means an
> orphaned connection (whose fd is no longer held by a process, but is
> still established) only lasts for 1.275 seconds before giving up and
> closing. This means that connectivity problems longer than 1.275
> seconds (extremely common with cellular links) are not tolerated for
> such connections; the connections often do not receive the data they
> were supposed to receive.
>=20
> (2) TCP_RETR1 /sysctl_tcp_retries1, used for __dst_negative_advice(),
> also has big problems. Even with a min_rto as big as 20ms, on a route
> with 150ms RTT, the approach in this patch will cause
> retransmits_timed_out() to return true upon the 1st RTO timer firing,
> even though TCP_RETR1 is 3.
>=20
> (3) TCP_RETR2 /sysctl_tcp_retries2, with a default of 15, used for
> regular connection retry lifetimes, also has a massive decrease in
> robustness, due to falling from  109 minutes with a 200ms RTO, to
> about 2.7 minutes with a min_rto of 5ms.
>=20
> neal

