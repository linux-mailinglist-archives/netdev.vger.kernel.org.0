Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D30E696782
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjBNPA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjBNPA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:00:57 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B84526847;
        Tue, 14 Feb 2023 07:00:55 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id AA34F60027FD9;
        Tue, 14 Feb 2023 16:00:52 +0100 (CET)
Message-ID: <6a5ded96-2425-ff9b-c1b1-eca1c103164c@molgen.mpg.de>
Date:   Tue, 14 Feb 2023 16:00:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [Intel-wired-lan] [PATCH bpf-next V1] igc: enable and fix RX hash
 usage by netstack
Content-Language: en-US
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        martin.lau@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, ast@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        yoong.siang.song@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <167604167956.1726972.7266620647404438534.stgit@firesoul>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jesper,


Thank you very much for your patch.

Am 10.02.23 um 16:07 schrieb Jesper Dangaard Brouer:
> When function igc_rx_hash() was introduced in v4.20 via commit 0507ef8a0372
> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
> hardware wasn't configured to provide RSS hash, thus it made sense to not
> enable net_device NETIF_F_RXHASH feature bit.
> 
> The NIC hardware was configured to enable RSS hash info in v5.2 via commit
> 2121c2712f82 ("igc: Add multiple receive queues control supporting"), but
> forgot to set the NETIF_F_RXHASH feature bit.
> 
> The original implementation of igc_rx_hash() didn't extract the associated
> pkt_hash_type, but statically set PKT_HASH_TYPE_L3. The largest portions of
> this patch are about extracting the RSS Type from the hardware and mapping
> this to enum pkt_hash_types. This were based on Foxville i225 software user

s/This were/This was/

> manual rev-1.3.1 and tested on Intel Ethernet Controller I225-LM (rev 03).
> 
> For UDP it's worth noting that RSS (type) hashing have been disabled both for
> IPv4 and IPv6 (see IGC_MRQC_RSS_FIELD_IPV4_UDP + IGC_MRQC_RSS_FIELD_IPV6_UDP)
> because hardware RSS doesn't handle fragmented pkts well when enabled (can
> cause out-of-order). This result in PKT_HASH_TYPE_L3 for UDP packets, and

result*s*

> hash value doesn't include UDP port numbers. Not being PKT_HASH_TYPE_L4, have
> the effect that netstack will do a software based hash calc calling into
> flow_dissect, but only when code calls skb_get_hash(), which doesn't
> necessary happen for local delivery.

Excuse my ignorance, but is that bug visible in practice by users 
(performance?) or is that fix needed for future work?

> Fixes: 2121c2712f82 ("igc: Add multiple receive queues control supporting")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   drivers/net/ethernet/intel/igc/igc.h      |   52 +++++++++++++++++++++++++++++
>   drivers/net/ethernet/intel/igc/igc_main.c |   35 +++++++++++++++++---
>   2 files changed, 83 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
> index df3e26c0cf01..a112eeb59525 100644
> --- a/drivers/net/ethernet/intel/igc/igc.h
> +++ b/drivers/net/ethernet/intel/igc/igc.h
> @@ -311,6 +311,58 @@ extern char igc_driver_name[];
>   #define IGC_MRQC_RSS_FIELD_IPV4_UDP	0x00400000
>   #define IGC_MRQC_RSS_FIELD_IPV6_UDP	0x00800000
>   
> +/* RX-desc Write-Back format RSS Type's */
> +enum igc_rss_type_num {
> +	IGC_RSS_TYPE_NO_HASH		= 0,
> +	IGC_RSS_TYPE_HASH_TCP_IPV4	= 1,
> +	IGC_RSS_TYPE_HASH_IPV4		= 2,
> +	IGC_RSS_TYPE_HASH_TCP_IPV6	= 3,
> +	IGC_RSS_TYPE_HASH_IPV6_EX	= 4,
> +	IGC_RSS_TYPE_HASH_IPV6		= 5,
> +	IGC_RSS_TYPE_HASH_TCP_IPV6_EX	= 6,
> +	IGC_RSS_TYPE_HASH_UDP_IPV4	= 7,
> +	IGC_RSS_TYPE_HASH_UDP_IPV6	= 8,
> +	IGC_RSS_TYPE_HASH_UDP_IPV6_EX	= 9,
> +	IGC_RSS_TYPE_MAX		= 10,
> +};
> +#define IGC_RSS_TYPE_MAX_TABLE		16
> +#define IGC_RSS_TYPE_MASK		0xF
> +
> +/* igc_rss_type - Rx descriptor RSS type field */
> +static inline u8 igc_rss_type(union igc_adv_rx_desc *rx_desc)
> +{
> +	/* RSS Type 4-bit number: 0-9 (above 9 is reserved) */
> +	return rx_desc->wb.lower.lo_dword.hs_rss.pkt_info & IGC_RSS_TYPE_MASK;
> +}

Is it necessary to specficy the length of the return value, or could it 
be `unsigned int`. Using “native” types is normally more performant [1]. 
`scripts/bloat-o-meter` might help to verify that.

[…]

>   static inline void igc_rx_hash(struct igc_ring *ring,
>   			       union igc_adv_rx_desc *rx_desc,
>   			       struct sk_buff *skb)
>   {
> -	if (ring->netdev->features & NETIF_F_RXHASH)
> -		skb_set_hash(skb,
> -			     le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
> -			     PKT_HASH_TYPE_L3);
> +	if (ring->netdev->features & NETIF_F_RXHASH) {
> +		u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
> +		u8  rss_type = igc_rss_type(rx_desc);

Amongst others, also here.

> +		enum pkt_hash_types hash_type;
> +
> +		hash_type = igc_rss_type_table[rss_type].hash_type;
> +		skb_set_hash(skb, rss_hash, hash_type);
> +	}
>   }
>   
>   static void igc_rx_vlan(struct igc_ring *rx_ring,
> @@ -6501,6 +6527,7 @@ static int igc_probe(struct pci_dev *pdev,
>   	netdev->features |= NETIF_F_TSO;
>   	netdev->features |= NETIF_F_TSO6;
>   	netdev->features |= NETIF_F_TSO_ECN;
> +	netdev->features |= NETIF_F_RXHASH;
>   	netdev->features |= NETIF_F_RXCSUM;
>   	netdev->features |= NETIF_F_HW_CSUM;
>   	netdev->features |= NETIF_F_SCTP_CRC;


Kind regards,

Paul


[1]: https://notabs.org/coding/smallIntsBigPenalty.htm
