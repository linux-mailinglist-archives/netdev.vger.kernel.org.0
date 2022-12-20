Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4906C651E7F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 11:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiLTKLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 05:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiLTKLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 05:11:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E6FE84
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671531070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z0j0oIkWYx/mxGE0SPDYaFWThl0otruHGWBnwYKV8MA=;
        b=dThAF2vFu6PeZENrUHOWXaKiY1DOyYsBJEtTfZS7WKaHFeGlYZYUZIIliq4ONzNKFC5a4x
        p9qK8P2WVRBIwmVRt4Jj5DVEECaeqGwYP2XXkpgwSxshrbOcoH75yMcjSNHstfVyJYIuHk
        ooPPqYCNXsuzwBqLLMGDAarMtt2g5hs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-145-nfoTTGHQPAynORDiiO7EJA-1; Tue, 20 Dec 2022 05:11:07 -0500
X-MC-Unique: nfoTTGHQPAynORDiiO7EJA-1
Received: by mail-wr1-f72.google.com with SMTP id a7-20020adfbc47000000b002421f817287so2097521wrh.4
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:11:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z0j0oIkWYx/mxGE0SPDYaFWThl0otruHGWBnwYKV8MA=;
        b=gl/DInJG4Wqr9VcWtnRrHSs7nDwcqnYoQjLE0O+LEIv094VTzxVS+8wPQBZ2bNpkq7
         pzKXPJ/bv4BwxIr+Se3gVWYXUqYzaQ7kHSecbzO5OM8duqQqaUue4DYfF8XZlOm3blvQ
         sV6xUFUlS99A7bBh/3mz09SbNTjmwjtD3RS0LDZuWbabHkTGVswiSulPr/GqLzxcGu0X
         7JhdOVYxpAYP27D6RIKw78uHe6ruTiPaRNsgBNWZcN6WpysDmwBI+8hUT8effUl2mMuM
         +eInXl5FS17WWt+u6HgJWfycUDnVi4Jv6iSPKIEDxOB4uvRAbtgWD66WsR7eA686NlHH
         VD4Q==
X-Gm-Message-State: ANoB5pk2qRn6IRILljs9cMQCsdPwCSdfS/UhCKaI6/j3X0ODhhHlz7mM
        tXfks+QCa0nHWFCS1O+up4BOjKF83xpQpggBFzLnGOOlX0VHyqDbbW4g8D5yjUV0yIQdWdqSAoY
        YW5CbOjdc5KKkfZb9
X-Received: by 2002:a05:600c:1c91:b0:3d2:640:c4e5 with SMTP id k17-20020a05600c1c9100b003d20640c4e5mr33373011wms.8.1671531066469;
        Tue, 20 Dec 2022 02:11:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf54TfOVZ3pyt8FvAIEYd1mCigahzAv0tvsEBF6qlI9tD8k/FpiYNidpGOVC6uEiB2vwuT3aeQ==
X-Received: by 2002:a05:600c:1c91:b0:3d2:640:c4e5 with SMTP id k17-20020a05600c1c9100b003d20640c4e5mr33372979wms.8.1671531066064;
        Tue, 20 Dec 2022 02:11:06 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id g12-20020a05600c4ecc00b003cf9bf5208esm24902843wmq.19.2022.12.20.02.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 02:11:04 -0800 (PST)
Date:   Tue, 20 Dec 2022 11:11:03 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Marek Majtyka <alardam@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, saeedm@nvidia.com,
        anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        grygorii.strashko@ti.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC bpf-next 2/8] net: introduce XDP features flag
Message-ID: <Y6GKN/1iOC9eTsEE@lore-desk>
References: <cover.1671462950.git.lorenzo@kernel.org>
 <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
 <Y6DDfVhOWRybVNUt@google.com>
 <CAAOQfrFGArAYPyBX_kw4ZvFrTjKXf-jG-2F2y69nOs-oQ8Onwg@mail.gmail.com>
 <CAKH8qBuktjBcY_CuqqkWs74oBB8Mnkm638Cb=sF38H4kPAx3NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="B96UkFntLxXXDuKd"
