Return-Path: <netdev+bounces-5381-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4342F710FAF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:34:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A506F28104E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA64B19927;
	Thu, 25 May 2023 15:34:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FC5156E9;
	Thu, 25 May 2023 15:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C46C433D2;
	Thu, 25 May 2023 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685028854;
	bh=ZwxDw4oLnHr9NVa2Db8a36we5S0GgqD9byINGJspxSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KehClfljd08SNiuPE4jni76oBuDKLXGUmANCqL7/UO6wUHMuyIm+n6ggIVVhoUlmY
	 LREtu62b1a1RCt93q7jbljeXRCl9QNxYgWMn4GUm577jivEdaP/AXvOIs8fJc35k0R
	 W5VQNhj/k4TlaFwOnpY2sTmJ/dVZpS509wvLrM8BojgLntvl5xUQq34Doi9w1Lty+9
	 9MmOX8aaMLPUqgeAAdpNvzF0oKVdnzkrCUvtq90WqfMlNODzJgdZ7DNKOuWG1krc+g
	 Km06GOnkf69sxnPQTjBzhzozkwkVi41IYH2B5rC+ZVAwySJNZ5I31mHb7vj28Gs+IR
	 8RMVYyqfndX+g==
Message-ID: <a1074987-c3ce-56cd-3005-beb5a3c55ef9@kernel.org>
Date: Thu, 25 May 2023 09:34:12 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v3] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Content-Language: en-US
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Breno Leitao <leitao@debian.org>
Cc: Remi Denis-Courmont <courmisch@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Alexander Aring <alex.aring@gmail.com>,
 Stefan Schmidt <stefan@datenfreihafen.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Matthieu Baerts <matthieu.baerts@tessares.net>,
 Mat Martineau <martineau@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, leit@fb.com, axboe@kernel.dk,
 asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org,
 mptcp@lists.linux.dev, linux-sctp@vger.kernel.org
References: <20230525125503.400797-1-leitao@debian.org>
 <CAF=yD-LHQNkgPb-R==53-2auVxkP9r=xqrz2A8oe61vkoDdWjg@mail.gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <CAF=yD-LHQNkgPb-R==53-2auVxkP9r=xqrz2A8oe61vkoDdWjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/25/23 9:05 AM, Willem de Bruijn wrote:
>> +/* A wrapper around sock ioctls, which copies the data from userspace
>> + * (depending on the protocol/ioctl), and copies back the result to userspace.
>> + * The main motivation for this function is to pass kernel memory to the
>> + * protocol ioctl callbacks, instead of userspace memory.
>> + */
>> +int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
>> +{
>> +       int rc = 1;
>> +
>> +       if (ipmr_is_sk(sk))
>> +               rc = ipmr_sk_ioctl(sk, cmd, arg);
>> +       else if (ip6mr_is_sk(sk))
>> +               rc = ip6mr_sk_ioctl(sk, cmd, arg);
>> +       else if (phonet_is_sk(sk))
>> +               rc = phonet_sk_ioctl(sk, cmd, arg);
> 
> I don't understand what this buys us vs testing the sk_family,
> sk_protocol and cmd here.

To keep protocol specific code out of core files is the reason I
suggested it.

> 
> It introduces even deeper dependencies on the protocol specific
> header files. And the CONFIG issues that result from that. And it
> adds a bunch of wrappers that are only used once.
> 



