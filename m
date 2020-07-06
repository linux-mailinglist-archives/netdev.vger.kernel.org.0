Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76691215FB9
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgGFT5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGFT5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 15:57:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4184207D0;
        Mon,  6 Jul 2020 19:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594065426;
        bh=UxbI3RmiRb+JPvnze1GA/X1dpvd0LwjpxPUQjqWKZWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VZMYdcxb0RZz/mNdYSyTachrtDWOFLKAQFmZJJUAqo8axXBQtQLi8uQ2YJSD/hh5W
         AfuxNBeuMlPTHY9MihZvBb77y/jPtp1T4Tbi0jMJWYWqQVdspMm2l1paI54uqVOOfP
         zsO+YHEX/WwTfFMWmP/eljKE/3VxXqxFVE2eyagY=
Date:   Mon, 6 Jul 2020 12:57:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Ron Diskin <rondi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Message-ID: <20200706125704.465b3a0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a8ef2aece592d352dd6bd978db2d430ce55826ed.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
        <20200702221923.650779-3-saeedm@mellanox.com>
        <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
        <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <763ba5f0a5ae07f4da736572f1a3e183420efcd0.camel@mellanox.com>
        <20200703105938.2b7b0b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a8ef2aece592d352dd6bd978db2d430ce55826ed.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jul 2020 19:40:50 +0000 Saeed Mahameed wrote:
> > I don't really feel too strongly, I'm just trying to get the details
> > because I feel like the situation is going to be increasingly common.
> > It'd be quite sad if drivers had to reimplement all stats in sw.
> 
> Depends on HW, our HW/FW supports providing stats per (Vport/function).
> which means if a packet got lost between the NIC and the netdev queue,
> it will be counted as rx-packet/mcast, although we have a private
> counter to show this drop in ethtool but will be counted in rx counter
> in netdev stats, if we used hw stats.
> 
> so this is why i always prefer SW stats for netdev reported stats, all
> we need to count in SW {rx,tx} X {packets, bytes} + rx mcast packets.

If that was indeed the intention it'd had been done in the core, not
each driver separately..

> This gives more flexibility and correctness, any given HW can create
> multiple netdevs on the same function, we need the netdev stats to
> reflect traffic that only went through that netdev.
> 
> > I thought it would be entirely reasonable for the driver to read the
> > stats from a delayed work every 1/2 HZ and cache that. We do have a
> > knob in ethtool IRQ coalescing settings for stats writeback
> > frequency.
> 
> Some customers didn't like this since for drivers that implement this
> their CPU power utilization will be slightly higher on idle.

Other customers may dislike the per packet cycles.

I don't really mind, I just found the commit message to be lacking 
for a fix, which this supposedly is.

Also looks like you report the total number of mcast packets in ethtool
-S, which should be identical to ip -s? If so please remove that.