Content-Disposition: inline
In-Reply-To: <CAKH8qBuktjBcY_CuqqkWs74oBB8Mnkm638Cb=sF38H4kPAx3NQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--B96UkFntLxXXDuKd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Dec 19, Stanislav Fomichev wrote:
> On Mon, Dec 19, 2022 at 3:51 PM Marek Majtyka <alardam@gmail.com> wrote:
> >
> > At the time of writing, I wanted to be able to read additional informat=
ion about the XDP capabilities of each network interface using ethtool. Thi=
s change was intended for Linux users/admins, and not for XDP experts who m=
ostly don't need it and prefer tasting XDP with netlink and bpf rather than=
 reading network interface features with ethtool.
>=20
> Anything preventing ethtool from doing probing similar to 'bpftool
> feature probe'?
> The problem with these feature bits is that they might diverge and/or
> not work at all for the backported patches (where the fix/feature has
> been backported, but the part that exports the bit hasn't) :-(
> OTOH, I'm not sure we can probe everything from your list, but we
> might try and see what's missing..

Hi Stanislav,

I have not added the ethtool support to this series yet since userspace par=
t is
still missing but I think we can consider XDP as a sort of sw offload so it
would be nice for the user/sysadmin (not xdp or bpf developer) to check the=
 NIC
XDP capabilities similar to what we can already do for other hw offload
features.
Moreover let's consider XDP_REDIRECT of a scatter-gather XDP frame into a
devmap. I do not think there is a way to test if the 'target' device suppor=
ts
SG and so we are forced to disable this feature until all drivers support i=
t.
Introducing XDP features we can enable it on per-driver basis.
I think the same apply for other capabilities as well and just assuming a g=
iven
feature is not supported if an e2e test is not working seems a bit inaccura=
te.

Regards,
Lorenzo

>=20
> > On Mon, Dec 19, 2022 at 9:03 PM <sdf@google.com> wrote:
> >>
> >> On 12/19, Lorenzo Bianconi wrote:
> >> > From: Marek Majtyka <alardam@gmail.com>
> >>
> >> > Implement support for checking what kind of XDP features a netdev
> >> > supports. Previously, there was no way to do this other than to try =
to
> >> > create an AF_XDP socket on the interface or load an XDP program and =
see
> >> > if it worked. This commit changes this by adding a new variable which
> >> > describes all xdp supported functions on pretty detailed level:
> >>
> >> >   - aborted
> >> >   - drop
> >> >   - pass
> >> >   - tx
> >> >   - redirect
> >> >   - sock_zerocopy
> >> >   - hw_offload
> >> >   - redirect_target
> >> >   - tx_lock
> >> >   - frag_rx
> >> >   - frag_target
> >>
> >> > Zerocopy mode requires that redirect XDP operation is implemented in=
 a
> >> > driver and the driver supports also zero copy mode. Full mode requir=
es
> >> > that all XDP operation are implemented in the driver. Basic mode is =
just
> >> > full mode without redirect operation. Frag target requires
> >> > redirect_target one is supported by the driver.
> >>
> >> Can you share more about _why_ is it needed? If we can already obtain
> >> most of these signals via probing, why export the flags?
> >>
> >> > Initially, these new flags are disabled for all drivers by default.
> >>
> >> > Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >> > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >> > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> >> > ---
> >> >   .../networking/netdev-xdp-features.rst        | 60 +++++++++++++++=
++
> >> >   include/linux/netdevice.h                     |  2 +
> >> >   include/linux/xdp_features.h                  | 64 +++++++++++++++=
++++
> >> >   include/uapi/linux/if_link.h                  |  7 ++
> >> >   include/uapi/linux/xdp_features.h             | 34 ++++++++++
> >> >   net/core/rtnetlink.c                          | 34 ++++++++++
> >> >   tools/include/uapi/linux/if_link.h            |  7 ++
> >> >   tools/include/uapi/linux/xdp_features.h       | 34 ++++++++++
> >> >   8 files changed, 242 insertions(+)
> >> >   create mode 100644 Documentation/networking/netdev-xdp-features.rst
> >> >   create mode 100644 include/linux/xdp_features.h
> >> >   create mode 100644 include/uapi/linux/xdp_features.h
> >> >   create mode 100644 tools/include/uapi/linux/xdp_features.h
> >>
> >> > diff --git a/Documentation/networking/netdev-xdp-features.rst
> >> > b/Documentation/networking/netdev-xdp-features.rst
> >> > new file mode 100644
> >> > index 000000000000..1dc803fe72dd
> >> > --- /dev/null
> >> > +++ b/Documentation/networking/netdev-xdp-features.rst
> >> > @@ -0,0 +1,60 @@
> >> > +.. SPDX-License-Identifier: GPL-2.0
> >> > +
> >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > +Netdev XDP features
> >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > +
> >> > + * XDP FEATURES FLAGS
> >> > +
> >> > +Following netdev xdp features flags can be retrieved over route net=
link
> >> > +interface (compact form) - the same way as netdev feature flags.
> >> > +These features flags are read only and cannot be change at runtime.
> >> > +
> >> > +*  XDP_ABORTED
> >> > +
> >> > +This feature informs if netdev supports xdp aborted action.
> >> > +
> >> > +*  XDP_DROP
> >> > +
> >> > +This feature informs if netdev supports xdp drop action.
> >> > +
> >> > +*  XDP_PASS
> >> > +
> >> > +This feature informs if netdev supports xdp pass action.
> >> > +
> >> > +*  XDP_TX
> >> > +
> >> > +This feature informs if netdev supports xdp tx action.
> >> > +
> >> > +*  XDP_REDIRECT
> >> > +
> >> > +This feature informs if netdev supports xdp redirect action.
> >> > +It assumes the all beforehand mentioned flags are enabled.
> >> > +
> >> > +*  XDP_SOCK_ZEROCOPY
> >> > +
> >> > +This feature informs if netdev driver supports xdp zero copy.
> >> > +It assumes the all beforehand mentioned flags are enabled.
> >> > +
> >> > +*  XDP_HW_OFFLOAD
> >> > +
> >> > +This feature informs if netdev driver supports xdp hw oflloading.
> >> > +
> >> > +*  XDP_TX_LOCK
> >> > +
> >> > +This feature informs if netdev ndo_xdp_xmit function requires locki=
ng.
> >> > +
> >> > +*  XDP_REDIRECT_TARGET
> >> > +
> >> > +This feature informs if netdev implements ndo_xdp_xmit callback.
> >> > +
> >> > +*  XDP_FRAG_RX
> >> > +
> >> > +This feature informs if netdev implements non-linear xdp buff suppo=
rt in
> >> > +the driver napi callback.
> >> > +
> >> > +*  XDP_FRAG_TARGET
> >> > +
> >> > +This feature informs if netdev implements non-linear xdp buff suppo=
rt in
> >> > +ndo_xdp_xmit callback. XDP_FRAG_TARGET requires XDP_REDIRECT_TARGET=
 is
> >> > properly
> >> > +supported.
> >> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> >> > index aad12a179e54..ae5a8564383b 100644
> >> > --- a/include/linux/netdevice.h
> >> > +++ b/include/linux/netdevice.h
> >> > @@ -43,6 +43,7 @@
> >> >   #include <net/xdp.h>
> >>
> >> >   #include <linux/netdev_features.h>
> >> > +#include <linux/xdp_features.h>
> >> >   #include <linux/neighbour.h>
> >> >   #include <uapi/linux/netdevice.h>
> >> >   #include <uapi/linux/if_bonding.h>
> >> > @@ -2362,6 +2363,7 @@ struct net_device {
> >> >       struct rtnl_hw_stats64  *offload_xstats_l3;
> >>
> >> >       struct devlink_port     *devlink_port;
> >> > +     xdp_features_t          xdp_features;
> >> >   };
> >> >   #define to_net_dev(d) container_of(d, struct net_device, dev)
> >>
> >> > diff --git a/include/linux/xdp_features.h b/include/linux/xdp_featur=
es.h
> >> > new file mode 100644
> >> > index 000000000000..4e72a86ef329
> >> > --- /dev/null
> >> > +++ b/include/linux/xdp_features.h
> >> > @@ -0,0 +1,64 @@
> >> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> >> > +/*
> >> > + * Network device xdp features.
> >> > + */
> >> > +#ifndef _LINUX_XDP_FEATURES_H
> >> > +#define _LINUX_XDP_FEATURES_H
> >> > +
> >> > +#include <linux/types.h>
> >> > +#include <linux/bitops.h>
> >> > +#include <asm/byteorder.h>
> >> > +#include <uapi/linux/xdp_features.h>
> >> > +
> >> > +typedef u32 xdp_features_t;
> >> > +
> >> > +#define __XDP_F_BIT(bit)     ((xdp_features_t)1 << (bit))
> >> > +#define __XDP_F(name)                __XDP_F_BIT(XDP_F_##name##_BIT)
> >> > +
> >> > +#define XDP_F_ABORTED                __XDP_F(ABORTED)
> >> > +#define XDP_F_DROP           __XDP_F(DROP)
> >> > +#define XDP_F_PASS           __XDP_F(PASS)
> >> > +#define XDP_F_TX             __XDP_F(TX)
> >> > +#define XDP_F_REDIRECT               __XDP_F(REDIRECT)
> >> > +#define XDP_F_REDIRECT_TARGET        __XDP_F(REDIRECT_TARGET)
> >> > +#define XDP_F_SOCK_ZEROCOPY  __XDP_F(SOCK_ZEROCOPY)
> >> > +#define XDP_F_HW_OFFLOAD     __XDP_F(HW_OFFLOAD)
> >> > +#define XDP_F_TX_LOCK                __XDP_F(TX_LOCK)
> >> > +#define XDP_F_FRAG_RX                __XDP_F(FRAG_RX)
> >> > +#define XDP_F_FRAG_TARGET    __XDP_F(FRAG_TARGET)
> >> > +
> >> > +#define XDP_F_BASIC          (XDP_F_ABORTED | XDP_F_DROP |   \
> >> > +                              XDP_F_PASS | XDP_F_TX)
> >> > +
> >> > +#define XDP_F_FULL           (XDP_F_BASIC | XDP_F_REDIRECT)
> >> > +
> >> > +#define XDP_F_FULL_ZC                (XDP_F_FULL | XDP_F_SOCK_ZEROC=
OPY)
> >> > +
> >> > +#define XDP_FEATURES_ABORTED_STR             "xdp-aborted"
> >> > +#define XDP_FEATURES_DROP_STR                        "xdp-drop"
> >> > +#define XDP_FEATURES_PASS_STR                        "xdp-pass"
> >> > +#define XDP_FEATURES_TX_STR                  "xdp-tx"
> >> > +#define XDP_FEATURES_REDIRECT_STR            "xdp-redirect"
> >> > +#define XDP_FEATURES_REDIRECT_TARGET_STR     "xdp-redirect-target"
> >> > +#define XDP_FEATURES_SOCK_ZEROCOPY_STR               "xdp-sock-zero=
copy"
> >> > +#define XDP_FEATURES_HW_OFFLOAD_STR          "xdp-hw-offload"
> >> > +#define XDP_FEATURES_TX_LOCK_STR             "xdp-tx-lock"
> >> > +#define XDP_FEATURES_FRAG_RX_STR             "xdp-frag-rx"
> >> > +#define XDP_FEATURES_FRAG_TARGET_STR         "xdp-frag-target"
> >> > +
> >> > +#define DECLARE_XDP_FEATURES_TABLE(name, length)                   =
          \
