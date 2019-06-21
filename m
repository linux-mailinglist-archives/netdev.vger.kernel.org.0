Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EF44ED85
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfFUQ7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:59:46 -0400
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:48882 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbfFUQ7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 12:59:45 -0400
X-Greylist: delayed 7764 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jun 2019 12:59:44 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id x5LEWCGX056758;
        Fri, 21 Jun 2019 07:50:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=mime-version :
 content-type : sender : content-transfer-encoding : from : subject : date
 : message-id : references : cc : in-reply-to : to; s=20180706;
 bh=MAS72gXIipSQElTQDNhMasZswrxCuR0t732RihcAB6o=;
 b=SmNTGDF+yw9vBH0JzZOON/lSL8U1CY/pyXx/iU/RPaNqGP2iWwsFZiYzIhOrm3Zl+FMa
 O7HwdYhUEEyBjKGIoxLXLJfQqIw7ouZJ+ljWdTPrFbhIoMu0AUxYkBEQ4pXhEcaUQy08
 tpn/x8RQrN0XsB9MrSsxaHglFm8sXpYE5EafyeZJvxF8L9j5qzgnPDEvWZpLQm0KhwqG
 yQQn7jfb5pqexDYBzuryOFvMNV7JmRweS/979fobGKuOcFbKlKqAyMxF4yFGYUPHmO+9
 yQuCn4vxVcCN2Nvc2YCSdgaxi5+dA9E6BTCWRo6iwg6fRmOcQVNeVOOuNdLZC0H9CPi+ RQ== 
Received: from mr2-mtap-s03.rno.apple.com (mr2-mtap-s03.rno.apple.com [17.179.226.135])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 2t77yh2y0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 21 Jun 2019 07:50:14 -0700
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Received: from ma1-mmpp-sz08.apple.com
 (ma1-mmpp-sz08.apple.com [17.171.128.176]) by mr2-mtap-s03.rno.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0PTG00GP8EJPCD30@mr2-mtap-s03.rno.apple.com>; Fri,
 21 Jun 2019 07:50:13 -0700 (PDT)
Received: from process_milters-daemon.ma1-mmpp-sz08.apple.com by
 ma1-mmpp-sz08.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PTG00E00DYJBF00@ma1-mmpp-sz08.apple.com>; Fri,
 21 Jun 2019 07:50:13 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: bc678b9122560d8c54cbc590864445c6
X-Va-E-CD: 926145c2a755c95e264e3bb54de443a0
X-Va-R-CD: 529e77057a3221d602404d42522b11d5
X-Va-CD: 0
X-Va-ID: 5954521f-375e-4010-a7d4-e171c82b7783
X-V-A:  
X-V-T-CD: bc678b9122560d8c54cbc590864445c6
X-V-E-CD: 926145c2a755c95e264e3bb54de443a0
X-V-R-CD: 529e77057a3221d602404d42522b11d5
X-V-CD: 0
X-V-ID: fa6fc1be-0f40-41d4-9816-02ab9e23c0a9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-06-21_10:,, signatures=0
Received: from [17.234.145.56] (unknown [17.234.145.56])
 by ma1-mmpp-sz08.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PTG00KTZEJEDM20@ma1-mmpp-sz08.apple.com>; Fri,
 21 Jun 2019 07:50:13 -0700 (PDT)
Content-transfer-encoding: quoted-printable
From:   Christoph Paasch <cpaasch@apple.com>
Subject: Re: [PATCH net] tcp: refine memory limit test in tcp_fragment()
Date:   Fri, 21 Jun 2019 07:50:00 -0700
Message-id: <848C9ED5-6AE6-437F-8261-75EA43359140@apple.com>
References: <20190621130955.147974-1-edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-reply-to: <20190621130955.147974-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
X-Mailer: iPhone Mail (17A517a)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_10:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 21, 2019, at 6:11 AM, Eric Dumazet <edumazet@google.com> wrote:
>=20
> =EF=BB=BFtcp_fragment() might be called for skbs in the write queue.
>=20
> Memory limits might have been exceeded because tcp_sendmsg() only
> checks limits at full skb (64KB) boundaries.
>=20
> Therefore, we need to make sure tcp_fragment() wont punish applications
> that might have setup very low SO_SNDBUF values.
>=20
> Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits"=
)
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> ---
> net/ipv4/tcp_output.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)

Tested-by: Christoph Paasch <cpaasch@apple.com>


Thanks!


>=20
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 00c01a01b547ec67c971dc25a74c9258563cf871..0ebc33d1c9e5099d163a234930=
e213ee35e9fbd1 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1296,7 +1296,8 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp=
_queue,
>    if (nsize < 0)
>        nsize =3D 0;
>=20
> -    if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
> +    if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
> +             tcp_queue !=3D TCP_FRAG_IN_WRITE_QUEUE)) {
>        NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
>        return -ENOMEM;
>    }
> --=20
> 2.22.0.410.gd8fdbe21b5-goog
>=20
