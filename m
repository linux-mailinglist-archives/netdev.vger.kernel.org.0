Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2B530A500
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhBAKIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:08:17 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:13925 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbhBAKHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:07:13 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1l6W5A-000FbA-30; Mon, 01 Feb 2021 11:05:20 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1l6W59-000MEB-9l; Mon, 01 Feb 2021 11:05:19 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id B9319240041;
        Mon,  1 Feb 2021 11:05:18 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 410C1240040;
        Mon,  1 Feb 2021 11:05:18 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 894E8202DE;
        Mon,  1 Feb 2021 11:05:16 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 11:05:16 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: lapb: Copy the skb before sending a packet
Organization: TDT AG
In-Reply-To: <20210201055706.415842-1-xie.he.0141@gmail.com>
References: <20210201055706.415842-1-xie.he.0141@gmail.com>
Message-ID: <204c18e95caf2ae84fb567dd4be0c3ac@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate-ID: 151534::1612173919-00007CCF-2A7DB75F/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-01 06:57, Xie He wrote:
> When sending a packet, we will prepend it with an LAPB header.
> This modifies the shared parts of a cloned skb, so we should copy the
> skb rather than just clone it, before we prepend the header.
> 
> In "Documentation/networking/driver.rst" (the 2nd point), it states
> that drivers shouldn't modify the shared parts of a cloned skb when
> transmitting.
> 
> The "dev_queue_xmit_nit" function in "net/core/dev.c", which is called
> when an skb is being sent, clones the skb and sents the clone to
> AF_PACKET sockets. Because the LAPB drivers first remove a 1-byte
> pseudo-header before handing over the skb to us, if we don't copy the
> skb before prepending the LAPB header, the first byte of the packets
> received on AF_PACKET sockets can be corrupted.

What kind of packages do you mean are corrupted?
ETH_P_X25 or ETH_P_HDLC?

I have also sent a patch here in the past that addressed corrupted
ETH_P_X25 frames on an AF_PACKET socket:

https://lkml.org/lkml/2020/1/13/388

Unfortunately I could not track and describe exactly where the problem
was.

I just wonder when/where is the logically correct place to copy the skb.
Shouldn't it be copied before removing the pseudo header (as I did in my
patch)?

> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  net/lapb/lapb_out.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/lapb/lapb_out.c b/net/lapb/lapb_out.c
> index 7a4d0715d1c3..a966d29c772d 100644
> --- a/net/lapb/lapb_out.c
> +++ b/net/lapb/lapb_out.c
> @@ -82,7 +82,8 @@ void lapb_kick(struct lapb_cb *lapb)
>  		skb = skb_dequeue(&lapb->write_queue);
> 
>  		do {
> -			if ((skbn = skb_clone(skb, GFP_ATOMIC)) == NULL) {
> +			skbn = skb_copy(skb, GFP_ATOMIC);
> +			if (!skbn) {
>  				skb_queue_head(&lapb->write_queue, skb);
>  				break;
>  			}
