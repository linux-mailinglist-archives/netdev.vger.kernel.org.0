Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F36330AEE
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 11:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhCHKPX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Mar 2021 05:15:23 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:29866 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231942AbhCHKPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 05:15:05 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-110-PpHoh6FVONySBAbh2ICMKA-1; Mon, 08 Mar 2021 10:13:58 +0000
X-MC-Unique: PpHoh6FVONySBAbh2ICMKA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Mar 2021 10:13:56 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Mar 2021 10:13:56 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 5/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum trailer
Thread-Topic: [PATCH net-next v2 5/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum trailer
Thread-Index: AQHXEjcvEK7MzxmURkq987v/iEpZqap54riQ
Date:   Mon, 8 Mar 2021 10:13:56 +0000
Message-ID: <ebe1bf51902e49458cfdd685790c4350@AcuMS.aculab.com>
References: <20210306031550.26530-1-elder@linaro.org>
 <20210306031550.26530-6-elder@linaro.org>
In-Reply-To: <20210306031550.26530-6-elder@linaro.org>
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
> Replace the use of C bit-fields in the rmnet_map_dl_csum_trailer
> structure with a single one-byte field, using constant field masks
> to encode or get at embedded values.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c    |  2 +-
>  include/linux/if_rmnet.h                        | 17 +++++++----------
>  2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index 3291f252d81b0..29d485b868a65 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -365,7 +365,7 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
> 
>  	csum_trailer = (struct rmnet_map_dl_csum_trailer *)(skb->data + len);
> 
> -	if (!csum_trailer->valid) {
> +	if (!u8_get_bits(csum_trailer->flags, MAP_CSUM_DL_VALID_FMASK)) {

Is that just an overcomplicated way of saying:
	if (!(csum_trailer->flags & MAP_CSUM_DL_VALID_FMASK)) {

    David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

