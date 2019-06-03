Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842FF330F8
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfFCNWj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Jun 2019 09:22:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:32004 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726516AbfFCNWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:22:35 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-149-2i4xwsqCOGe9w_cHrK2MyA-1; Mon, 03 Jun 2019 14:22:32 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon,
 3 Jun 2019 14:22:31 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 3 Jun 2019 14:22:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Robert Hancock' <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "anirudh@xilinx.com" <anirudh@xilinx.com>,
        "John.Linn@xilinx.com" <John.Linn@xilinx.com>
Subject: RE: [PATCH net-next 09/13] net: axienet: Make missing MAC address
 non-fatal
Thread-Topic: [PATCH net-next 09/13] net: axienet: Make missing MAC address
 non-fatal
Thread-Index: AQHVF97vnsjN2fINTkywHBXtncRQ+qaJ7rAQ
Date:   Mon, 3 Jun 2019 13:22:31 +0000
Message-ID: <cc01dd319abd4b1194bcdb9900e0e1ce@AcuMS.aculab.com>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
 <1559326545-28825-10-git-send-email-hancock@sedsystems.ca>
In-Reply-To: <1559326545-28825-10-git-send-email-hancock@sedsystems.ca>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 2i4xwsqCOGe9w_cHrK2MyA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock
> Sent: 31 May 2019 19:16
> Failing initialization on a missing MAC address property is excessive.
> We can just fall back to using a random MAC instead, which at least
> leaves the interface in a functioning state.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 9949e67..947fa5d 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -308,7 +308,7 @@ static void axienet_set_mac_address(struct net_device *ndev,
>  {
>  	struct axienet_local *lp = netdev_priv(ndev);
> 
> -	if (address)
> +	if (!IS_ERR(address))
>  		memcpy(ndev->dev_addr, address, ETH_ALEN);
>  	if (!is_valid_ether_addr(ndev->dev_addr))
>  		eth_hw_addr_random(ndev);
> @@ -1730,8 +1730,7 @@ static int axienet_probe(struct platform_device *pdev)
>  	/* Retrieve the MAC address */
>  	mac_addr = of_get_mac_address(pdev->dev.of_node);
>  	if (IS_ERR(mac_addr)) {
> -		dev_err(&pdev->dev, "could not find MAC address\n");
> -		goto free_netdev;
> +		dev_warn(&pdev->dev, "could not find MAC address property\n");
>  	}
>  	axienet_set_mac_address(ndev, mac_addr);

Isn't that going to read from an invalid address on error?
Seems you didn't test of_get_mac_address() failing :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

