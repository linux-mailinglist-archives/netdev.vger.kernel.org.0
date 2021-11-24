Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F43045CDA9
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245058AbhKXUOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:14:01 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:53102 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244929AbhKXUOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:14:01 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 7C9D1209F8B8
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC 2/2] ravb: Add Rx checksum offload support
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "Biju Das" <biju.das@bp.renesas.com>
References: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
 <20211123133157.21829-3-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <912abe7c-3097-4d39-01b6-82385f001fa8@omp.ru>
Date:   Wed, 24 Nov 2021 23:10:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211123133157.21829-3-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 11/23/21 4:31 PM, Biju Das wrote:

> TOE has hw support for calculating IP header checkum for IPV4 and
> TCP/UDP/ICMP checksum for both IPV4 and IPV6.
> 
> This patch adds Rx checksum offload supported by TOE.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  4 +++
>  drivers/net/ethernet/renesas/ravb_main.c | 31 ++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index a96552348e2d..d0e5eec0636e 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -44,6 +44,10 @@
>  #define RAVB_RXTSTAMP_TYPE_ALL	0x00000006
>  #define RAVB_RXTSTAMP_ENABLED	0x00000010	/* Enable RX timestamping */
>  
> +/* GbEthernet TOE hardware checksum values */
> +#define TOE_RX_CSUM_OK		0x0000
> +#define TOE_RX_CSUM_UNSUPPORTED	0xFFFF

   These are hardly needed IMO.

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index c2b92c6a6cd2..2533e3401593 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -720,6 +720,33 @@ static void ravb_get_tx_tstamp(struct net_device *ndev)
>  	}
>  }
>  
> +static void ravb_rx_csum_gbeth(struct sk_buff *skb)
> +{
> +	u32 csum_ip_hdr, csum_proto;

   Why u32 if both sums are 16-bit?

> +	u8 *hw_csum;
> +
> +	/* The hardware checksum is contained in sizeof(__sum16) * 2 = 4 bytes
> +	 * appended to packet data. First 2 bytes is ip header csum and last
> +	 * 2 bytes is protocol csum.
> +	 */
> +	if (unlikely(skb->len < sizeof(__sum16) * 2))
> +		return;
> +	hw_csum = skb_tail_pointer(skb) - sizeof(__sum16);
> +	csum_proto = csum_unfold((__force __sum16)get_unaligned_le16(hw_csum));
> +
> +	hw_csum = skb_tail_pointer(skb) - 2 * sizeof(__sum16);
> +	csum_ip_hdr = csum_unfold((__force __sum16)get_unaligned_le16(hw_csum));
> +
> +	skb->ip_summed = CHECKSUM_NONE;
> +	if (csum_proto == TOE_RX_CSUM_OK) {
> +		if (skb->protocol == htons(ETH_P_IP) && csum_ip_hdr == TOE_RX_CSUM_OK)
> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
> +		else if (skb->protocol == htons(ETH_P_IPV6) &&
> +			 csum_ip_hdr == TOE_RX_CSUM_UNSUPPORTED)
> +			skb->ip_summed = CHECKSUM_UNNECESSARY;

   Checksum is unsupported and you declare it unnecessary?

> +	}

   Now where's a call to skb_trim()?

[...]

MBR, Sergey
