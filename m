Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858077AC22
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfG3PTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 11:19:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35651 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729727AbfG3PTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 11:19:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so66232585wrm.2
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 08:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UOGozXeEu/z5mHEu4pU+I7JMDlmvX37DnLiRdZ+0/HI=;
        b=dmaX2O6CWM2aFkJwbMf3VTgG8XRaQjY0kP8Tpa6icOr3HqHQf05/F6VSto8ej9xwj2
         V6RYbTlGAfslgeNI6veIID55gYjm+M0TNquHZnNARW1sKMpt9QcP9YcChbm7IMEla8PL
         oNhrkDyDtrpc0Sy4dTaKHjqMTN2PdUjDN30wgjb6f5qglAZNjM3AtQLqIz/oRo9kSp+o
         2frSSQCm//SAsCFX5Xz9IoOpmrTeVL55xzCZKfxW9Kj+pd25Fchv/p/cw2upUbVBg0x4
         CCwArtWz1Jfd32sFBdAlhXGKDI3D9YBQS62GzUeng15h2GqDTpg3JiJ1ueHeh7GhufsN
         U+gQ==
X-Gm-Message-State: APjAAAUYnNOMj+pNMkqYgHFthf7GHJEfocAge7Mc6OyV1MUetR4CJDJy
        J+AGkZsUrFV4w0S7Z9HzwWkR6w==
X-Google-Smtp-Source: APXvYqwMY7UBuSvrx7iEWrdcmrWKnrjEG5+39Dvuvnr/1/yS3xhbY0laFlp8Y9g/fSc9vYPzJ81ICA==
X-Received: by 2002:a5d:6a05:: with SMTP id m5mr55530272wru.305.1564499987358;
        Tue, 30 Jul 2019 08:19:47 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id n1sm49370142wrx.39.2019.07.30.08.19.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 08:19:46 -0700 (PDT)
Date:   Tue, 30 Jul 2019 17:19:44 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dsahern@gmail.com,
        marek@cloudflare.com
Subject: Re: [PATCH net v3] net: neigh: fix multiple neigh timer scheduling
Message-ID: <20190730151944.GB18771@localhost.localdomain>
References: <552d7c8de6a07e12f7b76791da953e81478138cd.1563134704.git.lorenzo.bianconi@redhat.com>
 <alpine.LFD.2.21.1907211606200.3535@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1907211606200.3535@ja.home.ssi.bg>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> 	Hello,

Hi Julian,

sorry for the late reply, I was AFK

>=20
> On Sun, 14 Jul 2019, Lorenzo Bianconi wrote:
>=20
> > Neigh timer can be scheduled multiple times from userspace adding
>=20
> 	If the garbage comes from ndm_state, why we should create
> a patch that just covers the problem?:
>=20
> State: INCOMPLETE, STALE, FAILED, 0x8400 (0x8425)
>=20
> 	User space is trying to create entry that is both
> STALE (no timer) and INCOMPLETE (with timer). So, in the
> 2nd NL message __neigh_event_send() detects timer with NUD_STALE
> bit. What if this 2nd message never comes? Such inconsistence
> between nud_state and the timer can trigger other bugs in
> other functions.

I guess this patch is not harmful since it does nothing if we are not in
IN_TIMER and it fixes an issue if for some reason we hit this code and we
have already scheduled the neigh timer (other parts of the state machine
do the same). Anyway I agree we could add some sanity checks to inputs from
userspace.

Regards,
Lorenzo

