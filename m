Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7A21310E
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 03:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgGCBsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 21:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgGCBr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 21:47:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 276AC20A8B;
        Fri,  3 Jul 2020 01:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593740879;
        bh=LDkRLQ5xEO9aZ+6739gpj69NY4R6YuBsiwYeEKh3x/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VIkoh2oJ3eARk4mGb8OIBwJIeqhEONX6JCk3kJXG/DnsMG5B0YPscJe9BJDOUlFSo
         Bp6EpRxKhQifGflI/iRc5zsJ+CZ8ULgQba2ZcBVLRRAkBA/JcifCcuIzQFBOf23eSI
         O53A3/6V3/IqIceS0Yk7Dl/qlsDA7xZvw3pNp1S0=
Date:   Thu, 2 Jul 2020 18:47:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ron Diskin <rondi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Message-ID: <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200702221923.650779-3-saeedm@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
        <20200702221923.650779-3-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Jul 2020 15:19:14 -0700 Saeed Mahameed wrote:
> From: Ron Diskin <rondi@mellanox.com>
> 
> Currently the FW does not generate events for counters other than error
> counters. Unlike ".get_ethtool_stats", ".ndo_get_stats64" (which ip -s
> uses) might run in atomic context, while the FW interface is non atomic.
> Thus, 'ip' is not allowed to issue fw commands, so it will only display
> cached counters in the driver.
> 
> Add a SW counter (mcast_packets) in the driver to count rx multicast
> packets. The counter also counts broadcast packets, as we consider it a
> special case of multicast.
> Use the counter value when calling "ip -s"/"ifconfig".  Display the new
> counter when calling "ethtool -S", and add a matching counter
> (mcast_bytes) for completeness.

What is the problem that is being solved here exactly?

Device counts mcast wrong / unsuitably?

> Fixes: f62b8bb8f2d3 ("net/mlx5: Extend mlx5_core to support ConnectX-4 Ethernet functionality")
> Signed-off-by: Ron Diskin <rondi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
