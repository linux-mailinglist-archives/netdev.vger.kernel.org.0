Return-Path: <netdev+bounces-5750-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D25712A3A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:10:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 948FC1C20F90
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B67A2771C;
	Fri, 26 May 2023 16:09:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21544742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:09:45 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45392119;
	Fri, 26 May 2023 09:09:43 -0700 (PDT)
Received: from [10.10.2.69] (unknown [10.10.2.69])
	by mail.ispras.ru (Postfix) with ESMTPSA id 80F0544C100F;
	Fri, 26 May 2023 16:09:41 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 80F0544C100F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1685117381;
	bh=sc/e4YbfJ8QW8+zY9SQfw6Qah/OograOaVZz9GmWE6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iPZxKhTGz4uB7XNm8VErRhtWXm5gnlzFnp6XjJQFIigsvrE5I4Ai25bZKIc/7xIG+
	 qzaMwQzB2aBoQtPYqDVg/GmjOpo9Udyu3HNxR4UguqJI9m8e0zfXTObdfjG+ZtdVui
	 OIrH+yu4xDiucnHcTJ1Vnc9JHP5IXN6ik/YWrQrc=
Message-ID: <c63e08fc-7abf-24fb-fc1e-9ecf36618aa6@ispras.ru>
Date: Fri, 26 May 2023 19:09:41 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] udp6: Fix race condition in udp6_sendmsg & connect
Content-Language: ru
To: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20230526150806.1457828-1-VEfanov@ispras.ru>
 <CANn89i+p7_UB8Z5FQ+iWg4G_caAnUf9W4P-t+VOzigUuJo+qRw@mail.gmail.com>
From: Vlad Efanov <vefanov@ispras.ru>
In-Reply-To: <CANn89i+p7_UB8Z5FQ+iWg4G_caAnUf9W4P-t+VOzigUuJo+qRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Eric,


udp6_sendmsg() currently still locks the socket (on line 1595).


Best regards,

Vlad.


On 26.05.2023 18:29, Eric Dumazet wrote:
> On Fri, May 26, 2023 at 5:08 PM Vladislav Efanov <VEfanov@ispras.ru> wrote:
>> Syzkaller got the following report:
>> BUG: KASAN: use-after-free in sk_setup_caps+0x621/0x690 net/core/sock.c:2018
>> Read of size 8 at addr ffff888027f82780 by task syz-executor276/3255
> Please include a full report.
>
>> The function sk_setup_caps (called by ip6_sk_dst_store_flow->
>> ip6_dst_store) referenced already freed memory as this memory was
>> freed by parallel task in udpv6_sendmsg->ip6_sk_dst_lookup_flow->
>> sk_dst_check.
>>
>>            task1 (connect)              task2 (udp6_sendmsg)
>>          sk_setup_caps->sk_dst_set |
>>                                    |  sk_dst_check->
>>                                    |      sk_dst_set
>>                                    |      dst_release
>>          sk_setup_caps references  |
>>          to already freed dst_entry|
>
>> The reason for this race condition is: udp6_sendmsg() calls
>> ip6_sk_dst_lookup() without lock for sock structure and tries to
>> allocate/add dst_entry structure to sock structure in parallel with
>> "connect" task.
>>
>> Found by Linux Verification Center (linuxtesting.org) with syzkaller.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> This is a bogus Fixes: tag
>
> In old times, UDP sendmsg() was using the socket lock.
>
> Then, in linux-4.0 Vlad Yasevich made UDP v6 sendmsg() lockless (and
> racy in many points)
>
>
>> Signed-off-by: Vladislav Efanov <VEfanov@ispras.ru>
>> ---
>>   net/ipv6/udp.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>> index e5a337e6b970..a5ecd5d93b0a 100644
>> --- a/net/ipv6/udp.c
>> +++ b/net/ipv6/udp.c
>> @@ -1563,12 +1563,15 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>
>>          fl6->flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6->flowlabel);
>>
>> +       lock_sock(sk);
>>          dst = ip6_sk_dst_lookup_flow(sk, fl6, final_p, connected);
>>          if (IS_ERR(dst)) {
>>                  err = PTR_ERR(dst);
>>                  dst = NULL;
>> +               release_sock(sk);
>>                  goto out;
>>          }
>> +       release_sock(sk);
>>
>>          if (ipc6.hlimit < 0)
>>                  ipc6.hlimit = ip6_sk_dst_hoplimit(np, fl6, dst);
>> --
>> 2.34.1
>>
> There must be another way really.
> You just killed UDP performance.

