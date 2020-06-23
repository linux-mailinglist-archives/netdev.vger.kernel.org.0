Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F1F204BBC
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbgFWHzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:55:12 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:35564 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731346AbgFWHzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:55:12 -0400
Received: from [192.168.178.106] (p57bc9f02.dip0.t-ipconnect.de [87.188.159.2])
        by mail.bugwerft.de (Postfix) with ESMTPSA id A32F242BB05;
        Tue, 23 Jun 2020 07:55:10 +0000 (UTC)
Subject: Re: [PATCH v2] dsa: Allow forwarding of redirected IGMP traffic
To:     netdev@vger.kernel.org
Cc:     jcobham@questertangent.com, andrew@lunn.ch
References: <20200620193925.3166913-1-daniel@zonque.org>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <649fde96-c017-9a6c-1e08-a602e317c60e@zonque.org>
Date:   Tue, 23 Jun 2020 09:55:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200620193925.3166913-1-daniel@zonque.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

This version should address the comments you had on my initial
submission. Does this one look better now?


Thanks,
Daniel

On 6/20/20 9:39 PM, Daniel Mack wrote:
> The driver for Marvell switches puts all ports in IGMP snooping mode
> which results in all IGMP/MLD frames that ingress on the ports to be
> forwarded to the CPU only.
> 
> The bridge code in the kernel can then interpret these frames and act
> upon them, for instance by updating the mdb in the switch to reflect
> multicast memberships of stations connected to the ports. However,
> the IGMP/MLD frames must then also be forwarded to other ports of the
> bridge so external IGMP queriers can track membership reports, and
> external multicast clients can receive query reports from foreign IGMP
> queriers.
> 
> Currently, this is impossible as the EDSA tagger sets offload_fwd_mark
> on the skb when it unwraps the tagged frames, and that will make the
> switchdev layer prevent the skb from egressing on any other port of
> the same switch.
> 
> To fix that, look at the To_CPU code in the DSA header and make
> forwarding of the frame possible for trapped IGMP packets.
> 
> Introduce some #defines for the frame types to make the code a bit more
> comprehensive.
> 
> This was tested on a Marvell 88E6352 variant.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
> v2:
>   * Limit IGMP handling to TO_CPU frames
>   * Use #defines for the TO_CPU codes and the frame types
> 
>  net/dsa/tag_edsa.c | 37 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
> index e8eaa804ccb9e..d6200ff982007 100644
> --- a/net/dsa/tag_edsa.c
> +++ b/net/dsa/tag_edsa.c
> @@ -13,6 +13,16 @@
>  #define DSA_HLEN	4
>  #define EDSA_HLEN	8
>  
> +#define FRAME_TYPE_TO_CPU	0x00
> +#define FRAME_TYPE_FORWARD	0x03
> +
> +#define TO_CPU_CODE_MGMT_TRAP		0x00
> +#define TO_CPU_CODE_FRAME2REG		0x01
> +#define TO_CPU_CODE_IGMP_MLD_TRAP	0x02
> +#define TO_CPU_CODE_POLICY_TRAP		0x03
> +#define TO_CPU_CODE_ARP_MIRROR		0x04
> +#define TO_CPU_CODE_POLICY_MIRROR	0x05
> +
>  static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> @@ -77,6 +87,8 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
>  				struct packet_type *pt)
>  {
>  	u8 *edsa_header;
> +	int frame_type;
> +	int code;
>  	int source_device;
>  	int source_port;
>  
> @@ -91,8 +103,29 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
>  	/*
>  	 * Check that frame type is either TO_CPU or FORWARD.
>  	 */
> -	if ((edsa_header[0] & 0xc0) != 0x00 && (edsa_header[0] & 0xc0) != 0xc0)
> +	frame_type = edsa_header[0] >> 6;
> +
> +	switch (frame_type) {
> +	case FRAME_TYPE_TO_CPU:
> +		code = (edsa_header[1] & 0x6) | ((edsa_header[2] >> 4) & 1);
> +
> +		/*
> +		 * Mark the frame to never egress on any port of the same switch
> +		 * unless it's a trapped IGMP/MLD packet, in which case the
> +		 * bridge might want to forward it.
> +		 */
> +		if (code != TO_CPU_CODE_IGMP_MLD_TRAP)
> +			skb->offload_fwd_mark = 1;
> +
> +		break;
> +
> +	case FRAME_TYPE_FORWARD:
> +		skb->offload_fwd_mark = 1;
> +		break;
> +
> +	default:
>  		return NULL;
> +	}
>  
>  	/*
>  	 * Determine source device and port.
> @@ -156,8 +189,6 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
>  			2 * ETH_ALEN);
>  	}
>  
> -	skb->offload_fwd_mark = 1;
> -
>  	return skb;
>  }
>  
> 

