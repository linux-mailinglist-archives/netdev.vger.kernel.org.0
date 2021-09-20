Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103B8412610
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353988AbhITSxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385893AbhITSwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 14:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D955611AE;
        Mon, 20 Sep 2021 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632160937;
        bh=as2gxVfvnJaxy4koQagKxvEP7kyTEN8JfpEklpWnlp0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q0n9A9GEUlQmIbkRUHCSHnVJseX4zDUujb6T+1aOhk/8Vo33P7W1mnucZEQ+50qh0
         jYxG+4nqRxyVT3rJXI10DHLC24Qzl9fZwh5KxETz5mRMkxS9dXqtJaHYi4Y0PQtS71
         AMLIcj5y7I/nTZ4YnuqAq3JzBUn/+N16P8vTKVzkPPPEB4rOoSje8ZfhxDCXNBjy9d
         ZkMVDtNRwywAQhndFj57TErGvkVYuQzg4GSYkEm5kSc/mwPz/xK0y/iNcZD9ko6cNI
         BZXtgpm+mcbG/VFvlUFeVmosB4BD+AJl1WE+VusgFJaHKLPjXXPUMD2ezLMMVQ0eb1
         q79Wm7dDsZbdQ==
Date:   Mon, 20 Sep 2021 11:02:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210920110216.4c54c9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8735q25ccg.fsf@toke.dk>
References: <cover.1631289870.git.lorenzo@kernel.org>
        <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YUSrWiWh57Ys7UdB@lore-desk>
        <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
        <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
        <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch>
        <8735q25ccg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Sep 2021 13:53:35 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> I'm OK with a bpf_header_pointer()-type helper - I quite like the
> in-kernel version of this for SKBs, so replicating it as a BPF helper
> would be great. But I'm a little worried about taking a performance hit.
>=20
> I.e., if you do:
>=20
> ptr =3D bpf_header_pointer(pkt, offset, len, stack_ptr)
> *ptr =3D xxx;
>=20
> then, if the helper ended up copying the data into the stack pointer,
> you didn't actually change anything in the packet, so you need to do a
> writeback.
>=20
> Jakub suggested up-thread that this should be done with some kind of
> flush() helper. But you don't know whether the header_pointer()-helper
> copied the data, so you always need to call the flush() helper, which
> will incur overhead. If the verifier can in-line the helpers that will
> lower it, but will it be enough to make it negligible?

Depends on the assumptions the program otherwise makes, right?

For reading I'd expect a *layout-independent* TC program would=20
replace approximately:

ptr =3D <some_ptr>;
if (ptr + CONST >=3D md->ptr_end)
	if (bpf_pull_data(md, off + CONST))
		return DROP;
	ptr =3D <some_ptr>;
	if (ptr + CONST >=3D md->ptr_end)
		return DROP; /* da hell? */
}

With this (pre-inlining):

ptr =3D bpf_header_pointer(md, offset, len, stack);
if (!ptr)
	return DROP;

Post-inlining (assuming static validation of args to prevent wraps):

if (md->ptr + args->off + args->len < md->ptr_end)
	ptr =3D md->ptr + args->off;
else
	ptr =3D __bpf_header_pointer(md, offset, len, stack);
if (!ptr)
	return DROP;

But that's based on guesswork so perhaps I'm off base.


Regarding the flush() I was expecting that most progs will not modify
the packet (or at least won't modify most headers they load) so no
point paying the price of tracking changes auto-magically.

In fact I don't think there is anything infra can do better for
flushing than the prog itself:

	bool mod =3D false;

	ptr =3D bpf_header_pointer(...);
	...
	if (some_cond(...)) {
		change_packet(...);
		mod =3D true;
	}
	...
	if (mod)
		bpf_header_pointer_flush();


is simple enough.. to me.
