Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D3C2C050B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgKWL5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 06:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbgKWL5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 06:57:21 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84827C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 03:57:20 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id a3so16965815wmb.5
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 03:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rlYXaarQWYr1z9FaJrhWlTj9jM6iSzALwXjPhaLgP9M=;
        b=g7aY8SaHFaDFAGRBx+nyswkUbD1mQbY/tWTBxvVsFmXjjsp+UvAoa+8YtdIF+OeCpw
         SHtmrQ6NTkbeIQC45+qsus86mhhD2T2V6vV2PYX0Dx7uRaWZ8ARgmcuKk8KGhdCua0wB
         N0eOEsJyl27Pbk+NylmQ+e12tRZyz5hBIR/oUeigmamzsJP43/6vBr+doiYdyXlWnUEj
         4GJgytD18z7EHsR9Q3bw5u4bhieEn14B4JQkHvCU++M2R1HVIck8UnX37FfGfCQ7rMnP
         RHMmb8aO2t0hdwX74RQej9DocYTaqij1HxVxz6BeMvUIkiFXZ7Dqe3nNKg/w+7SAjrEJ
         cI1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rlYXaarQWYr1z9FaJrhWlTj9jM6iSzALwXjPhaLgP9M=;
        b=GspytIHDp9TVYSoyv7730+VOtGRPkRZ+rVgJ7ICP++2tsjl62hIiv2wCewt28T+o33
         1dhUbEL7YXSn784dhKhqh12FRVUd9XbK8R5WtH8nVze86Kq7qqzCBPxHEDrI6sImamxN
         P7HXai0HBMVDEgA6fPlKR9gU3PzimstDUiSjn2gsBCkJDEZzJqSwvYxZWIEaVIOPejqw
         Cu774hbNok9AhpF0thyhUImLW+PYDweotZZuZxO7PDAkM+Av/r2usMZM6ePMyniaqo5U
         gB9i9DJikGe9Ie93oV3NuHB4slSBDr9Eq307mQ+IkJ5rL+qfIm2LSuVc2/7+XW4ceR2T
         rq5w==
X-Gm-Message-State: AOAM532ykDp6t3UnFOxoNKlk6rsKu4R1/UYkaNUw0XUgWjqF1EuS+RAL
        E1/Hzb0ie0IO/NbKpabOcUo=
X-Google-Smtp-Source: ABdhPJwTPPcAqsTmdP2VSVG2pXq8IvbWhNxlFZjEEA9LEktUN5sYGr/0DCy5AgAfC5cNPITvIeuLew==
X-Received: by 2002:a1c:4884:: with SMTP id v126mr24280812wma.160.1606132639319;
        Mon, 23 Nov 2020 03:57:19 -0800 (PST)
Received: from [192.168.8.114] ([37.164.107.50])
        by smtp.gmail.com with ESMTPSA id d13sm20908780wrb.39.2020.11.23.03.57.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 03:57:18 -0800 (PST)
Subject: Re: [PATCH net-next 10/10] mptcp: refine MPTCP-level ack scheduling
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, kuba@kernel.org,
        mptcp@lists.01.org
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
 <20201119194603.103158-11-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ca0b65f8-7a69-ff4e-9e0d-66a7a923b0c1@gmail.com>
Date:   Mon, 23 Nov 2020 12:57:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201119194603.103158-11-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/20 8:46 PM, Mat Martineau wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> 
> Send timely MPTCP-level ack is somewhat difficult when
> the insertion into the msk receive level is performed
> by the worker.
> 
> It needs TCP-level dup-ack to notify the MPTCP-level
> ack_seq increase, as both the TCP-level ack seq and the
> rcv window are unchanged.
> 
> We can actually avoid processing incoming data with the
> worker, and let the subflow or recevmsg() send ack as needed.
> 
> When recvmsg() moves the skbs inside the msk receive queue,
> the msk space is still unchanged, so tcp_cleanup_rbuf() could
> end-up skipping TCP-level ack generation. Anyway, when
> __mptcp_move_skbs() is invoked, a known amount of bytes is
> going to be consumed soon: we update rcv wnd computation taking
> them in account.
> 
> Additionally we need to explicitly trigger tcp_cleanup_rbuf()
> when recvmsg() consumes a significant amount of the receive buffer.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  net/mptcp/options.c  |   1 +
>  net/mptcp/protocol.c | 105 +++++++++++++++++++++----------------------
>  net/mptcp/protocol.h |   8 ++++
>  net/mptcp/subflow.c  |   4 +-
>  4 files changed, 61 insertions(+), 57 deletions(-)
> 
> diff --git a/net/mptcp/options.c b/net/mptcp/options.c
> index 248e3930c0cb..8a59b3e44599 100644
> --- a/net/mptcp/options.c
> +++ b/net/mptcp/options.c
> @@ -530,6 +530,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
>  		opts->ext_copy.ack64 = 0;
>  	}
>  	opts->ext_copy.use_ack = 1;
> +	WRITE_ONCE(msk->old_wspace, __mptcp_space((struct sock *)msk));
>  
>  	/* Add kind/length/subtype/flag overhead if mapping is not populated */
>  	if (dss_size == 0)
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index 4ae2c4a30e44..748343f1a968 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -407,16 +407,42 @@ static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
>  	mptcp_sk(sk)->timer_ival = tout > 0 ? tout : TCP_RTO_MIN;
>  }
>  
> -static void mptcp_send_ack(struct mptcp_sock *msk)
> +static bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
> +{
> +	struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
> +
> +	/* can't send if JOIN hasn't completed yet (i.e. is usable for mptcp) */
> +	if (subflow->request_join && !subflow->fully_established)
> +		return false;
> +
> +	/* only send if our side has not closed yet */
> +	return ((1 << ssk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT));
> +}
> +
> +static void mptcp_send_ack(struct mptcp_sock *msk, bool force)
>  {
>  	struct mptcp_subflow_context *subflow;
> +	struct sock *pick = NULL;
>  
>  	mptcp_for_each_subflow(msk, subflow) {
>  		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
>  
> -		lock_sock(ssk);
> -		tcp_send_ack(ssk);
> -		release_sock(ssk);
> +		if (force) {
> +			lock_sock(ssk);
> +			tcp_send_ack(ssk);
> +			release_sock(ssk);
> +			continue;
> +		}
> +
> +		/* if the hintes ssk is still active, use it */
> +		pick = ssk;
> +		if (ssk == msk->ack_hint)
> +			break;
> +	}
> +	if (!force && pick) {
> +		lock_sock(pick);
> +		tcp_cleanup_rbuf(pick, 1);

Calling tcp_cleanup_rbuf() on a socket that was never established is going to fail
with a divide by 0 (mss being 0)

AFAIK, mptcp_recvmsg() can be called right after a socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP)
call.

Probably, after a lock_sock(), you should double check socket state (same above before calling tcp_send_ack())



> +		release_sock(pick);
>  	}
>  }
>  


....

>  
> +		/* be sure to advertise window change */
> +		old_space = READ_ONCE(msk->old_wspace);
> +		if ((tcp_space(sk) - old_space) >= old_space)
> +			mptcp_send_ack(msk, false);
> +

Yes, if we call recvmsg() right after socket(), we will end up calling tcp_cleanup_rbuf(),
while no byte was ever copied/drained.

