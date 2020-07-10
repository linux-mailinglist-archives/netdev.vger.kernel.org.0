Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDD321C0B3
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 01:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGJX0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 19:26:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:50398 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgGJX0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 19:26:21 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ju2PI-0007Ri-NC; Sat, 11 Jul 2020 01:26:16 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ju2PI-000JHs-H4; Sat, 11 Jul 2020 01:26:16 +0200
Subject: Re: [PATCH bpf v2] xsk: fix memory leak and packet loss in Tx skb
 path
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     A.Zema@falconvsystems.com
References: <1594363554-4076-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3e42533f-fb6e-d6fa-af48-cb7f5c70890b@iogearbox.net>
Date:   Sat, 11 Jul 2020 01:26:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1594363554-4076-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25869/Fri Jul 10 16:01:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Magnus,

On 7/10/20 8:45 AM, Magnus Karlsson wrote:
> In the skb Tx path, transmission of a packet is performed with
> dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> routines, it returns NETDEV_TX_BUSY signifying that it was not
> possible to send the packet now, please try later. Unfortunately, the
> xsk transmit code discarded the packet, missed to free the skb, and
> returned EBUSY to the application. Fix this memory leak and
> unnecessary packet loss, by not discarding the packet in the Tx ring,
> freeing the allocated skb, and return EAGAIN. As EAGAIN is returned to the
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
> ---
> The v1 of this patch was called "xsk: do not discard packet when
> QUEUE_STATE_FROZEN".
> ---
>   net/xdp/xsk.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 3700266..5304250 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -376,13 +376,22 @@ static int xsk_generic_xmit(struct sock *sk)
>   		skb->destructor = xsk_destruct_skb;
>   
>   		err = dev_direct_xmit(skb, xs->queue_id);
> -		xskq_cons_release(xs->tx);
>   		/* Ignore NET_XMIT_CN as packet might have been sent */
> -		if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> +		if (err == NET_XMIT_DROP) {
>   			/* SKB completed but not sent */
> +			xskq_cons_release(xs->tx);
>   			err = -EBUSY;
>   			goto out;
> +		} else if  (err == NETDEV_TX_BUSY) {
> +			/* QUEUE_STATE_FROZEN, tell application to
> +			 * retry sending the packet
> +			 */
> +			skb->destructor = NULL;
> +			kfree_skb(skb);
> +			err = -EAGAIN;
> +			goto out;

Hmm, I'm probably missing something or I should blame my current lack of coffee,
but I'll ask anyway.. What is the relation here to the kfree_skb{,_list}() in
dev_direct_xmit() when we have NETDEV_TX_BUSY condition? Wouldn't the patch above
double-free with NETDEV_TX_BUSY?

>   		}
> +		xskq_cons_release(xs->tx);
>   
>   		sent_frame = true;
>   	}
> 

Thanks,
Daniel
