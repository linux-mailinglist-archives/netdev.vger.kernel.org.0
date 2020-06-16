Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84091FABE5
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 11:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgFPJI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 05:08:27 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46947 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgFPJI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 05:08:27 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49mMn40N2Nz9sR4;
        Tue, 16 Jun 2020 19:08:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1592298505; bh=u1FRa3Ay1JFMfOQ5OAd+l2EnGRttEMM/Y3auoqc9gak=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YYh3cpSOIs3PAB7FdMmy+XjumRkKpExTM1htZKx87R14wjigHoOHPtF5WHixWm2ll
         k2xJU33UBJJyWpn85sfJXlqsGPbE29Xrd02lqJTTmb33tPYw3edMwTrYjgxC9HcY1z
         0obdT9BRY60sYJG0fZhJ8Q9mH3dZp/ROlYBDnE73llyAuCcdYa3ErXGiHIL2Nc/fDG
         g2YrvosbyPiACGmtaNAuAeWZOLn2xV7cuqGZq+Iz/3s/2UFSdv224xeETM6Fi+WfX4
         sJndU39bXHDsBYak+hajaoROeeUF9o03PHdJ6A2CwWGPzEOzenCdNyWEMooEA3cEEX
         Ks6XVWtyBhBzA==
Message-ID: <e780f13fdde89d03ef863618d8de3dd67ba53c72.camel@ozlabs.org>
Subject: Re: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
From:   Jeremy Kerr <jk@ozlabs.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, allan@asix.com.tw, freddy@asix.com.tw,
        pfink@christ-es.de, linux-usb@vger.kernel.org, louis@asix.com.tw
Date:   Tue, 16 Jun 2020 17:08:23 +0800
In-Reply-To: <20200615.125220.492630206908309571.davem@davemloft.net>
References: <20200615025456.30219-1-jk@ozlabs.org>
         <20200615.125220.492630206908309571.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> > Those last two bytes - 96 1f - aren't part of the original packet.
> 
> Does this happen for non-tail packets in a multi-packet cluster?

I believe so, yes. I haven't been able to reliably reproduce the multi-
packet behaviour though, so input from ASIX would be good.

> 
> Because that code in this loop makes the same calculations:
> 
>                 ax_skb = skb_clone(skb, GFP_ATOMIC);
>                 if (ax_skb) {
>                         ax_skb->len = pkt_len;
>                         ax_skb->data = skb->data + 2;
>                         skb_set_tail_pointer(ax_skb, pkt_len);
>                         ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
>                         ax88179_rx_checksum(ax_skb, pkt_hdr);
>                         usbnet_skb_return(dev, ax_skb);
> 
> So if your change is right, it should be applied to this code block
> as well.

Yep, my patch changes that block too (or did I miss something?)

> And do we know that it's two extra tail bytes always?  Or some kind
> of alignment padding the chip performs for every sub-packet?

I've assumed it's a constant two bytes of prefix padding, as that's all
I've seen. But it would be great to have more detail from ASIX if
possible.

Cheers,


Jeremy

