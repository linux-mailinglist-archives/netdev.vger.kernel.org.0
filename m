Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A7FD443A
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 17:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfJKP34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 11:29:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:22180 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbfJKP34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 11:29:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 08:29:55 -0700
X-IronPort-AV: E=Sophos;i="5.67,284,1566889200"; 
   d="scan'208";a="206479218"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 08:29:55 -0700
Message-ID: <aa9462d4a48a47250d150e0f743bf08635ee9b72.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/3] igb: Add UDP segmentation offload support
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Josh Hunt <johunt@akamai.com>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     willemb@google.com, sridhar.samudrala@intel.com,
        aaron.f.brown@intel.com
Date:   Fri, 11 Oct 2019 08:29:54 -0700
In-Reply-To: <1570753502-6014-2-git-send-email-johunt@akamai.com>
References: <1570753502-6014-1-git-send-email-johunt@akamai.com>
         <1570753502-6014-2-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-10 at 20:25 -0400, Josh Hunt wrote:
> Based on a series from Alexander Duyck this change adds UDP segmentation
> offload support to the igb driver.
> 
> CC: Alexander Duyck <alexander.h.duyck@intel.com>
> CC: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  drivers/net/ethernet/intel/igb/e1000_82575.h |  1 +
>  drivers/net/ethernet/intel/igb/igb_main.c    | 23 +++++++++++++++++------
>  2 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.h b/drivers/net/ethernet/intel/igb/e1000_82575.h
> index 6ad775b1a4c5..63ec253ac788 100644
> --- a/drivers/net/ethernet/intel/igb/e1000_82575.h
> +++ b/drivers/net/ethernet/intel/igb/e1000_82575.h
> @@ -127,6 +127,7 @@ struct e1000_adv_tx_context_desc {
>  };
>  
>  #define E1000_ADVTXD_MACLEN_SHIFT    9  /* Adv ctxt desc mac len shift */
> +#define E1000_ADVTXD_TUCMD_L4T_UDP 0x00000000  /* L4 Packet TYPE of UDP */
>  #define E1000_ADVTXD_TUCMD_IPV4    0x00000400  /* IP Packet Type: 1=IPv4 */
>  #define E1000_ADVTXD_TUCMD_L4T_TCP 0x00000800  /* L4 Packet TYPE of TCP */
>  #define E1000_ADVTXD_TUCMD_L4T_SCTP 0x00001000 /* L4 packet TYPE of SCTP */
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 105b0624081a..4131bc8b079e 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -2516,6 +2516,7 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
>  	if (unlikely(mac_hdr_len > IGB_MAX_MAC_HDR_LEN))
>  		return features & ~(NETIF_F_HW_CSUM |
>  				    NETIF_F_SCTP_CRC |
> +				    NETIF_F_GSO_UDP_L4 |
>  				    NETIF_F_HW_VLAN_CTAG_TX |
>  				    NETIF_F_TSO |
>  				    NETIF_F_TSO6);
> @@ -2524,6 +2525,7 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
>  	if (unlikely(network_hdr_len >  IGB_MAX_NETWORK_HDR_LEN))
>  		return features & ~(NETIF_F_HW_CSUM |
>  				    NETIF_F_SCTP_CRC |
> +				    NETIF_F_GSO_UDP_L4 |
>  				    NETIF_F_TSO |
>  				    NETIF_F_TSO6);
>  
> @@ -3120,7 +3122,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  			    NETIF_F_HW_CSUM;
>  
>  	if (hw->mac.type >= e1000_82576)
> -		netdev->features |= NETIF_F_SCTP_CRC;
> +		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
>  
>  	if (hw->mac.type >= e1000_i350)
>  		netdev->features |= NETIF_F_HW_TC;
> @@ -5694,6 +5696,7 @@ static int igb_tso(struct igb_ring *tx_ring,
>  	} ip;
>  	union {
>  		struct tcphdr *tcp;
> +		struct udphdr *udp;
>  		unsigned char *hdr;
>  	} l4;
>  	u32 paylen, l4_offset;
> @@ -5713,7 +5716,8 @@ static int igb_tso(struct igb_ring *tx_ring,
>  	l4.hdr = skb_checksum_start(skb);
>  
>  	/* ADV DTYP TUCMD MKRLOC/ISCSIHEDLEN */
> -	type_tucmd = E1000_ADVTXD_TUCMD_L4T_TCP;
> +	type_tucmd = (!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)) ?
> +		      E1000_ADVTXD_TUCMD_L4T_TCP : E1000_ADVTXD_TUCMD_L4T_UDP;

The logic here seems a bit convoluted. Instead of testing for
'!SKB_GSO_UDP_L4' why not just make L4T_UDP the first option and drop the
'!'? That will make the TCP offload the default case rather than the UDP
offload.

The same applies to the other 2 patches.

>  	/* initialize outer IP header fields */
>  	if (ip.v4->version == 4) {
> @@ -5741,12 +5745,19 @@ static int igb_tso(struct igb_ring *tx_ring,
>  	/* determine offset of inner transport header */
>  	l4_offset = l4.hdr - skb->data;
>  
> -	/* compute length of segmentation header */
> -	*hdr_len = (l4.tcp->doff * 4) + l4_offset;
> -
>  	/* remove payload length from inner checksum */
>  	paylen = skb->len - l4_offset;
> -	csum_replace_by_diff(&l4.tcp->check, htonl(paylen));
> +	if (type_tucmd & E1000_ADVTXD_TUCMD_L4T_TCP) {
> +		/* compute length of segmentation header */
> +		*hdr_len = (l4.tcp->doff * 4) + l4_offset;
> +		csum_replace_by_diff(&l4.tcp->check,
> +			(__force __wsum)htonl(paylen));
> +	} else {
> +		/* compute length of segmentation header */
> +		*hdr_len = sizeof(*l4.udp) + l4_offset;
> +		csum_replace_by_diff(&l4.udp->check,
> +				     (__force __wsum)htonl(paylen));
> +	}
>  
>  	/* update gso size and bytecount with header size */
>  	first->gso_segs = skb_shinfo(skb)->gso_segs;


