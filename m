Return-Path: <netdev+bounces-4903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9F970F1D8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:11:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFE2E1C20AF3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD1EC2D0;
	Wed, 24 May 2023 09:11:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40795C15F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:11:11 +0000 (UTC)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A42C12B
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:11:09 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VjNZZFP_1684919465;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VjNZZFP_1684919465)
          by smtp.aliyun-inc.com;
          Wed, 24 May 2023 17:11:06 +0800
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net v1] tcp: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state if user_mss set
From: Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <20230524083350.54197-1-cambda@linux.alibaba.com>
Date: Wed, 24 May 2023 17:10:54 +0800
Cc: Jason Xing <kerneljasonxing@gmail.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>,
 Tony Lu <tonylu@linux.alibaba.com>,
 Jack Yang <mingliang@linux.alibaba.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FB0C4E1D-1558-4EFC-BCC4-E6E8C6F01B7A@linux.alibaba.com>
References: <20230524083350.54197-1-cambda@linux.alibaba.com>
To: netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> On May 24, 2023, at 16:33, Cambda Zhu <cambda@linux.alibaba.com> =
wrote:
>=20
> This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
> with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
> tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
> it's zero is probably a bug.
>=20
> With this change, getting TCP_MAXSEG before connecting will return
> default MSS normally, and return user_mss if user_mss is set.
>=20
> Fixes: 0c409e85f0ac ("Import 2.3.41pre2")
> Reported-by: Jack Yang <mingliang@linux.alibaba.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Link: =
https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=3D3u+U=
yLBmGmifHA@mail.gmail.com/#t
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> Link: =
https://lore.kernel.org/netdev/14D45862-36EA-4076-974C-EA67513C92F6@linux.=
alibaba.com/
> ---
> v1:
> - Return default MSS if user_mss not set for backwards compatibility.
> - Send patch to net instead of net-next, with Fixes tag.
> - Add Eric's tags.
> ---
> net/ipv4/tcp.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 4d6392c16b7a..3e01a58724b8 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4081,7 +4081,8 @@ int do_tcp_getsockopt(struct sock *sk, int =
level,
> switch (optname) {
> case TCP_MAXSEG:
> val =3D tp->mss_cache;
> - if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> + if (tp->rx_opt.user_mss &&
> +    ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> val =3D tp->rx_opt.user_mss;
> if (tp->repair)
> val =3D tp->rx_opt.mss_clamp;
> --=20
> 2.16.6

I see netdev/verify_fixes check failed for the commit 0c409e85f0ac =
("Import 2.3.41pre2").
The commit is from:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Should I remove the Fixes tag?

Thanks!

Cambda=

