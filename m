Return-Path: <netdev+bounces-5771-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 076EF712B48
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD3A71C210A5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4783928C04;
	Fri, 26 May 2023 17:00:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A883271F6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:00:14 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E255125;
	Fri, 26 May 2023 10:00:10 -0700 (PDT)
Received: from [10.10.2.69] (unknown [10.10.2.69])
	by mail.ispras.ru (Postfix) with ESMTPSA id AEF2344C100F;
	Fri, 26 May 2023 17:00:08 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru AEF2344C100F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1685120408;
	bh=K6mspQaxjuMVv9+CF48XVDc5ehAnfgeTpsYDWKVwgzg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kmqIq9Bkpq4xhXGEF6Ci7/dJXUYCiwy9CmVggLFqEk3Ebkt8lZLKdv0RGtC35J2Mq
	 fqSroNe5jEXynE0U/HJSTIQhu3VxWF0mjCgGiCu3WhPliktUI5Bik6svHXRlI+VI5W
	 EhObld1L/vPEp+dXgw47N2de1PJkZIOy0ll/vhLw=
Message-ID: <7a8b806f-14f5-5965-8915-0cd0b2473338@ispras.ru>
Date: Fri, 26 May 2023 20:00:08 +0300
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
Cc: Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20230526150806.1457828-1-VEfanov@ispras.ru>
 <27614af23cd7ae4433b909194062c553a6ae16ac.camel@redhat.com>
 <027d28a0-b31b-ab42-9eb6-2826c04c9364@ispras.ru>
 <CANn89iLGOVwW-KHBuJ94E+QoVARWw5EBKyfh0mPkOT+5ws31Fw@mail.gmail.com>
 <d3fccbd0-c92e-9aff-8c32-48c1171746c3@ispras.ru>
 <CANn89i+UYRXD16epov9x7+Zr5vCKL+DTCidsOaQdMBjWMmK8CA@mail.gmail.com>
From: Vlad Efanov <vefanov@ispras.ru>
In-Reply-To: <CANn89i+UYRXD16epov9x7+Zr5vCKL+DTCidsOaQdMBjWMmK8CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I will rework the patch.

Best regards,

Vlad.


On 26.05.2023 19:47, Eric Dumazet wrote:
> On Fri, May 26, 2023 at 6:41 PM Vlad Efanov <vefanov@ispras.ru> wrote:
>> sk_dst_set() is called by sk_setup_caps().
>>
>> sk_dst_set() replaces dst in socket using xchg() call and we still have
>> two tasks use one socket but expect different dst in sk_dst_cache.
>>
>>
>> __sk_dst_set() is rcu protected, but it checks for socket lock.
>>
>>
>> static inline void
>> __sk_dst_set(struct sock *sk, struct dst_entry *dst)
>> {
>>       struct dst_entry *old_dst;
>>
>>       sk_tx_queue_clear(sk);
>>       sk->sk_dst_pending_confirm = 0;
>>       old_dst = rcu_dereference_protected(sk->sk_dst_cache,
>>                           lockdep_sock_is_held(sk));
>>       rcu_assign_pointer(sk->sk_dst_cache, dst);
>>       dst_release(old_dst);
>> }
> I am quite familiar with this code.
>
> What are you trying to say exactly ?
>
> Please come with a V2 without grabbing the socket lock.

