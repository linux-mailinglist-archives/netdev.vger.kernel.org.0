Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D587289CFA
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 03:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgJJBS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 21:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729301AbgJJBBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 21:01:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAEB72076E;
        Sat, 10 Oct 2020 00:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602291472;
        bh=Xi+GuY+Ub0nJOsqlOxa+qb/oTjzimJdgMqtKwE2hq20=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xcieWmrBUjOBeKonPtzEwThjAodRQ9IVSJBcnG5ho7Wb3o6N5ac2gVnL4C0sGHj2U
         NBXnKlyM4M3M2n/p6OKveV0GWyfamse066k6maXOIbIKJNMbU9ESSgi4B6PjdYOGKl
         vHL8P/jNJhwVHqPPSdR/6V9dfOXhZo5ps86c+SrY=
Date:   Fri, 9 Oct 2020 17:57:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH 08/17] can: add ISO 15765-2:2016 transport protocol
Message-ID: <20201009175751.5c54097f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007213159.1959308-9-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
        <20201007213159.1959308-9-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 23:31:50 +0200 Marc Kleine-Budde wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> CAN Transport Protocols offer support for segmented Point-to-Point
> communication between CAN nodes via two defined CAN Identifiers.
> As CAN frames can only transport a small amount of data bytes
> (max. 8 bytes for 'classic' CAN and max. 64 bytes for CAN FD) this
> segmentation is needed to transport longer PDUs as needed e.g. for
> vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN traffic.
> This protocol driver implements data transfers according to
> ISO 15765-2:2016 for 'classic' CAN and CAN FD frame types.

A few random things jump out here at a quick scan. Most of them are 
not important enough to have to be addressed, but please follow up on
the 'default y' thing ASAP.

> +/*
> + * Remark on CAN_ISOTP_DEFAULT_RECV_* values:
> + *
> + * We can strongly assume, that the Linux Kernel implementation of
> + * CAN_ISOTP is capable to run with BS=0, STmin=0 and WFTmax=0.
> + * But as we like to be able to behave as a commonly available ECU,
> + * these default settings can be changed via sockopts.
> + * For that reason the STmin value is intentionally _not_ checked for
> + * consistency and copied directly into the flow control (FC) frame.
> + *

spurious empty comment line

> + */
> +
> +#endif /* !_UAPI_CAN_ISOTP_H */
> diff --git a/net/can/Kconfig b/net/can/Kconfig
> index 25436a715db3..021fe03a8ed6 100644
> --- a/net/can/Kconfig
> +++ b/net/can/Kconfig
> @@ -55,6 +55,19 @@ config CAN_GW
>  
>  source "net/can/j1939/Kconfig"
>  
> +config CAN_ISOTP
> +	tristate "ISO 15765-2:2016 CAN transport protocol"
> +	default y

default should not be y unless there is a very good reason.
I don't see such reason here. This is new functionality, users
can enable it if they need it.

> +	help
> +	  CAN Transport Protocols offer support for segmented Point-to-Point
> +	  communication between CAN nodes via two defined CAN Identifiers.
> +	  As CAN frames can only transport a small amount of data bytes
> +	  (max. 8 bytes for 'classic' CAN and max. 64 bytes for CAN FD) this
> +	  segmentation is needed to transport longer PDUs as needed e.g. for
> +	  vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN traffic.
> +	  This protocol driver implements data transfers according to
> +	  ISO 15765-2:2016 for 'classic' CAN and CAN FD frame types.
> +
>  source "drivers/net/can/Kconfig"
>  
>  endif

> +#define CAN_ISOTP_VERSION "20200928"

We've been removing such version strings throughout the drivers.
Kernel version should be sufficient for in-tree modules.

> +static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
> +{
> +	struct isotp_sock *so = container_of(hrtimer, struct isotp_sock,
> +					     txtimer);
> +	struct sock *sk = &so->sk;
> +	struct sk_buff *skb;
> +	struct net_device *dev;
> +	struct canfd_frame *cf;
> +	enum hrtimer_restart restart = HRTIMER_NORESTART;
> +	int can_send_ret;
> +	int ae = (so->opt.flags & CAN_ISOTP_EXTEND_ADDR) ? 1 : 0;
> +
> +	switch (so->tx.state) {
> +	case ISOTP_WAIT_FC:
> +	case ISOTP_WAIT_FIRST_FC:
> +
> +		/* we did not get any flow control frame in time */
> +
> +		/* report 'communication error on send' */
> +		sk->sk_err = ECOMM;
> +		if (!sock_flag(sk, SOCK_DEAD))
> +			sk->sk_error_report(sk);
> +
> +		/* reset tx state */
> +		so->tx.state = ISOTP_IDLE;
> +		wake_up_interruptible(&so->wait);
> +		break;
> +
> +	case ISOTP_SENDING:
> +
> +		/* push out the next segmented pdu */
> +		dev = dev_get_by_index(sock_net(sk), so->ifindex);
> +		if (!dev)
> +			break;
> +
> +isotp_tx_burst:
> +		skb = alloc_skb(so->ll.mtu + sizeof(struct can_skb_priv),
> +				gfp_any());

This is always in a timer context, so no need for gfp_any(), right?

> +		if (!skb) {
> +			dev_put(dev);
> +			break;
> +		}
> +
> +		can_skb_reserve(skb);
> +		can_skb_prv(skb)->ifindex = dev->ifindex;
> +		can_skb_prv(skb)->skbcnt = 0;
> +
> +		cf = (struct canfd_frame *)skb->data;
> +		skb_put(skb, so->ll.mtu);
> +
> +		/* create consecutive frame */
> +		isotp_fill_dataframe(cf, so, ae, 0);
> +
> +		/* place consecutive frame N_PCI in appropriate index */
> +		cf->data[ae] = N_PCI_CF | so->tx.sn++;
> +		so->tx.sn %= 16;
> +		so->tx.bs++;
> +
> +		if (so->ll.mtu == CANFD_MTU)
> +			cf->flags = so->ll.tx_flags;
> +
> +		skb->dev = dev;
> +		can_skb_set_owner(skb, sk);
> +
> +		can_send_ret = can_send(skb, 1);
> +		if (can_send_ret)
> +			printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
> +				    __func__, can_send_ret);

pr_notice_once()

> +
> +		if (so->tx.idx >= so->tx.len) {
> +			/* we are done */
> +			so->tx.state = ISOTP_IDLE;
> +			dev_put(dev);
> +			wake_up_interruptible(&so->wait);
> +			break;
> +		}
> +
> +		if (so->txfc.bs && so->tx.bs >= so->txfc.bs) {
> +			/* stop and wait for FC */
> +			so->tx.state = ISOTP_WAIT_FC;
> +			dev_put(dev);
> +			hrtimer_set_expires(&so->txtimer,
> +					    ktime_add(ktime_get(),
> +						      ktime_set(1, 0)));
> +			restart = HRTIMER_RESTART;
> +			break;
> +		}
> +
> +		/* no gap between data frames needed => use burst mode */
> +		if (!so->tx_gap)
> +			goto isotp_tx_burst;
> +
> +		/* start timer to send next data frame with correct delay */
> +		dev_put(dev);
> +		hrtimer_set_expires(&so->txtimer,
> +				    ktime_add(ktime_get(), so->tx_gap));
> +		restart = HRTIMER_RESTART;
> +		break;
> +
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +
> +	return restart;
> +}
