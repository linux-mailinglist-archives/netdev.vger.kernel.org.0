Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC870EB847
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbfJaUNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:13:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36380 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726741AbfJaUNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572552790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bmrr9J44Hc2sIUrtk+1QLooktya8ZditAG9mjiHvs2E=;
        b=B01hHszZh8NaDyiyyJK1CRKkKrOPycpb8HQPgSUynK6wi1kZQr/a6w+cvPxzFg6Dlrfzm3
        DhJZk1o8B3UhOqVE/Asztpm3LXLwzSsHSlFAvzFYOghLzzg/hpwF724x0nfVr41DhKtddq
        80cGqe1s2oShY1tFV4BrGJrm2CGHoIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-9sWlrh9vOyGs9lE3Tf-Crg-1; Thu, 31 Oct 2019 16:13:07 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0F8F8017E0;
        Thu, 31 Oct 2019 20:13:06 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25E8A19C7F;
        Thu, 31 Oct 2019 20:13:01 +0000 (UTC)
Date:   Thu, 31 Oct 2019 21:13:00 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v4 6/6] sfc: add XDP counters to ethtool stats
Message-ID: <20191031211300.7e5c1e7c@carbon>
In-Reply-To: <1d36bf21-f9d0-c464-1886-ef4ac1ed7557@solarflare.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
        <1d36bf21-f9d0-c464-1886-ef4ac1ed7557@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 9sWlrh9vOyGs9lE3Tf-Crg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 10:24:23 +0000
Charles McLachlan <cmclachlan@solarflare.com> wrote:

> Count XDP packet drops, error drops, transmissions and redirects and
> expose these counters via the ethtool stats command.
>=20
> Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>

I'm going to ACK this even-though I don't like these driver specific
counters.  Given we have failed to standardize this, I really cannot
complain.  Hopefully we will get this standardized later

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Left code below, if Ahern want to complain ;-)

