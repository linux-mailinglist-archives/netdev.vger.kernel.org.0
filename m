Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD88A213EFF
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 19:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgGCR7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 13:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgGCR7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 13:59:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8F3521D81;
        Fri,  3 Jul 2020 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593799179;
        bh=Q0yffFINVenO2aiOZ8jpM4hvGZCkWIhfYKAZLSt10Rk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q1DX3U1WlPuvYFudx2YavGIHTBqp23Cljpl4u5L4MBn/3rENKHVPCU59rYCpzm3me
         JFPGJBmaCUekm35j2gHyi5JuFBeFDkm+1yOrvOqsB6QqGT4eqYtnwc11vjoPOMvrxv
         MMM2SETWiQjqjmQIiKcuqrW8hGAQhY3/mBL3uvtY=
Date:   Fri, 3 Jul 2020 10:59:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Ron Diskin <rondi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Message-ID: <20200703105938.2b7b0b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <763ba5f0a5ae07f4da736572f1a3e183420efcd0.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
        <20200702221923.650779-3-saeedm@mellanox.com>
        <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
        <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <763ba5f0a5ae07f4da736572f1a3e183420efcd0.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jul 2020 06:15:09 +0000 Saeed Mahameed wrote:
> > > To read mcast counter we need to execute FW command which is
> > > blocking,
> > > we can't block in atomic context .ndo_get_stats64 :( .. we have to
> > > count in SW. 
> > > 
> > > the previous approach wasn't accurate as we read the mcast counter
> > > in a
> > > background thread triggered by the previous read.. so we were off
> > > by
> > > the interval between two reads.  
> > 
> > And that's bad enough to cause trouble? What's the worst case time
> > delta you're seeing?
> 
> Depends on the user frequency to read stats,
> if you read stats once every 5 minutes then mcast stats are off by 5
> minutes..
> 
> Just thinking out loud, is it ok of we busy loop and wait for FW
> response for mcast stats commands ? 
> 
> In ethtool -S though, they are accurate since we grab them on the spot
> from FW.

I don't really feel too strongly, I'm just trying to get the details
because I feel like the situation is going to be increasingly common.
It'd be quite sad if drivers had to reimplement all stats in sw.

I thought it would be entirely reasonable for the driver to read the
stats from a delayed work every 1/2 HZ and cache that. We do have a
knob in ethtool IRQ coalescing settings for stats writeback frequency.

I'm not sure what locks procfs actually holds, if its something that
could impact reading other files - it'd probably be a bad idea to busy
wait.
