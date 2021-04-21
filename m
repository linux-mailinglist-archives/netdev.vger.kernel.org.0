Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB1A366E5F
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbhDUOjI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Apr 2021 10:39:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:39737 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234914AbhDUOjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 10:39:04 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-279-E_LjFz9SPlSA_JZbVKloyw-1; Wed, 21 Apr 2021 15:38:28 +0100
X-MC-Unique: E_LjFz9SPlSA_JZbVKloyw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 21 Apr 2021 15:38:27 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Wed, 21 Apr 2021 15:38:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "Voon Weifeng" <weifeng.voon@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Thierry Reding <treding@nvidia.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] [net-next] net: stmmac: fix gcc-10 -Wrestrict warning
Thread-Topic: [PATCH] [net-next] net: stmmac: fix gcc-10 -Wrestrict warning
Thread-Index: AQHXNrT6fDpLRbOb4EudX81jJF2zvaq/CRyw
Date:   Wed, 21 Apr 2021 14:38:27 +0000
Message-ID: <caa29114659049e584b9fa7fbb6226c8@AcuMS.aculab.com>
References: <20210421134743.3260921-1-arnd@kernel.org>
In-Reply-To: <20210421134743.3260921-1-arnd@kernel.org>
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

From: Arnd Bergmann
> Sent: 21 April 2021 14:47
> 
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-10 and later warn about a theoretical array overrun when
> accessing priv->int_name_rx_irq[i] with an out of bounds value
> of 'i':
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_request_irq_multi_msi':
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3528:17: error: 'snprintf' argument 4 may overlap
> destination object 'dev' [-Werror=restrict]
>  3528 |                 snprintf(int_name, int_name_len, "%s:%s-%d", dev->name, "tx", i);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3404:60: note: destination object referenced by
> 'restrict'-qualified argument 1 was declared here
>  3404 | static int stmmac_request_irq_multi_msi(struct net_device *dev)
>       |                                         ~~~~~~~~~~~~~~~~~~~^~~
> 
> The warning is a bit strange since it's not actually about the array
> bounds but rather about possible string operations with overlapping
> arguments, but it's not technically wrong.
> 
> Avoid the warning by adding an extra bounds check.
> 
> Fixes: 8532f613bc78 ("net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index d1ca07c846e6..aadac783687b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -3498,6 +3498,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
> 
>  	/* Request Rx MSI irq */
>  	for (i = 0; i < priv->plat->rx_queues_to_use; i++) {
> +		if (i > MTL_MAX_RX_QUEUES)
> +			break;
>  		if (priv->rx_irq[i] == 0)
>  			continue;

It might be best to do:
	num_queues = min(priv->plat->rx_queues_to_use, MTL_MAX_RX_QUEUES);
	if (i = 0; i < num_queues; i++) {
		...

Or just give up - if rx_queues_to_use is too big it's all
gone horribly wrong already.

The compile must be smoking weed again.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

