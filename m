Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676124242E7
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhJFQm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:42:58 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:55112 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJFQm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 12:42:57 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 07C0620ECFD1
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [RFC 08/12] ravb: Add carrier_counters to struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Adam Ford" <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-9-biju.das.jz@bp.renesas.com>
Organization: Open Mobile Platform
Message-ID: <5be0aed7-ba46-3b5f-e49f-8edf7cb9c193@omp.ru>
Date:   Wed, 6 Oct 2021 19:41:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005110642.3744-9-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/21 2:06 PM, Biju Das wrote:

> RZ/G2L E-MAC supports carrier counters.
> Add a carrier_counter hw feature bit to struct ravb_hw_info
> to add this feature only for RZ/G2L.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 8c7b2569c7dd..899e16c5eb1a 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
[...]
@@ -1061,6 +1065,7 @@ struct ravb_hw_info {
 	unsigned nc_queue:1;		/* AVB-DMAC has NC queue */
 	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
 	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
+	unsigned carrier_counters:1;	/* E-MAC has carrier counters */



[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 42573eac82b9..c057de81ec58 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2075,6 +2075,18 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
>  		ravb_write(ndev, 0, TROCR);	/* (write clear) */
>  	}
>  
> +	if (info->carrier_counters) {
> +		nstats->collisions += ravb_read(ndev, CXR41);
> +		ravb_write(ndev, 0, CXR41);	/* (write clear) */
> +		nstats->tx_carrier_errors += ravb_read(ndev, CXR42);
> +		ravb_write(ndev, 0, CXR42);	/* (write clear) */
> +
> +		nstats->tx_carrier_errors += ravb_read(ndev, CXR55);

   According to the manual, CXR55 counts RX events (carrier extension lost.

> +		ravb_write(ndev, 0, CXR55);	/* (write clear) */
> +		nstats->tx_carrier_errors += ravb_read(ndev, CXR56);

   And CXR56 counts receive events too...

> +		ravb_write(ndev, 0, CXR56);	/* (write clear) */
> +	}
> +
>  	nstats->rx_packets = stats0->rx_packets;
>  	nstats->tx_packets = stats0->tx_packets;
>  	nstats->rx_bytes = stats0->rx_bytes;
> @@ -2486,6 +2498,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
>  	.aligned_tx = 1,
>  	.tx_counters = 1,
>  	.half_duplex = 1,
> +	.carrier_counters = 1,

   At least init it next to 'tx_counters'. :-)

[...]

MBR, Sergey
