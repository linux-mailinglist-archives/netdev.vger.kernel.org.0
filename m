Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE82C4A3F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732892AbgKYVt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:49:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732851AbgKYVt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 16:49:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACE602083E;
        Wed, 25 Nov 2020 21:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606340967;
        bh=kwlAvwQ9x4w4c8oPPCfGpynB2t32g0wSKIXIqjXmwR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PGGCjppsUSg6q4yK+aIE7KQ6BZ9kyOUsHKRuYbcXLJDZGDAiKEpBmcb3HjyiyyBZU
         eCitBdLNVcCUyna8/Orrjfup3rjcaA/Uvyw30grsZzBBVPulXev50u1Eeleh1oSVNC
         ji3JZFhFt5YHwE8STfvw6Y4jUKFTmD92pmSFwIwM=
Date:   Wed, 25 Nov 2020 13:49:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     andrew.hendry@gmail.com, davem@davemloft.net,
        xie.he.0141@gmail.com, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/5] net/lapb: support netdev events
Message-ID: <20201125134925.26d851f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124093938.22012-3-ms@dev.tdt.de>
References: <20201124093938.22012-1-ms@dev.tdt.de>
        <20201124093938.22012-3-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 10:39:35 +0100 Martin Schiller wrote:
> This patch allows layer2 (LAPB) to react to netdev events itself and
> avoids the detour via layer3 (X.25).
> 
> 1. Establish layer2 on NETDEV_UP events, if the carrier is already up.
> 
> 2. Call lapb_disconnect_request() on NETDEV_GOING_DOWN events to signal
>    the peer that the connection will go down.
>    (Only when the carrier is up.)
> 
> 3. When a NETDEV_DOWN event occur, clear all queues, enter state
>    LAPB_STATE_0 and stop all timers.
> 
> 4. The NETDEV_CHANGE event makes it possible to handle carrier loss and
>    detection.
> 
>    In case of Carrier Loss, clear all queues, enter state LAPB_STATE_0
>    and stop all timers.
> 
>    In case of Carrier Detection, we start timer t1 on a DCE interface,
>    and on a DTE interface we change to state LAPB_STATE_1 and start
>    sending SABM(E).
> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>

> +/* Handle device status changes. */
> +static int lapb_device_event(struct notifier_block *this, unsigned long event,
> +			     void *ptr)
> +{
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct lapb_cb *lapb;
> +
> +	if (!net_eq(dev_net(dev), &init_net))
> +		return NOTIFY_DONE;
> +
> +	if (dev->type == ARPHRD_X25) {

Flip condition, save indentation.

	if (dev->type != ARPHRD_X25)
		return NOTIFY_DONE;

You can also pull out of all the cases:

	lapb = lapb_devtostruct(dev);
	if (!lapb)
		return NOTIFY_DONE;

right?

> +		switch (event) {
> +		case NETDEV_UP:
> +			lapb_dbg(0, "(%p) Interface up: %s\n", dev,
> +				 dev->name);
> +
> +			if (netif_carrier_ok(dev)) {
> +				lapb = lapb_devtostruct(dev);
> +				if (!lapb)
> +					break;

>  static int __init lapb_init(void)
>  {
> +	register_netdevice_notifier(&lapb_dev_notifier);

This can fail, so:

	return register_netdevice_notifier(&lapb_dev_notifier);

>  	return 0;
>  }
>  
>  static void __exit lapb_exit(void)
>  {
>  	WARN_ON(!list_empty(&lapb_list));
> +
> +	unregister_netdevice_notifier(&lapb_dev_notifier);
>  }
>  
>  MODULE_AUTHOR("Jonathan Naylor <g4klx@g4klx.demon.co.uk>");

