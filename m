Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAFF31B660
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 10:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhBOJ0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 04:26:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230138AbhBOJZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 04:25:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C18D64DEE;
        Mon, 15 Feb 2021 09:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613381104;
        bh=bfvSPlI4bOZ5PvYmk6nN5TYccj5PzjzSAJoKeX5M+pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IsVSG/ZQlyd3wQIjwsnY7ygCfS7ysRv9A+Ob9FzgzshzMdDYHLLkq1fMqfY9V4Eh+
         krxug0eXpQ8WUGpTDTadVv8b1g5VmtMXJJUxMdqvGt9Bd18vAg4vuGO4zorNFKsoXC
         6ggLrJgwjwm5aCJCyivNtnA/NeilemdN/K6Rhzv9TenICLwmknzcFQoNxUXxh67gFp
         Vl4DPPVbcHJTFmNujzI48TeJwYL9r8kVjYYUu+i5rPC8LLNhiG4Fj3umATIHDzHaC0
         hMsgPacItYgC3UBFeUmOrzL5TnDzy03/frRDtMOVdqJa/i9/NkgbiP1dd4YjSV2sJ2
         Fv01A+YBJF6wA==
Date:   Mon, 15 Feb 2021 11:24:59 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net-next RFC v3] net: hdlc_x25: Queue outgoing LAPB frames
Message-ID: <YCo96zjXHyvKpbUM@unreal>
References: <20210215072703.43952-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215072703.43952-1-xie.he.0141@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 11:27:03PM -0800, Xie He wrote:
> When sending packets, we will first hand over the (L3) packets to the
> LAPB module. The LAPB module will then hand over the corresponding LAPB
> (L2) frames back to us for us to transmit.
>
> The LAPB module can also emit LAPB (L2) frames at any time, even without
> an (L3) packet currently being sent on the device. This happens when the
> LAPB module tries to send (L3) packets queued up in its internal queue,
> or when the LAPB module decides to send some (L2) control frame.
>
> This means we need to have a queue for these outgoing LAPB (L2) frames,
> otherwise frames can be dropped if sent when the hardware driver is
> already busy in transmitting. The queue needs to be controlled by
> the hardware driver's netif_stop_queue and netif_wake_queue calls.
> Therefore, we need to use the device's qdisc TX queue for this purpose.
> However, currently outgoing LAPB (L2) frames are not queued.
>
> On the other hand, outgoing (L3) packets (before they are handed over
> to the LAPB module) don't need to be queued, because the LAPB module
> already has an internal queue for them, and is able to queue new outgoing
> (L3) packets at any time. However, currently outgoing (L3) packets are
> being queued in the device's qdisc TX queue, which is controlled by
> the hardware driver's netif_stop_queue and netif_wake_queue calls.
> This is unnecessary and meaningless.
>
> To fix these issues, we can split the HDLC device into two devices -
> a virtual X.25 device and the actual HDLC device, use the virtual X.25
> device to send (L3) packets and then use the actual HDLC device to
> queue LAPB (L2) frames. The outgoing (L2) LAPB queue will be controlled
> by the hardware driver's netif_stop_queue and netif_wake_queue calls,
> while outgoing (L3) packets will not be affected by these calls.
>
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>
> Change from RFC v2:
> Simplified the commit message.
> Dropped the x25_open fix which is already merged into net-next now.
> Use HDLC_MAX_MTU as the mtu of the X.25 virtual device.
> Add an explanation to the documentation about the X.25 virtual device.
>
> Change from RFC v1:
> Properly initialize state(hdlc)->x25_dev and state(hdlc)->x25_dev_lock.
>
> ---
>  Documentation/networking/generic-hdlc.rst |   3 +
>  drivers/net/wan/hdlc_x25.c                | 153 ++++++++++++++++++----
>  2 files changed, 130 insertions(+), 26 deletions(-)

<...>

> +static void x25_setup_virtual_dev(struct net_device *dev)
> +{
> +	dev->netdev_ops	     = &hdlc_x25_netdev_ops;
> +	dev->type            = ARPHRD_X25;
> +	dev->addr_len        = 0;
> +	dev->hard_header_len = 0;
> +	dev->mtu             = HDLC_MAX_MTU;
> +
> +	/* When transmitting data:
> +	 * first we'll remove a pseudo header of 1 byte,
> +	 * then the LAPB module will prepend an LAPB header of at most 3 bytes.
> +	 */
> +	dev->needed_headroom = 3 - 1;

3 - 1 = 2

Thanks

> +}
> +
