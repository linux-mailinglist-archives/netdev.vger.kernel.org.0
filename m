Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF791B3AC1
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 11:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgDVJG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 05:06:58 -0400
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:7842
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbgDVJG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 05:06:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCzkbcET0Cu30cxtZEHCiHfM07V77cvQUkOd1y7llIWSUA0FW3uERYLSfpuSwVIqMoM75HQx/YZeKVmuaCQrlelf1BFK9pAKdQkQ6sgA2xzLB10zhR5SVFbO9HSX5eRghZW3cXgVlOhZs7oKMIz+QEU1GHsLsfSaLVd9MRC24KjRqtdNpkB4D2YEB/qI99L1C2A7jizA1zvAfcL+b4YuYbUAH+mI5EcZkvo/uTYtI01RijS+vCQv2d9w++7bZrqMMEG1SNr35qQ5+DzYsghjyXYK9ZVdl7vAeoX96g2GdcWzpFhATuaaKBKkXbf4++fVSMKvXI8OrzXQLZCY52hfFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFC+VA15APaceDJ33+9ru3obtXYLpNDTAuLaXs8X91Q=;
 b=OhCV0i7sdv6CURZcVFIum81hagcIYgux8Pq/srL4+AqASCeLiSogUlWe97ArE495orZr04l68o9H4RONIvxL+SFX63T1PFtxTnJWF1R+N352DM+M57D9yM6Q8E/Y5yqyY2JdY3O3Y9sBEb7cy/Emq9QlDuRGZ0+TZOdDxAYxKQ3ONLu5X3znOUNDgqd2KfdhmgT/Su/seDrT+rbOG45NyDRzz9TLV6QLGRVpQnZx1C6oG/P4GzJ2QjfuCw9QWo/atwzZoIno31mmZV8S7ZS0IDK/v4SQJyUQt8xiAPIP+7Kt4s1sAieZX0Rp+SGgfoN8L0YB8L0WKHGD08Z94SWlpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFC+VA15APaceDJ33+9ru3obtXYLpNDTAuLaXs8X91Q=;
 b=pKQYZpLub48KE39IJlhNGt4G1bZGqQnNYP4dMtKE6AmnJG4yJOHC3LLYBPEbxqqsib4ujGmqxxP/M80h02bmwzcfzWWqfFzWGv0i8rBoBUaNBPkmo763gfWYesqSTjEo7fAAZWRIRrNXwtcMjVxTLM2/kWDws1bvsARq8vXoLtk=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (2603:10a6:10:113::21)
 by DB8PR04MB6379.eurprd04.prod.outlook.com (2603:10a6:10:107::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Wed, 22 Apr
 2020 09:06:55 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d%8]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 09:06:55 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 4/4] dpaa2-eth: use bulk enqueue in .ndo_xdp_xmit
Thread-Topic: [PATCH net-next 4/4] dpaa2-eth: use bulk enqueue in
 .ndo_xdp_xmit
Thread-Index: AQHWF/CxxvxMQFGarE6TYAS6knCRDKiEut8AgAAHhzCAABBKgIAAAPvw
Date:   Wed, 22 Apr 2020 09:06:54 +0000
Message-ID: <DB8PR04MB682828DD1BA7881575ED8127E0D20@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200421152154.10965-1-ioana.ciornei@nxp.com>
        <20200421152154.10965-5-ioana.ciornei@nxp.com>
        <20200422091226.774b0dd7@carbon>
        <DB8PR04MB6828FCFAC2B6755E046B0B05E0D20@DB8PR04MB6828.eurprd04.prod.outlook.com>
 <20200422103741.690765d0@carbon>