>=20
> 	May be we just need to restrict ndm_state and to drop
> this patch, for example, by adding checks in __neigh_update():
>=20
>         if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
>             (old & (NUD_NOARP | NUD_PERMANENT)))
>                 goto out;
> +	/* State must be single bit or 0 */
> +	if (new & (new - 1))
> +		goto out;
>         if (neigh->dead) {
>=20
> 	If needed, this check can be moved only for ndm_state
> in neigh_add().
>=20
> > multiple neigh entries and forcing the neigh timer scheduling passing
> > NTF_USE in the netlink requests.
> > This will result in a refcount leak and in the following dump stack:
>=20
> 	It is a single create with multiple bits in state with following
> __neigh_event_send(). And who knows, this bug may exist even in Linux 2.2=
=20
> and below...
>=20
> > [   32.465295] NEIGH: BUG, double timer add, state is 8
> > [   32.465308] CPU: 0 PID: 416 Comm: double_timer_ad Not tainted 5.2.0+=
 #65
> > [   32.465311] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=
 1.12.0-2.fc30 04/01/2014
> > [   32.465313] Call Trace:
> > [   32.465318]  dump_stack+0x7c/0xc0
> > [   32.465323]  __neigh_event_send+0x20c/0x880
> > [   32.465326]  ? ___neigh_create+0x846/0xfb0
> > [   32.465329]  ? neigh_lookup+0x2a9/0x410
> > [   32.465332]  ? neightbl_fill_info.constprop.0+0x800/0x800
> > [   32.465334]  neigh_add+0x4f8/0x5e0
> > [   32.465337]  ? neigh_xmit+0x620/0x620
> > [   32.465341]  ? find_held_lock+0x85/0xa0
> > [   32.465345]  rtnetlink_rcv_msg+0x204/0x570
> > [   32.465348]  ? rtnl_dellink+0x450/0x450
> > [   32.465351]  ? mark_held_locks+0x90/0x90
> > [   32.465354]  ? match_held_lock+0x1b/0x230
> > [   32.465357]  netlink_rcv_skb+0xc4/0x1d0
> > [   32.465360]  ? rtnl_dellink+0x450/0x450
> > [   32.465363]  ? netlink_ack+0x420/0x420
> > [   32.465366]  ? netlink_deliver_tap+0x115/0x560
> > [   32.465369]  ? __alloc_skb+0xc9/0x2f0
> > [   32.465372]  netlink_unicast+0x270/0x330
> > [   32.465375]  ? netlink_attachskb+0x2f0/0x2f0
> > [   32.465378]  netlink_sendmsg+0x34f/0x5a0
> > [   32.465381]  ? netlink_unicast+0x330/0x330
> > [   32.465385]  ? move_addr_to_kernel.part.0+0x20/0x20
> > [   32.465388]  ? netlink_unicast+0x330/0x330
> > [   32.465391]  sock_sendmsg+0x91/0xa0
> > [   32.465394]  ___sys_sendmsg+0x407/0x480
> > [   32.465397]  ? copy_msghdr_from_user+0x200/0x200
> > [   32.465401]  ? _raw_spin_unlock_irqrestore+0x37/0x40
> > [   32.465404]  ? lockdep_hardirqs_on+0x17d/0x250
> > [   32.465407]  ? __wake_up_common_lock+0xcb/0x110
> > [   32.465410]  ? __wake_up_common+0x230/0x230
> > [   32.465413]  ? netlink_bind+0x3e1/0x490
> > [   32.465416]  ? netlink_setsockopt+0x540/0x540
> > [   32.465420]  ? __fget_light+0x9c/0xf0
> > [   32.465423]  ? sockfd_lookup_light+0x8c/0xb0
> > [   32.465426]  __sys_sendmsg+0xa5/0x110
> > [   32.465429]  ? __ia32_sys_shutdown+0x30/0x30
> > [   32.465432]  ? __fd_install+0xe1/0x2c0
> > [   32.465435]  ? lockdep_hardirqs_off+0xb5/0x100
> > [   32.465438]  ? mark_held_locks+0x24/0x90
> > [   32.465441]  ? do_syscall_64+0xf/0x270
> > [   32.465444]  do_syscall_64+0x63/0x270
> > [   32.465448]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >=20
> > Fix the issue unscheduling neigh_timer if selected entry is in 'IN_TIME=
R'
> > receiving a netlink request with NTF_USE flag set
> >=20
> > Reported-by: Marek Majkowski <marek@cloudflare.com>
> > Fixes: 0c5c2d308906 ("neigh: Allow for user space users of the neighbou=
r table")
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> > Changes since v2:
> > - remove check_timer flag and run neigh_del_timer directly
> > Changes since v1:
> > - fix compilation errors defining neigh_event_send_check_timer routine
> > ---
> >  net/core/neighbour.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index 742cea4ce72e..0dfc97bc8760 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -1124,6 +1124,7 @@ int __neigh_event_send(struct neighbour *neigh, s=
truct sk_buff *skb)
> > =20
> >  			atomic_set(&neigh->probes,
> >  				   NEIGH_VAR(neigh->parms, UCAST_PROBES));
> > +			neigh_del_timer(neigh);
> >  			neigh->nud_state     =3D NUD_INCOMPLETE;
> >  			neigh->updated =3D now;
> >  			next =3D now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
> > @@ -1140,6 +1141,7 @@ int __neigh_event_send(struct neighbour *neigh, s=
truct sk_buff *skb)
> >  		}
> >  	} else if (neigh->nud_state & NUD_STALE) {
> >  		neigh_dbg(2, "neigh %p is delayed\n", neigh);
> > +		neigh_del_timer(neigh);
> >  		neigh->nud_state =3D NUD_DELAY;
> >  		neigh->updated =3D jiffies;
> >  		neigh_add_timer(neigh, jiffies +
> > --=20
> > 2.21.0
>=20
> Regards
>=20
> --
> Julian Anastasov <ja@ssi.bg>

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXUBgDQAKCRA6cBh0uS2t
rE+eAP0f78IK7ypo3lS88fg3U9vVzRiH/brD5bfxA6kVLSeqYQD+L6b3i29/l4wL
pQSlM37Bd7InnmhkPMh7vw/zPygGawo=
=jbiI
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
