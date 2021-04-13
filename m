Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E0F35E6C7
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347913AbhDMTDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhDMTDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:03:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 785A2613C7;
        Tue, 13 Apr 2021 19:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618340606;
        bh=rLFd/xrh+tG4/zWboqcHD3m2GdGB/rmn4+tq21j9Vys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LTKxpgW+UWCnxj9hzje2M721QQ5P7aG2LK17i+IcHNdaTiYc54EAJoY/9mOeyxsTP
         BSleYznLnXp82DjbJgphYut4gbII1XflWxF7/xlGjM5v/YEvDJ/CknzOpA/8pA7wLa
         DpQIustPmsJGwU+EHsuaTvnZ3mPL6H84GdavAJiIKHMLJL+MVBXN4LjYjZwyeoXzZ1
         ZgnXVR95TXxBPO26ed3WldvI6TYe0JbT821PRLUCihScov7GDOpLuo7/TaZ6XbBuk8
         tDKnwSjSU3nKJlINNNd1KVQCtFQ8krlMTkF3baIwKbSaIOvHme8y9iU/nMWMOPa8sv
         7yCIbC0/GTKuQ==
Date:   Tue, 13 Apr 2021 12:03:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v5 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <20210413120324.18983187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210413023509.51952-1-decui@microsoft.com>
References: <20210413023509.51952-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Apr 2021 19:35:09 -0700 Dexuan Cui wrote:
> +	apc->port_st_save = apc->port_is_up;
> +	apc->port_is_up = false;
> +	apc->start_remove = true;
> +
> +	/* Ensure port state updated before txq state */
> +	smp_wmb();
> +
> +	netif_tx_disable(ndev);

In your napi poll method there is no barrier between port_is_up check
and netif_tx_queue_stopped().

> +	netif_carrier_off(ndev);
> +
> +	/* No packet can be transmitted now since apc->port_is_up is false.
> +	 * There is still a tiny chance that mana_poll_tx_cq() can re-enable
> +	 * a txq because it may not timely see apc->port_is_up being cleared
> +	 * to false, but it doesn't matter since mana_start_xmit() drops any
> +	 * new packets due to apc->port_is_up being false.
> +	 *
> +	 * Drain all the in-flight TX packets
> +	 */
> +	for (i = 0; i < apc->num_queues; i++) {
> +		txq = &apc->tx_qp[i].txq;
> +
> +		while (atomic_read(&txq->pending_sends) > 0)
> +			usleep_range(1000, 2000);
> +	}

> +		/* All cleanup actions should stay after rtnl_lock(), otherwise
> +		 * other functions may access partially cleaned up data.
> +		 */
> +		rtnl_lock();
> +
> +		mana_detach(ndev);
> +
> +		unregister_netdevice(ndev);
> +
> +		rtnl_unlock();

I find the resource management somewhat strange. Why is mana_attach()
and mana_detach() called at probe/remove time, and not when the
interface is brought up? Presumably when the user ifdowns the interface
there is no point holding the resources? Your open/close methods are
rather empty.

> +	if ((eq_addr & PAGE_MASK) != eq_addr)
> +		return -EINVAL;
> +
> +	if ((cq_addr & PAGE_MASK) != cq_addr)
> +		return -EINVAL;
> +
> +	if ((rq_addr & PAGE_MASK) != rq_addr)
> +		return -EINVAL;
> +
> +	if ((sq_addr & PAGE_MASK) != sq_addr)
> +		return -EINVAL;

PAGE_ALIGNED()
