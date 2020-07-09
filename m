Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1562F21A568
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgGIREK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:04:10 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:40666 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgGIREK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 13:04:10 -0400
Received: (qmail 23236 invoked by uid 89); 9 Jul 2020 17:03:59 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 9 Jul 2020 17:03:59 -0000
Date:   Thu, 9 Jul 2020 10:03:56 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, A.Zema@falconvsystems.com
Subject: Re: [PATCH bpf] xsk: do not discard packet when QUEUE_STATE_FROZEN
Message-ID: <20200709170356.pivsunwnk57jm4kr@bsd-mbp.dhcp.thefacebook.com>
References: <1594287951-27479-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594287951-27479-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:45:51AM +0200, Magnus Karlsson wrote:
> In the skb Tx path, transmission of a packet is performed with
> dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> routines, it returns NETDEV_TX_BUSY signifying that it was not
> possible to send the packet now, please try later. Unfortunately, the
> xsk transmit code discarded the packet and returned EBUSY to the
> application. Fix this unnecessary packet loss, by not discarding the
> packet and return EAGAIN. As EAGAIN is returned to the application, it
> can then retry the send operation and the packet will finally be sent
> as we will likely not be in the QUEUE_STATE_FROZEN state anymore. So
> EAGAIN tells the application that the packet was not discarded from
> the Tx ring and that it needs to call send() again. EBUSY, on the
> other hand, signifies that the packet was not sent and discarded from
> the Tx ring. The application needs to put the packet on the Tx ring
> again if it wants it to be sent.

Doesn't the original code leak the skb if NETDEV_TX_BUSY is returned?
I'm not seeing where it was released.  The new code looks correct.


> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> ---
>  net/xdp/xsk.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 3700266..5304250 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -376,13 +376,22 @@ static int xsk_generic_xmit(struct sock *sk)
>  		skb->destructor = xsk_destruct_skb;
>  
>  		err = dev_direct_xmit(skb, xs->queue_id);
> -		xskq_cons_release(xs->tx);
>  		/* Ignore NET_XMIT_CN as packet might have been sent */
> -		if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> +		if (err == NET_XMIT_DROP) {
>  			/* SKB completed but not sent */
> +			xskq_cons_release(xs->tx);
>  			err = -EBUSY;
>  			goto out;
> +		} else if  (err == NETDEV_TX_BUSY) {

Should be "if (err == ..." here, no else.


> +			/* QUEUE_STATE_FROZEN, tell application to
> +			 * retry sending the packet
> +			 */
> +			skb->destructor = NULL;
> +			kfree_skb(skb);
> +			err = -EAGAIN;
> +			goto out;
>  		}
> +		xskq_cons_release(xs->tx);
>  
>  		sent_frame = true;
>  	}
> -- 
> 2.7.4
> 
