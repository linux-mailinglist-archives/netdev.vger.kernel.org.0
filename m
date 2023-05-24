Return-Path: <netdev+bounces-4876-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B7270EF22
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D67E1C209BA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDF379D1;
	Wed, 24 May 2023 07:12:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531F629A0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:12:37 +0000 (UTC)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B9F211F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 00:12:11 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VjN6tgb_1684912243;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VjN6tgb_1684912243)
          by smtp.aliyun-inc.com;
          Wed, 24 May 2023 15:10:44 +0800
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net-next] net: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state
From: Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <CANn89iJmsM1YH01MsuDovn2LAKTQopOBjg6LNP8Uy_jOJh1+5Q@mail.gmail.com>
Date: Wed, 24 May 2023 15:10:32 +0800
Cc: Paolo Abeni <pabeni@redhat.com>,
 Jason Xing <kerneljasonxing@gmail.com>,
 netdev@vger.kernel.org,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>,
 Tony Lu <tonylu@linux.alibaba.com>,
 Jack Yang <mingliang@linux.alibaba.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <14D45862-36EA-4076-974C-EA67513C92F6@linux.alibaba.com>
References: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
 <20230519080118.25539-1-cambda@linux.alibaba.com>
 <f55cd2026c6cc01e19f2248ef4ed27b7b8ad11e1.camel@redhat.com>
 <CANn89iJmsM1YH01MsuDovn2LAKTQopOBjg6LNP8Uy_jOJh1+5Q@mail.gmail.com>
To: Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After I did a deep search about the TCP_MAXSEG, I found this is a bit
more complicated than I think before.

I don't know whether the TCP_MAXSEG is from BSD or not, but if the
"UNIX Network Programming" is right, getting TCP_MAXSEG returns default
MSS before connecting is as expect, that's what FreeBSD does. If we
simply remove the !val check for it, getting TCP_MAXSEG will return zero
before connecting, because tp->rx_opt.user_mss is initialized with zero
on Linux, while tp->t_maxseg is initialized with default MSS on FreeBSD.

I googled to see how it's used by developers now, and I think getting
TCP_MAXSEG should return default MSS if before connecting and user_mss
not set, for backward compatibility.

But the !val check is a bug also, and the problem is not discovered for
the first time.
=
https://stackoverflow.com/questions/25996741/why-getsockopt-does-not-retur=
n-the-expected-value-for-tcp-maxseg

I think it should be:

- if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
+ if (tp->rx_opt.user_mss && ((1 << sk->sk_state) & (TCPF_CLOSE | =
TCPF_LISTEN)))

With this change, getting TCP_MAXSEG will return default MSS as book
described, and return user_mss if user_mss is set and before connecting.
The tp->t_maxseg will only decrease on FreeBSD and we don't. I think
our solution is better.

I'll send a new patch later.


Regards,
Cambda=

