Return-Path: <netdev+bounces-3417-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE019706F97
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:37:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DDD52815AB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD17A31EE4;
	Wed, 17 May 2023 17:37:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FCF31133
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 17:37:44 +0000 (UTC)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1F01A7
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:37:35 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0ViteIPY_1684345052;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0ViteIPY_1684345052)
          by smtp.aliyun-inc.com;
          Thu, 18 May 2023 01:37:33 +0800
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: net: getsockopt(TCP_MAXSEG) on listen sock returns wrong MSS?
From: Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=3u+UyLBmGmifHA@mail.gmail.com>
Date: Thu, 18 May 2023 01:37:20 +0800
Cc: netdev@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>,
 Tony Lu <tonylu@linux.alibaba.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <17B26478-41C0-46BD-B47F-812DA12A3699@linux.alibaba.com>
References: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
 <CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=3u+UyLBmGmifHA@mail.gmail.com>
To: Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> On May 17, 2023, at 23:58, Eric Dumazet <edumazet@google.com> wrote:
>=20
> On Wed, May 17, 2023 at 1:09=E2=80=AFPM Cambda Zhu =
<cambda@linux.alibaba.com> wrote:
>>=20
>> I want to call setsockopt(TCP_MAXSEG) on a listen sock to let
>> all child socks have smaller MSS. And I found the child sock
>> MSS changed but getsockopt(TCP_MAXSEG) on the listen sock
>> returns 536 always.
>>=20
>=20
> I think TCP_MAXSEG is not like a traditional option you can set and =
get later,
> expecting to read back the value you set.
>=20
> It is probably a bug.
>=20
> Getting tp->mss_cache should have been a separate socket option, but
> it is too late.
>=20

I understand now. It seems setting/getting TCP_MAXSEG has different =
meaning. :)

>=20
>> It seems the tp->mss_cache is initialized with TCP_MSS_DEFAULT,
>> but getsockopt(TCP_MAXSEG) returns tp->rx_opt.user_mss only when
>> tp->mss_cache is 0. I don't understand the purpose of the mss_cache
>> check of TCP_MAXSEG. If getsockopt(TCP_MAXSEG) on listen sock makes
>> no sense, why does it have a branch for close/listen sock to return
>> user_mss? If getsockopt(TCP_MAXSEG) on listen sock is ok, why does
>> it check mss_cache for a listen sock?
>>=20
>> I tried to find the commit log about TCP_MAXSEG, and found that
>> in commit 0c409e85f0ac ("Import 2.3.41pre2"), the mss_cache check
>> was added. No more detailed information found. Is this a bug or am
>> I misunderstanding something?
>=20
> I wonder if we should simply do:
>=20
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index =
4d6392c16b7a5a9a853c27e3a4b258d000738304..cb526257a06a6c7a4e65e710fff1770b=
d382ed2d
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4080,9 +4080,10 @@ int do_tcp_getsockopt(struct sock *sk, int =
level,
>=20
>        switch (optname) {
>        case TCP_MAXSEG:
> -               val =3D tp->mss_cache;
> -               if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | =
TCPF_LISTEN)))
> +               if (((1 << sk->sk_state) & (TCPF_CLOSE | =
TCPF_LISTEN)))
>                        val =3D tp->rx_opt.user_mss;
> +               else
> +                       val =3D tp->mss_cache;
>                if (tp->repair)
>                        val =3D tp->rx_opt.mss_clamp;
>                break;

This fix is a good solution for me. Will you send a patch later?

Thanks,
Cambda