>  drivers/net/ethernet/sfc/ethtool.c    | 25 +++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/net_driver.h |  8 ++++++++
>  drivers/net/ethernet/sfc/rx.c         |  9 +++++++++
>  3 files changed, 42 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sf=
c/ethtool.c
> index 86b965875540..8db593fb9699 100644
> --- a/drivers/net/ethernet/sfc/ethtool.c
> +++ b/drivers/net/ethernet/sfc/ethtool.c
> @@ -83,6 +83,10 @@ static const struct efx_sw_stat_desc efx_sw_stat_desc[=
] =3D {
>  =09EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_frm_trunc),
>  =09EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_merge_events),
>  =09EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_merge_packets),
> +=09EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_drops),
> +=09EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_bad_drops),
> +=09EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_tx),
> +=09EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_redirect),
>  };
> =20
>  #define EFX_ETHTOOL_SW_STAT_COUNT ARRAY_SIZE(efx_sw_stat_desc)
> @@ -399,6 +403,19 @@ static size_t efx_describe_per_queue_stats(struct ef=
x_nic *efx, u8 *strings)
>  =09=09=09}
>  =09=09}
>  =09}
> +=09if (efx->xdp_tx_queue_count && efx->xdp_tx_queues) {
> +=09=09unsigned short xdp;
> +
> +=09=09for (xdp =3D 0; xdp < efx->xdp_tx_queue_count; xdp++) {
> +=09=09=09n_stats++;
> +=09=09=09if (strings) {
> +=09=09=09=09snprintf(strings, ETH_GSTRING_LEN,
> +=09=09=09=09=09 "tx-xdp-cpu-%hu.tx_packets", xdp);
> +=09=09=09=09strings +=3D ETH_GSTRING_LEN;
> +=09=09=09}
> +=09=09}
> +=09}
> +
>  =09return n_stats;
>  }
> =20
> @@ -509,6 +526,14 @@ static void efx_ethtool_get_stats(struct net_device =
*net_dev,
>  =09=09=09data++;
>  =09=09}
>  =09}
> +=09if (efx->xdp_tx_queue_count && efx->xdp_tx_queues) {
> +=09=09int xdp;
> +
> +=09=09for (xdp =3D 0; xdp < efx->xdp_tx_queue_count; xdp++) {
> +=09=09=09data[0] =3D efx->xdp_tx_queues[xdp]->tx_packets;
> +=09=09=09data++;
> +=09=09}
> +=09}
> =20
>  =09efx_ptp_update_stats(efx, data);
>  }
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet=
/sfc/net_driver.h
> index 505ddc060e64..04e49eac7327 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -453,6 +453,10 @@ enum efx_sync_events_state {
>   *=09lack of descriptors
>   * @n_rx_merge_events: Number of RX merged completion events
>   * @n_rx_merge_packets: Number of RX packets completed by merged events
> + * @n_rx_xdp_drops: Count of RX packets intentionally dropped due to XDP
> + * @n_rx_xdp_bad_drops: Count of RX packets dropped due to XDP errors
> + * @n_rx_xdp_tx: Count of RX packets retransmitted due to XDP
> + * @n_rx_xdp_redirect: Count of RX packets redirected to a different NIC=
 by XDP
>   * @rx_pkt_n_frags: Number of fragments in next packet to be delivered b=
y
>   *=09__efx_rx_packet(), or zero if there is none
>   * @rx_pkt_index: Ring index of first buffer for next packet to be deliv=
ered
> @@ -506,6 +510,10 @@ struct efx_channel {
>  =09unsigned int n_rx_nodesc_trunc;
>  =09unsigned int n_rx_merge_events;
>  =09unsigned int n_rx_merge_packets;
> +=09unsigned int n_rx_xdp_drops;
> +=09unsigned int n_rx_xdp_bad_drops;
> +=09unsigned int n_rx_xdp_tx;
> +=09unsigned int n_rx_xdp_redirect;
> =20
>  =09unsigned int rx_pkt_n_frags;
>  =09unsigned int rx_pkt_index;
> diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.=
c
> index 91f6d5b9ceac..a7d9841105d8 100644
> --- a/drivers/net/ethernet/sfc/rx.c
> +++ b/drivers/net/ethernet/sfc/rx.c
> @@ -677,6 +677,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct ef=
x_channel *channel,
>  =09=09=09netif_err(efx, rx_err, efx->net_dev,
>  =09=09=09=09  "XDP is not possible with multiple receive fragments (%d)\=
n",
>  =09=09=09=09  channel->rx_pkt_n_frags);
> +=09=09channel->n_rx_xdp_bad_drops++;
>  =09=09return false;
>  =09}
> =20
> @@ -722,6 +723,9 @@ static bool efx_do_xdp(struct efx_nic *efx, struct ef=
x_channel *channel,
>  =09=09=09if (net_ratelimit())
>  =09=09=09=09netif_err(efx, rx_err, efx->net_dev,
>  =09=09=09=09=09  "XDP TX failed (%d)\n", err);
> +=09=09=09channel->n_rx_xdp_bad_drops++;
> +=09=09} else {
> +=09=09=09channel->n_rx_xdp_tx++;
>  =09=09}
>  =09=09break;
> =20
> @@ -732,12 +736,16 @@ static bool efx_do_xdp(struct efx_nic *efx, struct =
efx_channel *channel,
>  =09=09=09if (net_ratelimit())
>  =09=09=09=09netif_err(efx, rx_err, efx->net_dev,
>  =09=09=09=09=09  "XDP redirect failed (%d)\n", err);
> +=09=09=09channel->n_rx_xdp_bad_drops++;
> +=09=09} else {
> +=09=09=09channel->n_rx_xdp_redirect++;
>  =09=09}
>  =09=09break;
> =20
>  =09default:
>  =09=09bpf_warn_invalid_xdp_action(xdp_act);
>  =09=09efx_free_rx_buffers(rx_queue, rx_buf, 1);
> +=09=09channel->n_rx_xdp_bad_drops++;
>  =09=09break;
> =20
>  =09case XDP_ABORTED:
> @@ -745,6 +753,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct ef=
x_channel *channel,
>  =09=09/* Fall through */
>  =09case XDP_DROP:
>  =09=09efx_free_rx_buffers(rx_queue, rx_buf, 1);
> +=09=09channel->n_rx_xdp_drops++;
>  =09=09break;
>  =09}
> =20



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

