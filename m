Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BD931E7D6
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 10:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBRJC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 04:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhBRI63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 03:58:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68C0664E5F;
        Thu, 18 Feb 2021 08:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613638668;
        bh=6GtbGlAX6Mbf/kMITEngl0gUaeUwRF/jO9DRYqyKbk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mRCUd2lo2cw7mdhIqHG399NclM3WiKASF7l2431Mv+iNMiQ010b2chCgc5il3jLAL
         zxkYudv+mBZeklp8sJmaOaagcvK1+IbJsggp/QTWn30foR+CGLSqUKmnMKjcSdyYSc
         vkutXwN5odtIs7KNueruDjyPdaH2YBdUnAh8ozlhBtDYVJ0H/2V6iP37ePFkIYtg4a
         NvieuXQ46lRz4A27h4guupaXkhS81mG5UdMN4R2iznJMIvioaVmKs1XcH/tOCHcwfd
         aREdks3g9ZeuXTlO2nmHkFEgqLqNl5d6O3l9qWJVPxs2HkfGMVNa2pY/Tn5Ia3fJGT
         9Oth6BjtaGfrQ==
Date:   Thu, 18 Feb 2021 10:57:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
Message-ID: <YC4sB9OCl5mm3JAw@unreal>
References: <20210216201813.60394-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216201813.60394-1-xie.he.0141@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 12:18:13PM -0800, Xie He wrote:
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

It is nice that you are resending your patch without the resolution.
However it will be awesome if you don't ignore review comments and fix this "3 - 1"
by writing solid comment above.

Thanks and good luck.
