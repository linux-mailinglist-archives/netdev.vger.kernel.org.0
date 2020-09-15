Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0413326B215
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgIOWlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbgIOP5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 11:57:53 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFF6C061352
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 08:50:42 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kIDD3-0002c1-5I; Tue, 15 Sep 2020 17:49:33 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kIDD2-000VJk-Us; Tue, 15 Sep 2020 17:49:32 +0200
Subject: Re: [PATCH bpf v4] xsk: do not discard packet when NETDEV_TX_BUSY
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     A.Zema@falconvsystems.com
References: <1599828221-19364-1-git-send-email-magnus.karlsson@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6e58cde8-9e38-079a-589d-7b7a860ef61e@iogearbox.net>
Date:   Tue, 15 Sep 2020 17:49:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1599828221-19364-1-git-send-email-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25930/Tue Sep 15 15:55:28 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Magnus,

On 9/11/20 2:43 PM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> In the skb Tx path, transmission of a packet is performed with
> dev_direct_xmit(). When NETDEV_TX_BUSY is set in the drivers, it
> signifies that it was not possible to send the packet right now,
> please try later. Unfortunately, the xsk transmit code discarded the
> packet and returned EBUSY to the application. Fix this unnecessary
> packet loss, by not discarding the packet in the Tx ring and return
> EAGAIN. As EAGAIN is returned to the application, it can then retry
> the send operation later and the packet will then likely be sent as
> the driver will then likely have space/resources to send the packet.
> 
> In summary, EAGAIN tells the application that the packet was not
> discarded from the Tx ring and that it needs to call send()
> again. EBUSY, on the other hand, signifies that the packet was not
> sent and discarded from the Tx ring. The application needs to put the
> packet on the Tx ring again if it wants it to be sent.
> 
> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
> v3->v4:
> * Free the skb without triggering the drop trace when NETDEV_TX_BUSY
> * Call consume_skb instead of kfree_skb when the packet has been
>    sent successfully for correct tracing
> * Use sock_wfree as destructor when NETDEV_TX_BUSY
> v1->v3:
> * Hinder dev_direct_xmit() from freeing and completing the packet to
>    user space by manipulating the skb->users count as suggested by
>    Daniel Borkmann.
> ---
>   net/xdp/xsk.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index c323162..d32e39d 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -377,15 +377,30 @@ static int xsk_generic_xmit(struct sock *sk)
>   		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
>   		skb->destructor = xsk_destruct_skb;
>   
> +		/* Hinder dev_direct_xmit from freeing the packet and
> +		 * therefore completing it in the destructor
> +		 */
> +		refcount_inc(&skb->users);
>   		err = dev_direct_xmit(skb, xs->queue_id);
> +		if  (err == NETDEV_TX_BUSY) {
> +			/* Tell user-space to retry the send */
> +			skb->destructor = sock_wfree;

I see, good catch, you need this one here as otherwise you leak wmem accounting
given it's also part of xsk_destruct_skb() and we do free the prior allocated skb
in this case.

> +			/* Free skb without triggering the perf drop trace */
> +			__kfree_skb(skb);

As a minor nit, I would just use consume_skb(skb) here given this doesn't blindly
ignore the skb_unref(). It's mostly about seeing where drops are happening so that
tracepoint is set to kfree_skb() which is the more interesting one. Other than that
looks good and ready to go. Thanks (& sorry for late reply)!

> +			err = -EAGAIN;
> +			goto out;
> +		}
> +
>   		xskq_cons_release(xs->tx);
>   		/* Ignore NET_XMIT_CN as packet might have been sent */
> -		if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> +		if (err == NET_XMIT_DROP) {
>   			/* SKB completed but not sent */
> +			kfree_skb(skb);
>   			err = -EBUSY;
>   			goto out;
>   		}
>   
> +		consume_skb(skb);
>   		sent_frame = true;
>   	}
>   
> 

