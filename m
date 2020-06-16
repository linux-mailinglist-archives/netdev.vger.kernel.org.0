Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B081FC04A
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgFPUzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgFPUzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 16:55:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F3FC061573;
        Tue, 16 Jun 2020 13:55:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A163128D80DE;
        Tue, 16 Jun 2020 13:55:36 -0700 (PDT)
Date:   Tue, 16 Jun 2020 13:55:35 -0700 (PDT)
Message-Id: <20200616.135535.379478681934951754.davem@davemloft.net>
To:     jk@ozlabs.org
Cc:     netdev@vger.kernel.org, allan@asix.com.tw, freddy@asix.com.tw,
        pfink@christ-es.de, linux-usb@vger.kernel.org, louis@asix.com.tw
Subject: Re: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e780f13fdde89d03ef863618d8de3dd67ba53c72.camel@ozlabs.org>
References: <20200615025456.30219-1-jk@ozlabs.org>
        <20200615.125220.492630206908309571.davem@davemloft.net>
        <e780f13fdde89d03ef863618d8de3dd67ba53c72.camel@ozlabs.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jun 2020 13:55:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>
Date: Tue, 16 Jun 2020 17:08:23 +0800

>> Because that code in this loop makes the same calculations:
>> 
>>                 ax_skb = skb_clone(skb, GFP_ATOMIC);
>>                 if (ax_skb) {
>>                         ax_skb->len = pkt_len;
>>                         ax_skb->data = skb->data + 2;
>>                         skb_set_tail_pointer(ax_skb, pkt_len);
>>                         ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
>>                         ax88179_rx_checksum(ax_skb, pkt_hdr);
>>                         usbnet_skb_return(dev, ax_skb);
>> 
>> So if your change is right, it should be applied to this code block
>> as well.
> 
> Yep, my patch changes that block too (or did I miss something?)

Nope, you didn't miss anything.  I missed that completely.

>> And do we know that it's two extra tail bytes always?  Or some kind
>> of alignment padding the chip performs for every sub-packet?
> 
> I've assumed it's a constant two bytes of prefix padding, as that's all
> I've seen. But it would be great to have more detail from ASIX if
> possible.

I'll wait a bit for the ASIX folks to comment.

It seems logical to me that what the chip does is align up the total
sub-packet length to a multiple of 4 or larger, and then add those two
prefix padding bytes.  Otherwise the prefix padding won't necessarily
and reliably align the IP header after the link level header.

Thanks.
