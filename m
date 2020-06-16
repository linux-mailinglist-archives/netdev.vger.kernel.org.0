Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9691FA56E
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgFPBMC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Jun 2020 21:12:02 -0400
Received: from asix.com.tw ([210.243.224.51]:57329 "EHLO freebsd2.asix.com.tw"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726564AbgFPBMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 21:12:02 -0400
Received: from AllanWin10 ([210.243.224.52])
        (authenticated bits=0)
        by freebsd2.asix.com.tw (8.15.2/8.15.2) with ESMTPSA id 05G1BSwx057632
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 16 Jun 2020 09:11:35 +0800 (CST)
        (envelope-from allan@asix.com.tw)
Authentication-Results: freebsd2.asix.com.tw; sender-id=softfail header.from=allan@asix.com.tw; auth=pass (LOGIN); spf=softfail smtp.mfrom=allan@asix.com.tw
X-Authentication-Warning: freebsd2.asix.com.tw: Host [210.243.224.52] claimed to be AllanWin10
From:   "ASIX_Allan [Office]" <allan@asix.com.tw>
To:     "'David Miller'" <davem@davemloft.net>, <jk@ozlabs.org>,
        =?utf-8?B?QVNJWCBMb3VpcyBb6JiH5aiB6Zm4XQ==?= <louis@asix.com.tw>
Cc:     <netdev@vger.kernel.org>, <pfink@christ-es.de>,
        <linux-usb@vger.kernel.org>
References: <20200615025456.30219-1-jk@ozlabs.org> <20200615.125220.492630206908309571.davem@davemloft.net>
In-Reply-To: <20200615.125220.492630206908309571.davem@davemloft.net>
Subject: RE: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
Date:   Tue, 16 Jun 2020 09:08:30 +0800
Message-ID: <000f01d6437a$ab60b080$02221180$@asix.com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-tw
Thread-Index: AQHuQNNAcJozatbpD9iQc3OpXVVaxAIJkOpNqJomUbA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added ASIX S/W, Louis in the CC loop. 

 
---
Best regards,
Allan Chou
ASIX Electronics Corporation
TEL: 886-3-5799500 ext.228
FAX: 886-3-5799558
E-mail: allan@asix.com.tw 
https://www.asix.com.tw/ 



-----Original Message-----
From: David Miller <davem@davemloft.net> 
Sent: Tuesday, June 16, 2020 3:52 AM
To: jk@ozlabs.org
Cc: netdev@vger.kernel.org; allan@asix.com.tw; freddy@asix.com.tw; pfink@christ-es.de; linux-usb@vger.kernel.org
Subject: Re: [PATCH] net: usb: ax88179_178a: fix packet alignment padding

From: Jeremy Kerr <jk@ozlabs.org>
Date: Mon, 15 Jun 2020 10:54:56 +0800

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

Does this happen for non-tail packets in a multi-packet cluster?

Because that code in this loop makes the same calculations:

		ax_skb = skb_clone(skb, GFP_ATOMIC);
		if (ax_skb) {
			ax_skb->len = pkt_len;
			ax_skb->data = skb->data + 2;
			skb_set_tail_pointer(ax_skb, pkt_len);
			ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
			ax88179_rx_checksum(ax_skb, pkt_hdr);
			usbnet_skb_return(dev, ax_skb);

So if your change is right, it should be applied to this code block as well.

And do we know that it's two extra tail bytes always?  Or some kind of alignment padding the chip performs for every sub-packet?

