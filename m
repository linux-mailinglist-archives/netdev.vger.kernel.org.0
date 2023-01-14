Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B3F66AC1E
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 16:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjANPdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 10:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjANPdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 10:33:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3801265B7
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 07:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673710398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rocdlOE7cHWC1zE1mEMZfdO9OdSReGB8PfyH9d+AaeU=;
        b=WEHyMsI/Ot0/h32F/IgPOhM3e5eO08uQfsNOu4JXGddM4kFD3niDO4pBAkRFuIHR0zBsUp
        HfxCCH7kFDi7JkBSid7h8SL+OO0ISF57IBR2vz2GGFlz1Q+BLBB/12A8qIH8p0HfGXv0DE
        /uaVD8SHgVOhVlbbE7e0T1mc51ZQerU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-194-uF1PGPRiNvW8ZDewX8YzzA-1; Sat, 14 Jan 2023 10:33:16 -0500
X-MC-Unique: uF1PGPRiNvW8ZDewX8YzzA-1
Received: by mail-wm1-f69.google.com with SMTP id o33-20020a05600c512100b003da1f94e8f7so2918366wms.8
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 07:33:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rocdlOE7cHWC1zE1mEMZfdO9OdSReGB8PfyH9d+AaeU=;
        b=KYJLXW/R9/0BTkD64Cp/VYrCas0HXAMRRat30eZaPSN7TIE9rid5TtlvV7SDhEXHfN
         iuGR4Iz1WPa9K0GVUQHTRDUosq9uI7vqt1O+s3PnJGDGy0Dwtuz5eU5SJFFeZltGlHrL
         wX+yiVN1DgENZCX6L0EMG6JE9qL7GWFKD8hbg9f6rc3IWk2qUj0Q+eDzL2o9IvSA+1wp
         O8Jy8nVDyxazPcQxFJVV6/NrDuFMf8Znp2jP8IcUI3lqwIeythF0iRgNvMi1zed8jG4k
         YxLZOoI0bqVyQ0hB3as5rlroElgHmqdN3PPVeYWZ7NSc04iWJ2hs2MimuvdkrnBPZPoO
         TVow==
X-Gm-Message-State: AFqh2kru3+PB67ttR7/NUtipiCXVBTJpp8nQaMuDrwq8S24y5xmFURQw
        ecGp2tfGk+vBb0OpaW+6QK0RnBgYet84JDxTieePKS/MpSwkNIS6f/DY+cWUN02r6PiybAt5131
        tnbpKJLPvIvDgmIWX
X-Received: by 2002:a05:600c:331d:b0:3d6:ecc4:6279 with SMTP id q29-20020a05600c331d00b003d6ecc46279mr2876538wmp.27.1673710395573;
        Sat, 14 Jan 2023 07:33:15 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvW1I48o8cgiyW4Lk1zD/zOvGZMEH2HKEq45sGbIyCQoT2K7GCZqzn0n1PQCFPsX8CzChG+pA==
X-Received: by 2002:a05:600c:331d:b0:3d6:ecc4:6279 with SMTP id q29-20020a05600c331d00b003d6ecc46279mr2876501wmp.27.1673710395255;
        Sat, 14 Jan 2023 07:33:15 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id i8-20020a1c5408000000b003da065105c9sm12488884wmb.40.2023.01.14.07.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 07:33:14 -0800 (PST)
Date:   Sat, 14 Jan 2023 16:33:11 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        grygorii.strashko@ti.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC bpf-next 6/8] libbpf: add API to get XDP/XSK supported
 features
Message-ID: <Y8LLN5qiTDlLNQcK@lore-desk>
References: <cover.1671462950.git.lorenzo@kernel.org>
 <6cce9b15a57345402bb94366434a5ac5609583b8.1671462951.git.lorenzo@kernel.org>
 <CAEf4BzbOF-S3kjbNVXCZR-K=TGarfi06ZwG1cbNF=HSSodwEfg@mail.gmail.com>
 <Y72f1U2/dw8jo0/0@lore-desk>
 <CAEf4BzawqXs6q18U8e5GD5d+9v1_w2+QOJYqmEpNb9rZ40E1Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="n89kErnvPkHUjfpP"
Content-Disposition: inline
In-Reply-To: <CAEf4BzawqXs6q18U8e5GD5d+9v1_w2+QOJYqmEpNb9rZ40E1Tw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n89kErnvPkHUjfpP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Jan 10, 2023 at 9:26 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > > On Mon, Dec 19, 2022 at 7:42 AM Lorenzo Bianconi <lorenzo@kernel.org>=
 wrote:
