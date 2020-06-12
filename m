Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A6B1F731C
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 06:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgFLEpd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 12 Jun 2020 00:45:33 -0400
Received: from asix.com.tw ([210.243.224.51]:31432 "EHLO freebsd2.asix.com.tw"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725763AbgFLEpd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 00:45:33 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2020 00:45:32 EDT
Received: from LouisSurfacePro (122-146-92-225.adsl.static.sparqnet.net [122.146.92.225] (may be forged))
        (authenticated bits=0)
        by freebsd2.asix.com.tw (8.15.2/8.15.2) with ESMTPSA id 05C4DwJs069313
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 12 Jun 2020 12:13:58 +0800 (CST)
        (envelope-from louis@asix.com.tw)
Authentication-Results: freebsd2.asix.com.tw; sender-id=softfail header.from=louis@asix.com.tw; auth=pass (LOGIN); spf=softfail smtp.mfrom=louis@asix.com.tw
X-Authentication-Warning: freebsd2.asix.com.tw: Host 122-146-92-225.adsl.static.sparqnet.net [122.146.92.225] (may be forged) claimed to be LouisSurfacePro
From:   <louis@asix.com.tw>
To:     "'ASIX_Allan [Office]'" <allan@asix.com.tw>,
        "'Jeremy Kerr'" <jk@ozlabs.org>,
        "'Freddy Xin'" <freddy@asix.com.tw>
Cc:     "'Peter Fink'" <pfink@christ-es.de>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
References: <20200527060334.19441-1-jk@ozlabs.org> <b9e1db7761761e321b23bd0d22ab981cbd5d6abe.camel@ozlabs.org> <000601d638a2$317f44d0$947dce70$@asix.com.tw>
In-Reply-To: <000601d638a2$317f44d0$947dce70$@asix.com.tw>
Subject: RE: [RFC PATCH] net: usb: ax88179_178a: fix packet alignment padding
Date:   Fri, 12 Jun 2020 12:10:47 +0800
Message-ID: <000801d6406f$757d45e0$6077d1a0$@asix.com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHmoCzAkPvBY+mFBa6Wg5HaQv5jdQFGCLaeAakD2h+onCO8kA==
Content-Language: zh-tw
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeremy,

Thanks for the correction.
Indeed, the hardware adds two bytes dummy data at beginning of Ethernet packet to make IP header aligned. 
The original patch made by Freddy contains the length of dummy header. 
Thanks for your concerning.
Please let us know if you have any other question.

Thank you,
Louis.

---
Best regards,
Allan Chou
ASIX Electronics Corporation
TEL: 886-3-5799500 ext.228
FAX: 886-3-5799558
E-mail: allan@asix.com.tw 
https://www.asix.com.tw/ 



-----Original Message-----
From: Jeremy Kerr <jk@ozlabs.org> 
Sent: Tuesday, June 2, 2020 11:18 AM
To: Freddy Xin <freddy@asix.com.tw>; Allan Chou <allan@asix.com.tw>
Cc: Peter Fink <pfink@christ-es.de>; netdev@vger.kernel.org; linux-usb@vger.kernel.org
Subject: Re: [RFC PATCH] net: usb: ax88179_178a: fix packet alignment padding

Hi Freddy and Allan,

Just following up on the RFC patch below: Can you confirm whether the packet len (in the hardware-provided packet RX metadata) includes the two-byte padding field? Is this the same for all ax88179 devices?

Cheers,


Jeremy

> Using a AX88179 device (0b95:1790), I see two bytes of appended data 
> on every RX packet. For example, this 48-byte ping, using 0xff as a 
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
> length from a per-packet field populated by hardware. It looks like 
> that length field *includes* the 2-byte header; the current driver 
> assumes that it's excluded.
> 
> This change trims the 2-byte alignment header after we've set the 
> packet length, so the resulting packet length is correct. While we're 
> moving the comment around, this also fixes the spelling of 'pseudo'.
> 
> Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
> 
> ---
> RFC: I don't have access to docs for this hardware, so this is all 
> based on observed behaviour of the reported packet length.
> ---
>  drivers/net/usb/ax88179_178a.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/usb/ax88179_178a.c 
> b/drivers/net/usb/ax88179_178a.c index 93044cf1417a..1fe4cc28d154 
> 100644
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

