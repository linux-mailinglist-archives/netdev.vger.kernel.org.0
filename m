Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2BD2A6DB7
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 20:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgKDTRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 14:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgKDTRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 14:17:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBDCA206ED;
        Wed,  4 Nov 2020 19:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604517463;
        bh=U8ozNp5ifQlNXX/adooj82tLzOu1cZZm3u/AWu7tK7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jRKrJ3CsHrC5T01auRWtdHl2thKKgEHFtp0udRp1L2h+HnAjdGFnpcYKiHqqUt6r+
         H9H2JbFHlBM25tFku7AeI8Ny9GOPhSWJ2jTLZAtUDlmRb2xirbEfafx31jTKLcEWvA
         Hz0ZXe8S70zDBkGNWCupOs0qhcRyDNq5OS3Eycfk=
Date:   Wed, 4 Nov 2020 11:17:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201104111708.0595e2a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5de7eb11-010b-e66e-c72d-07ece638c25e@iogearbox.net>
References: <20201028132529.3763875-1-haliu@redhat.com>
        <20201029151146.3810859-1-haliu@redhat.com>
        <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
        <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
        <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
        <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
        <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
        <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
        <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
        <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
        <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
        <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
        <87zh3xv04o.fsf@toke.dk>
        <5de7eb11-010b-e66e-c72d-07ece638c25e@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 14:12:47 +0100 Daniel Borkmann wrote:
> If we would have done lib/bpf.c as a dynamic library back then, we wouldn't be
> where we are today since users might be able to start consuming BPF functionality
> just now, don't you agree? This was an explicit design choice back then for exactly
> this reason. If we extend lib/bpf.c or import libbpf one way or another then there
> is consistency across distros and users would be able to consume it in a predictable
> way starting from next major releases. And you could start making this assumption
> on all major distros in say, 3 months from now. The discussion is somehow focused
> on the PoV of /a/ distro which is all nice and good, but the ones consuming the
> loader shipping software /across/ distros are users writing BPF progs, all I'm
> trying to say is that the _user experience_ should be the focus of this discussion
> and right now we're trying hard making it rather painful for them to consume it.

IIUC you're saying that we cannot depend on libbpf updates from distro.
Isn't that a pretty bad experience for all users who would like to link
against it? There are 4 components (kernel, lib, tools, compiler) all
need to be kept up to date for optimal user experience. Cutting corners
with one of them leads nowhere medium term IMHO.

Unless what you guys are saying is that libbpf is _not_ supposed to be
backward compatible from the user side, and must be used a submodule.
But then why bother defining ABI versions, or build it as an .so at all.

I'm also confused by the testing argument. Surely the solution is to
add unit / system tests for iproute2. Distros will rebuild packages
when dependencies change and retest. If we have 0 tests doesn't matter
what update strategy there is.