> > > >
> > > > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > >
> > > > Add functions to get XDP/XSK supported function of netdev over route
> > > > netlink interface. These functions provide functionalities that are
> > > > going to be used in upcoming change.
> > > >
> > > > The newly added bpf_xdp_query_features takes a fflags_cnt parameter,
> > > > which denotes the number of elements in the output fflags array. Th=
is
> > > > must be at least 1 and maybe greater than XDP_FEATURES_WORDS. The
> > > > function only writes to words which is min of fflags_cnt and
> > > > XDP_FEATURES_WORDS.
> > > >
> > > > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > Co-developed-by: Marek Majtyka <alardam@gmail.com>
> > > > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > ---
> > > >  tools/lib/bpf/libbpf.h   |  1 +
> > > >  tools/lib/bpf/libbpf.map |  1 +
> > > >  tools/lib/bpf/netlink.c  | 62 ++++++++++++++++++++++++++++++++++++=
++++
> > > >  3 files changed, 64 insertions(+)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > > index eee883f007f9..9d102eb5007e 100644
> > > > --- a/tools/lib/bpf/libbpf.h
> > > > +++ b/tools/lib/bpf/libbpf.h
> > > > @@ -967,6 +967,7 @@ LIBBPF_API int bpf_xdp_detach(int ifindex, __u3=
2 flags,
> > > >                               const struct bpf_xdp_attach_opts *opt=
s);
> > > >  LIBBPF_API int bpf_xdp_query(int ifindex, int flags, struct bpf_xd=
p_query_opts *opts);
> > > >  LIBBPF_API int bpf_xdp_query_id(int ifindex, int flags, __u32 *pro=
g_id);
> > > > +LIBBPF_API int bpf_xdp_query_features(int ifindex, __u32 *fflags, =
__u32 *fflags_cnt);
> > >
> > > no need to add new API, just extend bpf_xdp_query()?
> >
> > Hi Andrii,
> >
> > AFAIK libbpf supports just NETLINK_ROUTE protocol. In order to connect =
with the
> > genl family code shared by Jakub we need to add NETLINK_GENERIC protoco=
l support
> > to libbf. Is it ok to introduce a libmnl or libnl dependency in libbpf =
or do you
> > prefer to add open code to just what we need?
>=20
> I'd very much like to avoid any extra dependencies. But I also have no
> clue how much new code we are talking about, tbh. Either way, the less
> dependencies, the better, if the result is an acceptable amount of
> extra code to maintain.

ack, I avoided to introduce an extra dependencies since most of the protocol
is already implemented in libbpf and I added just few code.

>=20
> > I guess we should have a dedicated API to dump xdp features in this cas=
e since
> > all the other code relies on NETLINK_ROUTE protocol. What do you think?
> >
>=20
> From API standpoint it looks like an extension to bpf_xdp_query()
> family of APIs, which is already extendable through opts. Which is why
> I suggested that there is no need for new API. NETLINK_ROUTE vs
> NETLINK_GENERIC seems like an internal implementation detail (but
> again, I spent literally zero time trying to understand what's going
> on here).

ack, I extended bpf_xdp_query routine instead of adding a new API.

Regards,
Lorenzo

>=20
> > Regards,
> > Lorenzo
> >
> > >
> > > >
> > > >  /* TC related API */
> > > >  enum bpf_tc_attach_point {
> > > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > > index 71bf5691a689..9c2abb58fa4b 100644
> > > > --- a/tools/lib/bpf/libbpf.map
> > > > +++ b/tools/lib/bpf/libbpf.map
> > > > @@ -362,6 +362,7 @@ LIBBPF_1.0.0 {
> > > >                 bpf_program__set_autoattach;
> > > >                 btf__add_enum64;
> > > >                 btf__add_enum64_value;
> > > > +               bpf_xdp_query_features;
> > > >                 libbpf_bpf_attach_type_str;
> > > >                 libbpf_bpf_link_type_str;
> > > >                 libbpf_bpf_map_type_str;
> > >
> > > [...]
>=20

--n89kErnvPkHUjfpP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8LLNwAKCRA6cBh0uS2t
rHQpAP9S1nRxJxn6VI8kE+ZgcmpcM4bn41k/iKTInZDlJMnuRgD/UDwB7wgWf7IR
N84yItCjaXrkRBsk+05kHyYqvmSVTwI=
=5cEs
-----END PGP SIGNATURE-----

--n89kErnvPkHUjfpP--

