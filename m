Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A13D17B38E
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 02:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCFBIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 20:08:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:20219 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgCFBIr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 20:08:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 17:08:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="p7s'?scan'208";a="352619666"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga001.fm.intel.com with ESMTP; 05 Mar 2020 17:08:46 -0800
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 5 Mar 2020 17:08:46 -0800
Received: from orsmsx114.amr.corp.intel.com ([169.254.8.140]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.135]) with mapi id 14.03.0439.000;
 Thu, 5 Mar 2020 17:08:45 -0800
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Tieman, Henry W" <henry.w.tieman@intel.com>
Subject: Re: [net-next 05/16] ice: Add support for tunnel offloads
Thread-Topic: [net-next 05/16] ice: Add support for tunnel offloads
Thread-Index: AQHV8nupG94w3K+ZZ0WY91APKk7GDqg50boAgAF2+YA=
Date:   Fri, 6 Mar 2020 01:08:45 +0000
Message-ID: <4fd3bf3a8d473af7a40831b63e126f3dd6959950.camel@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
         <20200304232136.4172118-6-jeffrey.t.kirsher@intel.com>
         <20200304184638.12845fc7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304184638.12845fc7@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.166.244.155]
Content-Type: multipart/signed; micalg=sha-1;
        protocol="application/x-pkcs7-signature"; boundary="=-Fn0ZDshXmDUaZTRH5RJk"
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-Fn0ZDshXmDUaZTRH5RJk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-03-04 at 18:46 -0800, Jakub Kicinski wrote:
> On Wed,  4 Mar 2020 15:21:25 -0800 Jeff Kirsher wrote:
> > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> >=20
> > Create a boost TCAM entry for each tunnel port in order to get a
> > tunnel
> > PTYPE. Update netdev feature flags and implement the appropriate
> > logic to
> > get and set values for hardware offloads.
> >=20
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > +/**
> > + * ice_create_tunnel
> > + * @hw: pointer to the HW structure
> > + * @type: type of tunnel
> > + * @port: port to use for vxlan tunnel
> > + *
> > + * Creates a tunnel
>=20
> I was going to comment how useless this kdoc is, then I realized that
> it's not only useless but incorrect - port doesn't have to be vxlan,
> you support geneve..

Will fix these.

> > + */
> > +enum ice_status
> > +ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type,
> > u16 port)
> > +{
> > +	struct ice_boost_tcam_section *sect_rx, *sect_tx;
> > +	enum ice_status status =3D ICE_ERR_MAX_LIMIT;
> > +	struct ice_buf_build *bld;
> > +	u16 index;
> > +
> > +	if (ice_tunnel_port_in_use(hw, port, NULL))
> > +		return ICE_ERR_ALREADY_EXISTS;
>=20
> Could you explain how ref counting of ports works? It's possible to
> have multiple tunnels on the same port. Looks like this is just
> bailing
> without even making a note of the request. So delete will just remove
> the port whenever the first tunnel with this port goes down?

We aren't doing ref counting of ports so your observation is correct.=20
Will rework this and add in ref counting so this doesn't occur.  Thanks
for catching this.

> > +	if (!ice_find_free_tunnel_entry(hw, type, &index))
> > +		return ICE_ERR_OUT_OF_RANGE;
> > +
> > +	bld =3D ice_pkg_buf_alloc(hw);
> > +	if (!bld)
> > +		return ICE_ERR_NO_MEMORY;
> > +
> > +	/* allocate 2 sections, one for Rx parser, one for Tx parser */
> > +	if (ice_pkg_buf_reserve_section(bld, 2))
> > +		goto ice_create_tunnel_err;
> > +
> > +	sect_rx =3D (struct ice_boost_tcam_section *)
> > +		ice_pkg_buf_alloc_section(bld,
> > ICE_SID_RXPARSER_BOOST_TCAM,
>=20
> this function returns void, the extremely ugly casts are unnecessary

Will remove

> > +					  sizeof(*sect_rx));
> > +	if (!sect_rx)
> > +		goto ice_create_tunnel_err;
> > +	sect_rx->count =3D cpu_to_le16(1);
> > +
> > +	sect_tx =3D (struct ice_boost_tcam_section *)
> > +		ice_pkg_buf_alloc_section(bld,
> > ICE_SID_TXPARSER_BOOST_TCAM,
>=20
> and here

Will remove

> > +					  sizeof(*sect_tx));
> > +	if (!sect_tx)
> > +		goto ice_create_tunnel_err;
> > +	sect_tx->count =3D cpu_to_le16(1);
> > +
> > +	/* copy original boost entry to update package buffer */
> > +	memcpy(sect_rx->tcam, hw->tnl.tbl[index].boost_entry,
> > +	       sizeof(*sect_rx->tcam));
> > +
> > +	/* over-write the never-match dest port key bits with the
> > encoded port
> > +	 * bits
> > +	 */
> > +	ice_set_key((u8 *)&sect_rx->tcam[0].key, sizeof(sect_rx-
> > >tcam[0].key),
> > +		    (u8 *)&port, NULL, NULL, NULL,
> > +		    offsetof(struct ice_boost_key_value,
> > hv_dst_port_key),
> > +		    sizeof(sect_rx->tcam[0].key.key.hv_dst_port_key));
> > +
> > +	/* exact copy of entry to Tx section entry */
> > +	memcpy(sect_tx->tcam, sect_rx->tcam, sizeof(*sect_tx->tcam));
> > +
> > +	status =3D ice_update_pkg(hw, ice_pkg_buf(bld), 1);
> > +	if (!status) {
> > +		hw->tnl.tbl[index].port =3D port;
> > +		hw->tnl.tbl[index].in_use =3D true;
> > +	}
> > +
> > +ice_create_tunnel_err:
> > +	ice_pkg_buf_free(hw, bld);
> > +
> > +	return status;
> > +}
> > +/**
> > + * ice_udp_tunnel_add - Get notifications about UDP tunnel ports
> > that come up
> > + * @netdev: This physical port's netdev
> > + * @ti: Tunnel endpoint information
> > + */
> > +static void
> > +ice_udp_tunnel_add(struct net_device *netdev, struct
> > udp_tunnel_info *ti)
> > +{
> > +	struct ice_netdev_priv *np =3D netdev_priv(netdev);
> > +	struct ice_vsi *vsi =3D np->vsi;
> > +	struct ice_pf *pf =3D vsi->back;
> > +	enum ice_tunnel_type tnl_type;
> > +	u16 port =3D ntohs(ti->port);
> > +	enum ice_status status;
> > +
> > +	switch (ti->type) {
> > +	case UDP_TUNNEL_TYPE_VXLAN:
> > +		tnl_type =3D TNL_VXLAN;
> > +		break;
> > +	case UDP_TUNNEL_TYPE_GENEVE:
> > +		tnl_type =3D TNL_GENEVE;
> > +		break;
> > +	default:
> > +		netdev_err(netdev, "Unknown tunnel type\n");
> > +		return;
> > +	}
> > +
> > +	status =3D ice_create_tunnel(&pf->hw, tnl_type, port);
> > +	if (status =3D=3D ICE_ERR_ALREADY_EXISTS)
> > +		dev_dbg(ice_pf_to_dev(pf), "port %d already exists in
> > UDP tunnels list\n",
> > +			port);
> > +	else if (status =3D=3D ICE_ERR_OUT_OF_RANGE)
> > +		netdev_err(netdev, "Max tunneled UDP ports reached,
> > port %d not added\n",
> > +			   port);
>=20
> error is probably a little much for resource exhaustion since it's
> not
> going to cause any problem other than a slow down?

Correct, just a slow down. A warning then or did you prefer a dbg?

> > +	else if (status)
> > +		netdev_err(netdev, "Error adding UDP tunnel - %d\n",
> > +			   status);
> > +}
> > +
> > +/**
> > + * ice_udp_tunnel_del - Get notifications about UDP tunnel ports
> > that go away
> > + * @netdev: This physical port's netdev
> > + * @ti: Tunnel endpoint information
> > + */
> > +static void
> > +ice_udp_tunnel_del(struct net_device *netdev, struct
> > udp_tunnel_info *ti)
> > +{
> > +	struct ice_netdev_priv *np =3D netdev_priv(netdev);
> > +	struct ice_vsi *vsi =3D np->vsi;
> > +	struct ice_pf *pf =3D vsi->back;
> > +	u16 port =3D ntohs(ti->port);
> > +	enum ice_status status;
> > +	bool retval;
> > +	u16 index;
> > +
> > +	retval =3D ice_tunnel_port_in_use(&pf->hw, port, &index);
>=20
> nit: index is never used

Will remove this.

Thanks,
Tony

--=-Fn0ZDshXmDUaZTRH5RJk
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
UDSWFPJn1IonMumCuP0DYWGYiGS8dKTJMMh2WA2XVewXVn0JQTWQDpckAOkmi+A0RwpZzYJ0Y3gT
AgMBAAGjggI2MIICMjAdBgNVHQ4EFgQUydTU8+nnPeJE0ndEkV7rlhV6p30wHwYDVR0jBBgwFoAU
HmkqtNwo/kcYTiELP7ysES/wmPUwZQYDVR0fBF4wXDBaoFigVoZUaHR0cDovL3d3dy5pbnRlbC5j
b20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENB
JTIwNEEuY3JsMIGeBggrBgEFBQcBAQSBkTCBjjBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRl
bC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIw
SXNzdWluZyUyMENBJTIwNEEuY3J0MCEGCCsGAQUFBzABhhVodHRwOi8vb2NzcC5pbnRlbC5jb20w
CwYDVR0PBAQDAgeAMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OC
kcAJZ4HevTmV8EMCAWQCAQkwHwYDVR0lBBgwFgYIKwYBBQUHAwQGCisGAQQBgjcKAwwwKQYJKwYB
BAGCNxUKBBwwGjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgMMMFEGA1UdEQRKMEigKgYKKwYBBAGC
NxQCA6AcDBphbnRob255Lmwubmd1eWVuQGludGVsLmNvbYEaYW50aG9ueS5sLm5ndXllbkBpbnRl
bC5jb20wDQYJKoZIhvcNAQEFBQADggEBALLF5b7PLd6kEWuQRkEq6eZpohKWRkfC9DyLiwS+HaeH
9euNcIqpV4xrMXM6mPqs3AHRb9ibqUPo3wQMtHph35RRsmY7ENk9FxF/W8Ov5ZVPyW0rFiRsnr1C
QVc08YqXp1dlbQGf8nvJn8ryCwjNpw0CTQcGHXrL/YnboLu8+R9RdBue/HIlP4g0pyAC/8YOie04
PVo4flU2CGMYilm1euQ6OV8WRA2CKgvRVp/DZEzTqnmDvy12efG74bmMzXAvDv2I53TR5ltDpx5X
B8uO1XlhOrj+Z3mSi85eblWWhJlq6+TQH/hZWSiyZH2lo3J49oHClTlk86GUEIUp/sf5v5cxggIX
MIICEwIBATCBkDB5MQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFDASBgNVBAcTC1NhbnRhIENs
YXJhMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwg
QmFzaWMgSXNzdWluZyBDQSA0QQITMwAA0J5PWjT/SLEH2wAAAADQnjAJBgUrDgMCGgUAoF0wGAYJ
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwMzA2MDEwODQzWjAjBgkq
hkiG9w0BCQQxFgQURyqeogBaemlaHG/8D+tqQ+Oe+KcwDQYJKoZIhvcNAQEBBQAEggEAmTFnDMhH
kwdZXA/UfEwIguyOmJN80MSY+fl3u4Pq0f0FMlvq/O/V+w+yVA9hqSKvBWY7zQ3po5Hai76OkQ2b
RYuk6HmRN/NJOikPGpY1MoHtS650nhlLNVtc0lJf8Qv06z0DTgFrL4qlDfXXZpDObJQMM6d8eKbs
bkpEgCHdwu35X9FG9h1hsq6/cETA5py1+RqDcbpqafAlv7WZYHEfKGeAYTVj8Wkgic64fUY94bdo
sSvqyUAUEFtPwysBx6Di5TWWHb0oOma7rQYCORb2pCaP/0hMjvSe+vlrEpbCzhM5sUAaB0+wHLDp
j49udMc71Sup/W9I4VFszwdPorc1uAAAAAAAAA==


--=-Fn0ZDshXmDUaZTRH5RJk--
