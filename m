Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06DA228A1F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgGUUpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:45:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:60430 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgGUUpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:45:52 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jxz93-0008IV-Bb; Tue, 21 Jul 2020 22:45:49 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jxz93-0005cL-63; Tue, 21 Jul 2020 22:45:49 +0200
Subject: Re: [PATCH bpf v3] xsk: do not discard packet when QUEUE_STATE_FROZEN
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     A.Zema@falconvsystems.com
References: <1595253183-14935-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <851cef2d-173d-859e-f2d5-5949a4fe2619@iogearbox.net>
Date:   Tue, 21 Jul 2020 22:45:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1595253183-14935-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25880/Tue Jul 21 16:34:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/20 3:53 PM, Magnus Karlsson wrote:
> In the skb Tx path, transmission of a packet is performed with
> dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> routines, it returns NETDEV_TX_BUSY signifying that it was not
> possible to send the packet now, please try later. Unfortunately, the
> xsk transmit code discarded the packet and returned EBUSY to the
> application. Fix this unnecessary packet loss, by not discarding the
> packet in the Tx ring and return EAGAIN. As EAGAIN is returned to the
> application, it can then retry the send operation and the packet will
> finally be sent as we will likely not be in the QUEUE_STATE_FROZEN
> state anymore. So EAGAIN tells the application that the packet was not
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
> v1->v3:
> * Hinder dev_direct_xmit() from freeing and completing the packet to
>    user space by manipulating the skb->users count as suggested by
>    Daniel Borkmann.
> ---
>   net/xdp/xsk.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 3700266..9e95c85 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -375,10 +375,23 @@ static int xsk_generic_xmit(struct sock *sk)
>   		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
>   		skb->destructor = xsk_destruct_skb;
>   
> +		/* Hinder dev_direct_xmit from freeing the packet and
> +		 * therefore completing it in the destructor
> +		 */
> +		refcount_inc(&skb->users);
>   		err = dev_direct_xmit(skb, xs->queue_id);
> +		if  (err == NETDEV_TX_BUSY) {
> +			/* QUEUE_STATE_FROZEN, tell app to retry the send */
> +			skb->destructor = NULL;
> +			kfree_skb(skb);
> +			err = -EAGAIN;
> +			goto out;
> +		}
> +
>   		xskq_cons_release(xs->tx);
> +		kfree_skb(skb);

What happens if this was properly 'consumed'. If you call kfree_skb() for these pkts,
then doesn't this confuse perf drop monitor with false positives?

>   		/* Ignore NET_XMIT_CN as packet might have been sent */
> -		if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> +		if (err == NET_XMIT_DROP) {
>   			/* SKB completed but not sent */
>   			err = -EBUSY;
>   			goto out;
> 