> >> > +     const char name[][length] =3D {                               =
            \
> >> > +             [XDP_F_ABORTED_BIT] =3D XDP_FEATURES_ABORTED_STR,     =
            \
> >> > +             [XDP_F_DROP_BIT] =3D XDP_FEATURES_DROP_STR,           =
            \
> >> > +             [XDP_F_PASS_BIT] =3D XDP_FEATURES_PASS_STR,           =
            \
> >> > +             [XDP_F_TX_BIT] =3D XDP_FEATURES_TX_STR,               =
            \
> >> > +             [XDP_F_REDIRECT_BIT] =3D XDP_FEATURES_REDIRECT_STR,   =
            \
> >> > +             [XDP_F_REDIRECT_TARGET_BIT] =3D XDP_FEATURES_REDIRECT_=
TARGET_STR, \
> >> > +             [XDP_F_SOCK_ZEROCOPY_BIT] =3D XDP_FEATURES_SOCK_ZEROCO=
PY_STR,     \
> >> > +             [XDP_F_HW_OFFLOAD_BIT] =3D XDP_FEATURES_HW_OFFLOAD_STR=
,           \
> >> > +             [XDP_F_TX_LOCK_BIT] =3D XDP_FEATURES_TX_LOCK_STR,     =
            \
> >> > +             [XDP_F_FRAG_RX_BIT] =3D XDP_FEATURES_FRAG_RX_STR,     =
            \
> >> > +             [XDP_F_FRAG_TARGET_BIT] =3D XDP_FEATURES_FRAG_TARGET_S=
TR,         \
> >> > +     }
> >> > +
> >> > +#endif /* _LINUX_XDP_FEATURES_H */
> >> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_li=
nk.h
> >> > index 1021a7e47a86..971c658ceaea 100644
> >> > --- a/include/uapi/linux/if_link.h
> >> > +++ b/include/uapi/linux/if_link.h
> >> > @@ -374,6 +374,8 @@ enum {
> >>
> >> >       IFLA_DEVLINK_PORT,
> >>
> >> > +     IFLA_XDP_FEATURES,
> >> > +
> >> >       __IFLA_MAX
> >> >   };
> >>
> >> > @@ -1318,6 +1320,11 @@ enum {
> >>
> >> >   #define IFLA_XDP_MAX (__IFLA_XDP_MAX - 1)
> >>
> >> > +enum {
> >> > +     IFLA_XDP_FEATURES_WORD_UNSPEC =3D 0,
> >> > +     IFLA_XDP_FEATURES_BITS_WORD,
> >> > +};
> >> > +
> >> >   enum {
> >> >       IFLA_EVENT_NONE,
> >> >       IFLA_EVENT_REBOOT,              /* internal reset / reboot */
> >> > diff --git a/include/uapi/linux/xdp_features.h
> >> > b/include/uapi/linux/xdp_features.h
> >> > new file mode 100644
> >> > index 000000000000..48eb42069bcd
> >> > --- /dev/null
> >> > +++ b/include/uapi/linux/xdp_features.h
> >> > @@ -0,0 +1,34 @@
> >> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> >> > +/*
> >> > + * Copyright (c) 2020 Intel
> >> > + */
> >> > +
> >> > +#ifndef __UAPI_LINUX_XDP_FEATURES__
> >> > +#define __UAPI_LINUX_XDP_FEATURES__
> >> > +
> >> > +enum {
> >> > +     XDP_F_ABORTED_BIT,
> >> > +     XDP_F_DROP_BIT,
> >> > +     XDP_F_PASS_BIT,
> >> > +     XDP_F_TX_BIT,
> >> > +     XDP_F_REDIRECT_BIT,
> >> > +     XDP_F_REDIRECT_TARGET_BIT,
> >> > +     XDP_F_SOCK_ZEROCOPY_BIT,
> >> > +     XDP_F_HW_OFFLOAD_BIT,
> >> > +     XDP_F_TX_LOCK_BIT,
> >> > +     XDP_F_FRAG_RX_BIT,
> >> > +     XDP_F_FRAG_TARGET_BIT,
> >> > +     /*
> >> > +      * Add your fresh new property above and remember to update
> >> > +      * documentation.
> >> > +      */
> >> > +     XDP_FEATURES_COUNT,
> >> > +};
> >> > +
> >> > +#define XDP_FEATURES_WORDS                   ((XDP_FEATURES_COUNT +=
 32 - 1) / 32)
