Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9D1330AFE
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 11:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhCHKUP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Mar 2021 05:20:15 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:46197 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231128AbhCHKUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 05:20:02 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2021 05:20:01 EST
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-134-G7sto4gPP-KccM4BdtnMIA-1; Mon, 08 Mar 2021 10:18:42 +0000
X-MC-Unique: G7sto4gPP-KccM4BdtnMIA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Mar 2021 10:18:40 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Mar 2021 10:18:40 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alex Elder' <elder@linaro.org>,
        "subashab@codeaurora.org" <subashab@codeaurora.org>,
        "stranche@codeaurora.org" <stranche@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "sharathv@codeaurora.org" <sharathv@codeaurora.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "cpratapa@codeaurora.org" <cpratapa@codeaurora.org>,
        "elder@kernel.org" <elder@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel test robot" <lkp@intel.com>
Subject: RE: [PATCH net-next v2 6/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum header
Thread-Topic: [PATCH net-next v2 6/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum header
Thread-Index: AQHXEjc7/Zo1a5kRlEyGQ6znWO97Lap545RA
Date:   Mon, 8 Mar 2021 10:18:40 +0000
Message-ID: <498c301f517749fdbc9d3ff5529d71a6@AcuMS.aculab.com>
References: <20210306031550.26530-1-elder@linaro.org>
 <20210306031550.26530-7-elder@linaro.org>
In-Reply-To: <20210306031550.26530-7-elder@linaro.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder
> Sent: 06 March 2021 03:16
> 
> Replace the use of C bit-fields in the rmnet_map_ul_csum_header
> structure with a single two-byte (big endian) structure member,
> and use field masks to encode or get values within it.
> 
> Previously rmnet_map_ipv4_ul_csum_header() would update values in
> the host byte-order fields, and then forcibly fix their byte order
> using a combination of byte order operations and types.
> 
> Instead, just compute the value that needs to go into the new
> structure member and save it with a simple byte-order conversion.
> 
> Make similar simplifications in rmnet_map_ipv6_ul_csum_header().
> 
> Finally, in rmnet_map_checksum_uplink_packet() a set of assignments
> zeroes every field in the upload checksum header.  Replace that with
> a single memset() operation.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
> v2: Fixed to use u16_encode_bits() instead of be16_encode_bits().
> 
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 34 ++++++-------------
>  include/linux/if_rmnet.h                      | 21 ++++++------
>  2 files changed, 21 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index 29d485b868a65..b76ad48da7325 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -198,23 +198,19 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
>  			      struct rmnet_map_ul_csum_header *ul_header,
>  			      struct sk_buff *skb)
>  {
> -	__be16 *hdr = (__be16 *)ul_header;
>  	struct iphdr *ip4h = iphdr;
>  	u16 offset;
> +	u16 val;
> 
>  	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
>  	ul_header->csum_start_offset = htons(offset);
> 
> -	ul_header->csum_insert_offset = skb->csum_offset;
> -	ul_header->csum_enabled = 1;
> +	val = u16_encode_bits(1, MAP_CSUM_UL_ENABLED_FMASK);
>  	if (ip4h->protocol == IPPROTO_UDP)
> -		ul_header->udp_ind = 1;
> -	else
> -		ul_header->udp_ind = 0;
> +		val |= u16_encode_bits(1, MAP_CSUM_UL_UDP_FMASK);
> +	val |= u16_encode_bits(skb->csum_offset, MAP_CSUM_UL_OFFSET_FMASK);
> 
> -	/* Changing remaining fields to network order */
> -	hdr++;
> -	*hdr = htons((__force u16)*hdr);
> +	ul_header->csum_info = htons(val);

Isn't this potentially misaligned?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

