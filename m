Return-Path: <netdev+bounces-6076-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FAA714BCC
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FD5D280E95
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7833C8486;
	Mon, 29 May 2023 14:13:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA9B747D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:13:10 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E921A8;
	Mon, 29 May 2023 07:13:08 -0700 (PDT)
Received: from [10.10.2.69] (unknown [10.10.2.69])
	by mail.ispras.ru (Postfix) with ESMTPSA id 7CC8140737A9;
	Mon, 29 May 2023 14:13:05 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 7CC8140737A9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1685369585;
	bh=t+YywsZU6PnkHg+BfRIG6e+gnjSJaTvbXxvrq8xuUqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Hi8BK6i2d3GUZV+cp/fTh9k2HY6sKrP3Vu699Ca6Uz0ee+xTlMqVkPg/E1rYIq34C
	 cALtzG/ZSESN0rdALE2P2Qc7KNuf3G6qQxpvi+rIhmQVhnr1ZFKkvvD6aKmRnWFCia
	 KgclMmVlbXlxE8iMpx8FJPV2gVpHuFZ5iP/8q6wE=
Message-ID: <3bffa44a-b98c-85d9-9d5f-1b52943a7f2f@ispras.ru>
Date: Mon, 29 May 2023 17:13:05 +0300
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
To: Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, David Ahern
 <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20230526150806.1457828-1-VEfanov@ispras.ru>
 <27614af23cd7ae4433b909194062c553a6ae16ac.camel@redhat.com>
 <027d28a0-b31b-ab42-9eb6-2826c04c9364@ispras.ru>
 <815ce4d97f6d673799ee7a94d90eeda58b1e51e4.camel@redhat.com>
From: Vlad Efanov <vefanov@ispras.ru>
In-Reply-To: <815ce4d97f6d673799ee7a94d90eeda58b1e51e4.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thank you for detail information.

The patch is reworked and being tested now.


Vlad.

On 26.05.2023 21:13, Paolo Abeni wrote:
> On Fri, 2023-05-26 at 18:58 +0300, Ефанов Владислав Александрович
> wrote:
>> I don't think that we can just move sk_dst_set() call.
>>
>> I think we can destroy dst of sendmsg task in this case.
> AFAICS ip6_sk_dst_lookup_flow tries to acquire a reference to the
> cached dst. If the connect() clears the cache, decreasing the refcnt,
> the counter of the dst in use by sendmsg() must still be non zero.
>
> IMHO the problem you see is that sk_setup_caps() keeps using the dst
> after transferring the ownership to the dst cache, which is illegal.
> The suggested patch addressed that.
>
> If I'm wrong your syzkaller repro will keep splatting. Please have just
> have a spin, thanks.
>
> Paolo
>

