Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC33828A236
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731236AbgJJWzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732141AbgJJTkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:40:19 -0400
X-Greylist: delayed 611 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 10 Oct 2020 07:49:49 PDT
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D24C05BD21;
        Sat, 10 Oct 2020 07:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602340784;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Klr+mZsfIJkJvgRYeQuYBHf9OEE3IUqAY+xpDN72fV4=;
        b=l/2Y2fEyqU8vJHN35tYPUoXyoWVrVYmvFWG+WK101KdaVq84S3TLlc64AHRgPBxFep
        UM61IOZrejzdilsA7ROiNZyInxIK9WFky0ZCYtEJXTpejGUngiGU5IS+f8EYtZ3M7GPt
        0B5dsqxmw1+78CJb9H5LbILXWltI9lUwXPGdJChZ2VccaqyftgQZR2hqT9noCHCzFjWR
        CymS++d4kQy1s43+cNCP8xQvjBf00u/T342l8KSHWZ8MBxeaB6kO/mAYtALaSP+vFyCg
        iK/lcLvMmCcRduKRv4g1+f0CyK9qbO2zxOB9O8CzaDAr0neOHYbhmryDAM8nvKdnbOPR
        zAMw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3HMbEWLW0JK2wEH"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9AETBLvX
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 10 Oct 2020 16:29:11 +0200 (CEST)
Subject: Re: [PATCH 08/17] can: add ISO 15765-2:2016 transport protocol
To:     Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
References: <20201007213159.1959308-1-mkl@pengutronix.de>
 <20201007213159.1959308-9-mkl@pengutronix.de>
 <20201009175751.5c54097f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <bcebf26e-3cfb-c7aa-e7fc-4faa744b9c2f@hartkopp.net>
Date:   Sat, 10 Oct 2020 16:29:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201009175751.5c54097f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.10.20 02:57, Jakub Kicinski wrote:
> On Wed,  7 Oct 2020 23:31:50 +0200 Marc Kleine-Budde wrote:
>> From: Oliver Hartkopp <socketcan@hartkopp.net>
>>
>> CAN Transport Protocols offer support for segmented Point-to-Point
>> communication between CAN nodes via two defined CAN Identifiers.
>> As CAN frames can only transport a small amount of data bytes
>> (max. 8 bytes for 'classic' CAN and max. 64 bytes for CAN FD) this
>> segmentation is needed to transport longer PDUs as needed e.g. for
>> vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN traffic.
>> This protocol driver implements data transfers according to
>> ISO 15765-2:2016 for 'classic' CAN and CAN FD frame types.
> 
> A few random things jump out here at a quick scan. Most of them are
> not important enough to have to be addressed, but please follow up on
> the 'default y' thing ASAP.
> 
>> +/*
>> + * Remark on CAN_ISOTP_DEFAULT_RECV_* values:
>> + *
>> + * We can strongly assume, that the Linux Kernel implementation of
>> + * CAN_ISOTP is capable to run with BS=0, STmin=0 and WFTmax=0.
>> + * But as we like to be able to behave as a commonly available ECU,
>> + * these default settings can be changed via sockopts.
>> + * For that reason the STmin value is intentionally _not_ checked for
>> + * consistency and copied directly into the flow control (FC) frame.
>> + *
> 
> spurious empty comment line
> 

Oh, yes - at the front and at the end. I will fix that.

>> + */
>> +
>> +#endif /* !_UAPI_CAN_ISOTP_H */
>> diff --git a/net/can/Kconfig b/net/can/Kconfig
>> index 25436a715db3..021fe03a8ed6 100644
>> --- a/net/can/Kconfig
>> +++ b/net/can/Kconfig
>> @@ -55,6 +55,19 @@ config CAN_GW
>>   
>>   source "net/can/j1939/Kconfig"
>>   
>> +config CAN_ISOTP
>> +	tristate "ISO 15765-2:2016 CAN transport protocol"
>> +	default y
> 
> default should not be y unless there is a very good reason.
> I don't see such reason here. This is new functionality, users
> can enable it if they need it.
> 

Yes. I agree. But there is a good reason for it.
The ISO 15765-2 protocol is used for vehicle diagnosis and is a *very* 
common CAN bus use case.

The config item only shows up when CONFIG_CAN is selected and then ISO 
15765-2 should be enabled too. I have implemented and maintained the 
out-of-tree driver for ~12 years now and the people have real problems 
using e.g. Ubuntu with signed kernel modules when they need this protocol.

Therefore the option should default to 'y' to make sure the common 
distros (that enable CONFIG_CAN) enable ISO-TP too.

