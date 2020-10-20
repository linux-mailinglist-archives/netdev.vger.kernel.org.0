Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D26294294
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437912AbgJTS4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437907AbgJTS4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 14:56:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39F6D2222D;
        Tue, 20 Oct 2020 18:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603220190;
        bh=iVPbmOvmvmGGkuCL9894oNShGSC57fk0esGpz4BlWJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RqzlncGvHqJJ171EfBdP8hVNOs1sVgjXYW+dtx3gQeoTV0VykaICUFVKjyHg1unUP
         Mx3xB00vrA0G/HH7G8gZJ3UdcHApaycmQbKw3X9aCckEP3O0hMZNDOCjeESUMhTjq6
         jvqXaiMk5K0lpTcLnX+fjNFc6AVtUX4++JjQNDhw=
Date:   Tue, 20 Oct 2020 11:56:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
Message-ID: <20201020115627.3cf54c45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5bee9b34-e7ab-28ef-13a7-ef64a7f3b67e@gmail.com>
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
        <160319106221.15822.2629789706666194966.stgit@toke.dk>
        <20201020093003.6e1c7fdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5bee9b34-e7ab-28ef-13a7-ef64a7f3b67e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 12:12:32 -0600 David Ahern wrote:
> On 10/20/20 10:30 AM, Jakub Kicinski wrote:
> > On Tue, 20 Oct 2020 12:51:02 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te: =20
> >> diff --git a/include/linux/filter.h b/include/linux/filter.h
> >> index 20fc24c9779a..ba9de7188cd0 100644
> >> --- a/include/linux/filter.h
> >> +++ b/include/linux/filter.h
> >> @@ -607,12 +607,21 @@ struct bpf_skb_data_end {
> >>  	void *data_end;
> >>  };
> >> =20
> >> +struct bpf_nh_params {
> >> +	u8 nh_family;
> >> +	union {
> >> +		__u32 ipv4_nh;
> >> +		struct in6_addr ipv6_nh;
> >> +	};
> >> +}; =20
> >  =20
> >> @@ -4906,6 +4910,18 @@ struct bpf_fib_lookup {
> >>  	__u8	dmac[6];     /* ETH_ALEN */
> >>  };
> >> =20
> >> +struct bpf_redir_neigh {
> >> +	/* network family for lookup (AF_INET, AF_INET6) */
> >> +	__u8 nh_family;
> >> +	 /* avoid hole in struct - must be set to 0 */
> >> +	__u8 unused[3];
> >> +	/* network address of nexthop; skips fib lookup to find gateway */
> >> +	union {
> >> +		__be32		ipv4_nh;
> >> +		__u32		ipv6_nh[4];  /* in6_addr; network order */
> >> +	};
> >> +}; =20
> >=20
> > Isn't this backward? The hole could be named in the internal structure.
> > This is a bit of a gray area, but if you name this hole in uAPI and
> > programs start referring to it you will never be able to reuse it.
> > So you may as well not require it to be zeroed..
>=20
> for uapi naming the holes, stating they are unused and requiring a 0
> value allows them to be used later if an api change needs to.

I'm not sure what you're saying, if the field is referenced it can't be
removed. But we could use a union, so I guess it's not a deal breaker.
