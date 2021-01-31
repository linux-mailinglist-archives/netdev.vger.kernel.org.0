Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173B4309E77
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 21:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhAaUBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 15:01:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231651AbhAaTys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Jan 2021 14:54:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B55F64E1F;
        Sun, 31 Jan 2021 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612113826;
        bh=vFfdkI0WiJDOdMAjzbLTF6aHXnWhspQMuMXZ45KA2cs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eSFoE8yEDDveFuoypeKL7ijhxkmdzGFIhLkPxPec9IoXE+H2i6A+yFHhpamS+fqoR
         eJZq2a5q1o2WwhYJlox5ul3LI8OpFEHf7uUL2CO7i7DnU0tr2hvOZ5YjXkxYQZy5lU
         ZmO2PIKngs1z8ffSj7v+jirtb+H+yO0C0AYVBDAWFcoo3VlqR20gYz2kz///m8G6Dw
         NUznad9C41gt7hWmc9WCPpTd0PmBTc2TyG3N6FBWekAi+8S8Lv5/BHmR84uzekolh+
         vEbGXftpXCAWUBWBW/XgiDr56f7LxiWkmD1Baez4Yj3aBvtphnD5+gzy9G4IkNcsXf
         RIUcuvz3NfZJA==
Date:   Sun, 31 Jan 2021 18:23:41 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: Re: [PATCH v6 bpf-next 0/8] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210131172341.GA6003@lore-desk>
References: <cover.1611086134.git.lorenzo@kernel.org>
 <572556bb-845f-1b4a-8f0a-fb6a4fc286e3@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <572556bb-845f-1b4a-8f0a-fb6a4fc286e3@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,

Hi Daniel,

sorry for the delay.

>=20
> On 1/19/21 9:20 PM, Lorenzo Bianconi wrote:
> > This series introduce XDP multi-buffer support. The mvneta driver is
> > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > please focus on how these new types of xdp_{buff,frame} packets
> > traverse the different layers and the layout design. It is on purpose
> > that BPF-helpers are kept simple, as we don't want to expose the
> > internal layout to allow later changes.
> >=20
> > For now, to keep the design simple and to maintain performance, the XDP
> > BPF-prog (still) only have access to the first-buffer. It is left for
> > later (another patchset) to add payload access across multiple buffers.
>=20
> I think xmas break has mostly wiped my memory from 2020 ;) so it would be
> good to describe the sketched out design for how this will look like insi=
de
> the cover letter in terms of planned uapi exposure. (Additionally discuss=
ing
> api design proposal could also be sth for BPF office hour to move things
> quicker + posting a summary to the list for transparency of course .. just
> a thought.)

I guess the main goal of this series is to add the multi-buffer support to =
the
xdp core (e.g. in xdp_frame/xdp_buff or in xdp_return_{buff/frame}) and to =
provide
the first driver with xdp mult-ibuff support. We tried to make the changes
independent from eBPF helpers since we do not have defined use cases for th=
em
yet and we don't want to expose the internal layout to allow later changes.
One possible example is bpf_xdp_adjust_mb_header() helper we sent in v2 pat=
ch 6/9
[0] to try to address use-case explained by Eric @ NetDev 0x14 [1].
Anyway I agree there are some missing bits we need to address (e.g. what is=
 the
behaviour when we redirect a mb xdp_frame to a driver not supporting it?)

Ack, I agree we can discuss about mb eBPF helper APIs in BPF office hour mt=
g in
order to speed-up the process.

>=20
> Glancing over the series, while you've addressed the bpf_xdp_adjust_tail()
> helper API, this series will be breaking one assumption of programs at le=
ast
> for the mvneta driver from one kernel to another if you then use the multi
> buff mode, and that is basically bpf_xdp_event_output() API: the assumpti=
on
> is that you can do full packet capture by passing in the xdp buff len that
> is data_end - data ptr. We use it this way for sampling & others might as=
 well
> (e.g. xdpcap). But bpf_xdp_copy() would only copy the first buffer today =
which
> would break the full pkt visibility assumption. Just walking the frags if
> xdp->mb bit is set would still need some sort of struct xdp_md exposure so
> the prog can figure out the actual full size..

ack, thx for pointing this out, I will take a look to it.
Eelco added xdp_len to xdp_md in the previous series (he is still working on
it). Another possible approach would be defining a helper, what do you thin=
k?

>=20
> > This patchset should still allow for these future extensions. The goal
> > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > same performance as before.
> >=20
> > The main idea for the new multi-buffer layout is to reuse the same
> > layout used for non-linear SKB. We introduced a "xdp_shared_info" data
> > structure at the end of the first buffer to link together subsequent bu=
ffers.
> > xdp_shared_info will alias skb_shared_info allowing to keep most of the=
 frags
> > in the same cache-line (while with skb_shared_info only the first fragm=
ent will
> > be placed in the first "shared_info" cache-line). Moreover we introduce=
d some
> > xdp_shared_info helpers aligned to skb_frag* ones.
> > Converting xdp_frame to SKB and deliver it to the network stack is show=
n in
> > cpumap code (patch 7/8). Building the SKB, the xdp_shared_info structure
> > will be converted in a skb_shared_info one.
> >=20
> > A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} structu=
re
> > to notify the bpf/network layer if this is a xdp multi-buffer frame (mb=
 =3D 1)
> > or not (mb =3D 0).
> > The mb bit will be set by a xdp multi-buffer capable driver only for
> > non-linear frames maintaining the capability to receive linear frames
> > without any extra cost since the xdp_shared_info structure at the end
> > of the first buffer will be initialized only if mb is set.
> >=20
> > Typical use cases for this series are:
> > - Jumbo-frames
> > - Packet header split (please see Google=E2=80=99s use-case @ NetDevCon=
f 0x14, [0])
> > - TSO
> >=20
> > bpf_xdp_adjust_tail helper has been modified to take info account xdp
> > multi-buff frames.
>=20
> Also in terms of logistics (I think mentioned earlier already), for the s=
eries to
> be merged - as with other networking features spanning core + driver (exa=
mple
> af_xdp) - we also need a second driver (ideally mlx5, i40e or ice) implem=
enting
> this and ideally be submitted together in the same series for review. For=
 that
> it probably also makes sense to more cleanly split out the core pieces fr=
om the
> driver ones. Either way, how is progress on that side coming along?

I do not have any updated news about it so far, but afaik amazon folks were=
 working
on adding mb support to ena driver, while intel was planning to add it to a=
f_xdp.
Moreover Jason was looking to add it to virtio-net.

>=20
> Thanks,
> Daniel

Regards,
Lorenzo

[0] https://patchwork.ozlabs.org/project/netdev/patch/b7475687bb09aac6ec051=
596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org/
[1] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu-a=
nd-rx-zerocopy

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYBbnmgAKCRA6cBh0uS2t
rLeKAQCqcPzVsT+U39JtKEdoTeKIboeFePzf/Y9MyMqonRdZsgD/ZKYv6NcM/sht
Hxis4torgfvwZAlB78d6UrI9W0o4YQs=
=55Nb
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
