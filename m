Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5183C6244
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhGLR4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232912AbhGLR4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 13:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D74C4611C1;
        Mon, 12 Jul 2021 17:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626112391;
        bh=jGnGoxaC8d6Hqlp8ntm0TMB+F435psYQrUnJQ6yH8Fg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tKcGOXhjv5y8WBuGgOpO2/9LW+uwSf8AcaONcpUWvgtJirzHf/3B6HxLT0uSpEGRo
         IiY+yQR2ZGmqXPY8zzsGikUt626qB8vM2CfUMzYJts/Ra9jdZGixSjQFx3AfZLWFba
         H81jRYxAkutbDiOHNMriOCpQDHj66mROHl0yfWFcWPP/xTNfXotv380OvJePaARwpL
         aJusHZSo632ilnBvYjd266deXjDXMb9DKeupXhtFgbCX1EIHCwKduqCzRcf2cLFs/Z
         6yzN0/B1HO+Ji6nalpNzmI/aeDJz7dBanuHiRI/3N851UxYH0sMezsSOVybnSlsi8Z
         YiI8KDsySZwpA==
Date:   Mon, 12 Jul 2021 10:53:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NET 1/7] skbuff: introduce pskb_realloc_headroom()
Message-ID: <20210712105310.46d265a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8049e16b-3d7a-64c3-c948-ec504590a136@virtuozzo.com>
References: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
        <cover.1626093470.git.vvs@virtuozzo.com>
        <8049e16b-3d7a-64c3-c948-ec504590a136@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Jul 2021 16:26:44 +0300 Vasily Averin wrote:
>  /**
> + *	pskb_realloc_headroom - reallocate header of &sk_buff
> + *	@skb: buffer to reallocate
> + *	@headroom: needed headroom
> + *
> + *	Unlike skb_realloc_headroom, this one does not allocate a new skb
> + *	if possible; copies skb->sk to new skb as needed
> + *	and frees original scb in case of failures.
> + *
> + *	It expect increased headroom, and generates warning otherwise.
> + */
> +
> +struct sk_buff *pskb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)

I saw you asked about naming in a different sub-thread, what do you
mean by "'pskb_expand_head' have different semantic"? AFAIU the 'p'
in pskb stands for "private", meaning not shared. In fact
skb_realloc_headroom() should really be pskb... but it predates the 
'pskb' naming pattern by quite a while. Long story short
skb_expand_head() seems like a good name. With the current patch
pskb_realloc_headroom() vs skb_realloc_headroom() would give people
exactly the opposite intuition of what the code does.
