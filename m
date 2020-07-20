Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AE0226D0A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbgGTRV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbgGTRV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 13:21:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C65C22482;
        Mon, 20 Jul 2020 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595265718;
        bh=Dt6OB7b43YCono9HQV/Au+o4W7NpXpljAfhYQ13JMJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pXXsF73KmSeOc7M1kWZF2cP/SJ0qbgORB6LjmPYb1ofhBaXzNja2qY2CAVgpvH8Gi
         44MzVQoWUjGV0Cjq3kzpnXKBgTvFq58p6HMCLmu8isAUpr5sUOTTNJwM5KSNr+5yOZ
         B6H+/iotKvDnMvUMX9lPxxmRJIE7+4CEb634yTxQ=
Date:   Mon, 20 Jul 2020 10:21:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, <mhabets@solarflare.com>,
        <mslattery@solarflare.com>
Subject: Re: [PATCH net-next] efx: convert to new udp_tunnel infrastructure
Message-ID: <20200720102156.717e3e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a97d3321-3fee-5217-59e4-e56bfbaff7a3@solarflare.com>
References: <20200717235336.879264-1-kuba@kernel.org>
        <a97d3321-3fee-5217-59e4-e56bfbaff7a3@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 12:45:54 +0100 Edward Cree wrote:
> Subject line prefix should probably be sfc:, that's what we
> =C2=A0usually use for this driver.

Ack.

