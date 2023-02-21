Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5D369DF0E
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbjBULkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbjBULkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:40:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3692693F9
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676979579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5OAU4IRwSccFaTfTbhJfWFHAd4qx5D6vbydzjPOhVbc=;
        b=XYLkts8vEeX9VncdgM0FkWtUtt9wH9xipjBOwPh6J/nUkxUzfZIvGbzAuTjJ6V7/Qdwvlx
        YjkmVwfjJbLDcrLPwSmJRJZYk6bMfmGewN60vwuHy7hRLX0VLMtvXI9jQSBlyzNAwPLIid
        j3lbSGRZsq2RoelRnhNga26FsxvIJh4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-V0AxJ9QRN9OgfsWTKNWE8A-1; Tue, 21 Feb 2023 06:39:36 -0500
X-MC-Unique: V0AxJ9QRN9OgfsWTKNWE8A-1
Received: by mail-wm1-f70.google.com with SMTP id p22-20020a7bcc96000000b003e2036a1516so1893484wma.7
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:39:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676979575;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5OAU4IRwSccFaTfTbhJfWFHAd4qx5D6vbydzjPOhVbc=;
        b=Q3BRA2snBvMbxxdFA2zbA0yh0fsSDYtI5j/PiAfJZ46mWCo04rkOQOcW6U1tiGg1Sv
         MMAG35MxCLnNgFjQxRCDTFjw3p364vAesz+cPX/UlFGCcQ1qab1SLyXzR7jcf5OlozAw
         trBLUuzz9Lyv4YbW2lShql8wWSCvFlwey759++fio3jPC9UWp53hqKgiTYwPeTKyQ5qo
         cZ0CPVyobrylRNLiMPZ69j+RUDC7j+ZrYlEgwa3vVHbURgnSI3KIF2/o42wpUiGdP9Cl
         fRRsdKVmh2/F1p56RWfRlc8E1cBnoBZUYnPAHqNLDzkMaEkh2Z8wGXKulaDgeGSBTcu9
         itIQ==
X-Gm-Message-State: AO0yUKW2HnMjT+1VxZ4/M+ELVr33WrfEACmjo+qKo7Q+pSBJBGVHntVE
        rDMryDB0lLrz2RET+If5E58VDwo4m2FZDnq9B2634G9yF7+VFu9wfFPKw13pxNJ3LrK8B61KuFD
        NjE8l7Zbnw45AVYvT
X-Received: by 2002:a05:600c:4591:b0:3db:35e3:baf6 with SMTP id r17-20020a05600c459100b003db35e3baf6mr3911038wmo.4.1676979575089;
        Tue, 21 Feb 2023 03:39:35 -0800 (PST)
X-Google-Smtp-Source: AK7set+6hDRFKuK3Wd1zIqxXUkOnGEuvB4T0UyPLZC1a+QQIQsvl/35JR49aG8/tAkU3Uj3LGK45xQ==
X-Received: by 2002:a05:600c:4591:b0:3db:35e3:baf6 with SMTP id r17-20020a05600c459100b003db35e3baf6mr3911026wmo.4.1676979574785;
        Tue, 21 Feb 2023 03:39:34 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id 15-20020a05600c020f00b003dfe5190376sm3398688wmi.35.2023.02.21.03.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 03:39:34 -0800 (PST)
Message-ID: <45b7c6a169dda4fab7e24a2a7e1b731dca1d9c0c.camel@redhat.com>
Subject: Re: [net PATCH] octeontx2-pf: Recalculate UDP checksum for ptp
 1-step sync packet
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sai Krishna <saikrishnag@marvell.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com
Cc:     Hariprasad Kelam <hkelam@marvell.com>
Date:   Tue, 21 Feb 2023 12:39:32 +0100
In-Reply-To: <20230220122050.1639299-1-saikrishnag@marvell.com>
References: <20230220122050.1639299-1-saikrishnag@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-02-20 at 17:50 +0530, Sai Krishna wrote:
> From: Geetha sowjanya <gakula@marvell.com>
>=20
> When checksum offload is disabled in the driver via ethtool,
> the PTP 1-step sync packets contain incorrect checksum, since
> the stack calculates the checksum before driver updates
> PTP timestamp field in the packet. This results in PTP packets
> getting dropped at the other end. This patch fixes the issue by
> re-calculating the UDP checksum after updating PTP
> timestamp field in the driver.
>=20
> Fixes: 2958d17a8984 ("octeontx2-pf: Add support for ptp 1-step mode on CN=
10K silicon")
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> ---
>  .../marvell/octeontx2/nic/otx2_txrx.c         | 78 ++++++++++++++-----
>  1 file changed, 59 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/dri=
vers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index ef10aef3cda0..67345a3e2bba 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -10,6 +10,7 @@
>  #include <net/tso.h>
>  #include <linux/bpf.h>
>  #include <linux/bpf_trace.h>
> +#include <net/ip6_checksum.h>
> =20
>  #include "otx2_reg.h"
>  #include "otx2_common.h"
> @@ -699,7 +700,7 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, s=
truct otx2_snd_queue *sq,
> =20
>  static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
>  			     int alg, u64 iova, int ptp_offset,
> -			     u64 base_ns, int udp_csum)
> +			     u64 base_ns, bool udp_csum_crt)
>  {
>  	struct nix_sqe_mem_s *mem;
> =20
> @@ -711,7 +712,7 @@ static void otx2_sqe_add_mem(struct otx2_snd_queue *s=
q, int *offset,
> =20
>  	if (ptp_offset) {
>  		mem->start_offset =3D ptp_offset;
> -		mem->udp_csum_crt =3D udp_csum;
> +		mem->udp_csum_crt =3D !!udp_csum_crt;
>  		mem->base_ns =3D base_ns;
>  		mem->step_type =3D 1;
>  	}
> @@ -986,10 +987,11 @@ static bool otx2_validate_network_transport(struct =
sk_buff *skb)
>  	return false;
>  }
> =20
> -static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, int *udp_=
csum)
> +static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, bool *udp=
_csum_crt)
>  {
>  	struct ethhdr *eth =3D (struct ethhdr *)(skb->data);
>  	u16 nix_offload_hlen =3D 0, inner_vhlen =3D 0;
> +	bool udp_hdr_present =3D false, is_sync;
>  	u8 *data =3D skb->data, *msgtype;
>  	__be16 proto =3D eth->h_proto;
>  	int network_depth =3D 0;
> @@ -1029,45 +1031,83 @@ static bool otx2_ptp_is_sync(struct sk_buff *skb,=
 int *offset, int *udp_csum)
>  		if (!otx2_validate_network_transport(skb))
>  			return false;
> =20
> -		*udp_csum =3D 1;
>  		*offset =3D nix_offload_hlen + skb_transport_offset(skb) +
>  			  sizeof(struct udphdr);
> +		udp_hdr_present =3D true;
> +
>  	}
> =20
>  	msgtype =3D data + *offset;
> -
>  	/* Check PTP messageId is SYNC or not */
> -	return (*msgtype & 0xf) =3D=3D 0;
> +	is_sync =3D  ((*msgtype & 0xf) =3D=3D 0) ? true : false;

