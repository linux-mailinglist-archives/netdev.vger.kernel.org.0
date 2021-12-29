Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76EA4816E8
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 22:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhL2VJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 16:09:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53878 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhL2VJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 16:09:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FE0061567;
        Wed, 29 Dec 2021 21:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7DDC36AE9;
        Wed, 29 Dec 2021 21:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640812169;
        bh=AIGpPhwH3JZgx1thcZbcwXSN5e+TOgmtxsYzXXEN3I0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jSSHj+9JSVkK5ybHU1Mv3/RFUW9UIj8I/lAdzRC7TG7ibyZC9TX4xy1NXnMzhbZgr
         QWuTzQWfIKy6ek8p66JC9S313Jve9TUD6i05FlC3HhQks6JZ7ljnxh/zZWePd4u77b
         YIuMyUQ8+6QVrt4oXXlhkixdsMOsO2fsoPIBMLx+A4E624r8FZtgljdl12mU+I7sN9
         n+LllRNBDr0+HLrErTGAkJc5ga6Rqk+U5jthQNydH+/Jx3ZGs1SF/O0pH0NDUr05H+
         nVp8wfGj6M1HqYzu9zG0D8u0hXhGYcBHm+F23wlJ/0sHfP/cJ+FrU+3FYnDG7Os5lc
         D90jTGeoa9wvw==
Date:   Wed, 29 Dec 2021 13:09:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH] net: bpf: handle return value of
 BPF_CGROUP_RUN_PROG_INET4_POST_BIND()
Message-ID: <20211229130927.2370f098@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211227062035.3224982-1-imagedong@tencent.com>
References: <20211227062035.3224982-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Dec 2021 14:20:35 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> The return value of BPF_CGROUP_RUN_PROG_INET4_POST_BIND() in
> __inet_bind() is not handled properly. While the return value
> is non-zero, it will set inet_saddr and inet_rcv_saddr to 0 and
> exit:
> 
> 	err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
> 	if (err) {
> 		inet->inet_saddr = inet->inet_rcv_saddr = 0;
> 		goto out_release_sock;
> 	}
> 
> Let's take UDP for example and see what will happen. For UDP
> socket, it will be added to 'udp_prot.h.udp_table->hash' and
> 'udp_prot.h.udp_table->hash2' after the sk->sk_prot->get_port()
> called success. If 'inet->inet_rcv_saddr' is specified here,
> then 'sk' will be in the 'hslot2' of 'hash2' that it don't belong
> to (because inet_saddr is changed to 0), and UDP packet received
> will not be passed to this sock. If 'inet->inet_rcv_saddr' is not
> specified here, the sock will work fine, as it can receive packet
> properly, which is wired, as the 'bind()' is already failed.
> 
> I'm not sure what should do here, maybe we should unhash the sock
> for UDP? Therefor, user can try to bind another port?

Enumarating the L4 unwind paths in L3 code seems like a fairly clear
layering violation. A new callback to undo ->sk_prot->get_port() may
be better.

Does IPv6 no need as similar change?

You need to provide a selftest to validate the expected behavior.

> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 04067b249bf3..9e5710f40a39 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -530,7 +530,14 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>  		if (!(flags & BIND_FROM_BPF)) {
>  			err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
>  			if (err) {
> +				if (sk->sk_prot == &udp_prot)
> +					sk->sk_prot->unhash(sk);
> +				else if (sk->sk_prot == &tcp_prot)
> +					inet_put_port(sk);
> +
>  				inet->inet_saddr = inet->inet_rcv_saddr = 0;
> +				err = -EPERM;
> +
>  				goto out_release_sock;
>  			}
>  		}

