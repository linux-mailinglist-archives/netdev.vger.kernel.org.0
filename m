Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9940A3155C4
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhBISUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232925AbhBISRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 13:17:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E51864EB8;
        Tue,  9 Feb 2021 18:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612893905;
        bh=oQCLiNHBnEcLS2bCxoOXJLkhkuqoDwZUfXrCSbhEk2w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SNnuYkcwMfNwf0wmqn9kJ3Im09ehEHun9z/87AtHizSClU5R5kYRF8L9ZBvdb57OZ
         3bieqp5s6oVntaQ/jGr6DBlWpNxxAIvPYHmQM5aL8StfMO8hZNw905QF65tKsbgSXn
         vOZq+//sl4YOuMg8xfgI3v2FMN70wRob7wErRtWSeZxYv0xrhdbpLcZ98MAjwiHoB6
         e9SAuVKU3T/4GvSHvflP9cUvfyKqyLpBy9FFIVWea6RUr3QwzWmirUS3bfspih69/0
         9E9G94Yc3XcQ4j56GZ4y8QesF/U1XEQT3jj4WRZy9NEM0rVmi5Af+jb48u6Ca3GVqQ
         mvSTkZJVzsMXw==
Date:   Tue, 9 Feb 2021 10:05:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
Message-ID: <20210209100504.119925c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ygnho8gtgw2l.fsf@nvidia.com>
References: <20210206050240.48410-1-saeed@kernel.org>
        <20210206050240.48410-2-saeed@kernel.org>
        <20210206181335.GA2959@horizon.localdomain>
        <ygnhtuqngebi.fsf@nvidia.com>
        <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ygnho8gtgw2l.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 16:22:26 +0200 Vlad Buslov wrote:
> No, tunnel IP is configured on VF. That particular VF is in host
> namespace. When mlx5 resolves tunneling the code checks if tunnel
> endpoint IP address is on such mlx5 VF, since the VF is in same
> namespace as eswitch manager (e.g. on host) and route returned by
> ip_route_output_key() is resolved through rt->dst.dev==tunVF device.
> After establishing that tunnel is on VF the goal is to process two
> resulting TC rules (in both directions) fully in hardware without
> exposing the packet on tunneling device or tunnel VF in sw, which is
> implemented with all the infrastructure from this series.
> 
> So, to summarize with IP addresses from TC examples presented in cover letter,
> we have underlay network 7.7.7.0/24 in host namespace with tunnel endpoint IP
> address on VF:
> 
> $ ip a show dev enp8s0f0v0
> 1537: enp8s0f0v0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
>     link/ether 52:e5:6d:f2:00:69 brd ff:ff:ff:ff:ff:ff
>     altname enp8s0f0np0v0
>     inet 7.7.7.5/24 scope global enp8s0f0v0
>        valid_lft forever preferred_lft forever
>     inet6 fe80::50e5:6dff:fef2:69/64 scope link
>        valid_lft forever preferred_lft forever

Isn't this 100% the wrong way around. Disable the offloads. Does the
traffic hit the VF encapsulated?

IIUC SW will do this:

        PHY port
           |
device     |             ,-----.
-----------|------------|-------|----------
kernel     |            |       |
        (UL/PF)       (VFr)    (VF)
           |            |       |
        [TC ing]>redir -`       V

And the packet never hits encap.