the above could be:

	is_sync =3D !(*msgtype & 0xf);

possibly more readable.

> +	if (is_sync) {
> +		if (udp_hdr_present)
> +			*udp_csum_crt =3D true;

or:
		*udp_csum_crt =3D udp_hdr_present;

that will make the code more compact.

> +	} else {
> +		*offset =3D 0;
> +	}
> +
> +	return is_sync;
>  }
> =20
>  static void otx2_set_txtstamp(struct otx2_nic *pfvf, struct sk_buff *skb=
,
>  			      struct otx2_snd_queue *sq, int *offset)
>  {
> +	struct ethhdr	*eth =3D (struct ethhdr *)(skb->data);
>  	struct ptpv2_tstamp *origin_tstamp;
> -	int ptp_offset =3D 0, udp_csum =3D 0;
> +	bool udp_csum_crt =3D false;
> +	unsigned int udphoff;
>  	struct timespec64 ts;
> +	int ptp_offset =3D 0;
> +	__wsum skb_csum;
>  	u64 iova;
> =20
>  	if (unlikely(!skb_shinfo(skb)->gso_size &&
>  		     (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))) {
> -		if (unlikely(pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC)) {
> -			if (otx2_ptp_is_sync(skb, &ptp_offset, &udp_csum)) {
> -				origin_tstamp =3D (struct ptpv2_tstamp *)
> -						((u8 *)skb->data + ptp_offset +
> -						 PTP_SYNC_SEC_OFFSET);
> -				ts =3D ns_to_timespec64(pfvf->ptp->tstamp);
> -				origin_tstamp->seconds_msb =3D htons((ts.tv_sec >> 32) & 0xffff);
> -				origin_tstamp->seconds_lsb =3D htonl(ts.tv_sec & 0xffffffff);
> -				origin_tstamp->nanoseconds =3D htonl(ts.tv_nsec);
> -				/* Point to correction field in PTP packet */
> -				ptp_offset +=3D 8;
> +		if (unlikely(pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC &&
> +			     otx2_ptp_is_sync(skb, &ptp_offset, &udp_csum_crt))) {
> +			origin_tstamp =3D (struct ptpv2_tstamp *)
> +					((u8 *)skb->data + ptp_offset +
> +					 PTP_SYNC_SEC_OFFSET);
> +			ts =3D ns_to_timespec64(pfvf->ptp->tstamp);
> +			origin_tstamp->seconds_msb =3D htons((ts.tv_sec >> 32) & 0xffff);
> +			origin_tstamp->seconds_lsb =3D htonl(ts.tv_sec & 0xffffffff);
> +			origin_tstamp->nanoseconds =3D htonl(ts.tv_nsec);
> +			/* Point to correction field in PTP packet */
> +			ptp_offset +=3D 8;
> +
> +			/* When user disables hw checksum, stack calculates the csum,
> +			 * but it does not cover ptp timestamp which is added later.
> +			 * Recalculate the checksum manually considering the timestamp.
> +			 */
> +			if (udp_csum_crt) {
> +				struct udphdr *uh =3D udp_hdr(skb);
> +
> +				if (skb->ip_summed !=3D CHECKSUM_PARTIAL && uh->check !=3D 0) {
> +					udphoff =3D skb_transport_offset(skb);
> +					uh->check =3D 0;
> +					skb_csum =3D skb_checksum(skb, udphoff, skb->len - udphoff,
> +								0);
> +					if (ntohs(eth->h_proto) =3D=3D ETH_P_IPV6)
> +						uh->check =3D csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
> +									    &ipv6_hdr(skb)->daddr,
> +									    skb->len - udphoff,
> +									    ipv6_hdr(skb)->nexthdr,
> +									    skb_csum);
> +					else
> +						uh->check =3D csum_tcpudp_magic(ip_hdr(skb)->saddr,
> +									      ip_hdr(skb)->daddr,
> +									      skb->len - udphoff,
> +									      IPPROTO_UDP,
> +									      skb_csum);

Have you considered incremental csum updates instead? Possibly the code
could be simpler and likely faster - not sure if the latter part is
relevant in this case.

Cheers,

Paolo

