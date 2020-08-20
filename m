Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A197F24B088
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 09:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgHTHyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 03:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgHTHyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 03:54:10 -0400
Received: from localhost (unknown [151.48.139.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D30A72076E;
        Thu, 20 Aug 2020 07:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597910048;
        bh=cIdaJgtUjYwyU2nbZYKhsp8LoUVCX6b/qB63vi6+X6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bD2ecsFFGHqF3Hw9enc8MjGtnqsaxDyEI98IHmDYOWY3Psi3D6uPz6oEbwklT84/u
         7ONmqoXu3rQLZ5+4YmK86CXwsL/6SKYNrQ9SuGskdrqFB1tm6QT3enKtVAcP0JfIbO
         cQ59GTYEpP2UWC4Q+WbSoZ4xrg/ESsZn4kii9RuI=
Date:   Thu, 20 Aug 2020 09:54:03 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: Re: [PATCH net-next 6/6] net: mvneta: enable jumbo frames for XDP
Message-ID: <20200820075403.GB2282@lore-desk>
References: <cover.1597842004.git.lorenzo@kernel.org>
 <3e0d98fafaf955868205272354e36f0eccc80430.1597842004.git.lorenzo@kernel.org>
 <20200819122328.0dab6a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200819202223.GA179529@lore-desk>
 <20200819141428.24e5183a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5f3da06d5de6c_1b0e2ab87245e5c01b@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <5f3da06d5de6c_1b0e2ab87245e5c01b@john-XPS-13-9370.notmuch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Jakub Kicinski wrote:
> > On Wed, 19 Aug 2020 22:22:23 +0200 Lorenzo Bianconi wrote:
> > > > On Wed, 19 Aug 2020 15:13:51 +0200 Lorenzo Bianconi wrote: =20
> > > > > Enable the capability to receive jumbo frames even if the interfa=
ce is
> > > > > running in XDP mode
> > > > >=20
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org> =20
> > > >=20
> > > > Hm, already? Is all the infra in place? Or does it not imply
> > > > multi-buffer.
> > >=20
> > > with this series mvneta supports xdp multi-buff on both rx and tx sid=
es (XDP_TX
> > > and ndo_xpd_xmit()) so we can remove MTU limitation.
> >=20
> > Is there an API for programs to access the multi-buf frames?
>=20
> Hi Lorenzo,

Hi Jakub and John,

>=20
> This is not enough to support multi-buffer in my opinion. I have the
> same comment as Jakub. We need an API to pull in the multiple
> buffers otherwise we break the ability to parse the packets and that
> is a hard requirement to me. I don't want to lose visibility to get
> jumbo frames.

I have not been so clear in the commit message, sorry for that.
This series aims to finalize xdp multi-buff support for mvneta driver only.
Our plan is to work on the helpers/metadata in subsequent series since
driver support is quite orthogonal. If you think we need the helpers
in place before removing the mtu constraint, we could just drop last
patch (6/6) and apply patches from 1/6 to 5/6 since they are preliminary
to remove the mtu constraint. Do you agree?

>=20
> At minimum we need a bpf_xdp_pull_data() to adjust pointer. In the
> skmsg case we use this,
>=20
>   bpf_msg_pull_data(u32 start, u32 end, u64 flags)
>=20
> Where start is the offset into the packet and end is the last byte we
> want to adjust start/end pointers to. This way we can walk pages if
> we want and avoid having to linearize the data unless the user actual
> asks us for a block that crosses a page range. Smart users then never
> do a start/end that crosses a page boundary if possible. I think the
> same would apply here.
>=20
> XDP by default gives you the first page start/end to use freely. If
> you need to parse deeper into the payload then you call bpf_msg_pull_data
> with the byte offsets needed.

Our first proposal is described here [0][1]. In particular, we are assuming=
 the
eBPF layer can access just the first fragment in the non-linear XDP buff and
we will provide some non-linear xdp metadata (e.g. # of segments in the xdp=
_buffer
or buffer total length) to the eBPF program attached to the interface.
Anyway IMHO this mvneta series is not strictly related to this approach.

Regards,
Lorenzo

[0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-m=
ulti-buffer01-design.org
[1] http://people.redhat.com/lbiancon/conference/NetDevConf2020-0x14/add-xd=
p-on-driver.html (XDP multi-buffers section)

>=20
> Also we would want performance numbers to see how good/bad this is
> compared to the base case.
>=20
> Thanks,
> John

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXz4sGQAKCRA6cBh0uS2t
rAEhAP9eSNft43n7muFkfpERqALkQTKHSjh0mnbMNGC4xDwTlgD/aenDM5dFWyOv
H9An1MCb3XwD69ZYaF/GGWjnnN3Ungg=
=+HA3
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
