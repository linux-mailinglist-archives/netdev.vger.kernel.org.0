Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C866424701
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 21:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbhJFTlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 15:41:13 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:32816 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbhJFTkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 15:40:52 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 0CD49206166A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
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
 <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <63592646-7547-1a81-e6c3-5bac413cb94a@omp.ru>
Date:   Wed, 6 Oct 2021 22:38:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
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

> Fillup ravb_rx_gbeth() function to support RZ/G2L.
> 
> This patch also renames ravb_rcar_rx to ravb_rx_rcar to be
> consistent with the naming convention used in sh_eth driver.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 37164a983156..42573eac82b9 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -720,6 +720,23 @@ static void ravb_get_tx_tstamp(struct net_device *ndev)
>  	}
>  }
>  
> +static void ravb_rx_csum_gbeth(struct sk_buff *skb)
> +{
> +	u8 *hw_csum;
> +
> +	/* The hardware checksum is contained in sizeof(__sum16) (2) bytes
> +	 * appended to packet data
> +	 */
> +	if (unlikely(skb->len < sizeof(__sum16)))
> +		return;
> +	hw_csum = skb_tail_pointer(skb) - sizeof(__sum16);

   Not 32-bit? The manual says the IP checksum is stored in the first 2 bytes.

> +
> +	if (*hw_csum == 0)

   You only check the 1st byte, not the full checksum!

> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +	else
> +		skb->ip_summed = CHECKSUM_NONE;

  So the TCP/UDP/ICMP checksums are not dealt with? Why enable them then?

> +}
> +
>  static void ravb_rx_csum(struct sk_buff *skb)

static void ravb_rx_csum_rcar(struct sk_buff *skb)?

[...]

MBR, Sergey
