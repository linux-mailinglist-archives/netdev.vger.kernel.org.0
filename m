Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C90A5FC8F8
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 18:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJLQNr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Oct 2022 12:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJLQNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 12:13:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FB4E070A
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:13:45 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-268-WeWgrHtwPRGrwdN7bTB1vA-1; Wed, 12 Oct 2022 17:13:42 +0100
X-MC-Unique: WeWgrHtwPRGrwdN7bTB1vA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 12 Oct
 2022 17:13:40 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Wed, 12 Oct 2022 17:13:40 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sergei Antonov' <saproj@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH v2 net] net: ftmac100: do not reject packets bigger than
 1514
Thread-Topic: [PATCH v2 net] net: ftmac100: do not reject packets bigger than
 1514
Thread-Index: AQHY3lCWEiTFPZdxBkKncwnj941AIq4K6mqQ
Date:   Wed, 12 Oct 2022 16:13:40 +0000
Message-ID: <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
References: <20221012153737.128424-1-saproj@gmail.com>
In-Reply-To: <20221012153737.128424-1-saproj@gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_SBL_A autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Antonov
> Sent: 12 October 2022 16:38
> 
> Despite the datasheet [1] saying the controller should allow incoming
> packets of length >=1518, it only allows packets of length <=1514.

Shouldn't that be <=1518 and <1518 ??

Although traditionally it was 1514+crc.
An extra 4 byte header is now allowed.
There is also the usefulness of supporting full length frames
with a PPPoE header.

Whether it actually makes sense to round up the receive buffer
size and associated max frame length to 1536 (cache line aligned)
is another matter (probably 1534 for 4n+2 alignment).

> Since 1518 is a standard Ethernet maximum frame size, and it can
> easily be encountered (in SSH for example), fix this behavior:
> 
> * Set FTMAC100_MACCR_RX_FTL in the MAC Control Register.

What does that do?
Looks like it might cause 'Frame Too Long' packets be returned.
In which case should the code just have ignored it since
longer frames would be discarded completely??

> * Check for packet size > 1518 in ftmac100_rx_packet_error().
> 
> [1]
> https://bitbucket.org/Kasreyn/mkrom-uc7112lx/src/master/documents/FIC8120_DS_v1.2.pdf
> 
> Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> ---
> 
> v1 -> v2:
> * Typos in description fixed.
> 
>  drivers/net/ethernet/faraday/ftmac100.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
> index d95d78230828..34d0284079ff 100644
> --- a/drivers/net/ethernet/faraday/ftmac100.c
> +++ b/drivers/net/ethernet/faraday/ftmac100.c
> @@ -154,6 +154,7 @@ static void ftmac100_set_mac(struct ftmac100 *priv, const unsigned char *mac)
>  				 FTMAC100_MACCR_CRC_APD	| \
>  				 FTMAC100_MACCR_FULLDUP	| \
>  				 FTMAC100_MACCR_RX_RUNT	| \
> +				 FTMAC100_MACCR_RX_FTL	| \
>  				 FTMAC100_MACCR_RX_BROADPKT)
> 
>  static int ftmac100_start_hw(struct ftmac100 *priv)
> @@ -320,6 +321,7 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
>  {
>  	struct net_device *netdev = priv->netdev;
>  	bool error = false;
> +	const unsigned int length = ftmac100_rxdes_frame_length(rxdes);

Do you need to read this value this early in the function?
Looks like it is only used when overlong packets are reported.

	David

> 
>  	if (unlikely(ftmac100_rxdes_rx_error(rxdes))) {
>  		if (net_ratelimit())
> @@ -337,9 +339,16 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
>  		error = true;
>  	}
> 
> -	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes))) {
> +	/* The frame-too-long flag 'FTMAC100_RXDES0_FTL' is described in the
> +	 * datasheet as: "When set, it indicates that the received packet
> +	 * length exceeds 1518 bytes." But testing shows that it is also set
> +	 * when packet length is equal to 1518.
> +	 * Since 1518 is a standard Ethernet maximum frame size, let it pass
> +	 * and only trigger an error when packet length really exceeds it.
> +	 */
> +	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes) && length > 1518)) {
>  		if (net_ratelimit())
> -			netdev_info(netdev, "rx frame too long\n");
> +			netdev_info(netdev, "rx frame too long (%u)\n", length);
> 
>  		netdev->stats.rx_length_errors++;
>  		error = true;
> --
> 2.34.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

