Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25FD221894
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 01:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGOXol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 19:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgGOXol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 19:44:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD538206F5;
        Wed, 15 Jul 2020 23:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594856681;
        bh=aiOjHe9OYjb+HZdjf3d0YPKLyfMFW1HpEIAJtJ+butQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LLw4MPI/9a0Nr1+2I7WBJJUJ80Y7VZ0Keia83RpuM1Z6k/bqBjPQ9+xm3D9AGSvsn
         RK1Gp4PQ20gCqpa9SX6LAoPcZt63wIpjTX8kbHtHTPtfwE/MbOYIJiL6t2H83lOX+Y
         RjmXVrnSYha1IfpvTybPblehlQYo0uTVqlbVyoPQ=
Date:   Wed, 15 Jul 2020 16:44:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v2 net-next 02/10] net: atlantic: additional per-queue
 stats
Message-ID: <20200715164438.7cedb552@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715154842.305-3-irusskikh@marvell.com>
References: <20200715154842.305-1-irusskikh@marvell.com>
        <20200715154842.305-3-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 18:48:34 +0300 Igor Russkikh wrote:
> +int aq_nic_fill_stats_data(struct aq_ring_stats_rx_s *stats_rx,
> +			   struct aq_ring_stats_tx_s *stats_tx,
> +			   u64 *data,
> +			   unsigned int *p_count)
> +{
> +	unsigned int count = 0U;
> +	/* This data should mimic aq_ethtool_queue_stat_names structure
> +	 */
> +	data[count] += stats_rx->packets;
> +	data[++count] += stats_tx->packets;
> +	data[++count] += stats_tx->queue_restarts;
> +	data[++count] += stats_rx->jumbo_packets;
> +	data[++count] += stats_rx->lro_packets;
> +	data[++count] += stats_rx->errors;
> +	data[++count] += stats_rx->alloc_fails;
> +	data[++count] += stats_rx->skb_alloc_fails;
> +	data[++count] += stats_rx->polls;
> +
> +	if (p_count)
> +		*p_count = ++count;
> +
> +	return 0;
> +}

I don't see this function being taken care of in the following patch
introducing the u64_stats_update_* use.

For review it'd be easier to get the existing problems fixed first.

Also since this function always returns 0 please make it void.