>> +	help
>> +	  CAN Transport Protocols offer support for segmented Point-to-Point
>> +	  communication between CAN nodes via two defined CAN Identifiers.
>> +	  As CAN frames can only transport a small amount of data bytes
>> +	  (max. 8 bytes for 'classic' CAN and max. 64 bytes for CAN FD) this
>> +	  segmentation is needed to transport longer PDUs as needed e.g. for
>> +	  vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN traffic.
>> +	  This protocol driver implements data transfers according to
>> +	  ISO 15765-2:2016 for 'classic' CAN and CAN FD frame types.
>> +
>>   source "drivers/net/can/Kconfig"
>>   
>>   endif
> 
>> +#define CAN_ISOTP_VERSION "20200928"
> 
> We've been removing such version strings throughout the drivers.
> Kernel version should be sufficient for in-tree modules.

Yes. Good point.
I will send a separate patch which removes all the VERSION information 
from the entire CAN bus subsystem (core, raw, bcm, gw).

>> +static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
>> +{
>> +	struct isotp_sock *so = container_of(hrtimer, struct isotp_sock,
>> +					     txtimer);
>> +	struct sock *sk = &so->sk;
>> +	struct sk_buff *skb;
>> +	struct net_device *dev;
>> +	struct canfd_frame *cf;
>> +	enum hrtimer_restart restart = HRTIMER_NORESTART;
>> +	int can_send_ret;
>> +	int ae = (so->opt.flags & CAN_ISOTP_EXTEND_ADDR) ? 1 : 0;
>> +
>> +	switch (so->tx.state) {
>> +	case ISOTP_WAIT_FC:
>> +	case ISOTP_WAIT_FIRST_FC:
>> +
>> +		/* we did not get any flow control frame in time */
>> +
>> +		/* report 'communication error on send' */
>> +		sk->sk_err = ECOMM;
>> +		if (!sock_flag(sk, SOCK_DEAD))
>> +			sk->sk_error_report(sk);
>> +
>> +		/* reset tx state */
>> +		so->tx.state = ISOTP_IDLE;
>> +		wake_up_interruptible(&so->wait);
>> +		break;
>> +
>> +	case ISOTP_SENDING:
>> +
>> +		/* push out the next segmented pdu */
>> +		dev = dev_get_by_index(sock_net(sk), so->ifindex);
>> +		if (!dev)
>> +			break;
>> +
>> +isotp_tx_burst:
>> +		skb = alloc_skb(so->ll.mtu + sizeof(struct can_skb_priv),
>> +				gfp_any());
> 
> This is always in a timer context, so no need for gfp_any(), right?
> 

Some code from the time where hrtimer was only in hard-irq context. Will 
fix that too.

>> +		if (!skb) {
>> +			dev_put(dev);
>> +			break;
>> +		}
>> +
>> +		can_skb_reserve(skb);
>> +		can_skb_prv(skb)->ifindex = dev->ifindex;
>> +		can_skb_prv(skb)->skbcnt = 0;
>> +
>> +		cf = (struct canfd_frame *)skb->data;
>> +		skb_put(skb, so->ll.mtu);
>> +
>> +		/* create consecutive frame */
>> +		isotp_fill_dataframe(cf, so, ae, 0);
>> +
>> +		/* place consecutive frame N_PCI in appropriate index */
>> +		cf->data[ae] = N_PCI_CF | so->tx.sn++;
>> +		so->tx.sn %= 16;
>> +		so->tx.bs++;
>> +
>> +		if (so->ll.mtu == CANFD_MTU)
>> +			cf->flags = so->ll.tx_flags;
>> +
>> +		skb->dev = dev;
>> +		can_skb_set_owner(skb, sk);
>> +
>> +		can_send_ret = can_send(skb, 1);
>> +		if (can_send_ret)
>> +			printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
>> +				    __func__, can_send_ret);
> 
> pr_notice_once()

Ok. Will change that at the several occurrences.

>> +
>> +		if (so->tx.idx >= so->tx.len) {
>> +			/* we are done */
>> +			so->tx.state = ISOTP_IDLE;
>> +			dev_put(dev);
>> +			wake_up_interruptible(&so->wait);
>> +			break;
>> +		}
>> +
>> +		if (so->txfc.bs && so->tx.bs >= so->txfc.bs) {
>> +			/* stop and wait for FC */
>> +			so->tx.state = ISOTP_WAIT_FC;
>> +			dev_put(dev);
>> +			hrtimer_set_expires(&so->txtimer,
>> +					    ktime_add(ktime_get(),
>> +						      ktime_set(1, 0)));
>> +			restart = HRTIMER_RESTART;
>> +			break;
>> +		}
>> +
>> +		/* no gap between data frames needed => use burst mode */
>> +		if (!so->tx_gap)
>> +			goto isotp_tx_burst;
>> +
>> +		/* start timer to send next data frame with correct delay */
>> +		dev_put(dev);
>> +		hrtimer_set_expires(&so->txtimer,
>> +				    ktime_add(ktime_get(), so->tx_gap));
>> +		restart = HRTIMER_RESTART;
>> +		break;
>> +
>> +	default:
>> +		WARN_ON_ONCE(1);
>> +	}
>> +
>> +	return restart;
>> +}

Thanks for the review!

Will send the patches for the net-next tree later this day.

Best regards,
Oliver
