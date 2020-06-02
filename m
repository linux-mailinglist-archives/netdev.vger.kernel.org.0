Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C531EB3B7
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 05:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFBDRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 23:17:46 -0400
Received: from ozlabs.org ([203.11.71.1]:53761 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgFBDRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 23:17:46 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bcft6Gdgz9sSn;
        Tue,  2 Jun 2020 13:17:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1591067864; bh=b/bdhBRmnux6Rm4XZlS6YImDkqQA7n6ceo9UyjXrZQM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=yzcRawpLTZ5VMzZYqYJspMYmCUI4oQhzXudOasPGmbg6w7jptnsifBvkPQm8UKynu
         pBmJuAtM9Ht0REuGSFmg1W0zZo+S/DFjaBoVEV5Z4acTHyUScJGncTs/N0bXfRRDkq
         xS6I7eRQ3aJCNxhUzvD4K0sMHPh6UbOHcwo/EHFDNBSkXJyT77N+nv/tv9Py7pG7VX
         fOVT1I0MWJ3/23G8fJz+U4soe1lBnPFn/N57S5Ui1zpde4AUDfCJomgwKNK2vksPeq
         xsawVUl4G9mLAYNkxPFlC9pndrwovlp0lXDukwdXsjRrqN3bJOOcSdXzuEqgona/A4
         Qpx0X6mSSFlLg==
Message-ID: <b9e1db7761761e321b23bd0d22ab981cbd5d6abe.camel@ozlabs.org>
Subject: Re: [RFC PATCH] net: usb: ax88179_178a: fix packet alignment padding
From:   Jeremy Kerr <jk@ozlabs.org>
To:     Freddy Xin <freddy@asix.com.tw>, Allan Chou <allan@asix.com.tw>
Cc:     Peter Fink <pfink@christ-es.de>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Date:   Tue, 02 Jun 2020 11:17:34 +0800
In-Reply-To: <20200527060334.19441-1-jk@ozlabs.org>
References: <20200527060334.19441-1-jk@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Freddy and Allan,

Just following up on the RFC patch below: Can you confirm whether the
packet len (in the hardware-provided packet RX metadata) includes the
two-byte padding field? Is this the same for all ax88179 devices?

Cheers,


Jeremy

> Using a AX88179 device (0b95:1790), I see two bytes of appended data on
> every RX packet. For example, this 48-byte ping, using 0xff as a
> payload byte:
> 
>   04:20:22.528472 IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 2447, seq 1, length 64
> 	0x0000:  000a cd35 ea50 000a cd35 ea4f 0800 4500
> 	0x0010:  0054 c116 4000 4001 f63e c0a8 0101 c0a8
> 	0x0020:  0102 0800 b633 098f 0001 87ea cd5e 0000
> 	0x0030:  0000 dcf2 0600 0000 0000 ffff ffff ffff
> 	0x0040:  ffff ffff ffff ffff ffff ffff ffff ffff
> 	0x0050:  ffff ffff ffff ffff ffff ffff ffff ffff
> 	0x0060:  ffff 961f
> 
> Those last two bytes - 96 1f - aren't part of the original packet.
> 
> In the ax88179 RX path, the usbnet rx_fixup function trims a 2-byte
> 'alignment pseudo header' from the start of the packet, and sets the
> length from a per-packet field populated by hardware. It looks like that
> length field *includes* the 2-byte header; the current driver assumes
> that it's excluded.
> 
> This change trims the 2-byte alignment header after we've set the packet
> length, so the resulting packet length is correct. While we're moving
> the comment around, this also fixes the spelling of 'pseudo'.
> 
> Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
> 
> ---
> RFC: I don't have access to docs for this hardware, so this is all based
> on observed behaviour of the reported packet length.
> ---
>  drivers/net/usb/ax88179_178a.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> index 93044cf1417a..1fe4cc28d154 100644
> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -1414,10 +1414,10 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>  		}
>  
>  		if (pkt_cnt == 0) {
> -			/* Skip IP alignment psudo header */
> -			skb_pull(skb, 2);
>  			skb->len = pkt_len;
> -			skb_set_tail_pointer(skb, pkt_len);
> +			/* Skip IP alignment pseudo header */
> +			skb_pull(skb, 2);
> +			skb_set_tail_pointer(skb, skb->len);
>  			skb->truesize = pkt_len + sizeof(struct sk_buff);
>  			ax88179_rx_checksum(skb, pkt_hdr);
>  			return 1;
> @@ -1426,8 +1426,9 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>  		ax_skb = skb_clone(skb, GFP_ATOMIC);
>  		if (ax_skb) {
>  			ax_skb->len = pkt_len;
> -			ax_skb->data = skb->data + 2;
> -			skb_set_tail_pointer(ax_skb, pkt_len);
> +			/* Skip IP alignment pseudo header */
> +			skb_pull(ax_skb, 2);
> +			skb_set_tail_pointer(ax_skb, ax_skb->len);
>  			ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
>  			ax88179_rx_checksum(ax_skb, pkt_hdr);
>  			usbnet_skb_return(dev, ax_skb);
> 

