Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3051C2D8A61
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 23:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408098AbgLLWdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 17:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLWdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 17:33:41 -0500
Date:   Sat, 12 Dec 2020 14:32:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607812380;
        bh=lOSlFuxaPOHfM3x9O3vbLyFiOgPHjIhoo7tHSTHocM4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=OwUPoFSwsQvpayAblE1/7mXfC64Uo7PmS9nF1cTJ6sCiFOhDDUtQeSMXoTO+mRKsz
         rWc9njRVZY5Oznxg39uZWsdTPyUDAuJEQsMUUJW5NLTiYDdBfPhvbpoWm0vNn7zS3S
         MCAtYsCNtGguA/ZEQ9TeUzMbfeRFYLqwweoIvnwvAx0ASsCpqg6Q9i0v/7O3L5LSIM
         rqZXWvR6UipgIpfpP++p8rG/WnlChU/6ZsYuTMwRTp8xqY+lVKnDvBKitNtIsPnvZ2
         Wr4ESbdGgiVoRf/9q7snkvRa3709/BIpHTf6gIB6tmSUvRAajzrIKEXPqsH3JLc+op
         uI/DAzcxuM32A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cambda Zhu <cambda@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: Re: [PATCH net-next] net: Limit logical shift left of TCP probe0
 timeout
Message-ID: <20201212143259.581aadae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201208091910.37618-1-cambda@linux.alibaba.com>
References: <20201208091910.37618-1-cambda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Dec 2020 17:19:10 +0800 Cambda Zhu wrote:
> For each TCP zero window probe, the icsk_backoff is increased by one and
> its max value is tcp_retries2. If tcp_retries2 is greater than 63, the
> probe0 timeout shift may exceed its max bits. On x86_64/ARMv8/MIPS, the
> shift count would be masked to range 0 to 63. And on ARMv7 the result is
> zero. If the shift count is masked, only several probes will be sent
> with timeout shorter than TCP_RTO_MAX. But if the timeout is zero, it
> needs tcp_retries2 times probes to end this false timeout. Besides,
> bitwise shift greater than or equal to the width is an undefined
> behavior.

If icsk_backoff can reach 64, can it not also reach 256 and wrap?

Adding Eric's address from MAINTAINERS to CC.

> This patch adds a limit to the backoff. The max value of max_when is
> TCP_RTO_MAX and the min value of timeout base is TCP_RTO_MIN. The limit
> is the backoff from TCP_RTO_MIN to TCP_RTO_MAX.

> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index d4ef5bf94168..82044179c345 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1321,7 +1321,9 @@ static inline unsigned long tcp_probe0_base(const struct sock *sk)
>  static inline unsigned long tcp_probe0_when(const struct sock *sk,
>  					    unsigned long max_when)
>  {
> -	u64 when = (u64)tcp_probe0_base(sk) << inet_csk(sk)->icsk_backoff;
> +	u8 backoff = min_t(u8, ilog2(TCP_RTO_MAX / TCP_RTO_MIN) + 1,
> +			   inet_csk(sk)->icsk_backoff);
> +	u64 when = (u64)tcp_probe0_base(sk) << backoff;
>  
>  	return (unsigned long)min_t(u64, when, max_when);
>  }

