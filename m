Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AA72DA4B4
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 01:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgLOA0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 19:26:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728964AbgLOA0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 19:26:30 -0500
Date:   Mon, 14 Dec 2020 16:25:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607991948;
        bh=MwrnljA3mSqLxG4DFVsct+Nl6qqacQCy4nWl1O7lve4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=R07HM43EwsWiAamqKVZNfylYvvZG1ZIIRuONQ2m8udw0gnwuMc63drn3l9DQZKoSn
         iNTW2wocG10QdaLNqP4oLPzqdNv1f8L9ACF8TFsfBS1XagQx4y4nl/4CEJxAvRMdoG
         DiWQsMDwQ1j2ApTDwpheA6dnVp1zBRfuCDVHGqR0jAzA3hwvYWciuEhtcbz/LfKE8k
         nF8EpwnnF3qUo1+L+Jg3Sne4Axjw4jBU9GYYwp8tSxy8MkcdvVIhvymYYZBFLfYEh0
         433aofp5MM/lEMVCg5kbrRAyXNYdOl3qnueOIbkzzDIgee5Vf1tNMHgtjQn4PfaAOB
         qOJQB0Ij87UpQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com
Subject: Re: [net-next 2/2] tcp: Add receive timestamp support for receive
 zerocopy.
Message-ID: <20201214162547.110e7a5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211184419.1271335-3-arjunroy.kdev@gmail.com>
References: <20201211184419.1271335-1-arjunroy.kdev@gmail.com>
        <20201211184419.1271335-3-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 10:44:19 -0800 Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> tcp_recvmsg() uses the CMSG mechanism to receive control information
> like packet receive timestamps. This patch adds CMSG fields to
> struct tcp_zerocopy_receive, and provides receive timestamps
> if available to the user.
> 
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

>  			      struct scm_timestamping_internal *tss,
>  			      int *cmsg_flags);
>  static int receive_fallback_to_copy(struct sock *sk,
> -				    struct tcp_zerocopy_receive *zc, int inq)
> +				    struct tcp_zerocopy_receive *zc, int inq,
> +				    struct scm_timestamping_internal *tss)
>  {
>  	unsigned long copy_address = (unsigned long)zc->copybuf_address;
> -	struct scm_timestamping_internal tss_unused;
> -	int err, cmsg_flags_unused;
> +	int err;
>  	struct msghdr msg = {};
>  	struct iovec iov;
>  

rev xmas tree

> @@ -1913,17 +1927,24 @@ static int tcp_zerocopy_handle_leftover_data(struct tcp_zerocopy_receive *zc,
>  					     struct sock *sk,
>  					     struct sk_buff *skb,
>  					     u32 *seq,
> -					     s32 copybuf_len)
> +					     s32 copybuf_len,
> +					     struct scm_timestamping_internal
> +						*tss)

I appreciate the attempt to make the code fit 80 chars, but this
particular wrapping does more harm than good.

> @@ -4116,6 +4138,30 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
>  		default:
>  			goto zerocopy_rcv_out;
>  		}
> +zerocopy_rcv_cmsg:
> +		if (zc.msg_flags & TCP_CMSG_TS) {
> +			unsigned long msg_control_addr;
> +			struct msghdr cmsg_dummy;
> +
> +			msg_control_addr = (unsigned long)zc.msg_control;
> +			cmsg_dummy.msg_control = (void *)msg_control_addr;
> +			cmsg_dummy.msg_controllen =
> +				(__kernel_size_t)zc.msg_controllen;
> +			cmsg_dummy.msg_flags = in_compat_syscall()
> +				? MSG_CMSG_COMPAT : 0;
> +			zc.msg_flags = 0;
> +			if (zc.msg_control == msg_control_addr &&
> +			    zc.msg_controllen == cmsg_dummy.msg_controllen) {
> +				tcp_recv_timestamp(&cmsg_dummy, sk, &tss);
> +				zc.msg_control = (__u64)
> +					((uintptr_t)cmsg_dummy.msg_control);
> +				zc.msg_controllen =
> +					(__u64)cmsg_dummy.msg_controllen;
> +				zc.msg_flags = (__u32)cmsg_dummy.msg_flags;

This is indented by 4 levels. Time to create a helper?

Do we really need to cast each of these assignments explicitly?
