Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB5935FE64
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhDNXZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232827AbhDNXZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:25:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0803961220;
        Wed, 14 Apr 2021 23:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442701;
        bh=FuZXBioACGkzvJnGBR9M2PGdMuLQHIAnkdad4TdzLl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M48OohU6YCGsiHm5cJ4vWZXEJ4aW7DnnB8CRYSGFQdYoAmS3PejOpvEUWkxUCU7mC
         deW/Rxi7Oq1Y23caO1a0qZH/tphGS3OIzg9efNHRZhnN9RJw8ZAXnffpF9TWfYHJ58
         KL23Zzy5XncIFuZ7KqiqWv+gEnI1e+rd48Duqo/vKLTQf/Grcb/TRhiic14n+Yxr6V
         m2KVDPYv+5/GjAb6F4X3hfZZzN7/5UQ4ewvZexSoOC0zEaTIhXqKyrLU7aBRU7lJIX
         DvtcQU3/VuWlcXXhZ9xHhjHTMSEVkz87AMJyO6kU2O46XYQr1/nT3ArxUNXDBxZGjY
         DVBf/TEnNMCew==
Date:   Wed, 14 Apr 2021 16:25:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Joseph, Jithu" <jithu.joseph@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "dvorax.fuxbrumer@linux.intel.com" <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 8/9] igc: Enable RX via AF_XDP zero-copy
Message-ID: <20210414162500.397ddb7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fcd46fb09a08af36b7c34693f4e687d2c9ca2422.camel@intel.com>
References: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
        <20210409164351.188953-9-anthony.l.nguyen@intel.com>
        <20210409173604.217406b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fcd46fb09a08af36b7c34693f4e687d2c9ca2422.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 23:14:04 +0000 Joseph, Jithu wrote:
> > > +static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
> > > +					    struct xdp_buff *xdp)
> > > +{
> > > +	unsigned int metasize =3D xdp->data - xdp->data_meta;
> > > +	unsigned int datasize =3D xdp->data_end - xdp->data;
> > > +	struct sk_buff *skb;
> > > +
> > > +	skb =3D __napi_alloc_skb(&ring->q_vector->napi,
> > > +			       xdp->data_end - xdp->data_hard_start,
> > > +			       GFP_ATOMIC | __GFP_NOWARN);
> > > +	if (unlikely(!skb))
> > > +		return NULL;
> > > +
> > > +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> > > +	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
> > > +	if (metasize)
> > > +		skb_metadata_set(skb, metasize); =20
> >=20
> > But you haven't actually copied the matadata into the skb,
> > the metadata is before xdp->data, right? =20
>=20
> Today the igc driver doesn=E2=80=99t add any metadata (except for hw time
> stamps explained later) . So for most part, xdp->data and xdp-
> >data_meta point to the same address . That could be why in this =20
> initial implementation we are not copying  the metadata into skb (as
> the driver doesn=E2=80=99t add any). =20

I don't think the timestamp is supposed to be part of the metadata.
We're talking about BPF metadata here (added by the XDP prog).

> If the XDP program adds some metadata before xdp->data (and  xdp-
> >data_meta reflects this), that is NOT copied into the SKB as you =20
> mentioned .   Is the expectation that meta_data (if any added by the
> bpf program) , should also be copied to the skb  in this XDP_PASS flow
> ? If so I can revise this patch to do that.=20

Yes, I believe so.

> If h/w time-stamp is added by the NIC, then metasize will be non zero
> (as  xdp->data is advanced by the driver ) .  h/w ts  is still copied
> into "skb_hwtstamps(skb)->hwtstamp" by  the caller of this function
> igc_dispatch_skb_zc()  . Do you still want it to be copied into
> __skb_put(skb, ) area too ?=20

If TS is prepended to the frame it should be saved (e.g. on the stack)
before XDP program is called and gets the chance to overwrite it. The
metadata length when XDP program is called should be 0.

> > > +	return skb;
> > > +}
> > > +static int igc_xdp_enable_pool(struct igc_adapter *adapter,
> > > +			       struct xsk_buff_pool *pool, u16
> > > queue_id)
> > > +{
> > > +	struct net_device *ndev =3D adapter->netdev;
> > > +	struct device *dev =3D &adapter->pdev->dev;
> > > +	struct igc_ring *rx_ring;
> > > +	struct napi_struct *napi;
> > > +	bool needs_reset;
> > > +	u32 frame_size;
> > > +	int err;
> > > +
> > > +	if (queue_id >=3D adapter->num_rx_queues)
> > > +		return -EINVAL;
> > > +
> > > +	frame_size =3D xsk_pool_get_rx_frame_size(pool);
> > > +	if (frame_size < ETH_FRAME_LEN + VLAN_HLEN * 2) {
> > > +		/* When XDP is enabled, the driver doesn't support
> > > frames that
> > > +		 * span over multiple buffers. To avoid that, we check
> > > if xsk
> > > +		 * frame size is big enough to fit the max ethernet
> > > frame size
> > > +		 * + vlan double tagging.
> > > +		 */
> > > +		return -EOPNOTSUPP;
> > > +	}
> > > +
> > > +	err =3D xsk_pool_dma_map(pool, dev, IGC_RX_DMA_ATTR);
> > > +	if (err) {
> > > +		netdev_err(ndev, "Failed to map xsk pool\n");
> > > +		return err;
> > > +	}
> > > +
> > > +	needs_reset =3D netif_running(adapter->netdev) &&
> > > igc_xdp_is_enabled(adapter);
> > > +
> > > +	rx_ring =3D adapter->rx_ring[queue_id];
> > > +	napi =3D &rx_ring->q_vector->napi;
> > > +
> > > +	if (needs_reset) {
> > > +		igc_disable_rx_ring(rx_ring);
> > > +		napi_disable(napi);
> > > +	}
> > > +
> > > +	set_bit(IGC_RING_FLAG_AF_XDP_ZC, &rx_ring->flags);
> > > +
> > > +	if (needs_reset) {
> > > +		napi_enable(napi);
> > > +		igc_enable_rx_ring(rx_ring);
> > > +
> > > +		err =3D igc_xsk_wakeup(ndev, queue_id, XDP_WAKEUP_RX);
> > > +		if (err)
> > > +			return err; =20
> >=20
> > No need for an unwind path here?
> > Does something call XDP_SETUP_XSK_POOL(NULL) on failure
> > automagically? =20
>=20
> I think we should add a xsk_pool_dma_unmap() in this failure path
> ?  Did I understand you correctly ?

Sounds right.
