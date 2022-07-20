Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C456957B22F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiGTH5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiGTH5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:57:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554B361D49
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B327ACE1F1D
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC13C3411E;
        Wed, 20 Jul 2022 07:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658303842;
        bh=lJd2pJsTUAviNZFn2BNPNto23mng5LT4ShegvNxXB3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBlynrDyHaXid4Vcm2L+OS52ZTiU2TiNihQrfqsVZfPieY7Mc37xRHQeK60KYwlLX
         m8t3I6yv9Xmb9eg7F1g/avGmtFY2mWvcR1qe3+P73yc3zsL1O7swuG7Ffq4Qp0dvtv
         vlEJ7Cwji5DpOIXXf6awRHxH01vciAjvU8wX2rW+7Kb0tyGn/wS4aL+s/9+TwZOFO/
         meRQOMwoeipyo8Co6ouWrll1Zlriz7mzyLizUpx78uqFtZFB66TsdyB97GMVnPPw2X
         fD1p4oaEImu0Po+s/tjs8UhGso2wite3/i4YuCMFIkvlF8D2A+ij2vJA3pZZwDfWIi
         7ZSjFcSb4bojg==
Date:   Wed, 20 Jul 2022 09:57:17 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, jbrouer@redhat.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, magnus.karlsson@intel.com,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "naamax.meir" <naamax.meir@linux.intel.com>,
        "Edri, Michael" <michael.edri@intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next] igc: add xdp frags support to
 ndo_xdp_xmit
Message-ID: <Yte1XYf5l+RTvo2r@localhost.localdomain>
References: <d8e3744f060ee11d5069bfd0f581f02d0ecb5e08.1657093744.git.lorenzo@kernel.org>
 <34a8720b-47f8-5aa6-3953-a0c82915d188@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PYYAZk//73REXw05"
