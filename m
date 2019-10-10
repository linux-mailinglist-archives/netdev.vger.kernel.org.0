Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288A5D1D78
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 02:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbfJJAjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 20:39:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:14550 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731230AbfJJAjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 20:39:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 17:39:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,278,1566889200"; 
   d="scan'208";a="345536271"
Received: from unknown (HELO [10.241.228.165]) ([10.241.228.165])
  by orsmga004.jf.intel.com with ESMTP; 09 Oct 2019 17:39:20 -0700
Subject: Re: [PATCH 3/3] i40e: Add UDP segmentation offload support
To:     Josh Hunt <johunt@akamai.com>, netdev@vger.kernel.org,
        willemb@google.com, intel-wired-lan@lists.osuosl.org
Cc:     Alexander Duyck <alexander.h.duyck@intel.com>
References: <1570658777-13459-1-git-send-email-johunt@akamai.com>
 <1570658777-13459-4-git-send-email-johunt@akamai.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <5f4af1c5-c2d1-d643-3fb2-fe4bd0e7e8cf@intel.com>
Date:   Wed, 9 Oct 2019 17:39:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570658777-13459-4-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/9/2019 3:06 PM, Josh Hunt wrote:
> Based on a series from Alexander Duyck this change adds UDP segmentation
> offload support to the i40e driver.
> 
> CC: Alexander Duyck <alexander.h.duyck@intel.com>
> CC: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_main.c |  1 +
>   drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 +++++++++---
>   2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 6031223eafab..56f8c52cbba1 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -12911,6 +12911,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
>   			  NETIF_F_GSO_IPXIP6		|
>   			  NETIF_F_GSO_UDP_TUNNEL	|
>   			  NETIF_F_GSO_UDP_TUNNEL_CSUM	|
> +			  NETIF_F_GSO_UDP_L4		|
>   			  NETIF_F_SCTP_CRC		|
>   			  NETIF_F_RXHASH		|
>   			  NETIF_F_RXCSUM		|
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index e3f29dc8b290..0b32f04a6255 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -2960,10 +2960,16 @@ static int i40e_tso(struct i40e_tx_buffer *first, u8 *hdr_len,
>   
>   	/* remove payload length from inner checksum */
>   	paylen = skb->len - l4_offset;
> -	csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
>   
> -	/* compute length of segmentation header */
> -	*hdr_len = (l4.tcp->doff * 4) + l4_offset;
> +	if (skb->csum_offset == offsetof(struct tcphdr, check)) {

Isn't it more relevant to check for gso_type rather than base this on 
the csum_offset?


> +		csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
> +		/* compute length of segmentation header */
> +		*hdr_len = (l4.tcp->doff * 4) + l4_offset;
> +	} else {
> +		csum_replace_by_diff(&l4.udp->check, (__force __wsum)htonl(paylen));
> +		/* compute length of segmentation header */
> +		*hdr_len = sizeof(*l4.udp) + l4_offset;
> +	}
>   
>   	/* pull values out of skb_shinfo */
>   	gso_size = skb_shinfo(skb)->gso_size;
> 