In-Reply-To: <20200422103741.690765d0@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.25.102.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 46caa903-6408-4a24-0f91-08d7e69c8119
x-ms-traffictypediagnostic: DB8PR04MB6379:
x-microsoft-antispam-prvs: <DB8PR04MB63791D4BA937E195F39AD77FE0D20@DB8PR04MB6379.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03818C953D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(52536014)(8676002)(66946007)(64756008)(71200400001)(66556008)(76116006)(66446008)(66476007)(26005)(86362001)(54906003)(9686003)(44832011)(6506007)(186003)(5660300002)(81156014)(316002)(7696005)(8936002)(4326008)(33656002)(6916009)(2906002)(55016002)(478600001)(142923001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f7bu3wmVT0CElUgj95KLTndNz5QE2e0zwVSz6FZAMskQ4kxkSQjEPqBuIeBw3S7RzUH1ZQAVuP3tYhmnQ+mDDpq0NzHEB77lyFUSdky7L9WFXNN0Nd/930zd5W/MiwN9XG1Wxv6f+ZyxYtVbkQqIPs+KTY6peoh3syFTM2we5DKnf703H2Di6RInHe+iXJmQS9n6e6tG6zcwlKdE1Kgupg02xEtEbvFBs1jxZCCkORKCG/QIq9nfLvD4h15Tr9t/7f3Rdfa06pHVgJEQ40FGn6IIfuvNclA4/lUYHh+0b4n0sJhRzuIm8zkaXShvgAnh6DiwTe2Q+8ySvy7SP5HXFfGMCHLuy8azuzDuSFfQ0AbszrsTyG7mehguyzPjw+v/3McD3E8PTn/vbjB2HWslRw0NtD6UfafjHCnmQcCqO2ijSJmAJWH4r+HJkCP7sCbmBBMCVUiGptlAIjcL3WUX8SU/K15Y24Bi1tI9X6d6eMiQ6lB+OtscDz7FaO6eWQMY
x-ms-exchange-antispam-messagedata: xH/bBb4BBwcmgpdYrefV776Ju/SLxp8ltlftvf50P/F9B1Uf6LR+DBe42X65rVJwaRgu6K0DiWZBMN9JKYPFTIyelfpwB5voD5yYdpGztZoD4vkEdRqviwvQww0AvmAPpBkubSp2KItlbRrPade0fQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46caa903-6408-4a24-0f91-08d7e69c8119
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2020 09:06:55.0050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F1COVAcV6/dQqsZWuns2wdPkYuPx2S7t7oJNlZRiDSHr/XbzTxvV4ci3cXDVCH1X0WtVWlTwylJ1VKWbwlMPBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6379
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 4/4] dpaa2-eth: use bulk enqueue in
> .ndo_xdp_xmit
>=20
> On Wed, 22 Apr 2020 07:51:46 +0000
> Ioana Ciornei <ioana.ciornei@nxp.com> wrote:
>=20
> > > Subject: Re: [PATCH net-next 4/4] dpaa2-eth: use bulk enqueue in
> > > .ndo_xdp_xmit
> > >
> > > On Tue, 21 Apr 2020 18:21:54 +0300
> > > Ioana Ciornei <ioana.ciornei@nxp.com> wrote:
> > >
> > > > Take advantage of the bulk enqueue feature in .ndo_xdp_xmit.
> > > > We cannot use the XDP_XMIT_FLUSH since the architecture is not
> > > > capable to store all the frames dequeued in a NAPI cycle so we
> > > > instead are enqueueing all the frames received in a ndo_xdp_xmit ca=
ll right
> away.
> > > >
> > > > After setting up all FDs for the xdp_frames received, enqueue
> > > > multiple frames at a time until all are sent or the maximum number
> > > > of retries is hit.
> > > >
> > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > ---
> > > >  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 60
> > > > ++++++++++---------
> > > >  1 file changed, 32 insertions(+), 28 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > > index 9a0432cd893c..08b4efad46fd 100644
> > > > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > > @@ -1933,12 +1933,12 @@ static int dpaa2_eth_xdp_xmit(struct
> > > > net_device
> > > *net_dev, int n,
> > > >  			      struct xdp_frame **frames, u32 flags)  {
> > > >  	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
> > > > +	int total_enqueued =3D 0, retries =3D 0, enqueued;
> > > >  	struct dpaa2_eth_drv_stats *percpu_extras;
> > > >  	struct rtnl_link_stats64 *percpu_stats;
> > > > +	int num_fds, i, err, max_retries;
> > > >  	struct dpaa2_eth_fq *fq;
> > > > -	struct dpaa2_fd fd;
> > > > -	int drops =3D 0;
> > > > -	int i, err;
> > > > +	struct dpaa2_fd *fds;
> > > >
> > > >  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> > > >  		return -EINVAL;
> > > > @@ -1946,41 +1946,45 @@ static int dpaa2_eth_xdp_xmit(struct
> > > > net_device
> > > *net_dev, int n,
> > > >  	if (!netif_running(net_dev))
> > > >  		return -ENETDOWN;
> > > >
> > > > +	/* create the array of frame descriptors */
> > > > +	fds =3D kcalloc(n, sizeof(*fds), GFP_ATOMIC);
> > >
> > > I don't like that you have an allocation on the transmit fast-path.
> > >
> > > There are a number of ways you can avoid this.
> > >
> > > Option (1) Given we know that (currently) devmap will max bulk 16
> > > xdp_frames, we can have a call-stack local array with struct
> > > dpaa2_fd, that contains 16 elements, sizeof(struct dpaa2_fd)=3D=3D32
> > > bytes times 16 is
> > > 512 bytes, so it might be acceptable.  (And add code to alloc if n >
> > > 16, to be compatible with someone increasing max bulk in devmap).
> > >
> >
> > I didn't know about the 16 max xdp_frames . Thanks.
> >
> > > Option (2) extend struct dpaa2_eth_priv with an array of 16 struct
> > > dpaa2_fd's, that can be used as fds storage.
> >
> > I have more of a noob question here before proceeding with one of the
> > two options.
> >
> > The ndo_xdp_xmit() callback can be called concurrently from multiple
> > softirq contexts, right?
>=20
> Yes.
>=20
> > If the above is true, then I think the dpaa2_eth_ch_xdp is the right
> > struct to place the array of 16 FDs.
>=20
> Good point, and it sounds correct to use dpaa2_eth_ch_xdp.
>=20
> > Also, is there any caveat to just use DEV_MAP_BULK_SIZE when declaring
> > the array?
>=20
> Using DEV_MAP_BULK_SIZE sounds like a good idea.  Even if someone decide =
to
> increase that to 64, then this is only 2048 bytes(32*64).
>=20

Currently the macro is private to devmap.c. Maybe move it to the xdp.h head=
er
file for access from drivers? I'll include this in v2.

Ioana

>=20
> > >
> > > > +	if (!fds)
> > > > +		return -ENOMEM;
> > > > +
> > >
> > > [...]
> > > > +	kfree(fds);
> > >
> > >
> >
>=20
>=20
>=20

