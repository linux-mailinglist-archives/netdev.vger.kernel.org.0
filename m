Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483901FA0CC
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgFOTw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbgFOTw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:52:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADD9C061A0E;
        Mon, 15 Jun 2020 12:52:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A972120ED483;
        Mon, 15 Jun 2020 12:52:23 -0700 (PDT)
Date:   Mon, 15 Jun 2020 12:52:20 -0700 (PDT)
Message-Id: <20200615.125220.492630206908309571.davem@davemloft.net>
To:     jk@ozlabs.org
Cc:     netdev@vger.kernel.org, allan@asix.com.tw, freddy@asix.com.tw,
        pfink@christ-es.de, linux-usb@vger.kernel.org
Subject: Re: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200615025456.30219-1-jk@ozlabs.org>
References: <20200615025456.30219-1-jk@ozlabs.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 12:52:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>
Date: Mon, 15 Jun 2020 10:54:56 +0800

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

So if your change is right, it should be applied to this code block as
well.

And do we know that it's two extra tail bytes always?  Or some kind of
alignment padding the chip performs for every sub-packet?
