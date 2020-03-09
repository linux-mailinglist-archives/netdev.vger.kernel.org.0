Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3627D17E77F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgCISur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbgCISur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 14:50:47 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDECA20873;
        Mon,  9 Mar 2020 18:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583779846;
        bh=wAZU1ogFBL/nao63AXf87o/X9lKDL3fz6mbf0LwohuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DTa2MzW8sf607hZl1LTIFgjMChYI78Zetw1jd/uPfilcFTYwgVwmiLUfIONNldl6R
         ZQgKU6uj9q/7Ur+E8AFaobrvXgSV+M/0cqvOGYLQnp9A+Wq1E43rpc8p66vxcKCRRK
         iA15oWMyX7jkj5aA3C24uxMHCYiXHLFkMt8/DW3s=
Date:   Mon, 9 Mar 2020 11:50:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200309115043.17b2d6ef@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87d09l21t1.fsf@toke.dk>
References: <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
        <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
        <87pndt4268.fsf@toke.dk>
        <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
        <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
        <87k1413whq.fsf@toke.dk>
        <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
        <20200304114000.56888dac@kicinski-fedora-PC1C0HJN>
        <20200304204506.wli3enu5w25b35h7@ast-mbp>
        <20200304132439.6abadbe3@kicinski-fedora-PC1C0HJN>
        <20200305010706.dk7zedpyj5pb5jcv@ast-mbp>
        <20200305001620.204c292e@cakuba.hsd1.ca.comcast.net>
        <87tv332hak.fsf@toke.dk>
        <20200305101342.01427a2a@kicinski-fedora-PC1C0HJN>
        <87d09l21t1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Mar 2020 12:41:14 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > You said that like the library doesn't arbitrate access and manage
> > resources.. It does exactly the same work the daemon would do. =20
>=20
> Sure, the logic is in the library, but the state (which programs are
> loaded) and synchronisation primitives (atomic replace of attached
> program) are provided by the kernel.=20

I see your point of view. The state in the kernel which the library has
to read out every time is what I was thinking of as deserialization.

The library has to take some lock, and then read the state from the
kernel, and then construct its internal state based on that. I think
you have some cleverness there to stuff everything in BTF so far, but
I'd expect if the library grows that may become cumbersome and
wasteful (it's pinned memory after all).=20

Parsing the packet once could be an example of something that could be
managed by the library to avoid wasted cycles. Then programs would have
to describe their requirements, and library may need to do rewrites of
the bytecode.=20

I guess everything can be stuffed into BTF, but I'm not 100% sure
kernel is supposed to be a database either.

Note that the atomic replace may not sufficient for safe operation,=20
as reading the state from the kernel is also not atomic.

> > Daemon just trades off the complexity of making calls for the
> > complexity of the system and serializing/de-serializing the state. =20
>=20
> What state are we serialising? I'm not sure I would consider just
> pinning things in bpffs as "state serialisation"?

At a quick glance at your code, e.g. what xdp_parse_run_order() does ;)
