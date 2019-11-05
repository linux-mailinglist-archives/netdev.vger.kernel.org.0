Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E16AEFD4A
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 13:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388269AbfKEMhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 07:37:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33006 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388737AbfKEMhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 07:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572957458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x6KI9PpjHZx6M6nWMCiFeXnX4qEvxQI17oewQBy9jgU=;
        b=AAWobPbgjDjh9DqO4/QHsyR5WbeYchHLhHqRBdqPudKfajGpb5edC/D8dDjjwRYPJ0Y2G9
        9d1Rja3p8kfmCWBWvrjCAlRxgNIUuTlO6bR0H+O5Pa23Z1sPyYt/+dYNbv2+/1GfE48aFn
        QPvSas8Af2cmu4onCiWeOL/ptD7KueU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-w3OBhxaiOmC5kvE_e33cZQ-1; Tue, 05 Nov 2019 07:37:34 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D06A477;
        Tue,  5 Nov 2019 12:37:33 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA5835D9CD;
        Tue,  5 Nov 2019 12:37:24 +0000 (UTC)
Date:   Tue, 5 Nov 2019 13:37:23 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     brouer@redhat.com, davem@davemloft.net,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v2 9/9] ice: allow 3k MTU for XDP
Message-ID: <20191105133723.5dbe6aa0@carbon>
In-Reply-To: <20191104215125.16745-10-jeffrey.t.kirsher@intel.com>
References: <20191104215125.16745-1-jeffrey.t.kirsher@intel.com>
        <20191104215125.16745-10-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: w3OBhxaiOmC5kvE_e33cZQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Nov 2019 13:51:25 -0800
Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:

> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>=20
> At this point ice driver is able to work on order 1 pages that are split
> onto two 3k buffers. Let's reflect that when user is setting new MTU
> size and XDP is present on interface.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethe=
rnet/intel/ice/ice_main.c
> index 29eea08807fd..363b284e8aa1 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -4658,6 +4658,18 @@ static void ice_rebuild(struct ice_pf *pf, enum ic=
e_reset_req reset_type)
>  =09dev_err(dev, "Rebuild failed, unload and reload driver\n");
>  }
> =20
> +/**
> + * ice_max_xdp_frame_size - returns the maximum allowed frame size for X=
DP
> + * @vsi: Pointer to VSI structure
> + */
> +static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
> +{
> +=09if (PAGE_SIZE >=3D 8192 || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->fl=
ags))
> +=09=09return ICE_RXBUF_2048 - XDP_PACKET_HEADROOM;

I've not checked the details of the ICE drivers memory model, are you
using a split-page model?

If so, in case of ICE_FLAG_LEGACY_RX and PAGE_SIZE=3D=3D4096, then other
Intel drivers use headroom size 192 bytes and not
XDP_PACKET_HEADROOM=3D256, because it doesn't fit with split-page model.

Asked in another way: Have you taking into account the 320 bytes needed
by skb_shared_info ?


> +=09else
> +=09=09return ICE_RXBUF_3072;
> +}
> +
>  /**
>   * ice_change_mtu - NDO callback to change the MTU
>   * @netdev: network interface device structure
> @@ -4678,11 +4690,11 @@ static int ice_change_mtu(struct net_device *netd=
ev, int new_mtu)
>  =09}
> =20
>  =09if (ice_is_xdp_ena_vsi(vsi)) {
> -=09=09int frame_size =3D ICE_RXBUF_2048 - XDP_PACKET_HEADROOM;
> +=09=09int frame_size =3D ice_max_xdp_frame_size(vsi);
> =20
>  =09=09if (new_mtu + ICE_ETH_PKT_HDR_PAD > frame_size) {
>  =09=09=09netdev_err(netdev, "max MTU for XDP usage is %d\n",
> -=09=09=09=09   frame_size);
> +=09=09=09=09   frame_size - ICE_ETH_PKT_HDR_PAD);
>  =09=09=09return -EINVAL;
>  =09=09}
>  =09}



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

