Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A8B203653
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgFVMC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbgFVMC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 08:02:57 -0400
Received: from localhost (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5B6B206EB;
        Mon, 22 Jun 2020 12:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592827377;
        bh=Q6laQQgpZ5iRN3HAU54xvYzJN3NhQZ5O/4xbdo6r7lM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHMCd9uxh0ntGtwFKpw3aWmr3qz+l6ZHGxQ62VNgLUD5j0CPq0XBcAWz3Hw30ualy
         dD229th1uM5GH/7mMZVASl9x7tSN8ZJs0GM16txftF+MtkfhCrAHLdUpxoZn/yyrmu
         mk0J2AzNjGH4HOZXvNd/emM2V2RjvCOYy5SxE99I=
Date:   Mon, 22 Jun 2020 14:02:52 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Numan Siddique <nusiddiq@redhat.com>,
        Greg Rose <gvrose8192@gmail.com>, lorenzo.bianconi@redhat.com,
        ovs dev <dev@openvswitch.org>
Subject: Re: [PATCH net] openvswitch: take into account de-fragmentation in
 execute_check_pkt_len
Message-ID: <20200622120252.GC14425@localhost.localdomain>
References: <74266291a0aba929919f71ff3dbd1c36392bb4c4.1592567032.git.lorenzo@kernel.org>
 <CAOrHB_B2GO51hRy_kj3kdJKrFURFbKubhGvanLKCRHDc9DKeyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Content-Disposition: inline
In-Reply-To: <CAOrHB_B2GO51hRy_kj3kdJKrFURFbKubhGvanLKCRHDc9DKeyg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Jun 19, 2020 at 4:48 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > ovs connection tracking module performs de-fragmentation on incoming
> > fragmented traffic. Take info account if traffic has been de-fragmented
> > in execute_check_pkt_len action otherwise we will perform the wrong
> > nested action considering the original packet size. This issue typically
> > occurs if ovs-vswitchd adds a rule in the pipeline that requires connec=
tion
> > tracking (e.g. OVN stateful ACLs) before execute_check_pkt_len action.
> >
> > Fixes: 4d5ec89fc8d14 ("net: openvswitch: Add a new action check_pkt_len=
")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/openvswitch/actions.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > index fc0efd8833c8..9f4dd64e53bb 100644
> > --- a/net/openvswitch/actions.c
> > +++ b/net/openvswitch/actions.c
> > @@ -1169,9 +1169,10 @@ static int execute_check_pkt_len(struct datapath=
 *dp, struct sk_buff *skb,
> >                                  struct sw_flow_key *key,
> >                                  const struct nlattr *attr, bool last)
> >  {
> > +       struct ovs_skb_cb *ovs_cb =3D OVS_CB(skb);
> >         const struct nlattr *actions, *cpl_arg;
> >         const struct check_pkt_len_arg *arg;
> > -       int rem =3D nla_len(attr);
> > +       int len, rem =3D nla_len(attr);
> >         bool clone_flow_key;
> >
> >         /* The first netlink attribute in 'attr' is always
> > @@ -1180,7 +1181,8 @@ static int execute_check_pkt_len(struct datapath =
*dp, struct sk_buff *skb,
> >         cpl_arg =3D nla_data(attr);
> >         arg =3D nla_data(cpl_arg);
> >
> > -       if (skb->len <=3D arg->pkt_len) {
> > +       len =3D ovs_cb->mru ? ovs_cb->mru : skb->len;
> > +       if (len <=3D arg->pkt_len) {
>=20
> We could also check for the segmented packet and use  segment length
> for this check.

Hi Pravin,

thx for review.
By 'segmented packet' and 'segment length', do you mean 'fragment' and
'fragment length'?
If so I guess we can't retrieve the original fragment length if we exec
OVS_ACTION_ATTR_CT before OVS_ACTION_ATTR_CHECK_PKT_LEN (e.g if we have a
stateful ACL in the ingress pipeline) since handle_fragments() will reconst=
ruct
the whole IP datagram and it will store frag_max_size in OVS_CB(skb)->mru.
Am I missing something?

Regards,
Lorenzo


--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXvCd6gAKCRA6cBh0uS2t
rFnmAP4jOVAkyRbyLpUZ3ylfZYP6CPTO0noYiSFoffmpgO07EQD+MM+Y0QqB16ex
TNkV4lo3ByEaVZ6nXqmFc7xFFxEFBQ8=
=r9RW
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
