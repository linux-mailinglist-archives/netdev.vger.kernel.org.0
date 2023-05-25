Return-Path: <netdev+bounces-5367-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BD9710EF9
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B53EC2815C9
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF0F168B7;
	Thu, 25 May 2023 15:03:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEA9FC1B;
	Thu, 25 May 2023 15:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4465BC433D2;
	Thu, 25 May 2023 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685026984;
	bh=v5l1gvHWvPer9BfVYzVxNGNE0+xUGwapBdck9MVDveI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZmZmCUKd7mJfuzmwGQ60FzlZnwYhoLCVQrb5gzf30/fJ0TEV+3DxP/a86j64IoMXT
	 CkFldmgrDgfgEda+EtNTp9E0bdHua+Vazuuhele39hrAuF39uH3mTwrFyeb9tRA8rG
	 Bu5WIV7BrRPn+NUOkk5znwpflsqnivDbrBaycVYp79EUNflhOohqOEFjyolNUB4kng
	 ZAk4fkm0CtB5EYVqu7KKenphkuqu4n0Py5TSkI9qfncI/6pP3EtzHknCY+YtlKqbjo
	 69E/md3sUuVp9GWPiqUFUeDbsYoouXQyhEe97FtNyPnqR8fURlxUDOaQnjxpbquGQW
	 03QUMxOYtWHbA==
Message-ID: <83d90ef3-67ba-737e-02fb-dbfb7cc8d2de@kernel.org>
Date: Thu, 25 May 2023 09:03:02 -0600
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
To: Simon Horman <simon.horman@corigine.com>,
 Eric Dumazet <edumazet@google.com>
Cc: Breno Leitao <leitao@debian.org>, willemdebruijn.kernel@gmail.com,
 Remi Denis-Courmont <courmisch@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Alexander Aring <alex.aring@gmail.com>,
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
 <CANn89i+neca0ApNxRdZCiTMkwy-5=0mnOMM=9Z3u78VPNw4_fg@mail.gmail.com>
 <ZG92ox2BWE3rS1xR@corigine.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <ZG92ox2BWE3rS1xR@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/25/23 8:54 AM, Simon Horman wrote:
> On Thu, May 25, 2023 at 04:19:32PM +0200, Eric Dumazet wrote:
>> On Thu, May 25, 2023 at 2:55 PM Breno Leitao <leitao@debian.org> wrote:
>>>
>>> Most of the ioctls to net protocols operates directly on userspace
>>> argument (arg). Usually doing get_user()/put_user() directly in the
>>> ioctl callback.  This is not flexible, because it is hard to reuse these
>>> functions without passing userspace buffers.
>>>
>>> Change the "struct proto" ioctls to avoid touching userspace memory and
>>> operate on kernel buffers, i.e., all protocol's ioctl callbacks is
>>> adapted to operate on a kernel memory other than on userspace (so, no
>>> more {put,get}_user() and friends being called in the ioctl callback).
>>>
>>
>>  diff --git a/include/net/phonet/phonet.h b/include/net/phonet/phonet.h
>>> index 862f1719b523..93705d99f862 100644
>>> --- a/include/net/phonet/phonet.h
>>> +++ b/include/net/phonet/phonet.h
>>> @@ -109,4 +109,23 @@ void phonet_sysctl_exit(void);
>>>  int isi_register(void);
>>>  void isi_unregister(void);
>>>
>>> +#ifdef CONFIG_PHONET
>>> +int phonet_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
>>> +
>>> +static inline bool phonet_is_sk(struct sock *sk)
>>> +{
>>> +       return sk->sk_family == PF_PHONET && sk->sk_protocol == PN_PROTO_PHONET;
>>> +}
>>> +#else
>>> +static inline bool phonet_is_sk(struct sock *sk)
>>> +{
>>> +       return 0;
>>> +}
>>> +
>>> +static inline int phonet_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
>>> +{
>>> +       return 1;
>>> +}
>>> +#endif
>>> +
>>>
>>
>> PHONET can be built as a module, so I guess the compiler would
>> complain if "CONFIG_PHONET=m" ???
> 
> Yes, indeed it does.
> 

phonet_sk_ioctl is simple enough to make an inline in which case this
should go in include//linux/phonet.h.

