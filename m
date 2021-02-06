Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF60231207C
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 00:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhBFX3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 18:29:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhBFX3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 18:29:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0326664D9C;
        Sat,  6 Feb 2021 23:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612654109;
        bh=oYwr3Cr5DVuoQhbQfuwDlHptA1Yg+QM950o9ZQfmvqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J3JDSV0BjiNIqeYUCNmrhDXFlNgmngqISZ7bmi+7zeR7LHd4YDoFOCpbh4tKlBCod
         Sp7Cim6aE2jtAP6+uugFCC6MBd3DcSl9daFxmgNrP8KZEyZ+QvgW6NXG14LpwMNXN6
         HHG0a3jw3AabqT+1XlaIqpgxuwUlWKK13z3DlDkkflbcUQ6H/ndMuK21NEubLBwQaH
         O3PI0ydf6ULiYCclD6csm1ztJPjpdD2Nj88pq5//WJHYpx8hfjuWjvn/QLMsI3Eo5l
         jt/HZnKBsOI9Oy12TfJPdychlavLvnbrD2b9hL443ykXvAkJNbUhGPRj0N73Wjv2D+
         y8hJ3pty4BCmw==
Date:   Sat, 6 Feb 2021 15:28:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  6 Feb 2021 12:36:48 -0800 Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> Explicitly define reserved field and require it to be 0-valued.

> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e1a17c6b473c..c8469c579ed8 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
>  		}
>  		if (copy_from_user(&zc, optval, len))
>  			return -EFAULT;
> +		if (zc.reserved)
> +			return -EINVAL;
>  		lock_sock(sk);
>  		err = tcp_zerocopy_receive(sk, &zc, &tss);
>  		release_sock(sk);

I was expecting we'd also throw in a check_zeroed_user().
Either we can check if the buffer is zeroed all the way,
or we can't and we shouldn't validate reserved either

	check_zeroed_user(optval + offsetof(reserved), 
			  len - offsetof(reserved))
?
