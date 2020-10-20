Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9631C294087
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394686AbgJTQaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394647AbgJTQaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 12:30:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CAAF22250;
        Tue, 20 Oct 2020 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603211405;
        bh=u1Mu2Aqlff3ZslWlQIwsq52KeBi0gaw5NKY34rdxnxY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=llTD4CRol6fK8UZ/IJd3r39qEix1bW/waSRgnUmr3ixmNTYIKLn0MotGodoNxirgS
         npRttKYuVTZA3xWPDgDr7XhsScAOByjtT2yh9iG4d0lfla9h01Z6xsaa83qivk39Sd
         zJ1Nvq0yqJt6mLM5HkbohaarbecdhIDQkPaeZiT8=
Date:   Tue, 20 Oct 2020 09:30:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
Message-ID: <20201020093003.6e1c7fdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160319106221.15822.2629789706666194966.stgit@toke.dk>
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
        <160319106221.15822.2629789706666194966.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 12:51:02 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 20fc24c9779a..ba9de7188cd0 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -607,12 +607,21 @@ struct bpf_skb_data_end {
>  	void *data_end;
>  };
> =20
> +struct bpf_nh_params {
> +	u8 nh_family;
> +	union {
> +		__u32 ipv4_nh;
> +		struct in6_addr ipv6_nh;
> +	};
> +};

> @@ -4906,6 +4910,18 @@ struct bpf_fib_lookup {
>  	__u8	dmac[6];     /* ETH_ALEN */
>  };
> =20
> +struct bpf_redir_neigh {
> +	/* network family for lookup (AF_INET, AF_INET6) */
> +	__u8 nh_family;
> +	 /* avoid hole in struct - must be set to 0 */
> +	__u8 unused[3];
> +	/* network address of nexthop; skips fib lookup to find gateway */
> +	union {
> +		__be32		ipv4_nh;
> +		__u32		ipv6_nh[4];  /* in6_addr; network order */
> +	};
> +};

Isn't this backward? The hole could be named in the internal structure.
This is a bit of a gray area, but if you name this hole in uAPI and
programs start referring to it you will never be able to reuse it.
So you may as well not require it to be zeroed..