Content-Disposition: inline
In-Reply-To: <34a8720b-47f8-5aa6-3953-a0c82915d188@intel.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PYYAZk//73REXw05
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 7/6/2022 10:54, Lorenzo Bianconi wrote:
> > Add the capability to map non-linear xdp frames in XDP_TX and
> > ndo_xdp_xmit callback.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > Please note this patch is only compiled tested since I do not have
> > access to a igc NIC
> > ---
> >   drivers/net/ethernet/intel/igc/igc_main.c | 128 ++++++++++++++--------
> >   1 file changed, 83 insertions(+), 45 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/et=
hernet/intel/igc/igc_main.c
> > index ae17af44fe02..71657d03da03 100644
> > --- a/drivers/net/ethernet/intel/igc/igc_main.c
> > +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> > @@ -2129,65 +2129,102 @@ static bool igc_alloc_rx_buffers_zc(struct igc=
_ring *ring, u16 count)
> >   	return ok;
> >   }
> > -static int igc_xdp_init_tx_buffer(struct igc_tx_buffer *buffer,
> > -				  struct xdp_frame *xdpf,
> > -				  struct igc_ring *ring)
> > -{
> > -	dma_addr_t dma;
> > -
> > -	dma =3D dma_map_single(ring->dev, xdpf->data, xdpf->len, DMA_TO_DEVIC=
E);
> > -	if (dma_mapping_error(ring->dev, dma)) {
> > -		netdev_err_once(ring->netdev, "Failed to map DMA for TX\n");
> > -		return -ENOMEM;
> > -	}
> > -
> > -	buffer->type =3D IGC_TX_BUFFER_TYPE_XDP;
> > -	buffer->xdpf =3D xdpf;
> > -	buffer->protocol =3D 0;
> > -	buffer->bytecount =3D xdpf->len;
> > -	buffer->gso_segs =3D 1;
> > -	buffer->time_stamp =3D jiffies;
> > -	dma_unmap_len_set(buffer, len, xdpf->len);
> > -	dma_unmap_addr_set(buffer, dma, dma);
> > -	return 0;
> > -}
> > -
> >   /* This function requires __netif_tx_lock is held by the caller. */
> >   static int igc_xdp_init_tx_descriptor(struct igc_ring *ring,
> >   				      struct xdp_frame *xdpf)
> >   {
> > -	struct igc_tx_buffer *buffer;
> > -	union igc_adv_tx_desc *desc;
> > -	u32 cmd_type, olinfo_status;
> > -	int err;
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_frame(xdpf=
);
> > +	u8 nr_frags =3D unlikely(xdp_frame_has_frags(xdpf)) ? sinfo->nr_frags=
 : 0;
> > +	u16 count, index =3D ring->next_to_use;
> > +	struct igc_tx_buffer *head =3D &ring->tx_buffer_info[index];
> > +	struct igc_tx_buffer *buffer =3D head;
> > +	union igc_adv_tx_desc *desc =3D IGC_TX_DESC(ring, index);
> > +	u32 olinfo_status, len =3D xdpf->len, cmd_type;
> > +	void *data =3D xdpf->data;
> > +	u16 i;
> > -	if (!igc_desc_unused(ring))
> > -		return -EBUSY;
> > +	count =3D TXD_USE_COUNT(len);
> > +	for (i =3D 0; i < nr_frags; i++)
> > +		count +=3D TXD_USE_COUNT(skb_frag_size(&sinfo->frags[i]));
> > -	buffer =3D &ring->tx_buffer_info[ring->next_to_use];
> > -	err =3D igc_xdp_init_tx_buffer(buffer, xdpf, ring);
> > -	if (err)
> > -		return err;
> > +	if (igc_maybe_stop_tx(ring, count + 3)) {
> > +		/* this is a hard error */
> > +		return -EBUSY;
> > +	}
> > -	cmd_type =3D IGC_ADVTXD_DTYP_DATA | IGC_ADVTXD_DCMD_DEXT |
> > -		   IGC_ADVTXD_DCMD_IFCS | IGC_TXD_DCMD |
> > -		   buffer->bytecount;
> > -	olinfo_status =3D buffer->bytecount << IGC_ADVTXD_PAYLEN_SHIFT;
> > +	i =3D 0;
> > +	head->bytecount =3D xdp_get_frame_len(xdpf);
> > +	head->type =3D IGC_TX_BUFFER_TYPE_XDP;
> > +	head->gso_segs =3D 1;
> > +	head->xdpf =3D xdpf;
> > -	desc =3D IGC_TX_DESC(ring, ring->next_to_use);
> > -	desc->read.cmd_type_len =3D cpu_to_le32(cmd_type);
> > +	olinfo_status =3D head->bytecount << IGC_ADVTXD_PAYLEN_SHIFT;
> >   	desc->read.olinfo_status =3D cpu_to_le32(olinfo_status);
> > -	desc->read.buffer_addr =3D cpu_to_le64(dma_unmap_addr(buffer, dma));
> > -	netdev_tx_sent_queue(txring_txq(ring), buffer->bytecount);
> > +	for (;;) {
> > +		dma_addr_t dma;
> > -	buffer->next_to_watch =3D desc;
> > +		dma =3D dma_map_single(ring->dev, data, len, DMA_TO_DEVICE);
> > +		if (dma_mapping_error(ring->dev, dma)) {
> > +			netdev_err_once(ring->netdev,
> > +					"Failed to map DMA for TX\n");
> > +			goto unmap;
> > +		}
> > -	ring->next_to_use++;
> > -	if (ring->next_to_use =3D=3D ring->count)
> > -		ring->next_to_use =3D 0;
> > +		dma_unmap_len_set(buffer, len, len);
> > +		dma_unmap_addr_set(buffer, dma, dma);
> > +
> > +		cmd_type =3D IGC_ADVTXD_DTYP_DATA | IGC_ADVTXD_DCMD_DEXT |
> > +			   IGC_ADVTXD_DCMD_IFCS | len;
> > +
> > +		desc->read.cmd_type_len =3D cpu_to_le32(cmd_type);
> > +		desc->read.buffer_addr =3D cpu_to_le64(dma);
> > +
> > +		buffer->protocol =3D 0;
> > +
> > +		if (++index =3D=3D ring->count)
> > +			index =3D 0;
> > +
> > +		if (i =3D=3D nr_frags)
> > +			break;
> > +
> > +		buffer =3D &ring->tx_buffer_info[index];
> > +		desc =3D IGC_TX_DESC(ring, index);
> > +		desc->read.olinfo_status =3D 0;
> > +
> > +		data =3D skb_frag_address(&sinfo->frags[i]);
> > +		len =3D skb_frag_size(&sinfo->frags[i]);
> > +		i++;
> > +	}
> > +	desc->read.cmd_type_len |=3D cpu_to_le32(IGC_TXD_DCMD);
> > +
> > +	netdev_tx_sent_queue(txring_txq(ring), head->bytecount);
> > +	/* set the timestamp */
> > +	head->time_stamp =3D jiffies;
> > +	/* set next_to_watch value indicating a packet is present */
> > +	head->next_to_watch =3D desc;
> > +	ring->next_to_use =3D index;
> >   	return 0;
> > +
> > +unmap:
> > +	for (;;) {
> > +		buffer =3D &ring->tx_buffer_info[index];
> > +		if (dma_unmap_len(buffer, len))
> > +			dma_unmap_page(ring->dev,
> > +				       dma_unmap_addr(buffer, dma),
> > +				       dma_unmap_len(buffer, len),
> > +				       DMA_TO_DEVICE);
> > +		dma_unmap_len_set(buffer, len, 0);
> > +		if (buffer =3D=3D head)
> > +			break;
> > +
> > +		if (!index)
> > +			index +=3D ring->count;
> > +		index--;
> > +	}
> > +
> > +	return -ENOMEM;
> >   }
> >   static struct igc_ring *igc_xdp_get_tx_ring(struct igc_adapter *adapt=
er,
> > @@ -2369,6 +2406,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *=
q_vector, const int budget)
> >   			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
> >   					 igc_rx_offset(rx_ring) + pkt_offset,
> >   					 size, true);
> > +			xdp_buff_clear_frags_flag(&xdp);
> >   			skb =3D igc_xdp_run_prog(adapter, &xdp);
> >   		}
> Hello Lorenzo,
> Could you provide test hints (step by step) on how to test it?
> Sasha

Hi Sasha,

I guess you can just run the script I shared, does it work?

Regards,
Lorenzo

--PYYAZk//73REXw05
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYte1WgAKCRA6cBh0uS2t
rHdpAP42Hdw4w+wcvajq5O6OsXdMT48vLEWEx9VB5B/zzorcgwD/eJbRHu7UAQab
CspfK/6iAK1v947xkQUCc+WEh8q2YQs=
=lE59
-----END PGP SIGNATURE-----

--PYYAZk//73REXw05--