> On 18/07/2020 00:53, Jakub Kicinski wrote:
> > Check MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TRUSTED, before setting
> > the info, which will hopefully protect us from -EPERM errors =20
> Sorry, I forgot to pass on the answer I got from the firmware
> =C2=A0team, which was "TRUSTED is the wrong thing and there isn't a
> =C2=A0right thing".=C2=A0 The TRUSTED flag will be set on any function
> =C2=A0that can set UDP ports, but may also be set on some that can't
> =C2=A0(it's not clear what they're Trusted to do but this isn't it).
> So it's OK to check it, but the EPERMs could still happen.

I'll amend the commit message, hopefully it's good enough in practice,
and perhaps better bit could be added going forward? :(

> > -static int efx_ef10_udp_tnl_add_port(struct efx_nic *efx,
> > -				     struct efx_udp_tunnel tnl)
> > -{
> > -	struct efx_ef10_nic_data *nic_data =3D efx->nic_data;
> > -	struct efx_udp_tunnel *match;
> > -	char typebuf[8];
> > -	size_t i;
> > -	int rc;
> > +	if (ti->type =3D=3D UDP_TUNNEL_TYPE_VXLAN)
> > +		efx_tunnel_type =3D TUNNEL_ENCAP_UDP_PORT_ENTRY_VXLAN;
> > +	else
> > +		efx_tunnel_type =3D TUNNEL_ENCAP_UDP_PORT_ENTRY_GENEVE; =20
> I think I'd prefer to keep the switch() that explicitlychecks
> =C2=A0for UDP_TUNNEL_TYPE_GENEVE; even though the infrastructure
> =C2=A0makes sure it won't ever not be, I'd still feel more comfortable
> =C2=A0that way.=C2=A0 But it's up to you.

To me the motivation of expressing capabilities is for the core=20
to be able to do the necessary checking (and make more intelligent
decisions). All the drivers I've converted make the assumption they
won't see tunnel types they don't support.

> > @@ -3873,6 +3835,7 @@ static int efx_ef10_udp_tnl_add_port(struct efx_n=
ic *efx,
> >  static bool efx_ef10_udp_tnl_has_port(struct efx_nic *efx, __be16 port)
> >  {
> >  	struct efx_ef10_nic_data *nic_data =3D efx->nic_data;
> > +	size_t i;
> > =20
> >  	if (!(nic_data->datapath_caps &
> >  	      (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN)))
> > @@ -3884,58 +3847,48 @@ static bool efx_ef10_udp_tnl_has_port(struct ef=
x_nic *efx, __be16 port)
> >  		 */
> >  		return false;
> > =20
> > -	return __efx_ef10_udp_tnl_lookup_port(efx, port) !=3D NULL;
> > +	for (i =3D 0; i < ARRAY_SIZE(nic_data->udp_tunnels); ++i)
> > +		if (nic_data->udp_tunnels[i].port =3D=3D port)
> > +			return true;
> > +
> > +	return false;
> >  }
> > =20
> > -static int efx_ef10_udp_tnl_del_port(struct efx_nic *efx,
> > -				     struct efx_udp_tunnel tnl)
> > +static int efx_ef10_udp_tnl_unset_port(struct net_device *dev,
> > +				       unsigned int table, unsigned int entry,
> > +				       struct udp_tunnel_info *ti)
> >  {
> > -	struct efx_ef10_nic_data *nic_data =3D efx->nic_data;
> > -	struct efx_udp_tunnel *match;
> > -	char typebuf[8];
> > +	struct efx_nic *efx =3D netdev_priv(dev);
> > +	struct efx_ef10_nic_data *nic_data;
> >  	int rc;
> > =20
> > -	if (!(nic_data->datapath_caps &
> > -	      (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN)))
> > -		return 0;
> > -
> > -	efx_get_udp_tunnel_type_name(tnl.type, typebuf, sizeof(typebuf));
> > -	netif_dbg(efx, drv, efx->net_dev, "Removing UDP tunnel (%s) port %d\n=
",
> > -		  typebuf, ntohs(tnl.port));
> > +	nic_data =3D efx->nic_data;
> > =20
> >  	mutex_lock(&nic_data->udp_tunnels_lock);
> >  	/* Make sure all TX are stopped while we remove from the table, else =
we
> >  	 * might race against an efx_features_check().
> >  	 */
> >  	efx_device_detach_sync(efx);
> > -
> > -	match =3D __efx_ef10_udp_tnl_lookup_port(efx, tnl.port);
> > -	if (match !=3D NULL) {
> > -		if (match->type =3D=3D tnl.type) {
> > -			if (--match->count) {
> > -				/* Port is still in use, so nothing to do */
> > -				netif_dbg(efx, drv, efx->net_dev,
> > -					  "UDP tunnel port %d remains active\n",
> > -					  ntohs(tnl.port));
> > -				rc =3D 0;
> > -				goto out_unlock;
> > -			}
> > -			rc =3D efx_ef10_set_udp_tnl_ports(efx, false);
> > -			goto out_unlock;
> > -		}
> > -		efx_get_udp_tunnel_type_name(match->type,
> > -					     typebuf, sizeof(typebuf));
> > -		netif_warn(efx, drv, efx->net_dev,
> > -			   "UDP port %d is actually in use by %s, not removing\n",
> > -			   ntohs(tnl.port), typebuf);
> > -	}
> > -	rc =3D -ENOENT;
> > -
> > -out_unlock:
> > +	nic_data->udp_tunnels[entry].port =3D 0; =20
> I'm a little concerned that efx_ef10_udp_tnl_has_port(efx, 0);
> =C2=A0willgenerally return true, so in our yet-to-come TX offloads
> =C2=A0patch we'll need to check for !port when handling an skb with
> =C2=A0skb->encapsulation =3D=3D true before calling has_port.
> (I realise that the kernel almost certainly won't ever give us
> =C2=A0an skb with encap on UDP port 0, but it never hurts to be
> =C2=A0paranoid about things like that).
> Could we not keep a 'valid'/'used' flag in the table, used in
> =C2=A0roughly the same way we were checking count !=3D 0?

How about we do the !port check in efx_ef10_udp_tnl_has_port()?

Per-entry valid / used flag seems a little wasteful.

Another option is to have a reserved tunnel type for invalid / unused.

I don't mind either way.

> Apart from that this all looks fine, and the amount of deleted
> =C2=A0codemakes me happy :)
>=20
> -ed

