Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C062A64E2
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgKDNNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:13:07 -0500
Received: from www62.your-server.de ([213.133.104.62]:48702 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgKDNNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:13:06 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kaIam-0004qo-Vb; Wed, 04 Nov 2020 14:12:49 +0100
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kaIam-000CYP-LV; Wed, 04 Nov 2020 14:12:48 +0100
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
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
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net> <87zh3xv04o.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5de7eb11-010b-e66e-c72d-07ece638c25e@iogearbox.net>
Date:   Wed, 4 Nov 2020 14:12:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87zh3xv04o.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25977/Tue Nov  3 14:18:27 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 12:20 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
>> Back in the days when developing lib/bpf.c, it was explicitly done as
>> built-in for iproute2 so that it doesn't take years for users to
>> actually get to the point where they can realistically make use of it.
>> If we were to extend the internal lib/bpf.c to similar feature state
>> as libbpf today, how is that different in the bigger picture compared
>> to sync or submodule... so far noone complained about lib/bpf.c.
> 
> Except that this whole effort started because lib/bpf.c is slowly
> bitrotting into oblivion? If all the tools are dynamically linked
> against libbpf, that's only one package the distros have to keep
> up-to-date instead of a whole list of tools. How does that make things
> *worse*?

It sounds good in theory if that would all work out as expected, but reality
differs unfortunately. Today on vast majority of distros you are able to use
iproute2's BPF loader via lib/bpf.c given it's a fixed built-in, even if
it's bitrotting for a while now in terms of features^BTF, but the base functionality
that is in there can be used, and it is used in the wild today. If libbpf is
dynamically linked to iproute2, then I - as a user - am left with continuing
to assume that the current lib/bpf.c is the /only/ base that is really /guaranteed/
to be available as a loader across distros, but iproute2 + libbpf may not be
(it may be the case for RHEL but potentially not others). So from user PoV
I might be sticking to the current lib/bpf.c that iproute2 ships instead of
converting code over until even major distros catch up in maybe 2 years from now
(that is in fact how long it took Canonical to get bpftool included, not kidding).
If we would have done lib/bpf.c as a dynamic library back then, we wouldn't be
where we are today since users might be able to start consuming BPF functionality
just now, don't you agree? This was an explicit design choice back then for exactly
this reason. If we extend lib/bpf.c or import libbpf one way or another then there
is consistency across distros and users would be able to consume it in a predictable
way starting from next major releases. And you could start making this assumption
on all major distros in say, 3 months from now. The discussion is somehow focused
on the PoV of /a/ distro which is all nice and good, but the ones consuming the
loader shipping software /across/ distros are users writing BPF progs, all I'm
trying to say is that the _user experience_ should be the focus of this discussion
and right now we're trying hard making it rather painful for them to consume it.

Cheers,
Daniel