> >> > +#define XDP_FEATURES_WORD(blocks, index)     ((blocks)[(index) / 32=
U])
> >> > +#define XDP_FEATURES_FIELD_FLAG(index)               (1U << (index)=
 % 32U)
> >> > +#define XDP_FEATURES_BIT_IS_SET(blocks, index)        \
> >> > +     (XDP_FEATURES_WORD(blocks, index) & XDP_FEATURES_FIELD_FLAG(in=
dex))
> >> > +
> >> > +#endif  /* __UAPI_LINUX_XDP_FEATURES__ */
> >> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> >> > index 64289bc98887..1c299746b614 100644
> >> > --- a/net/core/rtnetlink.c
> >> > +++ b/net/core/rtnetlink.c
> >> > @@ -1016,6 +1016,14 @@ static size_t rtnl_xdp_size(void)
> >> >       return xdp_size;
> >> >   }
> >>
> >> > +static size_t rtnl_xdp_features_size(void)
> >> > +{
> >> > +     size_t xdp_size =3D nla_total_size(0) +   /* nest IFLA_XDP_FEA=
TURES */
> >> > +                       XDP_FEATURES_WORDS * nla_total_size(4);
> >> > +
> >> > +     return xdp_size;
> >> > +}
> >> > +
> >> >   static size_t rtnl_prop_list_size(const struct net_device *dev)
> >> >   {
> >> >       struct netdev_name_node *name_node;
> >> > @@ -1103,6 +1111,7 @@ static noinline size_t if_nlmsg_size(const str=
uct
> >> > net_device *dev,
> >> >              + rtnl_prop_list_size(dev)
> >> >              + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
> >> >              + rtnl_devlink_port_size(dev)
> >> > +            + rtnl_xdp_features_size() /* IFLA_XDP_FEATURES */
> >> >              + 0;
> >> >   }
> >>
> >> > @@ -1546,6 +1555,27 @@ static int rtnl_xdp_fill(struct sk_buff *skb,
> >> > struct net_device *dev)
> >> >       return err;
> >> >   }
> >>
> >> > +static int rtnl_xdp_features_fill(struct sk_buff *skb, struct net_d=
evice
> >> > *dev)
> >> > +{
> >> > +     struct nlattr *attr;
> >> > +
> >> > +     attr =3D nla_nest_start_noflag(skb, IFLA_XDP_FEATURES);
> >> > +     if (!attr)
> >> > +             return -EMSGSIZE;
> >> > +
> >> > +     BUILD_BUG_ON(XDP_FEATURES_WORDS !=3D 1);
> >> > +     if (nla_put_u32(skb, IFLA_XDP_FEATURES_BITS_WORD, dev->xdp_fea=
tures))
> >> > +             goto err_cancel;
> >> > +
> >> > +     nla_nest_end(skb, attr);
> >> > +
> >> > +     return 0;
> >> > +
> >> > +err_cancel:
> >> > +     nla_nest_cancel(skb, attr);
> >> > +     return -EMSGSIZE;
> >> > +}
> >> > +
> >> >   static u32 rtnl_get_event(unsigned long event)
> >> >   {
> >> >       u32 rtnl_event_type =3D IFLA_EVENT_NONE;
> >> > @@ -1904,6 +1934,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *sk=
b,
> >> >       if (rtnl_fill_devlink_port(skb, dev))
> >> >               goto nla_put_failure;
> >>
> >> > +     if (rtnl_xdp_features_fill(skb, dev))
> >> > +             goto nla_put_failure;
> >> > +
> >> >       nlmsg_end(skb, nlh);
> >> >       return 0;
> >>
> >> > @@ -1968,6 +2001,7 @@ static const struct nla_policy
> >> > ifla_policy[IFLA_MAX+1] =3D {
> >> >       [IFLA_TSO_MAX_SIZE]     =3D { .type =3D NLA_REJECT },
> >> >       [IFLA_TSO_MAX_SEGS]     =3D { .type =3D NLA_REJECT },
> >> >       [IFLA_ALLMULTI]         =3D { .type =3D NLA_REJECT },
> >> > +     [IFLA_XDP_FEATURES]     =3D { .type =3D NLA_NESTED },
> >> >   };
> >>
> >> >   static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] =
=3D {
> >> > diff --git a/tools/include/uapi/linux/if_link.h
> >> > b/tools/include/uapi/linux/if_link.h
> >> > index 82fe18f26db5..994228e9909a 100644
> >> > --- a/tools/include/uapi/linux/if_link.h
> >> > +++ b/tools/include/uapi/linux/if_link.h
> >> > @@ -354,6 +354,8 @@ enum {
> >>
> >> >       IFLA_DEVLINK_PORT,
> >>
> >> > +     IFLA_XDP_FEATURES,
> >> > +
> >> >       __IFLA_MAX
> >> >   };
> >>
> >> > @@ -1222,6 +1224,11 @@ enum {
> >>
> >> >   #define IFLA_XDP_MAX (__IFLA_XDP_MAX - 1)
> >>
> >> > +enum {
> >> > +     IFLA_XDP_FEATURES_WORD_UNSPEC =3D 0,
> >> > +     IFLA_XDP_FEATURES_BITS_WORD,
> >> > +};
> >> > +
> >> >   enum {
> >> >       IFLA_EVENT_NONE,
> >> >       IFLA_EVENT_REBOOT,              /* internal reset / reboot */
> >> > diff --git a/tools/include/uapi/linux/xdp_features.h
> >> > b/tools/include/uapi/linux/xdp_features.h
> >> > new file mode 100644
> >> > index 000000000000..48eb42069bcd
> >> > --- /dev/null
> >> > +++ b/tools/include/uapi/linux/xdp_features.h
> >> > @@ -0,0 +1,34 @@
> >> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> >> > +/*
> >> > + * Copyright (c) 2020 Intel
> >> > + */
> >> > +
> >> > +#ifndef __UAPI_LINUX_XDP_FEATURES__
> >> > +#define __UAPI_LINUX_XDP_FEATURES__
> >> > +
> >> > +enum {
> >> > +     XDP_F_ABORTED_BIT,
> >> > +     XDP_F_DROP_BIT,
> >> > +     XDP_F_PASS_BIT,
> >> > +     XDP_F_TX_BIT,
> >> > +     XDP_F_REDIRECT_BIT,
> >> > +     XDP_F_REDIRECT_TARGET_BIT,
> >> > +     XDP_F_SOCK_ZEROCOPY_BIT,
> >> > +     XDP_F_HW_OFFLOAD_BIT,
> >> > +     XDP_F_TX_LOCK_BIT,
> >> > +     XDP_F_FRAG_RX_BIT,
> >> > +     XDP_F_FRAG_TARGET_BIT,
> >> > +     /*
> >> > +      * Add your fresh new property above and remember to update
> >> > +      * documentation.
> >> > +      */
> >> > +     XDP_FEATURES_COUNT,
> >> > +};
> >> > +
> >> > +#define XDP_FEATURES_WORDS                   ((XDP_FEATURES_COUNT +=
 32 - 1) / 32)
> >> > +#define XDP_FEATURES_WORD(blocks, index)     ((blocks)[(index) / 32=
U])
> >> > +#define XDP_FEATURES_FIELD_FLAG(index)               (1U << (index)=
 % 32U)
> >> > +#define XDP_FEATURES_BIT_IS_SET(blocks, index)        \
> >> > +     (XDP_FEATURES_WORD(blocks, index) & XDP_FEATURES_FIELD_FLAG(in=
dex))
> >> > +
> >> > +#endif  /* __UAPI_LINUX_XDP_FEATURES__ */
> >> > --
> >> > 2.38.1
> >>
>=20

--B96UkFntLxXXDuKd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY6GKNwAKCRA6cBh0uS2t
rON6AQCjrZawaz1QorIsoHOki5hACeStOWjuDt2ZBCjNkXC1XwD/b1wXdqy0LKfJ
UKGPDmH+K5fsRqcFxlSUE7MnA82rjgg=
=3Yb9
-----END PGP SIGNATURE-----

--B96UkFntLxXXDuKd--

